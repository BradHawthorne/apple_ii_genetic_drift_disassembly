#!/usr/bin/env python3
"""extract_sound.py -- Extract and convert Apple II sound data to WAV/text.

Supports multiple Apple II sound data formats:
  - 2-byte record format: (note_value, duration) pairs, 00 00 = end
  - Raw frequency table format: sequential timer reload values
  - Speaker-toggle threshold format: LFSR-based noise parameters

The note_value in most Apple II sound routines is a timer reload value for
a speaker toggle loop. Higher values = lower frequency (longer period).

    frequency = CPU_CLOCK / (2 * CYCLES_PER_ITER * note_value)

where CPU_CLOCK = 1023000 Hz (Apple II 1 MHz) and CYCLES_PER_ITER depends
on the specific playback routine (typically 10-30 cycles).

Usage:
    # Decode and render Aliens music file to WAV
    python extract_sound.py ALIENS.MUS#064100 -o aliens_music.wav

    # Just dump the note data as text
    python extract_sound.py ALIENS.MUS#064100 --text

    # Specify playback parameters
    python extract_sound.py ALIENS.MUS#064100 -o out.wav --cycles 20 --tempo 120

    # Extract from a specific offset in a binary
    python extract_sound.py GAME.BIN --offset 0x4C54 --count 32 --format raw

    # Generate analysis report
    python extract_sound.py ALIENS.MUS#064100 --analyze
"""

import argparse
import math
import os
import struct
import sys

# Apple II constants
CPU_CLOCK = 1023000  # ~1.023 MHz

# WAV output parameters
WAV_SAMPLE_RATE = 22050
WAV_AMPLITUDE = 24000  # 16-bit signed amplitude for square wave


def parse_int(s):
    """Parse integer from hex ($xx, 0xNN) or decimal string."""
    s = s.strip()
    if s.startswith('$'):
        return int(s[1:], 16)
    elif s.startswith('0x') or s.startswith('0X'):
        return int(s, 16)
    else:
        return int(s)


# ── Record Parsers ──────────────────────────────────────────────────────

def parse_2byte_records(data, offset=0):
    """Parse 2-byte (note, duration) records. Returns list of (note, dur).
    note=0 is a rest. Terminates at (0,0) or end of data."""
    records = []
    pos = offset
    while pos + 1 < len(data):
        note = data[pos]
        dur = data[pos + 1]
        if note == 0 and dur == 0:
            break
        records.append((note, dur))
        pos += 2
    return records


def parse_raw_table(data, offset=0, count=None):
    """Parse raw frequency values as single-byte entries."""
    if count is None:
        count = len(data) - offset
    records = []
    for i in range(count):
        if offset + i >= len(data):
            break
        val = data[offset + i]
        if val == 0:
            records.append((0, 1))  # rest
        else:
            records.append((val, 1))  # each entry = 1 tick
    return records


# ── Frequency Conversion ───────────────────────────────────────────────

def note_to_freq(note_value, cycles_per_iter=20):
    """Convert Apple II timer reload value to frequency in Hz.

    The speaker toggle loop executes note_value iterations, each taking
    cycles_per_iter CPU cycles. One full wave = 2 half-cycles (toggle on,
    toggle off), so:

        freq = CPU_CLOCK / (2 * cycles_per_iter * note_value)
    """
    if note_value == 0:
        return 0.0  # rest
    return CPU_CLOCK / (2.0 * cycles_per_iter * note_value)


def freq_to_midi_note(freq):
    """Convert frequency to nearest MIDI note number."""
    if freq <= 0:
        return None
    return 69 + 12 * math.log2(freq / 440.0)


MIDI_NOTE_NAMES = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']


def midi_to_name(midi_note):
    """Convert MIDI note number to name like 'C4', 'A#5'."""
    if midi_note is None:
        return '---'
    note_num = round(midi_note)
    octave = (note_num // 12) - 1
    name = MIDI_NOTE_NAMES[note_num % 12]
    cents = round((midi_note - note_num) * 100)
    if abs(cents) > 5:
        return f'{name}{octave}{cents:+d}c'
    return f'{name}{octave}'


# ── WAV Generation ─────────────────────────────────────────────────────

def generate_square_wave(freq, duration_secs, sample_rate=WAV_SAMPLE_RATE,
                         amplitude=WAV_AMPLITUDE):
    """Generate square wave samples for a given frequency and duration."""
    num_samples = int(duration_secs * sample_rate)
    if freq <= 0 or num_samples == 0:
        return [0] * max(1, num_samples)

    samples = []
    half_period = sample_rate / (2.0 * freq)
    for i in range(num_samples):
        # Square wave: alternate between +amplitude and -amplitude
        phase = (i % int(2 * half_period)) / half_period if half_period > 0 else 0
        val = amplitude if phase < 1.0 else -amplitude
        samples.append(int(val))
    return samples


def write_wav(filename, samples, sample_rate=WAV_SAMPLE_RATE):
    """Write 16-bit mono WAV file."""
    num_samples = len(samples)
    data_size = num_samples * 2  # 16-bit = 2 bytes per sample
    file_size = 36 + data_size

    with open(filename, 'wb') as f:
        # RIFF header
        f.write(b'RIFF')
        f.write(struct.pack('<I', file_size))
        f.write(b'WAVE')
        # fmt chunk
        f.write(b'fmt ')
        f.write(struct.pack('<I', 16))       # chunk size
        f.write(struct.pack('<H', 1))        # PCM format
        f.write(struct.pack('<H', 1))        # mono
        f.write(struct.pack('<I', sample_rate))
        f.write(struct.pack('<I', sample_rate * 2))  # byte rate
        f.write(struct.pack('<H', 2))        # block align
        f.write(struct.pack('<H', 16))       # bits per sample
        # data chunk
        f.write(b'data')
        f.write(struct.pack('<I', data_size))
        for s in samples:
            s = max(-32768, min(32767, s))
            f.write(struct.pack('<h', s))


def records_to_wav(records, filename, cycles_per_iter=20, tick_ms=50,
                   sample_rate=WAV_SAMPLE_RATE):
    """Convert note records to WAV file.

    tick_ms: duration of one tick unit in milliseconds
    """
    all_samples = []

    for note, dur in records:
        freq = note_to_freq(note, cycles_per_iter)
        duration_secs = (dur * tick_ms) / 1000.0
        samples = generate_square_wave(freq, duration_secs, sample_rate)
        all_samples.extend(samples)

    if not all_samples:
        print("Warning: no audio data generated")
        return

    write_wav(filename, all_samples, sample_rate)
    total_secs = len(all_samples) / sample_rate
    print(f"Wrote {filename}: {total_secs:.1f}s, {len(all_samples)} samples, "
          f"{sample_rate} Hz mono 16-bit")


# ── Text Output ────────────────────────────────────────────────────────

def records_to_text(records, cycles_per_iter=20, tick_ms=50):
    """Generate text representation of sound data."""
    lines = []
    lines.append(f"{'#':>4s}  {'Hex':>4s}  {'Note':>4s}  {'Dur':>3s}  "
                 f"{'Freq':>8s}  {'Name':>6s}  {'ms':>6s}  Visualization")
    lines.append("-" * 72)

    total_ms = 0
    for i, (note, dur) in enumerate(records):
        freq = note_to_freq(note, cycles_per_iter)
        midi = freq_to_midi_note(freq)
        name = midi_to_name(midi)
        ms = dur * tick_ms

        if note == 0:
            bar = '.' * min(dur * 2, 40)
            lines.append(f"{i:4d}  {'--':>4s}  {'rest':>4s}  {dur:3d}  "
                         f"{'---':>8s}  {'---':>6s}  {ms:6.0f}  {bar}")
        else:
            bar = '#' * min(dur * 2, 40)
            # Scale bar height by note value for a crude pitch visualization
            indent = max(0, min(30, note // 2))
            lines.append(f"{i:4d}  ${note:02X}  {note:4d}  {dur:3d}  "
                         f"{freq:8.1f}  {name:>6s}  {ms:6.0f}  "
                         f"{' ' * indent}{bar}")
        total_ms += ms

    lines.append("")
    lines.append(f"Total duration: {total_ms/1000:.1f}s ({len(records)} records)")
    return '\n'.join(lines)


# ── Analysis ───────────────────────────────────────────────────────────

def analyze_records(records, cycles_per_iter=20, tick_ms=50):
    """Generate analysis report for sound data."""
    lines = []
    lines.append("=" * 60)
    lines.append("SOUND DATA ANALYSIS REPORT")
    lines.append("=" * 60)
    lines.append("")

    # Basic stats
    notes = [(n, d) for n, d in records if n != 0]
    rests = [(n, d) for n, d in records if n == 0]
    lines.append(f"Total records: {len(records)}")
    lines.append(f"Active notes:  {len(notes)}")
    lines.append(f"Rests:         {len(rests)}")
    lines.append("")

    # Duration stats
    total_ticks = sum(d for _, d in records)
    total_ms = total_ticks * tick_ms
    lines.append(f"Total ticks:    {total_ticks}")
    lines.append(f"Total duration: {total_ms/1000:.1f}s (at {tick_ms}ms/tick)")
    lines.append("")

    # Note frequency distribution
    lines.append("--- Note Value Distribution ---")
    lines.append(f"{'Value':>6s}  {'Hex':>4s}  {'Count':>5s}  {'Freq Hz':>8s}  "
                 f"{'Name':>6s}  Histogram")
    note_vals = sorted(set(n for n, d in notes))
    for nv in note_vals:
        count = sum(1 for n, d in notes if n == nv)
        freq = note_to_freq(nv, cycles_per_iter)
        midi = freq_to_midi_note(freq)
        name = midi_to_name(midi)
        bar = '*' * min(count, 40)
        lines.append(f"{nv:6d}  ${nv:02X}  {count:5d}  {freq:8.1f}  "
                     f"{name:>6s}  {bar}")
    lines.append("")

    # Duration distribution
    lines.append("--- Duration Distribution ---")
    dur_vals = sorted(set(d for _, d in records))
    for dv in dur_vals:
        count = sum(1 for _, d in records if d == dv)
        ms = dv * tick_ms
        bar = '*' * min(count, 40)
        lines.append(f"  dur={dv:3d} ({ms:5.0f}ms): {count:4d} {bar}")
    lines.append("")

    # Phrase analysis (group notes ignoring rests)
    lines.append("--- Phrase Structure ---")
    phrase_notes = []
    phrase_num = 0
    for n, d in records:
        if n == 0:
            continue
        phrase_notes.append(n)
        if len(phrase_notes) == 8:
            hexstr = ' '.join(f'{x:02X}' for x in phrase_notes)
            names = ' '.join(f'{midi_to_name(freq_to_midi_note(note_to_freq(x, cycles_per_iter))):>4s}'
                             for x in phrase_notes)
            lines.append(f"  Phrase {phrase_num:2d}: {hexstr}  ({names})")
            phrase_notes = []
            phrase_num += 1
    if phrase_notes:
        hexstr = ' '.join(f'{x:02X}' for x in phrase_notes)
        lines.append(f"  Phrase {phrase_num:2d}: {hexstr}  (partial)")
    lines.append("")

    # Frequency range
    freqs = [note_to_freq(n, cycles_per_iter) for n in note_vals]
    lines.append("--- Frequency Range ---")
    lines.append(f"  Lowest:  ${note_vals[-1]:02X} = {freqs[-1]:.1f} Hz "
                 f"({midi_to_name(freq_to_midi_note(freqs[-1]))})")
    lines.append(f"  Highest: ${note_vals[0]:02X} = {freqs[0]:.1f} Hz "
                 f"({midi_to_name(freq_to_midi_note(freqs[0]))})")
    lines.append(f"  Range:   {freqs[0]/freqs[-1]:.1f}x "
                 f"({12*math.log2(freqs[0]/freqs[-1]):.1f} semitones)")
    lines.append("")

    return '\n'.join(lines)


# ── Main ───────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description='Extract and convert Apple II sound data',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s ALIENS.MUS#064100 -o music.wav
  %(prog)s ALIENS.MUS#064100 --text
  %(prog)s ALIENS.MUS#064100 --analyze
  %(prog)s GAME.BIN --offset $4C54 --count 32 --format raw -o sfx.wav
        """)

    parser.add_argument('input', help='Input binary file')
    parser.add_argument('-o', '--output', help='Output WAV file')
    parser.add_argument('--text', action='store_true',
                        help='Output text representation')
    parser.add_argument('--analyze', action='store_true',
                        help='Output analysis report')
    parser.add_argument('--format', choices=['2byte', 'raw'], default='2byte',
                        help='Input data format (default: 2byte)')
    parser.add_argument('--offset', type=parse_int, default=0,
                        help='Start offset in input file (hex: $xx or 0xNN)')
    parser.add_argument('--count', type=parse_int, default=None,
                        help='Number of entries to read (raw format only)')
    parser.add_argument('--cycles', type=int, default=20,
                        help='CPU cycles per loop iteration (default: 20)')
    parser.add_argument('--tick-ms', type=float, default=50,
                        help='Duration of one tick in ms (default: 50)')
    parser.add_argument('--sample-rate', type=int, default=WAV_SAMPLE_RATE,
                        help=f'WAV sample rate (default: {WAV_SAMPLE_RATE})')

    args = parser.parse_args()

    # Read input
    if not os.path.exists(args.input):
        print(f"Error: file not found: {args.input}", file=sys.stderr)
        sys.exit(1)

    with open(args.input, 'rb') as f:
        data = f.read()

    print(f"Read {len(data)} bytes from {args.input}")

    # Parse records
    if args.format == '2byte':
        records = parse_2byte_records(data, args.offset)
    elif args.format == 'raw':
        records = parse_raw_table(data, args.offset, args.count)
    else:
        print(f"Unknown format: {args.format}", file=sys.stderr)
        sys.exit(1)

    if not records:
        print("No sound data found!", file=sys.stderr)
        sys.exit(1)

    notes_only = [r for r in records if r[0] != 0]
    print(f"Parsed {len(records)} records ({len(notes_only)} notes, "
          f"{len(records)-len(notes_only)} rests)")
    print(f"Playback params: {args.cycles} cycles/iter, {args.tick_ms}ms/tick")

    # Output
    if args.analyze:
        report = analyze_records(records, args.cycles, args.tick_ms)
        print()
        print(report)

        # Also write to file if output specified
        if args.output:
            report_path = args.output.rsplit('.', 1)[0] + '_analysis.txt'
            with open(report_path, 'w') as f:
                f.write(report)
            print(f"Analysis written to {report_path}")

    if args.text:
        text = records_to_text(records, args.cycles, args.tick_ms)
        print()
        print(text)

    if args.output and args.output.lower().endswith('.wav'):
        records_to_wav(records, args.output, args.cycles, args.tick_ms,
                       args.sample_rate)

    # Default: if no output mode specified, show brief summary
    if not args.output and not args.text and not args.analyze:
        print()
        print("Use --text for note listing, --analyze for report, "
              "-o file.wav for audio")
        print()
        # Show first 20 notes as a preview
        text = records_to_text(records[:40], args.cycles, args.tick_ms)
        print(text)


if __name__ == '__main__':
    main()

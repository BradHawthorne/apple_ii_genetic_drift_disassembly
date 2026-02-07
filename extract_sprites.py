#!/usr/bin/env python3
"""
Apple II HGR Sprite Extractor
Extracts and renders Apple II hi-res graphics sprites from binary files as PNG images.

Supports three extraction modes:
  1. Manual: fixed offset, width, height, count
  2. Table-driven: pointer/width/height tables (common Apple II sprite format)
  3. Auto-detect: scan for parallel pointer table pairs

HGR color encoding:
  - Each byte = 7 pixels (bits 0-6), bit 7 = palette selector
  - Palette 0 (bit7=0): purple/green    Palette 1 (bit7=1): blue/orange
  - Adjacent set bits -> white; isolated set bits -> color by column parity

Cowritten by Claude Code Opus 4.6
"""

import argparse
import struct
import sys
import zlib
from pathlib import Path

# ---------------------------------------------------------------------------
# Apple II HGR color palette (classic NTSC artifact colors)
# ---------------------------------------------------------------------------

COLORS = {
    'black':  (0, 0, 0),
    'purple': (255, 68, 253),
    'green':  (20, 245, 60),
    'blue':   (20, 207, 253),
    'orange': (255, 106, 60),
    'white':  (255, 255, 255),
}

# ---------------------------------------------------------------------------
# Minimal PNG writer (stdlib only, no Pillow required)
# ---------------------------------------------------------------------------

def _png_chunk(chunk_type, data):
    """Build a PNG chunk: length + type + data + CRC."""
    chunk = chunk_type + data
    return struct.pack('>I', len(data)) + chunk + struct.pack('>I', zlib.crc32(chunk) & 0xFFFFFFFF)


def write_png(filepath, pixels, width, height):
    """
    Write an RGB PNG file from a flat pixel list.

    pixels: list of (r, g, b) tuples, length = width * height, row-major order.
    """
    # Try Pillow first for better compression / broader format support
    try:
        from PIL import Image
        img = Image.new('RGB', (width, height))
        img.putdata(pixels)
        img.save(filepath)
        return
    except ImportError:
        pass

    # Fallback: minimal PNG using stdlib zlib + struct
    raw_rows = bytearray()
    for y in range(height):
        raw_rows.append(0)  # filter byte: None
        for x in range(width):
            r, g, b = pixels[y * width + x]
            raw_rows.append(r)
            raw_rows.append(g)
            raw_rows.append(b)

    compressed = zlib.compress(bytes(raw_rows))

    with open(filepath, 'wb') as f:
        # PNG signature
        f.write(b'\x89PNG\r\n\x1a\n')
        # IHDR: width, height, bit_depth=8, color_type=2 (RGB)
        ihdr_data = struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0)
        f.write(_png_chunk(b'IHDR', ihdr_data))
        # IDAT
        f.write(_png_chunk(b'IDAT', compressed))
        # IEND
        f.write(_png_chunk(b'IEND', b''))


# ---------------------------------------------------------------------------
# HGR pixel rendering
# ---------------------------------------------------------------------------

def render_hgr_row(row_bytes):
    """
    Render one row of HGR sprite data to a list of (r,g,b) pixel tuples.

    Each byte encodes 7 pixels (bits 0-6).  Bit 7 selects the color palette.
    The pixel column index is absolute across the row (byte_index * 7 + bit).

    Adjacency rules:
      - A bit that is 0 -> black.
      - A bit that is 1 with an adjacent 1 (left or right, including across
        byte boundaries within the row) -> white.
      - A bit that is 1 and isolated -> color determined by palette and
        whether the absolute column is even or odd.
    """
    # First, decode every bit into a flat list and record per-pixel palette
    num_bytes = len(row_bytes)
    num_pixels = num_bytes * 7
    bits = [0] * num_pixels
    palettes = [0] * num_pixels

    for byte_idx in range(num_bytes):
        byte_val = row_bytes[byte_idx]
        palette = (byte_val >> 7) & 1
        for bit in range(7):
            col = byte_idx * 7 + bit
            bits[col] = (byte_val >> bit) & 1
            palettes[col] = palette

    # Now determine colors with adjacency logic
    pixels = []
    for col in range(num_pixels):
        if bits[col] == 0:
            pixels.append(COLORS['black'])
            continue

        # Check adjacency (left and right neighbors)
        left_set = (col > 0 and bits[col - 1] == 1)
        right_set = (col < num_pixels - 1 and bits[col + 1] == 1)

        if left_set or right_set:
            pixels.append(COLORS['white'])
        else:
            # Isolated bit: color depends on palette and column parity
            pal = palettes[col]
            if pal == 0:
                # Palette 0: even column = purple, odd column = green
                pixels.append(COLORS['purple'] if col % 2 == 0 else COLORS['green'])
            else:
                # Palette 1: even column = blue, odd column = orange
                pixels.append(COLORS['blue'] if col % 2 == 0 else COLORS['orange'])

    return pixels


def render_sprite(data, width_bytes, height):
    """
    Render a complete sprite (width_bytes * height bytes of HGR data).
    Returns (pixel_list, pixel_width, pixel_height).
    """
    pixel_width = width_bytes * 7
    all_pixels = []
    for row in range(height):
        offset = row * width_bytes
        row_data = data[offset:offset + width_bytes]
        if len(row_data) < width_bytes:
            # Pad short rows with zeros (black)
            row_data = row_data + bytes(width_bytes - len(row_data))
        all_pixels.extend(render_hgr_row(row_data))
    return all_pixels, pixel_width, height


def scale_pixels(pixels, width, height, scale):
    """Scale pixel data by an integer factor (nearest-neighbor)."""
    if scale <= 1:
        return pixels, width, height
    new_width = width * scale
    new_height = height * scale
    scaled = []
    for y in range(new_height):
        src_y = y // scale
        for x in range(new_width):
            src_x = x // scale
            scaled.append(pixels[src_y * width + src_x])
    return scaled, new_width, new_height


# ---------------------------------------------------------------------------
# ASCII art preview
# ---------------------------------------------------------------------------

# Map colors to single characters for terminal display
_ASCII_MAP = {
    COLORS['black']:  ' ',
    COLORS['white']:  '#',
    COLORS['purple']: 'P',
    COLORS['green']:  'G',
    COLORS['blue']:   'B',
    COLORS['orange']: 'O',
}


def ascii_preview(pixels, width, height):
    """Return an ASCII art string for a sprite."""
    lines = []
    for y in range(height):
        row_chars = []
        for x in range(width):
            px = pixels[y * width + x]
            row_chars.append(_ASCII_MAP.get(px, '?'))
        lines.append(''.join(row_chars))
    return '\n'.join(lines)


# ---------------------------------------------------------------------------
# Sprite sheet assembly
# ---------------------------------------------------------------------------

def build_sprite_sheet(sprite_list, padding=2):
    """
    Combine a list of (pixels, width, height) into a single sprite sheet image.
    Sprites are arranged in a horizontal row with padding between them.
    Returns (pixels, total_width, total_height).
    """
    if not sprite_list:
        return [], 0, 0

    max_height = max(h for _, _, h in sprite_list)
    total_width = sum(w for _, w, _ in sprite_list) + padding * (len(sprite_list) - 1)

    # Fill with black
    sheet = [COLORS['black']] * (total_width * max_height)

    x_offset = 0
    for pixels, w, h in sprite_list:
        for y in range(h):
            for x in range(w):
                sheet[y * total_width + x_offset + x] = pixels[y * w + x]
        x_offset += w + padding

    return sheet, total_width, max_height


# ---------------------------------------------------------------------------
# Extraction modes
# ---------------------------------------------------------------------------

def extract_manual(data, offset, width_bytes, height, count):
    """Extract sprites sequentially from a fixed offset."""
    sprites = []
    sprite_size = width_bytes * height
    for i in range(count):
        start = offset + i * sprite_size
        end = start + sprite_size
        if end > len(data):
            print("Warning: sprite %d extends past end of file, truncating" % i, file=sys.stderr)
            sprite_data = data[start:] + bytes(end - len(data))
        else:
            sprite_data = data[start:end]
        sprites.append((sprite_data, width_bytes, height))
    return sprites


def extract_table_driven(data, ptr_lo_offset, ptr_hi_offset, width_tbl_offset,
                         height_tbl_offset, count, base_addr):
    """
    Extract sprites using pointer/width/height tables.

    Table format (common Apple II pattern):
      ptr_lo[count]   - low bytes of sprite data addresses
      ptr_hi[count]   - high bytes of sprite data addresses
      width_tbl[count] - width in bytes per sprite
      height_tbl[count] - height in scan lines per sprite
    """
    sprites = []
    for i in range(count):
        if ptr_lo_offset + i >= len(data):
            print("Warning: pointer table overrun at sprite %d" % i, file=sys.stderr)
            break
        if ptr_hi_offset + i >= len(data):
            print("Warning: pointer table overrun at sprite %d" % i, file=sys.stderr)
            break

        lo = data[ptr_lo_offset + i]
        hi = data[ptr_hi_offset + i]
        addr = lo | (hi << 8)
        file_offset = addr - base_addr

        w = data[width_tbl_offset + i] if width_tbl_offset + i < len(data) else 1
        h = data[height_tbl_offset + i] if height_tbl_offset + i < len(data) else 1

        if w == 0 or h == 0:
            print("Warning: sprite %d has zero dimension (w=%d h=%d), skipping" % (i, w, h),
                  file=sys.stderr)
            continue

        sprite_size = w * h
        if file_offset < 0 or file_offset >= len(data):
            print("Warning: sprite %d address $%04X (offset %d) outside file, skipping"
                  % (i, addr, file_offset), file=sys.stderr)
            continue

        end = file_offset + sprite_size
        if end > len(data):
            sprite_data = data[file_offset:] + bytes(end - len(data))
        else:
            sprite_data = data[file_offset:end]

        sprites.append((sprite_data, w, h))
        print("  Sprite %2d: addr=$%04X  offset=$%04X  %d x %d bytes (%d x %d px)"
              % (i, addr, file_offset, w, h, w * 7, h))

    return sprites


def auto_detect_sprites(data, base_addr, min_count=4, max_count=128):
    """
    Scan for potential sprite table pairs in the binary.

    Heuristic: look for two regions of `count` bytes each where:
      - Combining low[i] | (high[i] << 8) yields addresses that all point
        within the binary's address range [base_addr, base_addr + len(data)).
      - The addresses are roughly in the same neighborhood.

    Returns a list of candidate table descriptions.
    """
    file_size = len(data)
    addr_hi = base_addr + file_size
    candidates = []

    # Scan every byte offset as a potential ptr_lo table start
    for lo_start in range(0, file_size - min_count):
        # Try the matching hi table at several common relative positions:
        # immediately after (lo_start + count), or at a fixed stride
        for count in range(min_count, min(max_count + 1, file_size - lo_start)):
            hi_start = lo_start + count  # hi table right after lo table
            if hi_start + count > file_size:
                break

            valid = True
            addrs = []
            for i in range(count):
                lo = data[lo_start + i]
                hi = data[hi_start + i]
                addr = lo | (hi << 8)
                if addr < base_addr or addr >= addr_hi:
                    valid = False
                    break
                addrs.append(addr)

            if not valid:
                continue

            # Check that addresses are reasonably spread (not all identical)
            unique_addrs = set(addrs)
            if len(unique_addrs) < max(2, count // 2):
                continue

            # Check that addresses are monotonically non-decreasing (common pattern)
            monotonic = all(addrs[j] <= addrs[j + 1] for j in range(len(addrs) - 1))

            # Only report candidates with enough sprites and some spread
            addr_range = max(addrs) - min(addrs)
            if addr_range < count * 2:
                continue

            candidates.append({
                'ptr_lo': lo_start,
                'ptr_hi': hi_start,
                'count': count,
                'addr_min': min(addrs),
                'addr_max': max(addrs),
                'monotonic': monotonic,
            })

            # Don't report sub-ranges of the same table
            break

        # Limit output
        if len(candidates) >= 20:
            break

    return candidates


# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

def parse_int(s):
    """Parse an integer from decimal or hex (0x...) string."""
    s = s.strip()
    if s.startswith('0x') or s.startswith('0X') or s.startswith('$'):
        return int(s.replace('$', '0x'), 16)
    return int(s)


def build_parser():
    p = argparse.ArgumentParser(
        description='Extract and render Apple II HGR sprites from binary files.',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""\
examples:
  Manual extraction:
    %(prog)s game.bin --offset 0x2070 --width 4 --height 8 --count 7

  Table-driven extraction:
    %(prog)s game.bin --ptr-lo 0x1D7C --ptr-hi 0x1E1D \\
            --width-tbl 0x1EBE --height-tbl 0x1F5F --count 20 --base 0x4000

  Auto-detect mode:
    %(prog)s game.bin --auto --base 0x4000
""")

    p.add_argument('binary', help='Path to the Apple II binary file')

    # Mode selection
    mode = p.add_argument_group('extraction mode (pick one)')
    mode.add_argument('--auto', action='store_true',
                      help='Auto-detect potential sprite tables')

    # Manual mode options
    manual = p.add_argument_group('manual extraction')
    manual.add_argument('--offset', type=parse_int, default=None,
                        help='Starting offset of sprite data (hex or decimal)')
    manual.add_argument('--width', type=parse_int, default=None,
                        help='Sprite width in bytes (pixels = bytes * 7)')
    manual.add_argument('--height', type=parse_int, default=None,
                        help='Sprite height in scan lines')
    manual.add_argument('--count', type=parse_int, default=1,
                        help='Number of sprites to extract (default: 1)')

    # Table-driven options
    tbl = p.add_argument_group('table-driven extraction')
    tbl.add_argument('--ptr-lo', type=parse_int, default=None,
                     help='Offset of pointer low-byte table')
    tbl.add_argument('--ptr-hi', type=parse_int, default=None,
                     help='Offset of pointer high-byte table')
    tbl.add_argument('--width-tbl', type=parse_int, default=None,
                     help='Offset of width table (bytes per sprite)')
    tbl.add_argument('--height-tbl', type=parse_int, default=None,
                     help='Offset of height table (lines per sprite)')

    # Common options
    common = p.add_argument_group('common options')
    common.add_argument('--base', type=parse_int, default=0,
                        help='Load address / base address of the binary (default: 0)')
    common.add_argument('--scale', type=int, default=4,
                        help='Scale factor for output PNGs (default: 4)')
    common.add_argument('--sheet', action='store_true',
                        help='Also generate a combined sprite sheet PNG')
    common.add_argument('--ascii', action='store_true',
                        help='Print ASCII art preview to terminal')
    common.add_argument('--output-dir', type=str, default='.',
                        help='Output directory for PNG files (default: current dir)')

    return p


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    parser = build_parser()
    args = parser.parse_args()

    # Load binary
    binary_path = Path(args.binary)
    if not binary_path.is_file():
        print("Error: file not found: %s" % binary_path, file=sys.stderr)
        sys.exit(1)

    with open(binary_path, 'rb') as f:
        data = f.read()

    print("Loaded %s: %d bytes ($%04X)" % (binary_path.name, len(data), len(data)))

    # Determine extraction mode
    is_table = (args.ptr_lo is not None and args.ptr_hi is not None
                and args.width_tbl is not None and args.height_tbl is not None)
    is_manual = (args.offset is not None and args.width is not None
                 and args.height is not None)

    if args.auto:
        # Auto-detect mode
        print("\nScanning for sprite table candidates (base=$%04X)..." % args.base)
        candidates = auto_detect_sprites(data, args.base)
        if not candidates:
            print("No sprite table candidates found.")
            sys.exit(0)

        print("\nFound %d candidate(s):\n" % len(candidates))
        for idx, c in enumerate(candidates):
            mono = " (monotonic)" if c['monotonic'] else ""
            print("  [%2d] ptr_lo=$%04X  ptr_hi=$%04X  count=%d  "
                  "addr_range=$%04X..$%04X%s"
                  % (idx, c['ptr_lo'], c['ptr_hi'], c['count'],
                     c['addr_min'], c['addr_max'], mono))

        print("\nTo extract, re-run with --ptr-lo, --ptr-hi, --width-tbl, "
              "--height-tbl, and --count.")
        sys.exit(0)

    elif is_table:
        # Table-driven extraction
        print("\nTable-driven extraction:")
        print("  ptr_lo=$%04X  ptr_hi=$%04X" % (args.ptr_lo, args.ptr_hi))
        print("  width_tbl=$%04X  height_tbl=$%04X" % (args.width_tbl, args.height_tbl))
        print("  count=%d  base=$%04X\n" % (args.count, args.base))

        raw_sprites = extract_table_driven(
            data, args.ptr_lo, args.ptr_hi,
            args.width_tbl, args.height_tbl,
            args.count, args.base
        )

    elif is_manual:
        # Manual extraction
        print("\nManual extraction:")
        print("  offset=$%04X  width=%d bytes (%d px)  height=%d  count=%d\n"
              % (args.offset, args.width, args.width * 7, args.height, args.count))

        raw_sprites = extract_manual(data, args.offset, args.width, args.height, args.count)

    else:
        parser.print_help()
        print("\nError: specify --auto, or --offset/--width/--height for manual, "
              "or all four table offsets for table-driven mode.", file=sys.stderr)
        sys.exit(1)

    # If auto mode, we already exited above
    if args.auto:
        return

    if not raw_sprites:
        print("No sprites extracted.")
        sys.exit(1)

    # Render sprites
    print("\nRendering %d sprite(s) at %dx scale..." % (len(raw_sprites), args.scale))

    out_dir = Path(args.output_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    rendered = []  # (pixels, width, height) at 1x for sheet/ascii
    for i, (sprite_data, w_bytes, h) in enumerate(raw_sprites):
        pixels, px_w, px_h = render_sprite(sprite_data, w_bytes, h)
        rendered.append((pixels, px_w, px_h))

        # ASCII preview (always at 1x)
        if args.ascii:
            print("\n--- Sprite %d (%d x %d px) ---" % (i, px_w, px_h))
            print(ascii_preview(pixels, px_w, px_h))

        # Save scaled PNG
        scaled_px, scaled_w, scaled_h = scale_pixels(pixels, px_w, px_h, args.scale)
        out_path = out_dir / ("sprite_%02d.png" % i)
        write_png(str(out_path), scaled_px, scaled_w, scaled_h)
        print("  Wrote %s (%d x %d)" % (out_path, scaled_w, scaled_h))

    # Sprite sheet
    if args.sheet and rendered:
        # Build sheet at 1x, then scale
        sheet_px, sheet_w, sheet_h = build_sprite_sheet(rendered, padding=2)
        if sheet_w > 0 and sheet_h > 0:
            scaled_px, scaled_w, scaled_h = scale_pixels(
                sheet_px, sheet_w, sheet_h, args.scale
            )
            sheet_path = out_dir / "sprite_sheet.png"
            write_png(str(sheet_path), scaled_px, scaled_w, scaled_h)
            print("\n  Wrote sprite sheet: %s (%d x %d)" % (sheet_path, scaled_w, scaled_h))

    print("\nDone.")


if __name__ == '__main__':
    main()

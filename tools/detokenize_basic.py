#!/usr/bin/env python3
"""
Apple II BASIC Detokenizer
Converts tokenized Applesoft BASIC and Integer BASIC programs back to text.

Supports:
  - Applesoft BASIC (most common, fully supported)
  - Integer BASIC (best-effort, basic keyword decoding)

Input files should have the DOS 3.3 4-byte header (load address + length) already
stripped. Use extract_dos33.py to pull files from .dsk images.

Cowritten by Claude Code Opus 4.6
"""

import sys
from pathlib import Path

# ---------------------------------------------------------------------------
# Applesoft BASIC token table ($80-$EA)
# ---------------------------------------------------------------------------

APPLESOFT_TOKENS = {
    0x80: "END",      0x81: "FOR",      0x82: "NEXT",     0x83: "DATA",
    0x84: "INPUT",    0x85: "DEL",      0x86: "DIM",      0x87: "READ",
    0x88: "GR",       0x89: "TEXT",     0x8A: "PR#",      0x8B: "IN#",
    0x8C: "CALL",     0x8D: "PLOT",     0x8E: "HLIN",     0x8F: "VLIN",
    0x90: "HGR2",     0x91: "HGR",      0x92: "HCOLOR=",  0x93: "HPLOT",
    0x94: "DRAW",     0x95: "XDRAW",    0x96: "HTAB",     0x97: "HOME",
    0x98: "ROT=",     0x99: "SCALE=",   0x9A: "SHLOAD",   0x9B: "TRACE",
    0x9C: "NOTRACE",  0x9D: "NORMAL",   0x9E: "INVERSE",  0x9F: "FLASH",
    0xA0: "COLOR=",   0xA1: "POP",      0xA2: "VTAB",     0xA3: "HIMEM:",
    0xA4: "LOMEM:",   0xA5: "ONERR",    0xA6: "RESUME",   0xA7: "RECALL",
    0xA8: "STORE",    0xA9: "SPEED=",   0xAA: "LET",      0xAB: "GOTO",
    0xAC: "RUN",      0xAD: "IF",       0xAE: "RESTORE",  0xAF: "&",
    0xB0: "GOSUB",    0xB1: "RETURN",   0xB2: "REM",      0xB3: "STOP",
    0xB4: "ON",       0xB5: "WAIT",     0xB6: "LOAD",     0xB7: "SAVE",
    0xB8: "DEF",      0xB9: "POKE",     0xBA: "PRINT",    0xBB: "CONT",
    0xBC: "LIST",     0xBD: "CLEAR",    0xBE: "GET",      0xBF: "NEW",
    0xC0: "TAB(",     0xC1: "TO",       0xC2: "FN",       0xC3: "SPC(",
    0xC4: "THEN",     0xC5: "AT",       0xC6: "NOT",      0xC7: "STEP",
    0xC8: "+",        0xC9: "-",        0xCA: "*",        0xCB: "/",
    0xCC: "^",        0xCD: "AND",      0xCE: "OR",       0xCF: ">",
    0xD0: "=",        0xD1: "<",        0xD2: "SGN",      0xD3: "INT",
    0xD4: "ABS",      0xD5: "USR",      0xD6: "FRE",      0xD7: "SCRN(",
    0xD8: "PDL",      0xD9: "POS",      0xDA: "SQR",      0xDB: "RND",
    0xDC: "LOG",      0xDD: "EXP",      0xDE: "COS",      0xDF: "SIN",
    0xE0: "TAN",      0xE1: "ATN",      0xE2: "PEEK",     0xE3: "LEN",
    0xE4: "STR$",     0xE5: "VAL",      0xE6: "ASC",      0xE7: "CHR$",
    0xE8: "LEFT$",    0xE9: "RIGHT$",   0xEA: "MID$",
}

# Tokens that are pure operators/punctuation (no added space needed from token)
APPLESOFT_OPERATORS = {0xC8, 0xC9, 0xCA, 0xCB, 0xCC, 0xCF, 0xD0, 0xD1, 0xAF}

# ---------------------------------------------------------------------------
# Integer BASIC token tables
#
# Integer BASIC uses a more complex encoding than Applesoft.  The token
# space is divided into several ranges with different semantics:
#
#   $00-$11  - Special control tokens (statement separators, etc.)
#   $12-$1F  - More control / whitespace
#   $20-$7F  - Literal ASCII characters
#   $80-$FF  - Keyword tokens
#
# Numeric constants are encoded inline: a byte $B0-$B9 introduces a
# 16-bit integer stored little-endian in the next two bytes.  The $B0-$B9
# byte itself represents the leading digit character ('0'-'9') but the
# actual value to use is the following 16-bit word.
#
# String constants are stored as a length-prefixed run of characters
# (token $29 = opening quote, followed by count byte, then characters,
# then token $29 again for closing quote).
# ---------------------------------------------------------------------------

INTEGER_TOKENS = {
    # $00-$11: special/control
    0x00: "HIMEM:",  0x01: "<$01>",  0x02: "_ ",    0x03: ":",
    0x04: "LOAD",    0x05: "SAVE",   0x06: "CON",   0x07: "RUN",
    0x08: "RUN",     0x09: "DEL",    0x0A: ",",     0x0B: "NEW",
    0x0C: "CLR",     0x0D: "AUTO",   0x0E: ",",     0x0F: "MAN",
    0x10: "HIMEM:",  0x11: "LOMEM:",

    # $12-$1F: more control
    0x12: "+",       0x13: "-",      0x14: "*",     0x15: "/",
    0x16: "=",       0x17: "#",      0x18: ">=",    0x19: ">",
    0x1A: "<=",      0x1B: "<>",     0x1C: "<",     0x1D: "AND",
    0x1E: "OR",      0x1F: "MOD",

    # $20-$3F: more operators/special
    0x20: "^",       0x21: "+",      0x22: "(",     0x23: ",",
    0x24: "THEN",    0x25: "THEN",   0x26: ",",     0x27: ",",
    0x28: "\"",      0x29: "\"",     0x2A: "(",     0x2B: "!",
    0x2C: "!",       0x2D: "(",      0x2E: "PEEK",  0x2F: "RND",
    0x30: "SGN",     0x31: "ABS",    0x32: "PDL",   0x33: "RNDX",
    0x34: "(", 0x35: "+", 0x36: "-", 0x37: "NOT",
    0x38: "(", 0x39: "=", 0x3A: "#", 0x3B: "LEN(",
    0x3C: "ASC(",    0x3D: "SCRN(",  0x3E: ",",     0x3F: "(",

    # $40-$4F: more
    0x40: "$",       0x41: "$",      0x42: "(",     0x43: ",",
    0x44: ",",       0x45: ";",      0x46: ";",     0x47: ";",
    0x48: ",",       0x49: ",",      0x4A: ",",     0x4B: "TEXT",
    0x4C: "GR",      0x4D: "CALL",   0x4E: "DIM",   0x4F: "DIM",

    0x50: "TAB",     0x51: "END",    0x52: "INPUT",  0x53: "INPUT",
    0x54: "INPUT",   0x55: "FOR",    0x56: "=",      0x57: "TO",
    0x58: "STEP",    0x59: "NEXT",   0x5A: ",",      0x5B: "RETURN",
    0x5C: "GOSUB",   0x5D: "REM",    0x5E: "LET",    0x5F: "GOTO",

    0x60: "IF",      0x61: "PRINT",  0x62: "PRINT",  0x63: "PRINT",
    0x64: "POKE",    0x65: ",",      0x66: "COLOR=", 0x67: "PLOT",
    0x68: ",",       0x69: "HLIN",   0x6A: ",",      0x6B: "AT",
    0x6C: "VLIN",    0x6D: ",",      0x6E: "AT",     0x6F: "VTAB",

    0x70: "=",       0x71: "=",      0x72: ")",      0x73: ")",
    0x74: "LIST",    0x75: ",",      0x76: "LIST",   0x77: "POP",
    0x78: "NODSP",   0x79: "NODSP",  0x7A: "NOTRACE", 0x7B: "DSP",
    0x7C: "DSP",     0x7D: "TRACE",  0x7E: "PR#",    0x7F: "IN#",
}


# ---------------------------------------------------------------------------
# Applesoft BASIC detokenizer
# ---------------------------------------------------------------------------

def detokenize_applesoft(data: bytes) -> list[str]:
    """Detokenize an Applesoft BASIC program.

    Returns a list of text lines (without trailing newline characters).
    """
    lines = []
    pos = 0

    while pos + 3 < len(data):
        # Read next-line pointer (2 bytes, little-endian)
        next_ptr = data[pos] | (data[pos + 1] << 8)
        if next_ptr == 0x0000:
            break  # end of program

        # Read line number (2 bytes, little-endian)
        line_num = data[pos + 2] | (data[pos + 3] << 8)
        pos += 4

        # Decode tokens until $00 terminator
        line_text = str(line_num) + " "
        in_quote = False
        in_rem = False

        while pos < len(data) and data[pos] != 0x00:
            byte = data[pos]

            if in_rem:
                # After REM, everything is literal text until end of line
                if byte >= 0x20:
                    line_text += chr(byte)
                else:
                    # Control character in REM - show as-is or as space
                    line_text += chr(byte) if byte >= 0x20 else " "
                pos += 1
                continue

            if byte == 0x22:  # ASCII double-quote
                in_quote = not in_quote
                line_text += '"'
                pos += 1
                continue

            if in_quote:
                # Inside a string literal: all bytes are literal ASCII
                if byte >= 0x20 and byte < 0x80:
                    line_text += chr(byte)
                else:
                    # High-bit or control char inside string (unusual but possible)
                    line_text += chr(byte & 0x7F)
                pos += 1
                continue

            # Outside of quotes: decode tokens
            if byte >= 0x80 and byte in APPLESOFT_TOKENS:
                keyword = APPLESOFT_TOKENS[byte]
                # Add a leading space before keyword tokens (except operators)
                # only if the previous character is alphanumeric
                if byte not in APPLESOFT_OPERATORS:
                    if line_text and line_text[-1].isalnum():
                        line_text += " "
                line_text += keyword
                # Add trailing space after keyword tokens (except operators
                # and keywords ending with special chars like '(' or '=')
                if byte not in APPLESOFT_OPERATORS:
                    if not keyword.endswith(("(", "=", ":", "$")):
                        line_text += " "
                # REM consumes everything to end of line
                if byte == 0xB2:
                    in_rem = True
            elif byte >= 0x20 and byte < 0x80:
                # Literal ASCII character
                line_text += chr(byte)
            else:
                # Unexpected high byte that is not a known token ($EB-$FF)
                line_text += f"<${byte:02X}>"
            pos += 1

        # Skip the $00 terminator
        if pos < len(data) and data[pos] == 0x00:
            pos += 1

        lines.append(line_text.rstrip())

    return lines


# ---------------------------------------------------------------------------
# Integer BASIC detokenizer (best-effort)
# ---------------------------------------------------------------------------

def detokenize_integer(data: bytes) -> list[str]:
    """Detokenize an Integer BASIC program (best-effort).

    Integer BASIC has a more complex tokenization scheme than Applesoft.
    This implementation handles the common cases: line structure, keyword
    tokens, numeric constants, string literals, and variable names.

    Returns a list of text lines.
    """
    lines = []
    pos = 0

    while pos < len(data):
        # Line length byte (includes this byte itself)
        if pos >= len(data):
            break
        line_len = data[pos]
        if line_len == 0:
            break  # end of program or padding

        line_end = pos + line_len
        pos += 1

        # Line number (2 bytes, little-endian)
        if pos + 1 >= len(data):
            break
        line_num = data[pos] | (data[pos + 1] << 8)
        pos += 2

        line_text = str(line_num) + " "

        while pos < line_end:
            byte = data[pos]

            if byte == 0x01:
                # End-of-line marker
                pos += 1
                break

            # Numeric constant: $B0-$B9 followed by 2-byte little-endian value
            if 0xB0 <= byte <= 0xB9:
                pos += 1
                if pos + 1 < line_end:
                    value = data[pos] | (data[pos + 1] << 8)
                    pos += 2
                    line_text += str(value)
                else:
                    line_text += "<NUM?>"
                    pos = line_end
                continue

            # String literal: token $29 (quote), then count, then chars, then $29
            if byte == 0x28 or byte == 0x29:
                # $28 = opening quote context, $29 = closing quote context
                # In practice the tokenizer stores: $28 count chars... $29
                # But some variants just use raw chars between quotes.
                # We just emit the quote character.
                line_text += '"'
                pos += 1
                continue

            # Variable name token: $BA-$BF followed by characters
            # In Integer BASIC, variable names are stored as tokens $40-$5A
            # (uppercase letters) with high bit sometimes set.
            # For simplicity, if we see $BA-$BF range, treat as a variable ref.

            # Keyword/operator tokens $00-$7F
            if byte in INTEGER_TOKENS:
                keyword = INTEGER_TOKENS[byte]
                if keyword.startswith("<"):
                    # Unknown/placeholder token
                    line_text += keyword
                elif len(keyword) > 1 and keyword.isalpha():
                    # Multi-char keyword: add spaces for readability
                    if line_text and line_text[-1].isalnum():
                        line_text += " "
                    line_text += keyword
                    if not keyword.endswith(("(", "=", ":")):
                        line_text += " "
                else:
                    line_text += keyword
                pos += 1
                continue

            # $80-$AF: variable name characters (letter with high bit set)
            if 0x80 <= byte <= 0xAF:
                # Variable name character: strip high bit to get ASCII letter
                line_text += chr(byte & 0x7F)
                pos += 1
                continue

            # $BA-$BF: more token range
            if 0xBA <= byte <= 0xBF:
                line_text += f"<${byte:02X}>"
                pos += 1
                continue

            # $C0-$FF: additional keyword tokens (less common)
            if byte >= 0xC0:
                line_text += f"<${byte:02X}>"
                pos += 1
                continue

            # Fallback: show raw byte
            line_text += f"<${byte:02X}>"
            pos += 1

        # Make sure we advance to the real line end even if we broke early
        pos = max(pos, line_end)
        lines.append(line_text.rstrip())

    return lines


# ---------------------------------------------------------------------------
# Auto-detection
# ---------------------------------------------------------------------------

def detect_basic_type(data: bytes) -> str:
    """Attempt to auto-detect whether data is Applesoft or Integer BASIC.

    Applesoft programs start with a 2-byte next-line pointer (nonzero) followed
    by a 2-byte line number.  The next-line pointer typically points into the
    low memory range ($0801-$BFFF).  After decoding the first line, the pointer
    should land at the start of the second line or at $0000 (end).

    Integer BASIC programs start with a 1-byte line length.  The line length
    is usually small (< 128) and the first line number is reasonable.

    Heuristic:
      - Read the first 4 bytes as an Applesoft header.  If the next-line
        pointer is in a reasonable range and the line number is sane, score
        points for Applesoft.
      - Read the first 3 bytes as an Integer BASIC header.  If the line
        length is reasonable and leads to a valid second line, score points
        for Integer BASIC.
    """
    if len(data) < 4:
        return "unknown"

    # Applesoft check: next-line pointer in $0002-$BFFF, line number < 64000
    as_next = data[0] | (data[1] << 8)
    as_linenum = data[2] | (data[3] << 8)

    applesoft_score = 0
    if 0x0002 <= as_next <= 0xBFFF and as_linenum < 64000:
        applesoft_score += 2

        # Walk the first line to see if we hit a $00 terminator reasonably
        # and the next-line pointer is consistent
        pos = 4
        while pos < len(data) and pos < as_next and data[pos] != 0x00:
            pos += 1
        if pos < len(data) and data[pos] == 0x00:
            applesoft_score += 2
            # Check that the byte after the terminator aligns with next_ptr
            # (next_ptr is typically the address in memory, so we check
            # relative offsets).  In a bare file, as_next might be relative
            # to a base address like $0801.  We just check there is a
            # reasonable structure after the first line.
            remaining_start = pos + 1
            if remaining_start + 3 < len(data):
                next2 = data[remaining_start] | (data[remaining_start + 1] << 8)
                line2 = data[remaining_start + 2] | (data[remaining_start + 3] << 8)
                if next2 == 0x0000 or (next2 > as_next and line2 > as_linenum):
                    applesoft_score += 3

        # Check that tokens in the first line are valid Applesoft tokens
        for i in range(4, min(pos, len(data))):
            b = data[i]
            if b >= 0x80:
                if b in APPLESOFT_TOKENS:
                    applesoft_score += 1
                else:
                    applesoft_score -= 1

    # Integer BASIC check: first byte is line length (small), then line number
    int_linelen = data[0]
    integer_score = 0
    if 3 < int_linelen < 128:
        if len(data) >= 3:
            int_linenum = data[1] | (data[2] << 8)
            if int_linenum < 64000:
                integer_score += 2
                # Check for $01 end-of-line marker at expected position
                eol_pos = int_linelen  # line length includes the length byte
                if eol_pos - 1 < len(data) and data[eol_pos - 1] == 0x01:
                    integer_score += 3

    if applesoft_score > integer_score and applesoft_score >= 4:
        return "applesoft"
    elif integer_score > applesoft_score and integer_score >= 3:
        return "integer"
    else:
        return "unknown"


# ---------------------------------------------------------------------------
# Applesoft BASIC line-number cross-reference
# ---------------------------------------------------------------------------

def applesoft_xref(lines_text: list[str]) -> dict[int, list[int]]:
    """Build a cross-reference of GOTO/GOSUB targets from listing text.

    Returns a dict mapping target line numbers to lists of source line numbers
    that reference them.  This is purely cosmetic / informational.
    """
    import re
    xref: dict[int, list[int]] = {}
    branch_re = re.compile(
        r'\b(?:GOTO|GOSUB|THEN|ON\s.*?GOTO|ON\s.*?GOSUB)\s+(\d[\d,\s]*)',
        re.IGNORECASE,
    )
    for line in lines_text:
        # Extract the source line number (first token on the line)
        parts = line.split(None, 1)
        if not parts or not parts[0].isdigit():
            continue
        src_linenum = int(parts[0])
        rest = parts[1] if len(parts) > 1 else ""
        for m in branch_re.finditer(rest):
            targets_str = m.group(1)
            for num_str in re.findall(r'\d+', targets_str):
                target = int(num_str)
                xref.setdefault(target, []).append(src_linenum)
    return xref


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    import argparse

    parser = argparse.ArgumentParser(
        description="Detokenize Apple II BASIC programs (Applesoft / Integer BASIC)"
    )
    parser.add_argument("input", type=Path, help="Tokenized BASIC file (.bas / raw binary)")
    parser.add_argument("-o", "--output", type=Path, default=None,
                        help="Write output to file instead of stdout")
    parser.add_argument("--applesoft", action="store_true",
                        help="Force Applesoft BASIC interpretation")
    parser.add_argument("--integer", action="store_true",
                        help="Force Integer BASIC interpretation")
    parser.add_argument("--xref", action="store_true",
                        help="Print GOTO/GOSUB cross-reference (Applesoft only)")
    parser.add_argument("--hex-dump", action="store_true",
                        help="Print hex dump of raw file alongside listing")

    args = parser.parse_args()

    if args.applesoft and args.integer:
        print("Error: cannot specify both --applesoft and --integer", file=sys.stderr)
        sys.exit(1)

    data = args.input.read_bytes()
    if len(data) == 0:
        print("Error: input file is empty", file=sys.stderr)
        sys.exit(1)

    # Determine BASIC type
    if args.applesoft:
        basic_type = "applesoft"
    elif args.integer:
        basic_type = "integer"
    else:
        basic_type = detect_basic_type(data)
        if basic_type == "unknown":
            print("Warning: could not auto-detect BASIC type; assuming Applesoft.",
                  file=sys.stderr)
            print("  Use --applesoft or --integer to force.", file=sys.stderr)
            basic_type = "applesoft"

    # Detokenize
    if basic_type == "applesoft":
        lines = detokenize_applesoft(data)
        type_label = "Applesoft BASIC"
    else:
        lines = detokenize_integer(data)
        type_label = "Integer BASIC"

    # Build output
    output_lines = []

    if args.hex_dump:
        output_lines.append(f"; Hex dump of {args.input.name} ({len(data)} bytes)")
        output_lines.append("; " + "-" * 60)
        for offset in range(0, len(data), 16):
            chunk = data[offset:offset + 16]
            hex_part = " ".join(f"{b:02X}" for b in chunk)
            ascii_part = "".join(chr(b) if 0x20 <= b < 0x7F else "." for b in chunk)
            output_lines.append(f"; {offset:04X}: {hex_part:<48s}  {ascii_part}")
        output_lines.append("")

    output_lines.append(f"; {type_label} listing: {args.input.name}")
    output_lines.append(f"; {len(data)} bytes, {len(lines)} lines")
    output_lines.append("")

    for line in lines:
        output_lines.append(line)

    # Cross-reference
    if args.xref and basic_type == "applesoft":
        xref = applesoft_xref(lines)
        if xref:
            output_lines.append("")
            output_lines.append("; --- GOTO/GOSUB Cross-Reference ---")
            for target in sorted(xref.keys()):
                sources = ", ".join(str(s) for s in sorted(xref[target]))
                output_lines.append(f";   Line {target} <- referenced from: {sources}")

    # Output
    text = "\n".join(output_lines) + "\n"

    if args.output:
        args.output.write_text(text, encoding="utf-8")
        print(f"Wrote {len(lines)} lines to {args.output}", file=sys.stderr)
    else:
        sys.stdout.write(text)


if __name__ == "__main__":
    main()

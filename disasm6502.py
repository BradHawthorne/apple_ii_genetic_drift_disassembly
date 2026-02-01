#!/usr/bin/env python3
"""
6502 Disassembler for Apple II binaries

Cowritten by Claude Code Opus 4.5
"""

import sys
from pathlib import Path

# 6502 opcode table: opcode -> (mnemonic, addressing_mode, size)
OPCODES = {
    # ADC
    0x69: ("ADC", "imm", 2), 0x65: ("ADC", "zp", 2), 0x75: ("ADC", "zpx", 2),
    0x6D: ("ADC", "abs", 3), 0x7D: ("ADC", "absx", 3), 0x79: ("ADC", "absy", 3),
    0x61: ("ADC", "indx", 2), 0x71: ("ADC", "indy", 2),
    # AND
    0x29: ("AND", "imm", 2), 0x25: ("AND", "zp", 2), 0x35: ("AND", "zpx", 2),
    0x2D: ("AND", "abs", 3), 0x3D: ("AND", "absx", 3), 0x39: ("AND", "absy", 3),
    0x21: ("AND", "indx", 2), 0x31: ("AND", "indy", 2),
    # ASL
    0x0A: ("ASL", "acc", 1), 0x06: ("ASL", "zp", 2), 0x16: ("ASL", "zpx", 2),
    0x0E: ("ASL", "abs", 3), 0x1E: ("ASL", "absx", 3),
    # BCC, BCS, BEQ, BMI, BNE, BPL, BVC, BVS
    0x90: ("BCC", "rel", 2), 0xB0: ("BCS", "rel", 2), 0xF0: ("BEQ", "rel", 2),
    0x30: ("BMI", "rel", 2), 0xD0: ("BNE", "rel", 2), 0x10: ("BPL", "rel", 2),
    0x50: ("BVC", "rel", 2), 0x70: ("BVS", "rel", 2),
    # BIT
    0x24: ("BIT", "zp", 2), 0x2C: ("BIT", "abs", 3),
    # BRK
    0x00: ("BRK", "imp", 1),
    # CLC, CLD, CLI, CLV
    0x18: ("CLC", "imp", 1), 0xD8: ("CLD", "imp", 1), 0x58: ("CLI", "imp", 1), 0xB8: ("CLV", "imp", 1),
    # CMP
    0xC9: ("CMP", "imm", 2), 0xC5: ("CMP", "zp", 2), 0xD5: ("CMP", "zpx", 2),
    0xCD: ("CMP", "abs", 3), 0xDD: ("CMP", "absx", 3), 0xD9: ("CMP", "absy", 3),
    0xC1: ("CMP", "indx", 2), 0xD1: ("CMP", "indy", 2),
    # CPX
    0xE0: ("CPX", "imm", 2), 0xE4: ("CPX", "zp", 2), 0xEC: ("CPX", "abs", 3),
    # CPY
    0xC0: ("CPY", "imm", 2), 0xC4: ("CPY", "zp", 2), 0xCC: ("CPY", "abs", 3),
    # DEC
    0xC6: ("DEC", "zp", 2), 0xD6: ("DEC", "zpx", 2), 0xCE: ("DEC", "abs", 3), 0xDE: ("DEC", "absx", 3),
    # DEX, DEY
    0xCA: ("DEX", "imp", 1), 0x88: ("DEY", "imp", 1),
    # EOR
    0x49: ("EOR", "imm", 2), 0x45: ("EOR", "zp", 2), 0x55: ("EOR", "zpx", 2),
    0x4D: ("EOR", "abs", 3), 0x5D: ("EOR", "absx", 3), 0x59: ("EOR", "absy", 3),
    0x41: ("EOR", "indx", 2), 0x51: ("EOR", "indy", 2),
    # INC
    0xE6: ("INC", "zp", 2), 0xF6: ("INC", "zpx", 2), 0xEE: ("INC", "abs", 3), 0xFE: ("INC", "absx", 3),
    # INX, INY
    0xE8: ("INX", "imp", 1), 0xC8: ("INY", "imp", 1),
    # JMP
    0x4C: ("JMP", "abs", 3), 0x6C: ("JMP", "ind", 3),
    # JSR
    0x20: ("JSR", "abs", 3),
    # LDA
    0xA9: ("LDA", "imm", 2), 0xA5: ("LDA", "zp", 2), 0xB5: ("LDA", "zpx", 2),
    0xAD: ("LDA", "abs", 3), 0xBD: ("LDA", "absx", 3), 0xB9: ("LDA", "absy", 3),
    0xA1: ("LDA", "indx", 2), 0xB1: ("LDA", "indy", 2),
    # LDX
    0xA2: ("LDX", "imm", 2), 0xA6: ("LDX", "zp", 2), 0xB6: ("LDX", "zpy", 2),
    0xAE: ("LDX", "abs", 3), 0xBE: ("LDX", "absy", 3),
    # LDY
    0xA0: ("LDY", "imm", 2), 0xA4: ("LDY", "zp", 2), 0xB4: ("LDY", "zpx", 2),
    0xAC: ("LDY", "abs", 3), 0xBC: ("LDY", "absx", 3),
    # LSR
    0x4A: ("LSR", "acc", 1), 0x46: ("LSR", "zp", 2), 0x56: ("LSR", "zpx", 2),
    0x4E: ("LSR", "abs", 3), 0x5E: ("LSR", "absx", 3),
    # NOP
    0xEA: ("NOP", "imp", 1),
    # ORA
    0x09: ("ORA", "imm", 2), 0x05: ("ORA", "zp", 2), 0x15: ("ORA", "zpx", 2),
    0x0D: ("ORA", "abs", 3), 0x1D: ("ORA", "absx", 3), 0x19: ("ORA", "absy", 3),
    0x01: ("ORA", "indx", 2), 0x11: ("ORA", "indy", 2),
    # PHA, PHP, PLA, PLP
    0x48: ("PHA", "imp", 1), 0x08: ("PHP", "imp", 1), 0x68: ("PLA", "imp", 1), 0x28: ("PLP", "imp", 1),
    # ROL
    0x2A: ("ROL", "acc", 1), 0x26: ("ROL", "zp", 2), 0x36: ("ROL", "zpx", 2),
    0x2E: ("ROL", "abs", 3), 0x3E: ("ROL", "absx", 3),
    # ROR
    0x6A: ("ROR", "acc", 1), 0x66: ("ROR", "zp", 2), 0x76: ("ROR", "zpx", 2),
    0x6E: ("ROR", "abs", 3), 0x7E: ("ROR", "absx", 3),
    # RTI, RTS
    0x40: ("RTI", "imp", 1), 0x60: ("RTS", "imp", 1),
    # SBC
    0xE9: ("SBC", "imm", 2), 0xE5: ("SBC", "zp", 2), 0xF5: ("SBC", "zpx", 2),
    0xED: ("SBC", "abs", 3), 0xFD: ("SBC", "absx", 3), 0xF9: ("SBC", "absy", 3),
    0xE1: ("SBC", "indx", 2), 0xF1: ("SBC", "indy", 2),
    # SEC, SED, SEI
    0x38: ("SEC", "imp", 1), 0xF8: ("SED", "imp", 1), 0x78: ("SEI", "imp", 1),
    # STA
    0x85: ("STA", "zp", 2), 0x95: ("STA", "zpx", 2), 0x8D: ("STA", "abs", 3),
    0x9D: ("STA", "absx", 3), 0x99: ("STA", "absy", 3), 0x81: ("STA", "indx", 2), 0x91: ("STA", "indy", 2),
    # STX
    0x86: ("STX", "zp", 2), 0x96: ("STX", "zpy", 2), 0x8E: ("STX", "abs", 3),
    # STY
    0x84: ("STY", "zp", 2), 0x94: ("STY", "zpx", 2), 0x8C: ("STY", "abs", 3),
    # TAX, TAY, TSX, TXA, TXS, TYA
    0xAA: ("TAX", "imp", 1), 0xA8: ("TAY", "imp", 1), 0xBA: ("TSX", "imp", 1),
    0x8A: ("TXA", "imp", 1), 0x9A: ("TXS", "imp", 1), 0x98: ("TYA", "imp", 1),
}

# Apple II hardware addresses
HARDWARE = {
    0xC000: "KEYBOARD",
    0xC010: "KBDSTRB",      # Clear keyboard strobe
    0xC020: "TAPEOUT",
    0xC030: "SPKR",         # Speaker toggle
    0xC050: "TXTCLR",       # Graphics mode
    0xC051: "TXTSET",       # Text mode
    0xC052: "MIXCLR",       # Full screen
    0xC053: "MIXSET",       # Mixed mode
    0xC054: "LOWSCR",       # Page 1
    0xC055: "HISCR",        # Page 2
    0xC056: "LORES",        # Lo-res
    0xC057: "HIRES",        # Hi-res
    0xC060: "TAPEIN",
    0xC061: "PB0",          # Paddle button 0
    0xC062: "PB1",          # Paddle button 1
    0xC064: "PADDL0",       # Paddle 0
    0xC065: "PADDL1",       # Paddle 1
    0xC070: "PTRIG",        # Paddle trigger
}

def format_operand(mode, operand, pc):
    """Format operand based on addressing mode."""
    if mode == "imp":
        return ""
    elif mode == "acc":
        return "A"
    elif mode == "imm":
        return f"#${operand:02X}"
    elif mode == "zp":
        return f"${operand:02X}"
    elif mode == "zpx":
        return f"${operand:02X},X"
    elif mode == "zpy":
        return f"${operand:02X},Y"
    elif mode == "abs":
        hw = HARDWARE.get(operand, "")
        if hw:
            return f"${operand:04X}  ; {hw}"
        return f"${operand:04X}"
    elif mode == "absx":
        hw = HARDWARE.get(operand, "")
        if hw:
            return f"${operand:04X},X  ; {hw}"
        return f"${operand:04X},X"
    elif mode == "absy":
        hw = HARDWARE.get(operand, "")
        if hw:
            return f"${operand:04X},Y  ; {hw}"
        return f"${operand:04X},Y"
    elif mode == "ind":
        return f"(${operand:04X})"
    elif mode == "indx":
        return f"(${operand:02X},X)"
    elif mode == "indy":
        return f"(${operand:02X}),Y"
    elif mode == "rel":
        # Branch target
        if operand >= 128:
            offset = operand - 256
        else:
            offset = operand
        target = pc + 2 + offset
        return f"${target:04X}"
    return f"${operand:04X}"

def disassemble(code, start_addr, labels=None):
    """Disassemble binary code."""
    if labels is None:
        labels = {}

    lines = []
    branch_targets = set()
    jsr_targets = set()

    # First pass: find branch targets and JSR targets
    i = 0
    pc = start_addr
    while i < len(code):
        byte = code[i]
        if byte in OPCODES:
            mnem, mode, size = OPCODES[byte]
            if mode == "rel" and i + 1 < len(code):
                operand = code[i + 1]
                if operand >= 128:
                    offset = operand - 256
                else:
                    offset = operand
                target = pc + 2 + offset
                branch_targets.add(target)
            elif mnem == "JSR" and i + 2 < len(code):
                operand = code[i + 1] | (code[i + 2] << 8)
                jsr_targets.add(operand)
            elif mnem == "JMP" and mode == "abs" and i + 2 < len(code):
                operand = code[i + 1] | (code[i + 2] << 8)
                branch_targets.add(operand)
            pc += size
            i += size
        else:
            pc += 1
            i += 1

    # Second pass: generate disassembly
    i = 0
    pc = start_addr
    while i < len(code):
        # Check for label
        label = ""
        if pc in branch_targets:
            label = f"L_{pc:04X}"
        elif pc in jsr_targets:
            label = f"SUB_{pc:04X}"

        if label or pc in labels:
            lines.append(f"\n{labels.get(pc, label)}:")

        byte = code[i]
        if byte in OPCODES:
            mnem, mode, size = OPCODES[byte]

            if size == 1:
                operand = None
                hex_bytes = f"{byte:02X}"
            elif size == 2:
                if i + 1 < len(code):
                    operand = code[i + 1]
                    hex_bytes = f"{byte:02X} {operand:02X}"
                else:
                    operand = 0
                    hex_bytes = f"{byte:02X} ??"
            else:  # size == 3
                if i + 2 < len(code):
                    operand = code[i + 1] | (code[i + 2] << 8)
                    hex_bytes = f"{byte:02X} {code[i+1]:02X} {code[i+2]:02X}"
                else:
                    operand = 0
                    hex_bytes = f"{byte:02X} ?? ??"

            operand_str = format_operand(mode, operand, pc) if operand is not None else ""

            # Add label reference for branches
            if mode == "rel" and operand is not None:
                if operand >= 128:
                    offset = operand - 256
                else:
                    offset = operand
                target = pc + 2 + offset
                if target in jsr_targets:
                    operand_str = f"SUB_{target:04X}"
                elif target in branch_targets:
                    operand_str = f"L_{target:04X}"

            lines.append(f"    ${pc:04X}: {hex_bytes:10s}  {mnem:4s} {operand_str}")
            pc += size
            i += size
        else:
            # Unknown opcode - treat as data
            lines.append(f"    ${pc:04X}: {byte:02X}          .BYTE ${byte:02X}")
            pc += 1
            i += 1

    return lines

def find_strings(code, start_addr, min_len=4):
    """Find potential text strings (Apple II high-bit ASCII)."""
    strings = []
    i = 0
    while i < len(code):
        # Look for runs of high-bit ASCII printable characters
        if code[i] >= 0xA0 and code[i] <= 0xFE:
            start = i
            chars = []
            while i < len(code) and code[i] >= 0xA0 and code[i] <= 0xFE:
                chars.append(chr(code[i] & 0x7F))
                i += 1
            if len(chars) >= min_len:
                text = ''.join(chars)
                strings.append((start_addr + start, text))
        else:
            i += 1
    return strings

def main():
    if len(sys.argv) < 2:
        print("Usage: python disasm6502.py <binary.bin> [load_address_hex]")
        print("  load_address defaults to 0x0800")
        sys.exit(1)

    bin_path = Path(sys.argv[1])
    with open(bin_path, 'rb') as f:
        code = f.read()

    if len(sys.argv) >= 3:
        start_addr = int(sys.argv[2], 16)
    else:
        start_addr = 0x0800

    print(f"; Disassembly of {bin_path.name}")
    print(f"; Load address: ${start_addr:04X}")
    print(f"; Length: {len(code)} bytes (${len(code):04X})")
    print(f"; End address: ${start_addr + len(code) - 1:04X}")
    print()

    # Find strings
    strings = find_strings(code, start_addr)
    if strings:
        print("; Strings found:")
        for addr, text in strings:
            print(f";   ${addr:04X}: \"{text}\"")
        print()

    # Disassemble
    lines = disassemble(code, start_addr)
    for line in lines:
        print(line)

if __name__ == '__main__':
    main()

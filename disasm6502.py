#!/usr/bin/env python3
"""
6502 Disassembler for Apple II binaries

Cowritten by Claude Code Opus 4.6

Features:
  - Control flow graph tracing (default) or linear disassembly (--linear)
  - Self-modifying code (SMC) detection
  - Improved data region output (.BYTE, ASCII strings, pointer tables)
  - Contextual label generation (sub_, jmp_, loc_, dat_)
  - Apple II hardware address annotation
  - Multiple entry point support (--entry)

Usage:
  python disasm6502.py <binary.bin> [load_address_hex]
  python disasm6502.py <binary.bin> [load_address_hex] --entry 0x0900 --entry 0x0A00
  python disasm6502.py <binary.bin> [load_address_hex] --linear
  python disasm6502.py <binary.bin> [load_address_hex] --no-smc
"""

import sys
import argparse
from collections import deque
from pathlib import Path

# ---------------------------------------------------------------------------
# 6502 opcode table: opcode -> (mnemonic, addressing_mode, size)
# ---------------------------------------------------------------------------

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
    0x18: ("CLC", "imp", 1), 0xD8: ("CLD", "imp", 1),
    0x58: ("CLI", "imp", 1), 0xB8: ("CLV", "imp", 1),
    # CMP
    0xC9: ("CMP", "imm", 2), 0xC5: ("CMP", "zp", 2), 0xD5: ("CMP", "zpx", 2),
    0xCD: ("CMP", "abs", 3), 0xDD: ("CMP", "absx", 3), 0xD9: ("CMP", "absy", 3),
    0xC1: ("CMP", "indx", 2), 0xD1: ("CMP", "indy", 2),
    # CPX
    0xE0: ("CPX", "imm", 2), 0xE4: ("CPX", "zp", 2), 0xEC: ("CPX", "abs", 3),
    # CPY
    0xC0: ("CPY", "imm", 2), 0xC4: ("CPY", "zp", 2), 0xCC: ("CPY", "abs", 3),
    # DEC
    0xC6: ("DEC", "zp", 2), 0xD6: ("DEC", "zpx", 2),
    0xCE: ("DEC", "abs", 3), 0xDE: ("DEC", "absx", 3),
    # DEX, DEY
    0xCA: ("DEX", "imp", 1), 0x88: ("DEY", "imp", 1),
    # EOR
    0x49: ("EOR", "imm", 2), 0x45: ("EOR", "zp", 2), 0x55: ("EOR", "zpx", 2),
    0x4D: ("EOR", "abs", 3), 0x5D: ("EOR", "absx", 3), 0x59: ("EOR", "absy", 3),
    0x41: ("EOR", "indx", 2), 0x51: ("EOR", "indy", 2),
    # INC
    0xE6: ("INC", "zp", 2), 0xF6: ("INC", "zpx", 2),
    0xEE: ("INC", "abs", 3), 0xFE: ("INC", "absx", 3),
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
    0x48: ("PHA", "imp", 1), 0x08: ("PHP", "imp", 1),
    0x68: ("PLA", "imp", 1), 0x28: ("PLP", "imp", 1),
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
    0x9D: ("STA", "absx", 3), 0x99: ("STA", "absy", 3),
    0x81: ("STA", "indx", 2), 0x91: ("STA", "indy", 2),
    # STX
    0x86: ("STX", "zp", 2), 0x96: ("STX", "zpy", 2), 0x8E: ("STX", "abs", 3),
    # STY
    0x84: ("STY", "zp", 2), 0x94: ("STY", "zpx", 2), 0x8C: ("STY", "abs", 3),
    # TAX, TAY, TSX, TXA, TXS, TYA
    0xAA: ("TAX", "imp", 1), 0xA8: ("TAY", "imp", 1), 0xBA: ("TSX", "imp", 1),
    0x8A: ("TXA", "imp", 1), 0x9A: ("TXS", "imp", 1), 0x98: ("TYA", "imp", 1),
}

# ---------------------------------------------------------------------------
# Branch mnemonics (for identifying conditional branches)
# ---------------------------------------------------------------------------

BRANCH_MNEMONICS = {"BCC", "BCS", "BEQ", "BMI", "BNE", "BPL", "BVC", "BVS"}

# Store mnemonics for SMC detection
STORE_MNEMONICS = {"STA", "STX", "STY"}

# Addressing modes that target a definite absolute or zp address
STORE_ABS_MODES = {"abs", "zp"}

# ---------------------------------------------------------------------------
# Apple II hardware addresses
# ---------------------------------------------------------------------------

HARDWARE = {
    # Keyboard
    0xC000: "KEYBOARD",
    0xC010: "KBDSTRB",          # Clear keyboard strobe
    # Speaker / Tape
    0xC020: "TAPEOUT",
    0xC030: "SPKR",             # Speaker toggle
    # Display switches
    0xC050: "TXTCLR",           # Graphics mode
    0xC051: "TXTSET",           # Text mode
    0xC052: "MIXCLR",           # Full screen
    0xC053: "MIXSET",           # Mixed mode
    0xC054: "LOWSCR",           # Page 1
    0xC055: "HISCR",            # Page 2
    0xC056: "LORES",            # Lo-res
    0xC057: "HIRES",            # Hi-res
    # Game I/O
    0xC060: "TAPEIN",
    0xC061: "PB0",              # Paddle button 0
    0xC062: "PB1",              # Paddle button 1
    0xC063: "PB2",              # Paddle button 2
    0xC064: "PADDL0",           # Paddle 0
    0xC065: "PADDL1",           # Paddle 1
    0xC066: "PADDL2",           # Paddle 2
    0xC067: "PADDL3",           # Paddle 3
    0xC070: "PTRIG",            # Paddle trigger
    # Language Card / RAM bank switches ($C080-$C08F)
    0xC080: "LCBANK2_RE",       # Read enable, bank 2, write-protect
    0xC081: "LCBANK2_RW",       # Read ROM, write enable, bank 2
    0xC082: "LCBANK2_RO",       # Read ROM, write-protect, bank 2
    0xC083: "LCBANK2_RW2",      # Read enable, write enable, bank 2
    0xC084: "LCBANK2_RE_M",     # Mirror of $C080
    0xC085: "LCBANK2_RW_M",     # Mirror of $C081
    0xC086: "LCBANK2_RO_M",     # Mirror of $C082
    0xC087: "LCBANK2_RW2_M",    # Mirror of $C083
    0xC088: "LCBANK1_RE",       # Read enable, bank 1, write-protect
    0xC089: "LCBANK1_RW",       # Read ROM, write enable, bank 1
    0xC08A: "LCBANK1_RO",       # Read ROM, write-protect, bank 1
    0xC08B: "LCBANK1_RW2",      # Read enable, write enable, bank 1
    0xC08C: "LCBANK1_RE_M",     # Mirror of $C088 / Disk data latch (slot-relative)
    0xC08D: "LCBANK1_RW_M",     # Mirror of $C089
    0xC08E: "LCBANK1_RO_M",     # Mirror of $C08A
    0xC08F: "LCBANK1_RW2_M",    # Mirror of $C08B
    # Disk II I/O (slot 6: $C0E0-$C0EF)
    0xC0E0: "DISK_PHASE0_OFF",  # Stepper phase 0 off
    0xC0E1: "DISK_PHASE0_ON",   # Stepper phase 0 on
    0xC0E2: "DISK_PHASE1_OFF",  # Stepper phase 1 off
    0xC0E3: "DISK_PHASE1_ON",   # Stepper phase 1 on
    0xC0E4: "DISK_PHASE2_OFF",  # Stepper phase 2 off
    0xC0E5: "DISK_PHASE2_ON",   # Stepper phase 2 on
    0xC0E6: "DISK_PHASE3_OFF",  # Stepper phase 3 off
    0xC0E7: "DISK_PHASE3_ON",   # Stepper phase 3 on
    0xC0E8: "DISK_MOTOR_OFF",   # Drive motor off
    0xC0E9: "DISK_MOTOR_ON",    # Drive motor on
    0xC0EA: "DISK_SEL_D1",      # Select drive 1
    0xC0EB: "DISK_SEL_D2",      # Select drive 2
    0xC0EC: "DISK_DATA_READ",   # Data register (read)
    0xC0ED: "DISK_DATA_WRITE",  # Data register (write)
    0xC0EE: "DISK_READ_MODE",   # Read mode
    0xC0EF: "DISK_WRITE_MODE",  # Write mode
}


# ---------------------------------------------------------------------------
# Byte classification for CFG tracing
# ---------------------------------------------------------------------------

CODE = 1
DATA = 0


# ===================================================================
#  Control Flow Graph Tracer
# ===================================================================

class FlowTracer(object):
    """
    Walk executable paths starting from one or more entry points to
    classify every byte in the binary as CODE or DATA.
    """

    def __init__(self, code, start_addr):
        self.code = code
        self.start_addr = start_addr
        self.end_addr = start_addr + len(code)
        # Per-byte classification: 0 = DATA (default), 1 = CODE
        self.byte_type = [DATA] * len(code)
        # Addresses we still need to explore
        self._work = deque()
        # Addresses we have already started tracing from
        self._visited = set()
        # Collected reference information
        self.jsr_targets = set()        # sub_XXXX
        self.jmp_targets = set()        # jmp_XXXX
        self.branch_targets = set()     # loc_XXXX
        self.data_refs = set()          # dat_XXXX
        # SMC: list of (writer_addr, target_addr)
        self.smc_writes = []

    # ----- helpers -----

    def _in_range(self, addr):
        return self.start_addr <= addr < self.end_addr

    def _offset(self, addr):
        return addr - self.start_addr

    def _read_byte(self, addr):
        off = self._offset(addr)
        if 0 <= off < len(self.code):
            return self.code[off]
        return None

    def _read_word(self, addr):
        lo = self._read_byte(addr)
        hi = self._read_byte(addr + 1)
        if lo is None or hi is None:
            return None
        return lo | (hi << 8)

    # ----- public API -----

    def add_entry(self, addr):
        """Queue an entry point for tracing."""
        if self._in_range(addr) and addr not in self._visited:
            self._work.append(addr)

    def trace(self):
        """Run the work-list algorithm until all reachable code is explored."""
        while self._work:
            pc = self._work.popleft()
            self._trace_block(pc)

    def _trace_block(self, pc):
        """Trace a single linear block of instructions."""
        while True:
            if pc in self._visited:
                return
            if not self._in_range(pc):
                return

            self._visited.add(pc)
            off = self._offset(pc)
            opbyte = self.code[off]

            if opbyte not in OPCODES:
                # Illegal / undocumented opcode -- stop tracing this path
                return

            mnem, mode, size = OPCODES[opbyte]

            # Make sure we have enough bytes
            if off + size > len(self.code):
                return

            # Mark these bytes as CODE
            for k in range(size):
                self.byte_type[off + k] = CODE

            # Read operand
            operand = None
            if size == 2:
                operand = self.code[off + 1]
            elif size == 3:
                operand = self.code[off + 1] | (self.code[off + 2] << 8)

            # ---- Collect references & queue successors ----

            if mode == "rel" and operand is not None:
                # Conditional branch
                if operand >= 128:
                    branch_offset = operand - 256
                else:
                    branch_offset = operand
                target = pc + 2 + branch_offset
                self.branch_targets.add(target)
                if self._in_range(target) and target not in self._visited:
                    self._work.append(target)
                # Fall through
                pc = pc + size
                continue

            if mnem == "JSR" and mode == "abs":
                self.jsr_targets.add(operand)
                if self._in_range(operand) and operand not in self._visited:
                    self._work.append(operand)
                # Fall through after JSR
                pc = pc + size
                continue

            if mnem == "JMP":
                if mode == "abs":
                    self.jmp_targets.add(operand)
                    if self._in_range(operand) and operand not in self._visited:
                        self._work.append(operand)
                # JMP (indirect) -- we cannot resolve the target statically
                # Either way, JMP does not fall through
                return

            if mnem in ("RTS", "RTI", "BRK"):
                return

            # ---- Track store targets for SMC detection ----
            if mnem in STORE_MNEMONICS and mode in STORE_ABS_MODES and operand is not None:
                if self._in_range(operand):
                    self.data_refs.add(operand)
                    # We record the write; SMC check happens after full trace
                    self.smc_writes.append((pc, operand))

            # ---- Track data references (loads from binary range) ----
            if mnem in ("LDA", "LDX", "LDY", "CMP", "CPX", "CPY",
                        "ADC", "SBC", "AND", "ORA", "EOR", "BIT",
                        "INC", "DEC", "ASL", "LSR", "ROL", "ROR"):
                if mode in ("abs",) and operand is not None:
                    if self._in_range(operand):
                        self.data_refs.add(operand)

            pc = pc + size

    def detect_smc(self):
        """
        After tracing, check each store-to-binary-range to see if it
        writes to an address currently classified as CODE.
        Returns list of (writer_addr, target_addr).
        """
        results = []
        for writer_addr, target_addr in self.smc_writes:
            off = self._offset(target_addr)
            if 0 <= off < len(self.byte_type) and self.byte_type[off] == CODE:
                results.append((writer_addr, target_addr))
        return results


# ===================================================================
#  Linear scanner (legacy mode, improved)
# ===================================================================

def linear_scan(code, start_addr):
    """
    Scan the entire binary linearly to collect branch/JSR/JMP targets.
    Returns (jsr_targets, jmp_targets, branch_targets).
    """
    jsr_targets = set()
    jmp_targets = set()
    branch_targets = set()

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
                jmp_targets.add(operand)
            pc += size
            i += size
        else:
            pc += 1
            i += 1
    return jsr_targets, jmp_targets, branch_targets


# ===================================================================
#  Label generation
# ===================================================================

def build_label_map(jsr_targets, jmp_targets, branch_targets, data_refs):
    """
    Build addr -> label string mapping with contextual prefixes.
    Priority: sub_ > jmp_ > loc_ > dat_
    """
    labels = {}
    for addr in data_refs:
        labels[addr] = "dat_{0:04X}".format(addr)
    for addr in branch_targets:
        labels[addr] = "loc_{0:04X}".format(addr)
    for addr in jmp_targets:
        labels[addr] = "jmp_{0:04X}".format(addr)
    for addr in jsr_targets:
        labels[addr] = "sub_{0:04X}".format(addr)
    return labels


# ===================================================================
#  Operand formatting
# ===================================================================

def format_operand(mode, operand, pc, labels):
    """Format operand based on addressing mode, using labels when available."""
    if mode == "imp":
        return ""
    elif mode == "acc":
        return "A"
    elif mode == "imm":
        return "#${0:02X}".format(operand)
    elif mode == "zp":
        lbl = labels.get(operand)
        if lbl:
            return "{0}".format(lbl)
        return "${0:02X}".format(operand)
    elif mode == "zpx":
        lbl = labels.get(operand)
        if lbl:
            return "{0},X".format(lbl)
        return "${0:02X},X".format(operand)
    elif mode == "zpy":
        lbl = labels.get(operand)
        if lbl:
            return "{0},Y".format(lbl)
        return "${0:02X},Y".format(operand)
    elif mode == "abs":
        hw = HARDWARE.get(operand, "")
        lbl = labels.get(operand)
        name = lbl if lbl else "${0:04X}".format(operand)
        if hw:
            return "{0}  ; {1}".format(name, hw)
        return name
    elif mode == "absx":
        hw = HARDWARE.get(operand, "")
        lbl = labels.get(operand)
        name = lbl if lbl else "${0:04X}".format(operand)
        if hw:
            return "{0},X  ; {1}".format(name, hw)
        return "{0},X".format(name)
    elif mode == "absy":
        hw = HARDWARE.get(operand, "")
        lbl = labels.get(operand)
        name = lbl if lbl else "${0:04X}".format(operand)
        if hw:
            return "{0},Y  ; {1}".format(name, hw)
        return "{0},Y".format(name)
    elif mode == "ind":
        lbl = labels.get(operand)
        name = lbl if lbl else "${0:04X}".format(operand)
        return "({0})".format(name)
    elif mode == "indx":
        return "(${0:02X},X)".format(operand)
    elif mode == "indy":
        return "(${0:02X}),Y".format(operand)
    elif mode == "rel":
        if operand >= 128:
            offset = operand - 256
        else:
            offset = operand
        target = pc + 2 + offset
        lbl = labels.get(target)
        if lbl:
            return lbl
        return "${0:04X}".format(target)
    return "${0:04X}".format(operand)


# ===================================================================
#  Data region analysis helpers
# ===================================================================

def _is_printable(b, allow_high_bit):
    """Check if a byte is a printable ASCII character."""
    if allow_high_bit:
        ch = b & 0x7F
    else:
        ch = b
    return 0x20 <= ch <= 0x7E

def find_strings_in_region(code, region_start_off, region_len, min_len=4):
    """
    Find ASCII string runs within a data region.
    Returns list of (offset_within_region, text, is_high_bit).
    Checks both normal and high-bit ASCII.
    """
    results = []
    end = region_start_off + region_len

    for high_bit in (True, False):
        i = region_start_off
        while i < end:
            if _is_printable(code[i], high_bit):
                start = i
                chars = []
                while i < end and _is_printable(code[i], high_bit):
                    ch = code[i] & 0x7F if high_bit else code[i]
                    chars.append(chr(ch))
                    i += 1
                if len(chars) >= min_len:
                    text = ''.join(chars)
                    results.append((start - region_start_off, text, high_bit))
            else:
                i += 1

    # Deduplicate: if a region is found in both high-bit and normal, keep
    # high-bit version only if the raw bytes actually have the high bit set.
    # Simple approach: sort by offset, prefer high-bit when they overlap.
    results.sort(key=lambda r: (r[0], 0 if r[2] else 1))
    seen_offsets = set()
    filtered = []
    for off, text, hb in results:
        span = set(range(off, off + len(text)))
        if span & seen_offsets:
            continue
        # For high-bit match, verify at least one byte actually has high bit set
        if hb:
            actual_off = region_start_off + off
            if not any(code[actual_off + k] & 0x80 for k in range(len(text))):
                continue
        filtered.append((off, text, hb))
        seen_offsets.update(span)
    return filtered


def detect_pointer_table(code, region_start_off, region_len, start_addr, end_addr):
    """
    Look for runs of 16-bit little-endian values that all point within
    the binary address range.  Returns list of (offset_within_region, [addrs]).
    A pointer table must have at least 3 consecutive pointers.
    """
    MIN_PTRS = 3
    results = []
    i = 0
    while i + 1 < region_len:
        abs_off = region_start_off + i
        ptrs = []
        j = i
        while j + 1 < region_len:
            lo = code[region_start_off + j]
            hi = code[region_start_off + j + 1]
            val = lo | (hi << 8)
            if start_addr <= val < end_addr:
                ptrs.append(val)
                j += 2
            else:
                break
        if len(ptrs) >= MIN_PTRS:
            results.append((i, ptrs))
            i = j
        else:
            i += 1
    return results


# ===================================================================
#  Data region emitter
# ===================================================================

def emit_data_region(code, start_off, length, base_addr, labels, bin_start, bin_end):
    """
    Emit .BYTE / .ASC / .WORD lines for a data region.
    Tries to detect strings and pointer tables for nicer output.
    """
    lines = []
    region_addr = base_addr + start_off

    # Detect strings
    str_runs = find_strings_in_region(code, start_off, length)
    # Detect pointer tables
    ptr_tables = detect_pointer_table(code, start_off, length, bin_start, bin_end)

    # Build a set of offsets covered by special regions
    special = {}  # offset_within_region -> ("str", ...) or ("ptr", ...)
    for off, text, hb in str_runs:
        for k in range(len(text)):
            special[off + k] = ("str", off, text, hb)
    for off, ptrs in ptr_tables:
        for k in range(len(ptrs) * 2):
            special[off + k] = ("ptr", off, ptrs)

    i = 0
    while i < length:
        addr = base_addr + start_off + i

        # Check for label
        lbl = labels.get(addr)
        if lbl:
            lines.append("{0}:".format(lbl))

        if i in special:
            tag = special[i]
            if tag[0] == "str" and tag[1] == i:
                _, _, text, hb = tag
                hb_marker = " (high-bit)" if hb else ""
                lines.append('    ${0:04X}:             .ASC "{1}"{2}'.format(
                    addr, text, hb_marker))
                i += len(text)
                continue
            elif tag[0] == "ptr" and tag[1] == i:
                _, _, ptrs = tag
                ptr_strs = []
                for p in ptrs:
                    plbl = labels.get(p)
                    ptr_strs.append(plbl if plbl else "${0:04X}".format(p))
                lines.append("    ${0:04X}:             .WORD {1}  ; pointer table".format(
                    addr, ", ".join(ptr_strs)))
                i += len(ptrs) * 2
                continue
            # If we are inside a special region but not at its start, just
            # skip forward (the start emitted it already).
            # This shouldn't normally happen because we jump past them above.

        # Default: emit .BYTE, 16 per line
        chunk_end = i
        while chunk_end < length and chunk_end < i + 16:
            if chunk_end in special and special[chunk_end][1] == chunk_end:
                break
            # Also break if there is a label at this address
            if chunk_end != i and labels.get(base_addr + start_off + chunk_end):
                break
            chunk_end += 1

        if chunk_end == i:
            chunk_end = i + 1  # safety: always advance

        byte_vals = code[start_off + i : start_off + chunk_end]
        hex_str = ", ".join("${0:02X}".format(b) for b in byte_vals)
        lines.append("    ${0:04X}:             .BYTE {1}".format(addr, hex_str))
        i = chunk_end

    return lines


# ===================================================================
#  Main disassembly output
# ===================================================================

def disassemble_with_cfg(code, start_addr, byte_type, labels, smc_set):
    """
    Produce final disassembly lines using the byte classification from
    the flow tracer.  CODE bytes are disassembled; DATA bytes are emitted
    as .BYTE / .ASC etc.

    smc_set: set of (writer_addr, target_addr) for SMC annotation.
    """
    lines = []
    end_addr = start_addr + len(code)
    smc_writers = {}   # writer_addr -> target_addr
    smc_targets = set()
    for w, t in smc_set:
        smc_writers[w] = t
        smc_targets.add(t)

    i = 0
    while i < len(code):
        pc = start_addr + i

        if byte_type[i] == DATA:
            # Gather contiguous DATA region
            data_start = i
            while i < len(code) and byte_type[i] == DATA:
                i += 1
            data_len = i - data_start
            data_lines = emit_data_region(
                code, data_start, data_len, start_addr, labels,
                start_addr, end_addr)
            lines.extend(data_lines)
            continue

        # CODE byte
        # Label?
        lbl = labels.get(pc)
        if lbl:
            lines.append("")
            lines.append("{0}:".format(lbl))

        opbyte = code[i]
        if opbyte not in OPCODES:
            # Should not happen if tracer is correct, but handle gracefully
            lines.append("    ${0:04X}: {1:02X}          .BYTE ${1:02X}  ; unreachable?".format(pc, opbyte))
            i += 1
            continue

        mnem, mode, size = OPCODES[opbyte]

        # Build hex byte string
        if size == 1:
            operand = None
            hex_bytes = "{0:02X}".format(opbyte)
        elif size == 2:
            if i + 1 < len(code):
                operand = code[i + 1]
                hex_bytes = "{0:02X} {1:02X}".format(opbyte, operand)
            else:
                operand = 0
                hex_bytes = "{0:02X} ??".format(opbyte)
        else:
            if i + 2 < len(code):
                operand = code[i + 1] | (code[i + 2] << 8)
                hex_bytes = "{0:02X} {1:02X} {2:02X}".format(opbyte, code[i + 1], code[i + 2])
            else:
                operand = 0
                hex_bytes = "{0:02X} ?? ??".format(opbyte)

        if operand is not None:
            operand_str = format_operand(mode, operand, pc, labels)
        else:
            operand_str = ""

        # SMC annotation for the writer instruction
        smc_comment = ""
        if pc in smc_writers:
            smc_comment = "  ; !!! SELF-MODIFYING: writes to code at ${0:04X}".format(
                smc_writers[pc])

        # SMC annotation for the target (the byte being overwritten)
        if pc in smc_targets:
            smc_comment += "  ; !!! SMC TARGET: modified at runtime"

        lines.append("    ${0:04X}: {1:10s}  {2:4s} {3}{4}".format(
            pc, hex_bytes, mnem, operand_str, smc_comment))

        i += size

    return lines


def disassemble_linear(code, start_addr, labels, smc_set):
    """
    Legacy linear disassembly (all bytes treated as potential code).
    """
    lines = []
    smc_writers = {}
    for w, t in smc_set:
        smc_writers[w] = t

    i = 0
    pc = start_addr
    while i < len(code):
        lbl = labels.get(pc)
        if lbl:
            lines.append("")
            lines.append("{0}:".format(lbl))

        byte = code[i]
        if byte in OPCODES:
            mnem, mode, size = OPCODES[byte]

            if size == 1:
                operand = None
                hex_bytes = "{0:02X}".format(byte)
            elif size == 2:
                if i + 1 < len(code):
                    operand = code[i + 1]
                    hex_bytes = "{0:02X} {1:02X}".format(byte, operand)
                else:
                    operand = 0
                    hex_bytes = "{0:02X} ??".format(byte)
            else:
                if i + 2 < len(code):
                    operand = code[i + 1] | (code[i + 2] << 8)
                    hex_bytes = "{0:02X} {1:02X} {2:02X}".format(byte, code[i + 1], code[i + 2])
                else:
                    operand = 0
                    hex_bytes = "{0:02X} ?? ??".format(byte)

            if operand is not None:
                operand_str = format_operand(mode, operand, pc, labels)
            else:
                operand_str = ""

            smc_comment = ""
            if pc in smc_writers:
                smc_comment = "  ; !!! SELF-MODIFYING: writes to code at ${0:04X}".format(
                    smc_writers[pc])

            lines.append("    ${0:04X}: {1:10s}  {2:4s} {3}{4}".format(
                pc, hex_bytes, mnem, operand_str, smc_comment))
            pc += size
            i += size
        else:
            lines.append("    ${0:04X}: {1:02X}          .BYTE ${1:02X}".format(pc, byte))
            pc += 1
            i += 1

    return lines


# ===================================================================
#  String finder (top-level, for header summary)
# ===================================================================

def find_strings(code, start_addr, min_len=4):
    """Find potential text strings (Apple II high-bit ASCII and normal)."""
    strings = []

    for high_bit in (True, False):
        i = 0
        while i < len(code):
            if _is_printable(code[i], high_bit):
                start = i
                chars = []
                while i < len(code) and _is_printable(code[i], high_bit):
                    ch = code[i] & 0x7F if high_bit else code[i]
                    chars.append(chr(ch))
                    i += 1
                if len(chars) >= min_len:
                    text = ''.join(chars)
                    # For high-bit, verify at least one byte has the bit set
                    if high_bit:
                        if any(code[start + k] & 0x80 for k in range(len(text))):
                            strings.append((start_addr + start, text, True))
                    else:
                        strings.append((start_addr + start, text, False))
            else:
                i += 1

    # Deduplicate overlapping runs: prefer high-bit
    strings.sort(key=lambda s: (s[0], 0 if s[2] else 1))
    seen = set()
    filtered = []
    for addr, text, hb in strings:
        span = set(range(addr, addr + len(text)))
        if span & seen:
            continue
        filtered.append((addr, text, hb))
        seen.update(span)

    return filtered


# ===================================================================
#  Argument parsing
# ===================================================================

def parse_args():
    parser = argparse.ArgumentParser(
        description="6502 Disassembler for Apple II binaries",
        epilog="Example: python disasm6502.py game.bin 0x0800 --entry 0x0900"
    )
    parser.add_argument("input", help="Binary file to disassemble")
    parser.add_argument("load_address", nargs="?", default="0x0800",
                        help="Load address in hex (default: 0x0800)")
    parser.add_argument("--entry", action="append", default=None,
                        help="Entry point address in hex (can be specified "
                             "multiple times; default: load address)")
    parser.add_argument("--linear", action="store_true",
                        help="Use linear disassembly instead of flow tracing")
    parser.add_argument("--smc", action="store_true", default=True,
                        help="Enable self-modifying code detection "
                             "(on by default with flow tracing)")
    parser.add_argument("--no-smc", action="store_true",
                        help="Disable self-modifying code detection")
    return parser.parse_args()


# ===================================================================
#  Main
# ===================================================================

def main():
    args = parse_args()

    bin_path = Path(args.input)
    if not bin_path.exists():
        print("Error: file not found: {0}".format(bin_path), file=sys.stderr)
        sys.exit(1)

    with open(bin_path, 'rb') as f:
        code = f.read()

    if not code:
        print("Error: file is empty", file=sys.stderr)
        sys.exit(1)

    start_addr = int(args.load_address, 16)
    end_addr = start_addr + len(code)

    # Determine entry points
    entry_points = []
    if args.entry:
        for e in args.entry:
            entry_points.append(int(e, 16))
    else:
        entry_points.append(start_addr)

    enable_smc = not args.no_smc

    # ---- Header ----
    print("; Disassembly of {0}".format(bin_path.name))
    print("; Load address: ${0:04X}".format(start_addr))
    print("; Length: {0} bytes (${0:04X})".format(len(code)))
    print("; End address: ${0:04X}".format(end_addr - 1))
    if not args.linear:
        ep_strs = ", ".join("${0:04X}".format(e) for e in entry_points)
        print("; Mode: control flow tracing from {0}".format(ep_strs))
    else:
        print("; Mode: linear disassembly")

    # ---- Perform analysis ----
    smc_results = []

    if not args.linear:
        # --- CFG tracing ---
        tracer = FlowTracer(code, start_addr)
        for ep in entry_points:
            tracer.add_entry(ep)
        tracer.trace()

        jsr_targets = tracer.jsr_targets
        jmp_targets = tracer.jmp_targets
        branch_targets = tracer.branch_targets
        data_refs = tracer.data_refs
        byte_type = tracer.byte_type

        if enable_smc:
            smc_results = tracer.detect_smc()

        # Also run linear scan to catch any targets the tracer might
        # reference but not trace (e.g. targets outside binary).
        # We only use its target sets for labelling, not for classifying.
        lin_jsr, lin_jmp, lin_branch = linear_scan(code, start_addr)
        # Merge (tracer targets take priority for classification)
        jsr_targets = jsr_targets | lin_jsr
        jmp_targets = jmp_targets | lin_jmp
        branch_targets = branch_targets | lin_branch

    else:
        # --- Linear mode ---
        jsr_targets, jmp_targets, branch_targets = linear_scan(code, start_addr)
        data_refs = set()
        byte_type = None

        if enable_smc:
            # Quick SMC scan in linear mode
            i = 0
            pc = start_addr
            while i < len(code):
                b = code[i]
                if b in OPCODES:
                    mnem, mode, size = OPCODES[b]
                    if mnem in STORE_MNEMONICS and mode in STORE_ABS_MODES and size <= len(code) - i:
                        if size == 2:
                            operand = code[i + 1]
                        else:
                            operand = code[i + 1] | (code[i + 2] << 8)
                        if start_addr <= operand < end_addr:
                            data_refs.add(operand)
                            smc_results.append((pc, operand))
                    pc += size
                    i += size
                else:
                    pc += 1
                    i += 1

    # Build labels
    labels = build_label_map(jsr_targets, jmp_targets, branch_targets, data_refs)

    # ---- SMC summary ----
    if enable_smc and smc_results:
        print("; Self-modifying code detected: {0} locations".format(len(smc_results)))
        for writer, target in sorted(smc_results):
            print(";   ${0:04X} writes to code at ${1:04X}".format(writer, target))
    print()

    # ---- Strings summary ----
    strings = find_strings(code, start_addr)
    if strings:
        print("; Strings found:")
        for addr, text, hb in strings:
            hb_tag = " [high-bit]" if hb else ""
            print(';   ${0:04X}: "{1}"{2}'.format(addr, text, hb_tag))
        print()

    # ---- Code statistics (CFG mode) ----
    if byte_type is not None:
        code_bytes = sum(1 for b in byte_type if b == CODE)
        data_bytes = len(byte_type) - code_bytes
        print("; Classification: {0} bytes code, {1} bytes data".format(
            code_bytes, data_bytes))
        print()

    # ---- Emit disassembly ----
    smc_set = set((w, t) for w, t in smc_results) if enable_smc else set()

    if not args.linear and byte_type is not None:
        output = disassemble_with_cfg(code, start_addr, byte_type, labels, smc_set)
    else:
        output = disassemble_linear(code, start_addr, labels, smc_set)

    for line in output:
        print(line)


if __name__ == '__main__':
    main()

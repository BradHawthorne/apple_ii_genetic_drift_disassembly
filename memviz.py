#!/usr/bin/env python3
"""
6502 Memory Access Pattern Visualizer for Apple II binaries

Analyzes a 6502 binary and produces memory access pattern visualizations
including text reports, HTML heatmaps, and CSV exports.

Cowritten by Claude Code Opus 4.6
"""

import sys
import argparse
import html as html_module
from collections import defaultdict
from pathlib import Path

# ---------------------------------------------------------------------------
# 6502 opcode table: opcode -> (mnemonic, addressing_mode, size)
# Identical to disasm6502.py
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

# Instructions that read from a memory operand
READ_MNEMONICS = {
    "ADC", "AND", "BIT", "CMP", "CPX", "CPY", "EOR", "LDA", "LDX", "LDY",
    "ORA", "SBC",
}

# Instructions that write to a memory operand
WRITE_MNEMONICS = {
    "STA", "STX", "STY",
}

# Instructions that read-modify-write a memory operand
RMW_MNEMONICS = {
    "ASL", "DEC", "INC", "LSR", "ROL", "ROR",
}

# Branch / jump mnemonics
BRANCH_MNEMONICS = {"BCC", "BCS", "BEQ", "BMI", "BNE", "BPL", "BVC", "BVS"}
UNCONDITIONAL_FLOW = {"JMP", "RTS", "RTI", "BRK"}

# ---------------------------------------------------------------------------
# Apple II hardware addresses (expanded from disasm6502.py)
# ---------------------------------------------------------------------------
HARDWARE = {
    # Keyboard
    0xC000: "KEYBOARD",
    0xC010: "KBDSTRB",
    # Tape / speaker
    0xC020: "TAPEOUT",
    0xC030: "SPKR",
    # Graphics soft switches
    0xC050: "TXTCLR",
    0xC051: "TXTSET",
    0xC052: "MIXCLR",
    0xC053: "MIXSET",
    0xC054: "LOWSCR",
    0xC055: "HISCR",
    0xC056: "LORES",
    0xC057: "HIRES",
    # Annunciators
    0xC058: "AN0OFF",
    0xC059: "AN0ON",
    0xC05A: "AN1OFF",
    0xC05B: "AN1ON",
    0xC05C: "AN2OFF",
    0xC05D: "AN2ON",
    0xC05E: "AN3OFF",
    0xC05F: "AN3ON",
    # Game I/O
    0xC060: "TAPEIN",
    0xC061: "PB0",
    0xC062: "PB1",
    0xC063: "PB2",
    0xC064: "PADDL0",
    0xC065: "PADDL1",
    0xC066: "PADDL2",
    0xC067: "PADDL3",
    0xC070: "PTRIG",
    # Language Card (bank-switched RAM)
    0xC080: "LCBANK2_RE",
    0xC081: "LCBANK2_RW",
    0xC082: "LCROM_ONLY",
    0xC083: "LCBANK2_RW2",
    0xC088: "LCBANK1_RE",
    0xC089: "LCBANK1_RW",
    0xC08A: "LCROM_ONLY1",
    0xC08B: "LCBANK1_RW2",
    # Slot I/O
    0xC0E0: "DISK_PHASE0_OFF",
    0xC0E1: "DISK_PHASE0_ON",
    0xC0E2: "DISK_PHASE1_OFF",
    0xC0E3: "DISK_PHASE1_ON",
    0xC0E4: "DISK_PHASE2_OFF",
    0xC0E5: "DISK_PHASE2_ON",
    0xC0E6: "DISK_PHASE3_OFF",
    0xC0E7: "DISK_PHASE3_ON",
    0xC0E8: "DISK_MOTOR_OFF",
    0xC0E9: "DISK_MOTOR_ON",
    0xC0EA: "DISK_SEL_DRV1",
    0xC0EB: "DISK_SEL_DRV2",
    0xC0EC: "DISK_READ",
    0xC0ED: "DISK_WRITE",
    0xC0EE: "DISK_RDMODE",
    0xC0EF: "DISK_WRMODE",
    # IIe-specific
    0xC00C: "80COLOFF",
    0xC00D: "80COLON",
    0xC00E: "ALTCHAROFF",
    0xC00F: "ALTCHARON",
    0xC001: "80STOREON",
    0xC002: "RDMAINRAM",
    0xC003: "RDCARDRAM",
    0xC004: "WRMAINRAM",
    0xC005: "WRCARDRAM",
}

# Well-known zero-page locations on Apple II
ZP_NAMES = {
    0x00: "LOMEM (BASIC)",
    0x01: "LOMEM+1",
    0x03: "HIMEM (BASIC)",
    0x04: "HIMEM+1",
    0x06: "LINNUM",
    0x07: "LINNUM+1",
    0x09: "TXTTAB",
    0x0A: "TXTTAB+1",
    0x20: "WNDLFT",
    0x21: "WNDWDTH",
    0x22: "WNDTOP",
    0x23: "WNDBTM",
    0x24: "CH (cursor H)",
    0x25: "CV (cursor V)",
    0x26: "BASL",
    0x27: "BASH",
    0x28: "BAS2L",
    0x29: "BAS2H",
    0x2B: "BOOTSLOT",
    0x30: "COLOR (lo-res)",
    0x33: "PROMPT",
    0x36: "CSWL",
    0x37: "CSWH",
    0x38: "KSWL",
    0x39: "KSWH",
    0x3C: "A1L",
    0x3D: "A1H",
    0x3E: "A2L",
    0x3F: "A2H",
    0x42: "A4L",
    0x43: "A4H",
    0x45: "ACC (monitor)",
    0x46: "XREG (monitor)",
    0x47: "YREG (monitor)",
    0x48: "STATUS (monitor)",
    0x4E: "RNDL",
    0x4F: "RNDH",
}


# ---------------------------------------------------------------------------
# Per-address access record
# ---------------------------------------------------------------------------
class AddrInfo:
    """Tracks access counts and metadata for a single address."""
    __slots__ = ("read_count", "write_count", "exec_count",
                 "is_code", "callers", "notes")

    def __init__(self):
        self.read_count = 0
        self.write_count = 0
        self.exec_count = 0
        self.is_code = False
        self.callers = set()   # addresses that reference this location
        self.notes = []

    @property
    def total(self):
        return self.read_count + self.write_count + self.exec_count

    def type_str(self):
        if self.is_code:
            return "code"
        if self.read_count or self.write_count:
            return "data"
        return "unknown"

    def rw_str(self):
        r = "R" if self.read_count else ""
        w = "W" if self.write_count else ""
        return r + w if (r or w) else "-"


# ---------------------------------------------------------------------------
# Core analysis engine
# ---------------------------------------------------------------------------
class MemoryAnalyzer:
    """Analyze 6502 binary for memory access patterns."""

    def __init__(self, code, load_addr):
        self.code = code
        self.load_addr = load_addr
        self.end_addr = load_addr + len(code) - 1
        self.info = defaultdict(AddrInfo)
        self.subroutines = set()    # JSR targets
        self.branch_targets = set()

    # -- helpers -----------------------------------------------------------

    def _addr_to_offset(self, addr):
        """Convert an address to an offset into self.code, or -1."""
        off = addr - self.load_addr
        if 0 <= off < len(self.code):
            return off
        return -1

    def _record_exec(self, addr, size):
        """Mark *size* bytes starting at *addr* as executed code."""
        for a in range(addr, addr + size):
            info = self.info[a]
            info.exec_count += 1
            info.is_code = True

    def _record_read(self, target_addr, from_addr):
        info = self.info[target_addr]
        info.read_count += 1
        info.callers.add(from_addr)

    def _record_write(self, target_addr, from_addr):
        info = self.info[target_addr]
        info.write_count += 1
        info.callers.add(from_addr)

    def _record_rmw(self, target_addr, from_addr):
        info = self.info[target_addr]
        info.read_count += 1
        info.write_count += 1
        info.callers.add(from_addr)

    # -- operand target resolution ----------------------------------------

    @staticmethod
    def _resolve_operand(mode, raw_operand, pc):
        """Return (target_address, pointer_address_or_None).

        For indirect modes the *pointer_address* is the zero-page location
        holding the pointer; the actual target is unknowable statically, but
        we still want to record the pointer read.
        """
        if mode in ("zp", "zpx", "zpy"):
            return raw_operand, None
        if mode in ("abs", "absx", "absy"):
            return raw_operand, None
        if mode == "indx":
            # (zp,X) -- pointer at zp+X, target unknown
            return None, raw_operand
        if mode == "indy":
            # (zp),Y -- pointer at zp, target unknown
            return None, raw_operand
        if mode == "ind":
            # JMP (abs) -- pointer at abs16
            return None, raw_operand
        return None, None

    # -- linear scan -------------------------------------------------------

    def analyze_linear(self):
        """Linear disassembly scan -- assume everything is potentially code."""
        i = 0
        pc = self.load_addr
        while i < len(self.code):
            byte = self.code[i]
            if byte not in OPCODES:
                pc += 1
                i += 1
                continue

            mnem, mode, size = OPCODES[byte]

            # bounds check
            if i + size > len(self.code):
                pc += 1
                i += 1
                continue

            # Mark instruction bytes as executed
            self._record_exec(pc, size)

            # Decode operand
            if size == 2:
                raw_operand = self.code[i + 1]
            elif size == 3:
                raw_operand = self.code[i + 1] | (self.code[i + 2] << 8)
            else:
                raw_operand = None

            # Track branches / jumps
            if mode == "rel" and raw_operand is not None:
                offset = raw_operand - 256 if raw_operand >= 128 else raw_operand
                target = pc + 2 + offset
                self.branch_targets.add(target)
            elif mnem == "JSR" and raw_operand is not None:
                self.subroutines.add(raw_operand)
            elif mnem == "JMP" and mode == "abs" and raw_operand is not None:
                self.branch_targets.add(raw_operand)

            # Record memory accesses
            if raw_operand is not None and mode not in ("imm", "rel", "acc", "imp"):
                target, pointer = self._resolve_operand(mode, raw_operand, pc)

                if pointer is not None:
                    # Indirect: read the pointer location (and ptr+1 for 16-bit)
                    self._record_read(pointer, pc)
                    if pointer < 0x100:
                        self._record_read(pointer + 1, pc)

                if target is not None:
                    if mnem in READ_MNEMONICS:
                        self._record_read(target, pc)
                    elif mnem in WRITE_MNEMONICS:
                        self._record_write(target, pc)
                    elif mnem in RMW_MNEMONICS:
                        self._record_rmw(target, pc)
                    elif mnem == "JSR":
                        self._record_read(target, pc)
                    elif mnem == "JMP":
                        self._record_read(target, pc)
                    elif mnem == "BIT":
                        self._record_read(target, pc)

            pc += size
            i += size

    # -- flow-based analysis -----------------------------------------------

    def analyze_flow(self, entry):
        """Trace execution flow from *entry* to identify reachable code."""
        visited = set()
        worklist = [entry]

        while worklist:
            pc = worklist.pop()
            if pc in visited:
                continue

            # Walk the basic block starting at pc
            while pc not in visited:
                visited.add(pc)
                off = self._addr_to_offset(pc)
                if off < 0:
                    break

                byte = self.code[off]
                if byte not in OPCODES:
                    break

                mnem, mode, size = OPCODES[byte]
                if off + size > len(self.code):
                    break

                # Mark as executed
                self._record_exec(pc, size)

                # Decode operand
                if size == 2:
                    raw_operand = self.code[off + 1]
                elif size == 3:
                    raw_operand = self.code[off + 1] | (self.code[off + 2] << 8)
                else:
                    raw_operand = None

                # Record memory accesses for non-flow operands
                if raw_operand is not None and mode not in ("imm", "rel", "acc", "imp"):
                    target, pointer = self._resolve_operand(mode, raw_operand, pc)
                    if pointer is not None:
                        self._record_read(pointer, pc)
                        if pointer < 0x100:
                            self._record_read(pointer + 1, pc)
                    if target is not None:
                        if mnem in READ_MNEMONICS:
                            self._record_read(target, pc)
                        elif mnem in WRITE_MNEMONICS:
                            self._record_write(target, pc)
                        elif mnem in RMW_MNEMONICS:
                            self._record_rmw(target, pc)
                        elif mnem in ("JSR", "JMP", "BIT"):
                            self._record_read(target, pc)

                # Handle control flow
                if mode == "rel" and raw_operand is not None:
                    offset = raw_operand - 256 if raw_operand >= 128 else raw_operand
                    branch_target = pc + 2 + offset
                    self.branch_targets.add(branch_target)
                    worklist.append(branch_target)
                    # conditional branches also fall through
                    pc += size
                    continue

                if mnem == "JSR" and raw_operand is not None:
                    self.subroutines.add(raw_operand)
                    worklist.append(raw_operand)
                    # fall through after return
                    pc += size
                    continue

                if mnem == "JMP":
                    if mode == "abs" and raw_operand is not None:
                        self.branch_targets.add(raw_operand)
                        worklist.append(raw_operand)
                    # indirect JMP -- target unknown, stop tracing this path
                    break

                if mnem in ("RTS", "RTI", "BRK"):
                    break

                pc += size

    # -- region detection --------------------------------------------------

    def build_regions(self):
        """Return sorted list of (start, end, type, details) regions."""
        if not self.info:
            return []

        # Gather all addresses in the binary range that have info
        addrs = set()
        for a in range(self.load_addr, self.end_addr + 1):
            addrs.add(a)

        regions = []
        sorted_addrs = sorted(addrs)
        if not sorted_addrs:
            return regions

        cur_start = sorted_addrs[0]
        cur_type = self.info[cur_start].type_str()

        for a in sorted_addrs[1:]:
            t = self.info[a].type_str()
            if t != cur_type:
                regions.append((cur_start, a - 1, cur_type))
                cur_start = a
                cur_type = t
        regions.append((cur_start, sorted_addrs[-1], cur_type))
        return regions

    # -- hotspot detection -------------------------------------------------

    def top_hot_code(self, n=20):
        """Return top *n* addresses by exec_count, only code addresses."""
        code_addrs = [(a, inf) for a, inf in self.info.items()
                      if inf.is_code and inf.exec_count > 0]
        code_addrs.sort(key=lambda x: x[1].exec_count, reverse=True)
        return code_addrs[:n]

    # -- zero-page summary -------------------------------------------------

    def zp_summary(self):
        """Return list of (addr, info) for accessed zero-page locations."""
        result = []
        for a in range(0x00, 0x100):
            inf = self.info.get(a)
            if inf and (inf.read_count or inf.write_count):
                result.append((a, inf))
        return result

    # -- I/O summary -------------------------------------------------------

    def io_summary(self):
        """Return list of (addr, hw_name, info) for accessed I/O."""
        result = []
        for a in range(0xC000, 0xC100):
            inf = self.info.get(a)
            if inf and (inf.read_count or inf.write_count):
                name = HARDWARE.get(a, "UNKNOWN_IO")
                result.append((a, name, inf))
        return result


# ---------------------------------------------------------------------------
# Output: Text report
# ---------------------------------------------------------------------------
def report_text(analyzer, filename):
    """Print a text report to stdout."""
    code = analyzer.code
    load = analyzer.load_addr

    print("=" * 68)
    print("Memory Access Analysis: {}".format(filename))
    print("Load address: ${:04X}, Size: {} bytes".format(load, len(code)))
    print("=" * 68)

    # -- Zero Page --
    zp = analyzer.zp_summary()
    if zp:
        print()
        print("=== Zero Page Usage ===")
        # Coalesce consecutive addresses that look like pointers
        i = 0
        while i < len(zp):
            addr, inf = zp[i]
            # Check if this and next byte form a pointer pair
            if (i + 1 < len(zp) and zp[i + 1][0] == addr + 1):
                addr2, inf2 = zp[i + 1]
                total_r = inf.read_count + inf2.read_count
                total_w = inf.write_count + inf2.write_count
                note = ZP_NAMES.get(addr, "")
                pointer_tag = " - pointer" if total_r >= 2 else ""
                if note:
                    pointer_tag = " - " + note
                has_r = inf.read_count or inf2.read_count
                has_w = inf.write_count or inf2.write_count
                rw = ("R" if has_r else "") + ("W" if has_w else "") or "-"
                print("${:02X}-${:02X} : {:3s} ({} reads, {} writes){}".format(
                    addr, addr2, rw,
                    total_r, total_w, pointer_tag
                ))
                i += 2
            else:
                note = ZP_NAMES.get(addr, "")
                tag = " - " + note if note else ""
                print("${:02X}     : {:3s} ({} reads, {} writes){}".format(
                    addr, inf.rw_str(), inf.read_count, inf.write_count, tag
                ))
                i += 1

    # -- I/O Registers --
    io = analyzer.io_summary()
    if io:
        print()
        print("=== I/O Registers Accessed ===")
        for addr, name, inf in io:
            parts = []
            if inf.read_count:
                parts.append("{} reads".format(inf.read_count))
            if inf.write_count:
                parts.append("{} writes".format(inf.write_count))
            print("${:04X} {:20s} : {}".format(addr, name, ", ".join(parts)))

    # -- Memory Map --
    regions = analyzer.build_regions()
    if regions:
        print()
        print("=== Memory Map ===")
        for start, end, rtype in regions:
            size = end - start + 1
            detail = ""
            if rtype == "code":
                # Count total exec and callers for the region
                total_exec = sum(analyzer.info[a].exec_count
                                 for a in range(start, end + 1))
                all_callers = set()
                for a in range(start, end + 1):
                    all_callers.update(analyzer.info[a].callers)
                if total_exec > 50:
                    detail = " (hot: {} executions, called from {} locations)".format(
                        total_exec, len(all_callers))
                elif all_callers:
                    detail = " (called from {} locations)".format(len(all_callers))
            elif rtype == "data":
                total_r = sum(analyzer.info[a].read_count
                              for a in range(start, end + 1))
                total_w = sum(analyzer.info[a].write_count
                              for a in range(start, end + 1))
                parts = []
                if total_r:
                    parts.append("{} reads".format(total_r))
                if total_w:
                    parts.append("{} writes".format(total_w))
                if size > 16:
                    parts.append("{}-byte block".format(size))
                if parts:
                    detail = " ({})".format(", ".join(parts))

            print("${:04X}-${:04X} : {:7s} [{:5d} bytes]{}".format(
                start, end, rtype.upper(), size, detail))

    # -- Top Hot Addresses --
    hot = analyzer.top_hot_code(20)
    if hot:
        print()
        print("=== Top {} Hottest Code Addresses ===".format(len(hot)))
        for addr, inf in hot:
            sub_tag = " (subroutine entry)" if addr in analyzer.subroutines else ""
            br_tag = " (branch target)" if addr in analyzer.branch_targets else ""
            print("${:04X} : {} estimated executions{}{}".format(
                addr, inf.exec_count, sub_tag, br_tag))

    # -- Statistics --
    total_code = sum(1 for a in analyzer.info.values() if a.is_code)
    total_data = sum(1 for a in analyzer.info.values()
                     if not a.is_code and (a.read_count or a.write_count))
    print()
    print("=== Statistics ===")
    print("Code bytes:    {}".format(total_code))
    print("Data refs:     {}".format(total_data))
    print("Subroutines:   {}".format(len(analyzer.subroutines)))
    print("Branch targets:{}".format(len(analyzer.branch_targets)))


# ---------------------------------------------------------------------------
# Output: CSV export
# ---------------------------------------------------------------------------
def export_csv(analyzer, csv_path):
    """Write one row per address in the binary range."""
    with open(csv_path, "w") as f:
        f.write("address,type,read_count,write_count,exec_count,notes\n")
        for addr in range(analyzer.load_addr, analyzer.end_addr + 1):
            inf = analyzer.info.get(addr, AddrInfo())
            notes_parts = []
            hw = HARDWARE.get(addr)
            if hw:
                notes_parts.append(hw)
            zp = ZP_NAMES.get(addr)
            if zp:
                notes_parts.append(zp)
            if addr in analyzer.subroutines:
                notes_parts.append("subroutine")
            if addr in analyzer.branch_targets:
                notes_parts.append("branch_target")
            notes_str = "; ".join(notes_parts)
            # CSV-escape the notes field
            if "," in notes_str or '"' in notes_str:
                notes_str = '"' + notes_str.replace('"', '""') + '"'
            f.write("${:04X},{},{},{},{},{}\n".format(
                addr, inf.type_str(),
                inf.read_count, inf.write_count, inf.exec_count,
                notes_str))
    print("CSV exported to {}".format(csv_path))


# ---------------------------------------------------------------------------
# Output: HTML heatmap
# ---------------------------------------------------------------------------
def export_html(analyzer, html_path, filename):
    """Write a self-contained HTML heatmap file."""
    load = analyzer.load_addr
    end = analyzer.end_addr
    size = len(analyzer.code)

    # Pre-compute max counts for normalization
    max_exec = max((analyzer.info[a].exec_count
                    for a in range(load, end + 1)), default=1) or 1
    max_read = 1
    max_write = 1
    for a in analyzer.info.values():
        if a.read_count > max_read:
            max_read = a.read_count
        if a.write_count > max_write:
            max_write = a.write_count

    # Build cell data
    rows_html = []
    addr = load
    while addr <= end:
        row_start = addr
        cells = []
        for col in range(16):
            if addr > end:
                cells.append('<td class="empty"></td>')
                addr += 1
                continue

            inf = analyzer.info.get(addr, AddrInfo())
            off = addr - load
            byte_val = analyzer.code[off] if off < size else 0

            # Determine color class and brightness
            is_io = 0xC000 <= addr <= 0xC0FF
            if is_io and (inf.read_count or inf.write_count):
                css_class = "io"
                intensity = min(1.0, (inf.read_count + inf.write_count) / max(max_read, 1) * 2)
            elif inf.is_code:
                if inf.exec_count > max_exec * 0.5:
                    css_class = "hot"
                    intensity = min(1.0, inf.exec_count / max_exec)
                else:
                    css_class = "code"
                    intensity = max(0.25, min(1.0, inf.exec_count / max_exec))
            elif inf.read_count or inf.write_count:
                css_class = "data"
                intensity = max(0.25, min(1.0,
                    (inf.read_count + inf.write_count) / max(max_read, 1)))
            else:
                css_class = "unused"
                intensity = 0.15

            # Build tooltip
            tip_parts = ["${:04X}: ${:02X}".format(addr, byte_val)]
            tip_parts.append("Type: {}".format(inf.type_str()))
            if inf.exec_count:
                tip_parts.append("Exec: {}".format(inf.exec_count))
            if inf.read_count:
                tip_parts.append("Read: {}".format(inf.read_count))
            if inf.write_count:
                tip_parts.append("Write: {}".format(inf.write_count))
            hw = HARDWARE.get(addr)
            if hw:
                tip_parts.append("HW: {}".format(hw))
            zp = ZP_NAMES.get(addr)
            if zp:
                tip_parts.append("ZP: {}".format(zp))
            if addr in analyzer.subroutines:
                tip_parts.append("[SUBROUTINE]")
            if addr in analyzer.branch_targets:
                tip_parts.append("[BRANCH TARGET]")
            tooltip = html_module.escape(" | ".join(tip_parts))

            style = "opacity:{:.2f};".format(max(0.15, intensity))
            cells.append(
                '<td class="{}" style="{}" title="{}">'
                '{:02X}</td>'.format(css_class, style, tooltip, byte_val)
            )
            addr += 1

        rows_html.append(
            '<tr><th class="addr">${:04X}</th>{}</tr>'.format(
                row_start, "".join(cells))
        )

    table_body = "\n".join(rows_html)

    # Statistics for the header
    total_code = sum(1 for a in range(load, end + 1)
                     if analyzer.info.get(a, AddrInfo()).is_code)
    total_data_refs = sum(1 for a in analyzer.info.values()
                          if not a.is_code and (a.read_count or a.write_count))

    html_content = """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Memory Access Heatmap - {filename}</title>
<style>
* {{ margin: 0; padding: 0; box-sizing: border-box; }}
body {{
    font-family: 'Consolas', 'Courier New', monospace;
    background: #1a1a2e;
    color: #e0e0e0;
    padding: 20px;
}}
h1 {{ color: #c8d6e5; margin-bottom: 4px; font-size: 1.3em; }}
.meta {{ color: #8899aa; font-size: 0.85em; margin-bottom: 16px; }}
.legend {{
    display: flex;
    gap: 18px;
    margin-bottom: 14px;
    flex-wrap: wrap;
}}
.legend-item {{
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 0.8em;
}}
.legend-swatch {{
    width: 16px;
    height: 16px;
    border: 1px solid #555;
    display: inline-block;
}}
.sw-code {{ background: #2a6fdb; }}
.sw-data {{ background: #27ae60; }}
.sw-io   {{ background: #e74c3c; }}
.sw-hot  {{ background: #f1c40f; }}
.sw-unused {{ background: #333; }}
table {{
    border-collapse: collapse;
    font-size: 11px;
    line-height: 1;
}}
th.addr {{
    text-align: right;
    padding: 1px 6px 1px 0;
    color: #8899aa;
    font-weight: normal;
    user-select: none;
}}
th.colhdr {{
    text-align: center;
    padding: 0 2px 4px 2px;
    color: #667788;
    font-weight: normal;
}}
td {{
    width: 22px;
    height: 18px;
    text-align: center;
    padding: 1px;
    border: 1px solid #2a2a3e;
    cursor: default;
    font-size: 10px;
    color: #ddd;
}}
td.code   {{ background-color: #2a6fdb; }}
td.data   {{ background-color: #27ae60; }}
td.io     {{ background-color: #e74c3c; }}
td.hot    {{ background-color: #f1c40f; color: #222; }}
td.unused {{ background-color: #333; color: #666; }}
td.empty  {{ background: transparent; border: none; }}
.stats {{
    margin-top: 16px;
    color: #8899aa;
    font-size: 0.8em;
}}
</style>
</head>
<body>
<h1>Memory Access Heatmap</h1>
<div class="meta">{filename} &mdash; Load: ${load:04X}, Size: {size} bytes, End: ${end:04X}</div>
<div class="legend">
    <div class="legend-item"><span class="legend-swatch sw-code"></span> Code</div>
    <div class="legend-item"><span class="legend-swatch sw-data"></span> Data</div>
    <div class="legend-item"><span class="legend-swatch sw-io"></span> I/O access</div>
    <div class="legend-item"><span class="legend-swatch sw-hot"></span> Hot spot</div>
    <div class="legend-item"><span class="legend-swatch sw-unused"></span> Unused / unknown</div>
</div>
<table>
<thead>
<tr><th></th>{col_headers}</tr>
</thead>
<tbody>
{table_body}
</tbody>
</table>
<div class="stats">
    Code bytes: {total_code} &bull;
    Data refs: {total_data_refs} &bull;
    Subroutines: {num_subs} &bull;
    Branch targets: {num_branches}
</div>
</body>
</html>""".format(
        filename=html_module.escape(filename),
        load=load,
        end=end,
        size=size,
        col_headers="".join(
            '<th class="colhdr">{:X}</th>'.format(c) for c in range(16)),
        table_body=table_body,
        total_code=total_code,
        total_data_refs=total_data_refs,
        num_subs=len(analyzer.subroutines),
        num_branches=len(analyzer.branch_targets),
    )

    with open(html_path, "w", encoding="utf-8") as f:
        f.write(html_content)
    print("HTML heatmap exported to {}".format(html_path))


# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
def parse_address(s):
    """Parse an address string like '0x4000', '$4000', or '16384'."""
    s = s.strip()
    if s.startswith("$"):
        return int(s[1:], 16)
    if s.startswith("0x") or s.startswith("0X"):
        return int(s, 16)
    # Try hex if it contains a-f
    if any(c in s.lower() for c in "abcdef"):
        return int(s, 16)
    return int(s, 0)


def main():
    parser = argparse.ArgumentParser(
        description="6502 Memory Access Pattern Visualizer for Apple II binaries",
        epilog="Examples:\n"
               "  python memviz.py game.bin 0x4000\n"
               "  python memviz.py game.bin 0x4000 --html report.html\n"
               "  python memviz.py game.bin 0x4000 --csv data.csv\n"
               "  python memviz.py game.bin 0x4000 --entry 0x57D7\n",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("binary", help="Path to the 6502 binary file")
    parser.add_argument("load_address", nargs="?", default="0x0800",
                        help="Load address (hex, default 0x0800)")
    parser.add_argument("--html", metavar="FILE",
                        help="Export HTML heatmap to FILE")
    parser.add_argument("--csv", metavar="FILE",
                        help="Export CSV data to FILE")
    parser.add_argument("--entry", metavar="ADDR",
                        help="Entry point for flow-based analysis (hex)")

    args = parser.parse_args()

    bin_path = Path(args.binary)
    if not bin_path.exists():
        print("Error: file not found: {}".format(bin_path), file=sys.stderr)
        sys.exit(1)

    with open(bin_path, "rb") as f:
        code = f.read()

    if not code:
        print("Error: empty file: {}".format(bin_path), file=sys.stderr)
        sys.exit(1)

    load_addr = parse_address(args.load_address)

    analyzer = MemoryAnalyzer(code, load_addr)

    if args.entry:
        entry = parse_address(args.entry)
        print("Flow analysis from entry point ${:04X}...".format(entry))
        analyzer.analyze_flow(entry)
    else:
        print("Linear analysis...")
        analyzer.analyze_linear()

    # Always print text report
    print()
    report_text(analyzer, bin_path.name)

    # Optional HTML export
    if args.html:
        print()
        export_html(analyzer, args.html, bin_path.name)

    # Optional CSV export
    if args.csv:
        print()
        export_csv(analyzer, args.csv)


if __name__ == "__main__":
    main()

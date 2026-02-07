# Disassembling an Apple II Game using Claude Code

## My game code from 1981

I wrote the game Genetic Drift for the Apple II in 1981 when I was 21 years old.  Ages ago I discarded the Apple II assembly source code, but I've been curious about how I did some things and just had some nostalgia to look it over.

[Article: My Career as a Game Designer](https://schram.net/articles/games/)

## Using Claude Code to disassemble it.

I have been playing with Claude Code, and I thought, let's give it an *impossible task*... extract the game binary from an Apple II dsk image and then disassemble and analyze it.

Within a few minutes, it had coded a DOS 3.3 File Extractor, and a 6502 disassembler.

Working together over about 3 hours, with what I could remember from the structure it helped piece together a partial analysis of the game including the main flow and game loop.

It's partial, but has satisfied my curiosity.

I was thoroughly amazed, and it felt like finding an old forgotten photo album.

# Apple II Game Reverse Engineering Tools

This directory contains Python tools for extracting and analyzing binary files from Apple II DOS 3.3 disk images (.dsk files). These tools were developed to reverse engineer "Genetic Drift" but can be used for any DOS 3.3 game.

## Tools Overview

### 1. `extract_dos33.py` - DOS 3.3 File Extractor

Extracts binary files from Apple II DOS 3.3 disk images without requiring Java or AppleCommander.

**Usage:**
```bash
# List all files on a disk
python3 extract_dos33.py disk_image.dsk

# Extract a specific file
python3 extract_dos33.py disk_image.dsk "FILENAME"
```

**Example:**
```bash
$ python3 extract_dos33.py CrossFire_CrossFireTitle_Cyclotron_GeneticDrift_OutPost.dsk

Catalog of CrossFire_CrossFireTitle_Cyclotron_GeneticDrift_OutPost.dsk:
--------------------------------------------------
  B  52 OUTPOST
  B  37 CYCLOTRON
  B  18 CROSSFIRE TITLE
  B  35 CROSSFIRE
  B  12 VIPER
  B  23 INVASION FORCE
  B  59 GENETIC DRIFT

$ python3 extract_dos33.py CrossFire_CrossFireTitle_Cyclotron_GeneticDrift_OutPost.dsk "GENETIC DRIFT"

Extracted: GENETIC DRIFT
  Type: Binary
  Load Address: $37D7
  Length: 14889 bytes ($3A29)
  Saved to: genetic_drift.bin
```

**What it does:**
- Parses the VTOC (Volume Table of Contents) at Track 17, Sector 0
- Reads the catalog starting at Track 17, Sector 15
- Follows Track/Sector lists to reconstruct files
- For binary files, extracts load address and length from the first sector
- Outputs raw binary data to a .bin file

### 2. `disasm6502.py` - 6502 Disassembler

Disassembles 6502 machine code into assembly language with annotations.

**Usage:**
```bash
python3 disasm6502.py input.bin output.asm [load_address]
```

**Example:**
```bash
$ python3 disasm6502.py genetic_drift.bin genetic_drift.asm 0x37D7

Disassembling genetic_drift.bin
Load address: $37D7
Output: genetic_drift.asm
```

**Features:**
- All 56 official 6502 opcodes and 13 addressing modes
- Automatic label generation for branch targets and subroutine calls
- Apple II hardware address annotations ($C000-$C0FF soft switches)
- String detection (high-bit ASCII)
- Illegal opcode detection
- Cross-reference comments

#### Apple II Hardware Addresses Recognized

| Address | Name | Description |
|---------|------|-------------|
| $C000 | KEYBOARD | Keyboard data (key + $80) |
| $C010 | KBDSTRB | Clear keyboard strobe |
| $C030 | SPKR | Speaker toggle |
| $C050 | TXTCLR | Graphics mode |
| $C051 | TXTSET | Text mode |
| $C052 | MIXCLR | Full screen |
| $C053 | MIXSET | Mixed mode (4 lines text) |
| $C054 | PAGE1 | Display page 1 |
| $C055 | PAGE2 | Display page 2 |
| $C056 | LORES | Lo-res graphics |
| $C057 | HIRES | Hi-res graphics |
| $C061 | PB0 | Paddle button 0 |
| $C062 | PB1 | Paddle button 1 |

## Workflow: Analyzing a New Game

### Step 1: Extract the Binary

```bash
# First, list files to see what's on the disk
python3 extract_dos33.py mystery_game.dsk

# Extract the game binary
python3 extract_dos33.py mystery_game.dsk "GAME NAME"
```

Note the **load address** - this tells you where the code runs in memory.

### Step 2: Disassemble

```bash
# Use the load address from extraction
python3 disasm6502.py game_name.bin game_name.asm 0xLOAD_ADDR
```

### Step 3: Initial Analysis

Look for these key patterns in the disassembly:

**Entry Point:**
- Usually at the load address
- Often starts with `CLD` (Clear Decimal) or `SEI` (Set Interrupt Disable)
- May have a relocation/copy loop if load address differs from execution address

**Graphics Mode Setup:**
```asm
LDA $C050   ; TXTCLR - graphics mode
LDA $C057   ; HIRES - hi-res mode
LDA $C052   ; MIXCLR - full screen
LDA $C054   ; PAGE1 - or $C055 for PAGE2
```

**Main Game Loop:**
- Look for a tight loop with `JMP` back to itself
- Usually calls multiple subroutines for: input, movement, collision, drawing

**Keyboard Input:**
```asm
LDA $C000   ; Read keyboard
BMI key     ; High bit set = key pressed
...
LDA $C010   ; Clear keyboard strobe
```

**Sound:**
```asm
LDA $C030   ; Toggle speaker (or STA, BIT)
; Usually in a timing loop for pitch control
```

**Sprite Data:**
- Look for large blocks of `.BYTE` data
- Pre-shifted sprites have 7 copies (for 7 pixel positions)
- Hi-res color bit is bit 7 ($80)

### Step 4: Memory Map Analysis

Create a memory map by identifying:

1. **Zero Page Variables ($00-$FF):**
   - Pointers (pairs like $00/$01)
   - Counters and flags
   - Temporary storage

2. **Game State Tables:**
   - Position arrays (X, Y for each entity)
   - Type/state arrays
   - Velocity/direction tables

3. **Sprite/Shape Tables:**
   - Look for pointer tables (low bytes, then high bytes)
   - Width and height tables
   - Actual bitmap data

### Step 5: Subroutine Mapping

Identify key routines by their characteristics:

| Pattern | Likely Function |
|---------|-----------------|
| Reads $C000, checks keys | Input handler |
| Writes to $2000-$3FFF | Hi-res page 1 drawing |
| Writes to $4000-$5FFF | Hi-res page 2 drawing |
| Toggles $C030 in loop | Sound generation |
| SED...ADC...CLD | BCD score update |
| Compares coordinates | Collision detection |

### Step 6: Document Findings

Create an analysis document (like `genetic_drift_analysis.md`) with:
- Memory map
- Subroutine table
- Data structure documentation
- Game flow diagram
- Sprite renderings (ASCII art)

## Tips for Reverse Engineering

### Finding Cheat Codes
- Search for keyboard reads ($C000) outside the main input handler
- Look for comparisons to unusual key values
- Check what happens when matches occur (lives increment, level change, etc.)

### Understanding Sprite Systems
- Find the draw routine (writes to hi-res memory $2000+ or $4000+)
- Trace back to find sprite pointer tables
- Width/height usually stored in parallel tables
- Pre-shifted sprites: 7 copies × height × width bytes each

### Identifying Game State
- Set breakpoints on zero page writes
- Track what changes when game events occur
- Lives, score, level often in low zero page ($10-$3F)

### Sound Analysis
- Find all $C030 references
- Timing loops determine pitch
- Outer loops determine duration

## File Formats

### DOS 3.3 Disk Image (.dsk)
- 140KB (35 tracks × 16 sectors × 256 bytes)
- Track 17 contains VTOC and catalog
- No interleaving in .dsk format (unlike .do or .po)

### Binary File Header
- Bytes 0-1: Load address (little-endian)
- Bytes 2-3: Length (little-endian)
- Bytes 4+: Actual program data

## Example Analysis: Genetic Drift

See `genetic_drift_analysis.md` for a partial reverse engineering of the 1982 Broderbund game "Genetic Drift" by Scott Schram, published by Broderbund in 1982. Analysis includes:

- Complete memory map and zero page variable documentation
- All 6 alien sprite types rendered as ASCII art (UFO, Eye1, Eye2, TV, Diamond, Bowtie)
- Main game loop documented with frame timing
- Collision detection explained
- **Cheat code discovered**: Shift-N (caret `^` on Apple II/II+ keyboard) for +3 lives and difficulty reset
- Progressive difficulty system with 12-level lookup tables
- Level system (6 waves, satellites appear in later levels)
- Heart/penalty mechanics (Diamond transformation punishment)
- Keyboard controls: Y/G/J/Space for direction, ESC for fire, A/F for 4-direction simultaneous fire

**Note on Apple II keyboard**: The cheat key `$9E` is the caret character, which on the original Apple II/II+ keyboard is produced by **Shift-N** (not Shift-6 as on modern keyboards).

## Rosetta v2 Toolchain Contribution

The `genetic_drift_complete.s` and `genetic_drift_annotated.s` files in this repository were produced using [Project Rosetta](https://github.com/nicholascross/rosetta_v2), a cross-platform Apple IIgs/65816 toolchain (v2.1.2). The toolchain's disassembler, **deasmiigs v2.0.0**, was used in 6502 mode to produce a machine-analyzed disassembly that goes far beyond linear disassembly.

### What is Project Rosetta?

Project Rosetta is a round-trip toolchain for the Apple IIgs and 65816 family:

| Tool | Purpose |
|------|---------|
| **deasmiigs** | Decompiler/disassembler with CFG analysis, pattern matching, and AI assist |
| **asmiigs** | Assembler (MPW/ORCA-M syntax) |
| **linkiigs** | Linker (OMF v2.1 output) |
| **reziigs** | Resource compiler |
| **romiigs** | ROM explorer GUI (Python/PySide6) for ROM archaeology and AI-assisted annotation |
| **rosetta-lsp** | Language server for IDE integration |

### What deasmiigs Detected Automatically

For the 14,889-byte Genetic Drift binary, deasmiigs performed control flow graph (CFG) tracing and produced these automated analyses:

| Analysis | Result |
|----------|--------|
| **Functions** | 74 auto-detected (vs ~30 found manually) |
| **Loops** | 210 detected with type classification (194 while, 7 counted, 9 other) |
| **Nesting** | Max nesting depth of 62 levels identified |
| **Pattern matches** | 876 code idioms recognized (BCD arithmetic, keyboard polling, sprite draw, etc.) |
| **Optimization hints** | 32 suggestions (peephole, redundant loads, strength reduction, tail calls) |
| **Call sites** | 39 analyzed with parameter inference |
| **Stack frames** | 71 functions with frame size, locals, and saved register analysis |
| **Cross-references** | Full call graph and data reference tracking |
| **Hardware context** | Subsystem detection: keyboard, video mode, joystick, speaker, disk I/O |
| **Data regions** | Automatic detection of non-code data (tables, sprite bitmaps) |

### deasmiigs Capabilities

**CPU targets:** 6502, 65C02, 65816, 65GS832 (custom Apple IIgs extended mode)

**Analysis passes:**
- Control flow graph (CFG) construction with basic block identification
- Loop detection and classification (while, do-while, counted, infinite) with iteration variable tracking
- Constant propagation through register/memory state tracking
- Type inference for memory locations (byte, word, pointer, array, struct)
- Switch/case detection (jump tables, CMP chains, computed jumps)
- Stack depth analysis with balance verification
- I/O pattern sequence detection (video mode setup, language card bank switching)
- Apple II ROM symbol lookup (166 symbols: Monitor, Applesoft, DOS vectors)

**Output formats:**
- Raw disassembly, annotated disassembly, or pseudocode
- Cross-reference reports (JSON, HTML)
- Intermediate representation (IR) as JSON for external tooling
- Validation output for round-trip verification

**Apple II / IIgs specific features:**
- `--apple2-rom` — Injects 166 Apple II ROM entry point symbols (Monitor, Applesoft, I/O)
- `--prodos8` — Detects ProDOS 8 MLI calls with parameter block analysis
- `--dos33` — Detects DOS 3.3 entry points and file manager calls
- `--6502-strict` — Restricts output to 6502-only instructions
- Full soft switch annotation ($C000-$C0FF) with subsystem classification

**AI-assisted analysis (optional, via Ollama):**
- `--ai-name` — AI-generated meaningful function names
- `--ai-describe` — AI-generated function descriptions

### How the Annotated Disassembly Was Produced

1. **Binary splitting** — A Python script (`split_binary.py`) identified the self-relocating structure and split the binary into 3 segments: bootstrap ($37D7), relocated ($0000), and main ($4000).

2. **Automated disassembly** — Each segment was disassembled with deasmiigs:
   ```bash
   deasmiigs --cpu 6502 --format binary --load 0x37D7 --entry 0x37D7 \
             --apple2-rom gd_bootstrap.bin -o gd_bootstrap.s
   deasmiigs --cpu 6502 --format binary --load 0x0000 --entry 0x0000 \
             --apple2-rom gd_relocated.bin -o gd_relocated.s
   deasmiigs --cpu 6502 --format binary --load 0x4000 --entry 0x4000 \
             --apple2-rom gd_main.bin -o gd_main.s
   ```

3. **Segment merge** — The three disassemblies were merged into `genetic_drift_complete.s` (5,277 lines) with a unified memory map header.

4. **Automated annotation** — A Python script (`annotate_genetic_drift.py`) applied 125 label renames, 21 section headers, zero page equates, and data table labels using Scott Schram's `genetic_drift_analysis.md` as the knowledge base.

5. **Manual polish** — Every major section received hand-written HOW/WHY annotations explaining both the code mechanism and the design rationale behind it (Apple II hardware quirks, game design decisions, historical context).

### Comparison: Linear vs CFG Disassembly

| Feature | `disasm6502.py` (linear) | **deasmiigs** (CFG-tracing) |
|---------|--------------------------|---------------------------|
| Disassembly method | Sequential byte-by-byte | Control flow graph tracing |
| Function detection | None (manual) | 74 auto-detected with boundaries |
| Loop analysis | None | 210 loops with type/nesting/counter |
| Data vs code | Disassembles everything as code | Detects data regions automatically |
| Branch targets | Labels generated | Labels + cross-reference graph |
| Hardware annotation | 13 soft switches | 166 ROM symbols + full soft switch map |
| Pattern recognition | None | 876 idioms (BCD, sprite draw, I/O polling) |
| Stack analysis | None | Frame sizes, locals, balance checking |
| Output | .asm text | .s text, JSON IR, HTML xref, validation |

Both approaches have value: the linear disassembler is simple, hackable, and produced results in minutes with zero dependencies. The CFG-tracing disassembler provides deeper structural analysis that reveals the program's architecture.

### Files in This Repository

| File | Description |
|------|-------------|
| `genetic_drift_analysis.md` | Scott Schram's comprehensive game analysis (co-written with Claude Code) |
| `genetic_drift_complete.s` | Raw Rosetta v2 toolchain output (5,277 lines, 74 auto-detected functions) |
| `genetic_drift_annotated.s` | Hand-annotated version (5,816 lines, 125 named functions, HOW/WHY comments) |
| `annotate_genetic_drift.py` | Annotation script that transforms raw output to annotated version |
| `extract_dos33.py` | DOS 3.3 file extractor (Scott's original tool) |
| `disasm6502.py` | Linear 6502 disassembler (Scott's original tool) |

## Requirements

- **Python tools** (`extract_dos33.py`, `disasm6502.py`): Python 3.6+, no external dependencies
- **Rosetta v2 toolchain** (`deasmiigs`): Built from source (C, CMake). See the [Rosetta project](https://github.com/nicholascross/rosetta_v2) for build instructions.

## Limitations

**Python tools:**
- Only handles DOS 3.3 format (not ProDOS, Pascal, or CP/M)
- Binary file extraction only (not Applesoft or Integer BASIC tokenized files)
- Disassembler doesn't trace execution flow (linear disassembly)
- No support for self-modifying code detection

**deasmiigs known issue:**
- The `--cpu 6502` flag does not fully restrict the instruction set; some 65816 mnemonics may appear in data regions that are incorrectly disassembled as code. The annotated file corrects these manually.

## Future Enhancements

Potential improvements:
- ProDOS disk image support
- Applesoft BASIC detokenizer
- Execution flow tracing disassembler
- Automated sprite extraction and PNG rendering
- Memory access pattern visualization

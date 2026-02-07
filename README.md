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

This directory contains Python tools for extracting, disassembling, and analyzing Apple II binaries from disk images. Originally developed to reverse engineer "Genetic Drift," the toolkit now supports DOS 3.3 and ProDOS disk formats, Applesoft and Integer BASIC detokenization, control-flow-tracing disassembly with self-modifying code detection, automated sprite extraction with PNG rendering, and memory access pattern visualization.

All tools are Python 3.6+ with no external dependencies (Pillow optional for sprite PNG output).

## Tools Overview

### 1. `extract_dos33.py` - DOS 3.3 File Extractor

Extracts binary files from Apple II DOS 3.3 disk images (.dsk).

**Usage:**
```bash
python3 extract_dos33.py disk_image.dsk              # List catalog
python3 extract_dos33.py disk_image.dsk "FILENAME"    # Extract file
```

### 2. `extract_prodos.py` - ProDOS File Extractor

Extracts files from Apple II ProDOS disk images (.po and .dsk with sector interleave).

**Usage:**
```bash
python3 extract_prodos.py disk.po                     # List all files recursively
python3 extract_prodos.py disk.po FILENAME             # Extract from root
python3 extract_prodos.py disk.po /SUBDIR/FILE         # Extract from subdirectory
```

**Features:**
- Supports `.po` (ProDOS-order) and `.dsk` (DOS-order with sector interleave) images
- All ProDOS storage types: seedling, sapling, tree, and subdirectory
- Sparse file handling (zero-filled blocks)
- Recursive directory listing with file types, sizes, and aux types
- ProDOS date/time decoding
- Path resolution: `FILENAME`, `/SUBDIR/FILE`, `/VOLUME/SUBDIR/FILE`

### 3. `disasm6502.py` - 6502 Disassembler with Flow Tracing

Disassembles 6502 machine code with control flow graph (CFG) tracing, self-modifying code detection, and semantic label generation.

**Usage:**
```bash
python3 disasm6502.py game.bin 0x0800                  # CFG tracing (default)
python3 disasm6502.py game.bin 0x0800 --linear         # Linear disassembly
python3 disasm6502.py game.bin 0x0800 --entry 0x0900   # Multiple entry points
python3 disasm6502.py game.bin 0x0800 --no-smc         # Disable SMC detection
```

**Features:**
- **Control flow graph tracing** (default): Follows JSR/JMP/branch targets from entry points; unreachable bytes classified as data
- **Self-modifying code detection**: Identifies STA/STX/STY instructions that write into code regions, with inline warnings
- **Semantic labels**: `sub_XXXX` (JSR targets), `jmp_XXXX` (JMP targets), `loc_XXXX` (branches), `dat_XXXX` (data)
- **Data region output**: `.BYTE` hex directives, `.ASC` for detected strings, `.WORD` for pointer tables
- **Expanded hardware annotations**: 40+ Apple II I/O addresses including Language Card ($C080-$C08F) and Disk II ($C0E0-$C0EF)
- All 56 official 6502 opcodes and 13 addressing modes
- Fallback `--linear` mode for comparison

### 4. `detokenize_basic.py` - Applesoft & Integer BASIC Detokenizer

Converts tokenized Apple II BASIC programs back to readable text listings.

**Usage:**
```bash
python3 detokenize_basic.py program.bas                # Auto-detect type
python3 detokenize_basic.py program.bas --applesoft     # Force Applesoft
python3 detokenize_basic.py program.bas --integer       # Force Integer BASIC
python3 detokenize_basic.py program.bas --xref          # GOTO/GOSUB cross-reference
python3 detokenize_basic.py program.bas --hex-dump      # Hex dump alongside listing
python3 detokenize_basic.py program.bas -o output.txt   # Write to file
```

**Features:**
- **Applesoft BASIC**: Complete 107-token table ($80-$EA), string/REM handling, smart keyword spacing
- **Integer BASIC**: Best-effort decoding with numeric constants, variable names, keyword tokens
- **Auto-detection**: Heuristic scoring distinguishes Applesoft from Integer BASIC
- **Cross-reference**: `--xref` builds GOTO/GOSUB target map showing which lines reference which
- **Hex dump**: `--hex-dump` shows raw bytes alongside the listing

### 5. `extract_sprites.py` - HGR Sprite Extractor & PNG Renderer

Extracts and renders Apple II Hi-Res Graphics (HGR) sprites from binary files with accurate NTSC artifact color emulation.

**Usage:**
```bash
# Manual extraction: known offset, width, height
python3 extract_sprites.py game.bin --offset 0x2070 --width 4 --height 8 --count 7

# Table-driven: pointer tables + width/height tables (common Apple II pattern)
python3 extract_sprites.py game.bin --ptr-lo 0x1D7C --ptr-hi 0x1E1D \
        --width-tbl 0x1EBE --height-tbl 0x1F5F --count 20 --base 0x4000

# Auto-detect: scan for potential sprite tables
python3 extract_sprites.py game.bin --auto --base 0x4000

# Options
python3 extract_sprites.py game.bin ... --scale 4 --sheet --ascii
```

**Features:**
- **HGR color model**: Full NTSC artifact color rendering (purple, green, blue, orange, white, black) with palette bit and adjacency rules
- **Three extraction modes**: manual (fixed offset), table-driven (lo/hi pointer + width/height tables), auto-detect (scans for pointer table patterns)
- **PNG output**: Uses Pillow if available, otherwise a pure-Python minimal PNG writer (no dependencies)
- **Sprite sheets**: `--sheet` combines all sprites into a single image
- **ASCII preview**: `--ascii` prints terminal-friendly sprite art
- **Nearest-neighbor scaling**: `--scale N` for crisp pixel-art enlargement

### 6. `memviz.py` - Memory Access Pattern Visualizer

Analyzes a 6502 binary and produces memory access heatmaps showing code regions, data references, I/O accesses, and hot spots.

**Usage:**
```bash
python3 memviz.py game.bin 0x4000                      # Linear analysis, text report
python3 memviz.py game.bin 0x4000 --entry 0x57D7       # Flow-based analysis
python3 memviz.py game.bin 0x4000 --html report.html   # Interactive HTML heatmap
python3 memviz.py game.bin 0x4000 --csv data.csv       # CSV export for spreadsheets
```

**Features:**
- **Two analysis modes**: linear scan or CFG-based flow tracing from entry point
- **Per-address tracking**: read count, write count, execution count, callers
- **Text report**: zero page usage (with pointer pair coalescing), I/O register summary, memory map with hotness, top 20 hot addresses
- **HTML heatmap**: Self-contained dark-theme page with color-coded grid (blue=code, green=data, red=I/O, yellow=hot), hover tooltips, opacity scaled by access frequency
- **CSV export**: One row per address for external analysis
- **Apple II I/O awareness**: 50+ hardware addresses named (keyboard, speaker, graphics, Language Card, Disk II)

### 7. `annotate_genetic_drift.py` - Genetic Drift Annotation Script

Transforms `genetic_drift_complete.s` into `genetic_drift_annotated.s` with meaningful labels, section headers, zero page documentation, and inline game-logic comments.

## Workflow: Analyzing a New Game

### Step 1: Extract the Binary

```bash
# DOS 3.3 disk
python3 extract_dos33.py mystery_game.dsk
python3 extract_dos33.py mystery_game.dsk "GAME NAME"

# ProDOS disk
python3 extract_prodos.py mystery_game.po
python3 extract_prodos.py mystery_game.po "GAME.NAME"
```

Note the **load address** - this tells you where the code runs in memory.

### Step 2: Disassemble

```bash
# Control flow tracing (recommended)
python3 disasm6502.py game.bin 0xLOAD_ADDR

# With multiple entry points (for self-relocating binaries)
python3 disasm6502.py game.bin 0x0800 --entry 0x0800 --entry 0x0900
```

### Step 3: Visualize Memory Layout

```bash
# Generate HTML heatmap showing code/data/I/O regions
python3 memviz.py game.bin 0xLOAD_ADDR --entry 0xENTRY --html report.html
```

### Step 4: Extract Sprites

```bash
# Auto-detect sprite tables
python3 extract_sprites.py game.bin --auto --base 0xLOAD_ADDR

# Extract known sprites as PNG
python3 extract_sprites.py game.bin --offset 0x2070 --width 4 --height 8 \
        --count 7 --scale 4 --sheet --ascii
```

### Step 5: Check for BASIC Programs

```bash
# Detokenize extracted BASIC files
python3 detokenize_basic.py program.bas --xref
```

### Step 6: Document Findings

Create an analysis document (like `genetic_drift_analysis.md`) with:
- Memory map (use `memviz.py` HTML output as starting point)
- Subroutine table (use `disasm6502.py` semantic labels)
- Data structure documentation
- Game flow diagram
- Sprite renderings (from `extract_sprites.py` PNGs)

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

The `genetic_drift_complete.s` and `genetic_drift_annotated.s` files in this repository were produced using Project Rosetta, a cross-platform Apple IIgs/65816 toolchain (v2.1.2). The toolchain's disassembler, **deasmiigs v2.0.0**, was used in 6502 mode to produce a machine-analyzed disassembly that goes far beyond linear disassembly.

> **Note:** Project Rosetta is currently a private project under active development. The tools described below are not yet publicly available.

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
- `--6502-strict` — Treats CPU-incompatible opcodes as data (sprite tables, lookup tables correctly detected)
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

### Comparison: disasm6502.py vs deasmiigs

| Feature | `disasm6502.py` (Python) | **deasmiigs** (C, Rosetta v2) |
|---------|--------------------------|-------------------------------|
| Disassembly method | CFG tracing + linear fallback | CFG tracing + pattern matching |
| Function detection | JSR-target semantic labels | 74 auto-detected with boundaries |
| Loop analysis | None | 210 loops with type/nesting/counter |
| Data vs code | CFG-based classification | CFG + opcode density + indexed addressing |
| SMC detection | Yes (STA/STX/STY into code) | No |
| Branch targets | Semantic labels (`sub_`, `loc_`, `jmp_`, `dat_`) | Labels + cross-reference graph |
| Hardware annotation | 40+ soft switches + Language Card + Disk II | 166 ROM symbols + full soft switch map |
| Pattern recognition | None | 876 idioms (BCD, sprite draw, I/O polling) |
| Stack analysis | None | Frame sizes, locals, balance checking |
| Output | .asm text to stdout | .s text, JSON IR, HTML xref, validation |
| Dependencies | Python 3.6+ only | C compiler, CMake |

Both tools now use CFG-based flow tracing. The Python disassembler is simple, hackable, and runs anywhere with zero dependencies. deasmiigs provides deeper structural analysis (loops, patterns, stack frames) for serious reverse engineering.

### Files in This Repository

| File | Description |
|------|-------------|
| **Analysis & Disassembly** | |
| `genetic_drift_analysis.md` | Scott Schram's comprehensive game analysis (co-written with Claude Code) |
| `genetic_drift_complete.s` | Rosetta v2 toolchain output (6,774 lines, 74 auto-detected functions, semantic labels) |
| `genetic_drift_annotated.s` | Hand-annotated version (125+ named functions, HOW/WHY comments) |
| `genetic_drift_game_binary.bin` | The original 14,889-byte game binary extracted from disk |
| `Genetic_Drift_Instructions.pdf` | Original game instruction manual |
| **Tools** | |
| `extract_dos33.py` | DOS 3.3 file extractor |
| `extract_prodos.py` | ProDOS file extractor (seedling/sapling/tree, .po and .dsk) |
| `disasm6502.py` | 6502 disassembler with CFG tracing, SMC detection, semantic labels |
| `detokenize_basic.py` | Applesoft & Integer BASIC detokenizer with cross-reference |
| `extract_sprites.py` | HGR sprite extractor with NTSC color rendering and PNG output |
| `memviz.py` | Memory access pattern visualizer (text, HTML heatmap, CSV) |
| `annotate_genetic_drift.py` | Annotation script that transforms raw output to annotated version |

## Requirements

- **Python tools**: Python 3.6+, no external dependencies required
- **Optional**: Pillow (PIL) for higher-quality PNG output from `extract_sprites.py` (falls back to pure-Python PNG writer)
- **Rosetta v2 toolchain** (`deasmiigs`): Built from source (C, CMake). Project Rosetta is currently private; contact the author for access.

## Limitations

**Python tools:**
- `extract_dos33.py`: DOS 3.3 format only (not Pascal or CP/M)
- `extract_prodos.py`: ProDOS format only; no Pascal or CP/M support
- `detokenize_basic.py`: Integer BASIC support is best-effort (complex tokenization scheme)
- `disasm6502.py`: No 65C02 or 65816 support (6502 only)

**deasmiigs:**
- As of v2.1.2, the `--6502-strict` flag correctly treats CPU-incompatible opcodes as data rather than disassembling them as 65816 instructions. The `--cpu 6502` flag now fully restricts the instruction set.

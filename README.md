# Genetic Drift (Broderbund, 1981)

## Historical Significance

Genetic Drift was written by **Scott Schram** in 1981, when he was 21 years old, and published by Broderbund Software for the Apple II. It is a single-load action game that fits entirely in ~15KB of 6502 machine code. Schram later wrote about the experience in his article ["My Career as a Game Designer"](https://schram.net/articles/games/).

The game's title is a biology metaphor: aliens "mutate" through six forms when shot, cycling from UFO through Eye, TV, Diamond, and Bowtie shapes. The player's goal is to evolve all 16 aliens into TVs simultaneously --- a deceptively simple objective that requires careful timing and restraint, since overshooting a TV cycles it back to the penalty Diamond state.

This disassembly was produced collaboratively by Scott Schram and Claude Code in 2025, starting from the raw disk image with no surviving source code. The original Apple II assembly was discarded decades ago.

### Credits

| Role | Person |
|------|--------|
| Designer/Programmer | Scott Schram |
| Publisher | Broderbund Software |
| Reverse Engineering | Scott Schram + Claude Code (Rosetta v2 toolchain) |

## Source Disk

| Property | Value |
|----------|-------|
| Disk Image | `Genetic Drift.dsk` (143,360 bytes, DOS 3.3 format) |
| WOZ Image | `Genetic Drift.woz` (120,320 bytes, WOZ 1.0, by 4am/Passport) |
| SHA-256 (.dsk) | `805f89516ae3725e591d02cc0594f250fbc9ab74461f1e03faeed1649f24e9a2` |
| Copy Protection | **Broderbund nibble-encoded** (custom RWTS at $025D) |
| Filesystem | Standard DOS 3.3 catalog unreadable by cp2 due to protection |

**Why cp2 can't read this disk:** Broderbund used a custom Read/Write Track/Sector (RWTS) routine that encodes nibbles differently from standard DOS 3.3. The game binary contains its own RWTS at $025D in the relocated zero-page block. The binary was extracted using a custom `extract_dos33.py` tool that reads the raw sector data directly.

## File Inventory

| File | Type | Size | Load Addr | Description |
|------|------|------|-----------|-------------|
| Game Binary | 6502 machine code | 14,889 bytes | $37D7 | Complete game: bootstrap + relocated block + main code |
| `Genetic_Drift_Instructions.pdf` | Document | ~200KB | --- | Original game manual (scanned) |

Only one loadable binary exists on the disk. The game is entirely self-contained with no external data files, BASIC loaders, or overlays.

## Boot Sequence

```
Power On
  |
  v
DOS 3.3 Boot (tracks 0-2)
  |
  v
RWTS loads game binary to $37D7-$71FF (14,889 bytes)
  |
  v
$37D7: Bootstrap Loader
  |  STA $C010          ; Clear keyboard strobe
  |  Copy $3800-$3FFF --> $0000-$07FF  (8 pages)
  |  JMP $57D7          ; Transfer to main code
  |
  v
$57D7: Main Entry
  |  CLD                ; Clear decimal mode
  |  JSR $415B          ; Hardware init
  |
  v
$4120: Graphics Init
  |  LDA $C050          ; TXTCLR  - enable graphics
  |  LDA $C057          ; HIRES   - hi-res mode
  |  LDA $C052          ; MIXCLR  - full screen (no text window)
  |  (Page 1 only -- no page flipping)
  |
  v
Title Screen --> Wait for RETURN ($8D) --> $5809: Start New Game
```

## Memory Map

The binary uses a **self-relocating** architecture. It loads as a contiguous block at $37D7, then the bootstrap copies the first 2KB to zero page and the stack area before jumping to the main code at its original load position.

```
$0000-$003F  Zero Page: Game state variables (see table below)
$0040-$00FF  Zero Page: Sprite pointers, temp calculations
$0100-$01FF  Stack
$0200-$07FF  Relocated Block: Custom RWTS, Broderbund intro, RNG
             (copied from $3800-$3FFF at boot)
$2000-$3FFF  HGR Page 1: Display memory (192 lines x 40 bytes)
$37D7-$37FF  Bootstrap Loader (29 bytes, runs once then overwritten by HGR)
$3800-$3FFF  Source data for relocation (overwritten by HGR page 1)
$4000-$53FF  Main Game Code: Drawing, collision, game logic
$5370-$53FF  Position/State Tables: Alien types, coordinates
$5400-$57CF  Movement, Level Logic, Difficulty Tables
$57D0-$57D6  Global Variables (direction, temp storage)
$57D7-$5875  Entry Point, Title Screen, Game Start
$5875-$5A5A  Main Game Loop
$5A5D-$5D08  Collision Resolution, Level Complete, Victory
$5D09-$5D98  Game Over, Score Display
$5D99-$5FFF  Sprite Pointer Tables (low/high/width/height)
$6000-$71FF  Sprite Data: Pre-shifted pixel patterns (7 shifts x N sprites)
```

### Zero Page Variables

| Address | Size | Name | Description |
|---------|------|------|-------------|
| $00-$01 | 2 | `src_ptr` | Source pointer / general counter |
| $02-$04 | 3 | `draw_ptr` | Destination pointer / graphics calculation |
| $0C-$0D | 2 | `score` | Current score (BCD format) |
| $0E-$0F | 2 | `hiscore` | High score (BCD format) |
| $10 | 1 | `lives` | Lives remaining |
| $11 | 1 | `direction` | Current aim direction (0=Up, 1=Right, 2=Down, 3=Left) |
| $12 | 1 | `loop_idx` | Loop counter (temp) |
| $19 | 1 | `draw_y` | Y-coordinate for sprite drawing |
| $2B | 1 | `game_state` | Game state flags |
| $2C-$2D | 2 | `anim_ctr` | Animation countdown timers |
| $2E | 1 | `frame_ctr` | Frame timing counter (counts up, wraps to reload from $2F) |
| $2F | 1 | `frame_reload` | Frame timing reload value (from difficulty table) |
| $30 | 1 | `difficulty` | Difficulty index (11=easiest, 0=hardest) |
| $31 | 1 | `diff_step` | Steps until next difficulty increase |
| $32 | 1 | `fire_rate` | Alien firing rate (from difficulty table) |
| $34-$36 | 3 | `game_flags` | Game flags ($36 = fire-requested flag) |
| $3A | 1 | `level` | Level counter (5=Level 1, 0=Victory) |

## Game Architecture

### Main Game Loop ($5875)

The game loop runs every frame. Each tick processes all game systems in a fixed order:

```
$5875: MainGameLoop
  |
  |-- JSR $457F     MoveAllProjectiles     ; Move 4 laser beams (one per direction)
  |-- JSR $52F3     RedrawSprites          ; Redraw screen elements
  |-- JSR $4F5B     CheckSatelliteHits     ; Laser vs satellite collision
  |-- JSR $5C1C     UpdateStarTwinkle      ; Animated star background
  |-- JSR $5C78     CheckAllTVs            ; All 16 aliens = TV? --> Level complete!
  |
  |-- JSR $43E0     KeyboardHandler        ; Read keys, update direction/$36 flag
  |-- BIT $C061     CheckPaddleButton      ; Alternate fire input
  |
  |-- (if $36 set)
  |   JSR $58A5     FireProjectile         ; Launch laser in current direction
  |
  |-- JSR $4D87     UpdateAlienPositions   ; Move aliens along tracks
  |
  |-- Loop X=3..0:
  |   JSR $58CB     CheckAlienCollisions   ; Laser vs alien hit detection
  |     |-- HIT: JSR $4E15  AlienEvolve   ; Alien cycles to next form
  |     |-- HIT: JSR $56E4  DifficultyUp  ; Increment difficulty
  |
  |-- $5A04: Frame Timing
  |   INC $2E                              ; Increment frame counter
  |   (when wraps) LDA $2F / STA $2E      ; Reload from difficulty-controlled value
  |   JSR $450E     PeriodicGameLogic      ; Periodic game logic (alien firing, etc.)
  |
  +-- JMP $5875     ; Loop forever
```

### Keyboard Handler ($43E0)

Direction keys form a diamond pattern matching the screen layout:

```
         Y ($D9)
          |
  G ($C7)-+-J ($CA)
          |
       SPACE ($A0)
```

| Key | ASCII | Action |
|-----|-------|--------|
| Y | $D9 | Direction = UP (0) |
| J | $CA | Direction = RIGHT (1) |
| SPACE | $A0 | Direction = DOWN (2) |
| G | $C7 | Direction = LEFT (3) |
| ESC | $9B | Fire in current direction (sets $36 flag) |
| A | $C1 | **4-direction simultaneous fire** (limited uses per level, stored at $536F) |
| F | $C6 | Same as A (alternate key) |

**HOW:** The handler reads $C000 (keyboard data register), strips the high bit, and compares against each key code in sequence. Direction keys write to $11; fire keys set $36.

**WHY:** ESC was the original fire key. Players complained about wearing out the ESC key, so A/F were added as the "super shot" that fires in all 4 directions simultaneously. When uses run out, A/F fall back to single-direction fire like ESC.

### Firing System ($58A5)

Each direction supports one active projectile at a time. The game tracks 4 simultaneous projectiles in parallel arrays:

| Table | Purpose |
|-------|---------|
| $5D58,X | Active flag (0=inactive, 1=active) |
| $5D48,X | X position low byte |
| $5D4C,X | X position high byte |
| $5D50,X | Y position |
| $5D54,X | State (0=none, 2=exploding, 3=hit) |
| $5D5C-$5D67 | Drawing position copies |
| $5D68-$5D73 | Base spawn position (projectile origin) |

**Projectile speed:** 3 pixels per frame in each axis direction (`ADC #$03` / `SBC #$03` at $45A2-$4615).

**Boundary limits:** UP=Y:0, DOWN=Y:$BF (191), LEFT=X:$17, RIGHT=X:$3E.

### Collision Detection ($58CB-$596E)

Collision is **direction-specific** using simple coordinate threshold checks --- no bounding boxes.

```
Loop X = 3 down to 0:
  if projectile not active: skip
  Branch by direction:
    X=0 (UP):    hit if projectile Y <= alien Y
    X=1 (LEFT):  hit if projectile X <= alien X
    X=2 (DOWN):  hit if projectile Y >= alien Y
    X=3 (RIGHT): hit if projectile X >= alien X
  HIT:
    JSR $44C4    DrawHitFlash
    JSR $4441    ClearSpriteArea
    LDA #$01 / JSR $4AE0    AddScore (1 point per hit)
    Play hit sound
```

**WHY this works:** Projectiles move in straight lines at 3px/frame. The check is simply "has the projectile reached or passed the target line?" This gives precise feel because at 3px/frame on a 1MHz Apple II, the projectile crosses each pixel position exactly once --- no skipping.

## Alien Evolution System ("Genetic Drift")

The game's title is a biology metaphor. Each alien cycles through 6 forms when hit, stored in the $53B8 table (16 entries, 4 per direction):

```
Hit   Hit   Hit   Hit   Hit   Hit
UFO ---> Eye1 ---> Eye2 ---> TV ---> Diamond ---> Bowtie --+
 ^                                                          |
 +----------------------------------------------------------+
                         (wraps)
```

### Alien Types

| Type | Form | Sprite Idx | Address | Strategic Role |
|------|------|-----------|---------|----------------|
| 0 | Empty | --- | --- | Initial/cleared |
| 1 | UFO | $74 | $69AB | Starting form |
| 2 | Eye (blue) | $35 | $65AA | Intermediate |
| 3 | Eye (green) | $5F | $6859 | Intermediate |
| 4 | **TV** | $66 | $6898 | **THE GOAL** |
| 5 | **Diamond** | $6D | $691F | **PENALTY STATE** |
| 6 | Bowtie | $7B | $6A30 | One hit from UFO |

### Alien Sprites (ASCII Art)

```
TYPE 1: UFO                    TYPE 2: Eye (Blue)           TYPE 3: Eye (Green)
      ######                       ##########                   ##########
######  ##  ######             ######  ##  ######           ######  ##  ######
##  ##  ##  ##  ####         ######  ##  ##  ######       ######  ##  ##  ######
##  ##  ##  ##  ##  ##       ######  ##      ##  ######   ######  ##      ##  ######
##########################   ######  ##  ##  ##  ######   ######  ##  ##  ##  ######
  ######    ##    ######       ######  ##  ######           ######  ##  ######
    ##              ##             ##########                   ##########

TYPE 4: TV (GOAL!)             TYPE 5: Diamond (PENALTY!)   TYPE 6: Bowtie
  ##      ##                           ####                 ##        ####        ##
    ##  ##                         ##  ####  ##             ##  ##    ####    ##  ##
      ##                       ##  ##  ####  ##  ##         ##  ##  ##    ##  ##  ##
##################             ######  ####  ##  ##  ##     ##  ##  ##  ##  ##  ##  ##
##          ##  ##               ##  ##  ####  ##  ##       ##  ##  ##    ##  ##  ##
##          ######                 ##  ####  ##             ##  ##    ####    ##  ##
##          ##  ##                     ####                 ##        ####        ##
##          ######
##################
```

### Evolution Logic ($4E15-$4E24)

```asm
$4E15: INC $53B8,X    ; Alien evolves to next form
$4E18: LDA $53B8,X
$4E1B: CMP #$07       ; Reached type 7?
$4E1D: BCC done
$4E1F: LDA #$01       ; Wrap back to UFO (type 1)
$4E21: STA $53B8,X
```

**HOW:** A single `INC` on the type table entry, with a bounds check wrapping 7 back to 1.

**WHY:** The 6-state cycle creates the core strategic tension. Getting an alien to TV (type 4) takes exactly 3 hits from UFO. But one extra hit pushes it to Diamond, requiring 5 more hits to return to TV. This makes trigger discipline essential.

### Alien Projectile Types (Hearts)

When ALL 4 aliens on a side have become TVs, they begin firing special projectiles:

| Type | Appearance | Action Required | Probability |
|------|------------|-----------------|-------------|
| 1 | Normal | Hit or let pass | Default |
| 2 | **Heart** | **DON'T HIT** --- triggers Diamond penalty | ~94% (when all TVs) |
| 3 | **Upside-Down Heart** | **MUST HIT** --- missing triggers penalty | ~6% (when all TVs) |

**Selection logic ($4B0C):** Check if all 4 aliens on the firing side are type 4. If yes, call RNG at $0403: random value < $10 (6.25%) = upside-down heart, otherwise regular heart.

### Punishment Routine ($4B65)

When you hit a heart or miss an upside-down heart:

```asm
$4B65: LDA $57D6        ; Get direction of offending side
$4B6B: ASL / ASL         ; direction * 4
$4B70: ADC #$03          ; Start at end of direction's group
$4B73: TAX
$4B74: LDY #$03          ; 4 aliens
$4B76: LDA #$05          ; Type 5 = DIAMOND
$4B78: STA $53B8,X       ; Transform alien
$4B7B: DEX / DEY / BPL   ; Loop all 4
```

**Effect:** ALL 4 aliens on that side instantly become Diamonds. Each Diamond requires 5 hits to cycle back to TV. One mistake can cost 20 hits of progress.

## Satellite System

Satellites are bonus targets that orbit around the playfield, appearing from Level 3 onward.

### Data Tables

| Address | Purpose |
|---------|---------|
| $520E,X | Satellite position (one per direction) |
| $5212,X | Point value / existence flag (0 = no satellite) |
| $5221,X | Hits remaining before satellite is destroyed |

**Collision ($4F5B):** When a laser enters the satellite zone (direction-specific boundary), compare laser position against satellite position. Hit within 5 pixels scores points equal to the value at $5212,X and decrements the hit counter at $5221,X.

**Spawning:** `JSR $5227` is called 4 times during level transitions when $3A < 4 (Levels 3-5).

## Level System

Levels count **down** from 5 to 0 using the $3A variable:

| $3A | Level | Features |
|-----|-------|----------|
| 5 | Level 1 | 16 UFOs, no satellites |
| 4 | Level 2 | 16 UFOs, no satellites |
| 3 | Level 3 | 16 UFOs + 4 satellites |
| 2 | Level 4 | 16 UFOs + 4 satellites |
| 1 | Level 5 | 16 UFOs + 4 satellites |
| 0 | **Victory** | Game complete! |

### Level Completion ($5CB8-$5D08)

Triggered when `JSR $5C78` detects all 16 aliens are type 4 (TV):

```
$5CB8: LDA #$50 / JSR $4AE0    ; 50-point bonus
$5CBD: DEC $3A                  ; Advance level
$5CE9: LDA $3A / BEQ victory   ; $3A = 0 → Victory!
$5CFC: JSR $5227 (×4)          ; Spawn satellites (if $3A < 4)
       Reset all aliens to type 1 (UFO)
       Continue to next level → JMP $5875
```

### Life Lost ($5839)

```asm
$5839: DEC $10          ; Decrement lives
$583B: BMI game_over    ; If negative → Game Over at $4A86
       ; Otherwise continue playing
```

Game over at $4A86 checks current score against high score, updates if higher, then restarts at $5809.

## Progressive Difficulty System

The game accelerates as you play, controlled by an index into 8 parallel lookup tables.

### Key Variables

| Variable | Role |
|----------|------|
| $30 | Difficulty index (11=easiest, 0=hardest) |
| $31 | Steps until next difficulty increase |
| $2E | Frame timing counter (counts UP, wraps → reload from $2F) |
| $2F | Frame timing reload value (set by difficulty table) |

### Difficulty Increase ($56E4)

Called each time the player hits something:

```asm
$56E4: DEC $31          ; Decrement step counter
$56E6: BNE done         ; Not zero yet → return
$56E8: LDA $30          ; Load difficulty index
$56EA: BEQ done         ; Already 0 (max) → return
$56EC: DEC $30          ; Increase difficulty!
$56EE: JMP $56F3        ; Reload ALL timing tables
```

### The 12-Entry Lookup Tables ($576C-$57CB)

`$56F3` uses $30 as index into 8 parallel tables:

| Index | $2F (Frame) | $32 (Fire Rate) | $31 (Steps) | Effect |
|-------|-------------|-----------------|-------------|--------|
| 11 (start) | $E0 | $E0 | $10 | Slowest: ~32 frames/tick, 16 hits to next level |
| 8 | $E6 | $E7 | $18 | Medium: tighter timing |
| 4 | $F5 | $F0 | $28 | Fast: noticeably quicker |
| 0 (max) | $FC | $FC | $FF | Maximum: nearly every frame, never increases again |

**HOW the frame timer works:** Counter $2E counts from the reload value ($2F) up to $FF. When it wraps past $FF, periodic game logic executes (alien firing, movement). Higher $2F values = fewer frames between ticks = faster game.

## Scoring System

### BCD Score ($4AE0)

```asm
$4AE0: SED              ; Set decimal mode (BCD arithmetic)
$4AE1: CLC
$4AE2: ADC $0C          ; Add points to score low byte
$4AE4: STA $0C
$4AE6: LDA $0D          ; Carry to high byte
$4AE8: ADC #$00
$4AEA: STA $0D
$4AEC: CLD              ; Clear decimal mode
```

| Action | Points |
|--------|--------|
| Hit alien | 1 |
| Hit satellite | Variable (from $5212,X) |
| Level complete bonus | 50 |

Score at $0C-$0D, high score at $0E-$0F. Both stored in BCD (Binary-Coded Decimal) so they display directly without conversion.

## Sprite System

### Pre-Shifted Architecture

All sprites are stored with **7 pre-shifted copies**, the standard Apple II optimization for fast horizontal positioning. Each copy is shifted 1 pixel right from the previous, covering all 7 bit positions within a byte.

**HOW:** The sprite pointer tables at $5D7C (low) / $5E1D (high) / $5EBE (width) / $5F5F (height) are indexed by sprite number. `DrawSpriteXY` at $40C0 takes position in $02/$04 and sprite index in A.

**WHY pre-shifting:** Apple II HGR memory packs 7 pixels per byte (bit 7 is a color flag). To draw a sprite at an arbitrary X position, you'd need to shift every byte at runtime --- expensive on a 1MHz 6502. Pre-computing all 7 shifts trades 7x memory for zero runtime shift cost.

### Color Control

Bit 7 ($80) in each sprite byte selects the color palette:
- Bit 7 = 0: Green/Violet (group 1)
- Bit 7 = 1: Orange/Blue (group 2)

The directional arrows at $6070-$6085 all have bit 7 set (orange/blue), making them visually distinct from the aliens.

## Sound System

Sound is produced by toggling the speaker at $C030, with timing loops controlling pitch:

| Location | Method | Context |
|----------|--------|---------|
| $3E60 | `LDX $C030` | Broderbund intro |
| $45F6 | `STA $C030` | Projectile fire |
| $4C6B, $4C86, $4D0C | `BIT $C030` in timing loops | Tonal sound effects |
| $4F43, $4F53 | `STA $C030` | Satellite hit |
| $5B73 | `BIT $C030` with X countdown | General sound effect |

**HOW:** The 6502 toggling `$C030` at different intervals produces different frequencies. Tighter loops = higher pitch. The `InputProcessC` routine at $5B6F uses a counted `DEX/BNE` loop to generate tones, with the loop count in A controlling pitch.

## The Cheat Code

### Shift-N ($9E) During Level Completion Animation

**When:** During the level completion animation (big TV sweep), press **Shift-N**.

**Location:** $4CEF-$4D02 inside the `SUB_4C99` animation routine.

```asm
$4CEF: LDA $C000        ; Read keyboard
$4CF2: CMP #$9E         ; Shift-N? (caret ^ on Apple II keyboard)
$4CF4: BNE skip
$4CF6: LDA $C010        ; Clear keyboard strobe
$4CF9: LDA #$0B
$4CFB: STA $30          ; Reset difficulty to EASIEST (index 11)
$4CFD: LDA #$03
$4CFF: CLC
$4D00: ADC $10          ; Add 3 to lives
$4D02: STA $10
```

**Two effects:**
1. **+3 lives** added to current count
2. **Difficulty reset** to index 11 (easiest), undoing all accumulated speed increases

**Why Shift-N?** On the Apple II/II+ keyboard, Shift-N produces the caret character (`^`), which generates key code $9E. This is different from modern keyboards where caret is Shift-6. The key was chosen because it's easy to reach, doesn't conflict with game controls (Y/G/J/Space/ESC/A/F), and obscure enough that players wouldn't find it by accident.

**Can be activated multiple times** during a single animation! Scott Schram confirms this was a developer testing feature that shipped with the game.

## Technical Notes

### Self-Relocating Binary

The unusual load address ($37D7) places the game binary so that:
1. The first section ($3800-$3FFF) overlaps with HGR page 1 ($2000-$3FFF)
2. The bootstrap copies this to $0000-$07FF before HGR is activated
3. The main code ($4000+) sits safely above HGR page 1

This is a Broderbund packaging technique --- the $3800-$3EFF region contains the Broderbund logo intro and the "BR0DERBUND" string (note: zero, not 'O').

### No Page Flipping

Unlike many Apple II action games, Genetic Drift uses **only HGR page 1** ($2000-$3FFF). There is no double-buffering. All drawing is done directly to the visible screen. The game avoids flicker through careful draw ordering: clear old positions, draw new positions, with sprites small enough that the tear is imperceptible at 1MHz.

### Custom RWTS ($025D)

The relocated block at $0000-$07FF contains Broderbund's custom RWTS (Read/Write Track/Sector) routine, which handles the non-standard nibble encoding used for copy protection. This is why standard DOS 3.3 tools and cp2 cannot read the disk image.

### Random Number Generator ($0403)

Located in the relocated block, this RNG is called throughout the game for:
- Alien projectile type selection (heart probability)
- Satellite spawn positions
- Star twinkle patterns
- Timing variations

### Compact Design

At 14,889 bytes, Genetic Drift is remarkably compact:
- ~5KB of sprite data (pre-shifted, 7 copies each)
- ~1KB of lookup tables (difficulty, positions, pointers)
- ~8KB of game logic code
- ~1KB bootstrap + relocated block

74 subroutines, 210 identified loops, 876 pattern matches detected by the disassembler.


## Recovered Source Code

The main deliverable is `genetic_drift_source.s` — a clean, annotated reconstruction of Scott Schram's original assembly source. This is not a raw disassembly; it reads like hand-written source code with named variables, section headers, and design commentary.

| Metric | Count |
|--------|-------|
| Named zero-page variables | 59 |
| Annotated functions | 67 |
| Documented data tables | 28 |
| Labeled subroutine calls | 32 |
| Machine noise remaining | 0 |

## Artifacts

| File | Description |
|------|-------------|
| `genetic_drift_source.s` | **Recovered source code** — clean annotated assembly |
| `disassembly/genetic_drift_annotated.s` | Raw deasmiigs machine output (input to transformation) |
| `disassembly/genetic_drift_complete.s` | Raw disassembly with register state tracking |
| `analysis/game_mechanics.md` | Complete game mechanics documentation |
| `analysis/genetic_drift_analysis.md` | Deep analysis of game architecture |
| `graphics/sprite_*.png` | All 32 extracted sprites |
| `extracted/genetic_drift_game_binary.bin` | Raw game binary (14,889 bytes) |
| `Genetic_Drift_Instructions.pdf` | Scanned original game manual |

## Tools

| Tool | Purpose |
|------|---------|
| `tools/annotate_genetic_drift_final.py` | Source recovery — transforms machine output to clean annotated assembly |
| `tools/disasm6502.py` | 6502 disassembler with CFG tracing, SMC detection, semantic labels |
| `tools/extract_dos33.py` | DOS 3.3 file extractor (bypasses copy protection by reading raw sectors) |
| `tools/extract_sprites.py` | HGR sprite extractor with pre-shift detection |
| `tools/memviz.py` | Memory access pattern visualization |

## Strategic Summary

The genius of Genetic Drift is the asymmetry between progress and punishment:

- **3 hits** to evolve an alien from UFO to TV
- **5 hits** to recover from TV→Diamond back to TV (through Bowtie→UFO→Eye1→Eye2→TV)
- **1 mistake** (hitting a heart) transforms an entire side of 4 aliens to Diamonds = **20 hits** of lost progress
- Hearts only appear when you're *almost done* (all 4 aliens on a side are TVs)
- The game gets *faster* as you score, so mistakes compound

This creates escalating tension: the closer you are to completing a level, the more dangerous the game becomes. Perfect play requires knowing when to stop shooting.

---
*Reverse-engineered by Scott Schram and Claude Code using the Rosetta v2 toolchain.*
*Based on the collaborative 2025 disassembly of the original 1981 Apple II binary.*

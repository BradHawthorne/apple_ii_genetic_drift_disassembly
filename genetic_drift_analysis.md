# Genetic Drift - Disassembly Analysis

Cowritten by Claude Code Opus 4.5

## Overview
- **Load Address**: $37D7 (in file header)
- **Binary Size**: 14,889 bytes ($3A29)
- **Memory Range**: $37D7-$71FF (in original load location)
- **Actual Runtime**: Code relocates and runs starting at $57D7

## File Structure

### 1. Bootstrap Loader ($37D7-$37FF)
```
$37D7: STA $C010       ; Clear keyboard strobe
$37DA: LDA #$38        ; Set up source pointer at $3800
$37DC: STA $01
$37DE: LDA #$00        ; Set up dest pointer at $0000
$37E0: STA $03
$37E2: LDA #$40        ; Copy until source reaches $4000
$37E4: STA $04
; ... copy loop ...
$37FD: JMP $57D7       ; Jump to main game code
```

The loader copies data from $3800-$3FFF to $0000-$07FF (8 pages), then jumps to the game.

### 2. Broderbund Intro/Loader ($3800-$3EFF approx)
Contains the "BR0DERBUND" logo data at $3EF0 (note: uses zero, not 'O' - likely stylized).
This section handles the intro screen and possibly copy protection checks.

### 3. Main Game Code ($57D7+)
The actual game starts here after relocation.

## Key Entry Points

| Address | Function |
|---------|----------|
| $57D7 | **Main entry** - CLD, JSR $415B (init?) |
| $57DB | Title/setup - calls $4120, $43B5 |
| $5809 | **Game start** - initializes level, calls $4D73 |
| $5875 | **Main game loop** - processes game logic |
| $4120 | Graphics init (sets TXTCLR, HIRES, MIXCLR at $4134) |

## Hardware Access

### Graphics Mode (at $4134-$413A)
```
LDA $C050   ; TXTCLR - enable graphics
LDA $C057   ; HIRES - hi-res mode
LDA $C052   ; MIXCLR - full screen (no text window)
```
**Note**: Only Page 1 ($C054) is used - **no page flipping** in this game.

### Keyboard Input
- $C000 read at $57D8, $5802, $4AD8, $4CEF, etc.
- Checks for RETURN ($8D) to start game
- $C061 (PB0 - paddle button) at $5891

### Speaker (Sound Effects)
Multiple speaker toggles ($C030):
- $3E60: LDX $C030
- $45F6: STA $C030
- $4C6B, $4C86, $4D0C: BIT $C030 (timing loops for tones)
- $4F43, $4F53: STA $C030

## Memory Map (Zero Page Usage)
| ZP Addr | Purpose |
|---------|---------|
| $00-$01 | Source pointer / counter |
| $02-$04 | Destination pointer / graphics calc |
| $0C-$0F | Score or state variables |
| $10 | Lives counter |
| $11 | Level/wave number? |
| $19 | Y-coordinate for drawing |
| $2B | Game state |
| $2C-$2E | Initialized to $F0 |
| $30 | Game state |
| $34-$36 | Game flags |
| $3A | Constant (5) |

## Subroutine Map

### Graphics/Display
| Address | Function |
|---------|----------|
| $4120 | Init hi-res graphics mode |
| $415B | Called at game start |
| $40C0 | Draw routine (called with X as index) |
| $52A1 | Draw routine |
| $527F | Draw routine |
| $52E5 | Draw routine |
| $52F3 | Called in main loop |

### Game Logic
| Address | Function |
|---------|----------|
| $42FC | Called during title wait |
| $43B5 | Setup/init |
| $4387 | Setup |
| $437A | Setup |
| $43CD | Per-frame update |
| $457F | Main loop - game logic |
| $4A86 | Game over / level transition |
| $4D73 | Level setup |

### Input/Control
| Address | Function |
|---------|----------|
| $4F5B | Input processing? |
| $5B4F | Input/state |
| $5B77 | Input/state |
| $5C1C | Called in main loop |
| $5C78 | Called in main loop |

### Movement/Collision
| Address | Function |
|---------|----------|
| $5370 | Movement routine |
| $56F3 | Movement routine |
| $53B8-$53FC | Position/state tables |

## Data Tables

### Sprite/Shape Data
Large blocks of data at:
- $5D99-$5E06: Movement tables (incrementing values)
- $607F+: Sprite patterns
- $61DA+: More sprite data (repeated patterns)
- $6A30+: "BBJR*T*U*TJRBB" pattern data

### Screen Layout
The game uses hi-res page 1 ($2000-$3FFF) only. Based on your description:
- Left side: Text area (Title, stats, copyright)
- Right side: Playfield with base and aliens

## Game Flow

```
$57D7: Main Entry
    │
    ├─► $415B: Initialize
    │
    ▼
$57DB: Title Screen
    │
    ├─► $4120: Set hi-res mode (page 1 only, no flipping)
    ├─► $43B5: Setup title screen
    ├─► Clear score ($0C-$0D) and high score ($0E-$0F)
    │
    ▼
$57FE: Wait for RETURN key ($8D)
    │
    ▼
$5809: Start New Game
    │
    ├─► Set lives ($10) = 3
    ├─► Set level ($3A) = 5 (counts DOWN to 0)
    ├─► $4D73: Level setup
    ├─► Set direction ($11) = 0 (UP)
    ├─► Set difficulty ($30) = $0B (easiest)
    ├─► $56F3: Load difficulty timing tables
    ├─► $5370: Set 4-dir fire ammo ($536F) = 3
    │
    ▼
$5875: Main Game Loop ◄─────────────────────────────────┐
    │                                                    │
    ├─► $457F: Move all 4 laser beams (player shots)    │
    ├─► $52F3: Redraw screen/sprites                    │
    ├─► $4F5B: Check laser vs SATELLITE collisions      │
    ├─► $5C1C: Update star twinkle animation            │
    ├─► $5C78: Check if all 16 aliens are TVs           │
    │       │                                            │
    │       └─► YES: Level Complete! ──────────┐        │
    │                                          │        │
    ├─► $43E0: Keyboard handler                │        │
    │       ├─► Y=$D9: Direction=UP (0)        │        │
    │       ├─► J=$CA: Direction=RIGHT (1)     │        │
    │       ├─► SPACE=$A0: Direction=DOWN (2)  │        │
    │       ├─► G=$C7: Direction=LEFT (3)      │        │
    │       ├─► ESC=$9B: Fire (set $36 flag)   │        │
    │       └─► A/F: 4-direction fire ($5381)  │        │
    │                                          │        │
    ├─► Check paddle button ($C061)            │        │
    │       └─► Pressed: Fire projectile       │        │
    │                                          │        │
    ├─► $58A5: Fire projectile (if $36 set)    │        │
    ├─► $4D87: Update alien positions          │        │
    ├─► $58CB: Check laser vs ALIEN collisions │        │
    │       │                                  │        │
    │       └─► HIT: $4E15 alien evolves       │        │
    │           └─► $56E4: Difficulty increase │        │
    │                                          │        │
    ├─► $5A04: Frame timing loop               │        │
    │       ├─► INC $2E (frame counter)        │        │
    │       └─► When wraps: reload from $2F    │        │
    │                                          │        │
    └───────────────────────────────────────────────────┘
                                               │
                                               ▼
$5CB8: Level Complete!
    │
    ├─► Add 50 points bonus ($4AE0)
    ├─► DEC $3A (advance level: 5→4→3→2→1→0)
    ├─► $4D33: Display level number
    ├─► $4C99: Level completion animation
    │       │
    │       └─► CHEAT CHECK: Shift-N ($9E)?
    │               ├─► YES: +3 lives, reset difficulty to $0B
    │               └─► NO: Continue animation
    │
    ├─► Reset all 16 aliens to type 1 (UFO)
    ├─► If $3A < 4: Spawn 4 satellites ($5227 ×4)
    │
    ├─► $3A = 0? ──► YES: VICTORY! ──► $5D09
    │
    └─► NO: Continue to next level ──► Back to $5875

$4B65: Punishment Routine (Heart mistakes)
    │
    ├─► Called when: Hit a heart OR miss upside-down heart
    ├─► Play punishment sound ($4C3C)
    ├─► Transform ALL 4 aliens on that side to DIAMONDS (type 5)
    └─► Redraw affected aliens

$5839: Life Lost
    │
    ├─► DEC $10 (lives)
    ├─► Lives < 0? ──► YES: $4A86 Game Over ──► $5809 Restart
    └─► NO: Continue playing
```

## Sprite Tables

### Organization
Sprites are stored with **7 pre-shifted copies** for fast drawing at any horizontal pixel position. High bit ($80) controls color mode.

### Key Sprite Data Locations

| Address | Size | Description |
|---------|------|-------------|
| $607F | 7 bytes | **Projectile/bullet** - diamond shape |
| $6086+ | ~42 bytes | TV/monitor sprite (7 shifts × 7 rows) |
| $6598+ | ~350 bytes | Alien sprites (multiple types) |
| $61DA+ | ~120 bytes | More alien/character sprites |
| $6A30 | 14 bytes | **TV shape** (2 bytes wide × 7 rows) |
| $6F1E+ | Complex | Additional game sprites |

### Directional Arrows (Base Reticle) - $6070-$6085
Fixed sprites showing which direction the base is aiming. All have color bit set ($80).

```
UP ($6070-$6073, 4 bytes)     DOWN ($607B-$607E, 4 bytes)
      ██                      ██████████████
    ██████                      ██████████
  ██████████                      ██████
██████████████                      ██

LEFT ($6074-$607A, 7 bytes)   RIGHT ($607F-$6085, 7 bytes)
██                                          ██
████                                      ████
██████                                  ██████
████████                              ████████
██████                                  ██████
████                                      ████
██                                          ██
```

## All Alien Sprites

The aliens cycle through 6 forms. Your goal is to get all 16 aliens (4 per side) to become TVs!

### Type 1: UFO Alien
Sprite index $74, Address $69AB, 2 bytes × 7 rows
```
          ######
    ######  ##  ######
  ####  ##  ##  ##  ####
##  ##  ##  ##  ##  ##  ##
##########################
  ######    ##    ######
    ##              ##
```
The classic flying saucer shape - starting alien form.

### Type 2: Eye Alien (Color 1 - Blue)
Sprite index $35, Address $65AA, 3 bytes × 7 rows
```
          ##########
      ######  ##  ######
  ######  ##  ##  ##  ######
########  ##      ##  ########
  ######  ##  ##  ##  ######
      ######  ##  ######
          ##########
```
An eye-shaped alien with a pupil in the center.

### Type 3: Eye Alien (Color 2 - Green)
Sprite index $5F, Address $6859, 3 bytes × 7 rows
```
            ##########
        ######  ##  ######
    ######  ##  ##  ##  ######
  ########  ##      ##  ########
    ######  ##  ##  ##  ######
        ######  ##  ######
            ##########
```
Same eye shape, different color palette (hi-res color bit differs).

### Type 4: TV (THE GOAL!)
Sprite index $66, Address $6898, 2 bytes × 9 rows
```
    ##      ##              ← rabbit ear antennas
      ##  ##                ← antennas converging
        ##                  ← antenna base
##################          ← top of cabinet
##          ##  ##          ← screen + knob
##          ######          ← screen + knob
##          ##  ##          ← screen + knob
##          ######          ← screen + knob
##################          ← bottom of cabinet
```
**THE GOAL!** You want all aliens to become TVs. DON'T hit the TV - if you do, it cycles to Diamond and you need 5 more hits to get back!

### Type 5: Diamond Alien (PENALTY STATE!)
Sprite index $6D, Address $691F, 2 bytes × 7 rows
```
            ####
        ##  ####  ##
    ##  ##  ####  ##  ##
##  ######  ####  ##  ##  ##
    ##  ##  ####  ##  ##
        ##  ####  ##
            ####
```
**THE PENALTY STATE!** When you hit a heart or miss an upside-down heart, ALL aliens on that side transform into diamonds. Also appears after accidentally hitting a TV.

### Type 6: Bowtie Alien
Sprite index $7B, Address $6A30, 2 bytes × 7 rows
```
  ##        ##  ##        ##
  ##  ##    ##  ##    ##  ##
  ##  ##  ##      ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##      ##  ##  ##
  ##  ##    ##  ##    ##  ##
  ##        ##  ##        ##
```
The bowtie shape - just another alien form in the cycle, one step before wrapping back to UFO.

### Alien Type to Sprite Lookup - $53C8

The game maps alien types (0-6) to sprite indices using this table at $53C8:

| Alien Type | Sprite Index | Address | Sprite |
|------------|--------------|---------|--------|
| 0 | $00 | - | Empty/starting |
| 1 | $74 | $69AB | UFO Alien |
| 2 | $35 | $65AA | Eye Alien (color 1) |
| 3 | $5F | $6859 | Eye Alien (color 2) |
| 4 | $66 | $6898 | **TV** (GOAL!) |
| 5 | $6D | $691F | **Diamond** (PENALTY!) |
| 6 | $7B | $6A30 | Bowtie Alien |

The sprite index is used with the shape table:
- Low byte pointer at: `$5D7C + index`
- High byte pointer at: `$5E1D + index`
- Width at: `$5EBE + index`
- Height at: `$5F5F + index`

### Position/State Tables - $53B8+
These tables at $53B8-$53FF contain:
- Alien type values ($53B8-$53C7): 16 entries, 4 per direction
- Sprite index lookup ($53C8-$53CE): maps type → sprite
- Screen coordinates
- Movement deltas

## Main Game Loop - Detailed Analysis

The game loop at **$5875** runs continuously during gameplay. Here's what happens each tick:

### Game Loop Flow ($5875)
```
$5875: JSR $457F    ; Move all 4 LASER BEAMS (player shots)
$5878: JSR $52F3    ; Redraw screen/sprites
$587B: JSR $4F5B    ; Check laser beam vs SATELLITE collisions
$587E: JSR $5C1C    ; Update star twinkle animation
$5881: JSR $5C78    ; Check if all aliens type 4 (level complete?)
       ; Check ESC key ($36) for pause
       ; Check paddle button ($C061) for firing
       ; Fire laser beam if button pressed
$58C3: JSR $4D87    ; Update alien positions
       ; Loop through all 4 directions checking laser vs alien collisions
$596E: ; Continue to boundary checks
       ; Process keyboard for direction changes
$5875: ; Loop back
```

### Terminology
- **Laser beams**: What the BASE fires (player's weapon)
- **Projectiles**: What the ALIENS shoot back at you
- **Satellites**: Bonus targets that orbit - hit for points

### Projectile Movement ($457F)

The game supports **4 simultaneous projectiles** (one for each direction: UP/LEFT/DOWN/RIGHT). Each projectile's state is tracked in tables:

| Table | Purpose |
|-------|---------|
| $5D58,X | Projectile active flag (0=inactive, 1=active) |
| $5D48,X | X position (low byte) |
| $5D4C,X | X position (high byte, for diagonal) |
| $5D50,X | Y position |
| $5D54,X | Projectile state (0=none, 2=exploding, 3=active) |
| $5D5C,X | Projectile X (for drawing) |
| $5D60,X | Projectile X high |
| $5D64,X | Projectile Y (for drawing) |

**Movement per tick (at $457F):**
- **Direction 0 (UP)**: Y decreases by 3 pixels (`SBC #$03` at $45A2)
- **Direction 1 (LEFT)**: X decreases by 3 pixels (`SBC #$03` at $45D9)
- **Direction 2 (DOWN)**: Y increases by 3 pixels (`ADC #$03` at $45C4)
- **Direction 3 (RIGHT)**: X increases by 3 pixels (`ADC #$03` at $4615)

### Collision Detection ($58CB-$596E)

The collision system is **direction-specific** and checks projectile positions against alien positions:

```
$58CB: Loop through X = 3 down to 0 (all 4 directions)
$58CE:   If projectile not active, skip
$58D3:   If projectile state = 0, skip
$58DE:   Branch by direction:
           X=0 (UP):    Compare $5D64 >= $5D50 (projectile Y vs alien Y)
           X=1 (LEFT):  Compare $5D60 >= $5D4C AND $5D5C >= $5D48
           X=2 (DOWN):  Compare $5D64 < $5D50
           X=3 (RIGHT): Compare $5D5C < $5D48
$591E:   HIT! Call $44C4 (draw hit), $4441 (clear sprite)
$595E:   Add 1 point: JSR $4AE0 with A=1
$5962:   Play hit sound
```

**Why collisions feel precise:** The comparisons are simple greater-than/less-than checks on the position coordinates. When a projectile reaches or passes the target position in its direction of travel, it's a hit. No bounding box—just "did you reach this line?"

### Boundary Checks ($597A-$59C2)

After collision checks, projectiles that have left the playfield are deactivated:

- **UP (X=0)**: Deactivate if Y position = 0
- **LEFT (X=1)**: Deactivate if X < $17 and high byte underflowed
- **DOWN (X=2)**: Deactivate if Y position = $BF (191, screen bottom)
- **RIGHT (X=3)**: Deactivate if X position = $3E (62, right edge)

### Firing a Projectile ($58A5-$58C0)

When the fire button is pressed:
```
$58A5: LDX $11           ; Get current direction (0-3)
$58A7: LDA $5D58,X       ; Check if projectile already active
$58AA: BNE skip          ; If active, can't fire another
$58AC: LDA #$01          ; Set projectile active
$58AE: STA $5D58,X
       ; Copy base position to projectile start position:
$58B1: LDA $5D68,X → STA $5D5C,X  ; Base X → Projectile X
$58B7: LDA $5D6C,X → STA $5D60,X  ; Base X high
$58BD: LDA $5D70,X → STA $5D64,X  ; Base Y → Projectile Y
```

### Keyboard Handler ($43E0)

Direction keys set $11 (current direction):
| Key | ASCII | Direction | $11 Value |
|-----|-------|-----------|-----------|
| Y   | $D9   | UP        | 0 |
| J   | $CA   | RIGHT     | 1 |
| SPACE | $A0 | DOWN      | 2 |
| G   | $C7   | LEFT      | 3 |

The keys form a diamond pattern matching the screen directions: Y (up), G (left), J (right), Space (down).

Fire keys:
- **ESC** ($9B) - Fire in current direction (sets $36 flag which triggers fire at $58A5)
- **A** ($C1) - **4-DIRECTION SIMULTANEOUS FIRE!** (limited uses per level, stored at $536F)
- **F** ($C6) - Same as A (4-direction fire)

ESC was the original fire key, but players complained about wearing out the key. The A key was added as the "super shot" that fires in all 4 directions simultaneously, with limited uses per level. When uses run out, A/F fall back to single-direction fire like ESC.

### Scoring ($4AE0)

Score stored in BCD at $0C-$0D:
```
$4AE0: SED           ; Set decimal mode
$4AE1: CLC
$4AE2: 65 0C        ADC $0C    ; Add to score low
$4AE4: 85 0C        STA $0C
$4AE6: LDA $0D               ; Carry to high
$4AE8: ADC #$00
$4AEA: STA $0D
$4AEC: CLD           ; Clear decimal mode
```

High score comparison and lives ($10) update handled at $4A86 (game over check).

## Data Tables Reference

### Projectile/Entity State Tables ($5D48-$5D78)

| Offset | Table | Description |
|--------|-------|-------------|
| $5D34-$5D37 | Base X positions | 4 directions |
| $5D38-$5D3B | Base Y positions | 4 directions |
| $5D3C-$5D3F | Alien track X | Per direction |
| $5D44-$5D47 | Alien track Y | Per direction |
| $5D48-$5D4B | Projectile X low | 4 projectiles |
| $5D4C-$5D4F | Projectile X high | 4 projectiles |
| $5D50-$5D53 | Projectile Y | 4 projectiles |
| $5D54-$5D57 | Projectile state | 0/2/3 |
| $5D58-$5D5B | Projectile active | 0/1 |
| $5D5C-$5D5F | Draw X low | 4 projectiles |
| $5D60-$5D63 | Draw X high | 4 projectiles |
| $5D64-$5D67 | Draw Y | 4 projectiles |
| $5D68-$5D6B | Base X (spawn) | 4 directions |
| $5D6C-$5D6F | Base X high | 4 directions |
| $5D70-$5D73 | Base Y (spawn) | 4 directions |

## Notes

1. **No Page Flipping**: The game only uses hi-res page 1. Your memory of using page flipping must be from later games.

2. **Broderbund Packaging**: The unusual load address ($37D7) and loader suggest this was distributed through Broderbund's catalog, which added their intro screen.

3. **Pre-shifted Sprites**: Classic Apple II optimization - 7 copies of each sprite, each shifted 1 pixel right, allows drawing at any X position without runtime bit-shifting.

4. **Compact Code**: At ~15KB, this is a tight game. Most of the space is code with embedded data tables for sprites and game state.

5. **Sound**: Multiple sound routines using speaker toggle timing loops - typical of Apple II games.

6. **Precise Collision**: You were right about the collision detection being precise. It uses simple coordinate comparisons—when the projectile's coordinate crosses the target's coordinate in the direction of travel, it's a hit. No fuzzy bounding boxes.

## Alien Evolution Mechanic ("Genetic Drift")

The game's title refers to the **mutation/evolution system** for aliens.

### Alien Type Table ($53B8)

Each alien's current form is stored in the `$53B8` table (16 entries, 4 per direction):

| Type | Form | Notes |
|------|------|-------|
| 0 | Empty/Starting | Initial state |
| 1 | UFO Alien | Flying saucer shape |
| 2 | Eye Alien (color 1) | Eye with pupil |
| 3 | Eye Alien (color 2) | Same shape, different color |
| 4 | **TV** | **THE GOAL!** Don't hit this! |
| 5 | **Diamond** | **PENALTY STATE!** Heart mistakes set all to this |
| 6 | Bowtie Alien | Just another form in the cycle |
| 7 | Wraps to 1 | Cycle continues |

### Evolution Logic (at $4E15-$4E24)
```
$4E15: INC $53B8,X    ; Alien evolves to next form
$4E18: LDA $53B8,X
$4E1B: CMP #$07       ; If reached 7...
$4E1D: BCC done
$4E1F: LDA #$01       ; ...wrap back to form 1
$4E21: STA $53B8,X
```

### Penalty: Diamond Transformation - "Punishment Routine" ($4B65)

When you hit a heart or miss an upside-down heart, this routine transforms ALL aliens on that side into diamonds (type 5):

```asm
;===========================================================
; PUNISHMENT ROUTINE - Transform all aliens on one side to bowties
; Called when: hitting a heart OR missing an upside-down heart
; Input: $57D6 = direction (0=UP, 1=LEFT, 2=DOWN, 3=RIGHT)
;===========================================================
SUB_4B65:
    $4B65: LDA $57D6        ; Get current direction
    $4B68: JSR $4C3C        ; Play punishment sound effect

    ; Calculate starting index into $53B8 table
    ; Each direction has 4 aliens, so index = (direction * 4) + 3
    $4B6B: LDA $57D6        ; Get direction again
    $4B6E: ASL              ; × 2
    $4B6F: ASL              ; × 4
    $4B70: CLC
    $4B71: ADC #$03         ; Add 3 (start at end of this direction's group)
    $4B73: TAX              ; X = starting index

    ; Transform all 4 aliens on this side to DIAMONDS
    $4B74: LDY #$03         ; Loop counter (4 aliens: 3,2,1,0)
    $4B76: LDA #$05         ; Type 5 = DIAMOND (the penalty state!)
L_4B78:
    $4B78: STA $53B8,X      ; Set alien type to DIAMOND
    $4B7B: DEX              ; Previous alien
    $4B7C: DEY              ; Decrement counter
    $4B7D: BPL L_4B78       ; Loop until all 4 done

    ; Now jump to direction-specific redraw routine
    $4B7F: LDX $57D6        ; Get direction
    $4B82: BNE L_4B87       ; If not UP, check others
    $4B84: JMP $54C5        ; Direction 0 (UP) - redraw top aliens

L_4B87:
    $4B87: CPX #$01
    $4B89: BNE L_4B8E
    $4B8B: JMP $5461        ; Direction 1 (LEFT) - redraw left aliens

L_4B8E:
    $4B8E: CPX #$02
    $4B90: BNE L_4B95
    $4B92: JMP $5529        ; Direction 2 (DOWN) - redraw bottom aliens

L_4B95:
    $4B95: JMP $53FD        ; Direction 3 (RIGHT) - redraw right aliens
```

**Memory layout of $53B8 alien type table:**
```
$53B8-$53BB: Direction 0 (UP)    - 4 aliens
$53BC-$53BF: Direction 1 (LEFT)  - 4 aliens
$53C0-$53C3: Direction 2 (DOWN)  - 4 aliens
$53C4-$53C7: Direction 3 (RIGHT) - 4 aliens
```

When punishment triggers, one entire row of 4 aliens instantly becomes diamonds!

### Strategic Tension
- Aliens cycle through forms: UFO → Eye1 → Eye2 → **TV** → Diamond → Bowtie → (back to UFO)
- **THE GOAL**: Get all 16 aliens to become **TVs** (type 4) - 4 on each side
- **DON'T hit the TV!** If you hit a TV, it cycles to Diamond and you need 5 more hits to get back
- **Hearts** (projectile type 2): DON'T hit - triggers Diamond penalty on entire side
- **Upside-down Hearts** (projectile type 3): MUST hit before they pass - missing triggers Diamond penalty

The "Genetic Drift" is the aliens cycling through forms as you hit them. Your goal is to:
1. Hit aliens to cycle them toward TV state
2. STOP shooting once they're TVs
3. Avoid hearts (don't shoot)
4. Catch upside-down hearts (must shoot)

One mistake with hearts = entire side becomes Diamonds (5 hits each to get back to TV)!

## Satellite System

Satellites are bonus targets that orbit around the playfield. Each direction can have one satellite.

### Satellite Data Tables

| Address | Size | Purpose |
|---------|------|---------|
| $520E | 4 bytes | Satellite position (one per direction) |
| $5212 | 4 bytes | Satellite points/hits remaining (0 = no satellite) |
| $5221 | 4 bytes | Hit countdown for current satellite |

### Satellite Collision Check ($4F5B)

The `$4F5B` routine checks if laser beams hit satellites:

```asm
SUB_4F5B:
    $4F5B: LDX #$03          ; Check all 4 directions
    $4F5D: STX $12

L_4F5F:
    $4F5F: LDX $12
    $4F61: LDA $5D58,X       ; Is laser beam active?
    $4F64: BNE check_pos     ; If yes, check position
    $4F66: JMP next_dir      ; Otherwise skip

    ; Direction-specific boundary checks:
    ; X=0 (UP):    laser Y < $26?
    ; X=1 (LEFT):  laser X >= $E3?
    ; X=2 (DOWN):  laser Y >= $98?
    ; X=3 (RIGHT): laser X < $71?

L_4F9A:                       ; Laser in satellite zone
    $4F9A: LDY #$03           ; Check all 4 satellite slots
L_4F9F:
    $4FA2: LDA $5212,Y        ; Satellite exists?
    $4FA5: BEQ L_4FF0         ; No, skip
    $4FA7: LDA $520E,Y        ; Get satellite position
    $4FAA: SEC
    $4FAB: LDX $12
    $4FAD: SBC $4FFD,X        ; Compare with laser position
    $4FB0: CMP #$05           ; Within 5 pixels?
    $4FB2: BCS L_4FF0         ; No hit, skip

    ; HIT! Score points
    $4FB4: LDA #$08
    $4FB6: LDY #$10
    $4FB8: JSR $4F35          ; Play hit sound
    $4FBE: LDA $5212,X        ; Get satellite point value
    $4FC1: JSR $4AE0          ; Add to score
    $4FC4: JSR $56E4          ; Visual effect
    $4FCB: STA $5D58,X        ; Deactivate laser beam (A=0)
    $4FD7: DEC $5221,X        ; Decrement hit counter
    $4FDA: BNE L_4FF0         ; If not zero, satellite still exists
    ; Satellite destroyed - respawn logic follows
```

### Satellite Point Values

The value at `$5212,X` determines both:
1. Whether a satellite exists (0 = none)
2. How many points you get for hitting it

Satellites require multiple hits to destroy (tracked by `$5221`).

## Level System

### Level Variable: $3A

The game uses `$3A` as the level counter, counting **down** from 5 to 0:

| $3A Value | Level | Notes |
|-----------|-------|-------|
| 5 | Level 1 | Starting level |
| 4 | Level 2 | |
| 3 | Level 3 | Satellites start appearing |
| 2 | Level 4 | More satellites |
| 1 | Level 5 | Final level |
| 0 | Victory! | Game complete |

### Level Initialization ($5809)
```asm
$5809: LDA #$03        ; 3 lives
$580B: STA $10
$580D: LDA #$05        ; Start at level 5 (first level)
$580F: STA $3A
```

### Level Completion ($5CB8-$5D08)
```asm
$5CB8: LDA #$50        ; 50 points bonus
$5CBA: JSR $4AE0       ; Add to score
$5CBD: DEC $3A         ; Advance to next level (decrement)
...
$5CF6: LDA $3A
$5CF8: CMP #$04        ; If level < 4 (i.e., $3A = 3, 2, 1)...
$5CFA: BCS skip
$5CFC: JSR $5227       ; Spawn satellite (×4 calls)
```

### Satellites Appear on Later Levels
- Levels 1-2 ($3A = 5, 4): No satellites
- Levels 3-5 ($3A = 3, 2, 1): 4 satellites spawned each level

### Victory Check
```asm
$5CE9: LDA $3A
$5CEB: BEQ victory     ; If $3A = 0, game won!
```

## Alien Projectile Types (Hearts)

### Projectile Type Selection ($4B0C)

When aliens fire projectiles, the type depends on the alien states:

```asm
SUB_4B0C:
    ; Check if ALL 4 aliens on this side are type 4 (hearts)
    $4B16: LDY #$03         ; Check 4 aliens
L_4B18:
    $4B18: LDA $53B8,X      ; Get alien type
    $4B1B: CMP #$04         ; Is it type 4 (heart)?
    $4B1D: BNE normal       ; No - fire normal projectile
    $4B1F: DEX
    $4B20: DEY
    $4B21: BPL L_4B18       ; Check all 4

    ; ALL aliens are hearts! Fire special projectile
    $4B23: JSR $0403        ; Get random number
    $4B26: CMP #$10         ; Random < 16?
    $4B28: BCS heart
    $4B2A: LDA #$03         ; Type 3 = UPSIDE-DOWN HEART (must hit!)
    $4B2C: JMP store

heart:
    $4B2F: LDA #$02         ; Type 2 = HEART (don't hit!)
    $4B31: JMP store

normal:
    $4B34: LDA #$01         ; Type 1 = NORMAL projectile
```

### Projectile Types

| Type | Appearance | Action Required |
|------|------------|-----------------|
| 1 | Normal projectile | Hit or let pass |
| 2 | **HEART** | **DON'T HIT!** Triggers bowtie penalty |
| 3 | **UPSIDE-DOWN HEART** | **MUST HIT!** Missing triggers bowtie penalty |

### Heart Probability
- Hearts only appear when **all 4 aliens on that side are type 4**
- When they do appear: ~6% chance upside-down heart, ~94% chance regular heart
- This creates intense moments where you must quickly identify which type it is!

## Random Number Generator

The routine at `$0403` provides random numbers used throughout:
- Projectile type selection (heart vs upside-down heart)
- Satellite position spawning
- Star twinkle patterns
- Various timing variations

## Cheat Code: Extra Lives

### The Secret: Shift-N (The Caret Key!)

**Press Shift-N during the level completion animation to get 3 extra lives!**

On the original Apple II and Apple II+ keyboard, **Shift-N produces the caret `^` character**, which generates key code `$9E`. This is different from modern keyboards where caret is Shift-6.

### Location: $4CEF-$4D02 (in SUB_4C99)

The cheat is embedded in the level completion animation routine (when the big TV sweeps around collecting aliens). During this animation, the code checks the keyboard:

```asm
$4CEF: LDA $C000       ; Read keyboard
$4CF2: CMP #$9E        ; Is it Shift-N (caret)?
$4CF4: BNE L_4D04      ; No - skip
$4CF6: LDA $C010       ; Clear keyboard strobe
$4CF9: LDA #$0B
$4CFB: STA $30         ; Reset difficulty to level 1
$4CFD: LDA #$03        ; 3 extra lives!
$4CFF: CLC
$4D00: ADC $10         ; Add to current lives
$4D02: STA $10         ; Store new total
```

### How It Works
- **When**: During the level completion animation (big TV sweeping up)
- **Key**: Hold Shift and press N (produces caret `^` on Apple II/II+ keyboard)
- **Effect 1**: Adds **3 lives** to your current count
- **Effect 2**: Resets difficulty index `$30` to $0B (easiest), undoing speed increases!
- Can be activated multiple times during a single animation!

See the "Progressive Difficulty System" section below for details on how `$30` controls game speed.

### The Key Code Explained

| Key | Code | On Apple II/II+ |
|-----|------|-----------------|
| $9E | `$80 + $1E` | Shift-N (caret `^`) |

On the original Apple II keyboard layout:
- **Shift-N** = `^` (caret)
- **Shift-M** = `]` (right bracket)
- **Shift-P** = `@` (at sign)

This is why the cheat code seemed "impossible" to type - people were looking for Ctrl-^ or Shift-6, but on the original Apple II keyboard, caret is on Shift-N!

### Why This Key?

The caret key was a clever choice:
1. **Easy to type** - N is conveniently located, just hold Shift and tap N
2. **Not a game key** - Wouldn't interfere with direction (Y/G/J/Space) or fire (ESC/A/F) keys
3. **Obscure enough** - Players wouldn't accidentally discover it
4. **Quick to hit** - During the brief animation window, you need to react fast

### Note on Disk Image Variants

The internet-circulated hack "Scan for 85 2E A9 03 85 10 and change the 03" is at `$57F3` and modifies the **starting lives count**. This runtime cheat at $4CFD is different - it **adds** 3 to whatever lives you currently have.

### Developer Test Feature

This was left in the game to allow testing later levels without having to play through from the beginning each time. Scott Schram (the author) confirms the cheat shipped with the game and was usable by anyone who knew the secret!

## Progressive Difficulty System

The game features a sophisticated progressive difficulty system that makes the game faster as you play!

### How It Works

**Key Variables:**
- `$30` - Difficulty index (11 = easiest, 0 = hardest)
- `$31` - Difficulty step counter (counts down to trigger difficulty increase)

**The Difficulty Increase Routine at SUB_56E4:**

```asm
SUB_56E4:
    $56E4: C6 31       DEC  $31      ; Decrement step counter
    $56E6: D0 09       BNE  L_56F1   ; If not zero, return
    $56E8: A5 30       LDA  $30      ; Load difficulty index
    $56EA: F0 05       BEQ  L_56F1   ; If already 0 (max difficulty), return
    $56EC: C6 30       DEC  $30      ; Decrease difficulty index (harder!)
    $56EE: 4C F3 56    JMP  $56F3    ; Reload all timing tables!
L_56F1:
    $56F1: 60          RTS
```

**When Difficulty Increases:**

SUB_56E4 is called from two places:
- `$4DDD` - When player projectile hits something
- `$4FC4` - When collecting hearts (after adding score)

Each call decrements `$31`. When `$31` reaches zero:
1. If `$30 > 0`, decrement `$30` (increase difficulty)
2. Jump to SUB_56F3 to reload ALL timing parameters from lookup tables
3. Game becomes faster!

### The 12-Entry Lookup Tables

`SUB_56F3` uses `$30` as an index into 8 lookup tables that control game speed:

**Difficulty Tables at $576C-$57CB:**

| Index | $576C→$2F | $5778→$52F2 | $5784→$55E0 | $5790→$32 | $579C→$57CC | $57A8→$57CF | $57B4→$57D2 | $57C0→$31 |
|-------|-----------|-------------|-------------|-----------|-------------|-------------|-------------|-----------|
| 0 (hardest) | $FC | $F9 | $F8 | $FC | $F4 | $F0 | $F0 | $FF |
| 1 | $FA | $F7 | $F6 | $FA | $F4 | $F0 | $F0 | $2A |
| 2 | $F9 | $F6 | $F4 | $F7 | $F3 | $F0 | $F0 | $2A |
| 3 | $F7 | $F4 | $F1 | $F5 | $F3 | $F0 | $F0 | $30 |
| 4 | $F5 | $F3 | $EF | $F0 | $F2 | $EF | $F0 | $28 |
| 5 | $F4 | $F0 | $ED | $EE | $F2 | $E8 | $F0 | $1E |
| 6 | $F0 | $EC | $EB | $ED | $F1 | $E0 | $F0 | $1E |
| 7 | $EB | $EB | $E9 | $EC | $F1 | $D8 | $F0 | $18 |
| 8 | $E6 | $E8 | $E7 | $E7 | $F0 | $D0 | $F0 | $18 |
| 9 | $E4 | $E6 | $E5 | $E4 | $F0 | $C8 | $F0 | $10 |
| 10 | $E2 | $E4 | $E3 | $E2 | $F0 | $C0 | $F0 | $10 |
| 11 (easiest) | $E0 | $E4 | $E1 | $E0 | $F0 | $C0 | $F0 | $10 |

**What these control:**
- `$2F` - Frame delay reload value (controls main game speed via $2E counter)
- `$32` - Alien firing rate (reload value for $2C counter)
- `$31` - Steps until next difficulty increase
- Other values control various timing aspects

### The Main Frame Timing Loop

At the end of the game loop ($5A04-$5A0A):

```asm
$5A04: INC $2E          ; Increment frame counter
$5A06: BNE L_5A5A       ; If not wrapped, jump to loop top
$5A08: LDA $2F          ; Counter wrapped! Reload from $2F
$5A0A: STA $2E
$5A0C: JSR $450E        ; Execute periodic game logic
...
$5A5A: JMP $5875        ; Back to top of game loop
```

The counter `$2E` counts UP from `$2F` to $FF, then wraps. Higher `$2F` values = fewer frames before action = **faster game**.

### The Cheat Code Effect - NOW UNDERSTOOD!

The cheat code at $4CFB:
```asm
$4CF9: LDA #$0B
$4CFB: STA $30         ; Reset difficulty to easiest (index 11)
$4CFD: LDA #$03
$4CFF: CLC
$4D00: ADC $10         ; Add 3 lives
$4D02: STA $10
```

**The cheat does TWO things:**
1. **Adds 3 lives** (the obvious effect)
2. **Resets difficulty to easiest** by setting `$30` back to $0B

The next time SUB_56E4 is called and `$31` reaches zero, SUB_56F3 will reload all timing parameters from index 11 (easiest), effectively **undoing all the speed increases** that had accumulated!

This makes the cheat extremely powerful for testing - it not only gives you more lives but also resets the game speed back to the beginning.

# Genetic Drift - Game Mechanics Deep Dive

Cowritten by Claude Code Opus 4.6

This document covers two specific systems in detail: the satellite timing/spawning
system and the complete difficulty progression curve. It builds on the existing
analysis in `genetic_drift_analysis.md`.

All addresses are runtime addresses (post-relocation). Code references point to
the annotated disassembly at `genetic_drift_annotated.s`.

---

## 1. Satellite System - Complete Analysis

### Overview

Satellites are bonus targets that orbit the playfield edges. They do NOT appear
on a timer during gameplay. Instead, they are spawned exclusively at level
transitions -- specifically, they are batch-spawned when the player completes a
level, and only on levels 3 through 5.

There is no periodic satellite timer in the main game loop. The satellite
"timing" is entirely event-driven: complete a level, get satellites.

### When Satellites Spawn

Satellites are spawned in the Level Complete routine at `$5CB8` (annotated
disassembly line 6614). After awarding the 50-point bonus, decrementing the
level counter `$3A`, playing the completion animation, and resetting all 16
aliens to type 1 (UFO), the code checks whether to spawn satellites:

```
$5CF6: LDA $3A          ; Load current level counter
$5CF8: CMP #$04         ; Is $3A >= 4?
$5CFA: BCS $5D08        ; YES: skip satellite spawning (return)
$5CFC: JSR $5227        ; NO: Spawn satellite #1
$5CFF: JSR $5227        ; Spawn satellite #2
$5D02: JSR $5227        ; Spawn satellite #3
$5D05: JSR $5227        ; Spawn satellite #4
$5D08: RTS
```

The level counter `$3A` counts DOWN from 5 to 0:

| `$3A` Value | Level | Satellites Spawned? |
|-------------|-------|---------------------|
| 5           | 1     | NO (`$3A >= 4`)     |
| 4           | 2     | NO (`$3A >= 4`)     |
| 3           | 3     | YES - 4 satellites  |
| 2           | 4     | YES - 4 satellites  |
| 1           | 5     | YES - 4 satellites  |
| 0           | Victory! | N/A (game ends) |

The check `CMP #$04; BCS` means: if `$3A >= 4`, skip spawning. So satellites
only appear when `$3A` is 3, 2, or 1 (levels 3, 4, and 5). Four satellites
are spawned each time by calling `SpawnSatellite` four times in succession.

### Satellite Data Tables

| Address     | Size    | Purpose                                            |
|-------------|---------|----------------------------------------------------|
| `$520E`     | 4 bytes | Satellite orbit position index (one per slot)      |
| `$5212`     | 4 bytes | Satellite hit points remaining (0 = no satellite)  |
| `$521A`     | 7 bytes | Sprite index lookup by remaining hit points        |
| `$5221`     | 4 bytes | Current hit countdown (reloaded from `$5212`)      |
| `$5002`     | 256 bytes | Orbit path: Y coordinates (indexed by position)  |
| `$5102`     | 256 bytes | Orbit path: X/screen-row data (indexed by position)|
| `$4FFD`     | 4 bytes | Laser position comparison offsets (per direction)  |

### SpawnSatellite Routine ($5227) - Complete Walkthrough

The spawn routine (line 4996) works as follows:

**Step 1: Find an empty slot**
```
$5227: LDX #$03                 ; Start from slot 3
$5229: LDA $5212,X              ; Check if slot has a satellite
$522C: BEQ $5232                ; If empty (0), use this slot
$522E: DEX                      ; Try next slot
$522F: BPL $5229                ; Loop through all 4 slots
$5231: RTS                      ; All slots full - abort
```

**Step 2: Set hit points based on current level**
```
$5232: STX $5225                ; Save chosen slot index
$5235: LDA $3A                  ; Load level counter
$5237: CMP #$03                 ; Level 3? ($3A = 3)
$5239: BEQ $5244                ;   -> hit points = 2
$523B: CMP #$02                 ; Level 4? ($3A = 2)
$523D: BNE $5249                ;   -> hit points = 4
$523F: LDA #$04                 ; Level 4: 4 hits to destroy
$5241: JMP $524B
$5244: LDA #$02                 ; Level 3: 2 hits to destroy
$5246: JMP $524B
$5249: LDA #$06                 ; Level 5 (or anything else): 6 hits
$524B: STA $5212,X              ; Store as hit points
$524E: STA $5221,X              ; Also store as hit countdown
```

**Satellite Hit Points by Level:**

| Level | `$3A` | Hits to Destroy | Points per Hit | Total Points |
|-------|-------|-----------------|----------------|--------------|
| 3     | 3     | 2               | 2              | 4            |
| 4     | 2     | 4               | 4              | 16           |
| 5     | 1     | 6               | 6              | 36           |

The hit points value serves double duty: it is BOTH the number of hits required
to destroy the satellite AND the point value awarded per hit. This means later
levels have dramatically more valuable satellites (6 points x 6 hits = 36 total
per satellite on level 5, versus 2 x 2 = 4 total on level 3).

**Step 3: Choose a random orbit position (with collision avoidance)**
```
$5251: JSR $0403                ; Get random number (0-255)
$5254: CMP #$F0                 ; Is it >= 240?
$5256: BCS $5251                ; Yes: reject, try again (keep position < 240)
$5258: STA $5226                ; Store candidate position

; Check that no existing satellite is within 10 positions
$525B: LDY #$03                 ; Check all 4 slots
$525D: LDA $5212,Y              ; Does this slot have a satellite?
$5260: BEQ $5271                ; No: skip distance check
$5262: LDA $5226                ; Load candidate position
$5265: SEC
$5266: SBC $520E,Y              ; Subtract existing satellite's position
$5269: CMP #$0A                 ; Is distance < 10?
$526B: BCC $5251                ; Yes: too close, pick new random position

$526D: CMP #$F6                 ; Is distance >= 246 (wrapped, also within 10)?
$526F: BCS $5251                ; Yes: too close, pick new position

$5271: DEY                      ; Check next slot
$5272: BPL $525D                ; Loop through all slots

; Position accepted - store it
$5274: LDA $5226
$5277: LDX $5225
$527A: STA $520E,X              ; Set orbit position for this satellite
$527D: RTS
```

The collision avoidance ensures satellites are at least 10 orbit-path steps apart
from each other. The position range is 0-239 ($00-$EF), forming a closed orbit
loop around the playfield perimeter.

### Satellite Orbit Path

The orbit path is defined by two 256-byte lookup tables starting at `$5002`
(Y coordinates) and `$5102` (X/screen row data). The position index in
`$520E` is used to look up the satellite's screen coordinates:

```
; From DrawSatelliteE ($52CF):
$52CF: LDA $520E,X              ; Get orbit position index
$52D2: TAY
$52D3: LDA $5102,Y              ; Look up X coordinate from orbit table
$52D6: STA $04                  ; Store for drawing
$52D8: LDA $5002,Y              ; Look up Y coordinate from orbit table
$52DB: STA $19                  ; Store for drawing
```

The orbit path traces a rectangle around the playfield edges. Looking at the
Y-coordinate data at `$5002` (starting at `$5002`, offset from the `$4FFD`
data block):

- Positions 0-63: Top edge, Y values descend from ~$89 to ~$2D (moving left)
- Positions 64-127: Left edge, Y values ascend from ~$2D to ~$A4 (moving down)
- Positions 128-191: Bottom edge, Y values descend from ~$A4 to ~$98 then
  back up (moving right)
- Positions 192-239: Right edge, Y values descend from ~$98 to ~$21 then back
  (moving up)

### Satellite Movement: Decrement-Based Orbit

Satellites move by DECREMENTING their orbit position index each frame (in the
RedrawScreen routine at `$52F3`). The relevant code:

```
; RedrawScreen ($52F3) - called every game frame
$52F3: INC $52F1                ; Increment redraw sub-counter
$52F6: BEQ $52F9                ; When wraps to 0, do actual redraw
$52F8: RTS                      ; Otherwise skip (throttled by $52F2)

$52F9: LDA $52F2                ; Reload sub-counter from difficulty table
$52FC: STA $52F1
$52FF: DEC $52F0                ; Cycle through satellite slots (3->2->1->0->3...)
$5302: BPL $5309
$5304: LDA #$03
$5306: STA $52F0                ; Reset to slot 3

$5309: LDX $52F0                ; Get current satellite slot
$530C: LDA $5212,X              ; Does this slot have a satellite?
$530F: BEQ $5336                ; No: skip

; Move satellite: decrement orbit position
$5311: LDA $520E,X              ; Get current orbit position
...
$5330: DEC $520E,X              ; Move satellite one step along orbit path
$5333: JSR $52C3                ; Draw satellite at new position
```

The satellite movement speed is throttled by the `$52F2` value (Table 2 from the
difficulty lookup tables). At easiest difficulty, `$52F2 = $E4` (-28), meaning
the sub-counter needs to increment 28 times before wrapping. At hardest,
`$52F2 = $F9` (-7), so it wraps every 7 frames -- satellites move roughly 4x
faster.

Additionally, only one satellite is updated per redraw cycle (slots are cycled
through round-robin via `$52F0`), so with 4 satellites active, each individual
satellite moves once every 4 redraw cycles.

### Satellite Collision Detection ($4F5B)

The satellite hit check (line 4867) runs every game frame from the main loop.
It checks whether any active laser beam has entered the satellite zone for its
direction:

**Direction-specific zone boundaries:**

| Direction | Check                        | Satellite Zone            |
|-----------|------------------------------|---------------------------|
| UP (0)    | Laser Y < `$26` (38 pixels)  | Top edge of playfield     |
| LEFT (1)  | Laser X >= `$E3` (227 pixels)| Left edge of playfield    |
| DOWN (2)  | Laser Y >= `$98` (152 pixels)| Bottom edge of playfield  |
| RIGHT (3) | Laser X < `$71` (113 pixels) | Right edge of playfield   |

If a laser is in the satellite zone, the code compares the laser's position
against each satellite's orbit position. The comparison uses the `$4FFD` table
(4 bytes: `$97, $D7, $17, $57`) as direction-specific position offsets:

```
$4FA7: LDA $520E,Y              ; Satellite orbit position
$4FAA: SEC
$4FAB: LDX $12
$4FAD: SBC $4FFD,X              ; Subtract direction offset
$4FB0: CMP #$05                 ; Within 5 units?
$4FB2: BCS $4FF0                ; No: miss
```

A hit occurs when the absolute difference between the satellite position and
the reference value is less than 5 -- a 5-unit hit window.

### Satellite Hit Consequences

When a satellite is hit:

1. Play hit sound (`$4F35`)
2. Award points equal to `$5212,X` (remaining hit points = point value per hit)
3. Call `IncreaseDifficulty` (`$56E4`) -- hitting satellites accelerates the game!
4. Deactivate the laser beam
5. Decrement hit countdown (`$5221,X`)
6. If countdown reaches 0:
   - Erase satellite sprite (`$52C9`)
   - Decrement total hit points (`$5212,X`)
   - Copy new hit points to countdown (`$5221,X`)
   - If hit points now 0: satellite is fully destroyed
   - If hit points > 0: redraw with new sprite (smaller/different appearance)

The `$521A` table maps remaining hit points to sprite indices, giving satellites
a visual indication of how many hits remain.

### Satellite Sprite Lookup ($521A)

The data at `$521A` is: `$3C, $43, $4A, $51, $CF, $A0, $FE, $AE`

When `$5212,X` (remaining hit points) is used as Y index into `$521A,Y`, the
result is a sprite index. Higher hit point values map to different (larger?)
sprites, providing visual feedback on satellite health.

### Satellite Transition Points ($5337)

When a satellite's orbit position matches one of the values in the `$5337`
table (`$96, $D6, $16, $56`), it has reached a corner of the playfield. At
these transition points, the code at `$533B` checks whether a projectile
should be spawned from that direction:

```
$533B: LDA $5D54,X              ; Is there already a projectile for this direction?
$533E: BNE $5361                ; Yes: skip
$5340: LDA #$01                 ; No: activate a new projectile!
$5342: STA $5D54,X
; ... set projectile start position from tables at $5362, $5366, $536A
```

This means satellites have a secondary function: when they pass specific orbit
positions, they trigger enemy projectile spawns. The 4 transition points
correspond to the 4 screen corners, and a projectile is fired toward the player
from the satellite's current direction.

### Satellite Timing Formula (Summary)

**Spawn Trigger:** Level completion when `$3A < 4` (levels 3, 4, 5).
4 satellites spawned per level transition.

**Movement Speed:** `256 - $52F2` frames per satellite step, with only 1 of 4
satellites updated per cycle. Effective per-satellite speed =
`(256 - $52F2) * 4` frames per orbit step.

| Difficulty Index | `$52F2` | Frames per Redraw Cycle | Effective Speed |
|-----------------|---------|-------------------------|-----------------|
| 11 (easiest)    | `$E4`   | 28                      | 112 frames/step |
| 10              | `$E4`   | 28                      | 112 frames/step |
| 9               | `$E6`   | 26                      | 104 frames/step |
| 8               | `$E8`   | 24                      | 96 frames/step  |
| 7               | `$EB`   | 21                      | 84 frames/step  |
| 6               | `$EC`   | 20                      | 80 frames/step  |
| 5               | `$F0`   | 16                      | 64 frames/step  |
| 4               | `$F3`   | 13                      | 52 frames/step  |
| 3               | `$F4`   | 12                      | 48 frames/step  |
| 2               | `$F6`   | 10                      | 40 frames/step  |
| 1               | `$F7`   | 9                       | 36 frames/step  |
| 0 (hardest)     | `$F9`   | 7                       | 28 frames/step  |

At maximum difficulty, satellites orbit 4x faster than at minimum difficulty.

---

## 2. Difficulty Progression Curve - Complete Analysis

### How Difficulty Works

The game uses a two-layer difficulty system:

1. **Difficulty Index (`$30`):** Ranges from `$0B` (11, easiest) to `$00`
   (0, hardest). Used as an index into 8 lookup tables.

2. **Step Counter (`$31`):** Counts down with each alien hit or heart
   collection. When it reaches zero and `$30 > 0`, `$30` decrements by 1
   (game gets harder) and all timing parameters are reloaded from the
   lookup tables.

### When Difficulty Increases

The `IncreaseDifficulty` routine at `$56E4` is called from exactly two places:

1. **`$4DDD`** (AlienEvolve area) - When the player's laser hits an alien
2. **`$4FC4`** (CheckSatelliteHits) - When the player hits a satellite

Each call decrements `$31`. When `$31` reaches 0:
```
$56E4: DEC $31          ; Decrement step counter
$56E6: BNE $56F1        ; Not zero yet? Return
$56E8: LDA $30          ; Load difficulty index
$56EA: BEQ $56F1        ; Already at max difficulty? Return
$56EC: DEC $30          ; Increase difficulty (lower index)
$56EE: JMP $56F3        ; Reload ALL timing tables
```

### The 8 Difficulty Lookup Tables

Located at `$576C`-`$57CB` (107 bytes). Raw hex data:

```
Table 1 ($576C): FC FA F9 F7 F5 F4 F0 EB E6 E4 E2 E0
Table 2 ($5778): F9 F7 F6 F4 F3 F0 EC EB E8 E6 E4 E4
Table 3 ($5784): F8 F6 F4 F1 EF ED EB E9 E7 E5 E3 E1
Table 4 ($5790): FC FA F7 F5 F0 EE ED EC E7 E4 E2 E0
Table 5 ($579C): F4 F4 F3 F3 F2 F2 F1 F1 F0 F0 F0 F0
Table 6 ($57A8): F0 F0 F0 F0 EF E8 E0 D8 D0 C8 C0 C0
Table 7 ($57B4): F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0
Table 8 ($57C0): FF 2A 2A 30 28 1E 1E 18 18 10 10 10
```

### What Each Table Controls

| Table | Source   | Destination | Purpose                                    |
|-------|----------|-------------|--------------------------------------------|
| 1     | `$576C`  | `$2F`       | Frame delay reload (main game speed timer) |
| 2     | `$5778`  | `$52F2`     | Redraw/satellite movement timing           |
| 3     | `$5784`  | `$55E0`     | Alien row drawing timing                   |
| 4     | `$5790`  | `$32`       | Alien fire rate                            |
| 5     | `$579C`  | `$57CC`     | Enemy projectile fire interval (2-byte)    |
| 6     | `$57A8`  | `$57CF`     | Unknown timing parameter                   |
| 7     | `$57B4`  | `$57D2`     | Constant `$F0` at all levels (unused variance)|
| 8     | `$57C0`  | `$31`       | Steps until next difficulty increase       |

### How the Timers Work

All timing values are negative numbers (viewed as signed bytes). The game uses
a pattern where a counter is incremented each frame; when it wraps past zero
(from $FF to $00), the action fires and the counter is reloaded from the
difficulty table value. Higher (closer to $00/more negative) values mean fewer
frames between actions = faster game.

**Main Frame Timer (`$2E`/`$2F` - Table 1):**
```
$5A04: INC $2E          ; Increment frame counter
$5A06: BNE $5A5A        ; Not wrapped? Jump to loop top
$5A08: LDA $2F          ; Wrapped! Reload from difficulty value
$5A0A: STA $2E
$5A0C: JSR $450E        ; Execute periodic game logic
```

Frames between periodic events = `256 - $2F` (unsigned). At easiest
(`$2F = $E0`): 32 frames between ticks. At hardest (`$2F = $FC`): 4 frames.

**Enemy Projectile Timer (`$57CC`/`$57CD`/`$57CE` - Table 5):**
```
$59EE: INC $57CD        ; Increment low byte counter
$59F1: BNE $5A04        ; Not wrapped? Continue
$59F3: INC $57CE        ; Increment high byte counter
$59F6: BNE $5A04        ; Not wrapped? Continue
$59F8: LDA $57CC        ; Both wrapped! Reload
$59FB: STA $57CD
$59FE: STA $57CE
$5A01: JSR $56C9        ; Fire enemy projectile (DrawAlienRowDirD)
```

This is a TWO-BYTE cascaded counter. Both bytes must wrap to zero before a
projectile fires. Effective interval = `(256 - $57CC)^2` frames. This creates
an exponential relationship between the table value and actual fire rate:

| Difficulty | `$57CC` | Interval Calculation | Approx. Frames |
|------------|---------|----------------------|-----------------|
| 11 (easiest)| `$F0`  | `(256-240)^2 = 16^2` | 256             |
| 10         | `$F0`   | 16^2                 | 256             |
| 9          | `$F0`   | 16^2                 | 256             |
| 8          | `$F0`   | 16^2                 | 256             |
| 7          | `$F1`   | 15^2                 | 225             |
| 6          | `$F2`   | 14^2                 | 196             |
| 5          | `$F2`   | 14^2                 | 196             |
| 4          | `$F3`   | 13^2                 | 169             |
| 3          | `$F3`   | 13^2                 | 169             |
| 2          | `$F4`   | 12^2                 | 144             |
| 1          | `$F4`   | 12^2                 | 144             |
| 0 (hardest)| `$F4`   | 12^2                 | 144             |

### Complete Difficulty Curve Table

Each row shows what changes at that difficulty level. The game starts at
index 11 and progresses toward 0.

| Idx | $2F (Speed) | Frames/Tick | $52F2 (Redraw) | $55E0 (AlienDraw) | $32 (FireRate) | $57CC (ProjTimer) | $57CF | $57D2 | $31 (Steps) |
|-----|-------------|-------------|----------------|--------------------|---------|--------------------|-------|-------|-------------|
| 11  | `$E0`       | 32          | `$E4`          | `$E1`              | `$E0`   | `$F0`              | `$C0` | `$F0` | 16          |
| 10  | `$E2`       | 30          | `$E4`          | `$E3`              | `$E2`   | `$F0`              | `$C0` | `$F0` | 16          |
| 9   | `$E4`       | 28          | `$E6`          | `$E5`              | `$E4`   | `$F0`              | `$C8` | `$F0` | 16          |
| 8   | `$E6`       | 26          | `$E8`          | `$E7`              | `$E7`   | `$F0`              | `$D0` | `$F0` | 24          |
| 7   | `$EB`       | 21          | `$EB`          | `$E9`              | `$EC`   | `$F1`              | `$D8` | `$F0` | 24          |
| 6   | `$F0`       | 16          | `$EC`          | `$EB`              | `$ED`   | `$F1`              | `$E0` | `$F0` | 30          |
| 5   | `$F4`       | 12          | `$F0`          | `$ED`              | `$EE`   | `$F2`              | `$E8` | `$F0` | 30          |
| 4   | `$F5`       | 11          | `$F3`          | `$EF`              | `$F0`   | `$F2`              | `$EF` | `$F0` | 40          |
| 3   | `$F7`       | 9           | `$F4`          | `$F1`              | `$F5`   | `$F3`              | `$F0` | `$F0` | 48          |
| 2   | `$F9`       | 7           | `$F6`          | `$F4`              | `$F7`   | `$F3`              | `$F0` | `$F0` | 42          |
| 1   | `$FA`       | 6           | `$F7`          | `$F6`              | `$FA`   | `$F4`              | `$F0` | `$F0` | 42          |
| 0   | `$FC`       | 4           | `$F9`          | `$F8`              | `$FC`   | `$F4`              | `$F0` | `$F0` | 255*        |

*Index 0 has `$31 = $FF` (255 steps). Since `$30` is already 0 at this point,
the step counter never triggers another difficulty increase -- it is effectively
infinite. This is the maximum difficulty ceiling.

### Interpreting the Timing Values

All timing values are reload values for up-counting wraparound timers. The
number of frames between events = `256 - value`:

| Parameter         | Easiest (Idx 11)     | Hardest (Idx 0)      | Speed Ratio |
|-------------------|----------------------|----------------------|-------------|
| Main game speed   | 32 frames/tick       | 4 frames/tick        | 8x faster   |
| Satellite/redraw  | 28 frames/cycle      | 7 frames/cycle       | 4x faster   |
| Alien drawing     | 31 frames/cycle      | 8 frames/cycle       | ~4x faster  |
| Alien fire rate   | 32 frames/cycle      | 4 frames/cycle       | 8x faster   |
| Enemy projectiles | ~256 frames/shot     | ~144 frames/shot     | ~1.8x faster|

### Difficulty Progression Speed

The `$31` (steps to next difficulty increase) value controls how quickly the
game ramps up. Interestingly, it is NOT monotonic:

| From Index | Steps Required | Hits to Advance |
|------------|----------------|-----------------|
| 11 -> 10   | 16 hits        | Quick ramp      |
| 10 -> 9    | 16 hits        | Quick ramp      |
| 9 -> 8     | 16 hits        | Quick ramp      |
| 8 -> 7     | 24 hits        | Medium          |
| 7 -> 6     | 24 hits        | Medium          |
| 6 -> 5     | 30 hits        | Slow            |
| 5 -> 4     | 30 hits        | Slow            |
| 4 -> 3     | 40 hits        | Very slow       |
| 3 -> 2     | 48 hits        | Very slow       |
| 2 -> 1     | 42 hits        | Slow            |
| 1 -> 0     | 42 hits        | Slow            |

**Total hits to reach max difficulty:** 16+16+16+24+24+30+30+40+48+42+42 = **328 hits**

The curve is designed so the game ramps up quickly at first (16 hits between
levels), then gradually slows down as the game gets harder. This gives new
players a sense of increasing challenge while giving experienced players a
longer plateau at the harder difficulties.

### What Changes Feel Like to the Player

**Levels 11-9 (Easy, first ~48 hits):**
- Leisurely pace, plenty of time to aim
- Enemies fire slowly, projectiles rare
- Good time to learn the UFO -> Eye -> Eye -> TV cycle
- Satellites (if present) drift slowly

**Levels 8-6 (Medium, hits 48-148):**
- Noticeably faster game tick
- Enemies fire more frequently
- Satellites speed up (if on level 3+)
- Need to be more strategic about direction changes

**Levels 5-3 (Hard, hits 148-266):**
- Very fast pace, main tick at 9-12 frames
- Enemies fire rapidly
- Little time to deliberate
- Satellites orbit quickly, harder to hit

**Levels 2-0 (Maximum, hits 266-328+):**
- Blistering speed, main tick at 4-7 frames
- Nearly constant enemy fire
- Requires reflexive play
- Satellites are fast but relatively fewer points at stake

### Initial Game State

When a new game starts at `$5809`:

```
$5809: LDA #$03; STA $10     ; 3 lives
$580D: LDA #$05; STA $3A     ; Level counter = 5 (Level 1)
$5811: JSR $4D73              ; Level setup (init alien positions)
$5814: LDA #$00
$5816: STA $0C; STA $0D       ; Zero score
$581A: STA $11                ; Direction = UP
$581E: STA $36                ; Fire flag = off
$5823: LDA #$0B; STA $30      ; Difficulty = 11 (easiest)
$5829: JSR $56F3              ; Load timing tables for difficulty 11
$582C: JSR $5370              ; Set 4-dir fire ammo = 3
$5832: LDA #$05; STA $35      ; Satellite counter = 5
$5836: JSR $52E5              ; Draw base / clear satellites
```

The `DrawBase` routine at `$52E5` zeroes all 4 satellite slots (`$5212`):
```
$52E5: LDX #$03
$52E7: LDA #$00
$52E9: STA $5212,X            ; Clear satellite slot
$52EC: DEX
$52ED: BPL $52E9              ; Loop all 4
```

### Level Progression

The game has 5 levels. Each level requires getting all 16 aliens to TV state
(type 4). The level counter `$3A` counts down from 5 to 0:

| Level | `$3A` | Aliens to Convert | Satellites | New Mechanic              |
|-------|-------|-------------------|------------|---------------------------|
| 1     | 5     | 16 (4 per side)   | None       | Learn basic mechanics     |
| 2     | 4     | 16 (4 per side)   | None       | Difficulty ramps up       |
| 3     | 3     | 16 (4 per side)   | 4 (2 hits) | Satellites add bonus/risk |
| 4     | 2     | 16 (4 per side)   | 4 (4 hits) | Tougher satellites        |
| 5     | 1     | 16 (4 per side)   | 4 (6 hits) | Maximum satellite value   |
| Win!  | 0     | Victory!          | N/A        | Game ends                 |

At each level transition:
1. Award 50 BCD points
2. Play completion animation (big TV sweep)
3. Reset all 16 aliens to type 1 (UFO)
4. Spawn 4 satellites (levels 3-5 only)
5. Continue with current difficulty (NOT reset)

Note: difficulty is cumulative across levels. The `$30` index continues
decreasing through all 5 levels. Only the cheat code (Shift-N during level
animation) resets `$30` back to `$0B`.

### 4-Direction Fire Ammo

At game start, the player gets 3 uses of the 4-direction simultaneous fire
(A/F keys). The `$536F` variable tracks remaining ammo. Each time
`LoadDifficultyTables` is called (via `$5376`/`Set4DirAmmoB`), the ammo count
is incremented (but capped at 255). This means each difficulty step also grants
+1 ammo for the 4-direction fire.

### The Cheat Code in Context

The Shift-N cheat at `$4CEF`:
```
$4CF9: LDA #$0B; STA $30     ; Reset difficulty to easiest
$4CFD: LDA #$03; CLC; ADC $10; STA $10  ; Add 3 lives
```

This is extremely powerful because:
1. It adds 3 lives (obvious)
2. It resets `$30` from wherever it was back to 11 (easiest)
3. This effectively undoes potentially 300+ hits worth of difficulty progression
4. Can be triggered multiple times during a single level animation
5. The 4-dir ammo also gets restored when tables reload

---

## 3. Summary: Key Mechanical Formulas

### Frame Timing
- Main tick interval: `256 - $2F` frames (4 to 32)
- Satellite movement: `(256 - $52F2) * 4` frames per satellite step (28 to 112)
- Enemy projectile interval: `(256 - $57CC)^2` frames (144 to 256)

### Satellite Spawning
- Trigger: Level complete with `$3A < 4`
- Count: 4 per level transition
- Hit points: 2 (level 3), 4 (level 4), 6 (level 5)
- Point value per hit: equals remaining hit points
- Orbit positions: 0-239, minimum 10 apart

### Difficulty Progression
- Total range: 12 steps (index 0-11)
- Total hits to max: 328
- Speed increase: 8x (main tick), 4x (satellites), 1.8x (enemy projectiles)
- Reset: cheat code only (Shift-N during level animation)

### Scoring
- Alien hit: 1 point per hit
- Level complete: 50 points (BCD)
- Satellite hit: 2/4/6 points per hit (level dependent)
- Enemy projectile hit: 5 points
- Maximum satellite bonus per level: 4 satellites * 36 points = 144 points (level 5)

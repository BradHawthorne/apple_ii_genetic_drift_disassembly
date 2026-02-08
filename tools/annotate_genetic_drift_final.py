#!/usr/bin/env python3
"""annotate_genetic_drift_final.py — Recover Scott Schram's lost source code.

Transforms the raw deasmiigs disassembly output into a clean, annotated source
file that reads like the 6502 assembly Scott would have written in 1981.

Strips all machine-generated noise (register liveness, optimization hints,
stack analysis) and replaces it with human-readable variable names, section
headers, HOW/WHY comments, and data table documentation.

Usage:
    python annotate_genetic_drift_final.py

Input:  archaeology/games/action/Genetic Drift (Broderbund 1981)/disassembly/genetic_drift_annotated.s
Output: archaeology/games/action/Genetic Drift (Broderbund 1981)/genetic_drift_source.s
"""

import os
import re
import sys
from pathlib import Path

# ═══════════════════════════════════════════════════════════════════════
#                         KNOWLEDGE BASE
# ═══════════════════════════════════════════════════════════════════════
# Everything we know about Genetic Drift, compiled from:
#   - game_mechanics.md (satellite system, difficulty, evolution)
#   - genetic_drift_analysis.md (binary structure, memory layout)
#   - notes.md (historical context, Scott Schram collaboration)
#   - MANIFEST.md (sprite identification)

# ── Zero Page Variable Names ──────────────────────────────────────────
# Format: address → (name, description)
# These replace raw $xx addresses throughout the code.

ZERO_PAGE = {
    0x00: ("src_lo",       "Source pointer, low byte"),
    0x01: ("src_hi",       "Source pointer, high byte"),
    0x02: ("col_ctr",      "Column counter / draw X position"),
    0x03: ("dest_hi",      "Destination pointer, high byte"),
    0x04: ("sprite_calc",  "Sprite height calculation / draw parameter"),
    0x05: ("sprite_h",     "Sprite height in scanline rows"),
    0x06: ("hgr_lo",       "HGR screen line address, low byte"),
    0x07: ("hgr_hi",       "HGR screen line address, high byte"),
    0x08: ("clip_top",     "Clipping boundary: top scanline"),
    0x09: ("clip_bot",     "Clipping boundary: bottom scanline"),
    0x0A: ("clip_left",    "Clipping boundary: left column"),
    0x0B: ("clip_right",   "Clipping boundary: right column"),
    0x0C: ("score_lo",     "Current score, low byte (BCD)"),
    0x0D: ("score_hi",     "Current score, high byte (BCD)"),
    0x0E: ("hiscore_lo",   "High score, low byte (BCD)"),
    0x0F: ("hiscore_hi",   "High score, high byte (BCD)"),
    0x10: ("lives",        "Lives remaining (starts at 3)"),
    0x11: ("direction",    "Aim direction: 0=UP 1=RIGHT 2=DOWN 3=LEFT"),
    0x12: ("loop_idx",     "Temporary loop counter"),
    0x13: ("sprite_idx",   "Current sprite table index"),
    0x14: ("save_x",       "Register save: X preserved across calls"),
    0x15: ("save_y",       "Register save: Y preserved across calls"),
    0x16: ("draw_mask",    "HGR byte mask for sprite blitting"),
    0x17: ("draw_col",     "HGR column byte index"),
    0x19: ("draw_y",       "Y coordinate for draw operations"),
    0x1A: ("draw_y_hi",    "Y coordinate overflow / high byte"),
    0x1B: ("anim_dir",     "Animation direction: $00=forward $FF=reverse"),
    0x1C: ("target_x",     "Target X for projectile/line drawing"),
    0x1D: ("target_x_hi",  "Target X, high byte"),
    0x1E: ("target_y",     "Target Y for projectile/line drawing"),
    0x1F: ("step_x_lo",    "Line-draw step X, low (signed)"),
    0x20: ("step_x_hi",    "Line-draw step X, high (signed)"),
    0x21: ("step_y",       "Line-draw step Y increment"),
    0x22: ("step_y_hi",    "Line-draw step Y, high byte (sign extension)"),
    0x23: ("delta_x",      "Absolute delta X for line drawing"),
    0x24: ("delta_x_hi",   "Delta X, high byte"),
    0x25: ("delta_y",      "Absolute delta Y for line drawing"),
    0x26: ("delta_y_hi",   "Delta Y high / RWTS track number"),
    0x27: ("accum_lo",     "Line-draw accumulator / RWTS sector"),
    0x28: ("accum_hi",     "Accumulator high byte"),
    0x29: ("line_ctr_lo",  "Line pixel counter, low byte"),
    0x2A: ("line_ctr_hi",  "Line pixel counter hi / RWTS addr field"),
    0x2B: ("slot_x16",     "RWTS disk slot * 16 / paddle state"),
    0x2C: ("timer_lo",     "General timer, low byte"),
    0x2D: ("timer_hi",     "General timer, high byte"),
    0x2E: ("frame_ctr",    "Frame counter (counts up to $FF, wraps)"),
    0x2F: ("frame_reload", "Frame timing reload from difficulty table"),
    0x30: ("difficulty",   "Difficulty: 11=easiest, 0=hardest"),
    0x31: ("diff_steps",   "Hits remaining until next difficulty increase"),
    0x32: ("fire_rate",    "Alien fire rate from difficulty table"),
    0x33: ("star_idx",     "Star twinkle animation index (cycles 0-31)"),
    0x34: ("game_flag",    "Game state flag"),
    0x35: ("sat_counter",  "Satellite counter"),
    0x36: ("fire_req",     "Fire requested (set by ESC key)"),
    0x38: ("snd_pitch1",   "Sound effect inner loop counter (pitch)"),
    0x39: ("snd_pitch2",   "Sound effect second half pitch"),
    0x3A: ("level",        "Level: 5=Lv1, 4=Lv2, 3=Lv3, 2=Lv4, 1=Lv5, 0=Victory"),
    0x3C: ("temp",         "Temporary work variable"),
    0x3D: ("disk_chk",     "RWTS disk checksum / temp"),
}

# ── Apple II Soft Switch Names ────────────────────────────────────────

SOFT_SWITCHES = {
    0xC000: "KBD",      0xC010: "KBDSTRB",  0xC030: "SPKR",
    0xC050: "TXTCLR",   0xC051: "TXTSET",   0xC052: "MIXCLR",
    0xC053: "MIXSET",   0xC054: "TXTPAGE1", 0xC055: "TXTPAGE2",
    0xC056: "LORES",    0xC057: "HIRES",
    0xC061: "BUTN0",    0xC062: "BUTN1",
}

# Replace deasmiigs tautological soft-switch comments with meaningful ones
SOFT_SWITCH_COMMENTS = {
    "KBDSTRB - Clear keyboard strobe":   "Clear keyboard strobe",
    "TXTCLR - Enable graphics mode":     "Graphics mode on (soft switch)",
    "HIRES - Hi-res graphics mode":      "Hi-res mode on (soft switch)",
    "MIXCLR - Full screen graphics":     "Full-screen (no text window)",
    "SPKR - Speaker toggle":            "Toggle speaker (click)",
    "BUTN0 - Button 0 / Open Apple":    "Read Open Apple button",
    "BUTN1 - Button 1 / Closed Apple":  "Read Closed Apple button",
    "KBD - Read keyboard":              "Read keyboard",
    "KBD - Keyboard data / 80STORE off": "Read keyboard (high bit = key pressed)",
}

# ── Subroutine Call Labels ───────────────────────────────────────────
# Short names appended as inline comments to bare jsr/jmp $XXXX calls.
# These are routines that don't have labels in the disassembly output.

CALL_LABELS = {
    0x0403: "RandomByte",
    0x0416: "DrawSprite",
    0x0462: "EraseSprite",
    0x20E0: "HGR2Clear",           # Apple II ROM: clear HGR page 2
    0x44EF: "LoadProjectileState",
    0x49AF: "BresenhamLineInit",
    0x4AD0: "UpdateStarTwinkle",
    0x4B98: "UpdateAlienOrbit",
    0x4CEF: "CheatCheck",
    0x4DB5: "UpdateAlienPositions",
    0x524B: "SpawnSatellite",
    0x52C3: "DrawSatellite",
    0x52C9: "EraseSatellite",
    0x52CF: "LoadSatelliteData",
    0x533B: "SpawnEnemyProjectile",
    0x5376: "Inc4DirAmmo",
    0x53FD: "AnimateSatelliteUp",
    0x5461: "AnimateSatelliteLeft",
    0x54C5: "AnimateSatelliteDown",
    0x5529: "AnimateSatelliteRight",
    0x560E: "CheckAlienDirection",
    0x57D7: "GameInit",
    0x58DE: "CheckSatelliteHits",
    0x591E: "DrawLaserProjectile",
    0x5954: "LaserExplosion",
    0x596E: "ProcessLaserHit",
    0x59C2: "CheckLaserLoop",
    0x5A5D: "HandleAlienHit",
    0x5B6F: "SoundClick",
    0x5B77: "InputWaitKey",
    0x5D27: "DrawBaseCenter",
    0x8800: "DiskIO",
}

# ── Function Annotations ─────────────────────────────────────────────
# Format: address → (name, HOW comment, WHY comment)
# Injected as block comments before the function's first instruction.

FUNCTIONS = {
    # ── Bootstrap ──
    0x0037D7: ("Bootstrap", """\
; HOW: Clears the keyboard strobe, then copies 8 pages ($3800-$3FFF)
;      down to $0000-$07FF using a simple nested loop (inner = 256 bytes
;      per page, outer = 8 pages). When done, jumps to $57D7.""", """\
; WHY: Self-relocating binary. The Broderbund intro screen code, custom
;      RWTS disk routines, and HGR line address tables all need to live
;      in low memory ($0000-$07FF). But that region is occupied by DOS
;      when the binary first loads. This bootstrap copies them into place
;      before the main game code enables hi-res graphics."""),

    # ── Relocated: RWTS ──
    0x00025D: ("RWTS_ReadSector", """\
; HOW: Reads one sector of Broderbund nibble-encoded disk data.
;      Accesses the disk controller directly via slot I/O at $C08C,X.
;      Searches for address field sync bytes, verifies track/sector,
;      then reads the data field into a decode buffer.""", """\
; WHY: Copy protection. Broderbund used a proprietary disk format that
;      standard DOS 3.3 RWTS cannot read, preventing casual disk copying.
;      This same scheme was used across Broderbund's catalog — Choplifter,
;      Lode Runner, and other titles all share this RWTS structure."""),

    0x0002D1: ("RWTS_DecodeData", """\
; HOW: Decodes the raw nibble data read by RWTS_ReadSector.
;      Converts 6-and-2 encoded nibbles back to the original byte values,
;      accumulating a running checksum to verify data integrity.""", """\
; WHY: Apple II floppy disks cannot store arbitrary bytes — values below
;      $96 are invalid on disk. The 6-and-2 encoding packs 8-bit values
;      into disk-safe nibbles, which this routine reverses."""),

    # ── Relocated: PRNG ──
    0x000403: ("RandomByte", """\
; HOW: Pseudorandom number generator using zero page ($00-$01) as
;      state. Combines ROL, EOR, and ROR operations on the 16-bit
;      seed, then increments and adds to produce the next value.
;      Returns random byte in A.""", """\
; WHY: Drives all randomized behavior — satellite spawn timing,
;      alien fire targeting, star twinkle positions. The algorithm
;      is compact (under 20 bytes) and fast for a 1 MHz 6502."""),

    # ── Relocated: Sprite Draw ──
    0x000416: ("DrawSprite", """\
; HOW: Takes sprite index in A, draws it at the current col_ctr/
;      sprite_calc position. Looks up sprite data pointer from the
;      tables at $5D7C (low) and $5E1D (high), width from $5EBE,
;      and height from $5F5F. Draws row by row using ORA to merge
;      sprite pixels with the existing screen content.""", """\
; WHY: Central rendering primitive — called 30+ times throughout
;      the code for all game objects. Kept in relocated low memory
;      ($0416) because page-zero addressing makes the inner loop
;      faster than equivalent code in the $4000+ range."""),

    0x000462: ("EraseSprite", """\
; HOW: Same structure as DrawSprite but uses XOR (EOR) instead of
;      ORA to erase the sprite from the screen. A second XOR of the
;      same data restores the original background pixels.""", """\
; WHY: XOR erase is the standard technique for fast sprite removal
;      on the Apple II HGR screen — no need to save/restore the
;      background, and it's a single pass through the sprite data."""),

    # ── Graphics: Sprite Engine ──
    0x0040C0: ("DrawSpriteXY", """\
; HOW: Core sprite rendering engine. Takes sprite index in A, screen
;      position in col_ctr/sprite_calc. Looks up sprite data pointer,
;      width, and height from tables at $5D7C/$5E1D/$5EBE/$5F5F.
;      Calculates HGR screen address from Y coordinate using the line
;      address lookup table. Selects the correct pre-shifted sprite copy
;      (X mod 7) and blits the sprite bytes with OR masking.""", """\
; WHY: Pre-shifted sprites are the key optimization. Each sprite has 7
;      copies, shifted 0-6 bits, so any X position can be drawn without
;      runtime bit shifting. On a 1 MHz 6502, bit shifts in a drawing
;      loop would be far too slow for smooth animation. The 7x memory
;      cost is worth it — and with only ~5KB of sprite data total in a
;      15KB binary, the tradeoff is well-managed."""),

    0x004120: ("InitHiRes", """\
; HOW: Enables full-screen hi-res graphics on page 1 by reading soft
;      switches: TXTCLR ($C050), HIRES ($C057), MIXCLR ($C052).
;      Then fills HGR page 1 ($2000-$3FFF) with zeros to clear the screen.""", """\
; WHY: Sets up the display for gameplay. Uses page 1 only — no double
;      buffering. All drawing goes directly to the visible screen. This
;      simplifies the code and the small, fast-moving sprites don't
;      produce visible tearing at 1 MHz."""),

    0x00413E: ("ClearPlayfield", """\
; HOW: Fills the playfield area of HGR page 1 with black (zero bytes).
;      Uses a tight loop writing 0 to consecutive HGR addresses.""", """\
; WHY: Prepares the screen for a new frame or level transition. Only
;      clears the gameplay area, preserving the score/status display."""),

    0x00415B: ("SetClipBounds", """\
; HOW: Sets the sprite clipping rectangle by storing boundary values
;      into clip_top, clip_bot, clip_left, clip_right.""", """\
; WHY: Prevents sprites from drawing outside the playfield area. The
;      clipping bounds define the safe region; DrawSpriteXY checks
;      against these before writing any pixels."""),

    # ── Graphics: HGR Utilities ──
    0x0042EC: ("PrintHexByte", """\
; HOW: Draws a single BCD digit on screen as a sprite. Takes the digit
;      value in A, looks up the corresponding numeral sprite, and calls
;      DrawSpriteXY to render it.""", """\
; WHY: Score and level display. BCD encoding means each nibble is a
;      decimal digit (0-9), so this routine can render score digits
;      directly without binary-to-decimal conversion."""),

    # ── Title Screen ──
    0x0042FC: ("DrawTitleScreen", """\
; HOW: Displays the title screen with animated elements. Enters a loop
;      that draws the title graphics, animates twinkling stars, and
;      polls the keyboard for RETURN ($8D) to start the game.""", """\
; WHY: Title screen / attract mode. The star twinkle animation keeps
;      the display lively while waiting for the player."""),

    0x0043B5: ("TitleSetup", """\
; HOW: Initializes the title screen display — draws the game title,
;      Broderbund logo, copyright text, and initial star field.""", """\
; WHY: First-time setup before the title animation loop begins."""),

    # ── Game State Initialization ──
    0x00437A: ("ResetAlienState", """\
; HOW: Resets alien animation and position state after a player death.
;      Preserves score, lives, level, and difficulty — only resets the
;      transient alien movement state.""", """\
; WHY: After losing a life, the game continues from the same level and
;      difficulty. Only the on-screen alien positions need resetting,
;      not the entire game state."""),

    0x004387: ("ResetTimers", """\
; HOW: Initializes the frame timing counters and animation variables
;      to their starting values for the current difficulty level.""", """\
; WHY: Called at game start and after difficulty changes to ensure
;      all timing loops begin from a clean state."""),

    0x00439E: ("ResetGameVarsC", """\
; HOW: Additional game variable initialization.""", """\
; WHY: Part of the cascaded initialization sequence at game start."""),

    # ── Input ──
    0x0043E0: ("KeyboardHandler", """\
; HOW: Reads the Apple II keyboard register ($C000). Compares against:
;      Y ($D9) → direction = 0 (UP)     J ($CA) → direction = 1 (RIGHT)
;      SPACE ($A0) → direction = 2 (DOWN)  G ($C7) → direction = 3 (LEFT)
;      ESC ($9B) → sets fire_req flag
;      A ($C1) / F ($C6) → 4-direction simultaneous fire (limited ammo)
;      Clears keyboard strobe ($C010) after reading.""", """\
; WHY: Diamond key layout: Y at top, G left, J right, Space at bottom.
;      This maps naturally to the four screen directions. ESC fires in
;      the current direction. The A/F keys trigger the 4-direction
;      "super shot" which fires all four directions at once but has
;      limited uses (starts at 3, gains 1 per difficulty increase)."""),

    # ── Sprite Erase ──
    0x004441: ("EraseSpriteArea", """\
; HOW: Erases a sprite from the screen by writing black (AND mask) over
;      the sprite's bounding rectangle in HGR memory.""", """\
; WHY: Before redrawing a sprite at a new position, the old image must
;      be cleared. No page flipping means manual erase-then-draw."""),

    # ── Projectile State Loader ──
    0x0044EF: ("LoadProjectileState", """\
; HOW: Loads projectile rendering parameters from the state tables
;      indexed by X. Copies Y position, Y high byte, sprite index,
;      and sprite height into the corresponding draw registers.""", """\
; WHY: Centralizes the table-to-register transfer for projectile
;      drawing, used by both the draw and erase paths."""),

    # ── Projectile Drawing ──
    0x004499: ("DrawProjectile", """\
; HOW: Draws the player's laser projectile sprite at its current
;      screen position.""", """\
; WHY: Visual representation of the player's shot moving across
;      the playfield."""),

    0x0044C4: ("DrawHitFlash", """\
; HOW: Draws a brief flash/explosion sprite at the point of impact
;      when a projectile hits an alien or satellite.""", """\
; WHY: Visual feedback confirming a successful hit."""),

    # ── Periodic Game Logic ──
    0x00450E: ("PeriodicGameLogic", """\
; HOW: Called when the frame timer ($2E) wraps past $FF. Handles
;      alien firing, enemy projectile spawning, and other game events
;      that don't need to execute every single frame.""", """\
; WHY: Separates per-frame logic (movement, drawing) from periodic
;      logic (firing decisions, spawning). The frame_reload value from
;      the difficulty table controls how often this runs — at easiest
;      difficulty, every 32 frames; at hardest, every 4 frames."""),

    # ── Projectile Movement ──
    0x00457F: ("MoveAllProjectiles", """\
; HOW: Loops through all 4 projectile slots (X=3..0). For each active
;      projectile, reads its direction and moves it 3 pixels per frame:
;      UP → Y -= 3, DOWN → Y += 3, LEFT → X -= 3, RIGHT → X += 3.
;      Updates the position tables at $5D48-$5D67.""", """\
; WHY: Constant 3-pixel speed gives smooth, predictable motion at
;      1 MHz. Fast enough to cross the screen in about 60 frames
;      (~0.6 seconds), slow enough to track visually. One projectile
;      per direction keeps the logic simple and the screen readable."""),

    # ── Line Drawing / Alien Rendering ──
    0x004641: ("StoreLaserState_Up", """\
; HOW: Stores laser projectile state for the UP direction.""", ""),

    0x004658: ("SetupAlienDraw", """\
; HOW: Prepares drawing parameters for alien sprites. Calculates the
;      HGR screen address from the alien's position, loads the correct
;      sprite index based on alien type, and sets up the clipping bounds.""", """\
; WHY: Each of the 16 aliens needs its own draw setup because they
;      orbit the playfield at different positions. This centralizes
;      the coordinate-to-screen-address conversion."""),

    0x004914: ("DrawAlienRow", """\
; HOW: Draws one row of alien pixels. Saves A/Y on stack, checks the
;      current scanline position, ORs sprite bytes into HGR memory,
;      then restores registers and returns.""", """\
; WHY: Inner loop of the alien sprite renderer. The OR operation
;      composites the alien sprite over the background without erasing
;      other sprites on the same scanline."""),

    0x004940: ("UpdateAlienAnim", """\
; HOW: Advances the alien animation by computing the next position
;      along its movement path using 16-bit fixed-point arithmetic.
;      Calculates delta X/Y from current position to target, determines
;      step direction (signed), and uses a Bresenham-style line algorithm
;      to advance the alien one step along its orbital track.""", """\
; WHY: Aliens orbit the playfield edges in smooth paths. The fixed-point
;      math with separate delta/step/accumulator variables gives sub-pixel
;      precision without floating point. The Bresenham approach guarantees
;      every pixel position along the path is visited exactly once."""),

    0x0049C6: ("BresenhamLineStep", """\
; HOW: Bresenham's line algorithm inner loop. Initializes the error
;      accumulator to half the major axis distance (delta_x >> 1),
;      then iterates line_ctr_lo/hi times. Each iteration:
;        1. Adds delta_y to the accumulator (accum_lo/accum_hi)
;        2. If accumulator >= delta_x, subtracts delta_x and steps
;           along the minor axis (Y direction via step_y)
;        3. Always steps along the major axis (X direction via step_x)
;      The 16-bit math handles screen-spanning distances accurately.""", """\
; WHY: Classic integer-only line drawing — fast and exact. No division
;      or floating point needed, which matters at 1 MHz. Used to compute
;      alien orbital paths and projectile trajectories. The algorithm
;      dates to 1962 (Jack Bresenham, IBM) and was the standard approach
;      for line drawing in the 8-bit era."""),

    # ── Game Over ──
    0x004A86: ("GameOver", """\
; HOW: Compares current score ($0C-$0D) against high score ($0E-$0F).
;      If current score is higher, copies it to the high score bytes.
;      Displays the game over screen with animated sprites, waits for
;      RETURN key, then restarts the game at the title screen.""", """\
; WHY: Standard arcade game over flow. The high score persists in
;      memory (not saved to disk) until the machine is powered off."""),

    # ── Scoring ──
    0x004AE0: ("AddScore", """\
; HOW: Adds points to the current score using BCD arithmetic.
;      SED (set decimal mode), CLC, ADC score_lo, STA score_lo,
;      propagate carry to score_hi, CLD (clear decimal mode).""", """\
; WHY: BCD (Binary-Coded Decimal) stores each digit as a nibble.
;      This means the score bytes can be displayed directly — each
;      nibble is a digit 0-9, no binary-to-decimal conversion needed.
;      Standard technique in 1980s arcade games."""),

    # ── Heart Projectile Selection ──
    0x004B0C: ("SelectProjectileType", """\
; HOW: Determines what type of projectile an alien fires. Checks if all
;      4 aliens on the firing side are type 4 (TV). If yes, calls the
;      random number generator — ~6% chance of upside-down heart (must
;      hit), ~94% chance of regular heart (must NOT hit). If not all TVs,
;      fires a normal projectile.""", """\
; WHY: The heart mechanic creates intense late-game tension. Hearts only
;      appear when you're one step from completing a side (all 4 TVs).
;      Regular hearts punish trigger-happy players who shoot everything.
;      Upside-down hearts force you to keep shooting. You must read the
;      screen carefully in the final moments of each level."""),

    # ── Punishment System ──
    0x004B65: ("PunishmentRoutine", """\
; HOW: When a heart mistake occurs (hitting a regular heart or missing
;      an upside-down heart), sets ALL 4 aliens on the offending side
;      to type 5 (Diamond). Calls the direction-specific redraw routine
;      to update the display, then plays the punishment sound.""", """\
; WHY: This is the game's signature penalty — devastating but fair. One
;      mistake transforms an entire side from TV (goal) to Diamond, which
;      requires 5 more hits each to cycle back to TV (Diamond → Bowtie →
;      UFO → Eye1 → Eye2 → TV). That's 20 hits of lost progress per
;      mistake. It rewards careful play over spray-and-pray."""),

    # ── Sound ──
    0x004C3C: ("PlayPunishSound", """\
; HOW: Generates a harsh buzzing tone by toggling the Apple II speaker
;      ($C030) in a tight timing loop with specific pitch parameters.""", """\
; WHY: Audio feedback for the heart penalty. The distinctive sound
;      serves as an unmistakable warning that you just lost progress."""),

    0x004C56: ("PlayTone", """\
; HOW: General-purpose tone generator. Toggles the speaker ($C030) in
;      a counted loop; the loop count determines pitch. Higher count =
;      lower frequency. Duration controlled by outer loop.""", """\
; WHY: The Apple II has no sound chip — just a single-bit speaker
;      toggle. All sound is generated by precisely-timed CPU loops.
;      This routine is the building block for all game sound effects."""),

    # ── Level Complete ──
    0x004C99: ("LevelCompleteAnim", """\
; HOW: Plays the level completion animation — a large TV sprite sweeps
;      around the screen. During the animation, checks the keyboard at
;      $4CEF: if the key code is $9E (Shift-N on Apple II keyboard,
;      which produces the caret character), adds 3 to lives and resets
;      difficulty to $0B (easiest).""", """\
; WHY: Celebration animation for clearing a level. The embedded cheat
;      code (Shift-N) was a development/testing feature that shipped
;      with the game. It's the most generous cheat possible — it both
;      restores lives AND resets the game speed to the starting pace,
;      undoing all accumulated difficulty increases. Can be triggered
;      multiple times during a single animation."""),

    0x004D33: ("DisplayLevelNum", """\
; HOW: Renders the current level number on screen. Reads the level
;      counter ($3A), converts it to a display value (level = 6 - $3A),
;      and draws the corresponding digit sprite.""", """\
; WHY: Visual feedback showing which level the player has reached."""),

    # ── Level Setup ──
    0x004D73: ("LevelSetup", """\
; HOW: Initializes a new level. Resets all 16 alien type values in the
;      $53B8 table to type 1 (UFO). Sets up the initial alien positions
;      for all 4 directions (4 aliens per direction).""", """\
; WHY: Every level starts fresh — all aliens revert to UFO regardless
;      of their evolved state in the previous level. This means the
;      player must work through the entire evolution cycle again. The
;      difficulty, however, carries over — the game gets progressively
;      harder across all 5 levels."""),

    # ── Alien Movement ──
    0x004D87: ("UpdateAlienPositions", """\
; HOW: Iterates through all 16 aliens, updating their orbital position
;      around the playfield edges. Each alien moves along its assigned
;      direction's track, with speed controlled by the difficulty tables.""", """\
; WHY: Continuous alien movement creates a dynamic target for the player.
;      The aliens orbit in groups of 4 per direction, creating a visual
;      pattern reminiscent of electrons orbiting a nucleus — fitting the
;      game's biology/mutation theme."""),

    # ── Alien Evolution ──
    0x004DE3: ("AlienEvolve", """\
; HOW: Increments the alien's type value in the $53B8 table. Type cycle:
;        1 (UFO) → 2 (Eye Blue) → 3 (Eye Green) → 4 (TV) → 5 (Diamond)
;        → 6 (Bowtie) → wraps back to 1 (UFO)
;      If the new type exceeds 6, wraps to 1.""", """\
; WHY: This is the core mechanic that gives the game its name — "Genetic
;      Drift." Each hit causes the alien to "mutate" into a new form.
;      The goal is to get all 16 aliens to type 4 (TV) simultaneously.
;      Three hits advance UFO→Eye→Eye→TV, but one extra hit pushes
;      past TV to Diamond, requiring 5 more hits to cycle back. This
;      creates a strategic puzzle layered on top of the action gameplay:
;      you must count your shots carefully and stop at exactly TV."""),

    # ── Collision Detection ──
    0x004E38: ("AlienHitHandler", """\
; HOW: Checks if a player's projectile has collided with an alien by
;      comparing the projectile's coordinate against the alien's track
;      position. Uses direction-specific threshold checks:
;        UP: projectile Y <= alien Y
;        DOWN: projectile Y >= alien Y
;        LEFT: projectile X <= alien X
;        RIGHT: projectile X >= alien X
;      On hit: draws flash, clears old sprite, adds 1 point, evolves
;      the alien, and increases difficulty.""", """\
; WHY: Coordinate line-crossing collision works well here because
;      projectiles move 3 pixels/frame in straight lines — they cross
;      every coordinate exactly once. No bounding box math needed.
;      This is efficient on the 6502 and perfectly suited to the
;      game's cardinal-direction-only movement."""),

    # ── Satellite Collision ──
    0x004F5B: ("CheckSatelliteHits", """\
; HOW: For each of 4 projectile directions (X=3..0), first checks if
;      the laser is in a satellite zone (edges of the playfield). If yes,
;      loops through 4 satellite slots (Y=3..0), comparing the laser's
;      position against the satellite's orbit position ($520E,Y) with a
;      5-pixel hit window. On hit: plays sound, awards points equal to
;      the satellite's remaining hit points, increases difficulty, and
;      decrements the satellite's hit counter.""", """\
; WHY: Zone-based filtering is an efficient two-stage collision check.
;      First check "is the laser near a playfield edge?" (cheap), then
;      only do the expensive per-satellite position comparison when it
;      matters. The 5-pixel hit window provides a forgiving target for
;      the fast-moving satellites. Points scale with difficulty — harder
;      satellites (more hits required) award more points per hit."""),

    0x004F35: ("PlayHitSound", """\
; HOW: Toggles the speaker ($C030) with timing controlled by A and Y
;      registers. Creates a short percussive sound.""", """\
; WHY: Audio confirmation of a successful hit on an alien or satellite."""),

    # ── Satellite System ──
    0x005227: ("SpawnSatellite", """\
; HOW: Finds an empty satellite slot (checks $5212,X for zero), sets hit
;      points based on the current level:
;        Level 3 ($3A=3): 2 hits, 2 points each
;        Level 4 ($3A=2): 4 hits, 4 points each
;        Level 5 ($3A=1): 6 hits, 6 points each
;      Generates a random orbit position (0-239), rejecting values >= 240
;      or within 10 steps of an existing satellite. Stores position in
;      $520E and hit points in $5212 and $5221.""", """\
; WHY: Satellites are the bonus challenge in levels 3-5. Four are spawned
;      at each level transition. Hit points scale with level, creating an
;      escalating reward: Level 3 satellites give 4 total points each
;      (2x2), Level 4 gives 16 (4x4), Level 5 gives 36 (6x6). The
;      spawn position validation (minimum 10-step separation) prevents
;      satellites from stacking on top of each other."""),

    0x0052C3: ("DrawSatellite", """\
; HOW: Reads the satellite's orbit position from $520E,X, uses it as an
;      index into the 256-byte orbit path tables at $5002 (Y coord) and
;      $5102 (X coord). Selects a sprite based on remaining hit points
;      via the $521A mapping table. Draws the satellite sprite.""", """\
; WHY: The orbit path tables define a rectangular course around the
;      playfield edges. By using lookup tables instead of computing
;      the path, satellite movement is fast and the orbit shape can be
;      any arbitrary curve the tables define — not just simple math."""),

    0x0052C9: ("EraseSatellite", """\
; HOW: Calls LoadSatelliteData to look up the satellite's screen
;      coordinates and sprite, then erases it via XOR draw.""", """\
; WHY: Paired with DrawSatellite — erase old position, then redraw
;      at new position to animate satellite orbit movement."""),

    0x0052CF: ("LoadSatelliteData", """\
; HOW: Reads the satellite's orbit index from $520E,X. Uses it to
;      look up X/Y coordinates from the 256-entry orbit path tables
;      at $5002 (Y) and $5102 (X). Selects sprite by hit points
;      via the $521A mapping table.""", """\
; WHY: Centralizes the orbit-to-screen coordinate conversion.
;      Both DrawSatellite and EraseSatellite call this to avoid
;      duplicating the table lookup logic."""),

    0x0052E5: ("DrawBase_ClearSatellites", """\
; HOW: Draws the player's base sprite at the center of the playfield,
;      then loops through all 4 satellite slots, setting $5212,X to zero
;      (deactivating them).""", """\
; WHY: Called at game start. The base is the visual anchor of the game
;      — the player's "home" at the center. Satellite slots are cleared
;      because no satellites exist in levels 1-2."""),

    0x0052F3: ("RedrawScreen", """\
; HOW: Master screen redraw. Handles satellite orbit movement: increments
;      a sub-counter ($52F1), when it wraps, reloads from $52F2 (speed)
;      and selects the next satellite slot in round-robin order ($52F0).
;      If the selected slot has an active satellite, decrements its
;      orbit position (moving it counterclockwise) and redraws it.""", """\
; WHY: Round-robin satellite updates spread the CPU cost evenly — only
;      one of the 4 satellites moves per redraw cycle. This keeps frame
;      time consistent regardless of satellite count. Movement speed is
;      controlled by the difficulty table via $52F2."""),

    # ── Enemy Projectile Spawning ──
    0x00533B: ("SpawnEnemyProjectile", """\
; HOW: Checks if the enemy projectile slot ($5D54,X) is empty.
;      If so, activates it and initializes position from the corner
;      spawn tables ($5362/$5366/$536A). Triggers a sound effect.""", """\
; WHY: Enemies shoot from the corners of the playfield toward the
;      center where the player sits. The spawn tables pre-define
;      the starting positions so corner shots converge naturally."""),

    # ── 4-Direction Fire ──
    0x005370: ("Set4DirAmmo", """\
; HOW: Loads the initial 4-direction fire ammo value (3 uses) and stores
;      it at $536F.""", """\
; WHY: Grants the player 3 uses of the 4-direction "super shot" at game
;      start. Additional uses are granted with each difficulty increase."""),

    0x005376: ("Inc4DirAmmo", """\
; HOW: Increments the 4-direction fire ammo counter at $536F.
;      Clamps at $FF to prevent rollover.""", """\
; WHY: Rewards the player with additional super shots as difficulty
;      increases, compensating for the faster game speed."""),

    # ── Alien Drawing (Direction-Specific) ──
    0x005591: ("DrawAlienRowDir", """\
; HOW: Draws one row of 4 aliens for direction A (UP). Uses self-modifying
;      code to patch the sprite table offset, then calls DrawSprite for each
;      alien whose type is non-zero (alive). Iterates X = 3..0.""", """\
; WHY: Four variants of this routine exist — one per direction (A through D).
;      Each applies the correct coordinate transformation for its edge of
;      the playfield. The UP variant is the base; B/C/D mirror and rotate."""),

    0x0055E3: ("DrawAlienRowDirB", """\
; HOW: Direction B (RIGHT) variant of DrawAlienRowDir. Self-modifies
;      the table offset at $55E1, then draws 4 aliens along the right
;      edge of the playfield.""", ""),

    0x0056C9: ("DrawAlienRowDirD", """\
; HOW: Direction D (LEFT) variant of DrawAlienRowDir. Calls RandomByte
;      ($0403) to add slight positional variation to each alien's draw
;      position, giving the left-edge aliens a wobble effect.""", ""),

    # ── Alien Direction Router ──
    0x00560E: ("CheckAlienDirection", """\
; HOW: Compares the alien's Y position against reference values to
;      determine which edge of the playfield it occupies. Branches
;      to direction-specific handlers ($569E, $564C, $5675) for
;      UP, RIGHT, and DOWN; falls through for LEFT.""", """\
; WHY: Each direction has unique coordinate math for positioning
;      aliens along its respective screen edge. This router dispatches
;      to the correct variant based on the alien's current orbit position."""),

    # ── Difficulty System ──
    0x0056E4: ("IncreaseDifficulty", """\
; HOW: Decrements diff_steps ($31). When it reaches zero AND difficulty
;      ($30) is not already at maximum (0), decrements difficulty by 1
;      and reloads all timing tables via LoadDifficultyTables.""", """\
; WHY: Progressive difficulty driven by player performance. Every alien
;      hit and satellite hit calls this routine. The step counter ensures
;      difficulty increases at measured intervals rather than on every
;      single hit. 328 total hits to reach maximum difficulty across 12
;      difficulty levels. The step counts are non-uniform (16, 16, 16,
;      24, 24, 30, 30, 40, 48, 42, 42, ∞) — faster at the start to
;      get players into the action, then gradually slowing to make each
;      subsequent level of challenge harder to reach."""),

    0x0056F3: ("LoadDifficultyTables", """\
; HOW: Uses difficulty ($30) as an index into 8 parallel 12-entry lookup
;      tables at $576C-$57CB. Loads each value into its destination:
;        Table 1 ($576C) → frame_reload ($2F)   — main game speed
;        Table 2 ($5778) → $52F2               — satellite/redraw speed
;        Table 3 ($5784) → $55E0               — alien draw timing
;        Table 4 ($5790) → fire_rate ($32)     — alien firing rate
;        Table 5 ($579C) → $57CC               — enemy projectile timer
;        Table 6 ($57A8) → $57CF               — timer parameter 2
;        Table 7 ($57B4) → $57D2               — timer parameter 3
;        Table 8 ($57C0) → diff_steps ($31)    — steps to next increase
;      Also increments 4-direction fire ammo ($536F).""", """\
; WHY: All game timing is data-driven through these 8 tables. Adjusting
;      difficulty is simply changing which column of the tables is active.
;      This elegant design means the entire feel of the game — speed,
;      aggression, player resources — is controlled by 96 bytes of lookup
;      data. Speed range across the full curve: main game ticks 8x faster,
;      alien fire rate 8x faster, satellite movement 4x faster."""),

    # ── Main Entry / Game Loop ──
    0x0057D7: ("MainEntry", """\
; HOW: Clears decimal mode (CLD), calls hardware initialization, then
;      proceeds to the title screen setup.""", """\
; WHY: Entry point after the bootstrap relocation. CLD is a safety
;      measure — ensures the CPU is in binary mode for all subsequent
;      arithmetic. (The 6502 retains decimal mode across subroutine
;      calls, so it must be explicitly cleared.)"""),

    0x005809: ("GameStart", """\
; HOW: Initializes all game state for a new game:
;        lives = 3
;        level = 5 (which displays as "Level 1")
;        direction = 0 (UP)
;        difficulty = $0B (11, easiest)
;        score = 0 (both bytes)
;      Then calls LevelSetup, LoadDifficultyTables, Set4DirAmmo, and
;      DrawBase_ClearSatellites.""", """\
; WHY: Fresh game state. Level counts DOWN from 5 to 0 (victory),
;      so 5 means "first level." Difficulty 11 is the easiest setting,
;      giving new players time to learn the evolution mechanic before
;      the game speeds up."""),

    0x005875: ("MainGameLoop", """\
; HOW: The main game loop, executed once per frame:
;        1. MoveAllProjectiles  — advance player lasers 3px
;        2. RedrawScreen        — update satellite positions, redraw
;        3. CheckSatelliteHits  — laser vs. satellite collision
;        4. UpdateStarTwinkle   — animate background stars
;        5. CheckAllTVs         — victory condition (all 16 = TV?)
;        6. KeyboardHandler     — read player input
;        7. Check paddle button — alternate fire input
;        8. Fire if requested   — launch projectile
;        9. UpdateAlienPositions — move alien orbits
;       10. Collision checks    — laser vs. alien (X=3..0)
;       11. Frame timer wait    — throttle to difficulty speed
;       12. JMP MainGameLoop""", """\
; WHY: Fixed execution order matters. Projectiles move first (using old
;      position), then the screen redraws (at new position), then
;      collision checks (testing new position against targets). Input
;      is read mid-frame so the player's actions take effect on the
;      very next frame. The frame timer at the end throttles everything
;      to the difficulty-appropriate speed."""),

    # ── Victory Condition ──
    0x005C78: ("CheckAllTVs", """\
; HOW: Loops through all 16 entries in the alien type table ($53B8).
;      If every entry equals 4 (TV type), the level is complete.
;      Jumps to LevelComplete ($5CB8) if the condition is met.""", """\
; WHY: This is the central victory condition. The player wins a level
;      when all 16 aliens are simultaneously in the TV state. With the
;      6-state evolution cycle, this requires precise shot counting —
;      overshooting any alien by even one hit pushes it past TV into
;      Diamond, requiring 5 more hits to get back."""),

    # ── Star Animation ──
    0x005C1C: ("UpdateStarTwinkle", """\
; HOW: Animates twinkling background stars by toggling individual pixels
;      in HGR memory. Uses the random number generator to select which
;      stars flicker each frame.""", """\
; WHY: Visual polish that gives the static background a sense of life.
;      The twinkling suggests the action takes place in space, fitting
;      the science fiction theme."""),

    # ── Level Complete Handler ──
    0x005CB8: ("LevelComplete", """\
; HOW: Awards 50-point bonus (BCD), decrements the level counter ($3A),
;      displays the level number, plays the completion animation (which
;      includes the cheat code window), resets all 16 aliens to type 1
;      (UFO). If level $3A < 4, spawns 4 satellites. If $3A = 0, triggers
;      the victory screen. Otherwise, continues to the next level.""", """\
; WHY: Level progression sequence. The satellite spawn check (only when
;      $3A < 4, i.e., levels 3-5) introduces the bonus satellite challenge
;      in the latter half of the game. Difficulty does NOT reset between
;      levels — the cumulative speed increase carries over, making each
;      successive level harder even though aliens reset to UFOs."""),

    # ── Sound Effects ──
    0x005B6F: ("SoundClick", """\
; HOW: Transfers A to X, executes a DEX countdown loop for timing,
;      then toggles the speaker at $C030. The initial A value controls
;      the pitch — higher = longer delay = lower pitch.""", """\
; WHY: Simple single-click sound effect used for UI feedback,
;      button presses, and minor game events."""),

    0x005B77: ("InputWaitKey", """\
; HOW: Loops reading RandomByte ($0403) to advance the PRNG state
;      while waiting for a valid keyboard input. Filters key codes
;      to the expected range before returning.""", """\
; WHY: Blocking wait for player input during the title screen and
;      game-over screen. The PRNG calls while waiting ensure the
;      random seed depends on human timing — a classic 8-bit trick
;      to seed randomness from user input lag."""),

    # ── Base Drawing ──
    0x005D27: ("DrawBaseCenter", """\
; HOW: Loads sprite index $56 (the player's base), sets col_ctr to
;      $17 and sprite_calc to $18 (the center of the playfield),
;      then jumps to DrawSpriteXY.""", """\
; WHY: The player's base is always at the exact center of the screen.
;      Hardcoded coordinates keep the drawing fast and the logic simple."""),

    # ── Projectile State Init ──
    0x005D14: ("InitProjectileTables", """\
; HOW: Zeroes out all projectile state arrays at $5D48-$5D73. Clears
;      position, state, and active flags for all 4 direction slots.""", """\
; WHY: Clean slate for projectiles when starting a new game or level.
;      Ensures no stale projectile data from previous play."""),
}

# ── Data Table Annotations ────────────────────────────────────────────
# Format: address → block comment string (injected before the HEX line)

DATA_TABLES = {
    0x0000: """\
; ── Zero Page / Interrupt Vectors / Disk Bootstrap Data ─────────
; The first $200 bytes contain zero-page game variables (see EQU
; block above) and 6502 interrupt vectors. Much of this region is
; initialized with Broderbund's nibble-encoded disk bootstrap data
; that is partially encrypted — the HEX blocks below are the raw
; byte values as they appear in the binary.
;
; NOTE: Some byte patterns in this region were misinterpreted by
; the disassembler as 6502 instructions. All data in $0000-$025C
; should be read as raw bytes, not executable code. The actual
; RWTS disk code begins at $025D.""",

    0x4000: """\
; ── Crosshatch Pattern / Sprite Alignment Data ─────────────────
; Repeating byte patterns ($49/$24/$12) that form the crosshatch
; HGR display pattern used during screen initialization. These
; bytes are data, not executable code.""",

    0x416C: """\
; ── HGR Line Address Table (Low Bytes) ───────────────────────────
; 192 entries: one per scanline row (0-191).
; Each entry is the low byte of the HGR memory address for that row.
; Apple II HGR memory is interleaved — consecutive rows are NOT at
; consecutive addresses. Row 0 = $2000, Row 1 = $2400, Row 2 = $2800,
; etc. This lookup table pre-computes the addresses to avoid the
; complex interleave calculation at runtime.""",

    0x422C: """\
; ── HGR Line Address Table (High Bytes) ──────────────────────────
; 192 entries matching the low-byte table above.
; Together they give the full 16-bit HGR address for each scanline.""",

    0x4692: """\
; ── HGR Pixel Bitmask Table ──────────────────────────────────────
; 280 entries indexed by X pixel coordinate (0-279).
; Each byte is the single-bit mask for that pixel's position within
; its HGR byte: $01, $02, $04, $08, $10, $20, $40, then repeats.
; Apple II HGR packs 7 pixels per byte (bit 7 is the color bit).
; This table eliminates runtime shift calculations.""",

    0x47AA: """\
; ── HGR Column Byte Table ────────────────────────────────────────
; 280 entries indexed by X pixel coordinate (0-279).
; Returns the byte offset within the HGR row for that pixel.
; Pixel 0-6 → byte 0, pixel 7-13 → byte 1, etc. (column = X / 7).
; Used together with the bitmask table to locate any pixel.""",

    0x5002: """\
; ── Satellite Orbit Path: Y Coordinates ──────────────────────────
; 256 bytes. Positions 0-239 define the satellite's Y coordinate at
; each step of its rectangular orbit around the playfield edges.
; Positions 240-255 are padding (orbit only uses 0-239).
; The orbit traces a rectangle: top edge → right edge → bottom edge
; → left edge, giving the satellites a smooth path around the
; outside of the gameplay area.""",

    0x5102: """\
; ── Satellite Orbit Path: X Coordinates ──────────────────────────
; 256 bytes. Paired with the Y table above to define the full 2D
; orbit path. Index into both tables with the satellite's position
; counter (0-239) to get screen coordinates.""",

    0x520E: """\
; ── Satellite State: Orbit Position ──────────────────────────────
; 4 bytes (one per satellite slot). Current position index (0-239)
; in the orbit path tables. Decremented each movement tick to orbit
; counterclockwise.""",

    0x5212: """\
; ── Satellite State: Hit Points / Active Flag ────────────────────
; 4 bytes (one per slot). 0 = empty/inactive. Nonzero = satellite
; exists with that many hit points remaining. Also equals points
; awarded per hit. Level 3: starts at 2. Level 4: 4. Level 5: 6.""",

    0x521A: """\
; ── Satellite Sprite Lookup by Hit Points ────────────────────────
; Maps remaining hit points to a sprite index, so satellites change
; appearance as they take damage.""",

    0x5337: """\
; ── Satellite Corner Transition Points ───────────────────────────
; 4 bytes: orbit positions ($96, $D6, $16, $56) corresponding to
; the 4 corners of the playfield. When a satellite's position matches
; one of these values, it triggers an enemy projectile spawn from
; that corner toward the player.""",

    0x53B8: """\
; ── Alien Type Table ─────────────────────────────────────────────
; 16 bytes: current evolution type for each alien.
;   Indices  0- 3: UP direction aliens
;   Indices  4- 7: LEFT direction aliens
;   Indices  8-11: DOWN direction aliens
;   Indices 12-15: RIGHT direction aliens
;
; Type values:
;   1 = UFO          (starting form)
;   2 = Eye Blue     (1st mutation)
;   3 = Eye Green    (2nd mutation)
;   4 = TV           ← GOAL STATE
;   5 = Diamond      (overshoot penalty)
;   6 = Bowtie       (5th mutation, wraps to UFO)
;
; The game is won when all 16 entries equal 4 (TV).""",

    0x536F: """\
; ── 4-Direction Fire Ammo Counter ────────────────────────────────
; 1 byte. Number of remaining "super shot" uses. Starts at 3,
; gains 1 with each difficulty increase. When > 0, pressing A or F
; fires in all 4 directions simultaneously.""",

    0x576C: """\
; ═══════════════════════════════════════════════════════════════════
; DIFFICULTY TABLES — 8 parallel tables, 12 entries each
; ═══════════════════════════════════════════════════════════════════
; Indexed by difficulty (0=hardest, 11=easiest). All timers use
; wrap-around counting: increment from the reload value toward $FF,
; then wrap and execute. Higher value = fewer frames = FASTER.
;
; Total hits to reach maximum difficulty: 328
;   Level 11→10: 16 hits    Level 10→9: 16 hits
;   Level  9→8:  16 hits    Level  8→7: 24 hits
;   Level  7→6:  24 hits    Level  6→5: 30 hits
;   Level  5→4:  30 hits    Level  4→3: 40 hits
;   Level  3→2:  48 hits    Level  2→1: 42 hits
;   Level  1→0:  42 hits
;
; ── Table 1: Main Game Speed ─────────────────────────────────────
; → frame_reload ($2F). Controls how fast everything runs.
; Easiest ($E0): 32 frames/tick ≈ 312ms. Hardest ($FC): 4 frames ≈ 39ms.
; 8× speed increase across the full difficulty range.""",

    0x5778: """\
; ── Table 2: Satellite / Redraw Speed ────────────────────────────
; → $52F2. Controls satellite orbit speed and screen redraw timing.
; Effective speed = (256 - value) × 4 frames per satellite step.
; Easiest: 112 frames/step. Hardest: 28 frames/step. 4× range.""",

    0x5784: """\
; ── Table 3: Alien Draw Timing ───────────────────────────────────
; → $55E0. Controls alien sprite animation speed.""",

    0x5790: """\
; ── Table 4: Alien Fire Rate ─────────────────────────────────────
; → fire_rate ($32). How often aliens shoot at the player.
; Easiest ($E0): every 32 frames. Hardest ($FC): every 4 frames. 8× range.""",

    0x579C: """\
; ── Table 5: Enemy Projectile Timer ──────────────────────────────
; → $57CC. 2-byte cascaded timer for enemy projectile spawning.
; Effective interval = (256 - value)² frames per shot.
; Easiest: 256 frames. Hardest: 144 frames.""",

    0x57A8: """\
; ── Table 6: Timer Parameter 2 ───────────────────────────────────
; → $57CF.""",

    0x57B4: """\
; ── Table 7: Timer Parameter 3 (constant) ────────────────────────
; → $57D2. All entries are $F0 — no variation across difficulty.""",

    0x57C0: """\
; ── Table 8: Steps to Next Difficulty Increase ───────────────────
; → diff_steps ($31). Hits required before advancing to the next
; difficulty level. Index 0 (hardest) = $FF (never increases further).
; Values: ∞, 42, 42, 48, 40, 30, 30, 24, 24, 16, 16, 16""",

    0x5D48: """\
; ── Player Projectile State Tables ───────────────────────────────
; 4 bytes each, one per direction (UP/RIGHT/DOWN/LEFT):
;   $5D48-$5D4B: X position, low byte
;   $5D4C-$5D4F: X position, high byte
;   $5D50-$5D53: Y position
;   $5D54-$5D57: State (0=none, 2=exploding, 3=active)
;   $5D58-$5D5B: Active flag (0=inactive, 1=active)
;   $5D5C-$5D5F: Draw X, low (rendering copy)
;   $5D60-$5D63: Draw X, high (rendering copy)
;   $5D64-$5D67: Draw Y (rendering copy)
;   $5D68-$5D6B: Base spawn X, low
;   $5D6C-$5D6F: Base spawn X, high
;   $5D70-$5D73: Base spawn Y""",

    0x5D7C: """\
; ── Sprite Pointer Table (Low Bytes) ─────────────────────────────
; 161 entries. Low byte of each sprite's data address in memory.
; Indexed by sprite number (0-160).""",

    0x5E1D: """\
; ── Sprite Pointer Table (High Bytes) ────────────────────────────
; 161 entries. High byte paired with the low-byte table above.""",

    0x5EBE: """\
; ── Sprite Width Table ───────────────────────────────────────────
; 161 entries. Width in bytes for each sprite. Determines how many
; HGR memory bytes wide the sprite is (multiply by 7 for pixels).""",

    0x5F5F: """\
; ── Sprite Height Table ──────────────────────────────────────────
; 161 entries. Height in scanline rows for each sprite.""",

    0x6000: """\
; ═══════════════════════════════════════════════════════════════════
; SPRITE BITMAP DATA ($6000-$71FF)
; ═══════════════════════════════════════════════════════════════════
; Pre-shifted sprite bitmaps. Each sprite has 7 copies (shifted 0-6
; bits right) so that any horizontal pixel position can be drawn
; without runtime bit shifting. On a 1 MHz 6502, this memory-for-
; speed tradeoff is essential for smooth animation.
;
; Apple II HGR packs 7 pixels per byte (bit 7 is the color flag),
; so 7 shift positions cover every possible sub-byte alignment.
;
; Sprite types include:
;   - UFO alien (type 1)         - Eye Blue alien (type 2)
;   - Eye Green alien (type 3)   - TV alien (type 4) — THE GOAL
;   - Diamond alien (type 5)     - Bowtie alien (type 6)
;   - Player base               - Laser projectile
;   - Hit flash / explosion     - Satellite (multiple health states)
;   - Directional arrows        - Score digits (0-9)
;   - "GAME OVER" / "LEVEL" text sprites
;   - Heart and upside-down heart projectiles
;   - Broderbund logo""",
}


# ═══════════════════════════════════════════════════════════════════════
#                       FILE HEADER
# ═══════════════════════════════════════════════════════════════════════

FILE_HEADER = """\
; ╔═══════════════════════════════════════════════════════════════════════╗
; ║                                                                       ║
; ║   GENETIC DRIFT — Reconstructed Source Code                           ║
; ║                                                                       ║
; ║   Written by Scott Schram, 1981                                       ║
; ║   Published by Broderbund Software                                    ║
; ║                                                                       ║
; ╠═══════════════════════════════════════════════════════════════════════╣
; ║                                                                       ║
; ║   Reverse-engineered from the original 14,889-byte binary in a        ║
; ║   collaboration between the author and Claude Code, 2025.             ║
; ║   The original Apple II assembly source was lost decades ago;          ║
; ║   this reconstruction recovers it from the surviving binary.          ║
; ║                                                                       ║
; ╚═══════════════════════════════════════════════════════════════════════╝
;
;
; ── HOW TO READ THIS FILE ────────────────────────────────────────────
;
; This is 6502 assembly source code, reconstructed from the original
; binary. Every instruction is the exact machine code Schram wrote.
; The annotations (comments, labels, variable names) have been added
; to explain the code's structure and purpose.
;
; Address column shows the runtime memory address. The binary loads
; at $37D7 but self-relocates: the bootstrap copies $3800-$3FFF down
; to $0000-$07FF, then the main game code runs at $4000-$71FF.
;
;
; ── MEMORY MAP ───────────────────────────────────────────────────────
;
;   $0000-$007F   Zero page — game state, pointers, counters
;   $0080-$00FF   Zero page — additional variables, sprite state
;   $0100-$01FF   6502 stack
;   $0200-$07FF   Relocated code block:
;                   $025D   Custom RWTS (Broderbund disk reader)
;                   $02D1   Nibble data decoder
;                   $03CC+  Broderbund splash screen code
;                   $0403   Pseudorandom number generator
;                   $0416   DrawSprite — render sprite by index
;                   $0462   EraseSprite — XOR-erase sprite by index
;                   $0700   HGR scanline address lookup tables
;   $0800-$1FFF   (DOS 3.3 / free memory)
;   $2000-$3FFF   HGR Page 1 — the visible screen
;   $4000-$5FFF   Main game code:
;                   $40C0   DrawSpriteXY (core sprite engine)
;                   $4120   HGR initialization
;                   $416C   HGR line address tables (192 entries)
;                   $43E0   Keyboard handler
;                   $4A86   Game over
;                   $4AE0   Score addition (BCD)
;                   $4C56   Sound generation
;                   $4D73   Level setup
;                   $4DE3   Alien evolution
;                   $4F5B   Satellite collision detection
;                   $5227   Satellite spawning
;                   $52F3   Screen redraw / satellite movement
;                   $5370   4-direction fire ammo
;                   $53B8   Alien type tables (4 dirs × 4 aliens)
;                   $56E4   Difficulty increase
;                   $56F3   Load difficulty tables
;                   $576C   Difficulty lookup tables (8 × 12)
;                   $5809   New game initialization
;                   $5875   Main game loop
;                   $5C78   Victory condition check
;                   $5CB8   Level complete handler
;                   $5D48   Projectile state tables
;                   $5D7C   Sprite pointer/size tables
;   $6000-$71FF   Sprite bitmap data (pre-shifted, 7 copies each)
;
;
; ── GAME OVERVIEW ────────────────────────────────────────────────────
;
; Genetic Drift is a fixed-screen action game where 16 aliens orbit
; the edges of the playfield in 4 groups of 4 (up, down, left, right).
; The player sits at the center and fires in cardinal directions.
;
; Each hit causes an alien to "mutate" through a 6-stage cycle:
;   UFO → Eye Blue → Eye Green → TV → Diamond → Bowtie → (wraps)
;
; The goal is to land all 16 aliens on the TV state simultaneously.
; Three hits advance UFO to TV, but one extra hit pushes past it
; to Diamond, requiring 5 more hits to cycle back. This creates a
; puzzle of shot counting layered on top of fast action gameplay.
;
; The game has 5 levels, progressive difficulty (12 speed tiers
; across 328 total hits), a satellite bonus system in levels 3-5,
; a heart penalty mechanic, and a hidden cheat code (Shift-N).
;
; All of this fits in 14,889 bytes of 6502 machine code.
;
;
; ── KEY ENTRY POINTS ─────────────────────────────────────────────────
;
;   $37D7   Bootstrap loader (initial entry from DOS)
;   $57D7   Main entry point (after self-relocation)
;   $5809   New game initialization
;   $5875   Main game loop
;   $40C0   DrawSpriteXY — core sprite rendering engine
;   $025D   RWTS — Broderbund custom disk read
;
"""


# ═══════════════════════════════════════════════════════════════════════
#                    TRANSFORMATION ENGINE
# ═══════════════════════════════════════════════════════════════════════

# Patterns to strip from individual lines (appended machine annotations)
NOISE_PATTERNS_INLINE = [
    # Register liveness: ; A=$0000 X=$0003 Y=[stk] ; A=comp@$4006 Y=A etc.
    re.compile(r'\s*;\s*A=[\[$c].*$'),
    # Register operations: ; A=A^$24, ; A=A-$01 X=$0002 Y=$0001, ; A=A X=$0003
    re.compile(r'\s*;\s*A=A[\s^&|+\-].*$'),
    # Stack pointer: ; [SP-86]
    re.compile(r'\s*;\s*\[SP[-+]\d+\].*$'),
    # Optimization hints: ; [OPT] REDUNDANT_LOAD: ...
    re.compile(r'\s*;\s*\[OPT\].*$'),
    # Pointer resolution: ; -> $089A (may have trailing noise)
    re.compile(r'\s*;\s*->\s*\$[0-9A-Fa-f]+.*$'),
    # Call site annotations: ; Call $0020E0(A, X, Y) or ; Call $004D73(A)
    re.compile(r'\s*;\s*Call \$[0-9A-Fa-f]+\([^)]*\).*$'),
    # Hardware I/O tags: {Video} <video_mode_read> or {Keyboard} <keyboard_strobe>
    # These can appear mid-comment with trailing content
    re.compile(r'\s*\{(Video|Keyboard|Speaker|Joystick|Disk)\}\s*<[a-z_]+>.*$'),
    # I/O register comments: ; $C08C - Unknown I/O register <slot_io>
    re.compile(r'\s*;\s*\$C0[0-9A-Fa-f]{2}\s*-\s*(Unknown )?I/O register\s*<[a-z_]+>.*$'),
    # Key comment (keep the useful part before machine noise)
    re.compile(r'\s*;\s*key:\s+\w+\s*$'),
    # Disassembler warnings appended to instruction lines
    re.compile(r'\s*;\s*WARNING:.*$'),
]

# Full lines to remove entirely
NOISE_LINE_PATTERNS = [
    # Machine function signatures
    re.compile(r'^;\s*FUNC \$'),
    re.compile(r'^;\s*Proto:\s'),
    re.compile(r'^;\s*Liveness:\s'),
    re.compile(r'^;\s*Frame:\s'),
    # Loop markers
    re.compile(r'^;\s*===\s*(while|for|do-while)\s+loop'),
    re.compile(r'^;\s*===\s*End of (while|for|do-while)\s+loop'),
    re.compile(r'^;\s*===\s*loop\b'),
    # Report headers and content
    re.compile(r'^;\s*(Optimization Hints|Loop Analysis|Call Site Analysis|'
               r'Type Inference|Switch/Case Detection|Cross-Reference|'
               r'Stack Frame Analysis|Liveness Analysis|Function Signature|'
               r'Constant Propagation|Hardware Context|Analysis Summary)\b'),
    re.compile(r'^;\s*(Total hints|Estimated savings|Total loops|'
               r'Total call sites|Entries analyzed|Switches found|'
               r'Total references|Functions analyzed|Constants found|'
               r'Total I/O|Subsystem Access|Final Video|Memory State|'
               r'Speed Mode|Detected Hardware|Basic blocks|CFG edges|'
               r'Loops detected|Patterns matched|Branch targets|'
               r'Functions:|Call edges|Max nesting|Detected Loops|'
               r'Detected Switches|Parameter Statistics|Calling Convention|'
               r'Register params|Stack params|Predominantly)\b'),
    # Report table headers and data lines
    re.compile(r'^;\s*(Address|Entry|Target|Header|Function)\s+(Type|End|From|Tail)\b'),
    re.compile(r'^;\s*-------'),
    re.compile(r'^;\s*\$[0-9A-Fa-f]{4,8}\s*:\s*(while|for|loop|jump_table|BRANCH|READ|INDIRECT|CALL|params)\b'),
    re.compile(r'^;\s*\$[0-9A-Fa-f]{6}\s+\$[0-9A-Fa-f]{6}'),  # Loop header/tail table
    re.compile(r'^;\s*~\d+ iterations'),
    re.compile(r'^;\s*\.\.\. and \d+ more'),
    # Type inference noise
    re.compile(r'^;\s*\$[0-9A-Fa-f]+\s+(ARRAY|BYTE|WORD|PTR|FLAG|STRUCT|LONG)\b'),
    re.compile(r'^;\s*(Bytes typed|Words typed|Pointers typed|Arrays typed|Structs typed)\b'),
    re.compile(r'^;\s*Inferred Types:'),
    re.compile(r'^;\s*(for|while|do-while|infinite|counted):'),
    # Switch case noise
    re.compile(r'^;\s*Switch #\d+'),
    re.compile(r'^;\s*(Type|Table|Index Reg|Cases):'),
    re.compile(r'^;\s*(Jump tables|CMP chains|Computed|Total cases|Max cases)\b'),
    # Stack frame noise
    re.compile(r'^;\s*Functions with frames:'),
    re.compile(r'^;\s*Function \$[0-9A-Fa-f]+:'),
    re.compile(r'^;\s*(Leaf|DP-relative|Stack slots):'),
    re.compile(r'^;\s*\+\d+:\s*param_'),
    # Liveness noise
    re.compile(r'^;\s*Function Details:'),
    re.compile(r'^;\s*\$[0-9A-Fa-f]+:\s*(params|returns)\('),
    re.compile(r'^;\s*(Leaf functions|Interrupt handlers|Stack params|Register params):'),
    # Constant propagation noise
    re.compile(r'^;\s*(Loads with known|Branches resolved|Compares resolved|Memory constants)\b'),
    re.compile(r'^;\s*Final register state:'),
    re.compile(r'^;\s*(A|X|Y|S|DP|DBR|PBR|P):\s*(unknown|\[|undefined)'),
    # Cross-reference noise
    re.compile(r'^;\s*(Calls|Jumps|Branches|Data):\s*\d+'),
    # Call site detail noise
    re.compile(r'^;\s*\$[0-9A-Fa-f]+:\s*JS[RL]\s'),
    # Report section markers (=== ... Report ===)
    re.compile(r'^;\s*===\s*(Optimization|Loop|Call|Type|Switch|Cross|Stack|'
               r'Liveness|Function Sig|Constant|Hardware|Analysis)\b'),
    # Disassembly metadata
    re.compile(r'^;\s*Disassembly generated by DeAsmIIgs'),
    re.compile(r'^;\s*Source:\s*D:/Projects'),
    re.compile(r'^;\s*Base address:\s*\$'),
    re.compile(r'^;\s*Size:\s*\d+ bytes'),
    re.compile(r'^;\s*Analysis:\s*\d+ functions'),
    re.compile(r'^;\s*Flags:\s*L=Leaf'),
    # Emulation mode markers
    re.compile(r'^\s*;\s*Emulation mode'),
    # Data region markers (keep these but simplify)
    re.compile(r'^;\s*---\s*(End d|D)ata region\s*\(\d+ bytes\)'),
    re.compile(r'^;\s*---\s*Data region\s*---'),
    # Report separator lines (=== with 10+ chars)
    re.compile(r'^;\s*={10,}$'),
    # Stray report continuation lines
    re.compile(r'^;\s*(Nest|Counter)\b'),
    re.compile(r'^;\s*\(none\)'),
    # Optimization hint table rows: ; $004311   REDUNDANT_LOAD  MEDIUM  3  ...
    re.compile(r'^;\s*\$[0-9A-Fa-f]{6}\s+(REDUNDANT_LOAD|STRENGTH_RED|PEEPHOLE|TAIL_CALL)\b'),
    # Call site summary lines
    re.compile(r'^;\s*(JSR|JSL|Toolbox)\s+calls?:\s*\d+'),
    re.compile(r'^;\s*Register-based\s+parameter\b'),
    re.compile(r'^;\s*Call Sites\s*\('),
    # Short separator lines (------  ----  etc.)
    re.compile(r'^;\s*-{4,}\s+-{4,}'),
    # Cross-reference table rows: $000000  READ/BRANCH/INDIRECT/CALL  $0004A6
    re.compile(r'^;\s*\$[0-9A-Fa-f]{6}\s+(READ|BRANCH|INDIRECT|CALL)\s+\$[0-9A-Fa-f]+'),
    re.compile(r'^;\s*Target Address\s+Type\s+From Address'),
    # Function register/dead store stats
    re.compile(r'^;\s*Functions with register (params|returns):\s*\d+'),
    re.compile(r'^;\s*Total dead stores detected:\s*\d+'),
    # I/O pattern sequences
    re.compile(r'^;\s*===\s*I/O Pattern\b'),
    re.compile(r'^;\s*\$[0-9A-Fa-f]+:\s*(video_mode|text_mode|speaker|keyboard|disk_|hgr_|softswitch)\b'),
    # Saves: A/X/Y lines
    re.compile(r'^;\s*Saves:\s*[AXY]'),
    # Constant propagation state: $000006 = $0000 (abs) or Y: $00B8 (set at ...)
    re.compile(r'^;\s*\$[0-9A-Fa-f]+\s*=\s*\$[0-9A-Fa-f]+\s*\((abs|dp)\)'),
    re.compile(r'^;\s*[AXYSDP][A-Z]*:\s*\$[0-9A-Fa-f]+\s*\(set at\b'),
    # Switch/case detail tables
    re.compile(r'^;\s*Case Details:'),
    re.compile(r'^;\s*Value\s+Target\s+Label'),
    re.compile(r'^;\s*-----\s+--------'),
    re.compile(r'^;\s*\d+\s+\$[0-9A-Fa-f]+\s+sw_'),
    re.compile(r'^;\s*(Default|deflt):\s+\$[0-9A-Fa-f]+'),
    re.compile(r'^;\s*\(too many cases'),
    re.compile(r'^;\s*Function Signatures:'),
    # Stray switch/dispatch labels
    re.compile(r'^;\s*deflt\s+\$[0-9A-Fa-f]+\s+sw_'),
    # LUMA pattern labels (function recognition)
    re.compile(r'^;\s*LUMA:\s'),
    # Stack Depth Analysis Report (entire block)
    re.compile(r'^;\s*Stack Depth Analysis Report'),
    re.compile(r'^;\s*Entry depth:\s'),
    re.compile(r'^;\s*Current depth:\s'),
    re.compile(r'^;\s*Min depth:\s'),
    re.compile(r'^;\s*Max depth:\s'),
    re.compile(r'^;\s*Stack Operations:'),
    re.compile(r'^;\s*Push:\s+\d+\s+Pull:'),
    re.compile(r'^;\s*JSR/JSL:\s+\d+\s+RTS/RTL:'),
    re.compile(r'^;\s*WARNING: Stack\s'),
    re.compile(r'^;\s*Entry depth:\s+\d+,\s+Return depth:'),
    re.compile(r'^;\s*Inferred Local Variables:'),
    re.compile(r'^;\s*Stack frame size:\s'),
    re.compile(r'^;\s*Offsets:\s+S\+'),
    # Language Card notes
    re.compile(r'^;\s*-?\s*Language [Cc]ard'),
    # Cross-reference with 6-8 digit addresses: $00020F  JUMP  $00020C
    re.compile(r'^;\s*\$[0-9A-Fa-f]{6,8}\s+(JUMP|WRITE|READ|CALL|INDIRECT)\b'),
    # Stray report headers not fully caught
    re.compile(r'^;\s*TYPE INFERENCE REPORT'),
    re.compile(r'^;\s*SWITCH/CASE DETECTION REPORT'),
    re.compile(r'^;\s*CROSS-REFERENCE REPORT'),
    re.compile(r'^;\s*HARDWARE CONTEXT'),
    re.compile(r'^;\s*I/O Access Pattern'),
    # Call graph entries: ;   $0040C0: 10 caller(s)
    re.compile(r'^;\s*\$[0-9A-Fa-f]{6,8}:\s+\d+\s+caller'),
    re.compile(r'^;\s*Call graph:'),
    # Analysis summary lines
    re.compile(r'^;\s*Functions:\s*\d+'),
    re.compile(r'^;\s*Loops:\s*$'),
    re.compile(r'^;\s*Pattern summary:'),
    re.compile(r'^;\s*GS/OS calls:\s*\d+'),
    # Resolved jump table sections
    re.compile(r'^;\s*===\s*Resolved Jump Tables'),
    re.compile(r'^;\s*Jump Table at \$'),
    re.compile(r'^;\s*Dispatch code at \$'),
    re.compile(r'^;\s*\[\s*\d+\]\s*\$[0-9A-Fa-f]+'),
    # End of loop markers
    re.compile(r'^;\s*===\s*End of loop'),
    # False string detection
    re.compile(r'^;\s*String:\s*"'),
    # Hardware access count lines: ;   Keyboard : 7
    re.compile(r'^;\s*(Keyboard|Speaker|Joystick|Video|Disk)\s*:\s*\d+'),
    re.compile(r'^;\s*-\s*Speaker toggle'),
    # Disassembler warnings (any WARNING: from deasmiigs)
    re.compile(r'^;\s*WARNING:\s'),
    # Duplicate section markers (machine-generated --- style)
    re.compile(r'^;\s*---\s*(HGR|Data|Sprite|Jump)\s'),
    # Hardware I/O pattern annotations on their own lines
    re.compile(r'^;\s*--\s*(video_mode|keyboard|hw_|speaker)'),
    re.compile(r'^;\s*\$[0-9A-Fa-f]+:\s*(video_mode|text_mode|keyboard|speaker|joystick|disk_)\w*\s*-'),
    # Machine-generated ALL CAPS section headers: ; SOME NAME ($XXXX)
    # These are superseded by our injected ── FunctionName ── headers
    re.compile(r'^;\s*[A-Z][A-Z ]{3,}\(\$[0-9A-Fa-f]{4}\)'),
    # Misleading opcode mnemonics on data bytes (disassembler artifacts):
    # "Interrupt return (RTI)" when $40 appears in sprite/table data
    # "Block move (MVN)" when $54 appears in data
    re.compile(r'^;\s*(Interrupt return|Block move|Break|Wait for interrupt|Co-processor)\s*\('),
]

def is_noise_line(line):
    """Check if an entire line should be removed."""
    stripped = line.strip()
    if not stripped:
        return False  # Keep blank lines
    for pat in NOISE_LINE_PATTERNS:
        if pat.search(stripped):
            return True
    return False

def clean_inline_noise(line):
    """Remove machine annotations appended to instruction lines."""
    for pat in NOISE_PATTERNS_INLINE:
        line = pat.sub('', line)
    # Fix mangled S0_ slot I/O labels: S0_score_lo,X → $C08C,X; S0_$0C,X → $C08C,X
    line = re.sub(r'S0_score_lo,X', '$C08C,X', line)
    line = re.sub(r'S0_\$0C,X', '$C08C,X', line)
    line = re.sub(r'S0_[A-Za-z_$][A-Za-z0-9_$]*', '$C080', line)  # generic fallback
    # Fix forced-absolute prefix: !src_lo → $0000 (absolute addressing of ZP)
    line = re.sub(r'!(\w+)', lambda m: '$' + format(
        next((a for a, (n, _) in ZERO_PAGE.items() if n == m.group(1)), 0), '04X'), line)
    # Replace tautological soft-switch comments with meaningful ones
    for old_comment, new_comment in SOFT_SWITCH_COMMENTS.items():
        line = line.replace(old_comment, new_comment)
    return line.rstrip()

def build_zp_replacement_map():
    """Build regex patterns for zero-page address replacement."""
    replacements = []
    # Sort by address descending to avoid partial matches ($0C before $0)
    for addr in sorted(ZERO_PAGE.keys(), reverse=True):
        name, _ = ZERO_PAGE[addr]
        hex2 = f'${addr:02X}'
        hex4 = f'${addr:04X}'
        # Match $XX or $00XX in instruction operands (after whitespace + mnemonic)
        # Be careful: only replace when it's clearly a zero-page operand
        replacements.append((addr, name, hex2, hex4))
    return replacements

def replace_zp_addresses(line, zp_map):
    """Replace zero-page addresses with named equates in instruction lines."""
    # Only process lines that look like instructions (have hex address prefix)
    if not re.match(r'^[0-9A-Fa-f]{6}\s', line):
        return line

    # Split into address/bytes/instruction/comment
    # Format: "0037D7  8D 10 C0                      sta  CLRKBD"
    parts = line.split(';', 1)
    code_part = parts[0]
    comment_part = ';' + parts[1] if len(parts) > 1 else ''

    # Strip forced-absolute prefix: "lda  !$0000" → "lda  $0000"
    # deasmiigs uses ! to indicate absolute addressing of zero-page addresses
    code_part = re.sub(r'!\$', '$', code_part)

    for addr, name, hex2, hex4 in zp_map:
        # Replace $XX in operand position (e.g., "lda  $30" → "lda  difficulty")
        # Match after instruction mnemonic, handle various addressing modes:
        #   $XX          → name          (zero page)
        #   ($XX),Y      → (name),Y      (indirect indexed)
        #   ($XX,X)      → (name,X)      (indexed indirect)

        # Direct zero-page: "lda  $30" but NOT "lda  $3000" or "lda  #$30"
        # Also avoid replacing inside addresses or hex byte columns
        old = code_part
        # Find instruction portion (after the hex bytes, in the mnemonic area)
        m = re.match(r'^([0-9A-Fa-f]{6}\s+[0-9A-Fa-f ]{8,30})(.*)', code_part)
        if m:
            prefix = m.group(1)  # address + hex bytes
            instr = m.group(2)   # mnemonic + operand

            # Replace $XX as standalone operand (not part of larger number)
            # Patterns: $XX, ($XX), $XX,X, $XX,Y, ($XX),Y, ($XX,X)
            # CRITICAL: Do NOT replace #$XX (immediate values) — only memory addresses
            instr = re.sub(
                r'(?<!#)(?<!\$[0-9A-Fa-f])' + re.escape(hex2) + r'(?![0-9A-Fa-f])',
                name, instr)
            # Also match $00XX form
            instr = re.sub(
                r'(?<!#)(?<!\$[0-9A-Fa-f])' + re.escape(hex4) + r'(?![0-9A-Fa-f])',
                name, instr)

            code_part = prefix + instr

    return code_part + comment_part


def add_call_labels(line):
    """Append subroutine name comments to bare jsr/jmp instructions."""
    # Match: "addr  bytes  jsr  $XXXX" or "jmp  $XXXX" without existing comment
    if ';' in line:
        return line  # already has a comment, don't double up
    m = re.search(r'\b(jsr|jmp)\s+\$([0-9A-Fa-f]{4})\s*$', line, re.IGNORECASE)
    if m:
        target = int(m.group(2), 16)
        if target in CALL_LABELS:
            line = line.rstrip() + '                    ; ' + CALL_LABELS[target]
            # Clean up excessive whitespace before the comment
            line = re.sub(r'\s{4,};', '  ;', line)
    return line


def get_address_from_line(line):
    """Extract the 6-digit hex address from an instruction line."""
    m = re.match(r'^([0-9A-Fa-f]{6})\s', line)
    if m:
        return int(m.group(1), 16)
    return None


def should_inject_before(addr, line=None):
    """Check if we should inject function/data annotations before this address.

    For HEX lines, also checks if the address range covers any data table entries.
    """
    injections = []
    if addr in FUNCTIONS:
        name, how, why = FUNCTIONS[addr]
        block = []
        block.append(f"; ── {name} ──" + "─" * max(1, 60 - len(name)))
        block.append(how)
        if why:
            block.append(why)
        injections.extend(block)

    if addr in DATA_TABLES:
        injections.append(DATA_TABLES[addr])

    # For HEX data lines, check if any function or data table addresses
    # fall within this line's address range
    if line and 'HEX' in line:
        m = re.match(r'^[0-9A-Fa-f]{6}\s+[0-9A-Fa-f]+\s+HEX\s+(.*)', line)
        if m:
            hex_data = m.group(1).replace(' ', '')
            end_addr = addr + len(hex_data) // 2
            for func_addr in sorted(FUNCTIONS.keys()):
                if func_addr != addr and addr < func_addr < end_addr:
                    name, how, why = FUNCTIONS[func_addr]
                    block = []
                    block.append(f"; ── {name} ──" + "─" * max(1, 60 - len(name)))
                    block.append(how)
                    if why:
                        block.append(why)
                    injections.extend(block)
            for table_addr in sorted(DATA_TABLES.keys()):
                if table_addr != addr and addr < table_addr < end_addr:
                    injections.append(DATA_TABLES[table_addr])

    return injections


def generate_equates_block():
    """Generate the zero-page equates section."""
    lines = []
    lines.append(";")
    lines.append("; ═══════════════════════════════════════════════════════════════════")
    lines.append(";                        ZERO PAGE EQUATES")
    lines.append("; ═══════════════════════════════════════════════════════════════════")
    lines.append(";")

    # Group by function
    groups = [
        ("Graphics System", [0x02, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B,
                             0x13, 0x16, 0x17, 0x19, 0x1A]),
        ("Game State", [0x0C, 0x0D, 0x0E, 0x0F, 0x10, 0x11, 0x12, 0x34, 0x36, 0x3A]),
        ("Line Drawing / Projectile Math", [0x1B, 0x1C, 0x1D, 0x1E, 0x1F, 0x20, 0x21,
                                            0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A]),
        ("Timing / Difficulty", [0x2C, 0x2D, 0x2E, 0x2F, 0x30, 0x31, 0x32, 0x35]),
        ("RWTS / Disk I/O", [0x2B, 0x3D]),
        ("General Purpose", [0x00, 0x01, 0x03, 0x3C]),
    ]

    max_name_len = max(len(ZERO_PAGE[a][0]) for a in ZERO_PAGE)

    for group_name, addrs in groups:
        lines.append(f"; ── {group_name} ──")
        for addr in addrs:
            if addr in ZERO_PAGE:
                name, desc = ZERO_PAGE[addr]
                padding = " " * (max_name_len - len(name) + 1)
                lines.append(f"{name}{padding} EQU ${addr:02X}      ; {desc}")
        lines.append("")

    return '\n'.join(lines)


def transform(input_path, output_path):
    """Main transformation: raw disassembly → clean annotated source."""
    with open(input_path, 'r', encoding='utf-8', errors='replace') as f:
        raw_lines = f.readlines()

    zp_map = build_zp_replacement_map()
    output = []
    in_original_header = True  # Skip the original file header
    skip_until_code = False
    consecutive_blanks = 0
    prev_was_section = False
    seen_addresses = set()

    # Write our clean header
    output.append(FILE_HEADER)
    output.append(generate_equates_block())
    output.append("")

    for i, raw_line in enumerate(raw_lines):
        line = raw_line.rstrip('\n\r')

        # Skip the original file header (everything before first code line)
        if in_original_header:
            addr = get_address_from_line(line)
            if addr is not None:
                in_original_header = False
                # Fall through to process this line
            else:
                # Keep section headers we wrote ourselves
                if line.startswith('; ====') and 'SEGMENT:' in line:
                    in_original_header = False
                    # Rewrite the segment header in our style
                    m = re.search(r'SEGMENT:\s*(.*?)(?:\s*\(|$)', line)
                    if m:
                        seg_name = m.group(1).strip()
                        output.append("")
                        output.append("; " + "═" * 67)
                        output.append(f";   {seg_name}")
                        output.append("; " + "═" * 67)
                    continue
                continue

        # Check for section headers we want to keep/rewrite
        if line.startswith('; ====') and 'SEGMENT:' in line:
            m = re.search(r'SEGMENT:\s*(.*?)(?:\s*\(|$)', line)
            if m:
                seg_name = m.group(1).strip()
                output.append("")
                output.append("; " + "═" * 67)
                output.append(f";   {seg_name}")
                output.append("; " + "═" * 67)
            skip_until_code = True
            prev_was_section = True
            continue

        # Skip multi-line block after segment header until we hit code/data
        if skip_until_code:
            addr = get_address_from_line(line)
            if addr is not None:
                skip_until_code = False
                # Fall through
            elif line.strip() and not line.strip().startswith(';'):
                skip_until_code = False
            else:
                # Check if it's a meaningful comment we should keep
                stripped = line.strip()
                if stripped.startswith('; This') or stripped.startswith('; The main'):
                    # Keep descriptive segment comments
                    if not is_noise_line(line):
                        output.append(line)
                continue

        # Remove noise lines
        if is_noise_line(line):
            continue

        # Clean inline noise from instruction lines
        line = clean_inline_noise(line)

        # Skip now-empty comment lines (were entirely noise)
        if line.strip() == ';' or line.strip() == '; ':
            continue

        # Check for address and inject function/data annotations
        addr = get_address_from_line(line)
        if addr is not None:
            # Convert fake instructions in data-only regions to HEX blocks.
            # The $0000-$025C region is disk bootstrap data, and $4000-$4007
            # is crosshatch sprite data — the disassembler misinterprets
            # some byte patterns as 6502 opcodes.
            is_data_region = (addr < 0x025D) or (0x4000 <= addr <= 0x4007)
            if is_data_region and 'HEX' not in line:
                # Extract hex bytes from the line and convert to HEX format
                m = re.match(r'^([0-9A-Fa-f]{6})\s+([0-9A-Fa-f ]+?)\s{2,}', line)
                if m:
                    hex_bytes = m.group(2).replace(' ', '')
                    line = f'{m.group(1)}  {hex_bytes:<24s}HEX     {hex_bytes}'

            injections = should_inject_before(addr, line)
            if injections:
                output.append("")
                for inj in injections:
                    output.append(inj)
                output.append("")

        # Replace zero-page addresses with names
        if addr is not None:
            line = replace_zp_addresses(line, zp_map)
            line = add_call_labels(line)

        # Collapse excessive blank lines
        if not line.strip():
            consecutive_blanks += 1
            if consecutive_blanks > 2:
                continue
        else:
            consecutive_blanks = 0

        output.append(line)

    # Post-process: remove orphaned machine description blocks that appear
    # immediately before our injected ; ── FunctionName ── headers.
    # These are machine-generated descriptions that are now redundant.
    cleaned = []
    i = 0
    seen_first_header = False
    while i < len(output):
        # Look for our injected function headers
        if output[i].startswith('; ── ') and '──' in output[i][5:] and seen_first_header:
            # Walk backwards through cleaned[] to remove preceding comment
            # and blank lines that are orphaned machine descriptions.
            # Stop at code lines, HEX lines, or our own annotations.
            while cleaned:
                last = cleaned[-1].strip()
                if not last:  # blank line — continue walking back
                    cleaned.pop()
                    continue
                # Only remove comment lines that look like machine descriptions
                # Protect our own annotations (── headers, ═══ separators, HOW/WHY, →)
                if (last.startswith(';') and
                    not last.startswith('; ── ') and
                    not last.startswith('; ═') and
                    not last.startswith('; HOW:') and
                    not last.startswith('; WHY:') and
                    not last.startswith('; →') and
                    not last.startswith(';   Level') and
                    not last.startswith('; Total') and
                    not last.startswith('; Indexed')):
                    cleaned.pop()
                    continue
                break
        if output[i].startswith('; ── ') and '──' in output[i][5:]:
            seen_first_header = True
        cleaned.append(output[i])
        i += 1
    output = cleaned

    # Write output
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(output))
        f.write('\n')

    return len(output)


def main():
    base = Path(__file__).parent.parent
    title_dir = base / "archaeology" / "games" / "action" / "Genetic Drift (Broderbund 1981)"
    input_path = title_dir / "disassembly" / "genetic_drift_annotated.s"
    output_path = title_dir / "genetic_drift_source.s"

    if not input_path.exists():
        print(f"Error: input file not found: {input_path}", file=sys.stderr)
        sys.exit(1)

    print(f"Input:  {input_path}")
    print(f"Output: {output_path}")
    print()

    total_lines = transform(str(input_path), str(output_path))

    # Verification stats
    with open(str(output_path), 'r', encoding='utf-8') as f:
        content = f.read()

    noise_checks = [
        ('; A=[$', 'Register liveness'),
        ('; [SP-', 'Stack pointer'),
        ('; [OPT]', 'Optimization hints'),
        ('Proto:', 'Function prototypes'),
        ('Liveness:', 'Liveness analysis'),
        ('REDUNDANT_LOAD', 'Redundant load hints'),
        ('STRENGTH_RED', 'Strength reduction hints'),
        ('DeAsmIIgs', 'Disassembler watermark'),
    ]

    print(f"Output: {total_lines} lines")
    print()
    print("Noise check:")
    all_clean = True
    for pattern, label in noise_checks:
        count = content.count(pattern)
        status = "CLEAN" if count == 0 else f"FOUND {count}"
        if count > 0:
            all_clean = False
        print(f"  {label:30s} {status}")

    # Count named variables
    zp_count = 0
    for name, _ in ZERO_PAGE.values():
        if name in content:
            zp_count += 1
    print(f"\nNamed variables used: {zp_count}/{len(ZERO_PAGE)}")

    # Count function annotations
    func_count = sum(1 for addr in FUNCTIONS if f"── {FUNCTIONS[addr][0]} ──" in content)
    print(f"Function annotations: {func_count}/{len(FUNCTIONS)}")

    # Count data table annotations
    dt_count = sum(1 for addr in DATA_TABLES
                   if any(line in content for line in DATA_TABLES[addr].split('\n')[:1]))
    print(f"Data table annotations: {dt_count}/{len(DATA_TABLES)}")

    print()
    if all_clean:
        print("All machine noise removed successfully.")
    else:
        print("WARNING: Some machine noise remains — review output.")

    print(f"\nWrote: {output_path}")


if __name__ == '__main__':
    main()

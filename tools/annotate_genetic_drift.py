"""
Annotate the Genetic Drift disassembly using Scott Schram's analysis.

Reads genetic_drift_complete.s and produces genetic_drift_annotated.s with:
- Zero page variable equates
- Meaningful function/label names
- Section headers for major code regions
- Inline game-logic comments
- Data table labels

Supports both legacy (L_00XXXX) and new deasmiigs semantic label prefixes
(sub_, loc_, func_, loop_, dispatch_, irq_).
"""
import re
import sys
import os

INPUT = os.path.join(os.path.dirname(__file__), "genetic_drift_complete.s")
OUTPUT = os.path.join(os.path.dirname(__file__), "genetic_drift_annotated.s")

# Auto-generated label prefixes emitted by deasmiigs
AUTO_PREFIXES = ["L_", "loc_", "sub_", "func_", "loop_", "dispatch_", "irq_"]

# ============================================================================
# FUNCTION LABEL RENAMES
# Maps address (6 hex digits) -> meaningful name
# Works with any auto-generated prefix: L_00XXXX, loc_00XXXX, sub_00XXXX, etc.
# ============================================================================
LABEL_BY_ADDR = {
    # Relocated block functions
    "00025D": "RWTS_ReadSector",
    "00025E": "RWTS_SyncLoop",
    "00025F": "RWTS_WaitNibble1",
    "000264": "RWTS_CheckD5",
    "000268": "RWTS_WaitNibble2",
    "000272": "RWTS_WaitNibble3",
    "000284": "RWTS_ReadAddr",
    "000288": "RWTS_AddrNibble1",
    "000290": "RWTS_AddrNibble2",
    "0002A1": "RWTS_FoundSector",
    "0002A3": "RWTS_ReadDataLoop",
    "0002D1": "RWTS_DecodeData",
    "000100": "DiskBoot_Setup",
    "000211": "DiskBoot_NibbleDecode",
    "00021B": "DiskBoot_SkipSync",
    "000224": "DiskBoot_StoreNibble",

    # Main game functions
    "004001": "DrawSprite",
    "0040C0": "DrawSpriteXY",
    "0040E0": "DrawSprite_RowLoop",
    "0040F8": "DrawSprite_ColLoop",
    "00410D": "DrawSprite_NextRow",
    "004115": "DrawSprite_IncCol",
    "00411F": "DrawSprite_Done",
    "004120": "InitHiRes",
    "004128": "InitHiRes_ClearLoop",
    "00413E": "ClearPlayfield",
    "004140": "ClearPF_RowLoop",
    "00414E": "ClearPF_ColLoop",
    "00415B": "SetClipBounds",
    "0042EC": "PrintHexByte",
    "0042FC": "DrawTitleScreen",
    "00437A": "InitGameVarsA",
    "004387": "InitGameVarsB",
    "00439E": "InitGameVarsC",
    "0043B5": "SetupTitle",
    "0043CD": "PerFrameUpdate",
    "0043DD": "PerFrameUpdate_JmpDraw",
    "0043E0": "KeyboardHandler",
    "0043EF": "Key_CheckY",
    "0043F7": "Key_NoKey",
    "0043F8": "Key_CheckJ",
    "004401": "Key_CheckSpace",
    "00440A": "Key_CheckG",
    "004413": "Key_CheckAF",
    "00441C": "Key_4DirFire",
    "004441": "ClearSpriteArea",
    "004455": "ClearSprite_Loop",
    "00446B": "ClearSprite_Down",
    "004476": "ClearSprite_Right",
    "004492": "ClearSprite_Left",
    "004499": "DrawProjectile",
    "0044C4": "DrawHitFlash",
    "0044EF": "DrawHitFlash_B",
    "00450E": "PeriodicGameLogic",
    "00457F": "MoveAllLasers",
    "004641": "MoveLaserUp",
    "00464B": "MoveLaserLeft",
    "004658": "MoveLaserDownRight",
    "004914": "DrawAlienRow",
    "004940": "UpdateAlienAnim",
    "0049C6": "DrawAlienSide",
    "004A2F": "DrawAlienSideB",
    "004A86": "GameOver",
    "004AE0": "AddScore",
    "004B0C": "SelectProjectileType",
    "004B65": "PunishmentRoutine",
    "004C3C": "PlayPunishSound",
    "004C56": "PlayTone",
    "004C71": "PlayToneB",
    "004C99": "LevelCompleteAnim",
    "004D33": "DisplayLevelNum",
    "004D73": "LevelSetup",
    "004D87": "UpdateAlienPositions",
    "004DC4": "UpdateAlienPosB",
    "004DE3": "AlienEvolve",
    "004E15": "AlienEvolve_Inc",
    "004E38": "AlienHitHandler",
    "004E8B": "AlienHitHandlerB",
    "004EE0": "AlienHitHandlerC",
    "004F35": "PlaySound",
    "004F5B": "CheckSatelliteHits",
    "005227": "SpawnSatellite",
    "00527F": "DrawSatellite",
    "0052A1": "DrawSatelliteB",
    "0052C3": "DrawSatelliteC",
    "0052C9": "DrawSatelliteD",
    "0052CF": "DrawSatelliteE",
    "0052E5": "DrawBase",
    "0052F3": "RedrawScreen",
    "00533B": "RedrawScreenB",
    "005370": "Set4DirAmmo",
    "005376": "Set4DirAmmoB",
    "005381": "Fire4Dir",
    "005591": "DrawAlienRowDir",
    "0055E3": "DrawAlienRowDirB",
    "00560E": "DrawAlienRowDirC",
    "0056C9": "DrawAlienRowDirD",
    "0056E4": "IncreaseDifficulty",
    "0056F3": "LoadDifficultyTables",

    # Main entry + game flow
    "0057FE": "WaitForReturn",
    "005809": "StartNewGame",
    "005839": "CheckLifeLost",
    "005846": "ContinueAfterDeath",
    "005852": "ClearProjectiles_Loop",
    "005875": "MainGameLoop",
    "005891": "CheckPaddle",
    "00589B": "PaddleDebounce",
    "0058A5": "FireProjectile",
    "0058C3": "AfterFire",
    "0058CB": "CheckLaserHits",
    "005A04": "FrameTimingLoop",
    "005A5A": "LoopBack_MainGame",

    # Input/state
    "005B4F": "InputProcessA",
    "005B62": "InputProcessB",
    "005B6F": "InputProcessC",
    "005B77": "InputProcessD",

    # Star/screen
    "005C1C": "UpdateStarTwinkle",
    "005C28": "UpdateStarTwinkleB",
    "005C6C": "StarTwinkleC",
    "005C78": "CheckAllTVs",

    # Level complete
    "005CB8": "LevelComplete",
    "005D09": "Victory",
    "005D14": "InitProjectileTables",
    "005D27": "InitProjectileTablesB",

    # Bootstrap
    "0037EC": "Bootstrap_CopyLoop",
}

# Build regex pattern that matches any auto-prefix + known address
_addr_pattern = "|".join(re.escape(a) for a in LABEL_BY_ADDR.keys())
_prefix_pattern = "|".join(re.escape(p) for p in AUTO_PREFIXES)
LABEL_RE = re.compile(rf"(?:{_prefix_pattern})({_addr_pattern})\b")

def replace_labels(text):
    """Replace any auto-generated label (any prefix + known address) with its name."""
    def _repl(m):
        return LABEL_BY_ADDR[m.group(1)]
    return LABEL_RE.sub(_repl, text)

# ============================================================================
# SECTION HEADERS
# Inserted BEFORE the line containing the given address
# ============================================================================
SECTION_HEADERS = {
    "0057D7": """\
; ============================================================================
; MAIN ENTRY POINT ($57D7)
; ============================================================================
; Called after bootstrap relocation completes.
; Initializes clipping bounds, clears HGR screen, sets up title screen,
; zeroes score/high-score, sets lives=3, then waits for RETURN key.
; ============================================================================
""",
    "0057FE": """\
; ---------------------------------------------------------------------------
; Wait for RETURN key to start game
; ---------------------------------------------------------------------------
""",
    "005809": """\
; ============================================================================
; START NEW GAME ($5809)
; ============================================================================
; Sets lives=3, level=$3A=5 (Level 1), calls LevelSetup, zeros score,
; sets direction=UP, difficulty=easiest ($0B), loads timing tables,
; sets 4-dir fire ammo=3, initializes projectile/alien state.
; ============================================================================
""",
    "005839": """\
; ---------------------------------------------------------------------------
; Check if player lost a life - decrement lives, if <0 game over
; ---------------------------------------------------------------------------
""",
    "005875": """\
; ============================================================================
; MAIN GAME LOOP ($5875)
; ============================================================================
; Each tick:
;   1. Move all 4 laser beams ($457F)
;   2. Redraw screen/sprites ($52F3)
;   3. Check laser vs satellite collisions ($4F5B)
;   4. Update star twinkle animation ($5C1C)
;   5. Check if all 16 aliens are TVs - level complete ($5C78)
;   6. Handle keyboard input ($43E0) - direction + fire
;   7. Check paddle button ($C061) - alternative fire
;   8. Fire projectile if triggered ($58A5)
;   9. Update alien positions ($4D87)
;  10. Check laser vs alien collisions ($58CB)
;  11. Frame timing delay ($5A04)
;  12. Loop back to top
; ============================================================================
""",
    "0058CB": """\
; ---------------------------------------------------------------------------
; Check laser vs alien collisions (all 4 directions)
; Direction-specific coordinate comparisons determine hits.
; On hit: alien evolves, play sound, add 1 point.
; ---------------------------------------------------------------------------
""",
    "005CB8": """\
; ============================================================================
; LEVEL COMPLETE ($5CB8)
; ============================================================================
; Awards 50 point bonus, advances level (DEC $3A), plays animation.
; If $3A < 4: spawns 4 satellites.
; If $3A = 0: VICTORY!
; During animation: checks for Shift-N cheat code ($9E) which gives
; +3 lives and resets difficulty to easiest.
; ============================================================================
""",
    "0043E0": """\
; ============================================================================
; KEYBOARD HANDLER ($43E0)
; ============================================================================
; Direction keys set $11 (current direction):
;   Y ($D9) = UP (0)      J ($CA) = RIGHT (1)
;   SPACE ($A0) = DOWN (2) G ($C7) = LEFT (3)
; Fire keys:
;   ESC ($9B) = Fire in current direction (sets $36 flag)
;   A ($C1) / F ($C6) = 4-direction simultaneous fire (limited ammo)
; ============================================================================
""",
    "004AE0": """\
; ---------------------------------------------------------------------------
; ADD SCORE ($4AE0)
; Adds A to BCD score at $0C-$0D. Updates high score at $0E-$0F.
; ---------------------------------------------------------------------------
""",
    "004B65": """\
; ============================================================================
; PUNISHMENT ROUTINE ($4B65)
; ============================================================================
; Called when: hitting a heart OR missing an upside-down heart.
; Transforms ALL 4 aliens on the affected side to DIAMONDS (type 5).
; This is devastating - you need 5 more hits per alien to cycle back to TV!
; Input: $57D6 = direction (0=UP, 1=LEFT, 2=DOWN, 3=RIGHT)
; ============================================================================
""",
    "004C99": """\
; ---------------------------------------------------------------------------
; LEVEL COMPLETE ANIMATION ($4C99)
; The big TV sweeps around collecting aliens.
; CHEAT CODE CHECK at $4CEF: Shift-N ($9E) = +3 lives + reset difficulty
; ---------------------------------------------------------------------------
""",
    "004D73": """\
; ---------------------------------------------------------------------------
; LEVEL SETUP ($4D73)
; Initializes alien positions and states for the current level.
; ---------------------------------------------------------------------------
""",
    "004D87": """\
; ---------------------------------------------------------------------------
; UPDATE ALIEN POSITIONS ($4D87)
; Moves aliens each tick based on current difficulty timing.
; ---------------------------------------------------------------------------
""",
    "004F5B": """\
; ---------------------------------------------------------------------------
; CHECK SATELLITE HITS ($4F5B)
; Checks if laser beams hit satellites (bonus targets).
; Satellites require multiple hits to destroy. Points awarded per hit.
; ---------------------------------------------------------------------------
""",
    "0056E4": """\
; ---------------------------------------------------------------------------
; DIFFICULTY SYSTEM ($56E4)
; Decrements step counter $31. When it reaches 0 and $30 > 0,
; decreases $30 (making game harder) and reloads all timing tables.
; $30 ranges from $0B (easiest) to $00 (hardest).
; Called after hitting aliens and collecting hearts.
; ---------------------------------------------------------------------------
""",
    "0056F3": """\
; ---------------------------------------------------------------------------
; LOAD DIFFICULTY TABLES ($56F3)
; Uses $30 as index into 8 lookup tables at $576C-$57CB to set:
;   $2F = frame delay reload, $32 = alien fire rate,
;   $31 = steps until next difficulty increase, plus other timing values.
; Higher values = slower/easier, lower values = faster/harder.
; ---------------------------------------------------------------------------
""",
    "00457F": """\
; ---------------------------------------------------------------------------
; MOVE ALL LASERS ($457F)
; Moves all 4 laser beams (one per direction):
;   UP (dir 0):    Y -= 3 pixels
;   LEFT (dir 1):  X -= 3 pixels
;   DOWN (dir 2):  Y += 3 pixels
;   RIGHT (dir 3): X += 3 pixels
; ---------------------------------------------------------------------------
""",
    "004120": """\
; ---------------------------------------------------------------------------
; INIT HI-RES ($4120)
; Clears HGR page 1 ($2000-$3FFF), then enables graphics mode:
;   $C050 = TXTCLR (graphics), $C057 = HIRES, $C052 = MIXCLR (full screen)
; No page flipping - this game uses page 1 only.
; ---------------------------------------------------------------------------
""",
    "004A86": """\
; ---------------------------------------------------------------------------
; GAME OVER ($4A86)
; Checks high score, displays game over screen, then restarts.
; ---------------------------------------------------------------------------
""",
    "005227": """\
; ---------------------------------------------------------------------------
; SPAWN SATELLITE ($5227)
; Spawns a bonus satellite target for one direction.
; Satellites appear on levels 3+ ($3A <= 3).
; ---------------------------------------------------------------------------
""",
    "00025D": """\
; ============================================================================
; CUSTOM RWTS - READ SECTOR ($025D)
; ============================================================================
; Broderbund's custom disk read routine. Searches for sectors with
; the non-standard prologue D5 AA B5 (instead of standard D5 AA 96).
; This is the copy protection - standard disk utilities can't read these.
; Reads nibbles directly via $C08C,X (disk data latch).
; ============================================================================
""",
}

# ============================================================================
# INLINE ANNOTATIONS
# Added as comments to lines containing the given address prefix
# ============================================================================
INLINE_ANNOTATIONS = {
    "004CEF": "  ; <<< CHEAT CODE CHECK: Read keyboard during level animation",
    "004CF2": "  ; <<< Shift-N = $9E on Apple II/II+ keyboard (caret key)",
    "004CF9": "  ; <<< Reset difficulty to easiest ($0B)",
    "004CFD": "  ; <<< +3 extra lives!",
    "004D00": "  ; <<< Add to current lives",
    "004D02": "  ; <<< Store new lives total",
    "004E15": "  ; <<< ALIEN EVOLUTION: INC type (UFO->Eye1->Eye2->TV->Diamond->Bowtie->wrap)",
    "004E1B": "  ; <<< Type 7? Wrap back to 1 (UFO)",
    "005A04": "  ; <<< Frame timing: INC $2E, when wraps reload from $2F",
}

# ============================================================================
# DATA TABLE LABELS
# Replaces data region comments at specific addresses
# ============================================================================
DATA_TABLE_LABELS = {
    "00416C": "; --- HGR Line Address Table (low bytes) - 192 entries ---",
    "00422C": "; --- HGR Line Address Table (high bytes) - 192 entries ---",
    "0053B8": "; --- Alien Type Table: 16 entries (4 per direction) ---\n"
              "; Types: 0=empty, 1=UFO, 2=Eye1, 3=Eye2, 4=TV(GOAL!), 5=Diamond(PENALTY!), 6=Bowtie",
    "0053C8": "; --- Alien Type -> Sprite Index Lookup ---\n"
              "; Maps type 0-6 to sprite indices: $00,$74,$35,$5F,$66,$6D,$7B",
    "005D34": "; --- Base X Positions (4 directions) ---",
    "005D38": "; --- Base Y Positions (4 directions) ---",
    "005D48": "; --- Projectile X Low (4 projectiles) ---",
    "005D4C": "; --- Projectile X High (4 projectiles) ---",
    "005D50": "; --- Projectile Y (4 projectiles) ---",
    "005D54": "; --- Projectile State: 0=none, 2=exploding, 3=active ---",
    "005D58": "; --- Projectile Active Flag: 0=inactive, 1=active ---",
    "005D5C": "; --- Draw X Low (4 projectiles) ---",
    "005D60": "; --- Draw X High (4 projectiles) ---",
    "005D64": "; --- Draw Y (4 projectiles) ---",
    "005D68": "; --- Base X Spawn (4 directions) ---",
    "005D6C": "; --- Base X High Spawn (4 directions) ---",
    "005D70": "; --- Base Y Spawn (4 directions) ---",
    "005D7C": "; --- Sprite Pointer Table (low bytes) ---",
    "005E1D": "; --- Sprite Pointer Table (high bytes) ---",
    "005EBE": "; --- Sprite Width Table ---",
    "005F5F": "; --- Sprite Height Table ---",
    "00576C": "; --- DIFFICULTY LOOKUP TABLES (12 entries each, index 0=hardest, 11=easiest) ---\n"
              "; Table 1 ($576C): Frame delay -> $2F\n"
              "; Table 2 ($5778): -> $52F2 (redraw timing)\n"
              "; Table 3 ($5784): -> $55E0 (alien draw timing)\n"
              "; Table 4 ($5790): -> $32 (alien fire rate)\n"
              "; Table 5 ($579C): -> $57CC\n"
              "; Table 6 ($57A8): -> $57CF\n"
              "; Table 7 ($57B4): -> $57D2\n"
              "; Table 8 ($57C0): -> $31 (steps until difficulty increase)",
    "006070": "; --- SPRITE DATA: Directional Arrow Sprites ---\n"
              "; UP ($6070, 4 bytes), LEFT ($6074, 7 bytes),\n"
              "; DOWN ($607B, 4 bytes), RIGHT ($607F, 7 bytes)",
    "00607F": "; --- SPRITE DATA: Projectile/Bullet Sprite (diamond shape) ---",
    "006598": "; --- SPRITE DATA: Alien Sprites (pre-shifted, 7 copies each) ---\n"
              "; Type 2: Eye Alien color 1 ($65AA), Type 3: Eye Alien color 2 ($6859)\n"
              "; Type 4: TV sprite ($6898), Type 5: Diamond ($691F)\n"
              "; Type 6: Bowtie ($6A30), Type 1: UFO ($69AB)",
}

# ============================================================================
# ZERO PAGE EQUATES (inserted after the MEMORY MAP section)
# ============================================================================
ZP_EQUATES = """\
; ============================================================================
; ZERO PAGE VARIABLE MAP
; ============================================================================
;
;   $00-$01 : Source pointer (bootstrap) / General pointer
;   $02-$03 : Destination pointer / Column counter
;   $04     : Copy limit / Sprite height calc
;   $05     : Sprite height
;   $06-$07 : HGR line address pointer
;   $08     : Clipping top scanline row
;   $09     : Clipping bottom scanline row
;   $0A     : Clipping left column
;   $0B     : Clipping right column
;   $0C-$0D : Score (BCD, low-high)
;   $0E-$0F : High score (BCD, low-high)
;   $10     : Lives remaining
;   $11     : Current direction: 0=UP, 1=RIGHT, 2=DOWN, 3=LEFT
;   $12     : Temp index for direction loops
;   $19     : Y coordinate for drawing operations
;   $26     : Disk track number (RWTS)
;   $27     : Disk sector number (RWTS)
;   $2A     : Disk address field count (RWTS)
;   $2B     : Disk slot * 16 / paddle debounce state
;   $2C-$2D : Timer reload values
;   $2E     : Frame counter (counts up from $2F to $FF, then wraps)
;   $2F     : Frame delay reload (from difficulty table, higher = faster)
;   $30     : Difficulty index (0=hardest, 11=easiest)
;   $31     : Steps until next difficulty increase
;   $32     : Alien fire rate reload value
;   $34     : Game state flag
;   $35     : Satellite-related counter
;   $36     : Fire button flag (set by ESC key)
;   $3A     : Level counter (5=Level 1, 4=Level 2, ..., 0=Victory!)
;   $3C     : Temp storage
;   $3D     : Disk checksum / temp
;
; ============================================================================
"""

# ============================================================================
# ALIEN EVOLUTION REFERENCE (inserted near $4E15)
# ============================================================================
ALIEN_EVOLUTION_COMMENT = """\
; ---------------------------------------------------------------------------
; ALIEN EVOLUTION ("Genetic Drift")
; ---------------------------------------------------------------------------
; Aliens cycle through 6 forms when hit:
;   Type 1: UFO (flying saucer) - starting form
;   Type 2: Eye Alien (blue)
;   Type 3: Eye Alien (green)
;   Type 4: TV - THE GOAL! All 16 must be TVs to complete the level
;   Type 5: Diamond - PENALTY STATE (set by punishment routine)
;   Type 6: Bowtie
;   Type 7: Wraps back to Type 1 (UFO)
;
; Strategy: Hit aliens 3 times to reach TV (UFO->Eye1->Eye2->TV)
;           STOP shooting once they're TVs!
;           Hitting a TV cycles it to Diamond (need 5 more hits!)
; ---------------------------------------------------------------------------
"""


def annotate():
    with open(INPUT, "r", encoding="utf-8", errors="replace") as f:
        lines = f.readlines()

    output = []
    zp_inserted = False
    evolution_comment_inserted = False
    renames_applied = 0
    i = 0

    while i < len(lines):
        line = lines[i]
        stripped = line.rstrip("\n")

        # Extract address from start of line (6 hex digits)
        addr_match = re.match(r"^([0-9A-Fa-f]{6})\s", stripped)
        addr = addr_match.group(1).upper() if addr_match else None

        # --- Insert zero page equates after header ---
        if not zp_inserted and stripped.strip() == "; Emulation mode (6502)":
            output.append(ZP_EQUATES)
            zp_inserted = True

        # --- Insert section headers ---
        if addr and addr in SECTION_HEADERS:
            output.append(SECTION_HEADERS[addr])

        # --- Insert alien evolution comment before $4DE3 function ---
        if not evolution_comment_inserted:
            if "; FUNC $004DE3:" in stripped:
                output.append(ALIEN_EVOLUTION_COMMENT)
                evolution_comment_inserted = True

        # --- Rename FUNC comment addresses ---
        if "; FUNC $" in stripped:
            for hex_addr, name in LABEL_BY_ADDR.items():
                func_ref = f"${hex_addr}"
                if func_ref in stripped:
                    stripped = stripped.replace(func_ref, f"${hex_addr} ({name})")
                    break

        # --- Rename auto-generated labels in code (any prefix) ---
        old = stripped
        stripped = replace_labels(stripped)
        if stripped != old:
            renames_applied += 1

        # --- Add data table labels ---
        if addr:
            for table_addr, table_label in DATA_TABLE_LABELS.items():
                if addr == table_addr.upper():
                    if "HEX" in stripped or "; ---" in stripped:
                        output.append(table_label + "\n")

        # --- Add inline annotations ---
        if addr:
            for ann_addr, annotation in INLINE_ANNOTATIONS.items():
                if addr == ann_addr.upper():
                    stripped = stripped + annotation
                    break

        # --- Keyboard key annotations ---
        if addr and "cmp  #$" in stripped:
            key_annotations = {
                "9B": "ESC (fire)",
                "D9": "Y (direction UP)",
                "CA": "J (direction RIGHT)",
                "A0": "SPACE (direction DOWN)",
                "C7": "G (direction LEFT)",
                "C1": "A (4-dir fire)",
                "C6": "F (4-dir fire)",
                "8D": "RETURN",
                "9E": "Shift-N (CHEAT CODE!)",
            }
            for code, desc in key_annotations.items():
                if f"#${code}" in stripped.upper() and desc not in stripped:
                    if "; <<<" not in stripped:
                        stripped = stripped + f"  ; key: {desc}"
                    break

        # --- Score/BCD annotations ---
        if addr and "sed" in stripped.lower() and "SED" in line.upper():
            if "; Set decimal mode" not in stripped:
                stripped = stripped + "  ; Set decimal mode (BCD arithmetic)"

        output.append(stripped + "\n")
        i += 1

    # Write output
    with open(OUTPUT, "w", encoding="utf-8") as f:
        f.writelines(output)

    print(f"Annotated {len(lines)} lines -> {OUTPUT}")
    print(f"Label addresses known: {len(LABEL_BY_ADDR)}")
    print(f"Lines with renames: {renames_applied}")
    print(f"Section headers: {len(SECTION_HEADERS)}")
    print(f"Data table labels: {len(DATA_TABLE_LABELS)}")
    print(f"Inline annotations: {len(INLINE_ANNOTATIONS)}")


if __name__ == "__main__":
    annotate()

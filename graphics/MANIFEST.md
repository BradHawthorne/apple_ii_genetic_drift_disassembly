# Graphics Manifest

## Rendering Details

- **Format:** HGR pre-shifted sprites (7 shift copies per sprite)
- **Palette:** Green phosphor on black (Apple II monochrome HGR)
- **Scale:** 4x from original pixel size
- **Tool:** `misc/genetic_drift_fork/extract_sprites.py` (see [tools/README.md](../tools/README.md))
- **Source:** Pointer tables at $25A5/$2646/$26E7/$2788 in game binary

## Assets

| File | Description | Size | Notes |
|------|-------------|------|-------|
| sprite_00.png | Score digit "0" | 8x8 | Used in BCD score display |
| sprite_01.png | Score digit "1" | 8x8 | |
| sprite_02.png | Score digit "2" | 8x8 | |
| sprite_03.png | Score digit "3" | 8x8 | |
| sprite_04.png | Score digit "4" | 8x8 | |
| sprite_05.png | Score digit "5" | 8x8 | |
| sprite_06.png | Score digit "6" | 8x8 | |
| sprite_07.png | Score digit "7" | 8x8 | |
| sprite_08.png | Score digit "8" | 8x8 | |
| sprite_09.png | Score digit "9" | 8x8 | |
| sprite_10.png | Text "SCORE" | wide | Score label |
| sprite_11.png | Text "GENETIC" | wide | Title screen text |
| sprite_12.png | Text "DRIFT" | wide | Title screen text |
| sprite_13.png | Directional arrow (up) | small | UI indicator |
| sprite_14.png | Directional arrow (down) | small | UI indicator |
| sprite_15.png | Alien form: UFO | ~16x12 | Evolution stage 1 (starting form) |
| sprite_16.png | Alien form: Eye | ~16x12 | Evolution stage 2 |
| sprite_17.png | Alien form: TV | ~16x12 | Evolution stage 3 (TARGET -- get all aliens here) |
| sprite_18.png | Alien form: Diamond | ~16x12 | Evolution stage 4 (PENALTY -- overshoot past TV) |
| sprite_19.png | Alien form: Bowtie | ~16x12 | Evolution stage 5 |
| sprite_20.png | Alien form: Ghost | ~16x12 | Evolution stage 6 (cycles back to UFO) |
| sprite_21.png | Heart projectile (frame 1) | small | Player's weapon, animated |
| sprite_22.png | Heart projectile (frame 2) | small | Second animation frame |
| sprite_23.png | Heart projectile (frame 3) | small | Third animation frame |
| sprite_24.png | Heart projectile (frame 4) | small | Fourth animation frame |
| sprite_25.png | Satellite | ~12x8 | Bonus target, appears periodically |
| sprite_26.png | Player ship | ~16x12 | The player's ship at screen bottom |
| sprite_27.png | Explosion frame 1 | ~16x12 | When alien or player is hit |
| sprite_28.png | Explosion frame 2 | ~16x12 | Second frame |
| sprite_29.png | Explosion frame 3 | ~16x12 | Third frame |
| sprite_30.png | Explosion frame 4 | ~16x12 | Final frame |
| sprite_31.png | Lives indicator | small | Displayed in HUD |

## Notes

The game uses **pre-shifted sprites** -- each sprite has 7 copies, each shifted
one bit position to the right. The game selects the appropriate pre-shifted copy
based on the screen X coordinate modulo 7, avoiding the need for runtime bit
shifting. This is the standard high-performance Apple II sprite technique.

The alien evolution cycle is: UFO -> Eye -> TV -> Diamond -> Bowtie -> Ghost -> UFO.
Each hit from a heart projectile advances the alien one stage. The goal is to get
all 16 aliens to the TV stage simultaneously.

Sprite indices 15-20 correspond to the six alien evolution stages in order.

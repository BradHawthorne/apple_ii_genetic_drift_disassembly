# Genetic Drift -- Extraction Tools

## Sprite Extraction

Genetic Drift uses pre-shifted HGR sprites with pointer tables in the binary.
The sprites were extracted using `extract_sprites.py` from the Rosetta v2 toolchain.

### Command Used

```bash
python misc/genetic_drift_fork/extract_sprites.py \
    "archaeology/games/action/Genetic Drift (Broderbund 1981)/extracted/GENETIC DRIFT#064000" \
    --ptr-lo 0x25A5 --ptr-hi 0x2646 \
    --width-tbl 0x26E7 --height-tbl 0x2788 \
    --count 32 --base 0x37D7 --ascii \
    "archaeology/games/action/Genetic Drift (Broderbund 1981)/graphics/"
```

### Pointer Tables (file offsets, not memory addresses)

| Table | Offset | Count | Purpose |
|-------|--------|-------|---------|
| Sprite address low | $25A5 | 32 | Low bytes of sprite data pointers |
| Sprite address high | $2646 | 32 | High bytes of sprite data pointers |
| Width table | $26E7 | 32 | Byte width of each sprite (pixels/7) |
| Height table | $2788 | 32 | Height in scanlines |

### Sprite Format

Each sprite is stored as a pre-shifted bitmap for the Apple II HGR display.
There are 7 shift copies of each sprite (one for each bit position within
the HGR byte). The game selects the appropriate pre-shifted copy based on
the screen X coordinate modulo 7.

Byte layout per sprite: width * height bytes, row-major, left-to-right.
The high bit of each byte is the HGR palette select bit.

### Extracted Sprites

32 sprites total, including:
- Score digits 0-9
- Text sprites ("SCORE", "GENETIC", "DRIFT")
- Directional arrow sprites
- Alien evolution stages (multiple forms)
- Heart projectiles
- Satellite

Output: `../graphics/sprite_00.png` through `../graphics/sprite_31.png`

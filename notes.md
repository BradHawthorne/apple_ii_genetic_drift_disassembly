# Notes: Genetic Drift (Broderbund, 1981)

## Observations

- This was a collaborative reverse-engineering project between Scott Schram (the
  original author) and Claude Code. Schram had no surviving source code -- the
  original Apple II assembly was discarded decades ago. The annotated disassembly
  is the first reconstruction of the source.
- The self-relocating binary architecture is more complex than most Apple II games.
  The bootstrap copies zero page state from the binary to $0000-$07FF before jumping
  to the main code. This means the binary contains a snapshot of the entire low
  memory layout at load time.
- Broderbund's copy protection (custom RWTS at $025D) defeated cp2 entirely. The
  binary was extracted using a custom `extract_dos33.py` tool that reads raw sector
  data. The 4am/Passport preservation copy (.woz) was used as the authoritative source.
- The game fits in ~15KB of 6502 code, which is remarkably compact for its feature
  set (16 independently-animating aliens, sprite-based graphics, sound, scoring,
  difficulty progression, satellite bonus, cheat code).

## Disassembly Challenges

- The self-relocation means addresses in the binary don't match runtime addresses.
  The bootstrap copies $3800-$3FFF to $0000-$07FF, so zero-page references in the
  binary's first 2KB refer to addresses $0000-$07FF at runtime, not $3800-$3FFF.
- The pre-shifted sprite data (7 copies per sprite) consumes a significant portion
  of the binary and was initially misidentified as code by deasmiigs.
- The complete annotated disassembly (`genetic_drift_annotated.s`) was produced
  through iterative human-AI collaboration over multiple sessions.

## Open Questions (Resolved)

- **Satellite timing:** DECODED. Satellites spawn at level transitions when $3A < 4
  (levels 3-5). 4 satellites per spawn. Orbit path defined by 256-byte sine-like
  lookup tables at $5002 (Y) and $5102 (X). Movement speed controlled by difficulty
  table at $52F2. Hit points = 6 - 2*$3A (6/4/2 by level). Collision detection uses
  direction-specific zone boundaries. See `analysis/game_mechanics.md`.
- **Difficulty progression:** FULLY MAPPED. 12 difficulty levels (index $0B=easiest
  to $00=hardest). 8 lookup tables at $576C-$57CB control game speed, satellite speed,
  alien drawing, fire rate, projectile intervals. 328 total hits to reach max difficulty.
  See `analysis/game_mechanics.md`.
- **Cheat code (Shift-N):** Confirmed intentional. Adds 3 lives AND resets difficulty
  index back to $0B (easiest). This was the most generous cheat possible -- it both
  gives lives and makes the game easier.

## Open Questions (Remaining)

- Some of the sprite data at the end of the binary may contain unused or
  development-era sprites. The 32 extracted sprites may not be the complete set.
- The exact frame timing relationship between difficulty levels and real wall-clock
  time depends on the Apple II's CPU speed (~1.023 MHz). An emulator run would
  pin down actual gameplay feel at each difficulty level.

## Historical References

- Scott Schram was 21 when he wrote Genetic Drift in 1981.
- Published by Broderbund Software, known for Choplifter, Lode Runner, Prince of
  Persia, and the Print Shop.
- Schram later wrote about the experience in his article "My Career as a Game
  Designer" at schram.net.
- The game's biology metaphor (aliens "evolving" through mutation) was unusual
  for its era -- most action games had purely martial themes.

## Future Work (Status)

- [DONE] Decode the satellite appearance timing formula.
  -> Complete satellite system analysis including spawn trigger, orbit paths,
     movement speed, collision detection. See `analysis/game_mechanics.md`.
- [DONE] Map the complete difficulty progression curve from the lookup tables.
  -> 12 levels, 8 parameters each, 328 hits to max. Full table with formulas
     in `analysis/game_mechanics.md`.
- [BLOCKED] Verify all 32 sprite labels against actual in-game appearance (requires emulator).
- [BLOCKED] Compare the Broderbund RWTS to other Broderbund titles (requires those disk images).

## Analysis Artifacts

- `analysis/game_mechanics.md` -- Complete game mechanics documentation:
  satellite system, difficulty curve, level progression, cheat code analysis,
  frame timing, scoring breakdown

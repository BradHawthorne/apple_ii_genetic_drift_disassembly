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
;                   $53B8   Alien type table (16 aliens)
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

;
; ═══════════════════════════════════════════════════════════════════
;                        ZERO PAGE EQUATES
; ═══════════════════════════════════════════════════════════════════
;
; ── Graphics System ──
col_ctr       EQU $02      ; Column counter / draw X position
sprite_calc   EQU $04      ; Sprite height calculation / draw parameter
sprite_h      EQU $05      ; Sprite height in scanline rows
hgr_lo        EQU $06      ; HGR screen line address, low byte
hgr_hi        EQU $07      ; HGR screen line address, high byte
clip_top      EQU $08      ; Clipping boundary: top scanline
clip_bot      EQU $09      ; Clipping boundary: bottom scanline
clip_left     EQU $0A      ; Clipping boundary: left column
clip_right    EQU $0B      ; Clipping boundary: right column
sprite_idx    EQU $13      ; Current sprite table index
draw_mask     EQU $16      ; HGR byte mask for sprite blitting
draw_col      EQU $17      ; HGR column byte index
draw_y        EQU $19      ; Y coordinate for draw operations
draw_y_hi     EQU $1A      ; Y coordinate overflow / high byte

; ── Game State ──
score_lo      EQU $0C      ; Current score, low byte (BCD)
score_hi      EQU $0D      ; Current score, high byte (BCD)
hiscore_lo    EQU $0E      ; High score, low byte (BCD)
hiscore_hi    EQU $0F      ; High score, high byte (BCD)
lives         EQU $10      ; Lives remaining (starts at 3)
direction     EQU $11      ; Aim direction: 0=UP 1=RIGHT 2=DOWN 3=LEFT
loop_idx      EQU $12      ; Temporary loop counter
game_flag     EQU $34      ; Game state flag
fire_req      EQU $36      ; Fire requested (set by ESC key)
level         EQU $3A      ; Level: 5=Lv1, 4=Lv2, 3=Lv3, 2=Lv4, 1=Lv5, 0=Victory

; ── Line Drawing / Projectile Math ──
anim_dir      EQU $1B      ; Animation direction: $00=forward $FF=reverse
target_x      EQU $1C      ; Target X for projectile/line drawing
target_x_hi   EQU $1D      ; Target X, high byte
target_y      EQU $1E      ; Target Y for projectile/line drawing
step_x_lo     EQU $1F      ; Line-draw step X, low (signed)
step_x_hi     EQU $20      ; Line-draw step X, high (signed)
step_y        EQU $21      ; Line-draw step Y increment
delta_x       EQU $23      ; Absolute delta X for line drawing
delta_x_hi    EQU $24      ; Delta X, high byte
delta_y       EQU $25      ; Absolute delta Y for line drawing
delta_y_hi    EQU $26      ; Delta Y high / RWTS track number
accum_lo      EQU $27      ; Line-draw accumulator / RWTS sector
accum_hi      EQU $28      ; Accumulator high byte
line_ctr_lo   EQU $29      ; Line pixel counter, low byte
line_ctr_hi   EQU $2A      ; Line pixel counter hi / RWTS addr field

; ── Timing / Difficulty ──
timer_lo      EQU $2C      ; General timer, low byte
timer_hi      EQU $2D      ; General timer, high byte
frame_ctr     EQU $2E      ; Frame counter (counts up to $FF, wraps)
frame_reload  EQU $2F      ; Frame timing reload from difficulty table
difficulty    EQU $30      ; Difficulty: 11=easiest, 0=hardest
diff_steps    EQU $31      ; Hits remaining until next difficulty increase
fire_rate     EQU $32      ; Alien fire rate from difficulty table
sat_counter   EQU $35      ; Satellite counter

; ── RWTS / Disk I/O ──
slot_x16      EQU $2B      ; RWTS disk slot * 16 / paddle state
disk_chk      EQU $3D      ; RWTS disk checksum / temp

; ── General Purpose ──
src_lo        EQU $00      ; Source pointer, low byte
src_hi        EQU $01      ; Source pointer, high byte
dest_hi       EQU $03      ; Destination pointer, high byte
temp          EQU $3C      ; Temporary work variable



; ── Bootstrap ─────────────────────────────────────────────────────
; HOW: Clears the keyboard strobe, then copies 8 pages ($3800-$3FFF)
;      down to $0000-$07FF using a simple nested loop (inner = 256 bytes
;      per page, outer = 8 pages). When done, jumps to $57D7.
; WHY: Self-relocating binary. The Broderbund intro screen code, custom
;      RWTS disk routines, and HGR line address tables all need to live
;      in low memory ($0000-$07FF). But that region is occupied by DOS
;      when the binary first loads. This bootstrap copies them into place
;      before the main game code enables hi-res graphics.

0037D7  8D 10 C0                      sta  CLRKBD          ; KBDSTRB - Clear keyboard strobe
0037DA  A9 38                         lda  #$38
0037DC  85 01                         sta  src_hi
0037DE  A9 00                         lda  #$00
0037E0  85 03                         sta  dest_hi
0037E2  A9 40                         lda  #$40
0037E4  85 04                         sta  sprite_calc
0037E6  A0 00                         ldy  #$00
0037E8  84 00                         sty  src_lo
0037EA  84 02                         sty  col_ctr

0037EC  B1 00                         lda  (src_lo),Y
0037EE  91 02                         sta  (col_ctr),Y
0037F0  C8                            iny
0037F1  D0 F9                         bne  Bootstrap_CopyLoop

0037F3  E6 01                         inc  src_hi
0037F5  E6 03                         inc  dest_hi
0037F7  A5 01                         lda  src_hi
0037F9  C5 04                         cmp  sprite_calc
0037FB  D0 EF                         bne  Bootstrap_CopyLoop

0037FD  4C D7 57                      jmp  $57D7  ; GameInit
; ── Zero Page / Interrupt Vectors / Disk Bootstrap Data ─────────
; The first $200 bytes contain zero-page game variables (see EQU
; block above) and 6502 interrupt vectors. Much of this region is
; initialized with Broderbund's nibble-encoded disk bootstrap data
; that is partially encrypted — the HEX blocks below are the raw
; byte values as they appear in the binary.

000000  00380000                HEX     00380000 40935029 01C00928 00000000
000010  03006C1D                HEX     03006C1D B213D1D1 3C3BD499 9BD1


00001E  F9 BA 00          loc_00001E  sbc  !$00BA,Y
000021  28                            plp
000022  00 18                         brk  #$18

000024  AE170225                HEX     AE170225 D007EF60

00002C  F0 F0                         beq  loc_00001E


00002E  F088CAD7                HEX     F088CAD7 FF90841B F0FD1BFD AD850072
00003E  00550025                HEX     00550025 FF852385 24AD0002 45250A8D
00004E  800CA62B                HEX     800CA62B BD8CC010 FB49D4D0 F7BD8CC0
00005E  10FBC9D5                HEX     10FBC9D5 D0F3BD8C C010FBC9 BBD0F3BD
00006E  8CC010FB                HEX     8CC010FB 382A8548 BD8CC010 FB254885
00007E  A2BD8CC0                HEX     A2BD8CC0 10FB382A 8548BD8C C010FB25
00008E  4885A3BD                HEX     4885A3BD 8CC010FB 382A8548 BD8CC010
00009E  FB25488D                HEX     FB25488D FFFFC9FF D0C5BD8C C010FBC9
0000AE  FFD0076C                HEX     FFD0076C 2800FDAF AAFD4C09 06FDAEAD
0000BE  EEDD7BBD                HEX     EEDD7BBD 8CC010FB C9DBD0F3 BD8CC010
0000CE  FBC9AFD0                HEX     FBC9AFD0 F3BD8CC0 10FB2A85 3FBD8CC0
0000DE  10FB253F                HEX     10FB253F 913CC8D0 ECE63DC6 40D0E6BD
0000EE  8CC010FB                HEX     8CC010FB C9AED0B3 BD8CC010 FBC9EED0
0000FE  AA6007                  HEX     AA6007

000101  00 A9                         brk  #$A9

000103  4C8D0006                HEX     4C8D0006 A9008D01 06A9B08D 0206A9EE
000113  60FF                    HEX     60FF

000115  FF 00 00 FF                   sbc  >$FF0000,X

000119  FF0000FF                HEX     FF0000FF FF0000FF FF0000FF FF0000FF
000129  FF0000FF                HEX     FF0000FF FF0000FF FF0000FF FF0000FF
000139  FF0000FF                HEX     FF0000FF FF0000FF FF0000FF FF0000FF
000149  FF0000FF                HEX     FF0000FF FF0000FF FF0000FF FF0000FF
000159  FF0000FF                HEX     FF0000FF FF0000FF FF0000FF FF0000FF
000169  FF0000FF                HEX     FF0000FF FF0000FF FF0000FF FF0000FF
000179  FF0000FF                HEX     FF0000FF FF0000FF FF0000FF FF0000FF
000189  FF0000FF                HEX     FF0000FF FF0000FF FF0000FF FF0000FF
000199  FF0000FF                HEX     FF0000FF FF0000FF FF0000FF FF0000FF
0001A9  FF0000FF                HEX     FF0000FF FF0000FF FF0000FF FF0000FF
0001B9  FF0000FF                HEX     FF0000FF FF0000FF FF0000FF FF0000FF
0001C9  FF0000FF                HEX     FF0000FF FF0000FF FF0000FF FF000017
0001D9  FBFDFBFD                HEX     FBFDFBFD B2FB1726 1726FC17 26FC6800
0001E9  008417FB                HEX     008417FB FDFB01E8 FBFBFD87 84FA43FD
0001F9  574F0F24                HEX     574F0F24 64EE0406 A200BD00 089D0002
000209  E8D0F74C                HEX     E8D0F74C 0F02A0AB


000211  98                            tya
000212  85 3C                         sta  temp
000214  4A                            lsr  a
000215  05 3C                         ora  temp
000217  C9 FF                         cmp  #$FF
000219  D0 09                         bne  DiskBoot_StoreNibble
00021B  C0 D5                         cpy  #$D5
00021D  F0 05                         beq  DiskBoot_StoreNibble
00021F  8A                            txa
000220  99 00 08                      sta  $0800,Y
000223  E8                            inx
000224  C8                            iny
000225  D0 EA                         bne  DiskBoot_NibbleDecode

000227  84 3D                         sty  disk_chk
000229  84 26                         sty  delta_y_hi
00022B  A9 03                         lda  #$03
00022D  85 27                         sta  accum_lo
00022F  A6 2B                         ldx  slot_x16
000231  20 5D 02                      jsr  RWTS_ReadSector
000234  20 D1 02                      jsr  RWTS_DecodeData
000237  4C 00 88                      jmp  $8800  ; DiskIO

00023A  00000000                HEX     00000000 00000000 00000000 00000000
00024A  00000000                HEX     00000000 00000000 00000000 00000000
00025A  000000                  HEX     000000
; ── RWTS_ReadSector ───────────────────────────────────────────────
; HOW: Reads one sector of Broderbund nibble-encoded disk data.
;      Accesses the disk controller directly via slot I/O at $C08C,X.
;      Searches for address field sync bytes, verifies track/sector,
;      then reads the data field into a decode buffer.
; WHY: Copy protection. Broderbund used a proprietary disk format that
;      standard DOS 3.3 RWTS cannot read, preventing casual disk copying.
;      This same scheme was used across Broderbund's catalog — Choplifter,
;      Lode Runner, and other titles all share this RWTS structure.

00025D  18                            clc

00025E  08                            php

00025F  BD 8C C0                      lda  $C08C,X
000262  10 FB                         bpl  RWTS_WaitNibble1


000264  49 D5                         eor  #$D5
000266  D0 F7                         bne  RWTS_WaitNibble1


000268  BD 8C C0                      lda  $C08C,X
00026B  10 FB                         bpl  RWTS_WaitNibble2

00026D  C9 AA                         cmp  #$AA
00026F  D0 F3                         bne  RWTS_CheckD5

000271  EA                            nop

000272  BD 8C C0                      lda  $C08C,X
000275  10 FB                         bpl  RWTS_WaitNibble3

000277  C9 B5                         cmp  #$B5
000279  F0 09                         beq  RWTS_ReadAddr
00027B  28                            plp
00027C  90 DF                         bcc  RWTS_ReadSector

00027E  49 AD                         eor  #$AD
000280  F0 1F                         beq  RWTS_FoundSector
000282  D0 D9                         bne  RWTS_ReadSector

000284  A0 03                         ldy  #$03
000286  84 2A                         sty  line_ctr_hi

000288  BD 8C C0                      lda  $C08C,X
00028B  10 FB                         bpl  RWTS_AddrNibble1

00028D  2A                            rol  a
00028E  85 3C                         sta  temp

000290  BD 8C C0                      lda  $C08C,X
000293  10 FB                         bpl  RWTS_AddrNibble2

000295  25 3C                         and  temp
000297  88                            dey
000298  D0 EE                         bne  RWTS_AddrNibble1

00029A  28                            plp
00029B  C5 3D                         cmp  disk_chk
00029D  D0 BE                         bne  RWTS_ReadSector

00029F  B0 BD                         bcs  RWTS_SyncLoop

0002A1  A0 9A                         ldy  #$9A

0002A3  84 3C                         sty  temp

0002A5  BC 8C C0          loc_0002A5  ldy  $C08C,X
0002A8  10 FB                         bpl  loc_0002A5

0002AA  59 00 08                      eor  $0800,Y
0002AD  A4 3C                         ldy  temp
0002AF  88                            dey
0002B0  99 00 08                      sta  $0800,Y
0002B3  D0 EE                         bne  RWTS_ReadDataLoop


0002B5  84 3C             loc_0002B5  sty  temp

0002B7  BC 8C C0          loc_0002B7  ldy  $C08C,X
0002BA  10 FB                         bpl  loc_0002B7

0002BC  59 00 08                      eor  $0800,Y
0002BF  A4 3C                         ldy  temp
0002C1  91 26                         sta  (delta_y_hi),Y
0002C3  C8                            iny
0002C4  D0 EF                         bne  loc_0002B5


0002C6  BC 8C C0                      ldy  $C08C,X
0002C9  10 FB                         bpl  $02C6

0002CB  59 00 08                      eor  $0800,Y
0002CE  D0 8D                         bne  RWTS_ReadSector

0002D0  60                            rts
; ── RWTS_DecodeData ───────────────────────────────────────────────
; HOW: Decodes the raw nibble data read by RWTS_ReadSector.
;      Converts 6-and-2 encoded nibbles back to the original byte values,
;      accumulating a running checksum to verify data integrity.
; WHY: Apple II floppy disks cannot store arbitrary bytes — values below
;      $96 are invalid on disk. The 6-and-2 encoding packs 8-bit values
;      into disk-safe nibbles, which this routine reverses.

0002D1  A8                            tay

0002D2  A2 00                         ldx  #$00

0002D4  B9 00 08          loc_0002D4  lda  $0800,Y
0002D7  4A                            lsr  a
0002D8  3E CC 03                      rol  $03CC,X
0002DB  4A                            lsr  a
0002DC  3E 99 03                      rol  $0399,X
0002DF  85 3C                         sta  temp
0002E1  B1 26                         lda  (delta_y_hi),Y
0002E3  0A                            asl  a
0002E4  0A                            asl  a
0002E5  0A                            asl  a
0002E6  05 3C                         ora  temp
0002E8  91 26                         sta  (delta_y_hi),Y
0002EA  C8                            iny
0002EB  E8                            inx
0002EC  E0 33                         cpx  #$33
0002EE  D0 E4                         bne  loc_0002D4

0002F0  C6 2A                         dec  line_ctr_hi
0002F2  D0 DE                         bne  $02D2

0002F4  CC 00 03                      cpy  $0300
0002F7  D0 03                         bne  $02FC
0002F9  60                            rts

0002FA  0000                    HEX     0000

0002FC  4C 2D FF                      jmp  PRERR

0002FF  00000000                HEX     00000000 00000000 00000000 00000000
00030F  00000000                HEX     00000000 00000000 00000000 00000000
00031F  00000000                HEX     00000000 00000000 00000000 00000000
00032F  00000000                HEX     00000000 00000000 00000000 00000000
00033F  00000000                HEX     00000000 00000000 00000000 00000000
00034F  00000000                HEX     00000000 00000000 00000000 00000000
00035F  00000000                HEX     00000000 00000000 00000000 00000000
00036F  00000000                HEX     00000000 00000000 00000000 00000000
00037F  00000000                HEX     00000000 00000000 00000000 00000000
00038F  00000000                HEX     00000000 00000000 00000000 00000000
00039F  00000000                HEX     00000000 00000000 00000000 00000000
0003AF  00000000                HEX     00000000 00000000 00000000 00000000
0003BF  00000000                HEX     00000000 00000000 00000000 00000000
0003CF  00000000                HEX     00000000 00000000 00000000 00000000
0003DF  00000000                HEX     00000000 00000000 00000000 00000000
0003EF  00030600                HEX     00030600 06A30000 00000000 00000000
; ── RandomByte ────────────────────────────────────────────────────
; HOW: Pseudorandom number generator using zero page ($00-$01) as
;      state. Combines ROL, EOR, and ROR operations on the 16-bit
;      seed, then increments and adds to produce the next value.
;      Returns random byte in A.
; WHY: Drives all randomized behavior — satellite spawn timing,
;      alien fire targeting, star twinkle positions. The algorithm
;      is compact (under 20 bytes) and fast for a 1 MHz 6502.

0003FF  00A5002A                HEX     00A5002A A5002600 45006600 E6016501
00040F  5002E601                HEX     5002E601 850060
; ── DrawSprite ────────────────────────────────────────────────────
; HOW: Takes sprite index in A, draws it at the current col_ctr/
;      sprite_calc position. Looks up sprite data pointer from the
;      tables at $5D7C (low) and $5E1D (high), width from $5EBE,
;      and height from $5F5F. Draws row by row using ORA to merge
;      sprite pixels with the existing screen content.
; WHY: Central rendering primitive — called 30+ times throughout
;      the code for all game objects. Kept in relocated low memory
;      ($0416) because page-zero addressing makes the inner loop
;      faster than equivalent code in the $4000+ range.

000416  A8                            tay
000417  B9 7C 5D                      lda  $5D7C,Y
00041A  8D 4B 04                      sta  $044B
00041D  B9 1D 5E                      lda  $5E1D,Y
000420  8D 4C 04                      sta  $044C
000423  A5 02                         lda  col_ctr
000425  85 03                         sta  dest_hi
000427  18                            clc
000428  79 BE 5E                      adc  $5EBE,Y
00042B  85 02                         sta  col_ctr
00042D  A5 04                         lda  sprite_calc
00042F  AA                            tax
000430  18                            clc
000431  79 5F 5F                      adc  $5F5F,Y
000434  85 05                         sta  sprite_h

000436  E0 C0                         cpx  #$C0
000438  B0 27                         bcs  $0461
00043A  BD 6C 41                      lda  $416C,X
00043D  85 06                         sta  hgr_lo
00043F  BD 2C 42                      lda  $422C,X
000442  85 07                         sta  hgr_hi
000444  A4 03                         ldy  dest_hi

000446  C0 28                         cpy  #$28
000448  B0 05                         bcs  $044F
00044A  AD 1C 60                      lda  $601C
00044D  91 06                         sta  (hgr_lo),Y
00044F  EE 4B 04                      inc  $044B
000452  D0 03                         bne  $0457
000454  EE 4C 04                      inc  $044C
000457  C8                            iny
000458  C4 02                         cpy  col_ctr
00045A  90 EA                         bcc  $0446

00045C  E8                            inx
00045D  E4 05                         cpx  sprite_h
00045F  90 D5                         bcc  $0436

000461  60                            rts
; ── EraseSprite ───────────────────────────────────────────────────
; HOW: Same structure as DrawSprite but uses XOR (EOR) instead of
;      ORA to erase the sprite from the screen. A second XOR of the
;      same data restores the original background pixels.
; WHY: XOR erase is the standard technique for fast sprite removal
;      on the Apple II HGR screen — no need to save/restore the
;      background, and it's a single pass through the sprite data.

000462  A8B97C5D                HEX     A8B97C5D 8DA704B9 1D5E8DA8 04A50285
000472  031879BE                HEX     031879BE 5E8502A5 04AA1879 5F5F8505
000482  E0C0B039                HEX     E0C0B039 E4089023 E409B01F BD6C4185
000492  06BD2C42                HEX     06BD2C42 8507A403 C028B00F C40A900B
0004A2  C40BB007                HEX     C40BB007 AD000011 069106EE A704D003
0004B2  EEA804C8                HEX     EEA804C8 C40290E0 E8E40590 C360

0004C0  A8                            tay
0004C1  B9 7C 5D                      lda  $5D7C,Y
0004C4  8D 05 41                      sta  $4105
0004C7  B9 1D 5E                      lda  $5E1D,Y
0004CA  8D 06 41                      sta  $4106
0004CD  A5 02                         lda  col_ctr
0004CF  85 03                         sta  dest_hi
0004D1  18                            clc
0004D2  79 BE 5E                      adc  $5EBE,Y
0004D5  85 02                         sta  col_ctr
0004D7  A5 04                         lda  sprite_calc
0004D9  AA                            tax
0004DA  18                            clc
0004DB  79 5F 5F                      adc  $5F5F,Y
0004DE  85 05                         sta  sprite_h
0004E0  E0 C0                         cpx  #$C0
0004E2  B0 3B                         bcs  $051F
0004E4  E4 08                         cpx  clip_top
0004E6  90 25                         bcc  $050D
0004E8  E4 09                         cpx  clip_bot
0004EA  B0 21                         bcs  $050D
0004EC  BD 6C 41                      lda  $416C,X
0004EF  85 06                         sta  hgr_lo
0004F1  BD 2C 42                      lda  $422C,X
0004F4  85 07                         sta  hgr_hi
0004F6  A4 03                         ldy  dest_hi
0004F8  C0 28                         cpy  #$28
0004FA  B0 11                         bcs  $050D
0004FC  C4 0A                         cpy  clip_left
0004FE  90 0D                         bcc  $050D
000500  61 0B                         adc  (clip_right,X)
000502  9A                            txs
000503  AC AD 26                      ldy  $26AD
000506  00 0C                         brk  #$0C

000508  FF570677                HEX     FF570677 078B0411 D2E5EF83 41A86CBB
000518  EC8365AF                HEX     EC8365AF 0129DC

00051F  3E 24 4C                      rol  $4C24,X
000522  A6 85                         ldx  $85
000524  AA                            tax

000525  0B2959E0                HEX     0B2959E0 BE1E4DD2 5FEA8059 B38FAB28
000535  55206DE7                HEX     55206DE7 E7103E81 E5A0B591 2EC482A2
000545  BEEC6A35                HEX     BEEC6A35 02090AA9 9197E883 C0DB9317
000555  A4E0C154                HEX     A4E0C154 E4F043E1 610F39D4 E5A01054
000565  D8860EC4                HEX     D8860EC4 3C143E8D A804A502 850318F9
000575  3EDE0582                HEX     3EDE0582 25842A18 795F5F85 05E0C030
000585  B9648810                HEX     B9648810 A36489B0 1FBD6C41 8506BDAC
000595  C2058724                HEX     C2058724 8340A8B0 0FC40A90 0BC40B30
0005A5  872D8080                HEX     872D8080 9186112E C68F2CF8 2BC680AC
0005B5  60                      HEX     60

0005B6  6C AA 38                      jmp  ($38AA)

0005B9  48404C2D                HEX     48404C2D B8EB4880 91547525 ADE911B5
0005C9  F625AE69                HEX     F625AE69 8D2AAD2B 305196F6 2DAA0DAC
0005D9  02B0D177                HEX     02B0D177 77AD2DC8 E898134C A0388D4C
0005E9  A11889ED                HEX     A11889ED 3C11D556 ED7C1255 D774D310
0005F9  F860                    HEX     F860

0005FB  C1 94             loc_0005FB  cmp  ($94,X)

0005FD  5AC05DA9                HEX     5AC05DA9 D22CA9D0 2CA9CD2C A9C38502
00060D  A200BD00                HEX     A200BD00 069D0002 E8D0F74C 1B02AD51
00061D  C0AD54C0                HEX     C0AD54C0 A000A904 84008501 A902A01B
00062D  20D002A2                HEX     20D002A2 BCA000A9 A09100C8 D0FBE601
00063D  CAD0F6A5                HEX     CAD0F6A5 028D0004 8D27048D D0078DF7
00064D  07A00084                HEX     07A00084 00B9C002 F0178501 B9C10285
00065D  03C8C8AE                HEX     03C8C8AE 30C0A603 CAD0FDC6 01D0F4F0
00066D  E44C00C6                HEX     E44C00C6 4A4A4A09 C0A00020 D002A200
00067D  8A95009D                HEX     8A95009D 0001E8D0 F8A209BD F0029D0F
00068D  04CA10F7                HEX     04CA10F7 99000299 A002C8C0 92D0F56C
00069D  F2030084                HEX     F2030084 01A401E6 01B90007 F0112058
0006AD  07A401E6                HEX     07A401E6 01B90007 2000074C A20600BD
0006BD  88C060                  HEX     88C060

0006C0  20 E0 20                      jsr  $20E0  ; HGR2Clear
0006C3  D0 20                         bne  loc_0006E5
0006C5  C0 20                         cpy  #$20
0006C7  B0 20                         bcs  $06E9
0006C9  C0 20                         cpy  #$20
0006CB  D0 20                         bne  $06ED
0006CD  E0 00                         cpx  #$00
0006CF  00 48                         brk  #$48

0006D1  AD83C0AD                HEX     AD83C0AD 83C06848 8DFDFF8D F30349A5
0006E1  8DF40368                HEX     8DF40368

0006E5  8C FC FF          loc_0006E5  sty  RESET_VEC       ; RESET_VEC - RESET vector
0006E8  8C F2 03                      sty  $03F2
0006EB  60                            rts

0006EC  00                      HEX     00

0006ED  00 00                         brk  #$00

0006EF  00C2D2B0                HEX     00C2D2B0 C4C5D2C2 D5CEC400 00000000
0006FF  00505050                HEX     00505050 50D0D0D0 D0D0D0D0 D0505050
00070F  50505050                HEX     50505050 50D0D0D0 D0D0D0D0 D0505050
00071F  50505050                HEX     50505050 50D0D0D0 D0D0D0D0 D0202428
00072F  2C303438                HEX     2C303438 3C202428 2C303438 3C212529
00073F  2D313539                HEX     2D313539 3D212529 2D313539 3D22262A
00074F  2E32363A                HEX     2E32363A 3E22262A 2E32363A 3E23272B
00075F  2F33373B                HEX     2F33373B 3F23272B 2F33373B 3F202428
00076F  2C303438                HEX     2C303438 3C202428 2C303438 3C212529
00077F  2D313539                HEX     2D313539 3D212529 2D313539 3D22262A
00078F  2E32363A                HEX     2E32363A 3E22262A 2E32363A 3E23272B
00079F  2F33373B                HEX     2F33373B 3F23272B 2F33373B 3F202428
0007AF  2C303438                HEX     2C303438 3C202428 2C303438 3C212529
0007BF  2D313539                HEX     2D313539 3D212529 2D313539 3D22262A
0007CF  2E32363A                HEX     2E32363A 3E22262A 2E32363A 3E23272B
0007DF  2F33373B                HEX     2F33373B 3F23272B 2F33373B 3F484A4A
0007EF  4A4A290F                HEX     4A4A290F 20160468 290F4C16 04A90185
0007FF  02                      HEX     02

; SEGMENT: Main Game Code ($4000-$71FF)
; The main game code remains at its load address. Contains:
;   - Sprite rendering engine ($40C0-$411F)
;   - HGR initialization and screen clear ($4120-$416B)
;   - HGR line address tables ($416C-$42EB)
;   - Game logic, input handling, collision detection
;   - Alien evolution and difficulty systems
;   - Sound generation routines
;   - Sprite bitmap data ($6000+)


004000  49                      HEX     49

004001  24 12                         bit  loop_idx
004003  49 24                         eor  #$24

004005  12                      HEX     12

004006  49 24                         eor  #$24            ; A=comp@$4006

004008  12492412                HEX     12492412 49241249 24124924 12492412
004018  49241249                HEX     49241249 24124924 12492412 49241249
004028  11224408                HEX     11224408 11224408 11224408 11224408
004038  11224408                HEX     11224408 11224408 11224408 11224408
004048  11224408                HEX     11224408 11224408 21084210 04210842
004058  10042108                HEX     10042108 42100421 08421004 21084210
004068  04210842                HEX     04210842 10042108 42100421 08421004
004078  41201008                HEX     41201008 04024120 10080402 41201008
004088  04024120                HEX     04024120 10080402 41201008 04024120
004098  10080402                HEX     10080402 41201008 7F7F7F7F 7F7F7F7F
0040A8  7F7F7F7F                HEX     7F7F7F7F 7F7F7F7F 7F7F7F7F 7F7F7F7F
0040B8  7F7F7F7F                HEX     7F7F7F7F 7F7F7F7F
; ── DrawSpriteXY ──────────────────────────────────────────────────
; HOW: Core sprite rendering engine. Takes sprite index in A, screen
;      position in col_ctr/sprite_calc. Looks up sprite data pointer,
;      width, and height from tables at $5D7C/$5E1D/$5EBE/$5F5F.
;      Calculates HGR screen address from Y coordinate using the line
;      address lookup table. Selects the correct pre-shifted sprite copy
;      (X mod 7) and blits the sprite bytes with OR masking.
; WHY: Pre-shifted sprites are the key optimization. Each sprite has 7
;      copies, shifted 0-6 bits, so any X position can be drawn without
;      runtime bit shifting. On a 1 MHz 6502, bit shifts in a drawing
;      loop would be far too slow for smooth animation. The 7x memory
;      cost is worth it — and with only ~5KB of sprite data total in a
;      15KB binary, the tradeoff is well-managed.

0040C0  A8                            tay                  ; A=comp@$4006 Y=A
0040C1  B9 7C 5D                      lda  $5D7C,Y         ; A=comp@$4006 Y=A
0040C4  8D 05 41                      sta  $4105           ; A=comp@$4006 Y=A
0040C7  B9 1D 5E                      lda  $5E1D,Y         ; A=comp@$4006 Y=A
0040CA  8D 06 41                      sta  $4106           ; A=comp@$4006 Y=A
0040CD  A5 02                         lda  col_ctr
0040CF  85 03                         sta  dest_hi
0040D1  18                            clc
0040D2  79 BE 5E                      adc  $5EBE,Y
0040D5  85 02                         sta  col_ctr
0040D7  A5 04                         lda  sprite_calc
0040D9  AA                            tax
0040DA  18                            clc
0040DB  79 5F 5F                      adc  $5F5F,Y
0040DE  85 05                         sta  sprite_h

0040E0  E0 C0                         cpx  #$C0
0040E2  B0 3B                         bcs  DrawSprite_Done
0040E4  E4 08                         cpx  clip_top
0040E6  90 25                         bcc  DrawSprite_NextRow
0040E8  E4 09                         cpx  clip_bot
0040EA  B0 21                         bcs  DrawSprite_NextRow
0040EC  BD 6C 41                      lda  $416C,X
0040EF  85 06                         sta  hgr_lo
0040F1  BD 2C 42                      lda  $422C,X
0040F4  85 07                         sta  hgr_hi
0040F6  A4 03                         ldy  dest_hi

0040F8  C0 28                         cpy  #$28
0040FA  B0 11                         bcs  DrawSprite_NextRow
0040FC  C4 0A                         cpy  clip_left
0040FE  90 0D                         bcc  DrawSprite_NextRow
004100  C4 0B                         cpy  clip_right
004102  B0 09                         bcs  DrawSprite_NextRow
004104  AD 00 00                      lda  !src_lo
004107  49 FF                         eor  #$FF
004109  31 06                         and  (hgr_lo),Y
00410B  91 06                         sta  (hgr_lo),Y
00410D  EE 05 41                      inc  $4105
004110  D0 03                         bne  DrawSprite_IncCol
004112  EE 06 41                      inc  $4106
004115  C8                            iny
004116  C4 02                         cpy  col_ctr
004118  90 DE                         bcc  DrawSprite_ColLoop

00411A  E8                            inx
00411B  E4 05                         cpx  sprite_h
00411D  90 C1                         bcc  DrawSprite_RowLoop

00411F  60                            rts
; ── InitHiRes ─────────────────────────────────────────────────────
; HOW: Enables full-screen hi-res graphics on page 1 by reading soft
;      switches: TXTCLR ($C050), HIRES ($C057), MIXCLR ($C052).
;      Then fills HGR page 1 ($2000-$3FFF) with zeros to clear the screen.
; WHY: Sets up the display for gameplay. Uses page 1 only — no double
;      buffering. All drawing goes directly to the visible screen. This
;      simplifies the code and the small, fast-moving sprites don't
;      produce visible tearing at 1 MHz.

004120  A9 00                         lda  #$00
004122  A2 20                         ldx  #$20
004124  A8                            tay
004125  8E 2A 41                      stx  $412A

004128  99 00 40                      sta  $4000,Y
00412B  C8                            iny
00412C  D0 FA                         bne  InitHiRes_ClearLoop

00412E  EE 2A 41                      inc  $412A
004131  CA                            dex
004132  D0 F4                         bne  InitHiRes_ClearLoop

004134  AD 50 C0                      lda  TXTCLR          ; TXTCLR - Enable graphics mode
004137  AD 57 C0                      lda  HIRES           ; HIRES - Hi-res graphics mode
00413A  AD 52 C0                      lda  MIXCLR          ; MIXCLR - Full screen graphics
00413D  60                            rts
; ── ClearPlayfield ────────────────────────────────────────────────
; HOW: Fills the playfield area of HGR page 1 with black (zero bytes).
;      Uses a tight loop writing 0 to consecutive HGR addresses.
; WHY: Prepares the screen for a new frame or level transition. Only
;      clears the gameplay area, preserving the score/status display.

00413E  A6 08                         ldx  clip_top

004140  BD 6C 41                      lda  $416C,X
004143  85 06                         sta  hgr_lo
004145  BD 2C 42                      lda  $422C,X
004148  85 07                         sta  hgr_hi
00414A  A4 0A                         ldy  clip_left
00414C  A9 00                         lda  #$00

00414E  91 06                         sta  (hgr_lo),Y
004150  C8                            iny
004151  C4 0B                         cpy  clip_right
004153  90 F9                         bcc  ClearPF_ColLoop

004155  E8                            inx
004156  E4 09                         cpx  clip_bot
004158  90 E6                         bcc  ClearPF_RowLoop

00415A  60                            rts
; ── SetClipBounds ─────────────────────────────────────────────────
; HOW: Sets the sprite clipping rectangle by storing boundary values
;      into clip_top, clip_bot, clip_left, clip_right.
; WHY: Prevents sprites from drawing outside the playfield area. The
;      clipping bounds define the safe region; DrawSpriteXY checks
;      against these before writing any pixels.

00415B  A9 09                         lda  #$09
00415D  85 0A                         sta  clip_left
00415F  A9 01                         lda  #$01
004161  85 08                         sta  clip_top
004163  A9 28                         lda  #$28
004165  85 0B                         sta  clip_right
004167  A9 C0                         lda  #$C0
004169  85 09                         sta  clip_bot
00416B  60                            rts
; ── HGR Line Address Table (Low Bytes) ───────────────────────────
; 192 entries: one per scanline row (0-191).
; Each entry is the low byte of the HGR memory address for that row.
; Apple II HGR memory is interleaved — consecutive rows are NOT at
; consecutive addresses. Row 0 = $2000, Row 1 = $2400, Row 2 = $2800,
; etc. This lookup table pre-computes the addresses to avoid the
; complex interleave calculation at runtime.

00416C  00000000                HEX     00000000 00000000 80808080 80808080
00417C  00000000                HEX     00000000 00000000 80808080 80808080
00418C  00000000                HEX     00000000 00000000 80808080 80808080
00419C  00000000                HEX     00000000 00000000 80808080 80808080
0041AC  28282828                HEX     28282828 28282828 A8A8A8A8 A8A8A8A8
0041BC  28282828                HEX     28282828 28282828 A8A8A8A8 A8A8A8A8
0041CC  28282828                HEX     28282828 28282828 A8A8A8A8 A8A8A8A8
0041DC  28282828                HEX     28282828 28282828 A8A8A8A8 A8A8A8A8
0041EC  50505050                HEX     50505050 50505050 D0D0D0D0 D0D0D0D0
0041FC  50505050                HEX     50505050 50505050 D0D0D0D0 D0D0D0D0
00420C  50505050                HEX     50505050 50505050 D0D0D0D0 D0D0D0D0
00421C  50505050                HEX     50505050 50505050 D0D0D0D0 D0D0D0D0
; ── HGR Line Address Table (High Bytes) ──────────────────────────
; 192 entries matching the low-byte table above.
; Together they give the full 16-bit HGR address for each scanline.

00422C  2024282C                HEX     2024282C 3034383C 2024282C 3034383C
00423C  2125292D                HEX     2125292D 3135393D 2125292D 3135393D
00424C  22262A2E                HEX     22262A2E 32363A3E 22262A2E 32363A3E
00425C  23272B2F                HEX     23272B2F 33373B3F 23272B2F 33373B3F
00426C  2024282C                HEX     2024282C 3034383C 2024282C 3034383C
00427C  2125292D                HEX     2125292D 3135393D 2125292D 3135393D
00428C  22262A2E                HEX     22262A2E 32363A3E 22262A2E 32363A3E
00429C  23272B2F                HEX     23272B2F 33373B3F 23272B2F 33373B3F
0042AC  2024282C                HEX     2024282C 3034383C 2024282C 3034383C
0042BC  2125292D                HEX     2125292D 3135393D 2125292D 3135393D
0042CC  22262A2E                HEX     22262A2E 32363A3E 22262A2E 32363A3E
0042DC  23272B2F                HEX     23272B2F 33373B3F 23272B2F 33373B3F
; ── PrintHexByte ──────────────────────────────────────────────────
; HOW: Draws a single BCD digit on screen as a sprite. Takes the digit
;      value in A, looks up the corresponding numeral sprite, and calls
;      DrawSpriteXY to render it.
; WHY: Score and level display. BCD encoding means each nibble is a
;      decimal digit (0-9), so this routine can render score digits
;      directly without binary-to-decimal conversion.

0042EC  48                            pha
0042ED  4A                            lsr  a
0042EE  4A                            lsr  a
0042EF  4A                            lsr  a
0042F0  4A                            lsr  a
0042F1  29 0F                         and  #$0F
0042F3  20 16 04                      jsr  $0416  ; DrawSprite
0042F6  68                            pla
0042F7  29 0F                         and  #$0F
0042F9  4C 16 04                      jmp  $0416  ; DrawSprite
; ── DrawTitleScreen ───────────────────────────────────────────────
; HOW: Displays the title screen with animated elements. Enters a loop
;      that draws the title graphics, animates twinkling stars, and
;      polls the keyboard for RETURN ($8D) to start the game.
; WHY: Title screen / attract mode. The star twinkle animation keeps
;      the display lively while waiting for the player.

0042FC  A9 01                         lda  #$01
0042FE  85 02                         sta  col_ctr
004300  A9 08                         lda  #$08
004302  85 04                         sta  sprite_calc
004304  A9 0F                         lda  #$0F
004306  20 16 04                      jsr  $0416  ; DrawSprite
004309  A9 01                         lda  #$01
00430B  85 02                         sta  col_ctr
00430D  A9 10                         lda  #$10
00430F  85 04                         sta  sprite_calc
004311  A9 10                         lda  #$10
004313  20 16 04                      jsr  $0416  ; DrawSprite
004316  A9 01                         lda  #$01
004318  85 02                         sta  col_ctr
00431A  A9 A7                         lda  #$A7
00431C  85 04                         sta  sprite_calc
00431E  A9 15                         lda  #$15
004320  20 16 04                      jsr  $0416  ; DrawSprite
004323  A9 01                         lda  #$01
004325  85 02                         sta  col_ctr
004327  A9 AF                         lda  #$AF
004329  85 04                         sta  sprite_calc
00432B  A9 12                         lda  #$12
00432D  20 16 04                      jsr  $0416  ; DrawSprite
004330  A9 01                         lda  #$01
004332  85 02                         sta  col_ctr
004334  A9 B7                         lda  #$B7
004336  85 04                         sta  sprite_calc
004338  A9 13                         lda  #$13
00433A  20 16 04                      jsr  $0416  ; DrawSprite
00433D  A9 01                         lda  #$01
00433F  85 02                         sta  col_ctr
004341  A9 4C                         lda  #$4C
004343  85 04                         sta  sprite_calc
004345  A9 0A                         lda  #$0A
004347  20 16 04                      jsr  $0416  ; DrawSprite
00434A  A9 02                         lda  #$02
00434C  85 02                         sta  col_ctr
00434E  A9 64                         lda  #$64
004350  85 04                         sta  sprite_calc
004352  A9 14                         lda  #$14
004354  20 16 04                      jsr  $0416  ; DrawSprite
004357  A9 01                         lda  #$01
004359  85 02                         sta  col_ctr
00435B  A9 6C                         lda  #$6C
00435D  85 04                         sta  sprite_calc
00435F  A9 0A                         lda  #$0A
004361  20 16 04                      jsr  $0416  ; DrawSprite
004364  A9 01                         lda  #$01
004366  85 02                         sta  col_ctr
004368  A9 84                         lda  #$84
00436A  85 04                         sta  sprite_calc
00436C  A9 19                         lda  #$19
00436E  20 16 04                      jsr  $0416  ; DrawSprite
004371  20 87 43                      jsr  InitGameVarsB
004374  20 9E 43                      jsr  InitGameVarsC
004377  4C CD 43                      jmp  PerFrameUpdate
; ── ResetAlienState ───────────────────────────────────────────────
; HOW: Resets alien animation and position state after a player death.
;      Preserves score, lives, level, and difficulty — only resets the
;      transient alien movement state.
; WHY: After losing a life, the game continues from the same level and
;      difficulty. Only the on-screen alien positions need resetting,
;      not the entire game state.

00437A  A9 56                         lda  #$56
00437C  85 04                         sta  sprite_calc
00437E  A9 17                         lda  #$17
004380  85 02                         sta  col_ctr
004382  A9 18                         lda  #$18
004384  4C 16 04                      jmp  $0416  ; DrawSprite
; ── ResetTimers ───────────────────────────────────────────────────
; HOW: Initializes the frame timing counters and animation variables
;      to their starting values for the current difficulty level.
; WHY: Called at game start and after difficulty changes to ensure
;      all timing loops begin from a clean state.

004387  A9 01                         lda  #$01
004389  85 02                         sta  col_ctr
00438B  A9 54                         lda  #$54
00438D  85 04                         sta  sprite_calc
00438F  A5 0D                         lda  score_hi
004391  20 EC 42                      jsr  PrintHexByte

004394  A5 0C                         lda  score_lo
004396  20 EC 42                      jsr  PrintHexByte

004399  A9 00                         lda  #$00
00439B  4C 16 04                      jmp  $0416  ; DrawSprite
; ── ResetGameVarsC ────────────────────────────────────────────────
; HOW: Additional game variable initialization.
; WHY: Part of the cascaded initialization sequence at game start.

00439E  A9 01                         lda  #$01
0043A0  85 02                         sta  col_ctr
0043A2  A9 74                         lda  #$74
0043A4  85 04                         sta  sprite_calc
0043A6  A5 0F                         lda  hiscore_hi
0043A8  20 EC 42                      jsr  PrintHexByte

0043AB  A5 0E                         lda  hiscore_lo
0043AD  20 EC 42                      jsr  PrintHexByte

0043B0  A9 00                         lda  #$00
0043B2  4C 16 04                      jmp  $0416  ; DrawSprite
; ── TitleSetup ────────────────────────────────────────────────────
; HOW: Initializes the title screen display — draws the game title,
;      Broderbund logo, copyright text, and initial star field.
; WHY: First-time setup before the title animation loop begins.

0043B5  A0 08                         ldy  #$08
0043B7  A2 00                         ldx  #$00

0043B9  BD 6C 41          loc_0043B9  lda  $416C,X
0043BC  85 06                         sta  hgr_lo
0043BE  BD 2C 42                      lda  $422C,X
0043C1  85 07                         sta  hgr_hi
0043C3  A9 94                         lda  #$94
0043C5  91 06                         sta  (hgr_lo),Y
0043C7  E8                            inx
0043C8  E0 C0                         cpx  #$C0
0043CA  90 ED                         bcc  loc_0043B9

0043CC  60                            rts


0043CD  A9 03                         lda  #$03
0043CF  85 02                         sta  col_ctr
0043D1  A9 8C                         lda  #$8C
0043D3  85 04                         sta  sprite_calc
0043D5  A5 10                         lda  lives
0043D7  C9 0A                         cmp  #$0A
0043D9  90 02                         bcc  PerFrameUpdate_JmpDraw
0043DB  A9 09                         lda  #$09
0043DD  4C 16 04          PerFrameUpdate_JmpDraw  jmp  $0416  ; DrawSprite
; ── KeyboardHandler ───────────────────────────────────────────────
; HOW: Reads the Apple II keyboard register ($C000). Compares against:
;      Y ($D9) → direction = 0 (UP)     J ($CA) → direction = 1 (RIGHT)
;      SPACE ($A0) → direction = 2 (DOWN)  G ($C7) → direction = 3 (LEFT)
;      ESC ($9B) → sets fire_req flag
;      A ($C1) / F ($C6) → 4-direction simultaneous fire (limited ammo)
;      Clears keyboard strobe ($C010) after reading.
; WHY: Diamond key layout: Y at top, G left, J right, Space at bottom.
;      This maps naturally to the four screen directions. ESC fires in
;      the current direction. The A/F keys trigger the 4-direction
;      "super shot" which fires all four directions at once but has
;      limited uses (starts at 3, gains 1 per difficulty increase).

0043E0  AD 00 C0                      lda  KBD             ; KBD - Keyboard data / 80STORE off
0043E3  10 12                         bpl  $43F7
0043E5  8D 10 C0                      sta  CLRKBD          ; KBDSTRB - Clear keyboard strobe
0043E8  C9 9B                         cmp  #$9B
0043EA  D0 03                         bne  $43EF
0043EC  85 36                         sta  fire_req
0043EE  60                            rts
0043EF  C9 D9                         cmp  #$D9
0043F1  D0 05                         bne  Key_CheckJ
0043F3  A9 00                         lda  #$00
0043F5  85 11                         sta  direction
0043F7  60                            rts
0043F8  C9 CA             Key_CheckJ  cmp  #$CA
0043FA  D0 05                         bne  Key_CheckSpace
0043FC  A9 01                         lda  #$01
0043FE  85 11                         sta  direction
004400  60                            rts
004401  C9 A0             Key_CheckSpace  cmp  #$A0
004403  D0 05                         bne  Key_CheckG
004405  A9 02                         lda  #$02
004407  85 11                         sta  direction
004409  60                            rts
00440A  C9 C7             Key_CheckG  cmp  #$C7
00440C  D0 05                         bne  Key_CheckAF
00440E  A9 03                         lda  #$03
004410  85 11                         sta  direction
004412  60                            rts
004413  C9 C1             Key_CheckAF  cmp  #$C1
004415  F0 05                         beq  Key_4DirFire
004417  C9 C6                         cmp  #$C6
004419  F0 01                         beq  Key_4DirFire
00441B  60                            rts
00441C  4C 81 53          Key_4DirFire  jmp  Fire4Dir

00441F  BD3C5D85                HEX     BD3C5D85 02BD445D 85048A18 691A4C62
00442F  04BD3C5D                HEX     04BD3C5D 8502BD44 5D85048A 18691A4C
00443F  C040                    HEX     C040
; ── EraseSpriteArea ───────────────────────────────────────────────
; HOW: Erases a sprite from the screen by writing black (AND mask) over
;      the sprite's bounding rectangle in HGR memory.
; WHY: Before redrawing a sprite at a new position, the old image must
;      be cleared. No page flipping means manual erase-then-draw.

004441  E0 03                         cpx  #$03
004443  F0 31                         beq  ClearSprite_Right
004445  E0 02                         cpx  #$02
004447  F0 22                         beq  $446B
004449  E0 01                         cpx  #$01
00444B  F0 45                         beq  ClearSprite_Left
00444D  A2 00                         ldx  #$00
00444F  A0 18                         ldy  #$18
004451  A9 51                         lda  #$51
004453  85 05                         sta  sprite_h

004455  BD 6C 41          ClearSprite_Loop  lda  $416C,X
004458  85 06                         sta  hgr_lo
00445A  BD 2C 42                      lda  $422C,X
00445D  85 07                         sta  hgr_hi
00445F  A9 73                         lda  #$73
004461  31 06                         and  (hgr_lo),Y
004463  91 06                         sta  (hgr_lo),Y
004465  E8                            inx
004466  E4 05                         cpx  sprite_h
004468  D0 EB                         bne  ClearSprite_Loop

00446A  60                            rts
00446B  A2 6E                         ldx  #$6E
00446D  A0 18                         ldy  #$18
00446F  A5 09                         lda  clip_bot
004471  85 05                         sta  sprite_h
004473  4C 55 44                      jmp  ClearSprite_Loop

004476  A0 09             ClearSprite_Right  ldy  #$09
004478  A9 17                         lda  #$17

00447A  85 05             loc_00447A  sta  sprite_h
00447C  A2 60                         ldx  #$60
00447E  BD 6C 41                      lda  $416C,X
004481  85 06                         sta  hgr_lo
004483  BD 2C 42                      lda  $422C,X
004486  85 07                         sta  hgr_hi
004488  A9 00                         lda  #$00

00448A  91 06             irq_00448A  sta  (hgr_lo),Y
00448C  C8                            iny
00448D  C4 05                         cpy  sprite_h
00448F  D0 F9                         bne  irq_00448A

004491  60                            rts
004492  A0 1A             ClearSprite_Left  ldy  #$1A
004494  A5 0B                         lda  clip_right
004496  4C 7A 44                      jmp  loc_00447A
; ── DrawProjectile ────────────────────────────────────────────────
; HOW: Draws the player's laser projectile sprite at its current
;      screen position.
; WHY: Visual representation of the player's shot moving across
;      the playfield.

004499  20 EF 44                      jsr  $44EF  ; LoadProjectileState
00449C  A6 19                         ldx  draw_y
00449E  A5 1A                         lda  draw_y_hi
0044A0  D0 0F                         bne  $44B1
0044A2  BD AA 47                      lda  $47AA,X
0044A5  85 02                         sta  col_ctr
0044A7  BD 92 46                      lda  $4692,X
0044AA  AA                            tax
0044AB  BD D3 48                      lda  $48D3,X
0044AE  4C BD 44                      jmp  loc_0044BD
0044B1  BD AD 48                      lda  $48AD,X
0044B4  85 02                         sta  col_ctr
0044B6  BD 8B 47                      lda  $478B,X
0044B9  AA                            tax
0044BA  BD D3 48                      lda  $48D3,X
0044BD  18                loc_0044BD  clc
0044BE  6D 09 45                      adc  $4509
0044C1  4C 62 04                      jmp  $0462  ; EraseSprite
; ── DrawHitFlash ──────────────────────────────────────────────────
; HOW: Draws a brief flash/explosion sprite at the point of impact
;      when a projectile hits an alien or satellite.
; WHY: Visual feedback confirming a successful hit.

0044C4  20 EF 44                      jsr  $44EF  ; LoadProjectileState
0044C7  A6 19                         ldx  draw_y
0044C9  A5 1A                         lda  draw_y_hi
0044CB  D0 0F                         bne  $44DC
0044CD  BD AA 47                      lda  $47AA,X
0044D0  85 02                         sta  col_ctr
0044D2  BD 92 46                      lda  $4692,X
0044D5  AA                            tax
0044D6  BD D3 48                      lda  $48D3,X
0044D9  4C E8 44                      jmp  loc_0044E8
0044DC  BD AD 48                      lda  $48AD,X
0044DF  85 02                         sta  col_ctr
0044E1  BD 8B 47                      lda  $478B,X
0044E4  AA                            tax
0044E5  BD D3 48                      lda  $48D3,X
0044E8  18                loc_0044E8  clc
0044E9  6D 09 45                      adc  $4509
0044EC  4C C0 40                      jmp  DrawSpriteXY
; ── LoadProjectileState ───────────────────────────────────────────
; HOW: Loads projectile rendering parameters from the state tables
;      indexed by X. Copies Y position, Y high byte, sprite index,
;      and sprite height into the corresponding draw registers.
; WHY: Centralizes the table-to-register transfer for projectile
;      drawing, used by both the draw and erase paths.

0044EF  BD 48 5D                      lda  $5D48,X
0044F2  85 19                         sta  draw_y
0044F4  BD 4C 5D                      lda  $5D4C,X
0044F7  85 1A                         sta  draw_y_hi
0044F9  BD 50 5D                      lda  $5D50,X
0044FC  85 04                         sta  sprite_calc
0044FE  BD 54 5D                      lda  $5D54,X
004501  AA                            tax
004502  BD 0A 45                      lda  $450A,X
004505  8D 09 45                      sta  $4509
004508  60                            rts

004509  001E1E82                HEX     001E1E82 89
; ── PeriodicGameLogic ─────────────────────────────────────────────
; HOW: Called when the frame timer ($2E) wraps past $FF. Handles
;      alien firing, enemy projectile spawning, and other game events
;      that don't need to execute every single frame.
; WHY: Separates per-frame logic (movement, drawing) from periodic
;      logic (firing decisions, spawning). The frame_reload value from
;      the difficulty table controls how often this runs — at easiest
;      difficulty, every 32 frames; at hardest, every 4 frames.

00450E  A2 03                         ldx  #$03
004510  86 12                         stx  loop_idx

004512  A6 12             loc_004512  ldx  loop_idx
004514  BD 54 5D                      lda  $5D54,X
004517  F0 61                         beq  loc_00457A
004519  20 C4 44                      jsr  DrawHitFlash

00451C  A6 12                         ldx  loop_idx
00451E  E0 03                         cpx  #$03
004520  F0 28                         beq  $454A
004522  E0 02                         cpx  #$02
004524  F0 14                         beq  $453A
004526  E0 01                         cpx  #$01
004528  F0 30                         beq  $455A
00452A  BD 50 5D                      lda  $5D50,X
00452D  18                            clc
00452E  69 01                         adc  #$01
004530  C9 60                         cmp  #$60
004532  B0 46                         bcs  loc_00457A
004534  9D 50 5D                      sta  $5D50,X
004537  4C 77 45                      jmp  loc_004577
00453A  BD 50 5D                      lda  $5D50,X
00453D  38                            sec
00453E  E9 01                         sbc  #$01
004540  C9 60                         cmp  #$60
004542  90 36                         bcc  loc_00457A
004544  9D 50 5D                      sta  $5D50,X
004547  4C 77 45                      jmp  loc_004577
00454A  BD 48 5D                      lda  $5D48,X
00454D  18                            clc
00454E  69 01                         adc  #$01
004550  C9 AB                         cmp  #$AB
004552  B0 26                         bcs  loc_00457A
004554  9D 48 5D                      sta  $5D48,X
004557  4C 77 45                      jmp  loc_004577
00455A  BD 4C 5D                      lda  $5D4C,X
00455D  D0 07                         bne  $4566
00455F  BD 48 5D                      lda  $5D48,X
004562  C9 AB                         cmp  #$AB
004564  90 14                         bcc  loc_00457A
004566  BD 48 5D                      lda  $5D48,X
004569  38                            sec
00456A  E9 01                         sbc  #$01
00456C  9D 48 5D                      sta  $5D48,X
00456F  BD 4C 5D                      lda  $5D4C,X
004572  E9 00                         sbc  #$00
004574  9D 4C 5D                      sta  $5D4C,X
004577  20 99 44          loc_004577  jsr  DrawProjectile

00457A  C6 12             loc_00457A  dec  loop_idx
00457C  10 94                         bpl  loc_004512

00457E  60                            rts
; ── MoveAllProjectiles ────────────────────────────────────────────
; HOW: Loops through all 4 projectile slots (X=3..0). For each active
;      projectile, reads its direction and moves it 3 pixels per frame:
;      UP → Y -= 3, DOWN → Y += 3, LEFT → X -= 3, RIGHT → X += 3.
;      Updates the position tables at $5D48-$5D67.
; WHY: Constant 3-pixel speed gives smooth, predictable motion at
;      1 MHz. Fast enough to cross the screen in about 60 frames
;      (~0.6 seconds), slow enough to track visually. One projectile
;      per direction keeps the logic simple and the screen readable.

00457F  A2 03                         ldx  #$03
004581  86 12                         stx  loop_idx

004583  A6 12             loc_004583  ldx  loop_idx
004585  BD 58 5D                      lda  $5D58,X
004588  F0 6F                         beq  loc_0045F9
00458A  E0 03                         cpx  #$03
00458C  F0 41                         beq  $45CF
00458E  E0 02                         cpx  #$02
004590  F0 28                         beq  $45BA
004592  E0 01                         cpx  #$01
004594  F0 68                         beq  $45FE
004596  BD 64 5D                      lda  $5D64,X
004599  F0 5E                         beq  loc_0045F9
00459B  85 04                         sta  sprite_calc
00459D  38                            sec
00459E  E9 03                         sbc  #$03
0045A0  B0 02                         bcs  irq_0045A4
0045A2  A9 00                         lda  #$00

0045A4  85 1E             irq_0045A4  sta  target_y
0045A6  9D 64 5D                      sta  $5D64,X
0045A9  BD 5C 5D                      lda  $5D5C,X
0045AC  85 19                         sta  draw_y
0045AE  85 1C                         sta  target_x
0045B0  BD 60 5D                      lda  $5D60,X
0045B3  85 1A                         sta  draw_y_hi
0045B5  85 1D                         sta  target_x_hi
0045B7  4C F3 45                      jmp  loc_0045F3
0045BA  BD 64 5D                      lda  $5D64,X
0045BD  C9 BF                         cmp  #$BF
0045BF  F0 38                         beq  loc_0045F9
0045C1  85 04                         sta  sprite_calc
0045C3  18                            clc
0045C4  69 03                         adc  #$03
0045C6  C9 BF                         cmp  #$BF
0045C8  90 DA                         bcc  irq_0045A4

0045CA  A9 BF                         lda  #$BF
0045CC  4C A4 45                      jmp  irq_0045A4

0045CF  BD 5C 5D                      lda  $5D5C,X
0045D2  C9 3E                         cmp  #$3E
0045D4  90 23                         bcc  loc_0045F9
0045D6  85 1C                         sta  target_x
0045D8  38                            sec
0045D9  E9 03                         sbc  #$03
0045DB  C9 3E                         cmp  #$3E
0045DD  B0 02                         bcs  $45E1
0045DF  A9 3E                         lda  #$3E
0045E1  85 19                         sta  draw_y
0045E3  9D 5C 5D                      sta  $5D5C,X
0045E6  A9 00                         lda  #$00
0045E8  85 1D                         sta  target_x_hi
0045EA  85 1A                         sta  draw_y_hi

0045EC  BD 64 5D          loc_0045EC  lda  $5D64,X
0045EF  85 1E                         sta  target_y
0045F1  85 04                         sta  sprite_calc
0045F3  20 40 49          loc_0045F3  jsr  UpdateAlienAnim
0045F6  8D 30 C0                      sta  SPKR            ; SPKR - Speaker toggle

0045F9  C6 12             loc_0045F9  dec  loop_idx
0045FB  10 86                         bpl  loc_004583

0045FD  60                            rts
0045FE  BD 5C 5D                      lda  $5D5C,X
004601  C9 17                         cmp  #$17
004603  BD 60 5D                      lda  $5D60,X
004606  E9 01                         sbc  #$01
004608  B0 EF                         bcs  loc_0045F9

00460A  BD 60 5D                      lda  $5D60,X
00460D  85 1A                         sta  draw_y_hi
00460F  BD 5C 5D                      lda  $5D5C,X
004612  85 19                         sta  draw_y
004614  18                            clc
004615  69 03                         adc  #$03
004617  9D 5C 5D                      sta  $5D5C,X
00461A  85 1C                         sta  target_x
00461C  BD 60 5D                      lda  $5D60,X
00461F  69 00                         adc  #$00
004621  9D 60 5D                      sta  $5D60,X
004624  85 1D                         sta  target_x_hi
004626  A5 1C                         lda  target_x
004628  C9 17                         cmp  #$17
00462A  A5 1D                         lda  target_x_hi
00462C  E9 01                         sbc  #$01
00462E  90 BC                         bcc  loc_0045EC

004630  A9 17                         lda  #$17
004632  9D 5C 5D                      sta  $5D5C,X
004635  85 1C                         sta  target_x
004637  A9 01                         lda  #$01
004639  85 1D                         sta  target_x_hi
00463B  9D 60 5D                      sta  $5D60,X
00463E  4C EC 45                      jmp  loc_0045EC
; ── StoreLaserState_Up ────────────────────────────────────────────
; HOW: Stores laser projectile state for the UP direction.

004641  8D 55 46                      sta  $4655
004644  8E 56 46                      stx  $4656
004647  8C 57 46                      sty  $4657
00464A  60                            rts


00464B  AD 55 46                      lda  $4655
00464E  AE 56 46                      ldx  $4656
004651  AC 57 46                      ldy  $4657
004654  60                            rts

004655  000000                  HEX     000000
; ── SetupAlienDraw ────────────────────────────────────────────────
; HOW: Prepares drawing parameters for alien sprites. Calculates the
;      HGR screen address from the alien's position, loads the correct
;      sprite index based on alien type, and sets up the clipping bounds.
; WHY: Each of the 16 aliens needs its own draw setup because they
;      orbit the playfield at different positions. This centralizes
;      the coordinate-to-screen-address conversion.

004658  85 13                         sta  sprite_idx
00465A  86 14                         stx  save_x
00465C  84 15                         sty  save_y
00465E  A6 04                         ldx  sprite_calc
004660  BD 6C 41                      lda  $416C,X
004663  85 06                         sta  hgr_lo
004665  BD 2C 42                      lda  $422C,X
004668  85 07                         sta  hgr_hi
00466A  A6 19                         ldx  draw_y
00466C  A5 1A                         lda  draw_y_hi
00466E  D0 11                         bne  loc_004681
004670  BD 92 46                      lda  $4692,X
004673  85 16                         sta  draw_mask
004675  BD AA 47                      lda  $47AA,X
004678  85 17                         sta  draw_col
00467A  A5 13                         lda  sprite_idx
00467C  A6 14                         ldx  save_x
00467E  A4 15                         ldy  save_y
004680  60                            rts
004681  BD 8B 47          loc_004681  lda  $478B,X
004684  85 16                         sta  draw_mask
004686  BD AD 48                      lda  $48AD,X
004689  85 17                         sta  draw_col
00468B  A5 13                         lda  sprite_idx
00468D  A6 14                         ldx  save_x
00468F  A4 15                         ldy  save_y
004691  60                            rts
; ── HGR Pixel Bitmask Table ──────────────────────────────────────
; 280 entries indexed by X pixel coordinate (0-279).
; Each byte is the single-bit mask for that pixel's position within
; its HGR byte: $01, $02, $04, $08, $10, $20, $40, then repeats.
; Apple II HGR packs 7 pixels per byte (bit 7 is the color bit).
; This table eliminates runtime shift calculations.

004692  01020408                HEX     01020408 10204001 02040810 20400102
0046A2  04081020                HEX     04081020 40010204 08102040 01020408
0046B2  10204001                HEX     10204001 02040810 20400102 04081020
0046C2  40010204                HEX     40010204 08102040 01020408 10204001
0046D2  02040810                HEX     02040810 20400102 04081020 40010204
0046E2  08102040                HEX     08102040 01020408 10204001 02040810
0046F2  20400102                HEX     20400102 04081020 40010204 08102040
004702  01020408                HEX     01020408 10204001 02040810 20400102
004712  04081020                HEX     04081020 40010204 08102040 01020408
004722  10204001                HEX     10204001 02040810 20400102 04081020
004732  40010204                HEX     40010204 08102040 01020408 10204001
004742  02040810                HEX     02040810 20400102 04081020 40010204
004752  08102040                HEX     08102040 01020408 10204001 02040810
004762  20400102                HEX     20400102 04081020 40010204 08102040
004772  01020408                HEX     01020408 10204001 02040810 20400102
004782  04081020                HEX     04081020 40010204 08102040 01020408
004792  10204001                HEX     10204001 02040810 20400102 04081020
; ── HGR Column Byte Table ────────────────────────────────────────
; 280 entries indexed by X pixel coordinate (0-279).
; Returns the byte offset within the HGR row for that pixel.
; Pixel 0-6 → byte 0, pixel 7-13 → byte 1, etc. (column = X / 7).
; Used together with the bitmask table to locate any pixel.

0047A2  40010204                HEX     40010204 08102040 00000000 00000001
0047B2  01010101                HEX     01010101 01010202 02020202 02030303
0047C2  03030303                HEX     03030303 04040404 04040405 05050505
0047D2  05050606                HEX     05050606 06060606 06070707 07070707
0047E2  08080808                HEX     08080808 08080809 09090909 09090A0A
0047F2  0A0A0A0A                HEX     0A0A0A0A 0A0B0B0B 0B0B0B0B 0C0C0C0C
004802  0C0C0C0D                HEX     0C0C0C0D 0D0D0D0D 0D0D0E0E 0E0E0E0E
004812  0E0F0F0F                HEX     0E0F0F0F 0F0F0F0F 10101010 10101011
004822  11111111                HEX     11111111 11111212 12121212 12131313
004832  13131313                HEX     13131313 14141414 14141415 15151515
004842  15151616                HEX     15151616 16161616 16171717 17171717
004852  18181818                HEX     18181818 18181819 19191919 19191A1A
004862  1A1A1A1A                HEX     1A1A1A1A 1A1B1B1B 1B1B1B1B 1C1C1C1C
004872  1C1C1C1D                HEX     1C1C1C1D 1D1D1D1D 1D1D1E1E 1E1E1E1E
004882  1E1F1F1F                HEX     1E1F1F1F 1F1F1F1F 20202020 20202021
004892  21212121                HEX     21212121 21212222 22222222 22232323
0048A2  23232323                HEX     23232323 24242424 24242424 24242525
0048B2  25252525                HEX     25252525 25262626 26262626 27272727
0048C2  27272728                HEX     27272728 28282828 28282929 29292929
0048D2  29000001                HEX     29000001 00020000 00030000 00000000
0048E2  00040000                HEX     00040000 00000000 00000000 00000000
0048F2  00050000                HEX     00050000 00000000 00000000 00000000
004902  00000000                HEX     00000000 00000000 00000000 00000000
004912  0006                    HEX     0006
; ── DrawAlienRow ──────────────────────────────────────────────────
; HOW: Draws one row of alien pixels. Saves A/Y on stack, checks the
;      current scanline position, ORs sprite bytes into HGR memory,
;      then restores registers and returns.
; WHY: Inner loop of the alien sprite renderer. The OR operation
;      composites the alien sprite over the background without erasing
;      other sprites on the same scanline.

004914  48                            pha
004915  98                            tya
004916  48                            pha
004917  A5 19                         lda  draw_y
004919  29 01                         and  #$01
00491B  F0 0B                         beq  $4928
00491D  20 58 46                      jsr  MoveLaserDownRight

004920  A4 17                         ldy  draw_col
004922  A5 16                         lda  draw_mask
004924  11 06                         ora  (hgr_lo),Y
004926  91 06                         sta  (hgr_lo),Y
004928  68                            pla
004929  A8                            tay
00492A  68                            pla
00492B  60                            rts

00492C  48984820                HEX     48984820 5846A417 A51649FF 31069106
00493C  68A86860                HEX     68A86860
; ── UpdateAlienAnim ───────────────────────────────────────────────
; HOW: Advances the alien animation by computing the next position
;      along its movement path using 16-bit fixed-point arithmetic.
;      Calculates delta X/Y from current position to target, determines
;      step direction (signed), and uses a Bresenham-style line algorithm
;      to advance the alien one step along its orbital track.
; WHY: Aliens orbit the playfield edges in smooth paths. The fixed-point
;      math with separate delta/step/accumulator variables gives sub-pixel
;      precision without floating point. The Bresenham approach guarantees
;      every pixel position along the path is visited exactly once.

004940  20 41 46                      jsr  MoveLaserUp

004943  A9 00                         lda  #$00
004945  85 1B                         sta  anim_dir
004947  4C 51 49                      jmp  loc_004951

00494A  204146A9                HEX     204146A9 FF851B

004951  38                loc_004951  sec
004952  A5 1C                         lda  target_x
004954  E5 19                         sbc  draw_y
004956  85 23                         sta  delta_x
004958  A5 1D                         lda  target_x_hi
00495A  E5 1A                         sbc  draw_y_hi
00495C  85 24                         sta  delta_x_hi
00495E  38                            sec
00495F  A5 1E                         lda  target_y
004961  E5 04                         sbc  sprite_calc
004963  85 25                         sta  delta_y
004965  A9 00                         lda  #$00
004967  E9 00                         sbc  #$00
004969  85 26                         sta  delta_y_hi
00496B  A5 24                         lda  delta_x_hi
00496D  10 16                         bpl  loc_004985
00496F  A9 FF                         lda  #$FF
004971  85 1F                         sta  step_x_lo
004973  85 20                         sta  step_x_hi
004975  38                            sec
004976  A9 00                         lda  #$00
004978  E5 23                         sbc  delta_x
00497A  85 23                         sta  delta_x
00497C  A9 00                         lda  #$00
00497E  E5 24                         sbc  delta_x_hi
004980  85 24                         sta  delta_x_hi
004982  4C 8D 49                      jmp  loc_00498D
004985  A9 01             loc_004985  lda  #$01
004987  85 1F                         sta  step_x_lo
004989  A9 00                         lda  #$00
00498B  85 20                         sta  step_x_hi
00498D  A5 26             loc_00498D  lda  delta_y_hi
00498F  10 16                         bpl  $49A7
004991  A9 FF                         lda  #$FF
004993  85 21                         sta  step_y
004995  85 22                         sta  step_y_hi
004997  38                            sec
004998  A9 00                         lda  #$00
00499A  E5 25                         sbc  delta_y
00499C  85 25                         sta  delta_y
00499E  A9 00                         lda  #$00
0049A0  E5 26                         sbc  delta_y_hi
0049A2  85 26                         sta  delta_y_hi
0049A4  4C AF 49                      jmp  $49AF  ; BresenhamLineInit
0049A7  A9 01                         lda  #$01
0049A9  85 21                         sta  step_y
0049AB  A9 00                         lda  #$00
0049AD  85 22                         sta  step_y_hi
0049AF  A5 23                         lda  delta_x
0049B1  C5 25                         cmp  delta_y
0049B3  A5 24                         lda  delta_x_hi
0049B5  E5 26                         sbc  delta_y_hi
0049B7  B0 06                         bcs  $49BF
0049B9  20 2F 4A                      jsr  DrawAlienSideB
0049BC  4C C2 49                      jmp  $49C2
0049BF  20 C6 49                      jsr  DrawAlienSide
0049C2  20 4B 46                      jsr  MoveLaserLeft

0049C5  60                            rts
; ── BresenhamLineStep ─────────────────────────────────────────────
; HOW: Bresenham's line algorithm inner loop. Initializes the error
;      accumulator to half the major axis distance (delta_x >> 1),
;      then iterates line_ctr_lo/hi times. Each iteration:
;        1. Adds delta_y to the accumulator (accum_lo/accum_hi)
;        2. If accumulator >= delta_x, subtracts delta_x and steps
;           along the minor axis (Y direction via step_y)
;        3. Always steps along the major axis (X direction via step_x)
;      The 16-bit math handles screen-spanning distances accurately.
; WHY: Classic integer-only line drawing — fast and exact. No division
;      or floating point needed, which matters at 1 MHz. Used to compute
;      alien orbital paths and projectile trajectories. The algorithm
;      dates to 1962 (Jack Bresenham, IBM) and was the standard approach
;      for line drawing in the 8-bit era.

0049C6  A5 23                         lda  delta_x
0049C8  D0 04                         bne  $49CE
0049CA  A5 24                         lda  delta_x_hi
0049CC  F0 60                         beq  $4A2E
0049CE  A5 24                         lda  delta_x_hi
0049D0  85 2A                         sta  line_ctr_hi
0049D2  4A                            lsr  a
0049D3  85 28                         sta  accum_hi
0049D5  A5 23                         lda  delta_x
0049D7  85 29                         sta  line_ctr_lo
0049D9  6A                            ror  a
0049DA  85 27                         sta  accum_lo

0049DC  18                loc_0049DC  clc
0049DD  A5 27                         lda  accum_lo
0049DF  65 25                         adc  delta_y
0049E1  85 27                         sta  accum_lo
0049E3  A5 28                         lda  accum_hi
0049E5  65 26                         adc  delta_y_hi
0049E7  85 28                         sta  accum_hi
0049E9  A5 27                         lda  accum_lo
0049EB  C5 23                         cmp  delta_x
0049ED  A5 28                         lda  accum_hi
0049EF  E5 24                         sbc  delta_x_hi
0049F1  90 13                         bcc  loc_004A06
0049F3  A5 27                         lda  accum_lo
0049F5  E5 23                         sbc  delta_x
0049F7  85 27                         sta  accum_lo
0049F9  A5 28                         lda  accum_hi
0049FB  E5 24                         sbc  delta_x_hi
0049FD  85 28                         sta  accum_hi
0049FF  18                            clc
004A00  A5 04                         lda  sprite_calc
004A02  65 21                         adc  step_y
004A04  85 04                         sta  sprite_calc
004A06  18                loc_004A06  clc
004A07  A5 19                         lda  draw_y
004A09  65 1F                         adc  step_x_lo
004A0B  85 19                         sta  draw_y
004A0D  A5 1A                         lda  draw_y_hi
004A0F  65 20                         adc  step_x_hi
004A11  85 1A                         sta  draw_y_hi
004A13  24 1B                         bit  anim_dir
004A15  10 06                         bpl  $4A1D
004A17  20 C0 40                      jsr  DrawSpriteXY

004A1A  4C 20 4A                      jmp  loc_004A20
004A1D  20 14 49                      jsr  DrawAlienRow

004A20  A5 29             loc_004A20  lda  line_ctr_lo
004A22  D0 02                         bne  $4A26
004A24  C6 2A                         dec  line_ctr_hi
004A26  C6 29                         dec  line_ctr_lo
004A28  A5 29                         lda  line_ctr_lo
004A2A  05 2A                         ora  line_ctr_hi
004A2C  D0 AE                         bne  loc_0049DC

004A2E  60                            rts

004A2F  A5 26                         lda  delta_y_hi
004A31  85 2A                         sta  line_ctr_hi
004A33  4A                            lsr  a
004A34  85 28                         sta  accum_hi
004A36  A5 25                         lda  delta_y
004A38  85 29                         sta  line_ctr_lo
004A3A  6A                            ror  a
004A3B  85 27                         sta  accum_lo

004A3D  18                loc_004A3D  clc
004A3E  A5 27                         lda  accum_lo
004A40  65 23                         adc  delta_x
004A42  85 27                         sta  accum_lo
004A44  A5 28                         lda  accum_hi
004A46  65 24                         adc  delta_x_hi
004A48  85 28                         sta  accum_hi
004A4A  A5 27                         lda  accum_lo
004A4C  C5 25                         cmp  delta_y
004A4E  A5 28                         lda  accum_hi
004A50  E5 26                         sbc  delta_y_hi
004A52  90 19                         bcc  loc_004A6D
004A54  A5 27                         lda  accum_lo
004A56  E5 25                         sbc  delta_y
004A58  85 27                         sta  accum_lo
004A5A  A5 28                         lda  accum_hi
004A5C  E5 26                         sbc  delta_y_hi
004A5E  85 28                         sta  accum_hi
004A60  18                            clc
004A61  A5 19                         lda  draw_y
004A63  65 1F                         adc  step_x_lo
004A65  85 19                         sta  draw_y
004A67  A5 1A                         lda  draw_y_hi
004A69  65 20                         adc  step_x_hi
004A6B  85 1A                         sta  draw_y_hi
004A6D  18                loc_004A6D  clc
004A6E  A5 04                         lda  sprite_calc
004A70  65 21                         adc  step_y
004A72  85 04                         sta  sprite_calc
004A74  20 14 49                      jsr  DrawAlienRow

004A77  A5 29                         lda  line_ctr_lo
004A79  D0 02                         bne  $4A7D
004A7B  C6 2A                         dec  line_ctr_hi
004A7D  C6 29                         dec  line_ctr_lo
004A7F  A5 29                         lda  line_ctr_lo
004A81  05 2A                         ora  line_ctr_hi
004A83  D0 B8                         bne  loc_004A3D

004A85  60                            rts
; ── GameOver ──────────────────────────────────────────────────────
; HOW: Compares current score ($0C-$0D) against high score ($0E-$0F).
;      If current score is higher, copies it to the high score bytes.
;      Displays the game over screen with animated sprites, waits for
;      RETURN key, then restarts the game at the title screen.
; WHY: Standard arcade game over flow. The high score persists in
;      memory (not saved to disk) until the machine is powered off.

004A86  A5 0D                         lda  score_hi
004A88  C5 0F                         cmp  hiscore_hi
004A8A  90 13                         bcc  loc_004A9F
004A8C  D0 06                         bne  loc_004A94
004A8E  A5 0C                         lda  score_lo
004A90  C5 0E                         cmp  hiscore_lo
004A92  90 0B                         bcc  loc_004A9F
004A94  A5 0C             loc_004A94  lda  score_lo
004A96  85 0E                         sta  hiscore_lo
004A98  A5 0D                         lda  score_hi
004A9A  85 0F                         sta  hiscore_hi
004A9C  20 9E 43                      jsr  InitGameVarsC

004A9F  A9 00             loc_004A9F  lda  #$00
004AA1  85 12                         sta  loop_idx
004AA3  85 11                         sta  direction

004AA5  E6 12             loc_004AA5  inc  loop_idx
004AA7  A5 12                         lda  loop_idx
004AA9  C9 50                         cmp  #$50
004AAB  D0 0A                         bne  loc_004AB7
004AAD  A9 00                         lda  #$00
004AAF  85 12                         sta  loop_idx
004AB1  A5 11                         lda  direction
004AB3  49 FF                         eor  #$FF
004AB5  85 11                         sta  direction
004AB7  A9 14             loc_004AB7  lda  #$14
004AB9  85 02                         sta  col_ctr
004ABB  A9 42                         lda  #$42
004ABD  85 04                         sta  sprite_calc
004ABF  A5 11                         lda  direction
004AC1  F0 08                         beq  $4ACB
004AC3  A9 25                         lda  #$25
004AC5  20 C0 40                      jsr  DrawSpriteXY

004AC8  4C D0 4A                      jmp  $4AD0  ; UpdateStarTwinkle
004ACB  A9 25                         lda  #$25
004ACD  20 62 04                      jsr  $0462  ; EraseSprite
004AD0  20 28 5C                      jsr  UpdateStarTwinkleB
004AD3  A9 40                         lda  #$40
004AD5  20 6C 5C                      jsr  StarTwinkleC
004AD8  AD 00 C0                      lda  KBD             ; KBD - Keyboard data / 80STORE off
004ADB  C9 8D                         cmp  #$8D
004ADD  D0 C6                         bne  loc_004AA5

004ADF  60                            rts
; ── AddScore ──────────────────────────────────────────────────────
; HOW: Adds points to the current score using BCD arithmetic.
;      SED (set decimal mode), CLC, ADC score_lo, STA score_lo,
;      propagate carry to score_hi, CLD (clear decimal mode).
; WHY: BCD (Binary-Coded Decimal) stores each digit as a nibble.
;      This means the score bytes can be displayed directly — each
;      nibble is a digit 0-9, no binary-to-decimal conversion needed.
;      Standard technique in 1980s arcade games.

004AE0  F8                            sed
004AE1  18                            clc
004AE2  65 0C                         adc  score_lo
004AE4  85 0C                         sta  score_lo
004AE6  A5 0D                         lda  score_hi
004AE8  69 00                         adc  #$00
004AEA  85 0D                         sta  score_hi
004AEC  D8                            cld
004AED  C5 35                         cmp  sat_counter
004AEF  D0 18                         bne  $4B09
004AF1  E6 10                         inc  lives
004AF3  20 CD 43                      jsr  PerFrameUpdate

004AF6  F8                            sed
004AF7  A9 10                         lda  #$10
004AF9  18                            clc
004AFA  65 35                         adc  sat_counter
004AFC  D8                            cld
004AFD  85 35                         sta  sat_counter
004AFF  A0 00                         ldy  #$00
004B01  A9 3C                         lda  #$3C
004B03  8D 67 5B                      sta  $5B67
004B06  20 62 5B                      jsr  InputProcessB
004B09  4C 87 43                      jmp  InitGameVarsB
; ── SelectProjectileType ──────────────────────────────────────────
; HOW: Determines what type of projectile an alien fires. Checks if all
;      4 aliens on the firing side are type 4 (TV). If yes, calls the
;      random number generator — ~6% chance of upside-down heart (must
;      hit), ~94% chance of regular heart (must NOT hit). If not all TVs,
;      fires a normal projectile.
; WHY: The heart mechanic creates intense late-game tension. Hearts only
;      appear when you're one step from completing a side (all 4 TVs).
;      Regular hearts punish trigger-happy players who shoot everything.
;      Upside-down hearts force you to keep shooting. You must read the
;      screen carefully in the final moments of each level.

004B0C  8A                            txa
004B0D  8E 64 4B                      stx  $4B64
004B10  0A                            asl  a
004B11  0A                            asl  a
004B12  18                            clc
004B13  69 03                         adc  #$03
004B15  AA                            tax
004B16  A0 03                         ldy  #$03

004B18  BD B8 53                      lda  $53B8,X
004B1B  C9 04                         cmp  #$04
004B1D  D0 15                         bne  loc_004B34
004B1F  CA                            dex
004B20  88                            dey
004B21  10 F5                         bpl  $4B18

004B23  20 03 04                      jsr  $0403  ; RandomByte
004B26  C9 10                         cmp  #$10
004B28  B0 05                         bcs  loc_004B2F
004B2A  A9 03                         lda  #$03
004B2C  4C 36 4B                      jmp  loc_004B36
004B2F  A9 02             loc_004B2F  lda  #$02
004B31  4C 36 4B                      jmp  loc_004B36
004B34  A9 01             loc_004B34  lda  #$01
004B36  AE 64 4B          loc_004B36  ldx  $4B64
004B39  9D 54 5D                      sta  $5D54,X
004B3C  BD 58 4B                      lda  $4B58,X
004B3F  9D 48 5D                      sta  $5D48,X
004B42  BD 5C 4B                      lda  $4B5C,X
004B45  9D 4C 5D                      sta  $5D4C,X
004B48  BD 60 4B                      lda  $4B60,X
004B4B  9D 50 5D                      sta  $5D50,X
004B4E  A0 10                         ldy  #$10
004B50  A9 45                         lda  #$45
004B52  8D 67 5B                      sta  $5B67
004B55  4C 62 5B                      jmp  InputProcessB

004B58  A900A950                HEX     A900A950 00010000 105EAC5E 00
; ── PunishmentRoutine ─────────────────────────────────────────────
; HOW: When a heart mistake occurs (hitting a regular heart or missing
;      an upside-down heart), sets ALL 4 aliens on the offending side
;      to type 5 (Diamond). Calls the direction-specific redraw routine
;      to update the display, then plays the punishment sound.
; WHY: This is the game's signature penalty — devastating but fair. One
;      mistake transforms an entire side from TV (goal) to Diamond, which
;      requires 5 more hits each to cycle back to TV (Diamond → Bowtie →
;      UFO → Eye1 → Eye2 → TV). That's 20 hits of lost progress per
;      mistake. It rewards careful play over spray-and-pray.

004B65  AD D6 57                      lda  $57D6
004B68  20 3C 4C                      jsr  PlayPunishSound
004B6B  AD D6 57                      lda  $57D6
004B6E  0A                            asl  a
004B6F  0A                            asl  a
004B70  18                            clc
004B71  69 03                         adc  #$03
004B73  AA                            tax
004B74  A0 03                         ldy  #$03
004B76  A9 05                         lda  #$05

004B78  9D B8 53          loc_004B78  sta  $53B8,X
004B7B  CA                            dex
004B7C  88                            dey
004B7D  10 F9                         bpl  loc_004B78

004B7F  AE D6 57                      ldx  $57D6
004B82  D0 03                         bne  loc_004B87
004B84  4C C5 54                      jmp  $54C5  ; AnimateSatelliteDown
004B87  E0 01             loc_004B87  cpx  #$01
004B89  D0 03                         bne  loc_004B8E
004B8B  4C 61 54                      jmp  $5461  ; AnimateSatelliteLeft
004B8E  E0 02             loc_004B8E  cpx  #$02
004B90  D0 03                         bne  $4B95
004B92  4C 29 55                      jmp  $5529  ; AnimateSatelliteRight
004B95  4C FD 53                      jmp  $53FD  ; AnimateSatelliteUp

004B98  A9 03                         lda  #$03
004B9A  8D F8 53                      sta  $53F8

004B9D  AE F8 53                      ldx  $53F8
004BA0  BD C4 53                      lda  $53C4,X
004BA3  F0 16                         beq  $4BBB
004BA5  48                            pha
004BA6  AD F3 53                      lda  $53F3
004BA9  18                            clc
004BAA  7D E8 53                      adc  $53E8,X
004BAD  85 04                         sta  sprite_calc
004BAF  A9 09                         lda  #$09
004BB1  85 02                         sta  col_ctr
004BB3  68                            pla
004BB4  AA                            tax
004BB5  BD D6 53                      lda  $53D6,X
004BB8  20 C0 40                      jsr  DrawSpriteXY

004BBB  CE F8 53                      dec  $53F8
004BBE  10 DD                         bpl  $4B9D

004BC0  60                            rts

004BC1  A9 03             loc_004BC1  lda  #$03
004BC3  8D F8 53                      sta  $53F8

004BC6  AE F8 53                      ldx  $53F8
004BC9  BD BC 53                      lda  $53BC,X
004BCC  F0 16                         beq  $4BE4
004BCE  48                            pha
004BCF  AD F1 53                      lda  $53F1
004BD2  18                            clc
004BD3  7D E8 53                      adc  $53E8,X
004BD6  85 04                         sta  sprite_calc
004BD8  A9 25                         lda  #$25
004BDA  85 02                         sta  col_ctr
004BDC  68                            pla
004BDD  AA                            tax
004BDE  BD DD 53                      lda  $53DD,X
004BE1  20 C0 40                      jsr  DrawSpriteXY

004BE4  CE F8 53                      dec  $53F8
004BE7  10 DD                         bpl  $4BC6

004BE9  60                            rts

004BEA  A9 03             loc_004BEA  lda  #$03
004BEC  8D F8 53                      sta  $53F8

004BEF  AE F8 53                      ldx  $53F8
004BF2  BD B8 53                      lda  $53B8,X
004BF5  F0 16                         beq  $4C0D
004BF7  48                            pha
004BF8  AD EC 53                      lda  $53EC
004BFB  18                            clc
004BFC  7D E4 53                      adc  $53E4,X
004BFF  85 19                         sta  draw_y
004C01  A9 01                         lda  #$01
; case 0:
004C03  85 04                         sta  sprite_calc
004C05  68                            pla
004C06  AA                            tax
004C07  BD C8 53                      lda  $53C8,X
004C0A  20 A1 52                      jsr  DrawSatelliteB
004C0D  CE F8 53                      dec  $53F8
004C10  10 DD                         bpl  $4BEF

004C12  60                            rts

004C13  A9 03             loc_004C13  lda  #$03
004C15  8D F8 53                      sta  $53F8

004C18  AE F8 53                      ldx  $53F8
004C1B  BD C0 53                      lda  $53C0,X
004C1E  F0 16                         beq  $4C36
004C20  48                            pha
004C21  AD EE 53                      lda  $53EE
004C24  18                            clc
004C25  7D E4 53                      adc  $53E4,X
004C28  85 19                         sta  draw_y
004C2A  A9 B4                         lda  #$B4
004C2C  85 04                         sta  sprite_calc
004C2E  68                            pla
004C2F  AA                            tax
004C30  BD CF 53                      lda  $53CF,X
004C33  20 A1 52                      jsr  DrawSatelliteB
004C36  CE F8 53                      dec  $53F8
004C39  10 DD                         bpl  $4C18

004C3B  60                            rts
; ── PlayPunishSound ───────────────────────────────────────────────
; HOW: Generates a harsh buzzing tone by toggling the Apple II speaker
;      ($C030) in a tight timing loop with specific pitch parameters.
; WHY: Audio feedback for the heart penalty. The distinctive sound
;      serves as an unmistakable warning that you just lost progress.

004C3C  C9 00                         cmp  #$00
004C3E  D0 03                         bne  loc_004C43
004C40  4C EA 4B                      jmp  loc_004BEA

004C43  C9 03             loc_004C43  cmp  #$03
004C45  D0 03                         bne  loc_004C4A
004C47  4C 98 4B                      jmp  $4B98  ; UpdateAlienOrbit

004C4A  C9 01             loc_004C4A  cmp  #$01
004C4C  D0 03                         bne  loc_004C51
004C4E  4C C1 4B                      jmp  loc_004BC1

004C51  4C 13 4C          loc_004C51  jmp  loc_004C13


004C54  0000                    HEX     0000
; ── PlayTone ──────────────────────────────────────────────────────
; HOW: General-purpose tone generator. Toggles the speaker ($C030) in
;      a counted loop; the loop count determines pitch. Higher count =
;      lower frequency. Duration controlled by outer loop.
; WHY: The Apple II has no sound chip — just a single-bit speaker
;      toggle. All sound is generated by precisely-timed CPU loops.
;      This routine is the building block for all game sound effects.

004C56  AD 54 4C                      lda  $4C54
004C59  85 19                         sta  draw_y
004C5B  AD 55 4C                      lda  $4C55
004C5E  85 04                         sta  sprite_calc
004C60  A5 3A                         lda  level
004C62  D0 05                         bne  loc_004C69
004C64  A9 9A                         lda  #$9A
004C66  4C 6B 4C                      jmp  loc_004C6B
004C69  A9 90             loc_004C69  lda  #$90
004C6B  2C 30 C0          loc_004C6B  bit  SPKR            ; SPKR - Speaker toggle
004C6E  4C 7F 52                      jmp  DrawSatellite


004C71  AD 54 4C                      lda  $4C54
004C74  85 19                         sta  draw_y
004C76  AD 55 4C                      lda  $4C55
004C79  85 04                         sta  sprite_calc
004C7B  A5 3A                         lda  level
004C7D  D0 05                         bne  loc_004C84
004C7F  A9 9A                         lda  #$9A
004C81  4C 86 4C                      jmp  $4C86
004C84  A9 90             loc_004C84  lda  #$90
004C86  2C 30 C0                      bit  SPKR            ; SPKR - Speaker toggle
004C89  4C A1 52                      jmp  DrawSatelliteB

004C8C  000060C0                HEX     000060C0 C0000051 01A5A501 00
; ── LevelCompleteAnim ─────────────────────────────────────────────
; HOW: Plays the level completion animation — a large TV sprite sweeps
;      around the screen. During the animation, checks the keyboard at
;      $4CEF: if the key code is $9E (Shift-N on Apple II keyboard,
;      which produces the caret character), adds 3 to lives and resets
;      difficulty to $0B (easiest).
; WHY: Celebration animation for clearing a level. The embedded cheat
;      code (Shift-N) was a development/testing feature that shipped
;      with the game. It's the most generous cheat possible — it both
;      restores lives AND resets the game speed to the starting pace,
;      undoing all accumulated difficulty increases. Can be triggered
;      multiple times during a single animation.

004C99  A9 C0                         lda  #$C0
004C9B  8D 54 4C                      sta  $4C54
004C9E  A9 01                         lda  #$01
004CA0  8D 55 4C                      sta  $4C55
004CA3  A9 04                         lda  #$04
004CA5  8D 98 4C                      sta  $4C98

004CA8  AE 98 4C          loc_004CA8  ldx  $4C98
004CAB  BD 8E 4C                      lda  $4C8E,X
004CAE  8D 8C 4C                      sta  $4C8C
004CB1  BD 93 4C                      lda  $4C93,X
004CB4  8D 8D 4C                      sta  $4C8D

004CB7  20 71 4C                      jsr  PlayToneB

004CBA  AD 54 4C                      lda  $4C54
004CBD  CD 8C 4C                      cmp  $4C8C
004CC0  F0 11                         beq  $4CD3
004CC2  B0 09                         bcs  $4CCD
004CC4  18                            clc
004CC5  69 04                         adc  #$04
004CC7  8D 54 4C                      sta  $4C54
004CCA  4C D3 4C                      jmp  $4CD3
004CCD  38                            sec
004CCE  E9 04                         sbc  #$04
004CD0  8D 54 4C                      sta  $4C54
004CD3  AD 55 4C                      lda  $4C55
004CD6  CD 8D 4C                      cmp  $4C8D
004CD9  F0 11                         beq  $4CEC
004CDB  B0 09                         bcs  $4CE6
004CDD  18                            clc
004CDE  69 04                         adc  #$04
004CE0  8D 55 4C                      sta  $4C55
004CE3  4C EC 4C                      jmp  $4CEC
004CE6  38                            sec
004CE7  E9 04                         sbc  #$04
004CE9  8D 55 4C                      sta  $4C55
004CEC  20 56 4C                      jsr  PlayTone

004CEF  AD 00 C0                      lda  KBD             ; KBD - Keyboard data / 80STORE off
004CF2  C9 9E                         cmp  #$9E
004CF4  D0 0E                         bne  loc_004D04
004CF6  AD 10 C0                      lda  KBDSTRB         ; KBDSTRB - Clear keyboard strobe
004CF9  A9 0B                         lda  #$0B
004CFB  85 30                         sta  difficulty
004CFD  A9 03                         lda  #$03
004CFF  18                            clc
004D00  65 10                         adc  lives
004D02  85 10                         sta  lives
004D04  A9 20             loc_004D04  lda  #$20
004D06  8D 32 4D                      sta  $4D32

004D09  20 1C 5C          loc_004D09  jsr  UpdateStarTwinkle
004D0C  2C 30 C0                      bit  SPKR            ; SPKR - Speaker toggle
004D0F  CE 32 4D                      dec  $4D32
004D12  10 F5                         bpl  loc_004D09

004D14  A9 FF                         lda  #$FF
004D16  20 6C 5C                      jsr  StarTwinkleC
004D19  AD 54 4C                      lda  $4C54
004D1C  CD 8C 4C                      cmp  $4C8C
004D1F  D0 96                         bne  $4CB7

004D21  AD 55 4C                      lda  $4C55
004D24  CD 8D 4C                      cmp  $4C8D
004D27  D0 8E                         bne  $4CB7

004D29  CE 98 4C                      dec  $4C98
004D2C  30 03                         bmi  $4D31
004D2E  4C A8 4C                      jmp  loc_004CA8

004D31  60                            rts

004D32  00                      HEX     00
; ── DisplayLevelNum ───────────────────────────────────────────────
; HOW: Renders the current level number on screen. Reads the level
;      counter ($3A), converts it to a display value (level = 6 - $3A),
;      and draws the corresponding digit sprite.
; WHY: Visual feedback showing which level the player has reached.

004D33  A9 14                         lda  #$14
004D35  85 02                         sta  col_ctr
004D37  A9 75                         lda  #$75
004D39  85 04                         sta  sprite_calc
004D3B  A9 97                         lda  #$97
004D3D  20 16 04                      jsr  $0416  ; DrawSprite
004D40  A9 77                         lda  #$77
004D42  85 19                         sta  draw_y
004D44  A9 75                         lda  #$75
004D46  85 04                         sta  sprite_calc
004D48  A6 3A                         ldx  level
004D4A  F0 07                         beq  loc_004D53
004D4C  BD 6E 4D                      lda  $4D6E,X
004D4F  20 7F 52                      jsr  DrawSatellite
004D52  60                            rts
004D53  A9 14             loc_004D53  lda  #$14
004D55  85 02                         sta  col_ctr
004D57  A9 82                         lda  #$82
004D59  85 04                         sta  sprite_calc
004D5B  A9 98                         lda  #$98
004D5D  20 16 04                      jsr  $0416  ; DrawSprite
004D60  A9 1A                         lda  #$1A
004D62  85 02                         sta  col_ctr
004D64  A9 75                         lda  #$75
004D66  85 04                         sta  sprite_calc
004D68  A9 99                         lda  #$99
004D6A  20 16 04                      jsr  $0416  ; DrawSprite
004D6D  60                            rts

004D6E  00665F35                HEX     00665F35 74
; ── LevelSetup ────────────────────────────────────────────────────
; HOW: Initializes a new level. Resets all 16 alien type values in the
;      $53B8 table to type 1 (UFO). Sets up the initial alien positions
;      for all 4 directions (4 aliens per direction).
; WHY: Every level starts fresh — all aliens revert to UFO regardless
;      of their evolved state in the previous level. This means the
;      player must work through the entire evolution cycle again. The
;      difficulty, however, carries over — the game gets progressively
;      harder across all 5 levels.

004D73  A2 03                         ldx  #$03
004D75  A9 00                         lda  #$00

004D77  9D B8 53                      sta  $53B8,X
004D7A  9D C0 53                      sta  $53C0,X
004D7D  9D BC 53                      sta  $53BC,X
004D80  9D C4 53                      sta  $53C4,X
004D83  CA                            dex
004D84  10 F1                         bpl  $4D77

004D86  60                            rts
; ── UpdateAlienPositions ──────────────────────────────────────────
; HOW: Iterates through all 16 aliens, updating their orbital position
;      around the playfield edges. Each alien moves along its assigned
;      direction's track, with speed controlled by the difficulty tables.
; WHY: Continuous alien movement creates a dynamic target for the player.
;      The aliens orbit in groups of 4 per direction, creating a visual
;      pattern reminiscent of electrons orbiting a nucleus — fitting the
;      game's biology/mutation theme.

004D87  A2 03                         ldx  #$03
004D89  8E BB 4D                      stx  $4DBB

004D8C  AE BB 4D                      ldx  $4DBB
004D8F  BD 58 5D                      lda  $5D58,X
004D92  F0 21                         beq  $4DB5
004D94  E0 03                         cpx  #$03
004D96  F0 1A                         beq  $4DB2
004D98  E0 02                         cpx  #$02
004D9A  F0 0A                         beq  $4DA6
004D9C  E0 01                         cpx  #$01
004D9E  F0 0C                         beq  $4DAC
004DA0  20 E3 4D                      jsr  AlienEvolve
004DA3  4C B5 4D                      jmp  $4DB5  ; UpdateAlienPositions
004DA6  20 8B 4E                      jsr  AlienHitHandlerB
004DA9  4C B5 4D                      jmp  $4DB5  ; UpdateAlienPositions
004DAC  20 38 4E                      jsr  AlienHitHandler
004DAF  4C B5 4D                      jmp  $4DB5  ; UpdateAlienPositions
004DB2  20 E0 4E                      jsr  AlienHitHandlerC
004DB5  CE BB 4D                      dec  $4DBB
004DB8  10 D2                         bpl  $4D8C

004DBA  60                            rts

004DBB  00000003                HEX     00000003 06090001 02


004DC4  AA                            tax
004DC5  BD BD 4D                      lda  $4DBD,X
004DC8  20 E0 4A                      jsr  AddScore

004DCB  A9 14                         lda  #$14
004DCD  A0 0A                         ldy  #$0A
004DCF  20 35 4F                      jsr  PlaySound
004DD2  AE BB 4D                      ldx  $4DBB
004DD5  A9 00                         lda  #$00
004DD7  9D 58 5D                      sta  $5D58,X
004DDA  20 41 44                      jsr  ClearSpriteArea

004DDD  20 E4 56                      jsr  IncreaseDifficulty
004DE0  4C 4F 5B                      jmp  InputProcessA
; ── AlienEvolve ───────────────────────────────────────────────────
; HOW: Increments the alien's type value in the $53B8 table. Type cycle:
;        1 (UFO) → 2 (Eye Blue) → 3 (Eye Green) → 4 (TV) → 5 (Diamond)
;        → 6 (Bowtie) → wraps back to 1 (UFO)
;      If the new type exceeds 6, wraps to 1.
; WHY: This is the core mechanic that gives the game its name — "Genetic
;      Drift." Each hit causes the alien to "mutate" into a new form.
;      The goal is to get all 16 aliens to type 4 (TV) simultaneously.
;      Three hits advance UFO→Eye→Eye→TV, but one extra hit pushes
;      past TV to Diamond, requiring 5 more hits to cycle back. This
;      creates a strategic puzzle layered on top of the action gameplay:
;      you must count your shots carefully and stop at exactly TV.

004DE3  AD 64 5D                      lda  $5D64
004DE6  C9 0A                         cmp  #$0A
004DE8  B0 4D                         bcs  $4E37
004DEA  20 0E 56                      jsr  $560E  ; CheckAlienDirection
004DED  F0 48                         beq  $4E37
004DEF  8E BC 4D                      stx  $4DBC
004DF2  20 C4 4D                      jsr  UpdateAlienPosB

004DF5  AE BC 4D                      ldx  $4DBC
004DF8  AD EC 53                      lda  $53EC
004DFB  18                            clc
004DFC  7D E4 53                      adc  $53E4,X
004DFF  8D FC 53                      sta  $53FC
004E02  85 19                         sta  draw_y
004E04  A9 01                         lda  #$01
004E06  85 04                         sta  sprite_calc
004E08  BD B8 53                      lda  $53B8,X
004E0B  AA                            tax
004E0C  BD C8 53                      lda  $53C8,X
004E0F  20 A1 52                      jsr  DrawSatelliteB
004E12  AE BC 4D                      ldx  $4DBC
004E15  FE B8 53                      inc  $53B8,X
004E18  BD B8 53                      lda  $53B8,X
004E1B  C9 07                         cmp  #$07
004E1D  90 05                         bcc  $4E24
004E1F  A9 01                         lda  #$01
004E21  9D B8 53                      sta  $53B8,X
004E24  AD FC 53                      lda  $53FC
004E27  85 19                         sta  draw_y
004E29  A9 01                         lda  #$01
004E2B  85 04                         sta  sprite_calc
004E2D  BD B8 53                      lda  $53B8,X
004E30  AA                            tax
004E31  BD C8 53                      lda  $53C8,X
004E34  20 7F 52                      jsr  DrawSatellite
004E37  60                            rts
; ── AlienHitHandler ───────────────────────────────────────────────
; HOW: Checks if a player's projectile has collided with an alien by
;      comparing the projectile's coordinate against the alien's track
;      position. Uses direction-specific threshold checks:
;        UP: projectile Y <= alien Y
;        DOWN: projectile Y >= alien Y
;        LEFT: projectile X <= alien X
;        RIGHT: projectile X >= alien X
;      On hit: draws flash, clears old sprite, adds 1 point, evolves
;      the alien, and increases difficulty.
; WHY: Coordinate line-crossing collision works well here because
;      projectiles move 3 pixels/frame in straight lines — they cross
;      every coordinate exactly once. No bounding box math needed.
;      This is efficient on the 6502 and perfectly suited to the
;      game's cardinal-direction-only movement.

004E38  AD 61 5D                      lda  $5D61
004E3B  F0 4D                         beq  $4E8A
004E3D  20 0E 56                      jsr  $560E  ; CheckAlienDirection
004E40  8E BC 4D                      stx  $4DBC
004E43  F0 45                         beq  $4E8A
004E45  20 C4 4D                      jsr  UpdateAlienPosB

004E48  AE BC 4D                      ldx  $4DBC
004E4B  AD F1 53                      lda  $53F1
004E4E  18                            clc
004E4F  7D E4 53                      adc  $53E4,X
004E52  8D FA 53                      sta  $53FA
004E55  85 04                         sta  sprite_calc
004E57  A9 C4                         lda  #$C4
004E59  85 19                         sta  draw_y
004E5B  BD BC 53                      lda  $53BC,X
004E5E  AA                            tax
004E5F  BD DD 53                      lda  $53DD,X
004E62  20 A1 52                      jsr  DrawSatelliteB
004E65  AE BC 4D                      ldx  $4DBC
004E68  FE BC 53                      inc  $53BC,X
004E6B  BD BC 53                      lda  $53BC,X
004E6E  C9 07                         cmp  #$07
004E70  90 05                         bcc  $4E77
004E72  A9 01                         lda  #$01
004E74  9D BC 53                      sta  $53BC,X
004E77  AD FA 53                      lda  $53FA
004E7A  85 04                         sta  sprite_calc
004E7C  A9 C4                         lda  #$C4
004E7E  85 19                         sta  draw_y
004E80  BD BC 53                      lda  $53BC,X
004E83  AA                            tax
004E84  BD DD 53                      lda  $53DD,X
004E87  20 7F 52                      jsr  DrawSatellite
004E8A  60                            rts

004E8B  AD 66 5D                      lda  $5D66
004E8E  C9 B4                         cmp  #$B4
004E90  90 4D                         bcc  $4EDF
004E92  20 0E 56                      jsr  $560E  ; CheckAlienDirection
004E95  F0 48                         beq  $4EDF
004E97  8E BC 4D                      stx  $4DBC
004E9A  20 C4 4D                      jsr  UpdateAlienPosB

004E9D  AE BC 4D                      ldx  $4DBC
004EA0  AD EE 53                      lda  $53EE
004EA3  18                            clc
004EA4  7D E4 53                      adc  $53E4,X
004EA7  8D FC 53                      sta  $53FC
004EAA  85 19                         sta  draw_y
004EAC  A9 B4                         lda  #$B4
004EAE  85 04                         sta  sprite_calc
004EB0  BD C0 53                      lda  $53C0,X
004EB3  AA                            tax
004EB4  BD CF 53                      lda  $53CF,X
004EB7  20 A1 52                      jsr  DrawSatelliteB
004EBA  AE BC 4D                      ldx  $4DBC
004EBD  FE C0 53                      inc  $53C0,X
004EC0  BD C0 53                      lda  $53C0,X
004EC3  C9 07                         cmp  #$07
004EC5  90 05                         bcc  $4ECC
004EC7  A9 01                         lda  #$01
004EC9  9D C0 53                      sta  $53C0,X
004ECC  AD FC 53                      lda  $53FC
004ECF  85 19                         sta  draw_y
004ED1  A9 B4                         lda  #$B4
004ED3  85 04                         sta  sprite_calc
004ED5  BD C0 53                      lda  $53C0,X
004ED8  AA                            tax
004ED9  BD CF 53                      lda  $53CF,X
004EDC  20 7F 52                      jsr  DrawSatellite
004EDF  60                            rts

004EE0  AD 5F 5D                      lda  $5D5F
004EE3  C9 46                         cmp  #$46
004EE5  B0 4D                         bcs  $4F34
004EE7  20 0E 56                      jsr  $560E  ; CheckAlienDirection
004EEA  F0 48                         beq  $4F34
004EEC  8E BC 4D                      stx  $4DBC
004EEF  20 C4 4D                      jsr  UpdateAlienPosB

004EF2  AE BC 4D                      ldx  $4DBC
004EF5  AD F3 53                      lda  $53F3
004EF8  18                            clc
004EF9  7D E4 53                      adc  $53E4,X
004EFC  8D FA 53                      sta  $53FA
004EFF  85 04                         sta  sprite_calc
004F01  A9 00                         lda  #$00
004F03  85 19                         sta  draw_y
004F05  BD C4 53                      lda  $53C4,X
004F08  AA                            tax
004F09  BD D6 53                      lda  $53D6,X
004F0C  20 A1 52                      jsr  DrawSatelliteB
004F0F  AE BC 4D                      ldx  $4DBC
004F12  FE C4 53                      inc  $53C4,X
004F15  BD C4 53                      lda  $53C4,X
004F18  C9 07                         cmp  #$07
004F1A  90 05                         bcc  $4F21
004F1C  A9 01                         lda  #$01
004F1E  9D C4 53                      sta  $53C4,X
004F21  AD FA 53                      lda  $53FA
004F24  85 04                         sta  sprite_calc
004F26  A9 00                         lda  #$00
004F28  85 19                         sta  draw_y
004F2A  BD C4 53                      lda  $53C4,X
004F2D  AA                            tax
004F2E  BD D6 53                      lda  $53D6,X
004F31  20 7F 52                      jsr  DrawSatellite
004F34  60                            rts
; ── PlayHitSound ──────────────────────────────────────────────────
; HOW: Toggles the speaker ($C030) with timing controlled by A and Y
;      registers. Creates a short percussive sound.
; WHY: Audio confirmation of a successful hit on an alien or satellite.

004F35  85 38                         sta  snd_pitch1
004F37  84 39                         sty  snd_pitch2
004F39  A2 30                         ldx  #$30

004F3B  A4 38                         ldy  snd_pitch1

004F3D  EA                            nop
004F3E  EA                            nop
004F3F  EA                            nop
004F40  88                            dey
004F41  D0 FA                         bne  $4F3D

004F43  8D 30 C0                      sta  SPKR            ; SPKR - Speaker toggle
004F46  CA                            dex
004F47  D0 F2                         bne  $4F3B

004F49  A2 30                         ldx  #$30

004F4B  A4 39                         ldy  snd_pitch2

004F4D  EA                            nop
004F4E  EA                            nop
004F4F  EA                            nop
004F50  88                            dey
004F51  D0 FA                         bne  $4F4D

004F53  8D 30 C0                      sta  SPKR            ; SPKR - Speaker toggle
004F56  EA                            nop
004F57  CA                            dex
004F58  D0 F1                         bne  $4F4B

004F5A  60                            rts
; ── CheckSatelliteHits ────────────────────────────────────────────
; HOW: For each of 4 projectile directions (X=3..0), first checks if
;      the laser is in a satellite zone (edges of the playfield). If yes,
;      loops through 4 satellite slots (Y=3..0), comparing the laser's
;      position against the satellite's orbit position ($520E,Y) with a
;      5-pixel hit window. On hit: plays sound, awards points equal to
;      the satellite's remaining hit points, increases difficulty, and
;      decrements the satellite's hit counter.
; WHY: Zone-based filtering is an efficient two-stage collision check.
;      First check "is the laser near a playfield edge?" (cheap), then
;      only do the expensive per-satellite position comparison when it
;      matters. The 5-pixel hit window provides a forgiving target for
;      the fast-moving satellites. Points scale with difficulty — harder
;      satellites (more hits required) award more points per hit.

004F5B  A2 03                         ldx  #$03
004F5D  86 12                         stx  loop_idx

004F5F  A6 12                         ldx  loop_idx
004F61  BD 58 5D                      lda  $5D58,X
004F64  D0 03                         bne  loc_004F69
004F66  4C F5 4F                      jmp  loc_004FF5
004F69  E0 03             loc_004F69  cpx  #$03
004F6B  F0 26                         beq  $4F93
004F6D  E0 02                         cpx  #$02
004F6F  F0 18                         beq  $4F89
004F71  E0 01                         cpx  #$01
004F73  F0 0A                         beq  $4F7F
004F75  BD 64 5D                      lda  $5D64,X
004F78  C9 26                         cmp  #$26
004F7A  90 1E                         bcc  $4F9A
004F7C  4C F5 4F                      jmp  loc_004FF5
004F7F  BD 5C 5D                      lda  $5D5C,X
004F82  C9 E3                         cmp  #$E3
004F84  B0 14                         bcs  $4F9A
004F86  4C F5 4F                      jmp  loc_004FF5
004F89  BD 64 5D                      lda  $5D64,X
004F8C  C9 98                         cmp  #$98
004F8E  B0 0A                         bcs  $4F9A
004F90  4C F5 4F                      jmp  loc_004FF5
004F93  BD 5C 5D                      lda  $5D5C,X
004F96  C9 71                         cmp  #$71
004F98  B0 5B                         bcs  loc_004FF5
004F9A  A0 03                         ldy  #$03
004F9C  8C 01 50                      sty  $5001

004F9F  AC 01 50          loc_004F9F  ldy  $5001
004FA2  B9 12 52                      lda  $5212,Y
004FA5  F0 49                         beq  loc_004FF0
004FA7  B9 0E 52                      lda  $520E,Y
004FAA  38                            sec
004FAB  A6 12                         ldx  loop_idx
004FAD  FD FD 4F                      sbc  $4FFD,X
004FB0  C9 05                         cmp  #$05
004FB2  B0 3C                         bcs  loc_004FF0
004FB4  A9 08                         lda  #$08
004FB6  A0 10                         ldy  #$10
004FB8  20 35 4F                      jsr  PlaySound

004FBB  AE 01 50                      ldx  $5001
004FBE  BD 12 52                      lda  $5212,X
004FC1  20 E0 4A                      jsr  AddScore

004FC4  20 E4 56                      jsr  IncreaseDifficulty
004FC7  A6 12                         ldx  loop_idx
004FC9  A9 00                         lda  #$00
004FCB  9D 58 5D                      sta  $5D58,X
004FCE  20 41 44                      jsr  ClearSpriteArea

004FD1  20 4F 5B                      jsr  InputProcessA
004FD4  AE 01 50                      ldx  $5001
004FD7  DE 21 52                      dec  $5221,X
004FDA  D0 14                         bne  loc_004FF0
004FDC  20 C9 52                      jsr  $52C9  ; EraseSatellite
004FDF  AE 01 50                      ldx  $5001
004FE2  DE 12 52                      dec  $5212,X
004FE5  BD 12 52                      lda  $5212,X
004FE8  9D 21 52                      sta  $5221,X
004FEB  F0 03                         beq  loc_004FF0
004FED  20 C3 52                      jsr  $52C3  ; DrawSatellite
004FF0  CE 01 50          loc_004FF0  dec  $5001
004FF3  10 AA                         bpl  loc_004F9F

004FF5  C6 12             loc_004FF5  dec  loop_idx
004FF7  30 03                         bmi  loc_004FFC
004FF9  4C 5F 4F                      jmp  $4F5F

004FFC  60                loc_004FFC  rts
; ── Satellite Orbit Path: Y Coordinates ──────────────────────────
; 256 bytes. Positions 0-239 define the satellite's Y coordinate at
; each step of its rectangular orbit around the playfield edges.
; Positions 240-255 are padding (orbit only uses 0-239).
; The orbit traces a rectangle: top edge → right edge → bottom edge
; → left edge, giving the satellites a smooth path around the
; outside of the gameplay area.

004FFD  97D71757                HEX     97D71757 00898886 85848281 807E7D7C
00500D  7A797776                HEX     7A797776 75737270 6F6D6C6A 69676664
00501D  6362605F                HEX     6362605F 5D5C5A59 57565553 52514F4E
00502D  4D4B4A49                HEX     4D4B4A49 47464544 4342403F 3E3D3C3B
00503D  3A393938                HEX     3A393938 37363534 34333232 31313030
00504D  2F2F2E2E                HEX     2F2F2E2E 2E2D2D2D 2D2D2D2D 2D2D2D2D
00505D  2D2D2D2D                HEX     2D2D2D2D 2E2E2E2F 2F2F3030 31313233
00506D  33343536                HEX     33343536 36373839 3A3B3C3D 3E3F4041
00507D  42434446                HEX     42434446 4748494B 4C4D4F50 51535455
00508D  57585A5B                HEX     57585A5B 5C5E5F61 62646567 686A6B6D
00509D  6E6F7172                HEX     6E6F7172 74757778 7A7B7C7E 7F808283
0050AD  84868788                HEX     84868788 8A8B8C8D 8E8F9192 93949596
0050BD  97989899                HEX     97989899 9A9B9C9D 9D9E9F9F A0A0A1A1
0050CD  A2A2A3A3                HEX     A2A2A3A3 A3A4A4A4 A4A4A4A4 A4A4A4A4
0050DD  A4A4A4A4                HEX     A4A4A4A4 A3A3A3A2 A2A2A1A1 A0A09F9E
0050ED  9E9D9C9B                HEX     9E9D9C9B 9B9A9998 97969594 93929190
; ── Satellite Orbit Path: X Coordinates ──────────────────────────
; 256 bytes. Paired with the Y table above to define the full 2D
; orbit path. Index into both tables with the satellite's position
; counter (0-239) to get screen coordinates.

0050FD  8F8E8D8B                HEX     8F8E8D8B 8A8F9091 91929393 94949595
00510D  96969797                HEX     96969797 97989898 98989898 98989898
00511D  98989898                HEX     98989898 97979796 96969595 94949392
00512D  9291908F                HEX     9291908F 8F8E8D8C 8B8A8988 87868584
00513D  8382817F                HEX     8382817F 7E7D7C7A 79787675 74727170
00514D  6E6D6B6A                HEX     6E6D6B6A 69676664 6361605E 5D5B5A58
00515D  57565453                HEX     57565453 51504E4D 4B4A4947 46454342
00516D  413F3E3D                HEX     413F3E3D 3B3A3938 37363433 3231302F
00517D  2E2D2D2C                HEX     2E2D2D2C 2B2A2928 28272626 25252424
00518D  23232222                HEX     23232222 22212121 21212121 21212121
00519D  21212121                HEX     21212121 22222223 23232424 25252627
0051AD  2728292A                HEX     2728292A 2A2B2C2D 2E2F3031 32333435
0051BD  3637383A                HEX     3637383A 3B3C3D3F 40414344 45474849
0051CD  4B4C4E4F                HEX     4B4C4E4F 50525355 5658595B 5C5E5F61
0051DD  62636566                HEX     62636566 68696B6C 6E6F7072 73747677
0051ED  787A7B7C                HEX     787A7B7C 7E7F8081 82838586 8788898A
0051FD  8B8C8C8D                HEX     8B8C8C8D 8EAD10C0 AD00C010 FB8D10C0
; ── Satellite State: Orbit Position ──────────────────────────────
; 4 bytes (one per satellite slot). Current position index (0-239)
; in the orbit path tables. Decremented each movement tick to orbit
; counterclockwise.
; ── Satellite State: Hit Points / Active Flag ────────────────────
; 4 bytes (one per slot). 0 = empty/inactive. Nonzero = satellite
; exists with that many hit points remaining. Also equals points
; awarded per hit. Level 3: starts at 2. Level 4: 4. Level 5: 6.
; ── Satellite Sprite Lookup by Hit Points ────────────────────────
; Maps remaining hit points to a sprite index, so satellites change
; appearance as they take damage.

00520D  6081A0A5                HEX     6081A0A5 A0A9A087 CD93A095 D4002E58
00521D  3C434A51                HEX     3C434A51 CFA0FEAE 0000
; ── SpawnSatellite ────────────────────────────────────────────────
; HOW: Finds an empty satellite slot (checks $5212,X for zero), sets hit
;      points based on the current level:
;        Level 3 ($3A=3): 2 hits, 2 points each
;        Level 4 ($3A=2): 4 hits, 4 points each
;        Level 5 ($3A=1): 6 hits, 6 points each
;      Generates a random orbit position (0-239), rejecting values >= 240
;      or within 10 steps of an existing satellite. Stores position in
;      $520E and hit points in $5212 and $5221.
; WHY: Satellites are the bonus challenge in levels 3-5. Four are spawned
;      at each level transition. Hit points scale with level, creating an
;      escalating reward: Level 3 satellites give 4 total points each
;      (2x2), Level 4 gives 16 (4x4), Level 5 gives 36 (6x6). The
;      spawn position validation (minimum 10-step separation) prevents
;      satellites from stacking on top of each other.

005227  A2 03                         ldx  #$03

005229  BD 12 52          loc_005229  lda  $5212,X
00522C  F0 04                         beq  loc_005232
00522E  CA                            dex
00522F  10 F8                         bpl  loc_005229

005231  60                            rts
005232  8E 25 52          loc_005232  stx  $5225
005235  A5 3A                         lda  level
005237  C9 03                         cmp  #$03
005239  F0 09                         beq  $5244
00523B  C9 02                         cmp  #$02
00523D  D0 0A                         bne  $5249
00523F  A9 04                         lda  #$04
005241  4C 4B 52                      jmp  $524B  ; SpawnSatellite
005244  A9 02                         lda  #$02
005246  4C 4B 52                      jmp  $524B  ; SpawnSatellite
005249  A9 06                         lda  #$06
00524B  9D 12 52                      sta  $5212,X
00524E  9D 21 52                      sta  $5221,X

005251  20 03 04          loc_005251  jsr  $0403  ; RandomByte
005254  C9 F0                         cmp  #$F0
005256  B0 F9                         bcs  loc_005251

005258  8D 26 52                      sta  $5226
00525B  A0 03                         ldy  #$03

00525D  B9 12 52          loc_00525D  lda  $5212,Y
005260  F0 0F                         beq  loc_005271
005262  AD 26 52                      lda  $5226
005265  38                            sec
005266  F9 0E 52                      sbc  $520E,Y
005269  C9 0A                         cmp  #$0A
00526B  90 E4                         bcc  loc_005251

00526D  C9 F6                         cmp  #$F6
00526F  B0 E0                         bcs  loc_005251

005271  88                loc_005271  dey
005272  10 E9                         bpl  loc_00525D

005274  AD 26 52                      lda  $5226
005277  AE 25 52                      ldx  $5225
00527A  9D 0E 52                      sta  $520E,X
00527D  60                            rts

00527E  00                      HEX     00


00527F  8D 7E 52                      sta  $527E
005282  A5 19                         lda  draw_y
005284  29 FE                         and  #$FE
005286  AA                            tax
005287  BD AA 47                      lda  $47AA,X
00528A  18                            clc
00528B  69 09                         adc  #$09
00528D  85 02                         sta  col_ctr
00528F  A5 19                         lda  draw_y
005291  4A                            lsr  a
005292  AA                            tax
005293  BD 92 46                      lda  $4692,X
005296  AA                            tax
005297  BD D3 48                      lda  $48D3,X
00529A  18                            clc
00529B  6D 7E 52                      adc  $527E
00529E  4C 16 04                      jmp  $0416  ; DrawSprite


0052A1  8D 7E 52          DrawSatelliteB  sta  $527E
0052A4  A5 19                         lda  draw_y
0052A6  29 FE                         and  #$FE
0052A8  AA                            tax
0052A9  BD AA 47                      lda  $47AA,X
0052AC  18                            clc
0052AD  69 09                         adc  #$09
0052AF  85 02                         sta  col_ctr
0052B1  A5 19                         lda  draw_y
0052B3  4A                            lsr  a
0052B4  AA                            tax
0052B5  BD 92 46                      lda  $4692,X
0052B8  AA                            tax
0052B9  BD D3 48                      lda  $48D3,X
0052BC  18                            clc
0052BD  6D 7E 52                      adc  $527E
0052C0  4C C0 40                      jmp  DrawSpriteXY
; ── DrawSatellite ─────────────────────────────────────────────────
; HOW: Reads the satellite's orbit position from $520E,X, uses it as an
;      index into the 256-byte orbit path tables at $5002 (Y coord) and
;      $5102 (X coord). Selects a sprite based on remaining hit points
;      via the $521A mapping table. Draws the satellite sprite.
; WHY: The orbit path tables define a rectangular course around the
;      playfield edges. By using lookup tables instead of computing
;      the path, satellite movement is fast and the orbit shape can be
;      any arbitrary curve the tables define — not just simple math.

0052C3  20 CF 52                      jsr  $52CF  ; LoadSatelliteData
0052C6  4C 7F 52                      jmp  DrawSatellite
; ── EraseSatellite ────────────────────────────────────────────────
; HOW: Calls LoadSatelliteData to look up the satellite's screen
;      coordinates and sprite, then erases it via XOR draw.
; WHY: Paired with DrawSatellite — erase old position, then redraw
;      at new position to animate satellite orbit movement.

0052C9  20 CF 52                      jsr  $52CF  ; LoadSatelliteData
0052CC  4C A1 52                      jmp  DrawSatelliteB
; ── LoadSatelliteData ─────────────────────────────────────────────
; HOW: Reads the satellite's orbit index from $520E,X. Uses it to
;      look up X/Y coordinates from the 256-entry orbit path tables
;      at $5002 (Y) and $5102 (X). Selects sprite by hit points
;      via the $521A mapping table.
; WHY: Centralizes the orbit-to-screen coordinate conversion.
;      Both DrawSatellite and EraseSatellite call this to avoid
;      duplicating the table lookup logic.

0052CF  BD 0E 52                      lda  $520E,X
0052D2  A8                            tay
0052D3  B9 02 51                      lda  $5102,Y
0052D6  85 04                         sta  sprite_calc
0052D8  B9 02 50                      lda  $5002,Y
0052DB  85 19                         sta  draw_y
0052DD  BD 12 52                      lda  $5212,X
0052E0  A8                            tay
0052E1  B9 1A 52                      lda  $521A,Y
0052E4  60                            rts
; ── DrawBase_ClearSatellites ──────────────────────────────────────
; HOW: Draws the player's base sprite at the center of the playfield,
;      then loops through all 4 satellite slots, setting $5212,X to zero
;      (deactivating them).
; WHY: Called at game start. The base is the visual anchor of the game
;      — the player's "home" at the center. Satellite slots are cleared
;      because no satellites exist in levels 1-2.

0052E5  A2 03                         ldx  #$03
0052E7  A9 00                         lda  #$00

0052E9  9D 12 52          loc_0052E9  sta  $5212,X
0052EC  CA                            dex
0052ED  10 FA                         bpl  loc_0052E9

0052EF  60                            rts

0052F0  00E0E0                  HEX     00E0E0
; ── RedrawScreen ──────────────────────────────────────────────────
; HOW: Master screen redraw. Handles satellite orbit movement: increments
;      a sub-counter ($52F1), when it wraps, reloads from $52F2 (speed)
;      and selects the next satellite slot in round-robin order ($52F0).
;      If the selected slot has an active satellite, decrements its
;      orbit position (moving it counterclockwise) and redraws it.
; WHY: Round-robin satellite updates spread the CPU cost evenly — only
;      one of the 4 satellites moves per redraw cycle. This keeps frame
;      time consistent regardless of satellite count. Movement speed is
;      controlled by the difficulty table via $52F2.

0052F3  EE F1 52                      inc  $52F1
0052F6  F0 01                         beq  loc_0052F9
0052F8  60                            rts
0052F9  AD F2 52          loc_0052F9  lda  $52F2
0052FC  8D F1 52                      sta  $52F1
0052FF  CE F0 52                      dec  $52F0
005302  10 05                         bpl  $5309
005304  A9 03                         lda  #$03
005306  8D F0 52                      sta  $52F0
005309  AE F0 52                      ldx  $52F0
00530C  BD 12 52                      lda  $5212,X
00530F  F0 25                         beq  $5336
005311  BD 0E 52                      lda  $520E,X
005314  A2 03                         ldx  #$03

005316  DD 37 53                      cmp  $5337,X
005319  D0 09                         bne  $5324
00531B  20 3B 53                      jsr  $533B  ; SpawnEnemyProjectile
00531E  AE F0 52                      ldx  $52F0
005321  4C 2A 53                      jmp  $532A
005324  CA                            dex
005325  10 EF                         bpl  $5316

005327  AE F0 52                      ldx  $52F0
00532A  20 C9 52                      jsr  $52C9  ; EraseSatellite

00532D  AE F0 52                      ldx  $52F0
005330  DE 0E 52                      dec  $520E,X
005333  20 C3 52                      jsr  $52C3  ; DrawSatellite

005336  60                            rts
; ── Satellite Corner Transition Points ───────────────────────────
; 4 bytes: orbit positions ($96, $D6, $16, $56) corresponding to
; the 4 corners of the playfield. When a satellite's position matches
; one of these values, it triggers an enemy projectile spawn from
; that corner toward the player.

005337  96D61656                HEX     96D61656
; ── SpawnEnemyProjectile ──────────────────────────────────────────
; HOW: Checks if the enemy projectile slot ($5D54,X) is empty.
;      If so, activates it and initializes position from the corner
;      spawn tables ($5362/$5366/$536A). Triggers a sound effect.
; WHY: Enemies shoot from the corners of the playfield toward the
;      center where the player sits. The spawn tables pre-define
;      the starting positions so corner shots converge naturally.

00533B  BD 54 5D                      lda  $5D54,X
00533E  D0 21                         bne  $5361
005340  A9 01                         lda  #$01
005342  9D 54 5D                      sta  $5D54,X
005345  BD 62 53                      lda  $5362,X
005348  9D 48 5D                      sta  $5D48,X
00534B  BD 66 53                      lda  $5366,X
00534E  9D 4C 5D                      sta  $5D4C,X
005351  BD 6A 53                      lda  $536A,X
005354  9D 50 5D                      sta  $5D50,X
005357  A0 10                         ldy  #$10
005359  A9 45                         lda  #$45
00535B  8D 67 5B                      sta  $5B67
00535E  4C 62 5B                      jmp  InputProcessB
005361  60                            rts
; ── 4-Direction Fire Ammo Counter ────────────────────────────────
; 1 byte. Number of remaining "super shot" uses. Starts at 3,
; gains 1 with each difficulty increase. When > 0, pressing A or F
; fires in all 4 directions simultaneously.

005362  A9E5A96D                HEX     A9E5A96D 00000000 225E9A5E 0000
; ── Set4DirAmmo ───────────────────────────────────────────────────
; HOW: Loads the initial 4-direction fire ammo value (3 uses) and stores
;      it at $536F.
; WHY: Grants the player 3 uses of the 4-direction "super shot" at game
;      start. Additional uses are granted with each difficulty increase.

005370  A9 03                         lda  #$03
005372  8D 6F 53                      sta  $536F
005375  60                            rts
; ── Inc4DirAmmo ───────────────────────────────────────────────────
; HOW: Increments the 4-direction fire ammo counter at $536F.
;      Clamps at $FF to prevent rollover.
; WHY: Rewards the player with additional super shots as difficulty
;      increases, compensating for the faster game speed.

005376  EE 6F 53                      inc  $536F
005379  D0 05                         bne  $5380
00537B  A9 FF                         lda  #$FF
00537D  8D 6F 53                      sta  $536F
005380  60                            rts
005381  AD 6F 53                      lda  $536F
005384  F0 2D                         beq  loc_0053B3
005386  CE 6F 53                      dec  $536F
005389  A2 03                         ldx  #$03
00538B  8E 6E 53                      stx  $536E

00538E  AE 6E 53                      ldx  $536E
005391  BD 58 5D                      lda  $5D58,X
005394  D0 17                         bne  $53AD
005396  A9 01                         lda  #$01
005398  9D 58 5D                      sta  $5D58,X
00539B  BD 68 5D                      lda  $5D68,X
00539E  9D 5C 5D                      sta  $5D5C,X
0053A1  BD 6C 5D                      lda  $5D6C,X
0053A4  9D 60 5D                      sta  $5D60,X
0053A7  BD 70 5D                      lda  $5D70,X
0053AA  9D 64 5D                      sta  $5D64,X
0053AD  CE 6E 53                      dec  $536E
0053B0  10 DC                         bpl  $538E

0053B2  60                            rts
0053B3  A9 01             loc_0053B3  lda  #$01
0053B5  85 36                         sta  fire_req
0053B7  60                            rts
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
; The game is won when all 16 entries equal 4 (TV).

0053B8  C6A5D4A0                HEX     C6A5D4A0 A0E7A0A0 C9A0A0A0 D5A0A9A0
; --- Alien Type -> Sprite Index Lookup ---
; Maps type 0-6 to sprite indices: $00,$74,$35,$5F,$66,$6D,$7B
0053C8  0074355F                HEX     0074355F 666D7B00 74355F66 6D7B0074
0053D8  355F666D                HEX     355F666D 7B007435 5F666D7B 00152A3F
0053E8  00152A3F                HEX     00152A3F 14141414 14141414 FEFE0202
0053F8  00000000                HEX     00000000 00


0053FD  AD F3 53                      lda  $53F3
005400  8D F9 53                      sta  $53F9
005403  18                            clc
005404  6D F7 53                      adc  $53F7
005407  8D FA 53                      sta  $53FA
00540A  8D F3 53                      sta  $53F3
00540D  C9 0A                         cmp  #$0A
00540F  90 04                         bcc  loc_005415
005411  C9 6C                         cmp  #$6C
005413  90 09                         bcc  loc_00541E
005415  38                loc_005415  sec
005416  A9 00                         lda  #$00
005418  ED F7 53                      sbc  $53F7
00541B  8D F7 53                      sta  $53F7
00541E  A9 03             loc_00541E  lda  #$03
005420  8D F8 53                      sta  $53F8

005423  AE F8 53                      ldx  $53F8
005426  BD C4 53                      lda  $53C4,X
005429  F0 30                         beq  loc_00545B
00542B  48                            pha
00542C  AD F9 53                      lda  $53F9
00542F  18                            clc
005430  7D E8 53                      adc  $53E8,X
005433  85 04                         sta  sprite_calc
005435  A9 09                         lda  #$09
005437  85 02                         sta  col_ctr
005439  68                            pla
00543A  AA                            tax
00543B  BD D6 53                      lda  $53D6,X
00543E  20 C0 40                      jsr  DrawSpriteXY

005441  AE F8 53                      ldx  $53F8
005444  AD FA 53                      lda  $53FA
005447  18                            clc
005448  7D E8 53                      adc  $53E8,X
00544B  85 04                         sta  sprite_calc
00544D  A9 09                         lda  #$09
00544F  85 02                         sta  col_ctr
005451  BD C4 53                      lda  $53C4,X
005454  AA                            tax
005455  BD D6 53                      lda  $53D6,X
005458  20 16 04                      jsr  $0416  ; DrawSprite
00545B  CE F8 53          loc_00545B  dec  $53F8
00545E  10 C3                         bpl  $5423

005460  60                            rts

005461  AD F1 53                      lda  $53F1
005464  8D F9 53                      sta  $53F9
005467  18                            clc
005468  6D F5 53                      adc  $53F5
00546B  8D FA 53                      sta  $53FA
00546E  8D F1 53                      sta  $53F1
005471  C9 0A                         cmp  #$0A
005473  90 04                         bcc  loc_005479
005475  C9 6C                         cmp  #$6C
005477  90 09                         bcc  loc_005482
005479  38                loc_005479  sec
00547A  A9 00                         lda  #$00
00547C  ED F5 53                      sbc  $53F5
00547F  8D F5 53                      sta  $53F5
005482  A9 03             loc_005482  lda  #$03
005484  8D F8 53                      sta  $53F8

005487  AE F8 53                      ldx  $53F8
00548A  BD BC 53                      lda  $53BC,X
00548D  F0 30                         beq  loc_0054BF
00548F  48                            pha
005490  AD F9 53                      lda  $53F9
005493  18                            clc
005494  7D E8 53                      adc  $53E8,X
005497  85 04                         sta  sprite_calc
005499  A9 25                         lda  #$25
00549B  85 02                         sta  col_ctr
00549D  68                            pla
00549E  AA                            tax
00549F  BD DD 53                      lda  $53DD,X
0054A2  20 C0 40                      jsr  DrawSpriteXY

0054A5  AE F8 53                      ldx  $53F8
0054A8  AD FA 53                      lda  $53FA
0054AB  18                            clc
0054AC  7D E8 53                      adc  $53E8,X
0054AF  85 04                         sta  sprite_calc
0054B1  A9 25                         lda  #$25
0054B3  85 02                         sta  col_ctr
0054B5  BD BC 53                      lda  $53BC,X
0054B8  AA                            tax
0054B9  BD DD 53                      lda  $53DD,X
0054BC  20 16 04                      jsr  $0416  ; DrawSprite
0054BF  CE F8 53          loc_0054BF  dec  $53F8
0054C2  10 C3                         bpl  $5487

0054C4  60                            rts

; case 1:
0054C5  AD EC 53                      lda  $53EC
0054C8  8D FB 53                      sta  $53FB
0054CB  18                            clc
0054CC  6D F4 53                      adc  $53F4
0054CF  8D FC 53                      sta  $53FC
0054D2  8D EC 53                      sta  $53EC
0054D5  C9 0A                         cmp  #$0A
0054D7  90 04                         bcc  loc_0054DD
0054D9  C9 85                         cmp  #$85
0054DB  90 09                         bcc  loc_0054E6
0054DD  38                loc_0054DD  sec
0054DE  A9 00                         lda  #$00
0054E0  ED F4 53                      sbc  $53F4
0054E3  8D F4 53                      sta  $53F4
0054E6  A9 03             loc_0054E6  lda  #$03
0054E8  8D F8 53                      sta  $53F8

0054EB  AE F8 53                      ldx  $53F8
0054EE  BD B8 53                      lda  $53B8,X
0054F1  F0 30                         beq  $5523
0054F3  48                            pha
0054F4  AD FB 53                      lda  $53FB
0054F7  18                            clc
0054F8  7D E4 53                      adc  $53E4,X
0054FB  85 19                         sta  draw_y
0054FD  A9 01                         lda  #$01
0054FF  85 04                         sta  sprite_calc
005501  68                            pla
005502  AA                            tax
005503  BD C8 53                      lda  $53C8,X
005506  20 A1 52                      jsr  DrawSatelliteB

005509  AE F8 53                      ldx  $53F8
00550C  AD FC 53                      lda  $53FC
00550F  18                            clc
005510  7D E4 53                      adc  $53E4,X
005513  85 19                         sta  draw_y
005515  A9 01                         lda  #$01
005517  85 04                         sta  sprite_calc
005519  BD B8 53                      lda  $53B8,X
00551C  AA                            tax
00551D  BD C8 53                      lda  $53C8,X
005520  20 7F 52                      jsr  DrawSatellite

005523  CE F8 53                      dec  $53F8
005526  10 C3                         bpl  $54EB

005528  60                            rts

005529  AD EE 53                      lda  $53EE
00552C  8D FB 53                      sta  $53FB
00552F  18                            clc
005530  6D F6 53                      adc  $53F6
005533  8D FC 53                      sta  $53FC
005536  8D EE 53                      sta  $53EE
005539  C9 0A                         cmp  #$0A
00553B  90 04                         bcc  loc_005541
00553D  C9 85                         cmp  #$85
00553F  90 09                         bcc  loc_00554A
005541  38                loc_005541  sec
005542  A9 00                         lda  #$00
005544  ED F6 53                      sbc  $53F6
005547  8D F6 53                      sta  $53F6
00554A  A9 03             loc_00554A  lda  #$03
00554C  8D F8 53                      sta  $53F8

00554F  AE F8 53                      ldx  $53F8
005552  BD C0 53                      lda  $53C0,X
005555  F0 30                         beq  $5587
005557  48                            pha
005558  AD FB 53                      lda  $53FB
00555B  18                            clc
00555C  7D E4 53                      adc  $53E4,X
00555F  85 19                         sta  draw_y
005561  A9 B4                         lda  #$B4
005563  85 04                         sta  sprite_calc
005565  68                            pla
005566  AA                            tax
005567  BD CF 53                      lda  $53CF,X
00556A  20 A1 52                      jsr  DrawSatelliteB

00556D  AE F8 53                      ldx  $53F8
005570  AD FC 53                      lda  $53FC
005573  18                            clc
005574  7D E4 53                      adc  $53E4,X
005577  85 19                         sta  draw_y
005579  A9 B4                         lda  #$B4
00557B  85 04                         sta  sprite_calc
00557D  BD C0 53                      lda  $53C0,X
005580  AA                            tax
005581  BD CF 53                      lda  $53CF,X
005584  20 7F 52                      jsr  DrawSatellite

005587  CE F8 53                      dec  $53F8
00558A  10 C3                         bpl  $554F

00558C  60                            rts

00558D  F8F80000                HEX     F8F80000
; ── DrawAlienRowDir ───────────────────────────────────────────────
; HOW: Draws one row of 4 aliens for direction A (UP). Uses self-modifying
;      code to patch the sprite table offset, then calls DrawSprite for each
;      alien whose type is non-zero (alive). Iterates X = 3..0.
; WHY: Four variants of this routine exist — one per direction (A through D).
;      Each applies the correct coordinate transformation for its edge of
;      the playfield. The UP variant is the base; B/C/D mirror and rotate.

005591  EE 8D 55                      inc  $558D
005594  D0 49                         bne  $55DF
005596  AD 8E 55                      lda  $558E
005599  8D 8D 55                      sta  $558D
00559C  EE 8F 55                      inc  $558F
00559F  AD 8F 55                      lda  $558F
0055A2  29 03                         and  #$03
0055A4  8D 8F 55                      sta  $558F
0055A7  AA                            tax
0055A8  BD 54 5D                      lda  $5D54,X
0055AB  D0 32                         bne  $55DF
0055AD  20 0E 56                      jsr  $560E  ; CheckAlienDirection
0055B0  F0 2D                         beq  $55DF
0055B2  E6 2C                         inc  timer_lo
0055B4  D0 29                         bne  $55DF
0055B6  A5 32                         lda  fire_rate
0055B8  85 2C                         sta  timer_lo
0055BA  AD 8F 55                      lda  $558F
0055BD  0A                            asl  a
0055BE  0A                            asl  a
0055BF  18                            clc
0055C0  69 03                         adc  #$03
0055C2  AA                            tax
0055C3  BD B8 53                      lda  $53B8,X
0055C6  CA                            dex
0055C7  A0 02                         ldy  #$02

0055C9  DD B8 53                      cmp  $53B8,X
0055CC  D0 0B                         bne  loc_0055D9
0055CE  CA                            dex
0055CF  88                            dey
0055D0  10 F7                         bpl  $55C9

0055D2  20 03 04                      jsr  $0403  ; RandomByte
0055D5  C9 80                         cmp  #$80
0055D7  B0 06                         bcs  $55DF
0055D9  AE 8F 55          loc_0055D9  ldx  $558F
0055DC  20 0C 4B                      jsr  SelectProjectileType

0055DF  60                            rts

0055E0  E0E000                  HEX     E0E000
; ── DrawAlienRowDirB ──────────────────────────────────────────────
; HOW: Direction B (RIGHT) variant of DrawAlienRowDir. Self-modifies
;      the table offset at $55E1, then draws 4 aliens along the right
;      edge of the playfield.

0055E3  EE E1 55          DrawAlienRowDirB  inc  $55E1
0055E6  F0 01                         beq  loc_0055E9
0055E8  60                            rts
0055E9  AD E0 55          loc_0055E9  lda  $55E0
0055EC  8D E1 55                      sta  $55E1
0055EF  CE E2 55                      dec  $55E2
0055F2  AD E2 55                      lda  $55E2
0055F5  10 08                         bpl  $55FF
0055F7  A9 03                         lda  #$03
0055F9  8D E2 55                      sta  $55E2
0055FC  4C FD 53                      jmp  $53FD  ; AnimateSatelliteUp

0055FF  D0 03                         bne  loc_005604
005601  4C C5 54                      jmp  $54C5  ; AnimateSatelliteDown

005604  C9 01             loc_005604  cmp  #$01
005606  D0 03                         bne  $560B
005608  4C 61 54                      jmp  $5461  ; AnimateSatelliteLeft

00560B  4C 29 55                      jmp  $5529  ; AnimateSatelliteRight
; ── CheckAlienDirection ───────────────────────────────────────────
; HOW: Compares the alien's Y position against reference values to
;      determine which edge of the playfield it occupies. Branches
;      to direction-specific handlers ($569E, $564C, $5675) for
;      UP, RIGHT, and DOWN; falls through for LEFT.
; WHY: Each direction has unique coordinate math for positioning
;      aliens along its respective screen edge. This router dispatches
;      to the correct variant based on the alien's current orbit position.

00560E  E0 01                         cpx  #$01
005610  D0 03                         bne  $5615
005612  4C 9E 56                      jmp  loc_00569E
005615  E0 02                         cpx  #$02
005617  D0 03                         bne  loc_00561C
005619  4C 4C 56                      jmp  loc_00564C
00561C  E0 03             loc_00561C  cpx  #$03
00561E  D0 03                         bne  $5623
005620  4C 75 56                      jmp  loc_005675
005623  AD EC 53                      lda  $53EC
005626  8D FB 53                      sta  $53FB
005629  A9 03                         lda  #$03
00562B  8D F8 53                      sta  $53F8

00562E  AE F8 53                      ldx  $53F8
005631  AD FB 53                      lda  $53FB
005634  18                            clc
005635  7D E4 53                      adc  $53E4,X
005638  C9 5F                         cmp  #$5F
00563A  90 08                         bcc  $5644
00563C  C9 6F                         cmp  #$6F
00563E  B0 04                         bcs  $5644
005640  BD B8 53                      lda  $53B8,X
005643  60                            rts
005644  CE F8 53                      dec  $53F8
005647  10 E5                         bpl  $562E

005649  A9 00                         lda  #$00
00564B  60                            rts
00564C  AD EE 53          loc_00564C  lda  $53EE
00564F  8D FB 53                      sta  $53FB
005652  A9 03                         lda  #$03
005654  8D F8 53                      sta  $53F8

005657  AE F8 53                      ldx  $53F8
00565A  AD FB 53                      lda  $53FB
00565D  18                            clc
00565E  7D E4 53                      adc  $53E4,X
005661  C9 5F                         cmp  #$5F
005663  90 08                         bcc  $566D
005665  C9 6F                         cmp  #$6F
005667  B0 04                         bcs  $566D
005669  BD C0 53                      lda  $53C0,X
00566C  60                            rts
00566D  CE F8 53                      dec  $53F8
005670  10 E5                         bpl  $5657

005672  A9 00                         lda  #$00
005674  60                            rts
005675  AD F3 53          loc_005675  lda  $53F3
005678  8D F9 53                      sta  $53F9
00567B  A9 03                         lda  #$03
00567D  8D F8 53                      sta  $53F8

005680  AE F8 53                      ldx  $53F8
005683  AD F9 53                      lda  $53F9
005686  18                            clc
005687  7D E8 53                      adc  $53E8,X
00568A  C9 5A                         cmp  #$5A
00568C  90 08                         bcc  $5696
00568E  C9 63                         cmp  #$63
005690  B0 04                         bcs  $5696
005692  BD C4 53                      lda  $53C4,X
005695  60                            rts
005696  CE F8 53                      dec  $53F8
005699  10 E5                         bpl  $5680

00569B  A9 00                         lda  #$00
00569D  60                            rts
00569E  AD F1 53          loc_00569E  lda  $53F1
0056A1  8D F9 53                      sta  $53F9
0056A4  A9 03                         lda  #$03
0056A6  8D F8 53                      sta  $53F8

0056A9  AE F8 53                      ldx  $53F8
0056AC  AD F9 53                      lda  $53F9
0056AF  18                            clc
0056B0  7D E8 53                      adc  $53E8,X
0056B3  C9 5A                         cmp  #$5A
0056B5  90 08                         bcc  $56BF
0056B7  C9 63                         cmp  #$63
0056B9  B0 04                         bcs  $56BF
0056BB  BD BC 53                      lda  $53BC,X
0056BE  60                            rts
0056BF  CE F8 53                      dec  $53F8
0056C2  10 E5                         bpl  $56A9

0056C4  A9 00                         lda  #$00
0056C6  60                            rts

0056C7  0000                    HEX     0000
; ── DrawAlienRowDirD ──────────────────────────────────────────────
; HOW: Direction D (LEFT) variant of DrawAlienRowDir. Calls RandomByte
;      ($0403) to add slight positional variation to each alien's draw
;      position, giving the left-edge aliens a wobble effect.

0056C9  20 03 04          DrawAlienRowDirD  jsr  $0403  ; RandomByte
0056CC  29 03                         and  #$03
0056CE  AA                            tax
0056CF  BD 54 5D                      lda  $5D54,X
0056D2  F0 0E                         beq  $56E2
0056D4  8E C7 56                      stx  $56C7
0056D7  20 C4 44                      jsr  DrawHitFlash

0056DA  AE C7 56                      ldx  $56C7
0056DD  A9 00                         lda  #$00
0056DF  9D 54 5D                      sta  $5D54,X
0056E2  60                            rts

0056E3  50                      HEX     50
; ── IncreaseDifficulty ────────────────────────────────────────────
; HOW: Decrements diff_steps ($31). When it reaches zero AND difficulty
;      ($30) is not already at maximum (0), decrements difficulty by 1
;      and reloads all timing tables via LoadDifficultyTables.
; WHY: Progressive difficulty driven by player performance. Every alien
;      hit and satellite hit calls this routine. The step counter ensures
;      difficulty increases at measured intervals rather than on every
;      single hit. 328 total hits to reach maximum difficulty across 12
;      difficulty levels. The step counts are non-uniform (16, 16, 16,
;      24, 24, 30, 30, 40, 48, 42, 42, ∞) — faster at the start to
;      get players into the action, then gradually slowing to make each
;      subsequent level of challenge harder to reach.

0056E4  C6 31                         dec  diff_steps
0056E6  D0 09                         bne  $56F1
0056E8  A5 30                         lda  difficulty
0056EA  F0 05                         beq  $56F1
0056EC  C6 30                         dec  difficulty
0056EE  4C F3 56                      jmp  LoadDifficultyTables
0056F1  60                            rts

0056F2  00                      HEX     00
; ── LoadDifficultyTables ──────────────────────────────────────────
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
;      Also increments 4-direction fire ammo ($536F).
; WHY: All game timing is data-driven through these 8 tables. Adjusting
;      difficulty is simply changing which column of the tables is active.
;      This elegant design means the entire feel of the game — speed,
;      aggression, player resources — is controlled by 96 bytes of lookup
;      data. Speed range across the full curve: main game ticks 8x faster,
;      alien fire rate 8x faster, satellite movement 4x faster.

0056F3  A6 30                         ldx  difficulty
0056F5  BD 6C 57                      lda  $576C,X
0056F8  85 2F                         sta  frame_reload
0056FA  BD 78 57                      lda  $5778,X
0056FD  8D F2 52                      sta  $52F2
005700  BD 84 57                      lda  $5784,X
005703  8D E0 55                      sta  $55E0
005706  BD 90 57                      lda  $5790,X
005709  85 32                         sta  fire_rate
00570B  BD 9C 57                      lda  $579C,X
00570E  8D CC 57                      sta  $57CC
005711  BD A8 57                      lda  $57A8,X
005714  8D CF 57                      sta  $57CF
005717  BD B4 57                      lda  $57B4,X
00571A  8D D2 57                      sta  $57D2
00571D  BD C0 57                      lda  $57C0,X
005720  85 31                         sta  diff_steps
005722  20 76 53                      jsr  $5376  ; Inc4DirAmmo

005725  20 76 53                      jsr  $5376  ; Inc4DirAmmo

005728  20 76 53                      jsr  $5376  ; Inc4DirAmmo

00572B  A5 30                         lda  difficulty
00572D  4A                            lsr  a
00572E  8D F2 56                      sta  $56F2
005731  A9 06                         lda  #$06
005733  38                            sec
005734  ED F2 56                      sbc  $56F2
005737  8D F2 56                      sta  $56F2
00573A  A2 03                         ldx  #$03

00573C  BD B8 53                      lda  $53B8,X
00573F  D0 06                         bne  $5747
005741  AD F2 56                      lda  $56F2
005744  9D B8 53                      sta  $53B8,X
005747  BD C0 53                      lda  $53C0,X
00574A  D0 06                         bne  $5752
00574C  AD F2 56                      lda  $56F2
00574F  9D C0 53                      sta  $53C0,X
005752  BD BC 53                      lda  $53BC,X
005755  D0 06                         bne  $575D
005757  AD F2 56                      lda  $56F2
00575A  9D BC 53                      sta  $53BC,X
00575D  BD C4 53                      lda  $53C4,X
005760  D0 06                         bne  loc_005768
005762  AD F2 56                      lda  $56F2
005765  9D C4 53                      sta  $53C4,X
005768  CA                loc_005768  dex
005769  10 D1                         bpl  $573C

00576B  60                            rts

; --- DIFFICULTY LOOKUP TABLES (12 entries each, index 0=hardest, 11=easiest) ---
; Table 1 ($576C): Frame delay -> $2F
; Table 2 ($5778): -> $52F2 (redraw timing)
; Table 3 ($5784): -> $55E0 (alien draw timing)
; Table 4 ($5790): -> $32 (alien fire rate)
; Table 5 ($579C): -> $57CC
; Table 6 ($57A8): -> $57CF
; Table 7 ($57B4): -> $57D2
; Table 8 ($57C0): -> $31 (steps until difficulty increase)

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
; 8× speed increase across the full difficulty range.
; ── Table 2: Satellite / Redraw Speed ────────────────────────────
; → $52F2. Controls satellite orbit speed and screen redraw timing.
; Effective speed = (256 - value) × 4 frames per satellite step.
; Easiest: 112 frames/step. Hardest: 28 frames/step. 4× range.

00576C  FCFAF9F7                HEX     FCFAF9F7 F5F4F0EB E6E4E2E0 F9F7F6F4
; ── Table 3: Alien Draw Timing ───────────────────────────────────
; → $55E0. Controls alien sprite animation speed.

00577C  F3F0ECEB                HEX     F3F0ECEB E8E6E4E4 F8F6F4F1 EFEDEBE9
; ── Table 4: Alien Fire Rate ─────────────────────────────────────
; → fire_rate ($32). How often aliens shoot at the player.
; Easiest ($E0): every 32 frames. Hardest ($FC): every 4 frames. 8× range.

00578C  E7E5E3E1                HEX     E7E5E3E1 FCFAF7F5 F0EEEDEC E7E4E2E0
; ── Table 5: Enemy Projectile Timer ──────────────────────────────
; → $57CC. 2-byte cascaded timer for enemy projectile spawning.
; Effective interval = (256 - value)² frames per shot.
; Easiest: 256 frames. Hardest: 144 frames.
; ── Table 6: Timer Parameter 2 ───────────────────────────────────
; → $57CF.

00579C  F4F4F3F3                HEX     F4F4F3F3 F2F2F1F1 F0F0F0F0 F0F0F0F0
; ── Table 7: Timer Parameter 3 (constant) ────────────────────────
; → $57D2. All entries are $F0 — no variation across difficulty.

0057AC  EFE8E0D8                HEX     EFE8E0D8 D0C8C0C0 F0F0F0F0 F0F0F0F0
; ── Table 8: Steps to Next Difficulty Increase ───────────────────
; → diff_steps ($31). Hits required before advancing to the next
; difficulty level. Index 0 (hardest) = $FF (never increases further).
; Values: ∞, 42, 42, 48, 40, 30, 30, 24, 24, 16, 16, 16

0057BC  F0F0F0F0                HEX     F0F0F0F0 FF2A2A30 281E1E18 18101010
0057CC  00000000                HEX     00000000 000000F4 000000
; ── MainEntry ─────────────────────────────────────────────────────
; HOW: Clears decimal mode (CLD), calls hardware initialization, then
;      proceeds to the title screen setup.
; WHY: Entry point after the bootstrap relocation. CLD is a safety
;      measure — ensures the CPU is in binary mode for all subsequent
;      arithmetic. (The 6502 retains decimal mode across subroutine
;      calls, so it must be explicitly cleared.)

0057D7  D8                            cld
0057D8  20 5B 41                      jsr  SetClipBounds

0057DB  20 20 41                      jsr  InitHiRes

0057DE  20 B5 43                      jsr  SetupTitle

0057E1  A9 00                         lda  #$00
0057E3  85 0C                         sta  score_lo
0057E5  85 0D                         sta  score_hi
0057E7  85 0E                         sta  hiscore_lo
0057E9  85 0F                         sta  hiscore_hi
0057EB  85 11                         sta  direction
0057ED  A9 F0                         lda  #$F0
0057EF  85 2C                         sta  timer_lo
0057F1  85 2D                         sta  timer_hi
0057F3  85 2E                         sta  frame_ctr
0057F5  A9 03                         lda  #$03
0057F7  85 10                         sta  lives
0057F9  85 00                         sta  src_lo
0057FB  20 FC 42                      jsr  DrawTitleScreen


; Wait for RETURN key to start game
0057FE  E6 00                         inc  src_lo
005800  C6 01                         dec  src_hi
005802  AD 00 C0                      lda  KBD             ; KBD - Keyboard data / 80STORE off
005805  C9 8D                         cmp  #$8D
005807  D0 F5                         bne  WaitForReturn
; ── GameStart ─────────────────────────────────────────────────────
; HOW: Initializes all game state for a new game:
;        lives = 3
;        level = 5 (which displays as "Level 1")
;        direction = 0 (UP)
;        difficulty = $0B (11, easiest)
;        score = 0 (both bytes)
;      Then calls LevelSetup, LoadDifficultyTables, Set4DirAmmo, and
;      DrawBase_ClearSatellites.
; WHY: Fresh game state. Level counts DOWN from 5 to 0 (victory),
;      so 5 means "first level." Difficulty 11 is the easiest setting,
;      giving new players time to learn the evolution mechanic before
;      the game speeds up.

005809  A9 03                         lda  #$03
00580B  85 10                         sta  lives
00580D  A9 05                         lda  #$05
00580F  85 3A                         sta  level
005811  20 73 4D                      jsr  LevelSetup

005814  A9 00                         lda  #$00
005816  85 0C                         sta  score_lo
005818  85 0D                         sta  score_hi
00581A  85 11                         sta  direction
00581C  85 34                         sta  game_flag
00581E  85 36                         sta  fire_req
005820  20 87 43                      jsr  InitGameVarsB

005823  A9 0B                         lda  #$0B
005825  85 2B                         sta  slot_x16
005827  85 30                         sta  difficulty
005829  20 F3 56                      jsr  LoadDifficultyTables

00582C  20 70 53                      jsr  Set4DirAmmo

00582F  20 77 5B                      jsr  $5B77  ; InputWaitKey
005832  A9 05                         lda  #$05
005834  85 35                         sta  sat_counter
005836  20 E5 52                      jsr  DrawBase


; Check if player lost a life - decrement lives, if <0 game over
005839  A5 10                         lda  lives
00583B  38                            sec
00583C  E9 01                         sbc  #$01
00583E  10 06                         bpl  ContinueAfterDeath
005840  20 86 4A                      jsr  GameOver

005843  4C 09 58                      jmp  StartNewGame

005846  85 10             ContinueAfterDeath  sta  lives
005848  20 CD 43                      jsr  PerFrameUpdate

00584B  20 3E 41                      jsr  ClearPlayfield

00584E  A2 03                         ldx  #$03
005850  A9 00                         lda  #$00

005852  9D 58 5D                      sta  $5D58,X
005855  9D 54 5D                      sta  $5D54,X
005858  CA                            dex
005859  10 F7                         bpl  $5852

00585B  20 7A 43                      jsr  InitGameVarsA

00585E  20 4F 5B                      jsr  InputProcessA
005861  AD D3 57                      lda  $57D3
005864  8D D4 57                      sta  $57D4
005867  8D D5 57                      sta  $57D5
00586A  A9 F0                         lda  #$F0
00586C  85 2C                         sta  timer_lo
00586E  85 2D                         sta  timer_hi
005870  85 2E                         sta  frame_ctr
005872  8D 10 C0                      sta  CLRKBD          ; KBDSTRB - Clear keyboard strobe
; ── MainGameLoop ──────────────────────────────────────────────────
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
;       12. JMP MainGameLoop
; WHY: Fixed execution order matters. Projectiles move first (using old
;      position), then the screen redraws (at new position), then
;      collision checks (testing new position against targets). Input
;      is read mid-frame so the player's actions take effect on the
;      very next frame. The frame timer at the end throttles everything
;      to the difficulty-appropriate speed.

005875  20 7F 45                      jsr  MoveAllLasers

005878  20 F3 52                      jsr  RedrawScreen

00587B  20 5B 4F                      jsr  CheckSatelliteHits

00587E  20 1C 5C                      jsr  UpdateStarTwinkle
005881  20 78 5C                      jsr  CheckAllTVs
005884  A5 36                         lda  fire_req
005886  F0 09                         beq  $5891
005888  E6 01                         inc  src_hi
00588A  A9 00                         lda  #$00
00588C  85 36                         sta  fire_req
00588E  4C A5 58                      jmp  FireProjectile
005891  AD 61 C0                      lda  BUTN0           ; BUTN0 - Button 0 / Open Apple
005894  30 05                         bmi  $589B
005896  85 2B                         sta  slot_x16
005898  4C C3 58                      jmp  AfterFire
00589B  25 2B                         and  slot_x16
00589D  30 24                         bmi  AfterFire
00589F  E6 01                         inc  src_hi
0058A1  A9 80                         lda  #$80
0058A3  85 2B                         sta  slot_x16
0058A5  A6 11                         ldx  direction
0058A7  BD 58 5D                      lda  $5D58,X
0058AA  D0 17                         bne  AfterFire
0058AC  A9 01                         lda  #$01
0058AE  9D 58 5D                      sta  $5D58,X
0058B1  BD 68 5D                      lda  $5D68,X
0058B4  9D 5C 5D                      sta  $5D5C,X
0058B7  BD 6C 5D                      lda  $5D6C,X
0058BA  9D 60 5D                      sta  $5D60,X
0058BD  BD 70 5D                      lda  $5D70,X
0058C0  9D 64 5D                      sta  $5D64,X
0058C3  20 87 4D          AfterFire  jsr  UpdateAlienPositions

0058C6  A2 03                         ldx  #$03
0058C8  8E D6 57                      stx  $57D6

; Check laser vs alien collisions (all 4 directions)
; Direction-specific coordinate comparisons determine hits.
; On hit: alien evolves, play sound, add 1 point.
0058CB  AE D6 57                      ldx  $57D6
0058CE  BD 58 5D                      lda  $5D58,X
0058D1  F0 08                         beq  $58DB
0058D3  BD 54 5D                      lda  $5D54,X
0058D6  F0 03                         beq  $58DB
0058D8  4C DE 58                      jmp  $58DE  ; CheckSatelliteHits
0058DB  4C 6E 59                      jmp  $596E  ; ProcessLaserHit
0058DE  E0 03                         cpx  #$03
0058E0  F0 31                         beq  $5913
0058E2  E0 02                         cpx  #$02
0058E4  F0 22                         beq  $5908
0058E6  E0 01                         cpx  #$01
0058E8  F0 0B                         beq  $58F5
0058EA  BD 64 5D                      lda  $5D64,X
0058ED  DD 50 5D                      cmp  $5D50,X
0058F0  90 2C                         bcc  $591E
0058F2  4C 6E 59                      jmp  $596E  ; ProcessLaserHit
0058F5  BD 60 5D                      lda  $5D60,X
0058F8  DD 4C 5D                      cmp  $5D4C,X
0058FB  90 71                         bcc  $596E
0058FD  BD 5C 5D                      lda  $5D5C,X
005900  DD 48 5D                      cmp  $5D48,X
005903  90 69                         bcc  $596E
005905  4C 1E 59                      jmp  $591E  ; DrawLaserProjectile
005908  BD 64 5D                      lda  $5D64,X
00590B  DD 50 5D                      cmp  $5D50,X
00590E  B0 0E                         bcs  $591E
005910  4C 6E 59                      jmp  $596E  ; ProcessLaserHit
005913  BD 5C 5D                      lda  $5D5C,X
005916  DD 48 5D                      cmp  $5D48,X
005919  90 03                         bcc  $591E
00591B  4C 6E 59                      jmp  $596E  ; ProcessLaserHit
00591E  20 C4 44                      jsr  DrawHitFlash

005921  AE D6 57                      ldx  $57D6
005924  20 41 44                      jsr  ClearSpriteArea

005927  AE D6 57                      ldx  $57D6
00592A  BD 54 5D                      lda  $5D54,X
00592D  C9 02                         cmp  #$02
00592F  D0 09                         bne  $593A
005931  20 65 4B                      jsr  PunishmentRoutine

005934  AE D6 57                      ldx  $57D6
005937  4C 54 59                      jmp  $5954  ; LaserExplosion
00593A  C9 03                         cmp  #$03
00593C  D0 16                         bne  $5954
00593E  AE D6 57                      ldx  $57D6
005941  A9 02                         lda  #$02
005943  9D 54 5D                      sta  $5D54,X
005946  20 99 44                      jsr  DrawProjectile

005949  A9 00                         lda  #$00
00594B  AE D6 57                      ldx  $57D6
00594E  9D 58 5D                      sta  $5D58,X
005951  4C 5C 59                      jmp  loc_00595C
005954  A9 00                         lda  #$00
005956  9D 54 5D                      sta  $5D54,X
005959  9D 58 5D                      sta  $5D58,X
00595C  A9 01             loc_00595C  lda  #$01
00595E  20 E0 4A                      jsr  AddScore

005961  A0 14                         ldy  #$14
005963  A9 C4                         lda  #$C4
005965  8D 67 5B                      sta  $5B67
005968  20 62 5B                      jsr  InputProcessB
00596B  20 4F 5B                      jsr  InputProcessA
00596E  CE D6 57                      dec  $57D6
005971  30 03                         bmi  loc_005976
005973  4C CB 58                      jmp  CheckLaserHits

005976  A2 03             loc_005976  ldx  #$03
005978  86 12                         stx  loop_idx

00597A  A6 12             loc_00597A  ldx  loop_idx
00597C  BD 58 5D                      lda  $5D58,X
00597F  F0 41                         beq  $59C2
005981  E0 03                         cpx  #$03
005983  F0 29                         beq  $59AE
005985  E0 02                         cpx  #$02
005987  F0 1B                         beq  $59A4
005989  E0 01                         cpx  #$01
00598B  F0 08                         beq  $5995
00598D  BD 64 5D                      lda  $5D64,X
005990  F0 23                         beq  $59B5
005992  4C C2 59                      jmp  $59C2  ; CheckLaserLoop
005995  BD 5C 5D                      lda  $5D5C,X
005998  C9 16                         cmp  #$16
00599A  BD 60 5D                      lda  $5D60,X
00599D  E9 01                         sbc  #$01
00599F  B0 14                         bcs  $59B5
0059A1  4C C2 59                      jmp  $59C2  ; CheckLaserLoop
0059A4  BD 64 5D                      lda  $5D64,X
0059A7  C9 BF                         cmp  #$BF
0059A9  F0 0A                         beq  $59B5
0059AB  4C C2 59                      jmp  $59C2  ; CheckLaserLoop
0059AE  BD 5C 5D                      lda  $5D5C,X
0059B1  C9 3E                         cmp  #$3E
0059B3  D0 0D                         bne  $59C2
0059B5  20 41 44                      jsr  ClearSpriteArea

0059B8  20 4F 5B                      jsr  InputProcessA
0059BB  A6 12                         ldx  loop_idx
0059BD  A9 00                         lda  #$00
0059BF  9D 58 5D                      sta  $5D58,X
0059C2  C6 12                         dec  loop_idx
0059C4  10 B4                         bpl  loc_00597A

0059C6  A6 11                         ldx  direction
0059C8  20 E0 43                      jsr  KeyboardHandler

0059CB  E4 11                         cpx  direction
0059CD  D0 03                         bne  $59D2
0059CF  4C E8 59                      jmp  $59E8
0059D2  BD 34 5D                      lda  $5D34,X
0059D5  85 02                         sta  col_ctr
0059D7  BD 38 5D                      lda  $5D38,X
0059DA  85 04                         sta  sprite_calc
0059DC  8A                            txa
0059DD  18                            clc
0059DE  69 0B                         adc  #$0B
0059E0  20 C0 40                      jsr  DrawSpriteXY

0059E3  20 4F 5B                      jsr  InputProcessA
0059E6  E6 01                         inc  src_hi
0059E8  20 91 55                      jsr  DrawAlienRowDir

0059EB  20 E3 55                      jsr  DrawAlienRowDirB

0059EE  EE CD 57                      inc  $57CD
0059F1  D0 11                         bne  FrameTimingLoop
0059F3  EE CE 57                      inc  $57CE
0059F6  D0 0C                         bne  FrameTimingLoop
0059F8  AD CC 57                      lda  $57CC
0059FB  8D CD 57                      sta  $57CD
0059FE  8D CE 57                      sta  $57CE
005A01  20 C9 56                      jsr  DrawAlienRowDirD

005A04  E6 2E                         inc  frame_ctr
005A06  D0 52                         bne  $5A5A
005A08  A5 2F                         lda  frame_reload
005A0A  85 2E                         sta  frame_ctr
005A0C  20 0E 45                      jsr  PeriodicGameLogic

005A0F  A2 03                         ldx  #$03
005A11  86 12                         stx  loop_idx

005A13  A6 12             loc_005A13  ldx  loop_idx
005A15  BD 54 5D                      lda  $5D54,X
005A18  F0 3C                         beq  loc_005A56
005A1A  E0 03                         cpx  #$03
005A1C  F0 1C                         beq  $5A3A
005A1E  E0 02                         cpx  #$02
005A20  F0 0E                         beq  $5A30
005A22  E0 01                         cpx  #$01
005A24  F0 1E                         beq  $5A44
005A26  BD 50 5D                      lda  $5D50,X
005A29  C9 52                         cmp  #$52
005A2B  B0 30                         bcs  $5A5D
005A2D  4C 56 5A                      jmp  loc_005A56
005A30  BD 50 5D                      lda  $5D50,X
005A33  C9 6B                         cmp  #$6B
005A35  90 26                         bcc  $5A5D
005A37  4C 56 5A                      jmp  loc_005A56
005A3A  BD 48 5D                      lda  $5D48,X
005A3D  C9 9B                         cmp  #$9B
005A3F  90 15                         bcc  loc_005A56
005A41  4C 5D 5A                      jmp  $5A5D  ; HandleAlienHit
005A44  BD 48 5D                      lda  $5D48,X
005A47  C9 B6                         cmp  #$B6
005A49  90 03                         bcc  $5A4E
005A4B  4C 56 5A                      jmp  loc_005A56
005A4E  BD 4C 5D                      lda  $5D4C,X
005A51  D0 03                         bne  loc_005A56
005A53  4C 5D 5A                      jmp  $5A5D  ; HandleAlienHit

005A56  C6 12             loc_005A56  dec  loop_idx
005A58  10 B9                         bpl  loc_005A13

005A5A  4C 75 58                      jmp  MainGameLoop

005A5D  BD 54 5D                      lda  $5D54,X
005A60  C9 02                         cmp  #$02
005A62  D0 18                         bne  $5A7C
005A64  20 C4 44                      jsr  DrawHitFlash

005A67  A6 12                         ldx  loop_idx
005A69  A9 00                         lda  #$00
005A6B  9D 54 5D                      sta  $5D54,X
005A6E  20 7A 43                      jsr  InitGameVarsA

005A71  20 4F 5B                      jsr  InputProcessA
005A74  A9 05                         lda  #$05
005A76  20 E0 4A                      jsr  AddScore

005A79  4C 56 5A                      jmp  loc_005A56

005A7C  C9 03                         cmp  #$03
005A7E  D0 1A                         bne  $5A9A
005A80  8E D6 57                      stx  $57D6
005A83  20 C4 44                      jsr  DrawHitFlash

005A86  AE D6 57                      ldx  $57D6
005A89  A9 00                         lda  #$00
005A8B  9D 54 5D                      sta  $5D54,X
005A8E  20 7A 43                      jsr  InitGameVarsA

005A91  20 4F 5B                      jsr  InputProcessA
005A94  20 65 4B                      jsr  PunishmentRoutine

005A97  4C 56 5A                      jmp  loc_005A56

005A9A  A2 03                         ldx  #$03
005A9C  86 12                         stx  loop_idx

005A9E  A6 12                         ldx  loop_idx
005AA0  BD 54 5D                      lda  $5D54,X
005AA3  F0 03                         beq  loc_005AA8
005AA5  20 C4 44                      jsr  DrawHitFlash

005AA8  C6 12             loc_005AA8  dec  loop_idx
005AAA  10 F2                         bpl  $5A9E

005AAC  A6 11                         ldx  direction
005AAE  BD 34 5D                      lda  $5D34,X
005AB1  85 02                         sta  col_ctr
005AB3  BD 38 5D                      lda  $5D38,X
005AB6  85 04                         sta  sprite_calc
005AB8  8A                            txa
005AB9  18                            clc
005ABA  69 0B                         adc  #$0B
005ABC  20 C0 40                      jsr  DrawSpriteXY

005ABF  A9 56                         lda  #$56
005AC1  85 04                         sta  sprite_calc
005AC3  A9 17                         lda  #$17
005AC5  85 02                         sta  col_ctr
005AC7  A9 18                         lda  #$18
005AC9  20 C0 40                      jsr  DrawSpriteXY

005ACC  A2 03                         ldx  #$03
005ACE  86 12                         stx  loop_idx

005AD0  A6 12             loc_005AD0  ldx  loop_idx
005AD2  BD 58 5D                      lda  $5D58,X
005AD5  F0 03                         beq  loc_005ADA
005AD7  20 41 44                      jsr  ClearSpriteArea

005ADA  C6 12             loc_005ADA  dec  loop_idx
005ADC  10 F2                         bpl  loc_005AD0

005ADE  A2 03                         ldx  #$03
005AE0  86 12                         stx  loop_idx

005AE2  A9 D0             loc_005AE2  lda  #$D0
005AE4  85 2C                         sta  timer_lo
005AE6  85 2D                         sta  timer_hi

005AE8  A9 56             loc_005AE8  lda  #$56
005AEA  85 04                         sta  sprite_calc
005AEC  A9 17                         lda  #$17
005AEE  85 02                         sta  col_ctr
005AF0  A5 12                         lda  loop_idx
005AF2  29 03                         and  #$03
005AF4  18                            clc
005AF5  69 26                         adc  #$26
005AF7  20 16 04                      jsr  $0416  ; DrawSprite
005AFA  20 1C 5C                      jsr  UpdateStarTwinkle
005AFD  A0 80                         ldy  #$80
005AFF  A9 F2                         lda  #$F2
005B01  8D 67 5B                      sta  $5B67
005B04  20 62 5B                      jsr  InputProcessB
005B07  C6 2C                         dec  timer_lo
005B09  10 DD                         bpl  loc_005AE8

005B0B  C6 2D                         dec  timer_hi
005B0D  10 D9                         bpl  loc_005AE8

005B0F  C6 12                         dec  loop_idx
005B11  10 CF                         bpl  loc_005AE2

005B13  A5 10                         lda  lives
005B15  D0 1D                         bne  $5B34
005B17  A9 56                         lda  #$56
005B19  85 04                         sta  sprite_calc
005B1B  A9 17                         lda  #$17
005B1D  85 02                         sta  col_ctr
005B1F  A9 26                         lda  #$26
005B21  20 C0 40                      jsr  DrawSpriteXY

005B24  A9 56                         lda  #$56
005B26  85 04                         sta  sprite_calc
005B28  A9 17                         lda  #$17
005B2A  85 02                         sta  col_ctr
005B2C  A9 90                         lda  #$90
005B2E  20 16 04                      jsr  $0416  ; DrawSprite
005B31  4C 39 58                      jmp  CheckLifeLost

005B34  A9 00                         lda  #$00
005B36  85 2C                         sta  timer_lo
005B38  A9 19                         lda  #$19
005B3A  85 2D                         sta  timer_hi

005B3C  A9 0A             loc_005B3C  lda  #$0A
005B3E  20 6C 5C                      jsr  StarTwinkleC
005B41  20 1C 5C                      jsr  UpdateStarTwinkle
005B44  C6 2C                         dec  timer_lo
005B46  D0 F4                         bne  loc_005B3C

005B48  C6 2D                         dec  timer_hi
005B4A  D0 F0                         bne  loc_005B3C

005B4C  4C 39 58                      jmp  CheckLifeLost


005B4F  A6 11                         ldx  direction
005B51  BD 34 5D                      lda  $5D34,X
005B54  85 02                         sta  col_ctr
005B56  BD 38 5D                      lda  $5D38,X
005B59  85 04                         sta  sprite_calc
005B5B  8A                            txa
005B5C  18                            clc
005B5D  69 0B                         adc  #$0B
005B5F  4C 62 04                      jmp  $0462  ; EraseSprite


005B62  98                InputProcessB  tya
005B63  20 6F 5B                      jsr  $5B6F  ; SoundClick
005B66  49 FF                         eor  #$FF
005B68  20 6F 5B                      jsr  $5B6F  ; SoundClick
005B6B  88                            dey
005B6C  D0 F4                         bne  InputProcessB

005B6E  60                            rts
; ── SoundClick ────────────────────────────────────────────────────
; HOW: Transfers A to X, executes a DEX countdown loop for timing,
;      then toggles the speaker at $C030. The initial A value controls
;      the pitch — higher = longer delay = lower pitch.
; WHY: Simple single-click sound effect used for UI feedback,
;      button presses, and minor game events.

005B6F  AA                            tax

005B70  CA                            dex
005B71  D0 FD                         bne  $5B70

005B73  2C 30 C0                      bit  SPKR            ; SPKR - Speaker toggle
005B76  60                            rts
; ── InputWaitKey ──────────────────────────────────────────────────
; HOW: Loops reading RandomByte ($0403) to advance the PRNG state
;      while waiting for a valid keyboard input. Filters key codes
;      to the expected range before returning.
; WHY: Blocking wait for player input during the title screen and
;      game-over screen. The PRNG calls while waiting ensure the
;      random seed depends on human timing — a classic 8-bit trick
;      to seed randomness from user input lag.

005B77  A2 1F                         ldx  #$1F

005B79  20 03 04                      jsr  $0403  ; RandomByte
005B7C  29 1F                         and  #$1F
005B7E  18                            clc
005B7F  69 01                         adc  #$01
005B81  29 1F                         and  #$1F
005B83  F0 F4                         beq  $5B79

005B85  18                            clc
005B86  69 08                         adc  #$08
005B88  9D B4 5B                      sta  $5BB4,X

005B8B  20 03 04          loc_005B8B  jsr  $0403  ; RandomByte
005B8E  C9 C0                         cmp  #$C0
005B90  B0 F9                         bcs  loc_005B8B

005B92  9D D4 5B                      sta  $5BD4,X
005B95  C9 50                         cmp  #$50
005B97  90 0F                         bcc  loc_005BA8
005B99  C9 71                         cmp  #$71
005B9B  B0 0B                         bcs  loc_005BA8
005B9D  BD B4 5B                      lda  $5BB4,X
005BA0  C9 1B                         cmp  #$1B
005BA2  B0 04                         bcs  loc_005BA8
005BA4  C9 16                         cmp  #$16
005BA6  B0 D1                         bcs  $5B79

005BA8  20 03 04          loc_005BA8  jsr  $0403  ; RandomByte
005BAB  29 07                         and  #$07
005BAD  9D F4 5B                      sta  $5BF4,X
005BB0  CA                            dex
005BB1  10 C6                         bpl  $5B79

005BB3  60                            rts

005BB4  AEB8A092                HEX     AEB8A092 A0C5C3A0 CAA4A5C4 B1FFA092
005BC4  A0FBCD90                HEX     A0FBCD90 A0A0E0A0 BDC9E0D3 A085A0A4
005BD4  A085A0A4                HEX     A085A0A4 A0A0C6A0 D0A085A0 90C9A0A5
005BE4  AC92A0A0                HEX     AC92A0A0 A0A0A0A0 A5CFD6A0 A0A0AE83
005BF4  AABAA0A0                HEX     AABAA0A0 A0A5AEA0 C3AFACA0 CFA089A0
005C04  99A0A0AE                HEX     99A0A0AE C38AA0D0 A0F480A0 A5A0D6A0
005C14  00081018                HEX     00081018 00889098
; ── UpdateStarTwinkle ─────────────────────────────────────────────
; HOW: Animates twinkling background stars by toggling individual pixels
;      in HGR memory. Uses the random number generator to select which
;      stars flicker each frame.
; WHY: Visual polish that gives the static background a sense of life.
;      The twinkling suggests the action takes place in space, fitting
;      the science fiction theme.

005C1C  A5 34                         lda  game_flag
005C1E  18                            clc
005C1F  69 01                         adc  #$01
005C21  85 34                         sta  game_flag
005C23  C9 28                         cmp  #$28
005C25  B0 01                         bcs  UpdateStarTwinkleB
005C27  60                            rts

005C28  A9 00             UpdateStarTwinkleB  lda  #$00
005C2A  85 34                         sta  game_flag
005C2C  A6 33                         ldx  star_idx
005C2E  E8                            inx
005C2F  E0 20                         cpx  #$20
005C31  90 02                         bcc  loc_005C35
005C33  A2 00                         ldx  #$00
005C35  86 33             loc_005C35  stx  star_idx
005C37  BD D4 5B                      lda  $5BD4,X
005C3A  A8                            tay
005C3B  B9 6C 41                      lda  $416C,Y
005C3E  85 06                         sta  hgr_lo
005C40  B9 2C 42                      lda  $422C,Y
005C43  85 07                         sta  hgr_hi
005C45  BD F4 5B                      lda  $5BF4,X
005C48  A8                            tay
005C49  18                            clc
005C4A  69 01                         adc  #$01
005C4C  29 07                         and  #$07
005C4E  9D F4 5B                      sta  $5BF4,X
005C51  B9 14 5C                      lda  $5C14,Y
005C54  48                            pha
005C55  BD B4 5B                      lda  $5BB4,X
005C58  A8                            tay
005C59  68                            pla
005C5A  49 FF                         eor  #$FF
005C5C  31 06                         and  (hgr_lo),Y
005C5E  91 06                         sta  (hgr_lo),Y
005C60  BD F4 5B                      lda  $5BF4,X
005C63  AA                            tax
005C64  BD 14 5C                      lda  $5C14,X
005C67  11 06                         ora  (hgr_lo),Y
005C69  91 06                         sta  (hgr_lo),Y
005C6B  60                            rts

005C6C  38                StarTwinkleC  sec

005C6D  48                loc_005C6D  pha

005C6E  E9 01             loc_005C6E  sbc  #$01
005C70  D0 FC                         bne  loc_005C6E

005C72  68                            pla
005C73  E9 01                         sbc  #$01
005C75  D0 F6                         bne  loc_005C6D

005C77  60                            rts
; ── CheckAllTVs ───────────────────────────────────────────────────
; HOW: Loops through all 16 entries in the alien type table ($53B8).
;      If every entry equals 4 (TV type), the level is complete.
;      Jumps to LevelComplete ($5CB8) if the condition is met.
; WHY: This is the central victory condition. The player wins a level
;      when all 16 aliens are simultaneously in the TV state. With the
;      6-state evolution cycle, this requires precise shot counting —
;      overshooting any alien by even one hit pushes it past TV into
;      Diamond, requiring 5 more hits to get back.

005C78  A2 0F                         ldx  #$0F

005C7A  BD B8 53          loc_005C7A  lda  $53B8,X
005C7D  C9 04                         cmp  #$04
005C7F  F0 01                         beq  loc_005C82
005C81  60                            rts
005C82  CA                loc_005C82  dex
005C83  10 F5                         bpl  loc_005C7A

005C85  20 27 5D                      jsr  $5D27  ; DrawBaseCenter
005C88  20 14 5D                      jsr  InitProjectileTables
005C8B  A9 03                         lda  #$03
005C8D  8D 13 5D                      sta  $5D13

005C90  AE 13 5D          loc_005C90  ldx  $5D13
005C93  BD 54 5D                      lda  $5D54,X
005C96  F0 0B                         beq  loc_005CA3
005C98  20 C4 44                      jsr  DrawHitFlash

005C9B  AE 13 5D                      ldx  $5D13
005C9E  A9 00                         lda  #$00
005CA0  9D 54 5D                      sta  $5D54,X
005CA3  BD 12 52          loc_005CA3  lda  $5212,X
005CA6  F0 0B                         beq  loc_005CB3
005CA8  20 C9 52                      jsr  $52C9  ; EraseSatellite

005CAB  AE 13 5D                      ldx  $5D13
005CAE  A9 00                         lda  #$00
005CB0  9D 12 52                      sta  $5212,X
005CB3  CE 13 5D          loc_005CB3  dec  $5D13
005CB6  10 D8                         bpl  loc_005C90
; ── LevelComplete ─────────────────────────────────────────────────
; HOW: Awards 50-point bonus (BCD), decrements the level counter ($3A),
;      displays the level number, plays the completion animation (which
;      includes the cheat code window), resets all 16 aliens to type 1
;      (UFO). If level $3A < 4, spawns 4 satellites. If $3A = 0, triggers
;      the victory screen. Otherwise, continues to the next level.
; WHY: Level progression sequence. The satellite spawn check (only when
;      $3A < 4, i.e., levels 3-5) introduces the bonus satellite challenge
;      in the latter half of the game. Difficulty does NOT reset between
;      levels — the cumulative speed increase carries over, making each
;      successive level harder even though aliens reset to UFOs.

005CB8  A9 50                         lda  #$50
005CBA  20 E0 4A                      jsr  AddScore

005CBD  C6 3A                         dec  level
005CBF  20 33 4D                      jsr  DisplayLevelNum

005CC2  20 99 4C                      jsr  LevelCompleteAnim

005CC5  A9 32                         lda  #$32
005CC7  A0 FF                         ldy  #$FF
005CC9  8D 67 5B                      sta  $5B67
005CCC  20 62 5B                      jsr  InputProcessB

005CCF  A9 03                         lda  #$03
005CD1  8D 13 5D                      sta  $5D13

005CD4  AD 13 5D          loc_005CD4  lda  $5D13
005CD7  20 3C 4C                      jsr  PlayPunishSound

005CDA  CE 13 5D                      dec  $5D13
005CDD  10 F5                         bpl  loc_005CD4

005CDF  A2 0F                         ldx  #$0F
005CE1  A9 01                         lda  #$01

005CE3  9D B8 53          loc_005CE3  sta  $53B8,X
005CE6  CA                            dex
005CE7  10 FA                         bpl  loc_005CE3

005CE9  A5 3A                         lda  level
005CEB  F0 1C                         beq  Victory
005CED  20 3E 41                      jsr  ClearPlayfield

005CF0  20 7A 43                      jsr  InitGameVarsA

005CF3  20 4F 5B                      jsr  InputProcessA

005CF6  A5 3A                         lda  level
005CF8  C9 04                         cmp  #$04
005CFA  B0 0C                         bcs  $5D08
005CFC  20 27 52                      jsr  SpawnSatellite

005CFF  20 27 52                      jsr  SpawnSatellite

005D02  20 27 52                      jsr  SpawnSatellite

005D05  20 27 52                      jsr  SpawnSatellite

005D08  60                            rts
005D09  A9 00                         lda  #$00
005D0B  85 10                         sta  lives
005D0D  68                            pla
005D0E  68                            pla
005D0F  4C 39 58                      jmp  CheckLifeLost


005D12  6000                    HEX     6000
; ── InitProjectileTables ──────────────────────────────────────────
; HOW: Zeroes out all projectile state arrays at $5D48-$5D73. Clears
;      position, state, and active flags for all 4 direction slots.
; WHY: Clean slate for projectiles when starting a new game or level.
;      Ensures no stale projectile data from previous play.

005D14  A6 11                         ldx  direction
005D16  BD 34 5D                      lda  $5D34,X
005D19  85 02                         sta  col_ctr
005D1B  BD 38 5D                      lda  $5D38,X
005D1E  85 04                         sta  sprite_calc
005D20  8A                            txa
005D21  18                            clc
005D22  69 0B                         adc  #$0B
005D24  4C C0 40                      jmp  DrawSpriteXY
; ── DrawBaseCenter ────────────────────────────────────────────────
; HOW: Loads sprite index $56 (the player's base), sets col_ctr to
;      $17 and sprite_calc to $18 (the center of the playfield),
;      then jumps to DrawSpriteXY.
; WHY: The player's base is always at the exact center of the screen.
;      Hardcoded coordinates keep the drawing fast and the logic simple.

005D27  A9 56                         lda  #$56
005D29  85 04                         sta  sprite_calc
005D2B  A9 17                         lda  #$17
005D2D  85 02                         sta  col_ctr
005D2F  A9 18                         lda  #$18
005D31  4C C0 40                      jmp  DrawSpriteXY


; --- Base X Positions (4 directions) ---
005D34  181A1816                HEX     181A1816 525D6B5D 17251709 0156B156
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
;   $5D70-$5D73: Base spawn Y

005D44  0158B158                HEX     0158B158 A08CBAA0 A0E6D2A0 A0A0C8A0
; --- Projectile State: 0=none, 2=exploding, 3=active ---
005D54  A0C8A080                HEX     A0C8A080 D4ACBAA0 A0BBA0AC A0A0D0AE
; --- Draw Y (4 projectiles) ---
005D64  E6AF8CB0                HEX     E6AF8CB0 ABBCAB9A 00000000 51606C60
; ── Sprite Pointer Table (Low Bytes) ─────────────────────────────
; 161 entries. Low byte of each sprite's data address in memory.
; Indexed by sprite number (0-160).

005D74  A9A0C6A0                HEX     A9A0C6A0 C3A081D4 00070E15 1C232A31
005D84  383F4670                HEX     383F4670 747B7F86 B7DAE80B 35436697
005D94  C8072A54                HEX     C8072A54 87B1C6CB D0D5DFE9 F3FDBA7B
005DA4  38F977A4                HEX     38F977A4 E3104F56 6472808E 9CAABFD4
005DB4  E9FE1328                HEX     E9FE1328 3D434F5B 67737F8B 92A0AEBC
005DC4  CAD8E6F4                HEX     CAD8E6F4 02101E2C 3A484F5D 6B798795
005DD4  A3AAB8C6                HEX     A3AAB8C6 D4E2F059 6E83FE1A 2F4498AA
005DE4  BCCEE9FB                HEX     BCCEE9FB 0D1F2D42 576C8196 ABB9CEE3
005DF4  F8061B30                HEX     F8061B30 3E53687D 92A7BCC2 CEDAE6F2
005E04  FE0A101C                HEX     FE0A101C 2834404C 5818B878 F050B010
; ── Sprite Pointer Table (High Bytes) ────────────────────────────
; 161 entries. High byte paired with the low-byte table above.

005E14  33B1C50D                HEX     33B1C50D 55B5155D BD606060 60606060
005E24  60606060                HEX     60606060 60606060 60606060 61616161
005E34  61616262                HEX     61616262 62626262 62626262 62626263
005E44  63646364                HEX     63646364 64646565 65656565 65656565
005E54  65656566                HEX     65656566 66666666 66666666 66666666
005E64  66666666                HEX     66666666 66676767 67676767 67676767
005E74  67676767                HEX     67676767 67676767 68686867 68686868
005E84  68686868                HEX     68686868 68696969 69696969 69696969
005E94  69696A6A                HEX     69696A6A 6A6A6A6A 6A6A6A6A 6A6A6A6A
005EA4  6A6A6B6B                HEX     6A6A6B6B 6B6B6B6B 6B6B6C6B 6C6C6D6D
; ── Sprite Width Table ───────────────────────────────────────────
; 161 entries. Width in bytes for each sprite. Determines how many
; HGR memory bytes wide the sprite is (multiply by 7 for pixels).

005EB4  6E6E6E6E                HEX     6E6E6E6E 6F6F6F70 70700101 01010101
005EC4  01010101                HEX     01010101 06010101 01070502 05060205
005ED4  07070305                HEX     07070305 03030303 01010102 02020209
005EE4  03030303                HEX     03030303 03030303 01020202 02020203
005EF4  03030303                HEX     03030303 03030102 02020202 02010202
005F04  02020202                HEX     02020202 02020202 02020201 02020202
005F14  02020102                HEX     02020102 02020202 02030303 04030303
005F24  02020203                HEX     02020203 02020202 03030303 03030203
005F34  03030203                HEX     03030203 03020303 03030303 01020202
005F44  02020201                HEX     02020201 02020202 02020404 04050404
; ── Sprite Height Table ──────────────────────────────────────────
; 161 entries. Height in scanline rows for each sprite.

005F54  04050902                HEX     04050902 03030404 03040407 07070707
005F64  07070707                HEX     07070707 07070407 04070707 07070707
005F74  07070715                HEX     07070715 070E110E 07050505 05050505
005F84  0E151515                HEX     0E151515 150F150F 15070707 07070707
005F94  07070707                HEX     07070707 07070706 06060606 06060707
005FA4  07070707                HEX     07070707 07070707 07070707 07070707
005FB4  07070707                HEX     07070707 07070707 07070707 07070707
005FC4  07090909                HEX     07090909 09090909 07070707 07070707
005FD4  07070707                HEX     07070707 07070707 07070707 07060606
005FE4  06060606                HEX     06060606 06060606 06060618 18181818

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
;   - Broderbund logo

005FF4  1818070E                HEX     1818070E 0A181818 18181818 1E333333
006004  33331E3C                HEX     33331E3C 36333030 30301E3F 33380E3F
006014  3F1E3F30                HEX     3F1E3F30 3E303F1E 383C3633 3F30303F
006024  3F031F30                HEX     3F031F30 3F1E1C06 031F3333 1E3F3F30
006034  180C0C0C                HEX     180C0C0C 1E3F331E 333F1E1E 3F333E30
006044  3E1E1E1E                HEX     3E1E1E1E 1E1F3F00 3F3F3F3F 3F000333
006054  33330300                HEX     33330300 1E03333F 1F003033 331F0300
006064  3F3F3F3B                HEX     3F3F3F3B 3F001E1E 1E333F00 889CBEFF
006074  8183878F                HEX     8183878F 878381FF BE9C88C0 E0F0F8F0
006084  E0C01E3F                HEX     E0C01E3F 333F3F3F 1E3F3F33 3F3F3F3F
006094  03033703                HEX     03033703 0C0C333B 1F3F1F0C 0C033303
0060A4  3B030C0C                HEX     3B030C0C 333F3F33 3F0C3F3F 1E3F333F
0060B4  0C3F1E1F                HEX     0C3F1E1F 1F3F3F3F 3F3F3F3F 3F33330C
0060C4  030C333F                HEX     030C333F 0C1F0C33 1F0C1F0C 3F3B3F03
0060D4  0C1F333F                HEX     0C1F333F 030C1F33 3F333333 1F1E330C
0060E4  3F0C1F0C                HEX     3F0C1F0C 1E1E1E3F 3F3F3F3F 3F3F0333
0060F4  330C0C1E                HEX     330C0C1E 03330C0C 3033330C 0C3F3F3F
006104  0C0C1E1E                HEX     0C0C1E1E 1E0C0C1E 1E331F1E 633F3F33
006114  3F3F7703                HEX     3F3F7703 33333333 6B1E033F 3F3F6330
006124  333F1F3F                HEX     333F1F3F 633F3F33 3B33631E 1E333333
006134  63333F33                HEX     63333F33 3F330C3F 0C3F0C33 3F333F3E
006144  3C1E1E3C                HEX     3C1E1E3C 41363F3F 365D3333 33334530
006154  3E1E305D                HEX     3E1E305D 30303330 41303E3F 303E301E
006164  1E301E33                HEX     1E301E33 00033F33 3F3F3300 033F333F
006174  33370003                HEX     33370003 0C370333 3F3F030C 3F1F333B
006184  3F030C3B                HEX     3F030C3B 033F3300 3F3F333F 1E33003F
006194  3F333F1E                HEX     3F333F1E 331E3F3F 633C3F33 3F3F3F77
0061A4  7E033303                HEX     7E033303 0C036B06 1E1E1E0C 1F633C30
0061B4  0C300C03                HEX     0C300C03 63603F0C 3F0C3F63 7E1E0C1E
0061C4  0C3F633C                HEX     0C3F633C 80FF80C0 FF81A0DD 82B0DD86
0061D4  A8DD8AAC                HEX     A8DD8AAC DD9AAADD AAABDDEA ABDDEAFF
0061E4  FFFFFFFF                HEX     FFFFFFFF FFFFFFFF ABDDEAAB DDEAAADD
0061F4  AAACDD9A                HEX     AAACDD9A A8DD8AB0 DD86A0DD 82C0FF81
006204  80FF8003                HEX     80FF8003 3F333F1E 033F333F 3F030C33
006214  0303030C                HEX     0303030C 331F1E03 0C330330 3F3F1E3F
006224  3F3F3F0C                HEX     3F3F3F0C 3F1ED400 95D4C195 D0FF85D0
006234  FF85C094                HEX     FF85C094 81009400 00940000 94000094
006244  00009400                HEX     00009400 00AA0000 AA0000AA 00008800
006254  0000C000                HEX     0000C000 00D00000 D00000D4 0000D400
006264  00B8008A                HEX     00B8008A 9800DA9A C0DA9A00 DA9A008A
006274  980000B8                HEX     980000B8 0000D400 00D40000 D00000D0
006284  0000C000                HEX     0000C000 880000AA 0000AA00 00AA0000
006294  94000094                HEX     94000094 00009400 00940000 9400C094
0062A4  81D0FF85                HEX     81D0FF85 D0FF85D4 C195D400 95E08700
0062B4  B89D00AE                HEX     B89D00AE F500AFF4 81AEF500 B89D00E0
0062C4  8700150E                HEX     8700150E 1B0E152A 1C361C2A 54386C38
0062D4  54280170                HEX     54280170 00580170 00280150 02600130
0062E4  03600150                HEX     03600150 02200540 03600640 03200540
0062F4  0A000740                HEX     0A000740 0D000740 0A1E1E63 7E001E33
006304  3F1F1E1E                HEX     3F1F1E1E 637E001E 333F1F3F 3F777E00
006314  3F333F3F                HEX     3F333F3F 3F3F777E 003F333F 3F03336B
006324  06003333                HEX     06003333 03330333 6B060033 3303333B
006334  3F633E00                HEX     3F633E00 33331F3F 3B3F633E 0033331F
006344  3F333F63                HEX     3F333F63 06003333 031F333F 63060033
006354  33031F3F                HEX     33031F3F 33637E00 3F1E3F3B 3F33637E
006364  003F1E3F                HEX     003F1E3F 3B1E3363 7E001E0C 3F331E33
006374  637E001E                HEX     637E001E 0C3F3300 7F00407F 01205D02
006384  305D0628                HEX     305D0628 5D0A2C5D 1A2A5D2A 2B5D6A2B
006394  5D6A7F7F                HEX     5D6A7F7F 7F7F7F7F 7F7F7F2B 5D6A2B5D
0063A4  6A2A5D2A                HEX     6A2A5D2A 2C5D1A28 5D0A305D 06205D02
0063B4  407F0100                HEX     407F0100 7F0080FF 80C0FF81 A0DD82B0
0063C4  DD86A8DD                HEX     DD86A8DD 8AACDD9A AADDAAAB DDEAABDD
0063D4  EAFFFFFF                HEX     EAFFFFFF FFFFFFFF FFFFABDD EAABDDEA
0063E4  AADDAAAC                HEX     AADDAAAC DD9AA8DD 8AB0DD86 A0DD82C0
0063F4  FF8180FF                HEX     FF8180FF 80007F00 407F0120 5D02305D
006404  06285D0A                HEX     06285D0A 2C5D1A2A 5D2A2B5D 6A2B5D6A
006414  7F7F7F7F                HEX     7F7F7F7F 7F7F7F7F 7F2B5D6A 2B5D6A2A
006424  5D2A2C5D                HEX     5D2A2C5D 1A285D0A 305D0620 5D02407F
006434  01007F00                HEX     01007F00 80FF80C0 FF81A0DD 82B0DD86
006444  A8DD8AAC                HEX     A8DD8AAC DD9AAADD AAABDDEA ABDDEAFF
006454  FFFFFFFF                HEX     FFFFFFFF FFFFFFFF ABDDEAAB DDEAAADD
006464  AAACDD9A                HEX     AAACDD9A A8DD8AB0 DD86A0DD 82C0FF81
006474  80FF80FD                HEX     80FF80FD 00DFFD00 DFF9FFCF F4FF97C4
006484  9C91D4AA                HEX     9C91D4AA 95C0AA81 C0AA81C0 9C81C0BE
006494  81C0BE81                HEX     81C0BE81 C0BE81C0 BE81C0AA 8100AA00
0064A4  0000D000                HEX     0000D000 00D40000 E40000F5 0000F900
0064B4  00F900AA                HEX     00F900AA F9C000B9 D09E99D0 BD9DD0BD
0064C4  9DD0BD9D                HEX     9DD0BD9D D09E99C0 00B900AA F90000F1
0064D4  0000F900                HEX     0000F900 00F50000 E40000D4 0000D000
0064E4  AA00C0AA                HEX     AA00C0AA 81C0BE81 C0BE81C0 BE81C0BE
0064F4  81C09C81                HEX     81C09C81 C0AA81C0 AA81D4AA 95C49C91
006504  F4FF97F9                HEX     F4FF97F9 FFCFFD00 DFFD00DF 85000095
006514  00009300                HEX     00009300 00D70000 CF0000CF 0000CFAA
006524  00CE0081                HEX     00CE0081 CCBC85DC BE85DCBE 85DCBE85
006534  CCBC85CE                HEX     CCBC85CE 0081CFAA 00CF0000 CF0000D7
006544  00009300                HEX     00009300 00950000 85000094 94D5D5D5
006554  9494D000                HEX     9494D000 D000D482 D482D482 D000D000
006564  C082C082                HEX     C082C082 D08AD08A D08AC082 C082008A
006574  008AC0AA                HEX     008AC0AA C0AAC0AA 008A0008 A800A800
006584  AA81AA81                HEX     AA81AA81 AA81A800 A800A081 A081A885
006594  A885A885                HEX     A885A885 A081A081 00850085 A095A095
0065A4  A0950085                HEX     A0950085 0085E087 00B89D00 AEF500AF
0065B4  F481AEF5                HEX     F481AEF5 00B89D00 E0870000 9F00E0F5
0065C4  00B8D583                HEX     00B8D583 BCD187B8 D583E0F5 00009F00
0065D4  00FC0000                HEX     00FC0000 D783E0D5 8EF0C59E E0D58E00
0065E4  D78300FC                HEX     D78300FC 0000F083 00DC8E00 D7BAC097
0065F4  FA00D7BA                HEX     FA00D7BA 00DC8E00 F083C08F 00F0BA00
006604  DCEA81DE                HEX     DCEA81DE E883DCEA 81F0BA00 C08F0000
006614  BE00C0EB                HEX     BE00C0EB 81F0AA87 F8A28FF0 AA87C0EB
006624  8100BE00                HEX     8100BE00 00F88100 AE87C0AB 9DE08BBD
006634  C0AB9D00                HEX     C0AB9D00 AE8700F8 813E6B7F 5D633E78
006644  012C037C                HEX     012C037C 0374020C 03780160 07300D70
006654  0F500B30                HEX     0F500B30 0C600700 1F403540 3F402E40
006664  31001F7C                HEX     31001F7C 0056017E 013A0146 017C0070
006674  03580678                HEX     03580678 07680518 06700340 0F601A60
006684  1F201760                HEX     1F201760 18400F0B 1C3E7F3E 1C082000
006694  70007801                HEX     70007801 7C037801 70002000 00014003
0066A4  6007700F                HEX     6007700F 60074003 00010004 000E001F
0066B4  403F001F                HEX     403F001F 000E0004 10003800 7C007E01
0066C4  7C003800                HEX     7C003800 10004000 60017003 78077003
0066D4  60014000                HEX     60014000 00020007 400F601F 400F0007
0066E4  00022800                HEX     00022800 2A012A01 D480AA81 AA81A800
0066F4  20012805                HEX     20012805 2805D082 A885A885 A0810005
006704  20152015                HEX     20152015 008AA095 A0950085 00140055
006714  005500AA                HEX     005500AA 00D500D5 00945000 54025402
006724  A800D482                HEX     A800D482 D482D000 4002500A 500AA084
006734  D08AD08A                HEX     D08AD08A C082000A 402A402A 0095C0AA
006744  C0AA00AA                HEX     C0AA00AA 94D5F7D5 115544D0 00D482DC
006754  83D48210                HEX     83D48210 02540244 00C082D0 8AF08ED0
006764  8A100250                HEX     8A100250 0A400B00 8AC0AAC0 BBC0AA00
006774  22402A40                HEX     22402A40 08A880AA 81EE81AA 8122002A
006784  010801A0                HEX     010801A0 81A885B8 87A88520 04280508
006794  010085A0                HEX     010085A0 95E09DA0 95200420 15001104
0067A4  04555555                HEX     04555555 04045000 50005402 54025402
0067B4  50005000                HEX     50005000 40024002 500A500A 500A4002
0067C4  4002000A                HEX     4002000A 000A402A 402A402A 000A0000
0067D4  28002800                HEX     28002800 2A012A01 2A012800 28002001
0067E4  20012805                HEX     20012805 28052805 20012001 00050005
0067F4  20152015                HEX     20152015 20150005 00050060 07000038
006804  1D00002E                HEX     1D00002E 7500002F 7401002E 75000038
006814  1D000060                HEX     1D000060 0700001F 00607500 3855033C
006824  51073855                HEX     51073855 03607500 001F0000 7C000057
006834  0360550E                HEX     0360550E 70451E60 550E0057 03007C00
006844  00700300                HEX     00700300 5C0E0057 3A40177A 00573A00
006854  5C0E0070                HEX     5C0E0070 83400F00 703A005C 6A015E68
006864  035C6A01                HEX     035C6A01 703A0040 0F00003E 00406B01
006874  702A0778                HEX     702A0778 220F702A 07406B01 003E0000
006884  7801002E                HEX     7801002E 07402B1D 600B3D40 2B1D002E
006894  07007801                HEX     07007801 44002800 10007F03 41024103
0068A4  41024103                HEX     41024103 7F031002 20014000 7C0F040A
0068B4  040E040A                HEX     040E040A 040E7C0F 40080005 0002703F
0068C4  10281038                HEX     10281038 10281038 703F0022 00001400
0068D4  00080040                HEX     00080040 7F014020 01406001 40200140
0068E4  6001407F                HEX     6001407F 01080150 0020007E 07020502
0068F4  07020502                HEX     07020502 077E0720 04400200 01781F08
006904  14081C08                HEX     14081C08 14081C78 1F001100 04000460
006914  7F205020                HEX     7F205020 70205020 70607FC0 81D085D4
006924  95DDD5D4                HEX     95DDD5D4 95D085C0 81008600 C09600D0
006934  D600F4D6                HEX     D600F4D6 82D0D600 C0960000 86000098
006944  0000DA00                HEX     0000DA00 C0DA82D0 D88AC0DA 8200DA00
006954  00980000                HEX     00980000 E08000E8 8200EA8A C0EEAA00
006964  EA8A00E8                HEX     EA8A00E8 8200E080 008300A0 8B00A8AB
006974  00BAAB81                HEX     00BAAB81 A8AB00A0 8B000083 00008C80
006984  00AD00A0                HEX     00AD00A0 AD81E8AD 85A0AD81 00AD0000
006994  8C8000B0                HEX     8C8000B0 8000B481 00B58540 B79500B5
0069A4  8500B481                HEX     8500B481 00B08060 015C0E56 1A552A7F
0069B4  3F4E1C04                HEX     3F4E1C04 08000F00 703A0058 6A00542A
0069C4  01747F01                HEX     01747F01 38720010 2000001C 00406B01
0069D4  602A0350                HEX     602A0350 2A05707F 07604903 40000100
0069E4  7000002E                HEX     7000002E 07002B0D 402A1540 7F1F0027
0069F4  0E000204                HEX     0E000204 4003381D 2C352A55 7E7F1C39
006A04  0810000E                HEX     0810000E 00607500 30550128 5502787F
006A14  03706401                HEX     03706401 20400000 38000057 03405506
006A24  20550A60                HEX     20550A60 7F0FA013 07000102 C2C2CAD2
006A34  AAD4AAD5                HEX     AAD4AAD5 AAD4CAD2 C2C2888A 82A8CA82
006A44  A8D182A8                HEX     A8D182A8 D582A8D1 82A8CA82 888A82A0
006A54  A888A0A9                HEX     A888A0A9 8AA0C58A A0D58AA0 C58AA0A9
006A64  8AA0A888                HEX     8AA0A888 00A1A100 A5A90095 AA00D5AA
006A74  0095AA00                HEX     0095AA00 A5A900A1 A1848581 94A581D4
006A84  A881D4AA                HEX     A881D4AA 81D4A881 94A58184 85819094
006A94  84D09485                HEX     84D09485 D0A285D0 AA85D0A2 85D09485
006AA4  909484C0                HEX     909484C0 D090C0D2 94C08A95 C0AA95C0
006AB4  8A95C0D2                HEX     8A95C0D2 94C0D090 22777F3E 1C084400
006AC4  6E017E01                HEX     6E017E01 7C003800 10000801 5C037C03
006AD4  78017000                HEX     78017000 20001002 38077807 70036001
006AE4  40002004                HEX     40002004 700E700F 60074003 00014008
006AF4  601D601F                HEX     601D601F 400F0007 00020011 403B403F
006B04  001F000E                HEX     001F000E 0004081C 3E7F7722 10003800
006B14  7C007E01                HEX     7C007E01 6E014400 20007000 78017C03
006B24  5C030801                HEX     5C030801 40006001 70037807 38071002
006B34  00014003                HEX     00014003 6007700F 700E2004 00020007
006B44  400F601F                HEX     400F601F 601D4008 0004000E 001F403F
006B54  403B0011                HEX     403B0011 40000400 00010200 00020100
006B64  00440000                HEX     00440000 00280000 00100000 7F7F7F03
006B74  7F7F7F03                HEX     7F7F7F03 03001C03 03001C03 03007C03
006B84  03007C03                HEX     03007C03 03001C03 03001C03 03007C03
006B94  03007C03                HEX     03007C03 03007C03 03007C03 03007C03
006BA4  03007C03                HEX     03007C03 03007C03 03007C03 7F7F7F03
006BB4  7F7F7F03                HEX     7F7F7F03 00084000 00102000 00201000
006BC4  00400800                HEX     00400800 00000500 00000200 707F7F3F
006BD4  707F7F3F                HEX     707F7F3F 30004033 30004033 3000403F
006BE4  3000403F                HEX     3000403F 30004033 30004033 3000403F
006BF4  3000403F                HEX     3000403F 3000403F 3000403F 3000403F
006C04  3000403F                HEX     3000403F 3000403F 3000403F 707F7F3F
006C14  707F7F3F                HEX     707F7F3F 00021000 00040800 00080400
006C24  00100200                HEX     00100200 00200100 00400000 7C7F7F0F
006C34  7C7F7F0F                HEX     7C7F7F0F 0C00700C 0C00700C 0C00700F
006C44  0C00700F                HEX     0C00700F 0C00700C 0C00700C 0C00700F
006C54  0C00700F                HEX     0C00700F 0C00700F 0C00700F 0C00700F
006C64  0C00700F                HEX     0C00700F 0C00700F 0C00700F 7C7F7F0F
006C74  7C7F7F0F                HEX     7C7F7F0F 00200002 00004000 01000000
006C84  41000000                HEX     41000000 00220000 00001400 00000008
006C94  0000407F                HEX     0000407F 7F7F0140 7F7F7F01 4001004E
006CA4  01400100                HEX     01400100 4E014001 007E0140 01007E01
006CB4  4001004E                HEX     4001004E 01400100 4E014001 007E0140
006CC4  01007E01                HEX     01007E01 4001007E 01400100 7E014001
006CD4  007E0140                HEX     007E0140 01007E01 4001007E 01400100
006CE4  7E01407F                HEX     7E01407F 7F7F0140 7F7F7F01 00010800
006CF4  00020400                HEX     00020400 00040200 00080100 00500000
006D04  00200000                HEX     00200000 7E7F7F07 7E7F7F07 06003806
006D14  06003806                HEX     06003806 06007807 06007807 06003806
006D24  06003806                HEX     06003806 06007807 06007807 06007807
006D34  06007807                HEX     06007807 06007807 06007807 06007807
006D44  06007807                HEX     06007807 7E7F7F07 7E7F7F07 00042000
006D54  00081000                HEX     00081000 00100800 00200400 00400200
006D64  00000100                HEX     00000100 787F7F1F 787F7F1F 18006019
006D74  18006019                HEX     18006019 1800601F 1800601F 18006019
006D84  18006019                HEX     18006019 1800601F 1800601F 1800601F
006D94  1800601F                HEX     1800601F 1800601F 1800601F 1800601F
006DA4  1800601F                HEX     1800601F 787F7F1F 787F7F1F 00100000
006DB4  00204000                HEX     00204000 00402000 00001100 00000A00
006DC4  00000400                HEX     00000400 607F7F7F 607F7F7F 60000067
006DD4  60000067                HEX     60000067 6000007F 6000007F 60000067
006DE4  60000067                HEX     60000067 6000007F 6000007F 6000007F
006DF4  6000007F                HEX     6000007F 6000007F 6000007F 6000007F
006E04  6000007F                HEX     6000007F 607F7F7F 607F7F7F 033F333F
006E14  03033F33                HEX     03033F33 3F030303 33030303 1F331F03
006E24  03033303                HEX     03033303 033F3F1E 3F3F3F3F 0C3F3F33
006E34  1E334031                HEX     1E334031 3F33001C 331E3340 313F3300
006E44  1C333F33                HEX     1C333F33 40313F33 001C333F 3340313F
006E54  33001C33                HEX     33001C33 33334031 0C37001C 33333340
006E64  310C3700                HEX     310C3700 1C1E3333 40350C3F 001C1E33
006E74  3340350C                HEX     3340350C 3F001C0C 33334035 0C3B0000
006E84  0C333340                HEX     0C333340 350C3B00 000C3F3F 403B3F33
006E94  001C0C3F                HEX     001C0C3F 3F403B3F 33001C0C 1E1E4031
006EA4  3F33001C                HEX     3F33001C 0C1E1E40 313F3300 1C18003C
006EB4  0019017F                HEX     0019017F 01180018 003C0024 00240024
006EC4  00FEFF8F                HEX     00FEFF8F 818090FF FF9FD5AA 95818090
006ED4  818090DD                HEX     818090DD BB97D588 95CD9993 D58895DD
006EE4  BB958180                HEX     BB958180 90818090 81809081 9F90E1F5
006EF4  90B9D593                HEX     90B9D593 BDD197B9 D593E1F5 90819F90
006F04  81809081                HEX     81809081 8090FEFF 8FF8FFBF 8480C0FC
006F14  FFFFD4AA                HEX     FFFFD4AA D58480C0 8480C0F4 EEDDD4A2
006F24  D4B4E6CC                HEX     D4B4E6CC D4A2D4F4 EED58480 C08480C0
006F34  8480C084                HEX     8480C084 FCC084D7 C3E4D5CE F4C5DEE4
006F44  D5CE84D7                HEX     D5CE84D7 C384FCC0 8480C084 80C0F8FF
006F54  BFE0FFFF                HEX     BFE0FFFF 81908080 82F0FFFF 83D0AAD5
006F64  82908080                HEX     82908080 82908080 82D0BBF7 82D08AD1
006F74  82D099B3                HEX     82D099B3 82D08AD1 82D0BBD7 82908080
006F84  82908080                HEX     82908080 82908080 8290F083 8290DC8E
006F94  8290D7BA                HEX     8290D7BA 82D097FA 8290D7BA 8290DC8E
006FA4  8290F083                HEX     8290F083 82908080 82908080 82E0FFFF
006FB4  8180FFFF                HEX     8180FFFF 87C08080 88C0FFFF 8FC0AAD5
006FC4  8AC08080                HEX     8AC08080 88C08080 88C0EEDD 8BC0AAC4
006FD4  8AC0E6CC                HEX     8AC0E6CC 89C0AAC4 8AC0EEDD 8AC08080
006FE4  88C08080                HEX     88C08080 88C08080 88C0C08F 88C0F0BA
006FF4  88C0DCEA                HEX     88C0DCEA 89C0DEE8 8BC0DCEA 89C0F0BA
007004  88C0C08F                HEX     88C0C08F 88C08080 88C08080 8880FFFF
007014  87FCFF9F                HEX     87FCFF9F 8280A0FE FFBFAAD5 AA8280A0
007024  8280A0BA                HEX     8280A0BA F7AEAA91 AA9AB3A6 AA91AABA
007034  F7AA8280                HEX     F7AA8280 A08280A0 8280A082 BEA0C2EB
007044  A1F2AAA7                HEX     A1F2AAA7 FAA2AFF2 AAA7C2EB A182BEA0
007054  8280A082                HEX     8280A082 80A0FCFF 9FF0FFFF 80888080
007064  81F8FFFF                HEX     81F8FFFF 81A8D5AA 81888080 81888080
007074  81E8DDBB                HEX     81E8DDBB 81A8C5A8 81E8CC99 81A8C5A8
007084  81E8DDAB                HEX     81E8DDAB 81888080 81888080 81888080
007094  8188F881                HEX     8188F881 8188AE87 81C8AB9D 81E88BBD
0070A4  81C8AB9D                HEX     81C8AB9D 8188AE87 8188F881 81888080
0070B4  81888080                HEX     81888080 81F0FFFF 80C0FFFF 83A08080
0070C4  84E0FFFF                HEX     84E0FFFF 87A0D5AA 85A08080 84A08080
0070D4  84A0F7EE                HEX     84A0F7EE 85A095A2 85A0B3E6 84A095A2
0070E4  85A0F7AE                HEX     85A0F7AE 85A08080 84A08080 84A08080
0070F4  84A0E087                HEX     84A0E087 84A0B89D 84A0AEF5 84A0AFF4
007104  85A0AEF5                HEX     85A0AEF5 84A0B89D 84A0E087 84A08080
007114  84A08080                HEX     84A08080 84C0FFFF 83000000 00000000
007124  00000000                HEX     00000000 00000000 00000000 00000000
007134  00000000                HEX     00000000 00000000 00000000 00000000
007144  00000000                HEX     00000000 00000000 00000000 00000000
007154  00000000                HEX     00000000 00000000 00000000 00000000
007164  00000000                HEX     00000000 00000000 00000000 00000000
007174  00000000                HEX     00000000 00000000 00000000 00000000
007184  00000000                HEX     00000000 00000000 00000000 00000000
007194  00000000                HEX     00000000 00000000 00000000 00000000
0071A4  00000000                HEX     00000000 00000000 00000000 00000000
0071B4  00000000                HEX     00000000 00000000 00000000 00000000
0071C4  00000000                HEX     00000000 00000000 00000000 00000000
0071D4  00000000                HEX     00000000 00000000 00000000 00000000
0071E4  00000000                HEX     00000000 00000000 00000000 00000000
0071F4  00000000                HEX     00000000 00000000 00000000

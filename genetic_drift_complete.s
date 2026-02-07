; ============================================================================
; "Genetic Drift" - Complete Disassembly
; ============================================================================
;
; Game:       Genetic Drift
; Author:     Scott Schram
; Publisher:  Broderbund Software, 1981
;
; Binary:     14,889 bytes, loads at $37D7, runs at $0000-$07FF + $4000-$71FF
;
; Disassembled by Rosetta v2 Toolchain (deasmiigs) - 6502 mode with
; Apple II ROM symbols
;
; The binary self-relocates at startup:
;   1. Bootstrap at $37D7 copies $3800-$3FFF to $0000-$07FF (zero page +
;      stack area, custom RWTS, Broderbund splash screen code)
;   2. Bootstrap then jumps to $57D7 (the main entry point, which is at
;      offset $57D7-$4000 = $17D7 within the main code segment)
;   3. Main game code at $4000-$71FF stays at its load address
;
; ============================================================================
; MEMORY MAP
; ============================================================================
;
;   $0000-$007F : Zero page variables (game state, pointers, counters)
;   $0000-$07FF : Relocated code block
;                   - Custom RWTS disk reader (reads nibble-encoded sectors)
;                   - Broderbund splash screen display
;                   - HGR line address lookup tables
;   $4000-$71FF : Main game code (remains at load address)
;                   - Game logic, graphics routines, input handling
;                   - Shape tables, color tables, level data
;
; KEY ENTRY POINTS:
;   $37D7 : Bootstrap loader (initial entry from DOS)
;   $57D7 : Main entry point (after relocation)
;   $5875 : Main game loop
;   $4120 : Graphics initialization (clears HGR, sets video mode)
;   $4001 : Start of main code segment
;   $0416 : Relocated rendering subroutine
;   $025D : RWTS sector read routine
;   $02D1 : Disk data decode routine
;
; ============================================================================

        ; Emulation mode (6502)

; ============================================================================
; SEGMENT: Bootstrap Loader ($37D7-$37FF)
; ============================================================================
; This 41-byte bootstrap is the initial entry point when the binary loads.
; It copies 8 pages ($3800-$3FFF) down to $0000-$07FF, overwriting zero page,
; the stack, and low memory with the relocated code block. After the copy
; completes, it jumps to $57D7 to begin the main game.
; ============================================================================

0037D7  8D 10 C0                      sta  $C010           ; KBDSTRB - Clear keyboard strobe {Keyboard} <keyboard_strobe>
0037DA  A9 38                         lda  #$38            ; A=$0038
0037DC  85 01                         sta  $01             ; A=$0038
0037DE  A9 00                         lda  #$00            ; A=$0000
0037E0  85 03                         sta  $03             ; A=$0000
0037E2  A9 40                         lda  #$40            ; A=$0040
0037E4  85 04                         sta  $04             ; A=$0040
0037E6  A0 00                         ldy  #$00            ; A=$0040 Y=$0000
0037E8  84 00                         sty  $00             ; A=$0040 Y=$0000
0037EA  84 02                         sty  $02             ; A=$0040 Y=$0000

; === while loop starts here (counter: Y 'iter_y') ===
0037EC  B1 00             L_0037EC    lda  ($00),Y         ; A=$0040 Y=$0000
0037EE  91 02                         sta  ($02),Y         ; A=$0040 Y=$0000
0037F0  C8                            iny                  ; A=$0040 Y=$0001
0037F1  D0 F9                         bne  L_0037EC        ; A=$0040 Y=$0001
; === End of while loop (counter: Y) ===

0037F3  E6 01                         inc  $01             ; A=$0040 Y=$0001
0037F5  E6 03                         inc  $03             ; A=$0040 Y=$0001
0037F7  A5 01                         lda  $01             ; A=[$0001] Y=$0001
0037F9  C5 04                         cmp  $04             ; A=[$0001] Y=$0001
0037FB  D0 EF                         bne  L_0037EC        ; A=[$0001] Y=$0001
; === End of while loop (counter: Y) ===

0037FD  4C D7 57                      jmp  $57D7           ; A=[$0001] Y=$0001

; ============================================================================
; SEGMENT: Relocated Code Block ($0000-$07FF)
; ============================================================================
; This 2048-byte block is copied from $3800-$3FFF to $0000-$07FF by the
; bootstrap. It contains:
;   - Zero page variables and interrupt vectors
;   - Custom RWTS (Read/Write Track/Sector) disk I/O routines that read
;     Broderbund's nibble-encoded disk format directly via slot I/O ($C08C,X)
;   - Broderbund splash screen display code
;   - HGR screen line address lookup tables ($0700-$07FF)
; ============================================================================

; FUNC $000000: register -> A:X [I]
; Proto: uint32_t func_000000(uint16_t param_A, uint16_t param_X, uint16_t param_Y);
; Liveness: params(A,X,Y) returns(A,X,Y)
; LUMA: int_brk
000000  00 38                         brk  #$38            ; [SP-3]
; LUMA: int_brk

; --- Data region ---
000002  00004093                HEX     00004093 502901C0 09280000 00000300
000012  6C1DB213                HEX     6C1DB213 D1D13C3B D4999BD1

; === while loop starts here ===
; --- End data region (28 bytes) ---

00001E  F9 BA 00          L_00001E    sbc  !$00BA,Y        ; [SP-10]
000021  28                            plp                  ; [SP-13]
; LUMA: int_brk
000022  00 18                         brk  #$18            ; [SP-16]

; --- Data region ---
000024  AE170225                HEX     AE170225 D007EF60
; --- End data region (8 bytes) ---

00002C  F0 F0             L_00002C    beq  L_00001E        ; [SP-14]
; === End of while loop ===


; --- Data region ---
00002E  F088CAD7                HEX     F088CAD7 FF90841B F0FD1BFD AD850072
; LUMA: int_brk
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
0000FE  AA60                    HEX     AA60
; --- End data region (210 bytes) ---

000100  07 00             L_000100    ora  [$00]           ; [SP-24]
000102  A9 4C                         lda  #$4C            ; A=$004C ; [SP-24]
000104  8D 00 06                      sta  $0600           ; A=$004C ; [SP-24]
000107  A9 00                         lda  #$00            ; A=$0000 ; [SP-24]
000109  8D 01 06                      sta  $0601           ; A=$0000 ; [SP-24]
00010C  A9 B0                         lda  #$B0            ; A=$00B0 ; [SP-24]
00010E  8D 02 06                      sta  $0602           ; A=$00B0 ; [SP-24]
000111  A9 EE                         lda  #$EE            ; A=$00EE ; [SP-24]
; LUMA: epilogue_rts
000113  60                            rts                  ; A=$00EE ; [SP-22]

; --- Data region ---
000114  FFFF0000                HEX     FFFF0000 FFFF0000 FFFF0000 FFFF0000
000124  FFFF0000                HEX     FFFF0000 FFFF0000 FFFF0000 FFFF0000
000134  FFFF0000                HEX     FFFF0000 FFFF0000 FFFF0000 FFFF0000
000144  FFFF0000                HEX     FFFF0000 FFFF0000 FFFF0000 FFFF0000
000154  FFFF0000                HEX     FFFF0000 FFFF0000 FFFF0000 FFFF0000
000164  FFFF0000                HEX     FFFF0000 FFFF0000 FFFF0000 FFFF0000
000174  FFFF0000                HEX     FFFF0000 FFFF0000 FFFF0000 FFFF0000
000184  FFFF0000                HEX     FFFF0000 FFFF0000 FFFF0000 FFFF0000
000194  FFFF0000                HEX     FFFF0000 FFFF0000 FFFF0000 FFFF0000
0001A4  FFFF0000                HEX     FFFF0000 FFFF0000 FFFF0000 FFFF0000
0001B4  FFFF0000                HEX     FFFF0000 FFFF0000 FFFF0000 FFFF0000
0001C4  FFFF0000                HEX     FFFF0000 FFFF0000 FFFF0000 FFFF0000
0001D4  FFFF0000                HEX     FFFF0000 17FBFDFB FDB2FB17 261726FC
0001E4  1726FC68                HEX     1726FC68 00008417 FBFDFB01 E8FBFBFD
0001F4  8784FA43                HEX     8784FA43 FD574F0F 2464EE04 06A200BD
; LUMA: int_brk
000204  00089D00                HEX     00089D00 02E8D0F7 4C0F02A0 AB

; === while loop starts here (counter: Y 'iter_y') ===
; --- End data region (253 bytes) ---

000211  98                L_000211    tya                  ; [SP-28]
000212  85 3C                         sta  $3C             ; [SP-28]
000214  4A                            lsr  a               ; [SP-28]
000215  05 3C                         ora  $3C             ; [SP-28]
000217  C9 FF                         cmp  #$FF            ; [SP-28]
000219  D0 09                         bne  L_000224        ; [SP-28]

; === while loop starts here (counter: X 'i') ===
00021B  C0 D5             L_00021B    cpy  #$D5            ; [SP-28]
00021D  F0 05                         beq  L_000224        ; [SP-28]
00021F  8A                            txa                  ; [SP-28]
000220  99 00 08                      sta  $0800,Y         ; [SP-28]
000223  E8                            inx                  ; X=X+$01 ; [SP-28]
000224  C8                L_000224    iny                  ; X=X+$01 Y=Y+$01 ; [SP-28]
000225  D0 EA                         bne  L_000211        ; X=X+$01 Y=Y+$01 ; [SP-28]
; === End of while loop (counter: Y) ===

000227  84 3D                         sty  $3D             ; X=X+$01 Y=Y+$01 ; [SP-28]
000229  84 26                         sty  $26             ; X=X+$01 Y=Y+$01 ; [SP-28]
00022B  A9 03                         lda  #$03            ; A=$0003 X=X+$01 Y=Y+$01 ; [SP-28]
00022D  85 27                         sta  $27             ; A=$0003 X=X+$01 Y=Y+$01 ; [SP-28]
00022F  A6 2B                         ldx  $2B             ; A=$0003 X=X+$01 Y=Y+$01 ; [SP-28]
000231  20 5D 02                      jsr  L_00025D        ; A=$0003 X=X+$01 Y=Y+$01 ; [SP-30]
000234  20 D1 02                      jsr  L_0002D1        ; A=$0003 X=X+$01 Y=Y+$01 ; [SP-32]
000237  4C 00 88                      jmp  $8800           ; A=$0003 X=X+$01 Y=Y+$01 ; [SP-32]
; LUMA: int_brk

; --- Data region ---
00023A  00000000                HEX     00000000 00000000 00000000 00000000
; LUMA: int_brk
00024A  00000000                HEX     00000000 00000000 00000000 00000000
; LUMA: int_brk
00025A  000000                  HEX     000000

; === while loop starts here [nest:1] ===

; FUNC $00025D: register -> A:X [L]
; Proto: uint32_t func_00025D(uint16_t param_X);
; Liveness: params(X) returns(A,X,Y) [9 dead stores]
; --- End data region (35 bytes) ---

00025D  18                L_00025D    clc                  ; A=$0003 X=X+$01 Y=Y+$01 ; [SP-86]

; === while loop starts here [nest:2] ===
00025E  08                L_00025E    php                  ; A=$0003 X=X+$01 Y=Y+$01 ; [SP-87]

; === while loop starts here [nest:6] ===
; LUMA: data_array_x
00025F  BD 8C C0          L_00025F    lda  $C08C,X         ; $C08C - Unknown I/O register <slot_io>
000262  10 FB                         bpl  L_00025F        ; A=$0003 X=X+$01 Y=Y+$01 ; [SP-87]
; === End of while loop ===


; === while loop starts here [nest:6] ===
000264  49 D5             L_000264    eor  #$D5            ; A=A^$D5 X=X+$01 Y=Y+$01 ; [SP-87]
000266  D0 F7                         bne  L_00025F        ; A=A^$D5 X=X+$01 Y=Y+$01 ; [SP-87]
; === End of while loop ===


; === while loop starts here [nest:7] ===
; LUMA: data_array_x
000268  BD 8C C0          L_000268    lda  $C08C,X         ; $C08C - Unknown I/O register <slot_io>
00026B  10 FB                         bpl  L_000268        ; A=A^$D5 X=X+$01 Y=Y+$01 ; [SP-87]
; === End of while loop ===

00026D  C9 AA                         cmp  #$AA            ; A=A^$D5 X=X+$01 Y=Y+$01 ; [SP-87]
00026F  D0 F3                         bne  L_000264        ; A=A^$D5 X=X+$01 Y=Y+$01 ; [SP-87]
; === End of while loop ===

000271  EA                            nop                  ; A=A^$D5 X=X+$01 Y=Y+$01 ; [SP-87]

; === while loop starts here [nest:6] ===
; LUMA: data_array_x
000272  BD 8C C0          L_000272    lda  $C08C,X         ; $C08C - Unknown I/O register <slot_io>
000275  10 FB                         bpl  L_000272        ; A=A^$D5 X=X+$01 Y=Y+$01 ; [SP-87]
; === End of while loop ===

000277  C9 B5                         cmp  #$B5            ; A=A^$D5 X=X+$01 Y=Y+$01 ; [SP-87]
000279  F0 09                         beq  L_000284        ; A=A^$D5 X=X+$01 Y=Y+$01 ; [SP-87]
00027B  28                            plp                  ; A=A^$D5 X=X+$01 Y=Y+$01 ; [SP-86]
00027C  90 DF                         bcc  L_00025D        ; A=A^$D5 X=X+$01 Y=Y+$01 ; [SP-86]
; === End of while loop ===

00027E  49 AD                         eor  #$AD            ; A=A^$AD X=X+$01 Y=Y+$01 ; [SP-86]
000280  F0 1F                         beq  L_0002A1        ; A=A^$AD X=X+$01 Y=Y+$01 ; [SP-86]
000282  D0 D9                         bne  L_00025D        ; A=A^$AD X=X+$01 Y=Y+$01 ; [SP-86]
; === End of while loop ===

000284  A0 03             L_000284    ldy  #$03            ; A=A^$AD X=X+$01 Y=$0003 ; [SP-86]
000286  84 2A                         sty  $2A             ; A=A^$AD X=X+$01 Y=$0003 ; [SP-86]

; === while loop starts here [nest:4] ===
; LUMA: data_array_x
000288  BD 8C C0          L_000288    lda  $C08C,X         ; $C08C - Unknown I/O register <slot_io>
00028B  10 FB                         bpl  L_000288        ; A=A^$AD X=X+$01 Y=$0003 ; [SP-86]
; === End of while loop ===

00028D  2A                            rol  a               ; A=A^$AD X=X+$01 Y=$0003 ; [SP-86]
00028E  85 3C                         sta  $3C             ; A=A^$AD X=X+$01 Y=$0003 ; [SP-86]

; === while loop starts here [nest:5] ===
; LUMA: data_array_x
000290  BD 8C C0          L_000290    lda  $C08C,X         ; $C08C - Unknown I/O register <slot_io>
000293  10 FB                         bpl  L_000290        ; A=A^$AD X=X+$01 Y=$0003 ; [SP-86]
; === End of while loop ===

000295  25 3C                         and  $3C             ; A=A^$AD X=X+$01 Y=$0003 ; [SP-86]
; LUMA: loop_dey_bne
000297  88                            dey                  ; A=A^$AD X=X+$01 Y=$0002 ; [SP-86]
000298  D0 EE                         bne  L_000288        ; A=A^$AD X=X+$01 Y=$0002 ; [SP-86]
; === End of loop (counter: Y) ===

00029A  28                            plp                  ; A=A^$AD X=X+$01 Y=$0002 ; [SP-85]
00029B  C5 3D                         cmp  $3D             ; A=A^$AD X=X+$01 Y=$0002 ; [SP-85]
00029D  D0 BE                         bne  L_00025D        ; A=A^$AD X=X+$01 Y=$0002 ; [SP-85]
; === End of while loop ===

00029F  B0 BD                         bcs  L_00025E        ; A=A^$AD X=X+$01 Y=$0002 ; [SP-85]
; === End of while loop ===

0002A1  A0 9A             L_0002A1    ldy  #$9A            ; A=A^$AD X=X+$01 Y=$009A ; [SP-85]

; === while loop starts here [nest:2] ===
0002A3  84 3C             L_0002A3    sty  $3C             ; A=A^$AD X=X+$01 Y=$009A ; [SP-85]

; === while loop starts here [nest:3] ===
0002A5  BC 8C C0          L_0002A5    ldy  $C08C,X         ; $C08C - Unknown I/O register <slot_io>
0002A8  10 FB                         bpl  L_0002A5        ; A=A^$AD X=X+$01 Y=$009A ; [SP-85]
; === End of while loop ===

0002AA  59 00 08                      eor  $0800,Y         ; -> $089A ; A=A^$AD X=X+$01 Y=$009A ; [SP-85]
0002AD  A4 3C                         ldy  $3C             ; A=A^$AD X=X+$01 Y=$009A ; [SP-85]
0002AF  88                            dey                  ; A=A^$AD X=X+$01 Y=$0099 ; [SP-85]
0002B0  99 00 08                      sta  $0800,Y         ; -> $0899 ; A=A^$AD X=X+$01 Y=$0099 ; [SP-85]
0002B3  D0 EE                         bne  L_0002A3        ; A=A^$AD X=X+$01 Y=$0099 ; [SP-85]
; === End of while loop ===


; === while loop starts here (counter: Y 'iter_y') [nest:2] ===
0002B5  84 3C             L_0002B5    sty  $3C             ; A=A^$AD X=X+$01 Y=$0099 ; [SP-85]

; === while loop starts here [nest:3] ===
0002B7  BC 8C C0          L_0002B7    ldy  $C08C,X         ; $C08C - Unknown I/O register <slot_io>
0002BA  10 FB                         bpl  L_0002B7        ; A=A^$AD X=X+$01 Y=$0099 ; [SP-85]
; === End of while loop ===

0002BC  59 00 08                      eor  $0800,Y         ; -> $0899 ; A=A^$AD X=X+$01 Y=$0099 ; [SP-85]
0002BF  A4 3C                         ldy  $3C             ; A=A^$AD X=X+$01 Y=$0099 ; [OPT] REDUNDANT_LOAD: Redundant LDY: same value loaded at $0002AD ; [SP-85]
0002C1  91 26                         sta  ($26),Y         ; A=A^$AD X=X+$01 Y=$0099 ; [SP-85]
0002C3  C8                            iny                  ; A=A^$AD X=X+$01 Y=$009A ; [SP-85]
0002C4  D0 EF                         bne  L_0002B5        ; A=A^$AD X=X+$01 Y=$009A ; [SP-85]
; === End of while loop (counter: Y) ===


; === while loop starts here [nest:2] ===
0002C6  BC 8C C0          L_0002C6    ldy  $C08C,X         ; $C08C - Unknown I/O register <slot_io>
0002C9  10 FB                         bpl  L_0002C6        ; A=A^$AD X=X+$01 Y=$009A ; [SP-85]
; === End of while loop ===

0002CB  59 00 08                      eor  $0800,Y         ; -> $089A ; A=A^$AD X=X+$01 Y=$009A ; [SP-85]
0002CE  D0 8D                         bne  L_00025D        ; A=A^$AD X=X+$01 Y=$009A ; [SP-85]
; === End of while loop (counter: Y) ===

0002D0  60                            rts                  ; A=A^$AD X=X+$01 Y=$009A ; [SP-83]

; FUNC $0002D1: register -> A:X [I]
; Proto: uint32_t func_0002D1(void);
; Liveness: returns(A,X,Y) [1 dead stores]
0002D1  A8                L_0002D1    tay                  ; A=A^$AD X=X+$01 Y=A ; [SP-83]

; === while loop starts here (counter: X 'i', range: 0..51, iters: 51) [nest:1] ===
0002D2  A2 00             L_0002D2    ldx  #$00            ; A=A^$AD X=$0000 Y=A ; [SP-83]

; === while loop starts here (counter: X 'iter_x', range: 0..51, iters: 51) [nest:2] ===
0002D4  B9 00 08          L_0002D4    lda  $0800,Y         ; A=A^$AD X=$0000 Y=A ; [SP-83]
0002D7  4A                            lsr  a               ; A=A^$AD X=$0000 Y=A ; [SP-83]
0002D8  3E CC 03                      rol  $03CC,X         ; A=A^$AD X=$0000 Y=A ; [SP-83]
0002DB  4A                            lsr  a               ; A=A^$AD X=$0000 Y=A ; [SP-83]
0002DC  3E 99 03                      rol  $0399,X         ; A=A^$AD X=$0000 Y=A ; [SP-83]
0002DF  85 3C                         sta  $3C             ; A=A^$AD X=$0000 Y=A ; [SP-83]
; LUMA: data_ptr_offset
0002E1  B1 26                         lda  ($26),Y         ; A=A^$AD X=$0000 Y=A ; [SP-83]
0002E3  0A                            asl  a               ; A=A^$AD X=$0000 Y=A ; [OPT] STRENGTH_RED: Multiple ASL A: consider using lookup table for multiply ; [SP-83]
0002E4  0A                            asl  a               ; A=A^$AD X=$0000 Y=A ; [OPT] STRENGTH_RED: Multiple ASL A: consider using lookup table for multiply ; [SP-83]
0002E5  0A                            asl  a               ; A=A^$AD X=$0000 Y=A ; [SP-83]
0002E6  05 3C                         ora  $3C             ; A=A^$AD X=$0000 Y=A ; [SP-83]
0002E8  91 26                         sta  ($26),Y         ; A=A^$AD X=$0000 Y=A ; [SP-83]
0002EA  C8                            iny                  ; A=A^$AD X=$0000 Y=Y+$01 ; [SP-83]
0002EB  E8                            inx                  ; A=A^$AD X=$0001 Y=Y+$01 ; [SP-83]
0002EC  E0 33                         cpx  #$33            ; A=A^$AD X=$0001 Y=Y+$01 ; [SP-83]
0002EE  D0 E4                         bne  L_0002D4        ; A=A^$AD X=$0001 Y=Y+$01 ; [SP-83]
; === End of while loop (counter: X) ===

0002F0  C6 2A                         dec  $2A             ; A=A^$AD X=$0001 Y=Y+$01 ; [SP-83]
0002F2  D0 DE                         bne  L_0002D2        ; A=A^$AD X=$0001 Y=Y+$01 ; [SP-83]
; === End of while loop (counter: X) ===

0002F4  CC 00 03                      cpy  $0300           ; A=A^$AD X=$0001 Y=Y+$01 ; [SP-83]
0002F7  D0 03                         bne  L_0002FC        ; A=A^$AD X=$0001 Y=Y+$01 ; [SP-83]
; LUMA: epilogue_rts
0002F9  60                            rts                  ; A=A^$AD X=$0001 Y=Y+$01 ; [SP-81]
; LUMA: int_brk

; --- Data region ---
0002FA  0000                    HEX     0000
; --- End data region (2 bytes) ---

0002FC  4C 2D FF          L_0002FC    jmp  $FF2D           ; A=A^$AD X=$0001 Y=Y+$01 ; [SP-84]
; LUMA: int_brk

; --- Data region ---
0002FF  00000000                HEX     00000000 00000000 00000000 00000000
; LUMA: int_brk
00030F  00000000                HEX     00000000 00000000 00000000 00000000
; LUMA: int_brk
00031F  00000000                HEX     00000000 00000000 00000000 00000000
; LUMA: int_brk
00032F  00000000                HEX     00000000 00000000 00000000 00000000
; LUMA: int_brk
00033F  00000000                HEX     00000000 00000000 00000000 00000000
; LUMA: int_brk
00034F  00000000                HEX     00000000 00000000 00000000 00000000
; LUMA: int_brk
00035F  00000000                HEX     00000000 00000000 00000000 00000000
; LUMA: int_brk
00036F  00000000                HEX     00000000 00000000 00000000 00000000
; LUMA: int_brk
00037F  00000000                HEX     00000000 00000000 00000000 00000000
; LUMA: int_brk
00038F  00000000                HEX     00000000 00000000 00000000 00000000
; LUMA: int_brk
00039F  00000000                HEX     00000000 00000000 00000000 00000000
; LUMA: int_brk
0003AF  00000000                HEX     00000000 00000000 00000000 00000000
; LUMA: int_brk
0003BF  00000000                HEX     00000000 00000000 00000000 00000000
; LUMA: int_brk
0003CF  00000000                HEX     00000000 00000000 00000000 00000000
; LUMA: int_brk
0003DF  00000000                HEX     00000000 00000000 00000000 00000000
0003EF  00030600                HEX     00030600 06A30000 00000000 00000000
0003FF  00A5002A                HEX     00A5002A A5002600 45006600 E6016501
00040F  5002E601                HEX     5002E601 850060
; --- End data region (279 bytes) ---

000416  A8                L_000416    tay                  ; A=A^$AD X=$0001 Y=A ; [SP-466]
000417  B9 7C 5D                      lda  $5D7C,Y         ; A=A^$AD X=$0001 Y=A ; [SP-466]
00041A  8D 4B 04                      sta  $044B           ; A=A^$AD X=$0001 Y=A ; [SP-466]
00041D  B9 1D 5E                      lda  $5E1D,Y         ; A=A^$AD X=$0001 Y=A ; [SP-466]
000420  8D 4C 04                      sta  $044C           ; A=A^$AD X=$0001 Y=A ; [SP-466]
000423  A5 02                         lda  $02             ; A=[$0002] X=$0001 Y=A ; [SP-466]
000425  85 03                         sta  $03             ; A=[$0002] X=$0001 Y=A ; [SP-466]
000427  18                            clc                  ; A=[$0002] X=$0001 Y=A ; [SP-466]
000428  79 BE 5E                      adc  $5EBE,Y         ; A=[$0002] X=$0001 Y=A ; [SP-466]
00042B  85 02                         sta  $02             ; A=[$0002] X=$0001 Y=A ; [SP-466]
00042D  A5 04                         lda  $04             ; A=[$0004] X=$0001 Y=A ; [SP-466]
00042F  AA                            tax                  ; A=[$0004] X=[$0004] Y=A ; [SP-466]
000430  18                            clc                  ; A=[$0004] X=[$0004] Y=A ; [SP-466]
000431  79 5F 5F                      adc  $5F5F,Y         ; A=[$0004] X=[$0004] Y=A ; [SP-466]
000434  85 05                         sta  $05             ; A=[$0004] X=[$0004] Y=A ; [SP-466]

; === while loop starts here (counter: X 'iter_x') [nest:1] ===
000436  E0 C0             L_000436    cpx  #$C0            ; A=[$0004] X=[$0004] Y=A ; [SP-466]
000438  B0 27                         bcs  L_000461        ; A=[$0004] X=[$0004] Y=A ; [SP-466]
00043A  BD 6C 41                      lda  $416C,X         ; A=[$0004] X=[$0004] Y=A ; [SP-466]
00043D  85 06                         sta  $06             ; A=[$0004] X=[$0004] Y=A ; [SP-466]
00043F  BD 2C 42                      lda  $422C,X         ; A=[$0004] X=[$0004] Y=A ; [SP-466]
000442  85 07                         sta  $07             ; A=[$0004] X=[$0004] Y=A ; [SP-466]
000444  A4 03                         ldy  $03             ; A=[$0004] X=[$0004] Y=A ; [SP-466]

; === while loop starts here (counter: Y 'iter_y') [nest:2] ===
000446  C0 28             L_000446    cpy  #$28            ; A=[$0004] X=[$0004] Y=A ; [SP-466]
000448  B0 05                         bcs  L_00044F        ; A=[$0004] X=[$0004] Y=A ; [SP-466]
00044A  AD 1C 60                      lda  $601C           ; A=[$601C] X=[$0004] Y=A ; [SP-466]
00044D  91 06                         sta  ($06),Y         ; A=[$601C] X=[$0004] Y=A ; [SP-466]
00044F  EE 4B 04          L_00044F    inc  $044B           ; A=[$601C] X=[$0004] Y=A ; [SP-466]
000452  D0 03                         bne  L_000457        ; A=[$601C] X=[$0004] Y=A ; [SP-466]
000454  EE 4C 04                      inc  $044C           ; A=[$601C] X=[$0004] Y=A ; [SP-466]
000457  C8                L_000457    iny                  ; A=[$601C] X=[$0004] Y=Y+$01 ; [SP-466]
000458  C4 02                         cpy  $02             ; A=[$601C] X=[$0004] Y=Y+$01 ; [SP-466]
00045A  90 EA                         bcc  L_000446        ; A=[$601C] X=[$0004] Y=Y+$01 ; [SP-466]
; === End of while loop (counter: Y) ===

00045C  E8                            inx                  ; A=[$601C] X=X+$01 Y=Y+$01 ; [SP-466]
00045D  E4 05                         cpx  $05             ; A=[$601C] X=X+$01 Y=Y+$01 ; [SP-466]
00045F  90 D5                         bcc  L_000436        ; A=[$601C] X=X+$01 Y=Y+$01 ; [SP-466]
; === End of while loop (counter: X) ===

000461  60                L_000461    rts                  ; A=[$601C] X=X+$01 Y=Y+$01 ; [SP-464]

; --- Data region ---
000462  A8B97C5D                HEX     A8B97C5D 8DA704B9 1D5E8DA8 04A50285
000472  031879BE                HEX     031879BE 5E8502A5 04AA1879 5F5F8505
000482  E0C0B039                HEX     E0C0B039 E4089023 E409B01F BD6C4185
000492  06BD2C42                HEX     06BD2C42 8507A403 C028B00F C40A900B
0004A2  C40BB007                HEX     C40BB007 AD000011 069106EE A704D003
0004B2  EEA804C8                HEX     EEA804C8 C40290E0 E8E40590 C360
; --- End data region (94 bytes) ---

0004C0  A8                L_0004C0    tay                  ; A=[$601C] X=X+$01 Y=[$601C] ; [SP-462]
0004C1  B9 7C 5D                      lda  $5D7C,Y         ; A=[$601C] X=X+$01 Y=[$601C] ; [SP-462]
0004C4  8D 05 41                      sta  $4105           ; A=[$601C] X=X+$01 Y=[$601C] ; [SP-462]
0004C7  B9 1D 5E                      lda  $5E1D,Y         ; A=[$601C] X=X+$01 Y=[$601C] ; [SP-462]
0004CA  8D 06 41                      sta  $4106           ; A=[$601C] X=X+$01 Y=[$601C] ; [SP-462]
0004CD  A5 02                         lda  $02             ; A=[$0002] X=X+$01 Y=[$601C] ; [SP-462]
0004CF  85 03                         sta  $03             ; A=[$0002] X=X+$01 Y=[$601C] ; [SP-462]
0004D1  18                            clc                  ; A=[$0002] X=X+$01 Y=[$601C] ; [SP-462]
0004D2  79 BE 5E                      adc  $5EBE,Y         ; A=[$0002] X=X+$01 Y=[$601C] ; [SP-462]
0004D5  85 02                         sta  $02             ; A=[$0002] X=X+$01 Y=[$601C] ; [SP-462]
0004D7  A5 04                         lda  $04             ; A=[$0004] X=X+$01 Y=[$601C] ; [SP-462]
0004D9  AA                            tax                  ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
0004DA  18                            clc                  ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
0004DB  79 5F 5F                      adc  $5F5F,Y         ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
0004DE  85 05                         sta  $05             ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
0004E0  E0 C0                         cpx  #$C0            ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
0004E2  B0 3B                         bcs  L_00051F        ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
0004E4  E4 08                         cpx  $08             ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
0004E6  90 25                         bcc  L_00050D        ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
0004E8  E4 09                         cpx  $09             ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
0004EA  B0 21                         bcs  L_00050D        ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
0004EC  BD 6C 41                      lda  $416C,X         ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
0004EF  85 06                         sta  $06             ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
0004F1  BD 2C 42                      lda  $422C,X         ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
0004F4  85 07                         sta  $07             ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
0004F6  A4 03                         ldy  $03             ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
0004F8  C0 28                         cpy  #$28            ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
0004FA  B0 11                         bcs  L_00050D        ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
0004FC  C4 0A                         cpy  $0A             ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
0004FE  90 0D                         bcc  L_00050D        ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
000500  61 0B                         adc  ($0B,X)         ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
000502  9A                            txs                  ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
000503  AC AD 26                      ldy  $26AD           ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-462]
000506  00 0C                         brk  #$0C            ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-465]

; --- Data region ---
000508  FF570677                HEX     FF570677 07
; --- End data region (5 bytes) ---

00050D  8B                L_00050D    phb                  ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-465]
00050E  04 11                         tsb  $11             ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-465]
000510  D2 E5                         cmp  ($E5)           ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-465]
000512  EF 83 41 A8                   sbc  >$A84183        ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-465]
000516  6C BB EC                      jmp  ($ECBB)         ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-465]

; --- Data region ---
000519  8365AF01                HEX     8365AF01 29DC
; --- End data region (6 bytes) ---

00051F  3E 24 4C          L_00051F    rol  $4C24,X         ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-465]
000522  A6 85                         ldx  $85             ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-465]
000524  AA                            tax                  ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-465]
000525  0B                            phd                  ; A=[$0004] X=[$0004] Y=[$601C] ; [SP-466]
000526  29 59                         and  #$59            ; A=A&$59 X=[$0004] Y=[$601C] ; [SP-466]
000528  E0 BE                         cpx  #$BE            ; A=A&$59 X=[$0004] Y=[$601C] ; [SP-466]
00052A  1E 4D D2                      asl  $D24D,X         ; A=A&$59 X=[$0004] Y=[$601C] ; [SP-466]

; === while loop starts here (counter: X 'iter_x') [nest:1] ===
00052D  5F EA 80 59       L_00052D    eor  >$5980EA,X      ; A=A&$59 X=[$0004] Y=[$601C] ; [SP-466]
000531  B3 8F                         lda  ($8F,S),Y       ; A=A&$59 X=[$0004] Y=[$601C] ; [SP-466]
000533  AB                            plb                  ; A=A&$59 X=[$0004] Y=[$601C] ; [SP-465]
000534  28                            plp                  ; A=A&$59 X=[$0004] Y=[$601C] ; [SP-464]
000535  55 20                         eor  $20,X           ; A=A&$59 X=[$0004] Y=[$601C] ; [SP-464]
000537  6D E7 E7                      adc  $E7E7           ; A=A&$59 X=[$0004] Y=[$601C] ; [SP-464]
00053A  10 3E                         bpl  L_00057A        ; A=A&$59 X=[$0004] Y=[$601C] ; [SP-464]
00053C  81 E5                         sta  ($E5,X)         ; A=A&$59 X=[$0004] Y=[$601C] ; [SP-464]
00053E  A0 B5                         ldy  #$B5            ; A=A&$59 X=[$0004] Y=$00B5 ; [SP-464]
000540  91 2E                         sta  ($2E),Y         ; A=A&$59 X=[$0004] Y=$00B5 ; [SP-464]
000542  C4 82                         cpy  $82             ; A=A&$59 X=[$0004] Y=$00B5 ; [SP-464]
000544  A2 BE                         ldx  #$BE            ; A=A&$59 X=$00BE Y=$00B5 ; [SP-464]
000546  EC 6A 35                      cpx  $356A           ; A=A&$59 X=$00BE Y=$00B5 ; [SP-464]
000549  02 09                         cop  #$09            ; A=A&$59 X=$00BE Y=$00B5 ; [SP-467]

; --- Data region ---
00054B  0AA99197                HEX     0AA99197 E883C0DB 9317A4E0 C154E4F0
00055B  43E1610F                HEX     43E1610F 39D4E5A0 1054D886 0EC43C14
00056B  3E8DA804                HEX     3E8DA804 A5028503 18F93EDE 058225
; --- End data region (47 bytes) ---

00057A  84 2A             L_00057A    sty  $2A             ; A=A&$59 X=$00BE Y=$00B5 ; [SP-467]
00057C  18                            clc                  ; A=A&$59 X=$00BE Y=$00B5 ; [SP-467]
00057D  79 5F 5F                      adc  $5F5F,Y         ; -> $6014 ; A=A&$59 X=$00BE Y=$00B5 ; [SP-467]
000580  85 05                         sta  $05             ; A=A&$59 X=$00BE Y=$00B5 ; [SP-467]
000582  E0 C0                         cpx  #$C0            ; A=A&$59 X=$00BE Y=$00B5 ; [SP-467]
000584  30 B9                         bmi  $053F           ; A=A&$59 X=$00BE Y=$00B5 ; [SP-467]
; === End of while loop (counter: X) ===

000586  64 88                         stz  $88             ; A=A&$59 X=$00BE Y=$00B5 ; [SP-467]
000588  10 A3                         bpl  L_00052D        ; A=A&$59 X=$00BE Y=$00B5 ; [SP-467]
; === End of while loop (counter: X) ===

00058A  64 89                         stz  $89             ; A=A&$59 X=$00BE Y=$00B5 ; [SP-467]
00058C  B0 1F                         bcs  L_0005AD        ; A=A&$59 X=$00BE Y=$00B5 ; [SP-467]
00058E  BD 6C 41                      lda  $416C,X         ; -> $422A ; A=A&$59 X=$00BE Y=$00B5 ; [SP-467]
000591  85 06                         sta  $06             ; A=A&$59 X=$00BE Y=$00B5 ; [SP-467]
000593  BD AC C2                      lda  $C2AC,X         ; S2_$AC - Slot 2 ROM offset $AC {Slot}
000596  05 87                         ora  $87             ; A=A&$59 X=$00BE Y=$00B5 ; [SP-467]
000598  24 83                         bit  $83             ; A=A&$59 X=$00BE Y=$00B5 ; [SP-467]
; Interrupt return (RTI)
00059A  40                            rti                  ; A=A&$59 X=$00BE Y=$00B5 ; [SP-464]

; --- Data region ---
00059B  A8B00FC4                HEX     A8B00FC4 0A900BC4 0B30872D 80809186
0005AB  112E                    HEX     112E
; --- End data region (18 bytes) ---

0005AD  C6 8F             L_0005AD    dec  $8F             ; A=A&$59 X=$00BE Y=$00B5 ; [SP-464]
0005AF  2C F8 2B                      bit  $2BF8           ; A=A&$59 X=$00BE Y=$00B5 ; [SP-464]
0005B2  C6 80                         dec  $80             ; A=A&$59 X=$00BE Y=$00B5 ; [SP-464]
0005B4  AC 60 6C                      ldy  $6C60           ; A=A&$59 X=$00BE Y=$00B5 ; [SP-464]
0005B7  AA                            tax                  ; A=A&$59 X=A Y=$00B5 ; [SP-464]
0005B8  38                            sec                  ; A=A&$59 X=A Y=$00B5 ; [SP-464]
0005B9  48                            pha                  ; A=A&$59 X=A Y=$00B5 ; [SP-465]
; Interrupt return (RTI)
0005BA  40                            rti                  ; A=A&$59 X=A Y=$00B5 ; [SP-462]

; --- Data region ---
0005BB  4C2DB8EB                HEX     4C2DB8EB 48809154 7525ADE9 11B5F625
0005CB  AE698D2A                HEX     AE698D2A AD2B3051 96F62DAA 0DAC02B0
0005DB  D17777AD                HEX     D17777AD 2DC8E898 134CA038 8D4CA118
0005EB  89ED3C11                HEX     89ED3C11 D556ED7C 1255D774 D310F860
; --- End data region (64 bytes) ---

0005FB  C1 94             L_0005FB    cmp  ($94,X)         ; A=A&$59 X=A Y=$00B5 ; [SP-461]
0005FD  5A                            phy                  ; A=A&$59 X=A Y=$00B5 ; [SP-462]
0005FE  C0 5D                         cpy  #$5D            ; A=A&$59 X=A Y=$00B5 ; [SP-462]
000600  A9 D2                         lda  #$D2            ; A=$00D2 X=A Y=$00B5 ; [SP-462]
000602  2C A9 D0                      bit  $D0A9           ; A=$00D2 X=A Y=$00B5 ; [SP-462]
000605  2C A9 CD                      bit  $CDA9           ; SLOTEXP_$5A9 - Slot expansion ROM offset $5A9 {Slot}
000608  2C A9 C3                      bit  $C3A9           ; S3_$A9 - Slot 3 ROM offset $A9 {Slot}
00060B  85 02                         sta  $02             ; A=$00D2 X=A Y=$00B5 ; [SP-462]
00060D  A2 00                         ldx  #$00            ; A=$00D2 X=$0000 Y=$00B5 ; [SP-462]

; === while loop starts here (counter: X 'iter_x') [nest:1] ===
00060F  BD 00 06          L_00060F    lda  $0600,X         ; A=$00D2 X=$0000 Y=$00B5 ; [SP-462]
000612  9D 00 02                      sta  $0200,X         ; A=$00D2 X=$0000 Y=$00B5 ; [SP-462]
000615  E8                            inx                  ; A=$00D2 X=$0001 Y=$00B5 ; [SP-462]
000616  D0 F7                         bne  L_00060F        ; A=$00D2 X=$0001 Y=$00B5 ; [SP-462]
; === End of while loop (counter: X) ===

000618  4C 1B 02                      jmp  L_00021B        ; A=$00D2 X=$0001 Y=$00B5 ; [SP-462]
; === End of while loop (counter: X) ===


; --- Data region ---
00061B  AD51C0AD                HEX     AD51C0AD 54C0A000 A9048400 8501A902
00062B  A01B20D0                HEX     A01B20D0 02A2BCA0 00A9A091 00C8D0FB
00063B  E601CAD0                HEX     E601CAD0 F6A5028D 00048D27 048DD007
00064B  8DF707A0                HEX     8DF707A0 008400B9 C002F017 8501B9C1
00065B  028503C8                HEX     028503C8 C8AE30C0 A603CAD0 FDC601D0
00066B  F4F0E44C                HEX     F4F0E44C 00C64A4A 4A09C0A0 0020D002
00067B  A2008A95                HEX     A2008A95 009D0001 E8D0F8A2 09BDF002
00068B  9D0F04CA                HEX     9D0F04CA 10F79900 0299A002 C8C092D0
00069B  F56CF203                HEX     F56CF203 008401A4 01E601B9 0007F011
0006AB  205807A4                HEX     205807A4 01E601B9 00072000 074CA206
0006BB  00BD88C0                HEX     00BD88C0 60
; --- End data region (165 bytes) ---

0006C0  20 E0 20          L_0006C0    jsr  $20E0           ; Call $0020E0(A, X, Y)
0006C3  D0 20                         bne  L_0006E5        ; A=$00D2 X=$0001 Y=$00B5 ; [SP-481]
0006C5  C0 20                         cpy  #$20            ; A=$00D2 X=$0001 Y=$00B5 ; [SP-481]
0006C7  B0 20                         bcs  $06E9           ; A=$00D2 X=$0001 Y=$00B5 ; [SP-481]
0006C9  C0 20                         cpy  #$20            ; A=$00D2 X=$0001 Y=$00B5 ; [SP-481]
0006CB  D0 20                         bne  L_0006ED        ; A=$00D2 X=$0001 Y=$00B5 ; [SP-481]
0006CD  E0 00                         cpx  #$00            ; A=$00D2 X=$0001 Y=$00B5 ; [SP-481]
0006CF  00 48                         brk  #$48            ; A=$00D2 X=$0001 Y=$00B5 ; [SP-484]

; --- Data region ---
0006D1  AD83C0AD                HEX     AD83C0AD 83C06848 8DFDFF8D F30349A5
0006E1  8DF40368                HEX     8DF40368
; --- End data region (20 bytes) ---

0006E5  8C FC FF          L_0006E5    sty  $FFFC           ; RESET_VEC - RESET vector
0006E8  8C F2 03                      sty  $03F2           ; A=$00D2 X=$0001 Y=$00B5 ; [SP-483]
0006EB  60                            rts                  ; A=$00D2 X=$0001 Y=$00B5 ; [SP-481]

; --- Data region ---
0006EC  00                      HEX     00
; --- End data region (1 bytes) ---

0006ED  00 00             L_0006ED    brk  #$00            ; A=$00D2 X=$0001 Y=$00B5 ; [SP-484]

; --- Data region ---
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

; ============================================================================
; SEGMENT: Main Game Code ($4000-$71FF)
; ============================================================================
; This 12,800-byte block contains the main game logic and stays at its load
; address. Includes:
;   - Graphics initialization and HGR rendering
;   - Game state machine and main loop
;   - Keyboard input handling (Y/J/Space/G/A/F keys)
;   - Creature movement and collision detection
;   - Score display and level management
;   - Shape tables, color lookup tables, and level data
; ============================================================================

; --- Data region ---
004000  49                      HEX     49

; === while loop starts here (counter: X 'i') ===

; FUNC $004001: register -> A:X []
; Proto: uint32_t func_004001(uint16_t param_X);
; Liveness: params(X) returns(A,X,Y) [9 dead stores]
; --- End data region (1 bytes) ---

004001  24 12             L_004001    bit  $12            
004003  49 24                         eor  #$24            ; A=A^$24
004005  12 49                         ora  ($49)           ; A=A^$24
004007  24 12                         bit  $12             ; A=A^$24
004009  49 24                         eor  #$24            ; A=A^$24
00400B  12 49                         ora  ($49)           ; A=A^$24
00400D  24 12                         bit  $12             ; A=A^$24
00400F  49 24                         eor  #$24            ; A=A^$24
004011  12 49                         ora  ($49)           ; A=A^$24
004013  24 12                         bit  $12             ; A=A^$24
004015  49 24                         eor  #$24            ; A=A^$24
004017  12 49                         ora  ($49)           ; A=A^$24
004019  24 12                         bit  $12             ; A=A^$24
00401B  49 24                         eor  #$24            ; A=A^$24
00401D  12 49                         ora  ($49)           ; A=A^$24
00401F  24 12                         bit  $12             ; A=A^$24
004021  49 24                         eor  #$24            ; A=A^$24
004023  12 49                         ora  ($49)           ; A=A^$24
004025  24 12                         bit  $12             ; A=A^$24
004027  49 11                         eor  #$11            ; A=A^$11
; LUMA: gsos_inline_call
004029  22 44 08 11                   jsl  >$110844        ; A=A^$11
; LUMA: gsos_inline_call
00402D  22 44 08 11                   jsl  >$110844        ; A=A^$11 ; [SP-3]
; LUMA: gsos_inline_call
004031  22 44 08 11                   jsl  >$110844        ; A=A^$11 ; [SP-6]
; LUMA: gsos_inline_call
004035  22 44 08 11                   jsl  >$110844        ; A=A^$11 ; [SP-9]
; LUMA: gsos_inline_call
004039  22 44 08 11                   jsl  >$110844        ; A=A^$11 ; [SP-12]
; LUMA: gsos_inline_call
00403D  22 44 08 11                   jsl  >$110844        ; A=A^$11 ; [SP-15]
; LUMA: gsos_inline_call
004041  22 44 08 11                   jsl  >$110844        ; A=A^$11 ; [SP-18]
; LUMA: gsos_inline_call
004045  22 44 08 11                   jsl  >$110844        ; A=A^$11 ; [SP-21]
; LUMA: gsos_inline_call
004049  22 44 08 11                   jsl  >$110844        ; A=A^$11 ; [SP-24]
; LUMA: gsos_inline_call
00404D  22 44 08 21                   jsl  >$210844        ; A=A^$11 ; [SP-27]
004051  08                            php                  ; A=A^$11 ; [SP-28]
004052  42 10                         wdm  #$10            ; A=A^$11 ; [SP-28]
004054  04 21                         tsb  $21             ; A=A^$11 ; [SP-28]
004056  08                            php                  ; A=A^$11 ; [SP-29]
004057  42 10                         wdm  #$10            ; A=A^$11 ; [SP-29]
004059  04 21                         tsb  $21             ; A=A^$11 ; [SP-29]
00405B  08                            php                  ; A=A^$11 ; [SP-30]
00405C  42 10                         wdm  #$10            ; A=A^$11 ; [SP-30]
00405E  04 21                         tsb  $21             ; A=A^$11 ; [SP-30]
004060  08                            php                  ; A=A^$11 ; [SP-31]
004061  42 10                         wdm  #$10            ; A=A^$11 ; [SP-31]
004063  04 21                         tsb  $21             ; A=A^$11 ; [SP-31]
004065  08                            php                  ; A=A^$11 ; [SP-32]
004066  42 10                         wdm  #$10            ; A=A^$11 ; [SP-32]
004068  04 21                         tsb  $21             ; A=A^$11 ; [SP-32]
00406A  08                            php                  ; A=A^$11 ; [SP-33]
00406B  42 10                         wdm  #$10            ; A=A^$11 ; [SP-33]
00406D  04 21                         tsb  $21             ; A=A^$11 ; [SP-33]
00406F  08                            php                  ; A=A^$11 ; [SP-34]
004070  42 10                         wdm  #$10            ; A=A^$11 ; [SP-34]
004072  04 21                         tsb  $21             ; A=A^$11 ; [SP-34]
004074  08                            php                  ; A=A^$11 ; [SP-35]
004075  42 10                         wdm  #$10            ; A=A^$11 ; [SP-35]
004077  04 41                         tsb  $41             ; A=A^$11 ; [SP-35]
004079  20 10 08                      jsr  $0810           ; A=A^$11 ; [SP-37]
00407C  04 02                         tsb  $02             ; A=A^$11 ; [SP-37]
00407E  41 20                         eor  ($20,X)         ; A=A^$11 ; [SP-37]
004080  10 08                         bpl  L_00408A        ; A=A^$11 ; [SP-37]
004082  04 02                         tsb  $02             ; A=A^$11 ; [SP-37]
004084  41 20                         eor  ($20,X)         ; A=A^$11 ; [SP-37]
004086  10 08                         bpl  L_004090        ; A=A^$11 ; [SP-37]
004088  04 02                         tsb  $02             ; A=A^$11 ; [SP-37]
00408A  41 20             L_00408A    eor  ($20,X)         ; A=A^$11 ; [SP-37]
00408C  10 08                         bpl  L_004096        ; A=A^$11 ; [SP-37]
00408E  04 02                         tsb  $02             ; A=A^$11 ; [SP-37]
004090  41 20             L_004090    eor  ($20,X)         ; A=A^$11 ; [SP-37]
004092  10 08                         bpl  L_00409C        ; A=A^$11 ; [SP-37]
004094  04 02                         tsb  $02             ; A=A^$11 ; [SP-37]
004096  41 20             L_004096    eor  ($20,X)         ; A=A^$11 ; [SP-37]
004098  10 08                         bpl  $40A2           ; A=A^$11 ; [SP-37]
00409A  04 02                         tsb  $02             ; A=A^$11 ; [SP-37]
00409C  41 20             L_00409C    eor  ($20,X)         ; A=A^$11 ; [SP-37]
00409E  10 08                         bpl  L_0040A8        ; A=A^$11 ; [SP-37]
0040A0  7F 7F 7F 7F                   adc  >$7F7F7F,X      ; A=A^$11 ; [SP-37]
0040A4  7F 7F 7F 7F                   adc  >$7F7F7F,X      ; A=A^$11 ; [SP-37]
0040A8  7F 7F 7F 7F       L_0040A8    adc  >$7F7F7F,X      ; A=A^$11 ; [SP-37]
0040AC  7F 7F 7F 7F                   adc  >$7F7F7F,X      ; A=A^$11 ; [SP-37]
0040B0  7F 7F 7F 7F                   adc  >$7F7F7F,X      ; A=A^$11 ; [SP-37]
0040B4  7F 7F 7F 7F                   adc  >$7F7F7F,X      ; A=A^$11 ; [SP-37]
0040B8  7F 7F 7F 7F                   adc  >$7F7F7F,X      ; A=A^$11 ; [SP-37]
0040BC  7F 7F 7F 7F                   adc  >$7F7F7F,X      ; A=A^$11 ; [SP-37]

; === while loop starts here (counter: $00, range: 0..17265, step: 17268, iters: 74302934238097) [nest:1] [inner] ===

; FUNC $0040C0: register -> A:X [L]
; Proto: uint32_t func_0040C0(void);
; Liveness: returns(A,X,Y) [2 dead stores]
0040C0  A8                L_0040C0    tay                  ; A=A^$11 Y=A ; [SP-37]
; LUMA: data_array_y
0040C1  B9 7C 5D                      lda  $5D7C,Y         ; A=A^$11 Y=A ; [SP-37]
0040C4  8D 05 41                      sta  $4105           ; A=A^$11 Y=A ; [SP-37]
; LUMA: data_array_y
0040C7  B9 1D 5E                      lda  $5E1D,Y         ; A=A^$11 Y=A ; [SP-37]
0040CA  8D 06 41                      sta  $4106           ; A=A^$11 Y=A ; [SP-37]
0040CD  A5 02                         lda  $02             ; A=[$0002] Y=A ; [SP-37]
0040CF  85 03                         sta  $03             ; A=[$0002] Y=A ; [SP-37]
0040D1  18                            clc                  ; A=[$0002] Y=A ; [SP-37]
0040D2  79 BE 5E                      adc  $5EBE,Y         ; A=[$0002] Y=A ; [SP-37]
0040D5  85 02                         sta  $02             ; A=[$0002] Y=A ; [SP-37]
0040D7  A5 04                         lda  $04             ; A=[$0004] Y=A ; [SP-37]
0040D9  AA                            tax                  ; A=[$0004] X=[$0004] Y=A ; [SP-37]
0040DA  18                            clc                  ; A=[$0004] X=[$0004] Y=A ; [SP-37]
0040DB  79 5F 5F                      adc  $5F5F,Y         ; A=[$0004] X=[$0004] Y=A ; [SP-37]
0040DE  85 05                         sta  $05             ; A=[$0004] X=[$0004] Y=A ; [SP-37]

; === while loop starts here (counter: $00, range: 0..17372, step: 17373, iters: 96795677972487) [nest:15] [inner] ===
0040E0  E0 C0             L_0040E0    cpx  #$C0            ; A=[$0004] X=[$0004] Y=A ; [SP-37]
0040E2  B0 3B                         bcs  L_00411F        ; A=[$0004] X=[$0004] Y=A ; [SP-37]
0040E4  E4 08                         cpx  $08             ; A=[$0004] X=[$0004] Y=A ; [SP-37]
0040E6  90 25                         bcc  L_00410D        ; A=[$0004] X=[$0004] Y=A ; [SP-37]
0040E8  E4 09                         cpx  $09             ; A=[$0004] X=[$0004] Y=A ; [SP-37]
0040EA  B0 21                         bcs  L_00410D        ; A=[$0004] X=[$0004] Y=A ; [SP-37]
; LUMA: data_array_x
0040EC  BD 6C 41                      lda  $416C,X         ; A=[$0004] X=[$0004] Y=A ; [SP-37]
0040EF  85 06                         sta  $06             ; A=[$0004] X=[$0004] Y=A ; [SP-37]
; LUMA: data_array_x
0040F1  BD 2C 42                      lda  $422C,X         ; A=[$0004] X=[$0004] Y=A ; [SP-37]
0040F4  85 07                         sta  $07             ; A=[$0004] X=[$0004] Y=A ; [SP-37]
0040F6  A4 03                         ldy  $03             ; A=[$0004] X=[$0004] Y=A ; [SP-37]

; === while loop starts here (counter: $00 '', range: 0..17320, step: 17132, iters: 73581379732397) [nest:16] [inner] ===
0040F8  C0 28             L_0040F8    cpy  #$28            ; A=[$0004] X=[$0004] Y=A ; [SP-37]
0040FA  B0 11                         bcs  L_00410D        ; A=[$0004] X=[$0004] Y=A ; [SP-37]
0040FC  C4 0A                         cpy  $0A             ; A=[$0004] X=[$0004] Y=A ; [SP-37]
0040FE  90 0D                         bcc  L_00410D        ; A=[$0004] X=[$0004] Y=A ; [SP-37]
004100  C4 0B                         cpy  $0B             ; A=[$0004] X=[$0004] Y=A ; [SP-37]
004102  B0 09                         bcs  L_00410D        ; A=[$0004] X=[$0004] Y=A ; [SP-37]
; LUMA: hw_keyboard_read
004104  AD 00 00                      lda  !$0000          ; A=[$0000] X=[$0004] Y=A ; [SP-37]
004107  49 FF                         eor  #$FF            ; A=A^$FF X=[$0004] Y=A ; [SP-37]
004109  31 06                         and  ($06),Y         ; A=A^$FF X=[$0004] Y=A ; [SP-37]
00410B  91 06                         sta  ($06),Y         ; A=A^$FF X=[$0004] Y=A ; [SP-37]
00410D  EE 05 41          L_00410D    inc  $4105           ; A=A^$FF X=[$0004] Y=A ; [SP-37]
004110  D0 03                         bne  L_004115        ; A=A^$FF X=[$0004] Y=A ; [SP-37]
004112  EE 06 41                      inc  $4106           ; A=A^$FF X=[$0004] Y=A ; [SP-37]
004115  C8                L_004115    iny                  ; A=A^$FF X=[$0004] Y=Y+$01 ; [SP-37]
004116  C4 02                         cpy  $02             ; A=A^$FF X=[$0004] Y=Y+$01 ; [SP-37]
004118  90 DE                         bcc  L_0040F8        ; A=A^$FF X=[$0004] Y=Y+$01 ; [SP-37]
; === End of while loop (counter: $00) ===

00411A  E8                            inx                  ; A=A^$FF X=X+$01 Y=Y+$01 ; [SP-37]
00411B  E4 05                         cpx  $05             ; A=A^$FF X=X+$01 Y=Y+$01 ; [SP-37]
00411D  90 C1                         bcc  L_0040E0        ; A=A^$FF X=X+$01 Y=Y+$01 ; [SP-37]
; === End of while loop (counter: $00) ===

; LUMA: epilogue_rts
00411F  60                L_00411F    rts                  ; A=A^$FF X=X+$01 Y=Y+$01 ; [SP-35]

; === while loop starts here (counter: Y 'j', range: 0..192, iters: 192) [nest:7] ===

; FUNC $004120: register -> A:X [I]
; Proto: uint32_t func_004120(void);
; Liveness: returns(A,X,Y) [2 dead stores]
004120  A9 00             L_004120    lda  #$00            ; A=$0000 X=X+$01 Y=Y+$01 ; [SP-35]
004122  A2 20                         ldx  #$20            ; A=$0000 X=$0020 Y=Y+$01 ; [SP-35]
004124  A8                            tay                  ; A=$0000 X=$0020 Y=$0000 ; [SP-35]
004125  8E 2A 41                      stx  $412A           ; A=$0000 X=$0020 Y=$0000 ; [SP-35]

; === while loop starts here (counter: Y 'iter_y') [nest:16] ===
004128  99 00 40          L_004128    sta  $4000,Y         ; A=$0000 X=$0020 Y=$0000 ; [SP-35]
00412B  C8                            iny                  ; A=$0000 X=$0020 Y=$0001 ; [SP-35]
00412C  D0 FA                         bne  L_004128        ; A=$0000 X=$0020 Y=$0001 ; [SP-35]
; === End of while loop (counter: Y) ===

00412E  EE 2A 41                      inc  $412A           ; A=$0000 X=$0020 Y=$0001 ; [SP-35]
; LUMA: loop_dex_bne
004131  CA                            dex                  ; A=$0000 X=$001F Y=$0001 ; [SP-35]
004132  D0 F4                         bne  L_004128        ; A=$0000 X=$001F Y=$0001 ; [SP-35]
; === End of loop (counter: X) ===

; LUMA: hw_keyboard_read
; -- video_mode_read: Enable graphics mode --
004134  AD 50 C0                      lda  $C050           ; TXTCLR - Enable graphics mode {Video} <video_mode_read>
; LUMA: hw_keyboard_read
004137  AD 57 C0                      lda  $C057           ; HIRES - Hi-res graphics mode {Video} <video_mode_read>
; LUMA: hw_keyboard_read
00413A  AD 52 C0                      lda  $C052           ; MIXCLR - Full screen graphics {Video} <video_mode_read>
; LUMA: epilogue_rts
00413D  60                            rts                  ; A=[$C052] X=$001F Y=$0001 ; [SP-33]

; === while loop starts here (counter: Y 'j', range: 0..192, iters: 192) [nest:7] ===

; FUNC $00413E: register -> A:X [L]
; Proto: uint32_t func_00413E(void);
; Liveness: returns(A,X,Y)
00413E  A6 08             L_00413E    ldx  $08             ; A=[$C052] X=$001F Y=$0001 ; [SP-33]

; === while loop starts here (counter: X 'iter_x') [nest:18] ===
; LUMA: data_array_x
004140  BD 6C 41          L_004140    lda  $416C,X         ; -> $418B ; A=[$C052] X=$001F Y=$0001 ; [SP-33]
004143  85 06                         sta  $06             ; A=[$C052] X=$001F Y=$0001 ; [SP-33]
; LUMA: data_array_x
004145  BD 2C 42                      lda  $422C,X         ; -> $424B ; A=[$C052] X=$001F Y=$0001 ; [SP-33]
004148  85 07                         sta  $07             ; A=[$C052] X=$001F Y=$0001 ; [SP-33]
00414A  A4 0A                         ldy  $0A             ; A=[$C052] X=$001F Y=$0001 ; [SP-33]
00414C  A9 00                         lda  #$00            ; A=$0000 X=$001F Y=$0001 ; [SP-33]

; === while loop starts here (counter: Y 'iter_y') [nest:19] ===
00414E  91 06             L_00414E    sta  ($06),Y         ; A=$0000 X=$001F Y=$0001 ; [SP-33]
004150  C8                            iny                  ; A=$0000 X=$001F Y=$0002 ; [SP-33]
004151  C4 0B                         cpy  $0B             ; A=$0000 X=$001F Y=$0002 ; [SP-33]
004153  90 F9                         bcc  L_00414E        ; A=$0000 X=$001F Y=$0002 ; [SP-33]
; === End of while loop (counter: Y) ===

004155  E8                            inx                  ; A=$0000 X=$0020 Y=$0002 ; [SP-33]
004156  E4 09                         cpx  $09             ; A=$0000 X=$0020 Y=$0002 ; [SP-33]
004158  90 E6                         bcc  L_004140        ; A=$0000 X=$0020 Y=$0002 ; [SP-33]
; === End of while loop (counter: X) ===

; LUMA: epilogue_rts
00415A  60                            rts                  ; A=$0000 X=$0020 Y=$0002 ; [SP-31]

; === while loop starts here (counter: Y 'j', range: 0..192, iters: 192) [nest:10] ===

; FUNC $00415B: register -> A:X []
; Proto: uint32_t func_00415B(uint16_t param_X, uint16_t param_Y);
; Liveness: params(X,Y) returns(A,X,Y)
00415B  A9 09             L_00415B    lda  #$09            ; A=$0009 X=$0020 Y=$0002 ; [SP-31]
00415D  85 0A                         sta  $0A             ; A=$0009 X=$0020 Y=$0002 ; [SP-31]
00415F  A9 01                         lda  #$01            ; A=$0001 X=$0020 Y=$0002 ; [SP-31]
004161  85 08                         sta  $08             ; A=$0001 X=$0020 Y=$0002 ; [SP-31]
004163  A9 28                         lda  #$28            ; A=$0028 X=$0020 Y=$0002 ; [SP-31]
004165  85 0B                         sta  $0B             ; A=$0028 X=$0020 Y=$0002 ; [SP-31]
004167  A9 C0                         lda  #$C0            ; A=$00C0 X=$0020 Y=$0002 ; [SP-31]
004169  85 09                         sta  $09             ; A=$00C0 X=$0020 Y=$0002 ; [SP-31]
; LUMA: epilogue_rts
00416B  60                            rts                  ; A=$00C0 X=$0020 Y=$0002 ; [SP-29]
; LUMA: int_brk

; --- Data region ---
00416C  00000000                HEX     00000000 00000000 80808080 80808080
; LUMA: int_brk
00417C  00000000                HEX     00000000 00000000 80808080 80808080
; LUMA: int_brk
00418C  00000000                HEX     00000000 00000000 80808080 80808080
; LUMA: int_brk
00419C  00000000                HEX     00000000 00000000 80808080 80808080
; String: "((((((((((((((((((((((((((((((((((((((("
0041AC  28282828                HEX     28282828 28282828 A8A8A8A8 A8A8A8A8
0041BC  28282828                HEX     28282828 28282828 A8A8A8A8 A8A8A8A8
0041CC  28282828                HEX     28282828 28282828 A8A8A8A8 A8A8A8A8
; String: "(((((((((((((((PPPPPPPPPPPPPPPPPPPPPPPP"
0041DC  28282828                HEX     28282828 28282828 A8A8A8A8 A8A8A8A8
0041EC  50505050                HEX     50505050 50505050 D0D0D0D0 D0D0D0D0
0041FC  50505050                HEX     50505050 50505050 D0D0D0D0 D0D0D0D0
00420C  50505050                HEX     50505050 50505050 D0D0D0D0 D0D0D0D0
00421C  50505050                HEX     50505050 50505050 D0D0D0D0 D0D0D0D0
; String: "$(,048< $(,048<!%)-159=!%)-159="
00422C  2024282C                HEX     2024282C 3034383C 2024282C 3034383C
00423C  2125292D                HEX     2125292D 3135393D 2125292D 3135393D
; LUMA: gsos_inline_call
00424C  22262A2E                HEX     22262A2E 32363A3E 22262A2E 32363A3E
00425C  23272B2F                HEX     23272B2F 33373B3F 23272B2F 33373B3F
00426C  2024282C                HEX     2024282C 3034383C 2024282C 3034383C
00427C  2125292D                HEX     2125292D 3135393D 2125292D 3135393D
; LUMA: gsos_inline_call
00428C  22262A2E                HEX     22262A2E 32363A3E 22262A2E 32363A3E
00429C  23272B2F                HEX     23272B2F 33373B3F 23272B2F 33373B3F
0042AC  2024282C                HEX     2024282C 3034383C 2024282C 3034383C
; String: "%)-159=!%)-159=\x22&*.26:>\x22&*.26:>#"
0042BC  2125292D                HEX     2125292D 3135393D 2125292D 3135393D
; LUMA: gsos_inline_call
0042CC  22262A2E                HEX     22262A2E 32363A3E 22262A2E 32363A3E
0042DC  23272B2F                HEX     23272B2F 33373B3F 23272B2F 33373B3F

; === while loop starts here [nest:19] ===

; FUNC $0042EC: register -> A:X []
; Proto: uint32_t func_0042EC(uint16_t param_A);
; Frame: push_only [saves: A]
; Liveness: params(A) returns(A,X,Y) [20 dead stores]
; --- End data region (384 bytes) ---

0042EC  48                L_0042EC    pha                  ; A=$00C0 X=$0020 Y=$0002 ; [SP-41]
0042ED  4A                            lsr  a               ; A=$00C0 X=$0020 Y=$0002 ; [SP-41]
0042EE  4A                            lsr  a               ; A=$00C0 X=$0020 Y=$0002 ; [SP-41]
0042EF  4A                            lsr  a               ; A=$00C0 X=$0020 Y=$0002 ; [SP-41]
0042F0  4A                            lsr  a               ; A=$00C0 X=$0020 Y=$0002 ; [SP-41]
0042F1  29 0F                         and  #$0F            ; A=A&$0F X=$0020 Y=$0002 ; [SP-41]
0042F3  20 16 04                      jsr  $0416           ; A=A&$0F X=$0020 Y=$0002 ; [SP-43]
0042F6  68                            pla                  ; A=[stk] X=$0020 Y=$0002 ; [SP-42]
0042F7  29 0F                         and  #$0F            ; A=A&$0F X=$0020 Y=$0002 ; [SP-42]
0042F9  4C 16 04                      jmp  $0416           ; A=A&$0F X=$0020 Y=$0002 ; [SP-42]

; === while loop starts here (counter: Y 'j', range: 0..192, iters: 192) [nest:9] ===

; FUNC $0042FC: unknown -> A:X []
; Liveness: returns(A,X,Y) [16 dead stores]
0042FC  A9 01             L_0042FC    lda  #$01            ; A=$0001 X=$0020 Y=$0002 ; [SP-42]
0042FE  85 02                         sta  $02             ; A=$0001 X=$0020 Y=$0002 ; [SP-42]
004300  A9 08                         lda  #$08            ; A=$0008 X=$0020 Y=$0002 ; [SP-42]
004302  85 04                         sta  $04             ; A=$0008 X=$0020 Y=$0002 ; [SP-42]
004304  A9 0F                         lda  #$0F            ; A=$000F X=$0020 Y=$0002 ; [SP-42]
004306  20 16 04                      jsr  $0416           ; Call $000416(A)
004309  A9 01                         lda  #$01            ; A=$0001 X=$0020 Y=$0002 ; [SP-44]
00430B  85 02                         sta  $02             ; A=$0001 X=$0020 Y=$0002 ; [SP-44]
00430D  A9 10                         lda  #$10            ; A=$0010 X=$0020 Y=$0002 ; [SP-44]
00430F  85 04                         sta  $04             ; A=$0010 X=$0020 Y=$0002 ; [SP-44]
004311  A9 10                         lda  #$10            ; A=$0010 X=$0020 Y=$0002 ; [OPT] REDUNDANT_LOAD: Redundant LDA: same value loaded at $00430D ; [SP-44]
004313  20 16 04                      jsr  $0416           ; Call $000416(A)
004316  A9 01                         lda  #$01            ; A=$0001 X=$0020 Y=$0002 ; [SP-46]
004318  85 02                         sta  $02             ; A=$0001 X=$0020 Y=$0002 ; [SP-46]
00431A  A9 A7                         lda  #$A7            ; A=$00A7 X=$0020 Y=$0002 ; [SP-46]
00431C  85 04                         sta  $04             ; A=$00A7 X=$0020 Y=$0002 ; [SP-46]
00431E  A9 15                         lda  #$15            ; A=$0015 X=$0020 Y=$0002 ; [SP-46]
004320  20 16 04                      jsr  $0416           ; Call $000416(A)
004323  A9 01                         lda  #$01            ; A=$0001 X=$0020 Y=$0002 ; [SP-48]
004325  85 02                         sta  $02             ; A=$0001 X=$0020 Y=$0002 ; [SP-48]
004327  A9 AF                         lda  #$AF            ; A=$00AF X=$0020 Y=$0002 ; [SP-48]
004329  85 04                         sta  $04             ; A=$00AF X=$0020 Y=$0002 ; [SP-48]
00432B  A9 12                         lda  #$12            ; A=$0012 X=$0020 Y=$0002 ; [SP-48]
00432D  20 16 04                      jsr  $0416           ; Call $000416(A)
004330  A9 01                         lda  #$01            ; A=$0001 X=$0020 Y=$0002 ; [SP-50]
004332  85 02                         sta  $02             ; A=$0001 X=$0020 Y=$0002 ; [SP-50]
004334  A9 B7                         lda  #$B7            ; A=$00B7 X=$0020 Y=$0002 ; [SP-50]
004336  85 04                         sta  $04             ; A=$00B7 X=$0020 Y=$0002 ; [SP-50]
004338  A9 13                         lda  #$13            ; A=$0013 X=$0020 Y=$0002 ; [SP-50]
00433A  20 16 04                      jsr  $0416           ; Call $000416(A)
00433D  A9 01                         lda  #$01            ; A=$0001 X=$0020 Y=$0002 ; [SP-52]
00433F  85 02                         sta  $02             ; A=$0001 X=$0020 Y=$0002 ; [SP-52]
004341  A9 4C                         lda  #$4C            ; A=$004C X=$0020 Y=$0002 ; [SP-52]
004343  85 04                         sta  $04             ; A=$004C X=$0020 Y=$0002 ; [SP-52]
004345  A9 0A                         lda  #$0A            ; A=$000A X=$0020 Y=$0002 ; [SP-52]
004347  20 16 04                      jsr  $0416           ; Call $000416(A)
00434A  A9 02                         lda  #$02            ; A=$0002 X=$0020 Y=$0002 ; [SP-54]
00434C  85 02                         sta  $02             ; A=$0002 X=$0020 Y=$0002 ; [SP-54]
00434E  A9 64                         lda  #$64            ; A=$0064 X=$0020 Y=$0002 ; [SP-54]
004350  85 04                         sta  $04             ; A=$0064 X=$0020 Y=$0002 ; [SP-54]
004352  A9 14                         lda  #$14            ; A=$0014 X=$0020 Y=$0002 ; [SP-54]
004354  20 16 04                      jsr  $0416           ; Call $000416(A)
004357  A9 01                         lda  #$01            ; A=$0001 X=$0020 Y=$0002 ; [SP-56]
004359  85 02                         sta  $02             ; A=$0001 X=$0020 Y=$0002 ; [SP-56]
00435B  A9 6C                         lda  #$6C            ; A=$006C X=$0020 Y=$0002 ; [SP-56]
00435D  85 04                         sta  $04             ; A=$006C X=$0020 Y=$0002 ; [SP-56]
00435F  A9 0A                         lda  #$0A            ; A=$000A X=$0020 Y=$0002 ; [SP-56]
004361  20 16 04                      jsr  $0416           ; Call $000416(A)
004364  A9 01                         lda  #$01            ; A=$0001 X=$0020 Y=$0002 ; [SP-58]
004366  85 02                         sta  $02             ; A=$0001 X=$0020 Y=$0002 ; [SP-58]
004368  A9 84                         lda  #$84            ; A=$0084 X=$0020 Y=$0002 ; [SP-58]
00436A  85 04                         sta  $04             ; A=$0084 X=$0020 Y=$0002 ; [SP-58]
00436C  A9 19                         lda  #$19            ; A=$0019 X=$0020 Y=$0002 ; [SP-58]
00436E  20 16 04                      jsr  $0416           ; Call $000416(A)
004371  20 87 43                      jsr  L_004387        ; A=$0019 X=$0020 Y=$0002 ; [SP-62]
004374  20 9E 43                      jsr  L_00439E        ; A=$0019 X=$0020 Y=$0002 ; [SP-64]
004377  4C CD 43                      jmp  L_0043CD        ; A=$0019 X=$0020 Y=$0002 ; [SP-64]

; === while loop starts here (counter: $00) [nest:8] [inner] ===

; FUNC $00437A: register -> A:X [L]
; Liveness: returns(A,X,Y) [7 dead stores]
00437A  A9 56             L_00437A    lda  #$56            ; A=$0056 X=$0020 Y=$0002 ; [SP-64]
00437C  85 04                         sta  $04             ; A=$0056 X=$0020 Y=$0002 ; [SP-64]
00437E  A9 17                         lda  #$17            ; A=$0017 X=$0020 Y=$0002 ; [SP-64]
004380  85 02                         sta  $02             ; A=$0017 X=$0020 Y=$0002 ; [SP-64]
004382  A9 18                         lda  #$18            ; A=$0018 X=$0020 Y=$0002 ; [SP-64]
004384  4C 16 04                      jmp  $0416           ; A=$0018 X=$0020 Y=$0002 ; [SP-64]

; === while loop starts here (counter: A 'counter_a') [nest:13] ===

; FUNC $004387: unknown -> A:X []
; Liveness: returns(A,X,Y) [6 dead stores]
004387  A9 01             L_004387    lda  #$01            ; A=$0001 X=$0020 Y=$0002 ; [SP-64]
004389  85 02                         sta  $02             ; A=$0001 X=$0020 Y=$0002 ; [SP-64]
00438B  A9 54                         lda  #$54            ; A=$0054 X=$0020 Y=$0002 ; [SP-64]
00438D  85 04                         sta  $04             ; A=$0054 X=$0020 Y=$0002 ; [SP-64]
00438F  A5 0D                         lda  $0D             ; A=[$000D] X=$0020 Y=$0002 ; [SP-64]
004391  20 EC 42                      jsr  L_0042EC        ; Call $0042EC(A)
; === End of while loop ===

004394  A5 0C                         lda  $0C             ; A=[$000C] X=$0020 Y=$0002 ; [SP-66]
004396  20 EC 42                      jsr  L_0042EC        ; Call $0042EC(A)
; === End of while loop ===

004399  A9 00                         lda  #$00            ; A=$0000 X=$0020 Y=$0002 ; [SP-68]
00439B  4C 16 04                      jmp  $0416           ; A=$0000 X=$0020 Y=$0002 ; [SP-68]

; === while loop starts here (counter: X 'i') [nest:24] ===

; FUNC $00439E: unknown -> A:X []
; Liveness: returns(A,X,Y) [3 dead stores]
00439E  A9 01             L_00439E    lda  #$01            ; A=$0001 X=$0020 Y=$0002 ; [SP-68]
0043A0  85 02                         sta  $02             ; A=$0001 X=$0020 Y=$0002 ; [SP-68]
0043A2  A9 74                         lda  #$74            ; A=$0074 X=$0020 Y=$0002 ; [SP-68]
0043A4  85 04                         sta  $04             ; A=$0074 X=$0020 Y=$0002 ; [SP-68]
0043A6  A5 0F                         lda  $0F             ; A=[$000F] X=$0020 Y=$0002 ; [SP-68]
0043A8  20 EC 42                      jsr  L_0042EC        ; Call $0042EC(A)
; === End of while loop ===

0043AB  A5 0E                         lda  $0E             ; A=[$000E] X=$0020 Y=$0002 ; [SP-70]
0043AD  20 EC 42                      jsr  L_0042EC        ; Call $0042EC(A)
; === End of while loop ===

0043B0  A9 00                         lda  #$00            ; A=$0000 X=$0020 Y=$0002 ; [SP-72]
0043B2  4C 16 04                      jmp  $0416           ; A=$0000 X=$0020 Y=$0002 ; [SP-72]

; === while loop starts here (counter: Y 'j', range: 0..192, iters: 192) [nest:15] ===

; FUNC $0043B5: register -> A:X [L]
; Proto: uint32_t func_0043B5(void);
; Liveness: returns(A,X,Y)
0043B5  A0 08             L_0043B5    ldy  #$08            ; A=$0000 X=$0020 Y=$0008 ; [SP-72]
0043B7  A2 00                         ldx  #$00            ; A=$0000 X=$0000 Y=$0008 ; [SP-72]

; === while loop starts here (counter: X 'iter_x', range: 0..192, iters: 192) [nest:28] ===
0043B9  BD 6C 41          L_0043B9    lda  $416C,X         ; A=$0000 X=$0000 Y=$0008 ; [SP-72]
0043BC  85 06                         sta  $06             ; A=$0000 X=$0000 Y=$0008 ; [SP-72]
; LUMA: data_array_x
0043BE  BD 2C 42                      lda  $422C,X         ; A=$0000 X=$0000 Y=$0008 ; [SP-72]
0043C1  85 07                         sta  $07             ; A=$0000 X=$0000 Y=$0008 ; [SP-72]
0043C3  A9 94                         lda  #$94            ; A=$0094 X=$0000 Y=$0008 ; [SP-72]
0043C5  91 06                         sta  ($06),Y         ; A=$0094 X=$0000 Y=$0008 ; [SP-72]
0043C7  E8                            inx                  ; A=$0094 X=$0001 Y=$0008 ; [SP-72]
0043C8  E0 C0                         cpx  #$C0            ; A=$0094 X=$0001 Y=$0008 ; [SP-72]
0043CA  90 ED                         bcc  L_0043B9        ; A=$0094 X=$0001 Y=$0008 ; [SP-72]
; === End of while loop (counter: X) ===

; LUMA: epilogue_rts
0043CC  60                            rts                  ; A=$0094 X=$0001 Y=$0008 ; [SP-70]

; === while loop starts here (counter: Y 'j', range: 0..192, iters: 192) [nest:13] ===

; FUNC $0043CD: register -> A:X [L]
; Proto: uint32_t func_0043CD(uint16_t param_X, uint16_t param_Y);
; Liveness: params(X,Y) returns(A,X,Y) [2 dead stores]
0043CD  A9 03             L_0043CD    lda  #$03            ; A=$0003 X=$0001 Y=$0008 ; [SP-70]
0043CF  85 02                         sta  $02             ; A=$0003 X=$0001 Y=$0008 ; [SP-70]
0043D1  A9 8C                         lda  #$8C            ; A=$008C X=$0001 Y=$0008 ; [SP-70]
0043D3  85 04                         sta  $04             ; A=$008C X=$0001 Y=$0008 ; [SP-70]
0043D5  A5 10                         lda  $10             ; A=[$0010] X=$0001 Y=$0008 ; [SP-70]
0043D7  C9 0A                         cmp  #$0A            ; A=[$0010] X=$0001 Y=$0008 ; [SP-70]
0043D9  90 02                         bcc  L_0043DD        ; A=[$0010] X=$0001 Y=$0008 ; [SP-70]
0043DB  A9 09                         lda  #$09            ; A=$0009 X=$0001 Y=$0008 ; [SP-70]
0043DD  4C 16 04          L_0043DD    jmp  $0416           ; A=$0009 X=$0001 Y=$0008 ; [SP-70]

; === while loop starts here (counter: Y 'j', range: 0..192, iters: 192) [nest:11] ===

; FUNC $0043E0: register -> A:X [LI]
; Proto: uint32_t func_0043E0(uint16_t param_X, uint16_t param_Y);
; Liveness: params(X,Y) returns(A,X,Y)
; LUMA: hw_keyboard_read
0043E0  AD 00 C0          L_0043E0    lda  $C000           ; KBD - Keyboard data / 80STORE off {Keyboard} <keyboard_read>
0043E3  10 12                         bpl  L_0043F7        ; A=[$C000] X=$0001 Y=$0008 ; [SP-70]
0043E5  8D 10 C0                      sta  $C010           ; KBDSTRB - Clear keyboard strobe {Keyboard} <keyboard_strobe>
0043E8  C9 9B                         cmp  #$9B            ; A=[$C000] X=$0001 Y=$0008 ; [SP-70]
0043EA  D0 03                         bne  L_0043EF        ; A=[$C000] X=$0001 Y=$0008 ; [SP-70]
0043EC  85 36                         sta  $36             ; A=[$C000] X=$0001 Y=$0008 ; [SP-70]
; LUMA: epilogue_rts
0043EE  60                            rts                  ; A=[$C000] X=$0001 Y=$0008 ; [SP-68]
0043EF  C9 D9             L_0043EF    cmp  #$D9            ; A=[$C000] X=$0001 Y=$0008 ; [SP-68]
0043F1  D0 05                         bne  L_0043F8        ; A=[$C000] X=$0001 Y=$0008 ; [SP-68]
0043F3  A9 00                         lda  #$00            ; A=$0000 X=$0001 Y=$0008 ; [SP-68]
0043F5  85 11                         sta  $11             ; A=$0000 X=$0001 Y=$0008 ; [SP-68]
; LUMA: epilogue_rts
0043F7  60                L_0043F7    rts                  ; A=$0000 X=$0001 Y=$0008 ; [SP-66]
0043F8  C9 CA             L_0043F8    cmp  #$CA            ; A=$0000 X=$0001 Y=$0008 ; [SP-66]
0043FA  D0 05                         bne  L_004401        ; A=$0000 X=$0001 Y=$0008 ; [SP-66]
0043FC  A9 01                         lda  #$01            ; A=$0001 X=$0001 Y=$0008 ; [SP-66]
0043FE  85 11                         sta  $11             ; A=$0001 X=$0001 Y=$0008 ; [SP-66]
; LUMA: epilogue_rts
004400  60                            rts                  ; A=$0001 X=$0001 Y=$0008 ; [SP-64]
004401  C9 A0             L_004401    cmp  #$A0            ; A=$0001 X=$0001 Y=$0008 ; [SP-64]
004403  D0 05                         bne  L_00440A        ; A=$0001 X=$0001 Y=$0008 ; [SP-64]
004405  A9 02                         lda  #$02            ; A=$0002 X=$0001 Y=$0008 ; [SP-64]
004407  85 11                         sta  $11             ; A=$0002 X=$0001 Y=$0008 ; [SP-64]
; LUMA: epilogue_rts
004409  60                            rts                  ; A=$0002 X=$0001 Y=$0008 ; [SP-62]
00440A  C9 C7             L_00440A    cmp  #$C7            ; A=$0002 X=$0001 Y=$0008 ; [SP-62]
00440C  D0 05                         bne  L_004413        ; A=$0002 X=$0001 Y=$0008 ; [SP-62]
00440E  A9 03                         lda  #$03            ; A=$0003 X=$0001 Y=$0008 ; [SP-62]
004410  85 11                         sta  $11             ; A=$0003 X=$0001 Y=$0008 ; [SP-62]
; LUMA: epilogue_rts
004412  60                            rts                  ; A=$0003 X=$0001 Y=$0008 ; [SP-60]
004413  C9 C1             L_004413    cmp  #$C1            ; A=$0003 X=$0001 Y=$0008 ; [SP-60]
004415  F0 05                         beq  L_00441C        ; A=$0003 X=$0001 Y=$0008 ; [SP-60]
004417  C9 C6                         cmp  #$C6            ; A=$0003 X=$0001 Y=$0008 ; [SP-60]
004419  F0 01                         beq  L_00441C        ; A=$0003 X=$0001 Y=$0008 ; [SP-60]
; LUMA: epilogue_rts
00441B  60                            rts                  ; A=$0003 X=$0001 Y=$0008 ; [SP-58]
00441C  4C 81 53          L_00441C    jmp  L_005381        ; A=$0003 X=$0001 Y=$0008 ; [SP-58]
; LUMA: data_array_x

; --- Data region ---
00441F  BD3C5D85                HEX     BD3C5D85 02BD445D 85048A18 691A4C62
00442F  04BD3C5D                HEX     04BD3C5D 8502BD44 5D85048A 18691A4C
00443F  C040                    HEX     C040

; === while loop starts here (counter: $00 '', range: 0..21184, step: 16576, iters: 91491393360691) [nest:23] [inner] ===

; FUNC $004441: register -> A:X []
; Proto: uint32_t func_004441(void);
; Liveness: returns(A,X,Y)
; --- End data region (34 bytes) ---

004441  E0 03             L_004441    cpx  #$03            ; A=$0003 X=$0001 Y=$0008 ; [SP-58]
004443  F0 31                         beq  L_004476        ; A=$0003 X=$0001 Y=$0008 ; [SP-58]
004445  E0 02                         cpx  #$02            ; A=$0003 X=$0001 Y=$0008 ; [SP-58]
004447  F0 22                         beq  L_00446B        ; A=$0003 X=$0001 Y=$0008 ; [SP-58]
004449  E0 01                         cpx  #$01            ; A=$0003 X=$0001 Y=$0008 ; [SP-58]
00444B  F0 45                         beq  L_004492        ; A=$0003 X=$0001 Y=$0008 ; [SP-58]
00444D  A2 00                         ldx  #$00            ; A=$0003 X=$0000 Y=$0008 ; [SP-58]
00444F  A0 18                         ldy  #$18            ; A=$0003 X=$0000 Y=$0018 ; [SP-58]
004451  A9 51                         lda  #$51            ; A=$0051 X=$0000 Y=$0018 ; [SP-58]
004453  85 05                         sta  $05             ; A=$0051 X=$0000 Y=$0018 ; [SP-58]

; === while loop starts here (counter: $00 '', range: 0..23409, step: 23408, iters: 100532299520872) [nest:36] [inner] ===
; LUMA: data_array_x
004455  BD 6C 41          L_004455    lda  $416C,X         ; A=$0051 X=$0000 Y=$0018 ; [SP-58]
004458  85 06                         sta  $06             ; A=$0051 X=$0000 Y=$0018 ; [SP-58]
; LUMA: data_array_x
00445A  BD 2C 42                      lda  $422C,X         ; A=$0051 X=$0000 Y=$0018 ; [SP-58]
00445D  85 07                         sta  $07             ; A=$0051 X=$0000 Y=$0018 ; [SP-58]
00445F  A9 73                         lda  #$73            ; A=$0073 X=$0000 Y=$0018 ; [SP-58]
004461  31 06                         and  ($06),Y         ; A=$0073 X=$0000 Y=$0018 ; [SP-58]
004463  91 06                         sta  ($06),Y         ; A=$0073 X=$0000 Y=$0018 ; [SP-58]
004465  E8                            inx                  ; A=$0073 X=$0001 Y=$0018 ; [SP-58]
004466  E4 05                         cpx  $05             ; A=$0073 X=$0001 Y=$0018 ; [SP-58]
004468  D0 EB                         bne  L_004455        ; A=$0073 X=$0001 Y=$0018 ; [SP-58]
; === End of while loop (counter: $00) ===

; LUMA: epilogue_rts
00446A  60                            rts                  ; A=$0073 X=$0001 Y=$0018 ; [SP-56]
00446B  A2 6E             L_00446B    ldx  #$6E            ; A=$0073 X=$006E Y=$0018 ; [SP-56]
00446D  A0 18                         ldy  #$18            ; A=$0073 X=$006E Y=$0018 ; [SP-56]
00446F  A5 09                         lda  $09             ; A=[$0009] X=$006E Y=$0018 ; [SP-56]
004471  85 05                         sta  $05             ; A=[$0009] X=$006E Y=$0018 ; [SP-56]
004473  4C 55 44                      jmp  L_004455        ; A=[$0009] X=$006E Y=$0018 ; [SP-56]
; === End of while loop (counter: $00) ===

004476  A0 09             L_004476    ldy  #$09            ; A=[$0009] X=$006E Y=$0009 ; [SP-56]
004478  A9 17                         lda  #$17            ; A=$0017 X=$006E Y=$0009 ; [SP-56]

; === while loop starts here (counter: $00 '', range: 0..20376, step: 20469, iters: 87943750373367) [nest:36] [inner] ===
00447A  85 05             L_00447A    sta  $05             ; A=$0017 X=$006E Y=$0009 ; [SP-56]
00447C  A2 60                         ldx  #$60            ; A=$0017 X=$0060 Y=$0009 ; [SP-56]
00447E  BD 6C 41                      lda  $416C,X         ; -> $41CC ; A=$0017 X=$0060 Y=$0009 ; [SP-56]
004481  85 06                         sta  $06             ; A=$0017 X=$0060 Y=$0009 ; [SP-56]
; LUMA: data_array_x
004483  BD 2C 42                      lda  $422C,X         ; -> $428C ; A=$0017 X=$0060 Y=$0009 ; [SP-56]
004486  85 07                         sta  $07             ; A=$0017 X=$0060 Y=$0009 ; [SP-56]
004488  A9 00                         lda  #$00            ; A=$0000 X=$0060 Y=$0009 ; [SP-56]

; === while loop starts here (counter: $00 '', range: 0..21275, step: 21307, iters: 91676076954430) [nest:37] [inner] ===
00448A  91 06             L_00448A    sta  ($06),Y         ; A=$0000 X=$0060 Y=$0009 ; [SP-56]
00448C  C8                            iny                  ; A=$0000 X=$0060 Y=$000A ; [SP-56]
00448D  C4 05                         cpy  $05             ; A=$0000 X=$0060 Y=$000A ; [SP-56]
00448F  D0 F9                         bne  L_00448A        ; A=$0000 X=$0060 Y=$000A ; [SP-56]
; === End of while loop (counter: $00) ===

; LUMA: epilogue_rts
004491  60                            rts                  ; A=$0000 X=$0060 Y=$000A ; [SP-54]
004492  A0 1A             L_004492    ldy  #$1A            ; A=$0000 X=$0060 Y=$001A ; [SP-54]
004494  A5 0B                         lda  $0B             ; A=[$000B] X=$0060 Y=$001A ; [SP-54]
004496  4C 7A 44                      jmp  L_00447A        ; A=[$000B] X=$0060 Y=$001A ; [SP-54]
; === End of while loop (counter: $00) ===


; === while loop starts here (counter: X 'iter_x') [nest:35] ===

; FUNC $004499: register -> A:X []
; Proto: uint32_t func_004499(uint16_t param_Y);
; Liveness: params(Y) returns(A,X,Y) [13 dead stores]
004499  20 EF 44          L_004499    jsr  L_0044EF        ; A=[$000B] X=$0060 Y=$001A ; [SP-56]
00449C  A6 19                         ldx  $19             ; A=[$000B] X=$0060 Y=$001A ; [SP-56]
00449E  A5 1A                         lda  $1A             ; A=[$001A] X=$0060 Y=$001A ; [SP-56]
0044A0  D0 0F                         bne  L_0044B1        ; A=[$001A] X=$0060 Y=$001A ; [SP-56]
; LUMA: data_array_x
0044A2  BD AA 47                      lda  $47AA,X         ; -> $480A ; A=[$001A] X=$0060 Y=$001A ; [SP-56]
0044A5  85 02                         sta  $02             ; A=[$001A] X=$0060 Y=$001A ; [SP-56]
0044A7  BD 92 46                      lda  $4692,X         ; -> $46F2 ; A=[$001A] X=$0060 Y=$001A ; [SP-56]
0044AA  AA                            tax                  ; A=[$001A] X=[$001A] Y=$001A ; [SP-56]
; LUMA: data_array_x
0044AB  BD D3 48                      lda  $48D3,X         ; A=[$001A] X=[$001A] Y=$001A ; [SP-56]
0044AE  4C BD 44                      jmp  L_0044BD        ; A=[$001A] X=[$001A] Y=$001A ; [SP-56]
0044B1  BD AD 48          L_0044B1    lda  $48AD,X         ; A=[$001A] X=[$001A] Y=$001A ; [SP-56]
0044B4  85 02                         sta  $02             ; A=[$001A] X=[$001A] Y=$001A ; [SP-56]
0044B6  BD 8B 47                      lda  $478B,X         ; A=[$001A] X=[$001A] Y=$001A ; [SP-56]
0044B9  AA                            tax                  ; A=[$001A] X=[$001A] Y=$001A ; [SP-56]
; LUMA: data_array_x
0044BA  BD D3 48                      lda  $48D3,X         ; A=[$001A] X=[$001A] Y=$001A ; [SP-56]
0044BD  18                L_0044BD    clc                  ; A=[$001A] X=[$001A] Y=$001A ; [SP-56]
0044BE  6D 09 45                      adc  $4509           ; A=[$001A] X=[$001A] Y=$001A ; [SP-56]
0044C1  4C 62 04                      jmp  $0462           ; A=[$001A] X=[$001A] Y=$001A ; [SP-56]

; === while loop starts here (counter: $00, range: 0..22210, step: 22212, iters: 95361158895289) [nest:5] [inner] ===

; FUNC $0044C4: register -> A:X [I]
; Proto: uint32_t func_0044C4(uint16_t param_Y);
; Liveness: params(Y) returns(A,X,Y) [7 dead stores]
0044C4  20 EF 44          L_0044C4    jsr  L_0044EF        ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
0044C7  A6 19                         ldx  $19             ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
0044C9  A5 1A                         lda  $1A             ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
0044CB  D0 0F                         bne  L_0044DC        ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
; LUMA: data_array_x
0044CD  BD AA 47                      lda  $47AA,X         ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
0044D0  85 02                         sta  $02             ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
0044D2  BD 92 46                      lda  $4692,X         ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
0044D5  AA                            tax                  ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
; LUMA: data_array_x
0044D6  BD D3 48                      lda  $48D3,X         ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
0044D9  4C E8 44                      jmp  L_0044E8        ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
0044DC  BD AD 48          L_0044DC    lda  $48AD,X         ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
0044DF  85 02                         sta  $02             ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
0044E1  BD 8B 47                      lda  $478B,X         ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
0044E4  AA                            tax                  ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
; LUMA: data_array_x
0044E5  BD D3 48                      lda  $48D3,X         ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
0044E8  18                L_0044E8    clc                  ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
0044E9  6D 09 45                      adc  $4509           ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
0044EC  4C C0 40                      jmp  L_0040C0        ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
; === End of while loop (counter: $00) ===


; FUNC $0044EF: register -> A:X [L]
; Proto: uint32_t func_0044EF(uint16_t param_X, uint16_t param_Y);
; Liveness: params(X,Y) returns(A,X,Y) [1 dead stores]
; LUMA: data_array_x
0044EF  BD 48 5D          L_0044EF    lda  $5D48,X         ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
0044F2  85 19                         sta  $19             ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
; LUMA: data_array_x
0044F4  BD 4C 5D                      lda  $5D4C,X         ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
0044F7  85 1A                         sta  $1A             ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
; LUMA: data_array_x
0044F9  BD 50 5D                      lda  $5D50,X         ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
0044FC  85 04                         sta  $04             ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
; LUMA: data_array_x
0044FE  BD 54 5D                      lda  $5D54,X         ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
004501  AA                            tax                  ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
; LUMA: data_array_x
004502  BD 0A 45                      lda  $450A,X         ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
004505  8D 09 45                      sta  $4509           ; A=[$001A] X=[$001A] Y=$001A ; [SP-58]
; LUMA: epilogue_rts
004508  60                            rts                  ; A=[$001A] X=[$001A] Y=$001A ; [SP-56]
; LUMA: int_brk

; --- Data region ---
004509  001E1E82                HEX     001E1E82 89

; === while loop starts here (counter: X 'iter_x') [nest:15] ===

; FUNC $00450E: register -> A:X []
; Proto: uint32_t func_00450E(uint16_t param_Y);
; Liveness: params(Y) returns(A,X,Y) [8 dead stores]
; --- End data region (5 bytes) ---

00450E  A2 03             L_00450E    ldx  #$03            ; A=[$001A] X=$0003 Y=$001A ; [SP-59]
004510  86 12                         stx  $12             ; A=[$001A] X=$0003 Y=$001A ; [SP-59]

; === while loop starts here [nest:43] ===
004512  A6 12             L_004512    ldx  $12             ; A=[$001A] X=$0003 Y=$001A ; [SP-59]
; LUMA: data_array_x
004514  BD 54 5D                      lda  $5D54,X         ; -> $5D57 ; A=[$001A] X=$0003 Y=$001A ; [SP-59]
004517  F0 61                         beq  L_00457A        ; A=[$001A] X=$0003 Y=$001A ; [SP-59]
004519  20 C4 44                      jsr  L_0044C4        ; A=[$001A] X=$0003 Y=$001A ; [SP-61]
; === End of while loop (counter: X) ===

00451C  A6 12                         ldx  $12             ; A=[$001A] X=$0003 Y=$001A ; [SP-61]
00451E  E0 03                         cpx  #$03            ; A=[$001A] X=$0003 Y=$001A ; [SP-61]
004520  F0 28                         beq  L_00454A        ; A=[$001A] X=$0003 Y=$001A ; [SP-61]
004522  E0 02                         cpx  #$02            ; A=[$001A] X=$0003 Y=$001A ; [SP-61]
004524  F0 14                         beq  L_00453A        ; A=[$001A] X=$0003 Y=$001A ; [SP-61]
004526  E0 01                         cpx  #$01            ; A=[$001A] X=$0003 Y=$001A ; [SP-61]
004528  F0 30                         beq  L_00455A        ; A=[$001A] X=$0003 Y=$001A ; [SP-61]
; LUMA: data_array_x
00452A  BD 50 5D                      lda  $5D50,X         ; -> $5D53 ; A=[$001A] X=$0003 Y=$001A ; [SP-61]
00452D  18                            clc                  ; A=[$001A] X=$0003 Y=$001A ; [SP-61]
00452E  69 01                         adc  #$01            ; A=A+$01 X=$0003 Y=$001A ; [SP-61]
004530  C9 60                         cmp  #$60            ; A=A+$01 X=$0003 Y=$001A ; [SP-61]
004532  B0 46                         bcs  L_00457A        ; A=A+$01 X=$0003 Y=$001A ; [SP-61]
004534  9D 50 5D                      sta  $5D50,X         ; -> $5D53 ; A=A+$01 X=$0003 Y=$001A ; [SP-61]
004537  4C 77 45                      jmp  L_004577        ; A=A+$01 X=$0003 Y=$001A ; [SP-61]
; LUMA: data_array_x
00453A  BD 50 5D          L_00453A    lda  $5D50,X         ; -> $5D53 ; A=A+$01 X=$0003 Y=$001A ; [SP-61]
00453D  38                            sec                  ; A=A+$01 X=$0003 Y=$001A ; [SP-61]
00453E  E9 01                         sbc  #$01            ; A=A-$01 X=$0003 Y=$001A ; [SP-61]
004540  C9 60                         cmp  #$60            ; A=A-$01 X=$0003 Y=$001A ; [SP-61]
004542  90 36                         bcc  L_00457A        ; A=A-$01 X=$0003 Y=$001A ; [SP-61]
004544  9D 50 5D                      sta  $5D50,X         ; -> $5D53 ; A=A-$01 X=$0003 Y=$001A ; [SP-61]
004547  4C 77 45                      jmp  L_004577        ; A=A-$01 X=$0003 Y=$001A ; [SP-61]
; LUMA: data_array_x
00454A  BD 48 5D          L_00454A    lda  $5D48,X         ; -> $5D4B ; A=A-$01 X=$0003 Y=$001A ; [SP-61]
00454D  18                            clc                  ; A=A-$01 X=$0003 Y=$001A ; [SP-61]
00454E  69 01                         adc  #$01            ; A=A+$01 X=$0003 Y=$001A ; [SP-61]
004550  C9 AB                         cmp  #$AB            ; A=A+$01 X=$0003 Y=$001A ; [SP-61]
004552  B0 26                         bcs  L_00457A        ; A=A+$01 X=$0003 Y=$001A ; [SP-61]
004554  9D 48 5D                      sta  $5D48,X         ; -> $5D4B ; A=A+$01 X=$0003 Y=$001A ; [SP-61]
004557  4C 77 45                      jmp  L_004577        ; A=A+$01 X=$0003 Y=$001A ; [SP-61]
; LUMA: data_array_x
00455A  BD 4C 5D          L_00455A    lda  $5D4C,X         ; -> $5D4F ; A=A+$01 X=$0003 Y=$001A ; [SP-61]
00455D  D0 07                         bne  L_004566        ; A=A+$01 X=$0003 Y=$001A ; [SP-61]
; LUMA: data_array_x
00455F  BD 48 5D                      lda  $5D48,X         ; -> $5D4B ; A=A+$01 X=$0003 Y=$001A ; [SP-61]
004562  C9 AB                         cmp  #$AB            ; A=A+$01 X=$0003 Y=$001A ; [SP-61]
004564  90 14                         bcc  L_00457A        ; A=A+$01 X=$0003 Y=$001A ; [SP-61]
; LUMA: data_array_x
004566  BD 48 5D          L_004566    lda  $5D48,X         ; -> $5D4B ; A=A+$01 X=$0003 Y=$001A ; [SP-61]
004569  38                            sec                  ; A=A+$01 X=$0003 Y=$001A ; [SP-61]
00456A  E9 01                         sbc  #$01            ; A=A-$01 X=$0003 Y=$001A ; [SP-61]
00456C  9D 48 5D                      sta  $5D48,X         ; -> $5D4B ; A=A-$01 X=$0003 Y=$001A ; [SP-61]
; LUMA: data_array_x
00456F  BD 4C 5D                      lda  $5D4C,X         ; -> $5D4F ; A=A-$01 X=$0003 Y=$001A ; [SP-61]
004572  E9 00                         sbc  #$00            ; A=A X=$0003 Y=$001A ; [SP-61]
004574  9D 4C 5D                      sta  $5D4C,X         ; -> $5D4F ; A=A X=$0003 Y=$001A ; [SP-61]
004577  20 99 44          L_004577    jsr  L_004499        ; A=A X=$0003 Y=$001A ; [SP-63]
; === End of while loop (counter: X) ===

00457A  C6 12             L_00457A    dec  $12             ; A=A X=$0003 Y=$001A ; [SP-63]
00457C  10 94                         bpl  L_004512        ; A=A X=$0003 Y=$001A ; [SP-63]
; === End of while loop ===

; LUMA: epilogue_rts
00457E  60                            rts                  ; A=A X=$0003 Y=$001A ; [SP-61]

; === while loop starts here (counter: Y 'j', range: 0..192, iters: 192) [nest:22] ===

; FUNC $00457F: register -> A:X []
; Proto: uint32_t func_00457F(uint16_t param_Y);
; Liveness: params(Y) returns(A,X,Y) [5 dead stores]
00457F  A2 03             L_00457F    ldx  #$03            ; A=A X=$0003 Y=$001A ; [SP-61]
004581  86 12                         stx  $12             ; A=A X=$0003 Y=$001A ; [SP-61]

; === while loop starts here [nest:44] ===
004583  A6 12             L_004583    ldx  $12             ; A=A X=$0003 Y=$001A ; [SP-61]
; LUMA: data_array_x
004585  BD 58 5D                      lda  $5D58,X         ; -> $5D5B ; A=A X=$0003 Y=$001A ; [SP-61]
004588  F0 6F                         beq  L_0045F9        ; A=A X=$0003 Y=$001A ; [SP-61]
00458A  E0 03                         cpx  #$03            ; A=A X=$0003 Y=$001A ; [SP-61]
00458C  F0 41                         beq  L_0045CF        ; A=A X=$0003 Y=$001A ; [SP-61]
00458E  E0 02                         cpx  #$02            ; A=A X=$0003 Y=$001A ; [SP-61]
004590  F0 28                         beq  L_0045BA        ; A=A X=$0003 Y=$001A ; [SP-61]
004592  E0 01                         cpx  #$01            ; A=A X=$0003 Y=$001A ; [SP-61]
004594  F0 68                         beq  L_0045FE        ; A=A X=$0003 Y=$001A ; [SP-61]
; LUMA: data_array_x
004596  BD 64 5D                      lda  $5D64,X         ; -> $5D67 ; A=A X=$0003 Y=$001A ; [SP-61]
004599  F0 5E                         beq  L_0045F9        ; A=A X=$0003 Y=$001A ; [SP-61]
00459B  85 04                         sta  $04             ; A=A X=$0003 Y=$001A ; [SP-61]
00459D  38                            sec                  ; A=A X=$0003 Y=$001A ; [SP-61]
00459E  E9 03                         sbc  #$03            ; A=A-$03 X=$0003 Y=$001A ; [SP-61]
0045A0  B0 02                         bcs  L_0045A4        ; A=A-$03 X=$0003 Y=$001A ; [SP-61]
0045A2  A9 00                         lda  #$00            ; A=$0000 X=$0003 Y=$001A ; [SP-61]

; === while loop starts here (counter: $00 '', range: 0..22377, step: 22332, iters: 96104188237671) [nest:45] [inner] ===
0045A4  85 1E             L_0045A4    sta  $1E             ; A=$0000 X=$0003 Y=$001A ; [SP-61]
0045A6  9D 64 5D                      sta  $5D64,X         ; -> $5D67 ; A=$0000 X=$0003 Y=$001A ; [SP-61]
; LUMA: data_array_x
0045A9  BD 5C 5D                      lda  $5D5C,X         ; -> $5D5F ; A=$0000 X=$0003 Y=$001A ; [SP-61]
0045AC  85 19                         sta  $19             ; A=$0000 X=$0003 Y=$001A ; [SP-61]
0045AE  85 1C                         sta  $1C             ; A=$0000 X=$0003 Y=$001A ; [SP-61]
; LUMA: data_array_x
0045B0  BD 60 5D                      lda  $5D60,X         ; -> $5D63 ; A=$0000 X=$0003 Y=$001A ; [SP-61]
0045B3  85 1A                         sta  $1A             ; A=$0000 X=$0003 Y=$001A ; [SP-61]
0045B5  85 1D                         sta  $1D             ; A=$0000 X=$0003 Y=$001A ; [SP-61]
0045B7  4C F3 45                      jmp  L_0045F3        ; A=$0000 X=$0003 Y=$001A ; [SP-61]
; LUMA: data_array_x
0045BA  BD 64 5D          L_0045BA    lda  $5D64,X         ; -> $5D67 ; A=$0000 X=$0003 Y=$001A ; [SP-61]
0045BD  C9 BF                         cmp  #$BF            ; A=$0000 X=$0003 Y=$001A ; [SP-61]
0045BF  F0 38                         beq  L_0045F9        ; A=$0000 X=$0003 Y=$001A ; [SP-61]
0045C1  85 04                         sta  $04             ; A=$0000 X=$0003 Y=$001A ; [SP-61]
0045C3  18                            clc                  ; A=$0000 X=$0003 Y=$001A ; [SP-61]
0045C4  69 03                         adc  #$03            ; A=A+$03 X=$0003 Y=$001A ; [SP-61]
0045C6  C9 BF                         cmp  #$BF            ; A=A+$03 X=$0003 Y=$001A ; [SP-61]
0045C8  90 DA                         bcc  L_0045A4        ; A=A+$03 X=$0003 Y=$001A ; [SP-61]
; === End of while loop (counter: $00) ===

0045CA  A9 BF                         lda  #$BF            ; A=$00BF X=$0003 Y=$001A ; [SP-61]
0045CC  4C A4 45                      jmp  L_0045A4        ; A=$00BF X=$0003 Y=$001A ; [SP-61]
; === End of while loop (counter: $00) ===

; LUMA: data_array_x
0045CF  BD 5C 5D          L_0045CF    lda  $5D5C,X         ; -> $5D5F ; A=$00BF X=$0003 Y=$001A ; [SP-61]
0045D2  C9 3E                         cmp  #$3E            ; A=$00BF X=$0003 Y=$001A ; [SP-61]
0045D4  90 23                         bcc  L_0045F9        ; A=$00BF X=$0003 Y=$001A ; [SP-61]
0045D6  85 1C                         sta  $1C             ; A=$00BF X=$0003 Y=$001A ; [SP-61]
0045D8  38                            sec                  ; A=$00BF X=$0003 Y=$001A ; [SP-61]
0045D9  E9 03                         sbc  #$03            ; A=A-$03 X=$0003 Y=$001A ; [SP-61]
0045DB  C9 3E                         cmp  #$3E            ; A=A-$03 X=$0003 Y=$001A ; [SP-61]
0045DD  B0 02                         bcs  L_0045E1        ; A=A-$03 X=$0003 Y=$001A ; [SP-61]
0045DF  A9 3E                         lda  #$3E            ; A=$003E X=$0003 Y=$001A ; [SP-61]
0045E1  85 19             L_0045E1    sta  $19             ; A=$003E X=$0003 Y=$001A ; [SP-61]
0045E3  9D 5C 5D                      sta  $5D5C,X         ; -> $5D5F ; A=$003E X=$0003 Y=$001A ; [SP-61]
0045E6  A9 00                         lda  #$00            ; A=$0000 X=$0003 Y=$001A ; [SP-61]
0045E8  85 1D                         sta  $1D             ; A=$0000 X=$0003 Y=$001A ; [SP-61]
0045EA  85 1A                         sta  $1A             ; A=$0000 X=$0003 Y=$001A ; [SP-61]

; === while loop starts here (counter: $00, range: 0..23458, step: 23460, iters: 100777112656806) [nest:44] [inner] ===
; LUMA: data_array_x
0045EC  BD 64 5D          L_0045EC    lda  $5D64,X         ; -> $5D67 ; A=$0000 X=$0003 Y=$001A ; [SP-61]
0045EF  85 1E                         sta  $1E             ; A=$0000 X=$0003 Y=$001A ; [SP-61]
0045F1  85 04                         sta  $04             ; A=$0000 X=$0003 Y=$001A ; [SP-61]
0045F3  20 40 49          L_0045F3    jsr  L_004940        ; A=$0000 X=$0003 Y=$001A ; [SP-63]
0045F6  8D 30 C0                      sta  $C030           ; SPKR - Speaker toggle {Speaker} <speaker_toggle>

; === while loop starts here (counter: $00 '', range: 0..23447, step: 23464, iters: 100575249193905) [nest:46] [inner] ===
0045F9  C6 12             L_0045F9    dec  $12             ; A=$0000 X=$0003 Y=$001A ; [SP-63]
0045FB  10 86                         bpl  L_004583        ; A=$0000 X=$0003 Y=$001A ; [SP-63]
; === End of while loop ===

; LUMA: epilogue_rts
0045FD  60                            rts                  ; A=$0000 X=$0003 Y=$001A ; [SP-61]
; LUMA: data_array_x
0045FE  BD 5C 5D          L_0045FE    lda  $5D5C,X         ; -> $5D5F ; A=$0000 X=$0003 Y=$001A ; [SP-61]
004601  C9 17                         cmp  #$17            ; A=$0000 X=$0003 Y=$001A ; [SP-61]
; LUMA: data_array_x
004603  BD 60 5D                      lda  $5D60,X         ; -> $5D63 ; A=$0000 X=$0003 Y=$001A ; [SP-61]
004606  E9 01                         sbc  #$01            ; A=A-$01 X=$0003 Y=$001A ; [SP-61]
004608  B0 EF                         bcs  L_0045F9        ; A=A-$01 X=$0003 Y=$001A ; [SP-61]
; === End of while loop (counter: $00) ===

; LUMA: data_array_x
00460A  BD 60 5D                      lda  $5D60,X         ; -> $5D63 ; A=A-$01 X=$0003 Y=$001A ; [SP-61]
00460D  85 1A                         sta  $1A             ; A=A-$01 X=$0003 Y=$001A ; [SP-61]
; LUMA: data_array_x
00460F  BD 5C 5D                      lda  $5D5C,X         ; -> $5D5F ; A=A-$01 X=$0003 Y=$001A ; [SP-61]
004612  85 19                         sta  $19             ; A=A-$01 X=$0003 Y=$001A ; [SP-61]
004614  18                            clc                  ; A=A-$01 X=$0003 Y=$001A ; [SP-61]
004615  69 03                         adc  #$03            ; A=A+$03 X=$0003 Y=$001A ; [SP-61]
004617  9D 5C 5D                      sta  $5D5C,X         ; -> $5D5F ; A=A+$03 X=$0003 Y=$001A ; [SP-61]
00461A  85 1C                         sta  $1C             ; A=A+$03 X=$0003 Y=$001A ; [SP-61]
; LUMA: data_array_x
00461C  BD 60 5D                      lda  $5D60,X         ; -> $5D63 ; A=A+$03 X=$0003 Y=$001A ; [SP-61]
00461F  69 00                         adc  #$00            ; A=A X=$0003 Y=$001A ; [SP-61]
004621  9D 60 5D                      sta  $5D60,X         ; -> $5D63 ; A=A X=$0003 Y=$001A ; [SP-61]
004624  85 1D                         sta  $1D             ; A=A X=$0003 Y=$001A ; [SP-61]
004626  A5 1C                         lda  $1C             ; A=[$001C] X=$0003 Y=$001A ; [SP-61]
004628  C9 17                         cmp  #$17            ; A=[$001C] X=$0003 Y=$001A ; [SP-61]
00462A  A5 1D                         lda  $1D             ; A=[$001D] X=$0003 Y=$001A ; [SP-61]
00462C  E9 01                         sbc  #$01            ; A=A-$01 X=$0003 Y=$001A ; [SP-61]
00462E  90 BC                         bcc  L_0045EC        ; A=A-$01 X=$0003 Y=$001A ; [SP-61]
; === End of while loop (counter: $00) ===

004630  A9 17                         lda  #$17            ; A=$0017 X=$0003 Y=$001A ; [SP-61]
004632  9D 5C 5D                      sta  $5D5C,X         ; -> $5D5F ; A=$0017 X=$0003 Y=$001A ; [SP-61]
004635  85 1C                         sta  $1C             ; A=$0017 X=$0003 Y=$001A ; [SP-61]
004637  A9 01                         lda  #$01            ; A=$0001 X=$0003 Y=$001A ; [SP-61]
004639  85 1D                         sta  $1D             ; A=$0001 X=$0003 Y=$001A ; [SP-61]
00463B  9D 60 5D                      sta  $5D60,X         ; -> $5D63 ; A=$0001 X=$0003 Y=$001A ; [SP-61]
00463E  4C EC 45                      jmp  L_0045EC        ; A=$0001 X=$0003 Y=$001A ; [SP-61]
; === End of while loop (counter: $00) ===


; === while loop starts here (iters: 93630287074595) [nest:44] ===

; FUNC $004641: register -> A:X [L]
; Proto: uint32_t func_004641(uint16_t param_A, uint16_t param_X, uint16_t param_Y);
; Liveness: params(A,X,Y) returns(A,X,Y)
004641  8D 55 46          L_004641    sta  $4655           ; A=$0001 X=$0003 Y=$001A ; [SP-61]
004644  8E 56 46                      stx  $4656           ; A=$0001 X=$0003 Y=$001A ; [SP-61]
004647  8C 57 46                      sty  $4657           ; A=$0001 X=$0003 Y=$001A ; [SP-61]
; LUMA: epilogue_rts
00464A  60                            rts                  ; A=$0001 X=$0003 Y=$001A ; [SP-59]

; === while loop starts here (counter: $00 '', range: 0..22560, step: 17287, iters: 95601677064233) [nest:44] [inner] ===

; FUNC $00464B: register -> A:X [L]
; Proto: uint32_t func_00464B(void);
; Liveness: returns(A,X,Y)
; LUMA: hw_keyboard_read
00464B  AD 55 46          L_00464B    lda  $4655           ; A=[$4655] X=$0003 Y=$001A ; [SP-59]
00464E  AE 56 46                      ldx  $4656           ; A=[$4655] X=$0003 Y=$001A ; [SP-59]
004651  AC 57 46                      ldy  $4657           ; A=[$4655] X=$0003 Y=$001A ; [SP-59]
; LUMA: epilogue_rts
004654  60                            rts                  ; A=[$4655] X=$0003 Y=$001A ; [SP-57]
; LUMA: int_brk

; --- Data region ---
004655  000000                  HEX     000000

; === while loop starts here (iters: 96610994378715) [nest:46] ===

; FUNC $004658: register -> A:X []
; Proto: uint32_t func_004658(uint16_t param_A, uint16_t param_X, uint16_t param_Y);
; Liveness: params(A,X,Y) returns(A,X,Y) [1 dead stores]
; --- End data region (3 bytes) ---

004658  85 13             L_004658    sta  $13             ; A=[$4655] X=$0003 Y=$001A ; [SP-63]
00465A  86 14                         stx  $14             ; A=[$4655] X=$0003 Y=$001A ; [SP-63]
00465C  84 15                         sty  $15             ; A=[$4655] X=$0003 Y=$001A ; [SP-63]
00465E  A6 04                         ldx  $04             ; A=[$4655] X=$0003 Y=$001A ; [SP-63]
; LUMA: data_array_x
004660  BD 6C 41                      lda  $416C,X         ; -> $416F ; A=[$4655] X=$0003 Y=$001A ; [SP-63]
004663  85 06                         sta  $06             ; A=[$4655] X=$0003 Y=$001A ; [SP-63]
; LUMA: data_array_x
004665  BD 2C 42                      lda  $422C,X         ; -> $422F ; A=[$4655] X=$0003 Y=$001A ; [SP-63]
004668  85 07                         sta  $07             ; A=[$4655] X=$0003 Y=$001A ; [SP-63]
00466A  A6 19                         ldx  $19             ; A=[$4655] X=$0003 Y=$001A ; [SP-63]
00466C  A5 1A                         lda  $1A             ; A=[$001A] X=$0003 Y=$001A ; [SP-63]
00466E  D0 11                         bne  L_004681        ; A=[$001A] X=$0003 Y=$001A ; [SP-63]
; LUMA: data_array_x
004670  BD 92 46                      lda  $4692,X         ; -> $4695 ; A=[$001A] X=$0003 Y=$001A ; [SP-63]
004673  85 16                         sta  $16             ; A=[$001A] X=$0003 Y=$001A ; [SP-63]
; LUMA: data_array_x
004675  BD AA 47                      lda  $47AA,X         ; -> $47AD ; A=[$001A] X=$0003 Y=$001A ; [SP-63]
004678  85 17                         sta  $17             ; A=[$001A] X=$0003 Y=$001A ; [SP-63]
00467A  A5 13                         lda  $13             ; A=[$0013] X=$0003 Y=$001A ; [SP-63]
00467C  A6 14                         ldx  $14             ; A=[$0013] X=$0003 Y=$001A ; [SP-63]
00467E  A4 15                         ldy  $15             ; A=[$0013] X=$0003 Y=$001A ; [SP-63]
; LUMA: epilogue_rts
004680  60                            rts                  ; A=[$0013] X=$0003 Y=$001A ; [SP-61]
; LUMA: data_array_x
004681  BD 8B 47          L_004681    lda  $478B,X         ; -> $478E ; A=[$0013] X=$0003 Y=$001A ; [SP-61]
004684  85 16                         sta  $16             ; A=[$0013] X=$0003 Y=$001A ; [SP-61]
; LUMA: data_array_x
004686  BD AD 48                      lda  $48AD,X         ; -> $48B0 ; A=[$0013] X=$0003 Y=$001A ; [SP-61]
004689  85 17                         sta  $17             ; A=[$0013] X=$0003 Y=$001A ; [SP-61]
00468B  A5 13                         lda  $13             ; A=[$0013] X=$0003 Y=$001A ; [SP-61]
00468D  A6 14                         ldx  $14             ; A=[$0013] X=$0003 Y=$001A ; [SP-61]
00468F  A4 15                         ldy  $15             ; A=[$0013] X=$0003 Y=$001A ; [SP-61]
; LUMA: epilogue_rts
004691  60                            rts                  ; A=[$0013] X=$0003 Y=$001A ; [SP-59]

; --- Data region ---
004692  01020408                HEX     01020408 10204001 02040810 20400102
0046A2  04081020                HEX     04081020 40010204 08102040 01020408
0046B2  10204001                HEX     10204001 02040810 20400102 04081020
; Interrupt return (RTI)
0046C2  40010204                HEX     40010204 08102040 01020408 10204001
; LUMA: int_cop
0046D2  02040810                HEX     02040810 20400102 04081020 40010204
0046E2  08102040                HEX     08102040 01020408 10204001 02040810
0046F2  20400102                HEX     20400102 04081020 40010204 08102040
004702  01020408                HEX     01020408 10204001 02040810 20400102
004712  04081020                HEX     04081020 40010204 08102040 01020408
004722  10204001                HEX     10204001 02040810 20400102 04081020
; Interrupt return (RTI)
004732  40010204                HEX     40010204 08102040 01020408 10204001
; LUMA: int_cop
004742  02040810                HEX     02040810 20400102 04081020 40010204
004752  08102040                HEX     08102040 01020408 10204001 02040810
004762  20400102                HEX     20400102 04081020 40010204 08102040
004772  01020408                HEX     01020408 10204001 02040810 20400102
004782  04081020                HEX     04081020 40010204 08102040 01020408
004792  10204001                HEX     10204001 02040810 20400102 04081020
; Interrupt return (RTI)
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

; === while loop starts here [nest:43] ===

; FUNC $004914: register -> A:X []
; Proto: uint32_t func_004914(uint16_t param_A, uint16_t param_X);
; Frame: push_only [saves: A]
; Liveness: params(A,X) returns(A,X,Y) [3 dead stores]
; --- End data region (642 bytes) ---

004914  48                L_004914    pha                  ; A=[$0013] X=$0003 Y=$001A ; [SP-77]
004915  98                            tya                  ; A=$001A X=$0003 Y=$001A ; [SP-77]
004916  48                            pha                  ; A=$001A X=$0003 Y=$001A ; [SP-78]
004917  A5 19                         lda  $19             ; A=[$0019] X=$0003 Y=$001A ; [SP-78]
004919  29 01                         and  #$01            ; A=A&$01 X=$0003 Y=$001A ; [SP-78]
00491B  F0 0B                         beq  L_004928        ; A=A&$01 X=$0003 Y=$001A ; [SP-78]
00491D  20 58 46                      jsr  L_004658        ; A=A&$01 X=$0003 Y=$001A ; [SP-80]
; === End of while loop ===

004920  A4 17                         ldy  $17             ; A=A&$01 X=$0003 Y=$001A ; [SP-80]
004922  A5 16                         lda  $16             ; A=[$0016] X=$0003 Y=$001A ; [SP-80]
004924  11 06                         ora  ($06),Y         ; A=[$0016] X=$0003 Y=$001A ; [SP-80]
004926  91 06                         sta  ($06),Y         ; A=[$0016] X=$0003 Y=$001A ; [SP-80]
004928  68                L_004928    pla                  ; A=[stk] X=$0003 Y=$001A ; [SP-79]
004929  A8                            tay                  ; A=[stk] X=$0003 Y=[stk] ; [SP-79]
00492A  68                            pla                  ; A=[stk] X=$0003 Y=[stk] ; [SP-78]
00492B  60                            rts                  ; A=[stk] X=$0003 Y=[stk] ; [SP-76]

; --- Data region ---
00492C  48984820                HEX     48984820 5846A417 A51649FF 31069106
00493C  68A86860                HEX     68A86860

; FUNC $004940: register -> A:X []
; Proto: uint32_t func_004940(uint16_t param_X, uint16_t param_Y);
; Liveness: params(X,Y) returns(A,X,Y) [12 dead stores]
; --- End data region (20 bytes) ---

004940  20 41 46          L_004940    jsr  L_004641        ; A=[stk] X=$0003 Y=[stk] ; [SP-78]
; === End of while loop ===

004943  A9 00                         lda  #$00            ; A=$0000 X=$0003 Y=[stk] ; [SP-78]
004945  85 1B                         sta  $1B             ; A=$0000 X=$0003 Y=[stk] ; [SP-78]
004947  4C 51 49                      jmp  L_004951        ; A=$0000 X=$0003 Y=[stk] ; [SP-78]

; --- Data region ---
00494A  204146A9                HEX     204146A9 FF851B
; --- End data region (7 bytes) ---

004951  38                L_004951    sec                  ; A=$0000 X=$0003 Y=[stk] ; [SP-80]
004952  A5 1C                         lda  $1C             ; A=[$001C] X=$0003 Y=[stk] ; [SP-80]
004954  E5 19                         sbc  $19             ; A=[$001C] X=$0003 Y=[stk] ; [SP-80]
004956  85 23                         sta  $23             ; A=[$001C] X=$0003 Y=[stk] ; [SP-80]
004958  A5 1D                         lda  $1D             ; A=[$001D] X=$0003 Y=[stk] ; [SP-80]
00495A  E5 1A                         sbc  $1A             ; A=[$001D] X=$0003 Y=[stk] ; [SP-80]
00495C  85 24                         sta  $24             ; A=[$001D] X=$0003 Y=[stk] ; [SP-80]
00495E  38                            sec                  ; A=[$001D] X=$0003 Y=[stk] ; [SP-80]
00495F  A5 1E                         lda  $1E             ; A=[$001E] X=$0003 Y=[stk] ; [SP-80]
004961  E5 04                         sbc  $04             ; A=[$001E] X=$0003 Y=[stk] ; [SP-80]
004963  85 25                         sta  $25             ; A=[$001E] X=$0003 Y=[stk] ; [SP-80]
004965  A9 00                         lda  #$00            ; A=$0000 X=$0003 Y=[stk] ; [SP-80]
004967  E9 00                         sbc  #$00            ; A=A X=$0003 Y=[stk] ; [SP-80]
004969  85 26                         sta  $26             ; A=A X=$0003 Y=[stk] ; [SP-80]
00496B  A5 24                         lda  $24             ; A=[$0024] X=$0003 Y=[stk] ; [SP-80]
00496D  10 16                         bpl  L_004985        ; A=[$0024] X=$0003 Y=[stk] ; [SP-80]
00496F  A9 FF                         lda  #$FF            ; A=$00FF X=$0003 Y=[stk] ; [SP-80]
004971  85 1F                         sta  $1F             ; A=$00FF X=$0003 Y=[stk] ; [SP-80]
004973  85 20                         sta  $20             ; A=$00FF X=$0003 Y=[stk] ; [SP-80]
004975  38                            sec                  ; A=$00FF X=$0003 Y=[stk] ; [SP-80]
004976  A9 00                         lda  #$00            ; A=$0000 X=$0003 Y=[stk] ; [SP-80]
004978  E5 23                         sbc  $23             ; A=$0000 X=$0003 Y=[stk] ; [SP-80]
00497A  85 23                         sta  $23             ; A=$0000 X=$0003 Y=[stk] ; [SP-80]
00497C  A9 00                         lda  #$00            ; A=$0000 X=$0003 Y=[stk] ; [OPT] REDUNDANT_LOAD: Redundant LDA: same value loaded at $004976 ; [SP-80]
00497E  E5 24                         sbc  $24             ; A=$0000 X=$0003 Y=[stk] ; [SP-80]
004980  85 24                         sta  $24             ; A=$0000 X=$0003 Y=[stk] ; [SP-80]
004982  4C 8D 49                      jmp  L_00498D        ; A=$0000 X=$0003 Y=[stk] ; [SP-80]
004985  A9 01             L_004985    lda  #$01            ; A=$0001 X=$0003 Y=[stk] ; [SP-80]
004987  85 1F                         sta  $1F             ; A=$0001 X=$0003 Y=[stk] ; [SP-80]
004989  A9 00                         lda  #$00            ; A=$0000 X=$0003 Y=[stk] ; [SP-80]
00498B  85 20                         sta  $20             ; A=$0000 X=$0003 Y=[stk] ; [SP-80]
00498D  A5 26             L_00498D    lda  $26             ; A=[$0026] X=$0003 Y=[stk] ; [SP-80]
00498F  10 16                         bpl  L_0049A7        ; A=[$0026] X=$0003 Y=[stk] ; [SP-80]
004991  A9 FF                         lda  #$FF            ; A=$00FF X=$0003 Y=[stk] ; [SP-80]
004993  85 21                         sta  $21             ; A=$00FF X=$0003 Y=[stk] ; [SP-80]
004995  85 22                         sta  $22             ; A=$00FF X=$0003 Y=[stk] ; [SP-80]
004997  38                            sec                  ; A=$00FF X=$0003 Y=[stk] ; [SP-80]
004998  A9 00                         lda  #$00            ; A=$0000 X=$0003 Y=[stk] ; [SP-80]
00499A  E5 25                         sbc  $25             ; A=$0000 X=$0003 Y=[stk] ; [SP-80]
00499C  85 25                         sta  $25             ; A=$0000 X=$0003 Y=[stk] ; [SP-80]
00499E  A9 00                         lda  #$00            ; A=$0000 X=$0003 Y=[stk] ; [OPT] REDUNDANT_LOAD: Redundant LDA: same value loaded at $004998 ; [SP-80]
0049A0  E5 26                         sbc  $26             ; A=$0000 X=$0003 Y=[stk] ; [SP-80]
0049A2  85 26                         sta  $26             ; A=$0000 X=$0003 Y=[stk] ; [SP-80]
0049A4  4C AF 49                      jmp  L_0049AF        ; A=$0000 X=$0003 Y=[stk] ; [SP-80]
0049A7  A9 01             L_0049A7    lda  #$01            ; A=$0001 X=$0003 Y=[stk] ; [SP-80]
0049A9  85 21                         sta  $21             ; A=$0001 X=$0003 Y=[stk] ; [SP-80]
0049AB  A9 00                         lda  #$00            ; A=$0000 X=$0003 Y=[stk] ; [SP-80]
0049AD  85 22                         sta  $22             ; A=$0000 X=$0003 Y=[stk] ; [SP-80]
0049AF  A5 23             L_0049AF    lda  $23             ; A=[$0023] X=$0003 Y=[stk] ; [SP-80]
0049B1  C5 25                         cmp  $25             ; A=[$0023] X=$0003 Y=[stk] ; [SP-80]
0049B3  A5 24                         lda  $24             ; A=[$0024] X=$0003 Y=[stk] ; [SP-80]
0049B5  E5 26                         sbc  $26             ; A=[$0024] X=$0003 Y=[stk] ; [SP-80]
0049B7  B0 06                         bcs  L_0049BF        ; A=[$0024] X=$0003 Y=[stk] ; [SP-80]
0049B9  20 2F 4A                      jsr  L_004A2F        ; A=[$0024] X=$0003 Y=[stk] ; [SP-82]
0049BC  4C C2 49                      jmp  L_0049C2        ; A=[$0024] X=$0003 Y=[stk] ; [SP-82]
0049BF  20 C6 49          L_0049BF    jsr  L_0049C6        ; A=[$0024] X=$0003 Y=[stk] ; [SP-84]
0049C2  20 4B 46          L_0049C2    jsr  L_00464B        ; A=[$0024] X=$0003 Y=[stk] ; [OPT] TAIL_CALL: Tail call: JSR/JSL at $0049C2 followed by RTS ; [SP-86]
; === End of while loop (counter: $00) ===

0049C5  60                            rts                  ; A=[$0024] X=$0003 Y=[stk] ; [SP-84]

; FUNC $0049C6: register -> A:X []
; Proto: uint32_t func_0049C6(uint16_t param_X, uint16_t param_Y);
; Liveness: params(X,Y) returns(A,X,Y) [14 dead stores]
0049C6  A5 23             L_0049C6    lda  $23             ; A=[$0023] X=$0003 Y=[stk] ; [SP-84]
0049C8  D0 04                         bne  L_0049CE        ; A=[$0023] X=$0003 Y=[stk] ; [SP-84]
0049CA  A5 24                         lda  $24             ; A=[$0024] X=$0003 Y=[stk] ; [SP-84]
0049CC  F0 60                         beq  L_004A2E        ; A=[$0024] X=$0003 Y=[stk] ; [SP-84]
0049CE  A5 24             L_0049CE    lda  $24             ; A=[$0024] X=$0003 Y=[stk] ; [OPT] REDUNDANT_LOAD: Redundant LDA: same value loaded at $0049CA ; [SP-84]
0049D0  85 2A                         sta  $2A             ; A=[$0024] X=$0003 Y=[stk] ; [SP-84]
0049D2  4A                            lsr  a               ; A=[$0024] X=$0003 Y=[stk] ; [SP-84]
0049D3  85 28                         sta  $28             ; A=[$0024] X=$0003 Y=[stk] ; [SP-84]
0049D5  A5 23                         lda  $23             ; A=[$0023] X=$0003 Y=[stk] ; [SP-84]
0049D7  85 29                         sta  $29             ; A=[$0023] X=$0003 Y=[stk] ; [SP-84]
0049D9  6A                            ror  a               ; A=[$0023] X=$0003 Y=[stk] ; [SP-84]
0049DA  85 27                         sta  $27             ; A=[$0023] X=$0003 Y=[stk] ; [SP-84]

; === while loop starts here (counter: $00 '', range: 0..22494, step: 17333, iters: 74461848028106) [nest:44] [inner] ===
0049DC  18                L_0049DC    clc                  ; A=[$0023] X=$0003 Y=[stk] ; [SP-84]
0049DD  A5 27                         lda  $27             ; A=[$0027] X=$0003 Y=[stk] ; [SP-84]
0049DF  65 25                         adc  $25             ; A=[$0027] X=$0003 Y=[stk] ; [SP-84]
0049E1  85 27                         sta  $27             ; A=[$0027] X=$0003 Y=[stk] ; [SP-84]
0049E3  A5 28                         lda  $28             ; A=[$0028] X=$0003 Y=[stk] ; [SP-84]
0049E5  65 26                         adc  $26             ; A=[$0028] X=$0003 Y=[stk] ; [SP-84]
0049E7  85 28                         sta  $28             ; A=[$0028] X=$0003 Y=[stk] ; [SP-84]
0049E9  A5 27                         lda  $27             ; A=[$0027] X=$0003 Y=[stk] ; [SP-84]
0049EB  C5 23                         cmp  $23             ; A=[$0027] X=$0003 Y=[stk] ; [SP-84]
0049ED  A5 28                         lda  $28             ; A=[$0028] X=$0003 Y=[stk] ; [SP-84]
0049EF  E5 24                         sbc  $24             ; A=[$0028] X=$0003 Y=[stk] ; [SP-84]
0049F1  90 13                         bcc  L_004A06        ; A=[$0028] X=$0003 Y=[stk] ; [SP-84]
0049F3  A5 27                         lda  $27             ; A=[$0027] X=$0003 Y=[stk] ; [SP-84]
0049F5  E5 23                         sbc  $23             ; A=[$0027] X=$0003 Y=[stk] ; [SP-84]
0049F7  85 27                         sta  $27             ; A=[$0027] X=$0003 Y=[stk] ; [SP-84]
0049F9  A5 28                         lda  $28             ; A=[$0028] X=$0003 Y=[stk] ; [SP-84]
0049FB  E5 24                         sbc  $24             ; A=[$0028] X=$0003 Y=[stk] ; [SP-84]
0049FD  85 28                         sta  $28             ; A=[$0028] X=$0003 Y=[stk] ; [SP-84]
0049FF  18                            clc                  ; A=[$0028] X=$0003 Y=[stk] ; [SP-84]
004A00  A5 04                         lda  $04             ; A=[$0004] X=$0003 Y=[stk] ; [SP-84]
004A02  65 21                         adc  $21             ; A=[$0004] X=$0003 Y=[stk] ; [SP-84]
004A04  85 04                         sta  $04             ; A=[$0004] X=$0003 Y=[stk] ; [SP-84]
004A06  18                L_004A06    clc                  ; A=[$0004] X=$0003 Y=[stk] ; [SP-84]
004A07  A5 19                         lda  $19             ; A=[$0019] X=$0003 Y=[stk] ; [SP-84]
004A09  65 1F                         adc  $1F             ; A=[$0019] X=$0003 Y=[stk] ; [SP-84]
004A0B  85 19                         sta  $19             ; A=[$0019] X=$0003 Y=[stk] ; [SP-84]
004A0D  A5 1A                         lda  $1A             ; A=[$001A] X=$0003 Y=[stk] ; [SP-84]
004A0F  65 20                         adc  $20             ; A=[$001A] X=$0003 Y=[stk] ; [SP-84]
004A11  85 1A                         sta  $1A             ; A=[$001A] X=$0003 Y=[stk] ; [SP-84]
004A13  24 1B                         bit  $1B             ; A=[$001A] X=$0003 Y=[stk] ; [SP-84]
004A15  10 06                         bpl  L_004A1D        ; A=[$001A] X=$0003 Y=[stk] ; [SP-84]
004A17  20 C0 40                      jsr  L_0040C0        ; A=[$001A] X=$0003 Y=[stk] ; [SP-86]
; === End of while loop (counter: $00) ===

004A1A  4C 20 4A                      jmp  L_004A20        ; A=[$001A] X=$0003 Y=[stk] ; [SP-86]
004A1D  20 14 49          L_004A1D    jsr  L_004914        ; A=[$001A] X=$0003 Y=[stk] ; [SP-88]
; === End of while loop ===

004A20  A5 29             L_004A20    lda  $29             ; A=[$0029] X=$0003 Y=[stk] ; [SP-88]
004A22  D0 02                         bne  L_004A26        ; A=[$0029] X=$0003 Y=[stk] ; [SP-88]
004A24  C6 2A                         dec  $2A             ; A=[$0029] X=$0003 Y=[stk] ; [SP-88]
004A26  C6 29             L_004A26    dec  $29             ; A=[$0029] X=$0003 Y=[stk] ; [SP-88]
004A28  A5 29                         lda  $29             ; A=[$0029] X=$0003 Y=[stk] ; [OPT] REDUNDANT_LOAD: Redundant LDA: same value loaded at $004A20 ; [SP-88]
004A2A  05 2A                         ora  $2A             ; A=[$0029] X=$0003 Y=[stk] ; [SP-88]
004A2C  D0 AE                         bne  L_0049DC        ; A=[$0029] X=$0003 Y=[stk] ; [SP-88]
; === End of while loop (counter: $00) ===

004A2E  60                L_004A2E    rts                  ; A=[$0029] X=$0003 Y=[stk] ; [SP-86]

; FUNC $004A2F: register -> A:X []
; Proto: uint32_t func_004A2F(uint16_t param_X, uint16_t param_Y);
; Liveness: params(X,Y) returns(A,X,Y) [12 dead stores]
004A2F  A5 26             L_004A2F    lda  $26             ; A=[$0026] X=$0003 Y=[stk] ; [SP-86]
004A31  85 2A                         sta  $2A             ; A=[$0026] X=$0003 Y=[stk] ; [SP-86]
004A33  4A                            lsr  a               ; A=[$0026] X=$0003 Y=[stk] ; [SP-86]
004A34  85 28                         sta  $28             ; A=[$0026] X=$0003 Y=[stk] ; [SP-86]
004A36  A5 25                         lda  $25             ; A=[$0025] X=$0003 Y=[stk] ; [SP-86]
004A38  85 29                         sta  $29             ; A=[$0025] X=$0003 Y=[stk] ; [SP-86]
004A3A  6A                            ror  a               ; A=[$0025] X=$0003 Y=[stk] ; [SP-86]
004A3B  85 27                         sta  $27             ; A=[$0025] X=$0003 Y=[stk] ; [SP-86]

; === while loop starts here (counter: $00, range: 0..22335, step: 22337, iters: 95983929153354) [nest:43] [inner] ===
004A3D  18                L_004A3D    clc                  ; A=[$0025] X=$0003 Y=[stk] ; [SP-86]
004A3E  A5 27                         lda  $27             ; A=[$0027] X=$0003 Y=[stk] ; [SP-86]
004A40  65 23                         adc  $23             ; A=[$0027] X=$0003 Y=[stk] ; [SP-86]
004A42  85 27                         sta  $27             ; A=[$0027] X=$0003 Y=[stk] ; [SP-86]
004A44  A5 28                         lda  $28             ; A=[$0028] X=$0003 Y=[stk] ; [SP-86]
004A46  65 24                         adc  $24             ; A=[$0028] X=$0003 Y=[stk] ; [SP-86]
004A48  85 28                         sta  $28             ; A=[$0028] X=$0003 Y=[stk] ; [SP-86]
004A4A  A5 27                         lda  $27             ; A=[$0027] X=$0003 Y=[stk] ; [SP-86]
004A4C  C5 25                         cmp  $25             ; A=[$0027] X=$0003 Y=[stk] ; [SP-86]
004A4E  A5 28                         lda  $28             ; A=[$0028] X=$0003 Y=[stk] ; [SP-86]
004A50  E5 26                         sbc  $26             ; A=[$0028] X=$0003 Y=[stk] ; [SP-86]
004A52  90 19                         bcc  L_004A6D        ; A=[$0028] X=$0003 Y=[stk] ; [SP-86]
004A54  A5 27                         lda  $27             ; A=[$0027] X=$0003 Y=[stk] ; [SP-86]
004A56  E5 25                         sbc  $25             ; A=[$0027] X=$0003 Y=[stk] ; [SP-86]
004A58  85 27                         sta  $27             ; A=[$0027] X=$0003 Y=[stk] ; [SP-86]
004A5A  A5 28                         lda  $28             ; A=[$0028] X=$0003 Y=[stk] ; [SP-86]
004A5C  E5 26                         sbc  $26             ; A=[$0028] X=$0003 Y=[stk] ; [SP-86]
004A5E  85 28                         sta  $28             ; A=[$0028] X=$0003 Y=[stk] ; [SP-86]
004A60  18                            clc                  ; A=[$0028] X=$0003 Y=[stk] ; [SP-86]
004A61  A5 19                         lda  $19             ; A=[$0019] X=$0003 Y=[stk] ; [SP-86]
004A63  65 1F                         adc  $1F             ; A=[$0019] X=$0003 Y=[stk] ; [SP-86]
004A65  85 19                         sta  $19             ; A=[$0019] X=$0003 Y=[stk] ; [SP-86]
004A67  A5 1A                         lda  $1A             ; A=[$001A] X=$0003 Y=[stk] ; [SP-86]
004A69  65 20                         adc  $20             ; A=[$001A] X=$0003 Y=[stk] ; [SP-86]
004A6B  85 1A                         sta  $1A             ; A=[$001A] X=$0003 Y=[stk] ; [SP-86]
004A6D  18                L_004A6D    clc                  ; A=[$001A] X=$0003 Y=[stk] ; [SP-86]
004A6E  A5 04                         lda  $04             ; A=[$0004] X=$0003 Y=[stk] ; [SP-86]
004A70  65 21                         adc  $21             ; A=[$0004] X=$0003 Y=[stk] ; [SP-86]
004A72  85 04                         sta  $04             ; A=[$0004] X=$0003 Y=[stk] ; [SP-86]
004A74  20 14 49                      jsr  L_004914        ; A=[$0004] X=$0003 Y=[stk] ; [SP-88]
; === End of while loop (counter: $00) ===

004A77  A5 29                         lda  $29             ; A=[$0029] X=$0003 Y=[stk] ; [SP-88]
004A79  D0 02                         bne  L_004A7D        ; A=[$0029] X=$0003 Y=[stk] ; [SP-88]
004A7B  C6 2A                         dec  $2A             ; A=[$0029] X=$0003 Y=[stk] ; [SP-88]
004A7D  C6 29             L_004A7D    dec  $29             ; A=[$0029] X=$0003 Y=[stk] ; [SP-88]
004A7F  A5 29                         lda  $29             ; A=[$0029] X=$0003 Y=[stk] ; [OPT] REDUNDANT_LOAD: Redundant LDA: same value loaded at $004A77 ; [SP-88]
004A81  05 2A                         ora  $2A             ; A=[$0029] X=$0003 Y=[stk] ; [SP-88]
004A83  D0 B8                         bne  L_004A3D        ; A=[$0029] X=$0003 Y=[stk] ; [SP-88]
; === End of while loop (counter: $00) ===

004A85  60                            rts                  ; A=[$0029] X=$0003 Y=[stk] ; [SP-86]

; === while loop starts here (counter: Y 'j', range: 0..192, iters: 192) [nest:26] ===

; FUNC $004A86: register -> A:X [I]
; Proto: uint32_t func_004A86(uint16_t param_X, uint16_t param_Y);
; Liveness: params(X,Y) returns(A,X,Y) [8 dead stores]
004A86  A5 0D             L_004A86    lda  $0D             ; A=[$000D] X=$0003 Y=[stk] ; [SP-86]
004A88  C5 0F                         cmp  $0F             ; A=[$000D] X=$0003 Y=[stk] ; [SP-86]
004A8A  90 13                         bcc  L_004A9F        ; A=[$000D] X=$0003 Y=[stk] ; [SP-86]
004A8C  D0 06                         bne  L_004A94        ; A=[$000D] X=$0003 Y=[stk] ; [SP-86]
004A8E  A5 0C                         lda  $0C             ; A=[$000C] X=$0003 Y=[stk] ; [SP-86]
004A90  C5 0E                         cmp  $0E             ; A=[$000C] X=$0003 Y=[stk] ; [SP-86]
004A92  90 0B                         bcc  L_004A9F        ; A=[$000C] X=$0003 Y=[stk] ; [SP-86]
004A94  A5 0C             L_004A94    lda  $0C             ; A=[$000C] X=$0003 Y=[stk] ; [OPT] REDUNDANT_LOAD: Redundant LDA: same value loaded at $004A8E ; [SP-86]
004A96  85 0E                         sta  $0E             ; A=[$000C] X=$0003 Y=[stk] ; [SP-86]
004A98  A5 0D                         lda  $0D             ; A=[$000D] X=$0003 Y=[stk] ; [SP-86]
004A9A  85 0F                         sta  $0F             ; A=[$000D] X=$0003 Y=[stk] ; [SP-86]
004A9C  20 9E 43                      jsr  L_00439E        ; Call $00439E(A)
; === End of while loop (counter: X) ===

004A9F  A9 00             L_004A9F    lda  #$00            ; A=$0000 X=$0003 Y=[stk] ; [SP-88]
004AA1  85 12                         sta  $12             ; A=$0000 X=$0003 Y=[stk] ; [SP-88]
004AA3  85 11                         sta  $11             ; A=$0000 X=$0003 Y=[stk] ; [SP-88]

; === while loop starts here [nest:42] ===
004AA5  E6 12             L_004AA5    inc  $12             ; A=$0000 X=$0003 Y=[stk] ; [SP-88]
004AA7  A5 12                         lda  $12             ; A=[$0012] X=$0003 Y=[stk] ; [SP-88]
004AA9  C9 50                         cmp  #$50            ; A=[$0012] X=$0003 Y=[stk] ; [SP-88]
004AAB  D0 0A                         bne  L_004AB7        ; A=[$0012] X=$0003 Y=[stk] ; [SP-88]
004AAD  A9 00                         lda  #$00            ; A=$0000 X=$0003 Y=[stk] ; [SP-88]
004AAF  85 12                         sta  $12             ; A=$0000 X=$0003 Y=[stk] ; [SP-88]
004AB1  A5 11                         lda  $11             ; A=[$0011] X=$0003 Y=[stk] ; [SP-88]
004AB3  49 FF                         eor  #$FF            ; A=A^$FF X=$0003 Y=[stk] ; [SP-88]
004AB5  85 11                         sta  $11             ; A=A^$FF X=$0003 Y=[stk] ; [SP-88]
004AB7  A9 14             L_004AB7    lda  #$14            ; A=$0014 X=$0003 Y=[stk] ; [SP-88]
004AB9  85 02                         sta  $02             ; A=$0014 X=$0003 Y=[stk] ; [SP-88]
004ABB  A9 42                         lda  #$42            ; A=$0042 X=$0003 Y=[stk] ; [SP-88]
004ABD  85 04                         sta  $04             ; A=$0042 X=$0003 Y=[stk] ; [SP-88]
004ABF  A5 11                         lda  $11             ; A=[$0011] X=$0003 Y=[stk] ; [SP-88]
004AC1  F0 08                         beq  L_004ACB        ; A=[$0011] X=$0003 Y=[stk] ; [SP-88]
004AC3  A9 25                         lda  #$25            ; A=$0025 X=$0003 Y=[stk] ; [SP-88]
004AC5  20 C0 40                      jsr  L_0040C0        ; A=$0025 X=$0003 Y=[stk] ; [SP-90]
; === End of while loop (counter: X) ===

004AC8  4C D0 4A                      jmp  L_004AD0        ; A=$0025 X=$0003 Y=[stk] ; [SP-90]
004ACB  A9 25             L_004ACB    lda  #$25            ; A=$0025 X=$0003 Y=[stk] ; [SP-90]
004ACD  20 62 04                      jsr  $0462           ; A=$0025 X=$0003 Y=[stk] ; [SP-92]
004AD0  20 28 5C          L_004AD0    jsr  L_005C28        ; A=$0025 X=$0003 Y=[stk] ; [SP-94]
004AD3  A9 40                         lda  #$40            ; A=$0040 X=$0003 Y=[stk] ; [SP-94]
004AD5  20 6C 5C                      jsr  L_005C6C        ; A=$0040 X=$0003 Y=[stk] ; [SP-96]
004AD8  AD 00 C0                      lda  $C000           ; KBD - Keyboard data / 80STORE off {Keyboard} <keyboard_read>
004ADB  C9 8D                         cmp  #$8D            ; A=[$C000] X=$0003 Y=[stk] ; [SP-96]
004ADD  D0 C6                         bne  L_004AA5        ; A=[$C000] X=$0003 Y=[stk] ; [SP-96]
; === End of while loop ===

004ADF  60                            rts                  ; A=[$C000] X=$0003 Y=[stk] ; [SP-94]

; === while loop starts here (counter: $00, range: 0..17817, step: 17819, iters: 76562087036320) [nest:37] [inner] ===

; FUNC $004AE0: register -> A:X []
; Proto: uint32_t func_004AE0(uint16_t param_X);
; Liveness: params(X) returns(A,X,Y) [21 dead stores]
004AE0  F8                L_004AE0    sed                  ; A=[$C000] X=$0003 Y=[stk] ; [SP-94]
004AE1  18                            clc                  ; A=[$C000] X=$0003 Y=[stk] ; [SP-94]
004AE2  65 0C                         adc  $0C             ; A=[$C000] X=$0003 Y=[stk] ; [SP-94]
004AE4  85 0C                         sta  $0C             ; A=[$C000] X=$0003 Y=[stk] ; [SP-94]
004AE6  A5 0D                         lda  $0D             ; A=[$000D] X=$0003 Y=[stk] ; [SP-94]
004AE8  69 00                         adc  #$00            ; A=A X=$0003 Y=[stk] ; [SP-94]
004AEA  85 0D                         sta  $0D             ; A=A X=$0003 Y=[stk] ; [SP-94]
004AEC  D8                            cld                  ; A=A X=$0003 Y=[stk] ; [SP-94]
004AED  C5 35                         cmp  $35             ; A=A X=$0003 Y=[stk] ; [SP-94]
004AEF  D0 18                         bne  L_004B09        ; A=A X=$0003 Y=[stk] ; [SP-94]
004AF1  E6 10                         inc  $10             ; A=A X=$0003 Y=[stk] ; [SP-94]
004AF3  20 CD 43                      jsr  L_0043CD        ; A=A X=$0003 Y=[stk] ; [SP-96]
; === End of while loop (counter: $00) ===

004AF6  F8                            sed                  ; A=A X=$0003 Y=[stk] ; [SP-96]
004AF7  A9 10                         lda  #$10            ; A=$0010 X=$0003 Y=[stk] ; [SP-96]
004AF9  18                            clc                  ; A=$0010 X=$0003 Y=[stk] ; [SP-96]
004AFA  65 35                         adc  $35             ; A=$0010 X=$0003 Y=[stk] ; [SP-96]
004AFC  D8                            cld                  ; A=$0010 X=$0003 Y=[stk] ; [SP-96]
004AFD  85 35                         sta  $35             ; A=$0010 X=$0003 Y=[stk] ; [SP-96]
004AFF  A0 00                         ldy  #$00            ; A=$0010 X=$0003 Y=$0000 ; [SP-96]
004B01  A9 3C                         lda  #$3C            ; A=$003C X=$0003 Y=$0000 ; [SP-96]
004B03  8D 67 5B                      sta  $5B67           ; A=$003C X=$0003 Y=$0000 ; [SP-96]
004B06  20 62 5B                      jsr  L_005B62        ; A=$003C X=$0003 Y=$0000 ; [SP-98]
004B09  4C 87 43          L_004B09    jmp  L_004387        ; A=$003C X=$0003 Y=$0000 ; [SP-98]
; === End of while loop (counter: $00) ===


; === while loop starts here (counter: Y 'j') [nest:36] ===

; FUNC $004B0C: register -> A:X []
; Proto: uint32_t func_004B0C(uint16_t param_X);
; Liveness: params(X) returns(A,X,Y) [18 dead stores]
004B0C  8A                L_004B0C    txa                  ; A=$0003 X=$0003 Y=$0000 ; [SP-98]
004B0D  8E 64 4B                      stx  $4B64           ; A=$0003 X=$0003 Y=$0000 ; [SP-98]
004B10  0A                            asl  a               ; A=$0003 X=$0003 Y=$0000 ; [OPT] STRENGTH_RED: Multiple ASL A: consider using lookup table for multiply ; [SP-98]
004B11  0A                            asl  a               ; A=$0003 X=$0003 Y=$0000 ; [SP-98]
004B12  18                            clc                  ; A=$0003 X=$0003 Y=$0000 ; [SP-98]
004B13  69 03                         adc  #$03            ; A=A+$03 X=$0003 Y=$0000 ; [SP-98]
004B15  AA                            tax                  ; A=A+$03 X=A Y=$0000 ; [SP-98]
004B16  A0 03                         ldy  #$03            ; A=A+$03 X=A Y=$0003 ; [SP-98]

; === while loop starts here [nest:46] ===
004B18  BD B8 53          L_004B18    lda  $53B8,X         ; A=A+$03 X=A Y=$0003 ; [SP-98]
004B1B  C9 04                         cmp  #$04            ; A=A+$03 X=A Y=$0003 ; [SP-98]
004B1D  D0 15                         bne  L_004B34        ; A=A+$03 X=A Y=$0003 ; [SP-98]
004B1F  CA                            dex                  ; A=A+$03 X=X-$01 Y=$0003 ; [SP-98]
004B20  88                            dey                  ; A=A+$03 X=X-$01 Y=$0002 ; [SP-98]
004B21  10 F5                         bpl  L_004B18        ; A=A+$03 X=X-$01 Y=$0002 ; [SP-98]
; === End of while loop ===

004B23  20 03 04                      jsr  $0403           ; A=A+$03 X=X-$01 Y=$0002 ; [SP-100]
004B26  C9 10                         cmp  #$10            ; A=A+$03 X=X-$01 Y=$0002 ; [SP-100]
004B28  B0 05                         bcs  L_004B2F        ; A=A+$03 X=X-$01 Y=$0002 ; [SP-100]
004B2A  A9 03                         lda  #$03            ; A=$0003 X=X-$01 Y=$0002 ; [SP-100]
004B2C  4C 36 4B                      jmp  L_004B36        ; A=$0003 X=X-$01 Y=$0002 ; [SP-100]
004B2F  A9 02             L_004B2F    lda  #$02            ; A=$0002 X=X-$01 Y=$0002 ; [SP-100]
004B31  4C 36 4B                      jmp  L_004B36        ; A=$0002 X=X-$01 Y=$0002 ; [SP-100]
004B34  A9 01             L_004B34    lda  #$01            ; A=$0001 X=X-$01 Y=$0002 ; [SP-100]
004B36  AE 64 4B          L_004B36    ldx  $4B64           ; A=$0001 X=X-$01 Y=$0002 ; [SP-100]
004B39  9D 54 5D                      sta  $5D54,X         ; A=$0001 X=X-$01 Y=$0002 ; [SP-100]
004B3C  BD 58 4B                      lda  $4B58,X         ; A=$0001 X=X-$01 Y=$0002 ; [SP-100]
004B3F  9D 48 5D                      sta  $5D48,X         ; A=$0001 X=X-$01 Y=$0002 ; [SP-100]
004B42  BD 5C 4B                      lda  $4B5C,X         ; A=$0001 X=X-$01 Y=$0002 ; [SP-100]
004B45  9D 4C 5D                      sta  $5D4C,X         ; A=$0001 X=X-$01 Y=$0002 ; [SP-100]
004B48  BD 60 4B                      lda  $4B60,X         ; A=$0001 X=X-$01 Y=$0002 ; [SP-100]
004B4B  9D 50 5D                      sta  $5D50,X         ; A=$0001 X=X-$01 Y=$0002 ; [SP-100]
004B4E  A0 10                         ldy  #$10            ; A=$0001 X=X-$01 Y=$0010 ; [SP-100]
004B50  A9 45                         lda  #$45            ; A=$0045 X=X-$01 Y=$0010 ; [SP-100]
004B52  8D 67 5B                      sta  $5B67           ; A=$0045 X=X-$01 Y=$0010 ; [SP-100]
004B55  4C 62 5B                      jmp  L_005B62        ; A=$0045 X=X-$01 Y=$0010 ; [SP-100]

; --- Data region ---
004B58  A900A950                HEX     A900A950 00010000 105EAC5E 00

; === while loop starts here (counter: X 'iter_x') [nest:12] ===

; FUNC $004B65: register -> A:X []
; Liveness: returns(A,X,Y) [7 dead stores]
; --- End data region (13 bytes) ---

004B65  AD D6 57          L_004B65    lda  $57D6           ; A=[$57D6] X=X-$01 Y=$0010 ; [SP-106]
004B68  20 3C 4C                      jsr  L_004C3C        ; A=[$57D6] X=X-$01 Y=$0010 ; [SP-108]
004B6B  AD D6 57                      lda  $57D6           ; A=[$57D6] X=X-$01 Y=$0010 ; [SP-108]
004B6E  0A                            asl  a               ; A=[$57D6] X=X-$01 Y=$0010 ; [OPT] STRENGTH_RED: Multiple ASL A: consider using lookup table for multiply ; [SP-108]
004B6F  0A                            asl  a               ; A=[$57D6] X=X-$01 Y=$0010 ; [SP-108]
004B70  18                            clc                  ; A=[$57D6] X=X-$01 Y=$0010 ; [SP-108]
004B71  69 03                         adc  #$03            ; A=A+$03 X=X-$01 Y=$0010 ; [SP-108]
004B73  AA                            tax                  ; A=A+$03 X=A Y=$0010 ; [SP-108]
004B74  A0 03                         ldy  #$03            ; A=A+$03 X=A Y=$0003 ; [SP-108]
004B76  A9 05                         lda  #$05            ; A=$0005 X=A Y=$0003 ; [SP-108]

; === while loop starts here [nest:48] ===
004B78  9D B8 53          L_004B78    sta  $53B8,X         ; A=$0005 X=A Y=$0003 ; [SP-108]
004B7B  CA                            dex                  ; A=$0005 X=X-$01 Y=$0003 ; [SP-108]
004B7C  88                            dey                  ; A=$0005 X=X-$01 Y=$0002 ; [SP-108]
004B7D  10 F9                         bpl  L_004B78        ; A=$0005 X=X-$01 Y=$0002 ; [SP-108]
; === End of while loop ===

004B7F  AE D6 57                      ldx  $57D6           ; A=$0005 X=X-$01 Y=$0002 ; [SP-108]
004B82  D0 03                         bne  L_004B87        ; A=$0005 X=X-$01 Y=$0002 ; [SP-108]
004B84  4C C5 54                      jmp  L_0054C5        ; A=$0005 X=X-$01 Y=$0002 ; [SP-108]
004B87  E0 01             L_004B87    cpx  #$01            ; A=$0005 X=X-$01 Y=$0002 ; [SP-108]
004B89  D0 03                         bne  L_004B8E        ; A=$0005 X=X-$01 Y=$0002 ; [SP-108]
004B8B  4C 61 54                      jmp  L_005461        ; A=$0005 X=X-$01 Y=$0002 ; [SP-108]
004B8E  E0 02             L_004B8E    cpx  #$02            ; A=$0005 X=X-$01 Y=$0002 ; [SP-108]
004B90  D0 03                         bne  L_004B95        ; A=$0005 X=X-$01 Y=$0002 ; [SP-108]
004B92  4C 29 55                      jmp  L_005529        ; A=$0005 X=X-$01 Y=$0002 ; [SP-108]
004B95  4C FD 53          L_004B95    jmp  L_0053FD        ; A=$0005 X=X-$01 Y=$0002 ; [SP-108]

; === while loop starts here (counter: $00, range: 0..23767, step: 23770, iters: 83837761637438) [nest:46] [inner] ===
004B98  A9 03             L_004B98    lda  #$03            ; A=$0003 X=X-$01 Y=$0002 ; [SP-108]
004B9A  8D F8 53                      sta  $53F8           ; A=$0003 X=X-$01 Y=$0002 ; [SP-108]

; === while loop starts here (counter: $00 '', range: 0..19537, step: 19475, iters: 83700322683934) [nest:48] [inner] ===
004B9D  AE F8 53          L_004B9D    ldx  $53F8           ; A=$0003 X=X-$01 Y=$0002 ; [SP-108]
004BA0  BD C4 53                      lda  $53C4,X         ; A=$0003 X=X-$01 Y=$0002 ; [SP-108]
004BA3  F0 16                         beq  L_004BBB        ; A=$0003 X=X-$01 Y=$0002 ; [SP-108]
004BA5  48                            pha                  ; A=$0003 X=X-$01 Y=$0002 ; [SP-109]
004BA6  AD F3 53                      lda  $53F3           ; A=[$53F3] X=X-$01 Y=$0002 ; [SP-109]
004BA9  18                            clc                  ; A=[$53F3] X=X-$01 Y=$0002 ; [SP-109]
004BAA  7D E8 53                      adc  $53E8,X         ; A=[$53F3] X=X-$01 Y=$0002 ; [SP-109]
004BAD  85 04                         sta  $04             ; A=[$53F3] X=X-$01 Y=$0002 ; [SP-109]
004BAF  A9 09                         lda  #$09            ; A=$0009 X=X-$01 Y=$0002 ; [SP-109]
004BB1  85 02                         sta  $02             ; A=$0009 X=X-$01 Y=$0002 ; [SP-109]
004BB3  68                            pla                  ; A=[stk] X=X-$01 Y=$0002 ; [SP-108]
004BB4  AA                            tax                  ; A=[stk] X=[stk] Y=$0002 ; [SP-108]
004BB5  BD D6 53                      lda  $53D6,X         ; A=[stk] X=[stk] Y=$0002 ; [SP-108]
004BB8  20 C0 40                      jsr  L_0040C0        ; A=[stk] X=[stk] Y=$0002 ; [SP-110]
; === End of while loop (counter: $00) ===

004BBB  CE F8 53          L_004BBB    dec  $53F8           ; A=[stk] X=[stk] Y=$0002 ; [SP-110]
004BBE  10 DD                         bpl  L_004B9D        ; A=[stk] X=[stk] Y=$0002 ; [SP-110]
; === End of while loop (counter: $00) ===

004BC0  60                            rts                  ; A=[stk] X=[stk] Y=$0002 ; [SP-108]

; === while loop starts here (counter: $00 '', range: 0..23669, step: 23661, iters: 84348862745887) [nest:46] [inner] ===
004BC1  A9 03             L_004BC1    lda  #$03            ; A=$0003 X=[stk] Y=$0002 ; [SP-108]
004BC3  8D F8 53                      sta  $53F8           ; A=$0003 X=[stk] Y=$0002 ; [SP-108]

; === while loop starts here (counter: $00, range: 0..19756, step: 19758, iters: 84679575227651) [nest:48] [inner] ===
004BC6  AE F8 53          L_004BC6    ldx  $53F8           ; A=$0003 X=[stk] Y=$0002 ; [SP-108]
004BC9  BD BC 53                      lda  $53BC,X         ; A=$0003 X=[stk] Y=$0002 ; [SP-108]
004BCC  F0 16                         beq  L_004BE4        ; A=$0003 X=[stk] Y=$0002 ; [SP-108]
004BCE  48                            pha                  ; A=$0003 X=[stk] Y=$0002 ; [SP-109]
004BCF  AD F1 53                      lda  $53F1           ; A=[$53F1] X=[stk] Y=$0002 ; [SP-109]
004BD2  18                            clc                  ; A=[$53F1] X=[stk] Y=$0002 ; [SP-109]
004BD3  7D E8 53                      adc  $53E8,X         ; A=[$53F1] X=[stk] Y=$0002 ; [SP-109]
004BD6  85 04                         sta  $04             ; A=[$53F1] X=[stk] Y=$0002 ; [SP-109]
004BD8  A9 25                         lda  #$25            ; A=$0025 X=[stk] Y=$0002 ; [SP-109]
004BDA  85 02                         sta  $02             ; A=$0025 X=[stk] Y=$0002 ; [SP-109]
004BDC  68                            pla                  ; A=[stk] X=[stk] Y=$0002 ; [SP-108]
004BDD  AA                            tax                  ; A=[stk] X=[stk] Y=$0002 ; [SP-108]
004BDE  BD DD 53                      lda  $53DD,X         ; A=[stk] X=[stk] Y=$0002 ; [SP-108]
004BE1  20 C0 40                      jsr  L_0040C0        ; A=[stk] X=[stk] Y=$0002 ; [SP-110]
; === End of while loop (counter: $00) ===

004BE4  CE F8 53          L_004BE4    dec  $53F8           ; A=[stk] X=[stk] Y=$0002 ; [SP-110]
004BE7  10 DD                         bpl  L_004BC6        ; A=[stk] X=[stk] Y=$0002 ; [SP-110]
; === End of while loop (counter: $00) ===

004BE9  60                            rts                  ; A=[stk] X=[stk] Y=$0002 ; [SP-108]

; === while loop starts here (counter: $00, range: 0..19425, step: 19428, iters: 83116207131719) [nest:48] [inner] ===
004BEA  A9 03             L_004BEA    lda  #$03            ; A=$0003 X=[stk] Y=$0002 ; [SP-108]
004BEC  8D F8 53                      sta  $53F8           ; A=$0003 X=[stk] Y=$0002 ; [SP-108]

; === while loop starts here (counter: $00 '', range: 0..19384, step: 16576, iters: 83266530986938) [nest:49] [inner] ===
004BEF  AE F8 53          L_004BEF    ldx  $53F8           ; A=$0003 X=[stk] Y=$0002 ; [SP-108]
004BF2  BD B8 53                      lda  $53B8,X         ; A=$0003 X=[stk] Y=$0002 ; [SP-108]
004BF5  F0 16                         beq  L_004C0D        ; A=$0003 X=[stk] Y=$0002 ; [SP-108]
004BF7  48                            pha                  ; A=$0003 X=[stk] Y=$0002 ; [SP-109]
004BF8  AD EC 53                      lda  $53EC           ; A=[$53EC] X=[stk] Y=$0002 ; [SP-109]
004BFB  18                            clc                  ; A=[$53EC] X=[stk] Y=$0002 ; [SP-109]
004BFC  7D E4 53                      adc  $53E4,X         ; A=[$53EC] X=[stk] Y=$0002 ; [SP-109]
004BFF  85 19                         sta  $19             ; A=[$53EC] X=[stk] Y=$0002 ; [SP-109]
004C01  A9 01                         lda  #$01            ; A=$0001 X=[stk] Y=$0002 ; [SP-109]
; case 0:
004C03  85 04                         sta  $04             ; A=$0001 X=[stk] Y=$0002 ; [SP-109]
004C05  68                            pla                  ; A=[stk] X=[stk] Y=$0002 ; [SP-108]
004C06  AA                            tax                  ; A=[stk] X=[stk] Y=$0002 ; [SP-108]
004C07  BD C8 53                      lda  $53C8,X         ; A=[stk] X=[stk] Y=$0002 ; [SP-108]
004C0A  20 A1 52                      jsr  L_0052A1        ; A=[stk] X=[stk] Y=$0002 ; [SP-110]
004C0D  CE F8 53          L_004C0D    dec  $53F8           ; A=[stk] X=[stk] Y=$0002 ; [SP-110]
004C10  10 DD                         bpl  L_004BEF        ; A=[stk] X=[stk] Y=$0002 ; [SP-110]
; === End of while loop (counter: $00) ===

004C12  60                            rts                  ; A=[stk] X=[stk] Y=$0002 ; [SP-108]

; === while loop starts here (counter: $00 '', range: 0..19554, step: 19561, iters: 90705414343790) [nest:46] [inner] ===
004C13  A9 03             L_004C13    lda  #$03            ; A=$0003 X=[stk] Y=$0002 ; [SP-108]
004C15  8D F8 53                      sta  $53F8           ; A=$0003 X=[stk] Y=$0002 ; [SP-108]

; === while loop starts here (counter: $00, range: 0..19721, step: 19724, iters: 84748294704402) [nest:50] [inner] ===
004C18  AE F8 53          L_004C18    ldx  $53F8           ; A=$0003 X=[stk] Y=$0002 ; [SP-108]
004C1B  BD C0 53                      lda  $53C0,X         ; A=$0003 X=[stk] Y=$0002 ; [SP-108]
004C1E  F0 16                         beq  L_004C36        ; A=$0003 X=[stk] Y=$0002 ; [SP-108]
004C20  48                            pha                  ; A=$0003 X=[stk] Y=$0002 ; [SP-109]
004C21  AD EE 53                      lda  $53EE           ; A=[$53EE] X=[stk] Y=$0002 ; [SP-109]
004C24  18                            clc                  ; A=[$53EE] X=[stk] Y=$0002 ; [SP-109]
004C25  7D E4 53                      adc  $53E4,X         ; A=[$53EE] X=[stk] Y=$0002 ; [SP-109]
004C28  85 19                         sta  $19             ; A=[$53EE] X=[stk] Y=$0002 ; [SP-109]
004C2A  A9 B4                         lda  #$B4            ; A=$00B4 X=[stk] Y=$0002 ; [SP-109]
004C2C  85 04                         sta  $04             ; A=$00B4 X=[stk] Y=$0002 ; [SP-109]
004C2E  68                            pla                  ; A=[stk] X=[stk] Y=$0002 ; [SP-108]
004C2F  AA                            tax                  ; A=[stk] X=[stk] Y=$0002 ; [SP-108]
004C30  BD CF 53                      lda  $53CF,X         ; A=[stk] X=[stk] Y=$0002 ; [SP-108]
004C33  20 A1 52                      jsr  L_0052A1        ; A=[stk] X=[stk] Y=$0002 ; [SP-110]
004C36  CE F8 53          L_004C36    dec  $53F8           ; A=[stk] X=[stk] Y=$0002 ; [SP-110]
004C39  10 DD                         bpl  L_004C18        ; A=[stk] X=[stk] Y=$0002 ; [SP-110]
; === End of while loop (counter: $00) ===

004C3B  60                            rts                  ; A=[stk] X=[stk] Y=$0002 ; [SP-108]

; === while loop starts here (counter: $00 '', range: 0..19585, step: 19590, iters: 84396107386048) [nest:5] [inner] ===

; FUNC $004C3C: register -> A:X [L]
; Proto: uint32_t func_004C3C(uint16_t param_X, uint16_t param_Y);
; Liveness: params(X,Y) returns(A,X,Y) [5 dead stores]
004C3C  C9 00             L_004C3C    cmp  #$00            ; A=[stk] X=[stk] Y=$0002 ; [SP-108]
004C3E  D0 03                         bne  L_004C43        ; A=[stk] X=[stk] Y=$0002 ; [SP-108]
004C40  4C EA 4B                      jmp  L_004BEA        ; A=[stk] X=[stk] Y=$0002 ; [SP-108]
; === End of while loop (counter: $00) ===

004C43  C9 03             L_004C43    cmp  #$03            ; A=[stk] X=[stk] Y=$0002 ; [SP-108]
004C45  D0 03                         bne  L_004C4A        ; A=[stk] X=[stk] Y=$0002 ; [SP-108]
004C47  4C 98 4B                      jmp  L_004B98        ; A=[stk] X=[stk] Y=$0002 ; [SP-108]
; === End of while loop (counter: $00) ===

004C4A  C9 01             L_004C4A    cmp  #$01            ; A=[stk] X=[stk] Y=$0002 ; [SP-108]
004C4C  D0 03                         bne  L_004C51        ; A=[stk] X=[stk] Y=$0002 ; [SP-108]
004C4E  4C C1 4B                      jmp  L_004BC1        ; A=[stk] X=[stk] Y=$0002 ; [SP-108]
; === End of while loop (counter: $00) ===

004C51  4C 13 4C          L_004C51    jmp  L_004C13        ; A=[stk] X=[stk] Y=$0002 ; [SP-108]
; === End of while loop (counter: $00) ===


; --- Data region ---
004C54  0000                    HEX     0000

; === while loop starts here (counter: $00, range: 0..20461, step: 20464, iters: 87449829134191) [nest:47] [inner] ===

; FUNC $004C56: register -> A:X [LJ]
; Proto: uint32_t func_004C56(uint16_t param_X, uint16_t param_Y);
; Liveness: params(X,Y) returns(A,X,Y) [5 dead stores]
; --- End data region (2 bytes) ---

004C56  AD 54 4C          L_004C56    lda  $4C54           ; A=[$4C54] X=[stk] Y=$0002 ; [SP-111]
004C59  85 19                         sta  $19             ; A=[$4C54] X=[stk] Y=$0002 ; [SP-111]
004C5B  AD 55 4C                      lda  $4C55           ; A=[$4C55] X=[stk] Y=$0002 ; [SP-111]
004C5E  85 04                         sta  $04             ; A=[$4C55] X=[stk] Y=$0002 ; [SP-111]
004C60  A5 3A                         lda  $3A             ; A=[$003A] X=[stk] Y=$0002 ; [SP-111]
004C62  D0 05                         bne  L_004C69        ; A=[$003A] X=[stk] Y=$0002 ; [SP-111]
004C64  A9 9A                         lda  #$9A            ; A=$009A X=[stk] Y=$0002 ; [SP-111]
004C66  4C 6B 4C                      jmp  L_004C6B        ; A=$009A X=[stk] Y=$0002 ; [SP-111]
004C69  A9 90             L_004C69    lda  #$90            ; A=$0090 X=[stk] Y=$0002 ; [SP-111]
004C6B  2C 30 C0          L_004C6B    bit  $C030           ; SPKR - Speaker toggle {Speaker} <speaker_toggle>
004C6E  4C 7F 52                      jmp  L_00527F        ; A=$0090 X=[stk] Y=$0002 ; [SP-111]

; === while loop starts here (counter: $00 '', range: 0..20442, step: 20464, iters: 91023241924572) [nest:48] [inner] ===

; FUNC $004C71: register -> A:X [L]
; Proto: uint32_t func_004C71(uint16_t param_X, uint16_t param_Y);
; Liveness: params(X,Y) returns(A,X,Y) [2 dead stores]
004C71  AD 54 4C          L_004C71    lda  $4C54           ; A=[$4C54] X=[stk] Y=$0002 ; [SP-111]
004C74  85 19                         sta  $19             ; A=[$4C54] X=[stk] Y=$0002 ; [SP-111]
004C76  AD 55 4C                      lda  $4C55           ; A=[$4C55] X=[stk] Y=$0002 ; [SP-111]
004C79  85 04                         sta  $04             ; A=[$4C55] X=[stk] Y=$0002 ; [SP-111]
004C7B  A5 3A                         lda  $3A             ; A=[$003A] X=[stk] Y=$0002 ; [SP-111]
004C7D  D0 05                         bne  L_004C84        ; A=[$003A] X=[stk] Y=$0002 ; [SP-111]
004C7F  A9 9A                         lda  #$9A            ; A=$009A X=[stk] Y=$0002 ; [SP-111]
004C81  4C 86 4C                      jmp  L_004C86        ; A=$009A X=[stk] Y=$0002 ; [SP-111]
004C84  A9 90             L_004C84    lda  #$90            ; A=$0090 X=[stk] Y=$0002 ; [SP-111]
004C86  2C 30 C0          L_004C86    bit  $C030           ; SPKR - Speaker toggle {Speaker} <speaker_toggle>
004C89  4C A1 52                      jmp  L_0052A1        ; A=$0090 X=[stk] Y=$0002 ; [SP-111]

; --- Data region ---
004C8C  000060                  HEX     000060
; --- End data region (3 bytes) ---

004C8F  C0 C0             L_004C8F    cpy  #$C0            ; A=$0090 X=[stk] Y=$0002 ; [SP-112]
004C91  00 00                         brk  #$00            ; A=$0090 X=[stk] Y=$0002 ; [SP-115]

; --- Data region ---
004C93  5101A5A5                HEX     5101A5A5 0100

; === while loop starts here (counter: $00, range: 0..17512, step: 17514, iters: 75097503188043) [nest:6] [inner] ===

; FUNC $004C99: register -> A:X []
; Proto: uint32_t func_004C99(uint16_t param_Y);
; Liveness: params(Y) returns(A,X,Y) [7 dead stores]
; --- End data region (6 bytes) ---

004C99  A9 C0             L_004C99    lda  #$C0            ; A=$00C0 X=[stk] Y=$0002 ; [SP-115]
004C9B  8D 54 4C                      sta  $4C54           ; A=$00C0 X=[stk] Y=$0002 ; [SP-115]
004C9E  A9 01                         lda  #$01            ; A=$0001 X=[stk] Y=$0002 ; [SP-115]
004CA0  8D 55 4C                      sta  $4C55           ; A=$0001 X=[stk] Y=$0002 ; [SP-115]
004CA3  A9 04                         lda  #$04            ; A=$0004 X=[stk] Y=$0002 ; [SP-115]
004CA5  8D 98 4C                      sta  $4C98           ; A=$0004 X=[stk] Y=$0002 ; [SP-115]

; === while loop starts here (counter: $00, range: 0..23738, step: 23741, iters: 101988293434559) [nest:48] [inner] ===
004CA8  AE 98 4C          L_004CA8    ldx  $4C98           ; A=$0004 X=[stk] Y=$0002 ; [SP-115]
004CAB  BD 8E 4C                      lda  $4C8E,X         ; A=$0004 X=[stk] Y=$0002 ; [SP-115]
004CAE  8D 8C 4C                      sta  $4C8C           ; A=$0004 X=[stk] Y=$0002 ; [SP-115]
004CB1  BD 93 4C                      lda  $4C93,X         ; A=$0004 X=[stk] Y=$0002 ; [SP-115]
004CB4  8D 8D 4C                      sta  $4C8D           ; A=$0004 X=[stk] Y=$0002 ; [SP-115]

; === while loop starts here (counter: $00, range: 0..23683, step: 23685, iters: 101739185331333) [nest:49] [inner] ===
004CB7  20 71 4C          L_004CB7    jsr  L_004C71        ; A=$0004 X=[stk] Y=$0002 ; [SP-117]
; === End of while loop (counter: $00) ===

004CBA  AD 54 4C                      lda  $4C54           ; A=[$4C54] X=[stk] Y=$0002 ; [SP-117]
004CBD  CD 8C 4C                      cmp  $4C8C           ; A=[$4C54] X=[stk] Y=$0002 ; [SP-117]
004CC0  F0 11                         beq  L_004CD3        ; A=[$4C54] X=[stk] Y=$0002 ; [SP-117]
004CC2  B0 09                         bcs  L_004CCD        ; A=[$4C54] X=[stk] Y=$0002 ; [SP-117]
004CC4  18                            clc                  ; A=[$4C54] X=[stk] Y=$0002 ; [SP-117]
004CC5  69 04                         adc  #$04            ; A=A+$04 X=[stk] Y=$0002 ; [SP-117]
004CC7  8D 54 4C                      sta  $4C54           ; A=A+$04 X=[stk] Y=$0002 ; [SP-117]
004CCA  4C D3 4C                      jmp  L_004CD3        ; A=A+$04 X=[stk] Y=$0002 ; [SP-117]
004CCD  38                L_004CCD    sec                  ; A=A+$04 X=[stk] Y=$0002 ; [SP-117]
004CCE  E9 04                         sbc  #$04            ; A=A-$04 X=[stk] Y=$0002 ; [SP-117]
004CD0  8D 54 4C                      sta  $4C54           ; A=A-$04 X=[stk] Y=$0002 ; [OPT] PEEPHOLE: Load after store: 2 byte pattern at $004CD0 ; [SP-117]
004CD3  AD 55 4C          L_004CD3    lda  $4C55           ; A=[$4C55] X=[stk] Y=$0002 ; [SP-117]
004CD6  CD 8D 4C                      cmp  $4C8D           ; A=[$4C55] X=[stk] Y=$0002 ; [SP-117]
004CD9  F0 11                         beq  L_004CEC        ; A=[$4C55] X=[stk] Y=$0002 ; [SP-117]
004CDB  B0 09                         bcs  L_004CE6        ; A=[$4C55] X=[stk] Y=$0002 ; [SP-117]
004CDD  18                            clc                  ; A=[$4C55] X=[stk] Y=$0002 ; [SP-117]
004CDE  69 04                         adc  #$04            ; A=A+$04 X=[stk] Y=$0002 ; [SP-117]
004CE0  8D 55 4C                      sta  $4C55           ; A=A+$04 X=[stk] Y=$0002 ; [SP-117]
004CE3  4C EC 4C                      jmp  L_004CEC        ; A=A+$04 X=[stk] Y=$0002 ; [SP-117]
004CE6  38                L_004CE6    sec                  ; A=A+$04 X=[stk] Y=$0002 ; [SP-117]
004CE7  E9 04                         sbc  #$04            ; A=A-$04 X=[stk] Y=$0002 ; [SP-117]
004CE9  8D 55 4C                      sta  $4C55           ; A=A-$04 X=[stk] Y=$0002 ; [SP-117]
004CEC  20 56 4C          L_004CEC    jsr  L_004C56        ; A=A-$04 X=[stk] Y=$0002 ; [SP-119]
; === End of while loop (counter: $00) ===

004CEF  AD 00 C0                      lda  $C000           ; KBD - Keyboard data / 80STORE off {Keyboard} <keyboard_read>
004CF2  C9 9E                         cmp  #$9E            ; A=[$C000] X=[stk] Y=$0002 ; [SP-119]
004CF4  D0 0E                         bne  L_004D04        ; A=[$C000] X=[stk] Y=$0002 ; [SP-119]
004CF6  AD 10 C0                      lda  $C010           ; KBDSTRB - Clear keyboard strobe {Keyboard} <keyboard_strobe>
004CF9  A9 0B                         lda  #$0B            ; A=$000B X=[stk] Y=$0002 ; [SP-119]
004CFB  85 30                         sta  $30             ; A=$000B X=[stk] Y=$0002 ; [SP-119]
004CFD  A9 03                         lda  #$03            ; A=$0003 X=[stk] Y=$0002 ; [SP-119]
004CFF  18                            clc                  ; A=$0003 X=[stk] Y=$0002 ; [SP-119]
004D00  65 10                         adc  $10             ; A=$0003 X=[stk] Y=$0002 ; [SP-119]
004D02  85 10                         sta  $10             ; A=$0003 X=[stk] Y=$0002 ; [SP-119]
004D04  A9 20             L_004D04    lda  #$20            ; A=$0020 X=[stk] Y=$0002 ; [SP-119]
004D06  8D 32 4D                      sta  $4D32           ; A=$0020 X=[stk] Y=$0002 ; [SP-119]

; === while loop starts here (counter: $00 '', range: 0..20339, step: 20351, iters: 87522843578244) [nest:51] [inner] ===
004D09  20 1C 5C          L_004D09    jsr  L_005C1C        ; A=$0020 X=[stk] Y=$0002 ; [SP-121]
004D0C  2C 30 C0                      bit  $C030           ; SPKR - Speaker toggle {Speaker} <speaker_toggle>
004D0F  CE 32 4D                      dec  $4D32           ; A=$0020 X=[stk] Y=$0002 ; [SP-121]
004D12  10 F5                         bpl  L_004D09        ; A=$0020 X=[stk] Y=$0002 ; [SP-121]
; === End of while loop (counter: $00) ===

004D14  A9 FF                         lda  #$FF            ; A=$00FF X=[stk] Y=$0002 ; [SP-121]
004D16  20 6C 5C                      jsr  L_005C6C        ; A=$00FF X=[stk] Y=$0002 ; [SP-123]
004D19  AD 54 4C                      lda  $4C54           ; A=[$4C54] X=[stk] Y=$0002 ; [SP-123]
004D1C  CD 8C 4C                      cmp  $4C8C           ; A=[$4C54] X=[stk] Y=$0002 ; [SP-123]
004D1F  D0 96                         bne  L_004CB7        ; A=[$4C54] X=[stk] Y=$0002 ; [SP-123]
; === End of while loop (counter: $00) ===

004D21  AD 55 4C                      lda  $4C55           ; A=[$4C55] X=[stk] Y=$0002 ; [SP-123]
004D24  CD 8D 4C                      cmp  $4C8D           ; A=[$4C55] X=[stk] Y=$0002 ; [SP-123]
004D27  D0 8E                         bne  L_004CB7        ; A=[$4C55] X=[stk] Y=$0002 ; [SP-123]
; === End of while loop (counter: $00) ===

004D29  CE 98 4C                      dec  $4C98           ; A=[$4C55] X=[stk] Y=$0002 ; [SP-123]
004D2C  30 03                         bmi  L_004D31        ; A=[$4C55] X=[stk] Y=$0002 ; [SP-123]
004D2E  4C A8 4C                      jmp  L_004CA8        ; A=[$4C55] X=[stk] Y=$0002 ; [SP-123]
; === End of while loop (counter: $00) ===

004D31  60                L_004D31    rts                  ; A=[$4C55] X=[stk] Y=$0002 ; [SP-121]

; --- Data region ---
004D32  00                      HEX     00

; === while loop starts here (counter: $00, range: 0..17475, step: 17477, iters: 75389560964239) [nest:7] [inner] ===

; FUNC $004D33: register -> A:X []
; Proto: uint32_t func_004D33(uint16_t param_Y);
; Liveness: params(Y) returns(A,X,Y) [1 dead stores]
; --- End data region (1 bytes) ---

004D33  A9 14             L_004D33    lda  #$14            ; A=$0014 X=[stk] Y=$0002 ; [SP-124]
004D35  85 02                         sta  $02             ; A=$0014 X=[stk] Y=$0002 ; [SP-124]
004D37  A9 75                         lda  #$75            ; A=$0075 X=[stk] Y=$0002 ; [SP-127]
004D39  85 04                         sta  $04             ; A=$0075 X=[stk] Y=$0002 ; [SP-127]
004D3B  A9 97                         lda  #$97            ; A=$0097 X=[stk] Y=$0002 ; [SP-127]
004D3D  20 16 04                      jsr  $0416           ; A=$0097 X=[stk] Y=$0002 ; [SP-127]
004D40  A9 77                         lda  #$77            ; A=$0077 X=[stk] Y=$0002 ; [SP-127]
004D42  85 19                         sta  $19             ; A=$0077 X=[stk] Y=$0002 ; [SP-127]
004D44  A9 75                         lda  #$75            ; A=$0075 X=[stk] Y=$0002 ; [SP-127]
004D46  85 04                         sta  $04             ; A=$0075 X=[stk] Y=$0002 ; [SP-127]
004D48  A6 3A                         ldx  $3A             ; A=$0075 X=[stk] Y=$0002 ; [SP-127]
004D4A  F0 07                         beq  L_004D53        ; A=$0075 X=[stk] Y=$0002 ; [SP-127]
004D4C  BD 6E 4D                      lda  $4D6E,X         ; A=$0075 X=[stk] Y=$0002 ; [SP-127]
004D4F  20 7F 52                      jsr  L_00527F        ; A=$0075 X=[stk] Y=$0002 ; [OPT] TAIL_CALL: Tail call: JSR/JSL at $004D4F followed by RTS ; [SP-129]
004D52  60                            rts                  ; A=$0075 X=[stk] Y=$0002 ; [SP-127]
004D53  A9 14             L_004D53    lda  #$14            ; A=$0014 X=[stk] Y=$0002 ; [SP-127]
004D55  85 02                         sta  $02             ; A=$0014 X=[stk] Y=$0002 ; [SP-127]
004D57  A9 82                         lda  #$82            ; A=$0082 X=[stk] Y=$0002 ; [SP-127]
004D59  85 04                         sta  $04             ; A=$0082 X=[stk] Y=$0002 ; [SP-127]
004D5B  A9 98                         lda  #$98            ; A=$0098 X=[stk] Y=$0002 ; [SP-127]
004D5D  20 16 04                      jsr  $0416           ; A=$0098 X=[stk] Y=$0002 ; [SP-129]
004D60  A9 1A                         lda  #$1A            ; A=$001A X=[stk] Y=$0002 ; [SP-129]
004D62  85 02                         sta  $02             ; A=$001A X=[stk] Y=$0002 ; [SP-129]
004D64  A9 75                         lda  #$75            ; A=$0075 X=[stk] Y=$0002 ; [SP-129]
004D66  85 04                         sta  $04             ; A=$0075 X=[stk] Y=$0002 ; [SP-129]
004D68  A9 99                         lda  #$99            ; A=$0099 X=[stk] Y=$0002 ; [SP-129]
004D6A  20 16 04                      jsr  $0416           ; A=$0099 X=[stk] Y=$0002 ; [OPT] TAIL_CALL: Tail call: JSR/JSL at $004D6A followed by RTS ; [SP-131]
004D6D  60                            rts                  ; A=$0099 X=[stk] Y=$0002 ; [SP-129]

; --- Data region ---
004D6E  00665F35                HEX     00665F35 74

; === while loop starts here (counter: A 'counter_a') [nest:36] ===

; FUNC $004D73: register -> A:X [L]
; Proto: uint32_t func_004D73(uint16_t param_Y);
; Liveness: params(Y) returns(A,X,Y)
; --- End data region (5 bytes) ---

004D73  A2 03             L_004D73    ldx  #$03            ; A=$0099 X=$0003 Y=$0002 ; [SP-132]
004D75  A9 00                         lda  #$00            ; A=$0000 X=$0003 Y=$0002 ; [SP-132]

; === while loop starts here [nest:50] ===
004D77  9D B8 53          L_004D77    sta  $53B8,X         ; -> $53BB ; A=$0000 X=$0003 Y=$0002 ; [SP-135]
004D7A  9D C0 53                      sta  $53C0,X         ; -> $53C3 ; A=$0000 X=$0003 Y=$0002 ; [SP-135]
004D7D  9D BC 53                      sta  $53BC,X         ; -> $53BF ; A=$0000 X=$0003 Y=$0002 ; [SP-135]
004D80  9D C4 53                      sta  $53C4,X         ; -> $53C7 ; A=$0000 X=$0003 Y=$0002 ; [SP-135]
004D83  CA                            dex                  ; A=$0000 X=$0002 Y=$0002 ; [SP-135]
004D84  10 F1                         bpl  L_004D77        ; A=$0000 X=$0002 Y=$0002 ; [SP-135]
; === End of while loop ===

004D86  60                            rts                  ; A=$0000 X=$0002 Y=$0002 ; [SP-133]

; === while loop starts here (counter: $00, range: 0..19933, step: 19936, iters: 90851443232524) [nest:30] [inner] ===

; FUNC $004D87: register -> A:X []
; Proto: uint32_t func_004D87(uint16_t param_Y);
; Liveness: params(Y) returns(A,X,Y)
004D87  A2 03             L_004D87    ldx  #$03            ; A=$0000 X=$0003 Y=$0002 ; [SP-133]
004D89  8E BB 4D                      stx  $4DBB           ; A=$0000 X=$0003 Y=$0002 ; [SP-133]

; === while loop starts here (counter: $00, range: 0..20273, step: 20276, iters: 87003152535328) [nest:51] [inner] ===
004D8C  AE BB 4D          L_004D8C    ldx  $4DBB           ; A=$0000 X=$0003 Y=$0002 ; [SP-133]
004D8F  BD 58 5D                      lda  $5D58,X         ; -> $5D5B ; A=$0000 X=$0003 Y=$0002 ; [SP-133]
004D92  F0 21                         beq  L_004DB5        ; A=$0000 X=$0003 Y=$0002 ; [SP-133]
004D94  E0 03                         cpx  #$03            ; A=$0000 X=$0003 Y=$0002 ; [SP-133]
004D96  F0 1A                         beq  L_004DB2        ; A=$0000 X=$0003 Y=$0002 ; [SP-133]
004D98  E0 02                         cpx  #$02            ; A=$0000 X=$0003 Y=$0002 ; [SP-133]
004D9A  F0 0A                         beq  L_004DA6        ; A=$0000 X=$0003 Y=$0002 ; [SP-133]
004D9C  E0 01                         cpx  #$01            ; A=$0000 X=$0003 Y=$0002 ; [SP-133]
004D9E  F0 0C                         beq  L_004DAC        ; A=$0000 X=$0003 Y=$0002 ; [SP-133]
004DA0  20 E3 4D                      jsr  L_004DE3        ; A=$0000 X=$0003 Y=$0002 ; [SP-135]
004DA3  4C B5 4D                      jmp  L_004DB5        ; A=$0000 X=$0003 Y=$0002 ; [SP-135]
004DA6  20 8B 4E          L_004DA6    jsr  L_004E8B        ; A=$0000 X=$0003 Y=$0002 ; [SP-137]
004DA9  4C B5 4D                      jmp  L_004DB5        ; A=$0000 X=$0003 Y=$0002 ; [SP-137]
004DAC  20 38 4E          L_004DAC    jsr  L_004E38        ; A=$0000 X=$0003 Y=$0002 ; [SP-139]
004DAF  4C B5 4D                      jmp  L_004DB5        ; A=$0000 X=$0003 Y=$0002 ; [SP-139]
004DB2  20 E0 4E          L_004DB2    jsr  L_004EE0        ; A=$0000 X=$0003 Y=$0002 ; [SP-141]
004DB5  CE BB 4D          L_004DB5    dec  $4DBB           ; A=$0000 X=$0003 Y=$0002 ; [SP-141]
004DB8  10 D2                         bpl  L_004D8C        ; A=$0000 X=$0003 Y=$0002 ; [SP-141]
; === End of while loop (counter: $00) ===

004DBA  60                            rts                  ; A=$0000 X=$0003 Y=$0002 ; [SP-139]

; --- Data region ---
004DBB  00000003                HEX     00000003 06090001 02

; === while loop starts here (counter: $00 '', range: 0..20037, step: 19908, iters: 90851443232354) [nest:49] [inner] ===

; FUNC $004DC4: register -> A:X []
; Liveness: returns(A,X,Y) [8 dead stores]
; --- End data region (9 bytes) ---

004DC4  AA                L_004DC4    tax                  ; A=$0000 X=$0000 Y=$0002 ; [SP-151]
004DC5  BD BD 4D                      lda  $4DBD,X         ; A=$0000 X=$0000 Y=$0002 ; [SP-151]
004DC8  20 E0 4A                      jsr  L_004AE0        ; Call $004AE0(A)
; === End of while loop (counter: $00) ===

004DCB  A9 14                         lda  #$14            ; A=$0014 X=$0000 Y=$0002 ; [SP-153]
004DCD  A0 0A                         ldy  #$0A            ; A=$0014 X=$0000 Y=$000A ; [SP-153]
004DCF  20 35 4F                      jsr  L_004F35        ; A=$0014 X=$0000 Y=$000A ; [SP-155]
004DD2  AE BB 4D                      ldx  $4DBB           ; A=$0014 X=$0000 Y=$000A ; [SP-155]
004DD5  A9 00                         lda  #$00            ; A=$0000 X=$0000 Y=$000A ; [SP-155]
004DD7  9D 58 5D                      sta  $5D58,X         ; A=$0000 X=$0000 Y=$000A ; [SP-155]
004DDA  20 41 44                      jsr  L_004441        ; A=$0000 X=$0000 Y=$000A ; [SP-157]
; === End of while loop (counter: Y) ===

004DDD  20 E4 56                      jsr  L_0056E4        ; A=$0000 X=$0000 Y=$000A ; [SP-159]
004DE0  4C 4F 5B                      jmp  L_005B4F        ; A=$0000 X=$0000 Y=$000A ; [SP-159]

; FUNC $004DE3: register -> A:X []
; Proto: uint32_t func_004DE3(uint16_t param_X, uint16_t param_Y);
; Liveness: params(X,Y) returns(A,X,Y) [6 dead stores]
004DE3  AD 64 5D          L_004DE3    lda  $5D64           ; A=[$5D64] X=$0000 Y=$000A ; [SP-159]
004DE6  C9 0A                         cmp  #$0A            ; A=[$5D64] X=$0000 Y=$000A ; [SP-159]
004DE8  B0 4D                         bcs  L_004E37        ; A=[$5D64] X=$0000 Y=$000A ; [SP-159]
004DEA  20 0E 56                      jsr  L_00560E        ; A=[$5D64] X=$0000 Y=$000A ; [SP-161]
004DED  F0 48                         beq  L_004E37        ; A=[$5D64] X=$0000 Y=$000A ; [SP-161]
004DEF  8E BC 4D                      stx  $4DBC           ; A=[$5D64] X=$0000 Y=$000A ; [SP-161]
004DF2  20 C4 4D                      jsr  L_004DC4        ; A=[$5D64] X=$0000 Y=$000A ; [SP-163]
; === End of while loop ===

004DF5  AE BC 4D                      ldx  $4DBC           ; A=[$5D64] X=$0000 Y=$000A ; [SP-163]
004DF8  AD EC 53                      lda  $53EC           ; A=[$53EC] X=$0000 Y=$000A ; [SP-163]
004DFB  18                            clc                  ; A=[$53EC] X=$0000 Y=$000A ; [SP-163]
004DFC  7D E4 53                      adc  $53E4,X         ; A=[$53EC] X=$0000 Y=$000A ; [SP-163]
004DFF  8D FC 53                      sta  $53FC           ; A=[$53EC] X=$0000 Y=$000A ; [SP-163]
004E02  85 19                         sta  $19             ; A=[$53EC] X=$0000 Y=$000A ; [SP-163]
004E04  A9 01                         lda  #$01            ; A=$0001 X=$0000 Y=$000A ; [SP-163]
004E06  85 04                         sta  $04             ; A=$0001 X=$0000 Y=$000A ; [SP-163]
004E08  BD B8 53                      lda  $53B8,X         ; A=$0001 X=$0000 Y=$000A ; [SP-163]
004E0B  AA                            tax                  ; A=$0001 X=$0001 Y=$000A ; [SP-163]
004E0C  BD C8 53                      lda  $53C8,X         ; -> $53C9 ; A=$0001 X=$0001 Y=$000A ; [SP-163]
004E0F  20 A1 52                      jsr  L_0052A1        ; A=$0001 X=$0001 Y=$000A ; [SP-165]
004E12  AE BC 4D                      ldx  $4DBC           ; A=$0001 X=$0001 Y=$000A ; [SP-165]
004E15  FE B8 53                      inc  $53B8,X         ; -> $53B9 ; A=$0001 X=$0001 Y=$000A ; [SP-165]
004E18  BD B8 53                      lda  $53B8,X         ; -> $53B9 ; A=$0001 X=$0001 Y=$000A ; [SP-165]
004E1B  C9 07                         cmp  #$07            ; A=$0001 X=$0001 Y=$000A ; [SP-165]
004E1D  90 05                         bcc  L_004E24        ; A=$0001 X=$0001 Y=$000A ; [SP-165]
004E1F  A9 01                         lda  #$01            ; A=$0001 X=$0001 Y=$000A ; [SP-165]
004E21  9D B8 53                      sta  $53B8,X         ; -> $53B9 ; A=$0001 X=$0001 Y=$000A ; [SP-165]
004E24  AD FC 53          L_004E24    lda  $53FC           ; A=[$53FC] X=$0001 Y=$000A ; [SP-165]
004E27  85 19                         sta  $19             ; A=[$53FC] X=$0001 Y=$000A ; [SP-165]
004E29  A9 01                         lda  #$01            ; A=$0001 X=$0001 Y=$000A ; [SP-165]
004E2B  85 04                         sta  $04             ; A=$0001 X=$0001 Y=$000A ; [SP-165]
004E2D  BD B8 53                      lda  $53B8,X         ; -> $53B9 ; A=$0001 X=$0001 Y=$000A ; [SP-165]
004E30  AA                            tax                  ; A=$0001 X=$0001 Y=$000A ; [SP-165]
004E31  BD C8 53                      lda  $53C8,X         ; -> $53C9 ; A=$0001 X=$0001 Y=$000A ; [SP-165]
004E34  20 7F 52                      jsr  L_00527F        ; A=$0001 X=$0001 Y=$000A ; [OPT] TAIL_CALL: Tail call: JSR/JSL at $004E34 followed by RTS ; [SP-167]
004E37  60                L_004E37    rts                  ; A=$0001 X=$0001 Y=$000A ; [SP-165]

; FUNC $004E38: register -> A:X []
; Proto: uint32_t func_004E38(uint16_t param_X, uint16_t param_Y);
; Liveness: params(X,Y) returns(A,X,Y) [6 dead stores]
004E38  AD 61 5D          L_004E38    lda  $5D61           ; A=[$5D61] X=$0001 Y=$000A ; [SP-165]
004E3B  F0 4D                         beq  L_004E8A        ; A=[$5D61] X=$0001 Y=$000A ; [SP-165]
004E3D  20 0E 56                      jsr  L_00560E        ; A=[$5D61] X=$0001 Y=$000A ; [SP-167]
004E40  8E BC 4D                      stx  $4DBC           ; A=[$5D61] X=$0001 Y=$000A ; [SP-167]
004E43  F0 45                         beq  L_004E8A        ; A=[$5D61] X=$0001 Y=$000A ; [SP-167]
004E45  20 C4 4D                      jsr  L_004DC4        ; A=[$5D61] X=$0001 Y=$000A ; [SP-169]
; === End of while loop (counter: Y) ===

004E48  AE BC 4D                      ldx  $4DBC           ; A=[$5D61] X=$0001 Y=$000A ; [SP-169]
004E4B  AD F1 53                      lda  $53F1           ; A=[$53F1] X=$0001 Y=$000A ; [SP-169]
004E4E  18                            clc                  ; A=[$53F1] X=$0001 Y=$000A ; [SP-169]
004E4F  7D E4 53                      adc  $53E4,X         ; -> $53E5 ; A=[$53F1] X=$0001 Y=$000A ; [SP-169]
004E52  8D FA 53                      sta  $53FA           ; A=[$53F1] X=$0001 Y=$000A ; [SP-169]
004E55  85 04                         sta  $04             ; A=[$53F1] X=$0001 Y=$000A ; [SP-169]
004E57  A9 C4                         lda  #$C4            ; A=$00C4 X=$0001 Y=$000A ; [SP-169]
004E59  85 19                         sta  $19             ; A=$00C4 X=$0001 Y=$000A ; [SP-169]
004E5B  BD BC 53                      lda  $53BC,X         ; -> $53BD ; A=$00C4 X=$0001 Y=$000A ; [SP-169]
004E5E  AA                            tax                  ; A=$00C4 X=$00C4 Y=$000A ; [SP-169]
004E5F  BD DD 53                      lda  $53DD,X         ; -> $54A1 ; A=$00C4 X=$00C4 Y=$000A ; [SP-169]
004E62  20 A1 52                      jsr  L_0052A1        ; A=$00C4 X=$00C4 Y=$000A ; [SP-171]
004E65  AE BC 4D                      ldx  $4DBC           ; A=$00C4 X=$00C4 Y=$000A ; [SP-171]
004E68  FE BC 53                      inc  $53BC,X         ; -> $5480 ; A=$00C4 X=$00C4 Y=$000A ; [SP-171]
004E6B  BD BC 53                      lda  $53BC,X         ; -> $5480 ; A=$00C4 X=$00C4 Y=$000A ; [SP-171]
004E6E  C9 07                         cmp  #$07            ; A=$00C4 X=$00C4 Y=$000A ; [SP-171]
004E70  90 05                         bcc  L_004E77        ; A=$00C4 X=$00C4 Y=$000A ; [SP-171]
004E72  A9 01                         lda  #$01            ; A=$0001 X=$00C4 Y=$000A ; [SP-171]
004E74  9D BC 53                      sta  $53BC,X         ; -> $5480 ; A=$0001 X=$00C4 Y=$000A ; [SP-171]
004E77  AD FA 53          L_004E77    lda  $53FA           ; A=[$53FA] X=$00C4 Y=$000A ; [SP-171]
004E7A  85 04                         sta  $04             ; A=[$53FA] X=$00C4 Y=$000A ; [SP-171]
004E7C  A9 C4                         lda  #$C4            ; A=$00C4 X=$00C4 Y=$000A ; [SP-171]
004E7E  85 19                         sta  $19             ; A=$00C4 X=$00C4 Y=$000A ; [SP-171]
004E80  BD BC 53                      lda  $53BC,X         ; -> $5480 ; A=$00C4 X=$00C4 Y=$000A ; [SP-171]
004E83  AA                            tax                  ; A=$00C4 X=$00C4 Y=$000A ; [SP-171]
004E84  BD DD 53                      lda  $53DD,X         ; -> $54A1 ; A=$00C4 X=$00C4 Y=$000A ; [SP-171]
004E87  20 7F 52                      jsr  L_00527F        ; A=$00C4 X=$00C4 Y=$000A ; [OPT] TAIL_CALL: Tail call: JSR/JSL at $004E87 followed by RTS ; [SP-173]
004E8A  60                L_004E8A    rts                  ; A=$00C4 X=$00C4 Y=$000A ; [SP-171]

; FUNC $004E8B: register -> A:X []
; Proto: uint32_t func_004E8B(uint16_t param_X, uint16_t param_Y);
; Liveness: params(X,Y) returns(A,X,Y) [6 dead stores]
004E8B  AD 66 5D          L_004E8B    lda  $5D66           ; A=[$5D66] X=$00C4 Y=$000A ; [SP-171]
004E8E  C9 B4                         cmp  #$B4            ; A=[$5D66] X=$00C4 Y=$000A ; [SP-171]
004E90  90 4D                         bcc  L_004EDF        ; A=[$5D66] X=$00C4 Y=$000A ; [SP-171]
004E92  20 0E 56                      jsr  L_00560E        ; A=[$5D66] X=$00C4 Y=$000A ; [SP-173]
004E95  F0 48                         beq  L_004EDF        ; A=[$5D66] X=$00C4 Y=$000A ; [SP-173]
004E97  8E BC 4D                      stx  $4DBC           ; A=[$5D66] X=$00C4 Y=$000A ; [SP-173]
004E9A  20 C4 4D                      jsr  L_004DC4        ; A=[$5D66] X=$00C4 Y=$000A ; [SP-175]
; === End of while loop (counter: Y) ===

004E9D  AE BC 4D                      ldx  $4DBC           ; A=[$5D66] X=$00C4 Y=$000A ; [SP-175]
004EA0  AD EE 53                      lda  $53EE           ; A=[$53EE] X=$00C4 Y=$000A ; [SP-175]
004EA3  18                            clc                  ; A=[$53EE] X=$00C4 Y=$000A ; [SP-175]
004EA4  7D E4 53                      adc  $53E4,X         ; -> $54A8 ; A=[$53EE] X=$00C4 Y=$000A ; [SP-175]
004EA7  8D FC 53                      sta  $53FC           ; A=[$53EE] X=$00C4 Y=$000A ; [SP-175]
004EAA  85 19                         sta  $19             ; A=[$53EE] X=$00C4 Y=$000A ; [SP-175]
004EAC  A9 B4                         lda  #$B4            ; A=$00B4 X=$00C4 Y=$000A ; [SP-175]
004EAE  85 04                         sta  $04             ; A=$00B4 X=$00C4 Y=$000A ; [SP-175]
004EB0  BD C0 53                      lda  $53C0,X         ; -> $5484 ; A=$00B4 X=$00C4 Y=$000A ; [SP-175]
004EB3  AA                            tax                  ; A=$00B4 X=$00B4 Y=$000A ; [SP-175]
004EB4  BD CF 53                      lda  $53CF,X         ; -> $5483 ; A=$00B4 X=$00B4 Y=$000A ; [SP-175]
004EB7  20 A1 52                      jsr  L_0052A1        ; A=$00B4 X=$00B4 Y=$000A ; [SP-177]
004EBA  AE BC 4D                      ldx  $4DBC           ; A=$00B4 X=$00B4 Y=$000A ; [SP-177]
004EBD  FE C0 53                      inc  $53C0,X         ; -> $5474 ; A=$00B4 X=$00B4 Y=$000A ; [SP-177]
004EC0  BD C0 53                      lda  $53C0,X         ; -> $5474 ; A=$00B4 X=$00B4 Y=$000A ; [SP-177]
004EC3  C9 07                         cmp  #$07            ; A=$00B4 X=$00B4 Y=$000A ; [SP-177]
004EC5  90 05                         bcc  L_004ECC        ; A=$00B4 X=$00B4 Y=$000A ; [SP-177]
004EC7  A9 01                         lda  #$01            ; A=$0001 X=$00B4 Y=$000A ; [SP-177]
004EC9  9D C0 53                      sta  $53C0,X         ; -> $5474 ; A=$0001 X=$00B4 Y=$000A ; [SP-177]
004ECC  AD FC 53          L_004ECC    lda  $53FC           ; A=[$53FC] X=$00B4 Y=$000A ; [SP-177]
004ECF  85 19                         sta  $19             ; A=[$53FC] X=$00B4 Y=$000A ; [SP-177]
004ED1  A9 B4                         lda  #$B4            ; A=$00B4 X=$00B4 Y=$000A ; [SP-177]
004ED3  85 04                         sta  $04             ; A=$00B4 X=$00B4 Y=$000A ; [SP-177]
004ED5  BD C0 53                      lda  $53C0,X         ; -> $5474 ; A=$00B4 X=$00B4 Y=$000A ; [SP-177]
004ED8  AA                            tax                  ; A=$00B4 X=$00B4 Y=$000A ; [SP-177]
004ED9  BD CF 53                      lda  $53CF,X         ; -> $5483 ; A=$00B4 X=$00B4 Y=$000A ; [SP-177]
004EDC  20 7F 52                      jsr  L_00527F        ; A=$00B4 X=$00B4 Y=$000A ; [OPT] TAIL_CALL: Tail call: JSR/JSL at $004EDC followed by RTS ; [SP-179]
004EDF  60                L_004EDF    rts                  ; A=$00B4 X=$00B4 Y=$000A ; [SP-177]

; FUNC $004EE0: register -> A:X []
; Proto: uint32_t func_004EE0(uint16_t param_X, uint16_t param_Y);
; Liveness: params(X,Y) returns(A,X,Y) [6 dead stores]
004EE0  AD 5F 5D          L_004EE0    lda  $5D5F           ; A=[$5D5F] X=$00B4 Y=$000A ; [SP-177]
004EE3  C9 46                         cmp  #$46            ; A=[$5D5F] X=$00B4 Y=$000A ; [SP-177]
004EE5  B0 4D                         bcs  L_004F34        ; A=[$5D5F] X=$00B4 Y=$000A ; [SP-177]
004EE7  20 0E 56                      jsr  L_00560E        ; A=[$5D5F] X=$00B4 Y=$000A ; [SP-179]
004EEA  F0 48                         beq  L_004F34        ; A=[$5D5F] X=$00B4 Y=$000A ; [SP-179]
004EEC  8E BC 4D                      stx  $4DBC           ; A=[$5D5F] X=$00B4 Y=$000A ; [SP-179]
004EEF  20 C4 4D                      jsr  L_004DC4        ; A=[$5D5F] X=$00B4 Y=$000A ; [SP-181]
; === End of while loop (counter: $00) ===

004EF2  AE BC 4D                      ldx  $4DBC           ; A=[$5D5F] X=$00B4 Y=$000A ; [SP-181]
004EF5  AD F3 53                      lda  $53F3           ; A=[$53F3] X=$00B4 Y=$000A ; [SP-181]
004EF8  18                            clc                  ; A=[$53F3] X=$00B4 Y=$000A ; [SP-181]
004EF9  7D E4 53                      adc  $53E4,X         ; -> $5498 ; A=[$53F3] X=$00B4 Y=$000A ; [SP-181]
004EFC  8D FA 53                      sta  $53FA           ; A=[$53F3] X=$00B4 Y=$000A ; [SP-181]
004EFF  85 04                         sta  $04             ; A=[$53F3] X=$00B4 Y=$000A ; [SP-181]
004F01  A9 00                         lda  #$00            ; A=$0000 X=$00B4 Y=$000A ; [SP-181]
004F03  85 19                         sta  $19             ; A=$0000 X=$00B4 Y=$000A ; [SP-181]
004F05  BD C4 53                      lda  $53C4,X         ; -> $5478 ; A=$0000 X=$00B4 Y=$000A ; [SP-181]
004F08  AA                            tax                  ; A=$0000 X=$0000 Y=$000A ; [SP-181]
004F09  BD D6 53                      lda  $53D6,X         ; A=$0000 X=$0000 Y=$000A ; [SP-181]
004F0C  20 A1 52                      jsr  L_0052A1        ; A=$0000 X=$0000 Y=$000A ; [SP-183]
004F0F  AE BC 4D                      ldx  $4DBC           ; A=$0000 X=$0000 Y=$000A ; [SP-183]
004F12  FE C4 53                      inc  $53C4,X         ; A=$0000 X=$0000 Y=$000A ; [SP-183]
004F15  BD C4 53                      lda  $53C4,X         ; A=$0000 X=$0000 Y=$000A ; [SP-183]
004F18  C9 07                         cmp  #$07            ; A=$0000 X=$0000 Y=$000A ; [SP-183]
004F1A  90 05                         bcc  L_004F21        ; A=$0000 X=$0000 Y=$000A ; [SP-183]
004F1C  A9 01                         lda  #$01            ; A=$0001 X=$0000 Y=$000A ; [SP-183]
004F1E  9D C4 53                      sta  $53C4,X         ; A=$0001 X=$0000 Y=$000A ; [SP-183]
004F21  AD FA 53          L_004F21    lda  $53FA           ; A=[$53FA] X=$0000 Y=$000A ; [SP-183]
004F24  85 04                         sta  $04             ; A=[$53FA] X=$0000 Y=$000A ; [SP-183]
004F26  A9 00                         lda  #$00            ; A=$0000 X=$0000 Y=$000A ; [SP-183]
004F28  85 19                         sta  $19             ; A=$0000 X=$0000 Y=$000A ; [SP-183]
004F2A  BD C4 53                      lda  $53C4,X         ; A=$0000 X=$0000 Y=$000A ; [SP-183]
004F2D  AA                            tax                  ; A=$0000 X=$0000 Y=$000A ; [SP-183]
004F2E  BD D6 53                      lda  $53D6,X         ; A=$0000 X=$0000 Y=$000A ; [SP-183]
004F31  20 7F 52                      jsr  L_00527F        ; A=$0000 X=$0000 Y=$000A ; [OPT] TAIL_CALL: Tail call: JSR/JSL at $004F31 followed by RTS ; [SP-185]
004F34  60                L_004F34    rts                  ; A=$0000 X=$0000 Y=$000A ; [SP-183]

; === while loop starts here (counter: $00 '', range: 0..18882, step: 17995, iters: 81565723937209) [nest:49] [inner] ===

; FUNC $004F35: register -> A:X [L]
; Proto: uint32_t func_004F35(uint16_t param_A, uint16_t param_Y);
; Liveness: params(A,Y) returns(A,X,Y) [2 dead stores]
004F35  85 38             L_004F35    sta  $38             ; A=$0000 X=$0000 Y=$000A ; [SP-183]
004F37  84 39                         sty  $39             ; A=$0000 X=$0000 Y=$000A ; [SP-183]
004F39  A2 30                         ldx  #$30            ; A=$0000 X=$0030 Y=$000A ; [SP-183]

; === loop starts here (counter: X '', range: 48..18876, iters: 48) [nest:50] [inner] ===
004F3B  A4 38             L_004F3B    ldy  $38             ; A=$0000 X=$0030 Y=$000A ; [SP-183]

; === loop starts here (counter: Y, range: 0..19060, iters: 81892141451897) [nest:51] [inner] ===
004F3D  EA                L_004F3D    nop                  ; A=$0000 X=$0030 Y=$000A ; [SP-183]
004F3E  EA                            nop                  ; A=$0000 X=$0030 Y=$000A ; [SP-183]
004F3F  EA                            nop                  ; A=$0000 X=$0030 Y=$000A ; [SP-183]
004F40  88                            dey                  ; A=$0000 X=$0030 Y=$0009 ; [SP-183]
004F41  D0 FA                         bne  L_004F3D        ; A=$0000 X=$0030 Y=$0009 ; [SP-183]
; === End of loop (counter: Y) ===

004F43  8D 30 C0                      sta  $C030           ; SPKR - Speaker toggle {Speaker} <speaker_toggle>
004F46  CA                            dex                  ; A=$0000 X=$002F Y=$0009 ; [SP-183]
004F47  D0 F2                         bne  L_004F3B        ; A=$0000 X=$002F Y=$0009 ; [SP-183]
; === End of loop (counter: X) ===

004F49  A2 30                         ldx  #$30            ; A=$0000 X=$0030 Y=$0009 ; [OPT] REDUNDANT_LOAD: Redundant LDX: same value loaded at $004F39 ; [SP-183]

; === loop starts here (counter: X, range: 48..17812, iters: 48) [nest:50] [inner] ===
004F4B  A4 39             L_004F4B    ldy  $39             ; A=$0000 X=$0030 Y=$0009 ; [SP-183]

; === loop starts here (counter: Y '', range: 0..17855, iters: 76570676970952) [nest:51] [inner] ===
004F4D  EA                L_004F4D    nop                  ; A=$0000 X=$0030 Y=$0009 ; [SP-183]
004F4E  EA                            nop                  ; A=$0000 X=$0030 Y=$0009 ; [SP-183]
004F4F  EA                            nop                  ; A=$0000 X=$0030 Y=$0009 ; [SP-183]
004F50  88                            dey                  ; A=$0000 X=$0030 Y=$0008 ; [SP-183]
004F51  D0 FA                         bne  L_004F4D        ; A=$0000 X=$0030 Y=$0008 ; [SP-183]
; === End of loop (counter: Y) ===

004F53  8D 30 C0                      sta  $C030           ; SPKR - Speaker toggle {Speaker} <speaker_toggle>
004F56  EA                            nop                  ; A=$0000 X=$0030 Y=$0008 ; [SP-183]
004F57  CA                            dex                  ; A=$0000 X=$002F Y=$0008 ; [SP-183]
004F58  D0 F1                         bne  L_004F4B        ; A=$0000 X=$002F Y=$0008 ; [SP-183]
; === End of loop (counter: X) ===

004F5A  60                            rts                  ; A=$0000 X=$002F Y=$0008 ; [SP-181]

; === while loop starts here (counter: $00 '', range: 0..16664, step: 16632, iters: 71524090396922) [nest:31] [inner] ===

; FUNC $004F5B: register -> A:X [IJ]
; Proto: uint32_t func_004F5B(void);
; Liveness: returns(A,X,Y) [10 dead stores]
004F5B  A2 03             L_004F5B    ldx  #$03            ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F5D  86 12                         stx  $12             ; A=$0000 X=$0003 Y=$0008 ; [SP-181]

; === while loop starts here (counter: $00, range: 0..16642, step: 16644, iters: 71330816868637) [nest:48] ===
004F5F  A6 12             L_004F5F    ldx  $12             ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F61  BD 58 5D                      lda  $5D58,X         ; -> $5D5B ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F64  D0 03                         bne  L_004F69        ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F66  4C F5 4F                      jmp  L_004FF5        ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F69  E0 03             L_004F69    cpx  #$03            ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F6B  F0 26                         beq  L_004F93        ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F6D  E0 02                         cpx  #$02            ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F6F  F0 18                         beq  L_004F89        ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F71  E0 01                         cpx  #$01            ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F73  F0 0A                         beq  L_004F7F        ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F75  BD 64 5D                      lda  $5D64,X         ; -> $5D67 ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F78  C9 26                         cmp  #$26            ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F7A  90 1E                         bcc  L_004F9A        ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F7C  4C F5 4F                      jmp  L_004FF5        ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F7F  BD 5C 5D          L_004F7F    lda  $5D5C,X         ; -> $5D5F ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F82  C9 E3                         cmp  #$E3            ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F84  B0 14                         bcs  L_004F9A        ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F86  4C F5 4F                      jmp  L_004FF5        ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F89  BD 64 5D          L_004F89    lda  $5D64,X         ; -> $5D67 ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F8C  C9 98                         cmp  #$98            ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F8E  B0 0A                         bcs  L_004F9A        ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F90  4C F5 4F                      jmp  L_004FF5        ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F93  BD 5C 5D          L_004F93    lda  $5D5C,X         ; -> $5D5F ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F96  C9 71                         cmp  #$71            ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F98  B0 5B                         bcs  L_004FF5        ; A=$0000 X=$0003 Y=$0008 ; [SP-181]
004F9A  A0 03             L_004F9A    ldy  #$03            ; A=$0000 X=$0003 Y=$0003 ; [SP-181]
004F9C  8C 01 50                      sty  $5001           ; A=$0000 X=$0003 Y=$0003 ; [SP-181]

; === while loop starts here (counter: $00, range: 0..16618, step: 16620, iters: 81501299427866) [nest:49] [inner] ===
004F9F  AC 01 50          L_004F9F    ldy  $5001           ; A=$0000 X=$0003 Y=$0003 ; [SP-181]
004FA2  B9 12 52                      lda  $5212,Y         ; -> $5215 ; A=$0000 X=$0003 Y=$0003 ; [SP-181]
004FA5  F0 49                         beq  L_004FF0        ; A=$0000 X=$0003 Y=$0003 ; [SP-181]
004FA7  B9 0E 52                      lda  $520E,Y         ; -> $5211 ; A=$0000 X=$0003 Y=$0003 ; [SP-181]
004FAA  38                            sec                  ; A=$0000 X=$0003 Y=$0003 ; [SP-181]
004FAB  A6 12                         ldx  $12             ; A=$0000 X=$0003 Y=$0003 ; [SP-181]
004FAD  FD FD 4F                      sbc  $4FFD,X         ; -> $5000 ; A=$0000 X=$0003 Y=$0003 ; [SP-181]
004FB0  C9 05                         cmp  #$05            ; A=$0000 X=$0003 Y=$0003 ; [SP-181]
004FB2  B0 3C                         bcs  L_004FF0        ; A=$0000 X=$0003 Y=$0003 ; [SP-181]
004FB4  A9 08                         lda  #$08            ; A=$0008 X=$0003 Y=$0003 ; [SP-181]
004FB6  A0 10                         ldy  #$10            ; A=$0008 X=$0003 Y=$0010 ; [SP-181]
004FB8  20 35 4F                      jsr  L_004F35        ; A=$0008 X=$0003 Y=$0010 ; [SP-183]
; === End of while loop (counter: $00) ===

004FBB  AE 01 50                      ldx  $5001           ; A=$0008 X=$0003 Y=$0010 ; [SP-183]
004FBE  BD 12 52                      lda  $5212,X         ; -> $5215 ; A=$0008 X=$0003 Y=$0010 ; [SP-183]
004FC1  20 E0 4A                      jsr  L_004AE0        ; A=$0008 X=$0003 Y=$0010 ; [SP-185]
; === End of while loop (counter: $00) ===

004FC4  20 E4 56                      jsr  L_0056E4        ; Call $0056E4(A, X, Y)
004FC7  A6 12                         ldx  $12             ; A=$0008 X=$0003 Y=$0010 ; [SP-187]
004FC9  A9 00                         lda  #$00            ; A=$0000 X=$0003 Y=$0010 ; [SP-187]
004FCB  9D 58 5D                      sta  $5D58,X         ; -> $5D5B ; A=$0000 X=$0003 Y=$0010 ; [SP-187]
004FCE  20 41 44                      jsr  L_004441        ; A=$0000 X=$0003 Y=$0010 ; [SP-189]
; === End of while loop (counter: $00) ===

004FD1  20 4F 5B                      jsr  L_005B4F        ; A=$0000 X=$0003 Y=$0010 ; [SP-191]
004FD4  AE 01 50                      ldx  $5001           ; A=$0000 X=$0003 Y=$0010 ; [SP-191]
004FD7  DE 21 52                      dec  $5221,X         ; -> $5224 ; A=$0000 X=$0003 Y=$0010 ; [SP-191]
004FDA  D0 14                         bne  L_004FF0        ; A=$0000 X=$0003 Y=$0010 ; [SP-191]
004FDC  20 C9 52                      jsr  L_0052C9        ; A=$0000 X=$0003 Y=$0010 ; [SP-193]
004FDF  AE 01 50                      ldx  $5001           ; A=$0000 X=$0003 Y=$0010 ; [SP-193]
004FE2  DE 12 52                      dec  $5212,X         ; -> $5215 ; A=$0000 X=$0003 Y=$0010 ; [SP-193]
004FE5  BD 12 52                      lda  $5212,X         ; -> $5215 ; A=$0000 X=$0003 Y=$0010 ; [SP-193]
004FE8  9D 21 52                      sta  $5221,X         ; -> $5224 ; A=$0000 X=$0003 Y=$0010 ; [SP-193]
004FEB  F0 03                         beq  L_004FF0        ; A=$0000 X=$0003 Y=$0010 ; [SP-193]
004FED  20 C3 52                      jsr  L_0052C3        ; A=$0000 X=$0003 Y=$0010 ; [SP-195]
004FF0  CE 01 50          L_004FF0    dec  $5001           ; A=$0000 X=$0003 Y=$0010 ; [SP-195]
004FF3  10 AA                         bpl  L_004F9F        ; A=$0000 X=$0003 Y=$0010 ; [SP-195]
; === End of while loop (counter: $00) ===

004FF5  C6 12             L_004FF5    dec  $12             ; A=$0000 X=$0003 Y=$0010 ; [SP-195]
004FF7  30 03                         bmi  L_004FFC        ; A=$0000 X=$0003 Y=$0010 ; [SP-195]
004FF9  4C 5F 4F                      jmp  L_004F5F        ; A=$0000 X=$0003 Y=$0010 ; [SP-195]
; === End of while loop (counter: $00) ===

004FFC  60                L_004FFC    rts                  ; A=$0000 X=$0003 Y=$0010 ; [SP-193]

; --- Data region ---
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
00520D  60                      HEX     60
; --- End data region (529 bytes) ---

00520E  81 A0             L_00520E    sta  ($A0,X)         ; A=$0000 X=$0003 Y=$0010 ; [SP-194]
005210  A5 A0                         lda  $A0             ; A=[$00A0] X=$0003 Y=$0010 ; [SP-194]
005212  A9 A0                         lda  #$A0            ; A=$00A0 X=$0003 Y=$0010 ; [OPT] REDUNDANT_LOAD: Redundant LDA: same value loaded at $005210 ; [SP-194]
005214  87 CD                         sta  [$CD]           ; A=$00A0 X=$0003 Y=$0010 ; [SP-194]
005216  93 A0                         sta  ($A0,S),Y       ; A=$00A0 X=$0003 Y=$0010 ; [SP-194]
005218  95 D4                         sta  $D4,X           ; -> $00D7 ; A=$00A0 X=$0003 Y=$0010 ; [SP-194]
00521A  00 2E                         brk  #$2E            ; A=$00A0 X=$0003 Y=$0010 ; [SP-197]

; --- Data region ---
00521C  583C434A                HEX     583C434A 51CFA0FE
; --- End data region (8 bytes) ---

005224  AE 00 00          L_005224    ldx  !$0000          ; A=$00A0 X=$0003 Y=$0010 ; [SP-197]

; === while loop starts here (counter: $00, range: 0..21039, step: 21041, iters: 102263171341567) [nest:3] [inner] ===

; FUNC $005227: register -> A:X []
; Proto: uint32_t func_005227(uint16_t param_Y);
; Liveness: params(Y) returns(A,X,Y)
005227  A2 03             L_005227    ldx  #$03            ; A=$00A0 X=$0003 Y=$0010 ; [SP-197]

; === while loop starts here (counter: $00, range: 0..19890, step: 19893, iters: 86754044432101) [nest:52] [inner] ===
005229  BD 12 52          L_005229    lda  $5212,X         ; -> $5215 ; A=$00A0 X=$0003 Y=$0010 ; [SP-197]
00522C  F0 04                         beq  L_005232        ; A=$00A0 X=$0003 Y=$0010 ; [SP-197]
00522E  CA                            dex                  ; A=$00A0 X=$0002 Y=$0010 ; [SP-197]
00522F  10 F8                         bpl  L_005229        ; A=$00A0 X=$0002 Y=$0010 ; [SP-197]
; === End of while loop (counter: $00) ===

005231  60                            rts                  ; A=$00A0 X=$0002 Y=$0010 ; [SP-195]
005232  8E 25 52          L_005232    stx  $5225           ; A=$00A0 X=$0002 Y=$0010 ; [SP-195]
005235  A5 3A                         lda  $3A             ; A=[$003A] X=$0002 Y=$0010 ; [SP-195]
005237  C9 03                         cmp  #$03            ; A=[$003A] X=$0002 Y=$0010 ; [SP-195]
005239  F0 09                         beq  L_005244        ; A=[$003A] X=$0002 Y=$0010 ; [SP-195]
00523B  C9 02                         cmp  #$02            ; A=[$003A] X=$0002 Y=$0010 ; [SP-195]
00523D  D0 0A                         bne  L_005249        ; A=[$003A] X=$0002 Y=$0010 ; [SP-195]
00523F  A9 04                         lda  #$04            ; A=$0004 X=$0002 Y=$0010 ; [SP-195]
005241  4C 4B 52                      jmp  L_00524B        ; A=$0004 X=$0002 Y=$0010 ; [SP-195]
005244  A9 02             L_005244    lda  #$02            ; A=$0002 X=$0002 Y=$0010 ; [SP-195]
005246  4C 4B 52                      jmp  L_00524B        ; A=$0002 X=$0002 Y=$0010 ; [SP-195]
005249  A9 06             L_005249    lda  #$06            ; A=$0006 X=$0002 Y=$0010 ; [SP-195]
00524B  9D 12 52          L_00524B    sta  $5212,X         ; -> $5214 ; A=$0006 X=$0002 Y=$0010 ; [SP-195]
00524E  9D 21 52                      sta  $5221,X         ; -> $5223 ; A=$0006 X=$0002 Y=$0010 ; [SP-195]

; === while loop starts here (counter: $00, range: 0..23815, step: 23816, iters: 101889509186728) [nest:52] [inner] ===
005251  20 03 04          L_005251    jsr  $0403           ; A=$0006 X=$0002 Y=$0010 ; [SP-197]
005254  C9 F0                         cmp  #$F0            ; A=$0006 X=$0002 Y=$0010 ; [SP-197]
005256  B0 F9                         bcs  L_005251        ; A=$0006 X=$0002 Y=$0010 ; [SP-197]
; === End of while loop (counter: $00) ===

005258  8D 26 52                      sta  $5226           ; A=$0006 X=$0002 Y=$0010 ; [SP-197]
00525B  A0 03                         ldy  #$03            ; A=$0006 X=$0002 Y=$0003 ; [SP-197]

; === while loop starts here (counter: $00, range: 0..17604, step: 17607, iters: 75647259002059) [nest:52] [inner] ===
00525D  B9 12 52          L_00525D    lda  $5212,Y         ; -> $5215 ; A=$0006 X=$0002 Y=$0003 ; [SP-197]
005260  F0 0F                         beq  L_005271        ; A=$0006 X=$0002 Y=$0003 ; [SP-197]
005262  AD 26 52                      lda  $5226           ; A=[$5226] X=$0002 Y=$0003 ; [SP-197]
005265  38                            sec                  ; A=[$5226] X=$0002 Y=$0003 ; [SP-197]
005266  F9 0E 52                      sbc  $520E,Y         ; -> $5211 ; A=[$5226] X=$0002 Y=$0003 ; [SP-197]
005269  C9 0A                         cmp  #$0A            ; A=[$5226] X=$0002 Y=$0003 ; [SP-197]
00526B  90 E4                         bcc  L_005251        ; A=[$5226] X=$0002 Y=$0003 ; [SP-197]
; === End of while loop (counter: $00) ===

00526D  C9 F6                         cmp  #$F6            ; A=[$5226] X=$0002 Y=$0003 ; [SP-197]
00526F  B0 E0                         bcs  L_005251        ; A=[$5226] X=$0002 Y=$0003 ; [SP-197]
; === End of while loop (counter: $00) ===

005271  88                L_005271    dey                  ; A=[$5226] X=$0002 Y=$0002 ; [SP-197]
005272  10 E9                         bpl  L_00525D        ; A=[$5226] X=$0002 Y=$0002 ; [SP-197]
; === End of while loop (counter: $00) ===

005274  AD 26 52                      lda  $5226           ; A=[$5226] X=$0002 Y=$0002 ; [OPT] REDUNDANT_LOAD: Redundant LDA: same value loaded at $005262 ; [SP-197]
005277  AE 25 52                      ldx  $5225           ; A=[$5226] X=$0002 Y=$0002 ; [SP-197]
00527A  9D 0E 52                      sta  $520E,X         ; -> $5210 ; A=[$5226] X=$0002 Y=$0002 ; [SP-197]
00527D  60                            rts                  ; A=[$5226] X=$0002 Y=$0002 ; [SP-195]

; --- Data region ---
00527E  00                      HEX     00

; === while loop starts here (counter: $00, range: 0..18973, step: 18976, iters: 80388902897947) [nest:51] [inner] ===

; FUNC $00527F: register -> A:X [L]
; Proto: uint32_t func_00527F(uint16_t param_A);
; Liveness: params(A) returns(A,X,Y) [15 dead stores]
; --- End data region (1 bytes) ---

00527F  8D 7E 52          L_00527F    sta  $527E           ; A=[$5226] X=$0002 Y=$0002 ; [SP-198]
005282  A5 19                         lda  $19             ; A=[$0019] X=$0002 Y=$0002 ; [SP-198]
005284  29 FE                         and  #$FE            ; A=A&$FE X=$0002 Y=$0002 ; [SP-198]
005286  AA                            tax                  ; A=A&$FE X=A Y=$0002 ; [SP-198]
005287  BD AA 47                      lda  $47AA,X         ; A=A&$FE X=A Y=$0002 ; [SP-198]
00528A  18                            clc                  ; A=A&$FE X=A Y=$0002 ; [SP-198]
00528B  69 09                         adc  #$09            ; A=A+$09 X=A Y=$0002 ; [SP-198]
00528D  85 02                         sta  $02             ; A=A+$09 X=A Y=$0002 ; [SP-198]
00528F  A5 19                         lda  $19             ; A=[$0019] X=A Y=$0002 ; [OPT] REDUNDANT_LOAD: Redundant LDA: same value loaded at $005282 ; [SP-198]
005291  4A                            lsr  a               ; A=[$0019] X=A Y=$0002 ; [SP-198]
005292  AA                            tax                  ; A=[$0019] X=[$0019] Y=$0002 ; [SP-198]
005293  BD 92 46                      lda  $4692,X         ; A=[$0019] X=[$0019] Y=$0002 ; [SP-198]
005296  AA                            tax                  ; A=[$0019] X=[$0019] Y=$0002 ; [SP-198]
005297  BD D3 48                      lda  $48D3,X         ; A=[$0019] X=[$0019] Y=$0002 ; [SP-198]
00529A  18                            clc                  ; A=[$0019] X=[$0019] Y=$0002 ; [SP-198]
00529B  6D 7E 52                      adc  $527E           ; A=[$0019] X=[$0019] Y=$0002 ; [SP-198]
00529E  4C 16 04                      jmp  $0416           ; A=[$0019] X=[$0019] Y=$0002 ; [SP-198]

; === while loop starts here (counter: $00, range: 0..17885, step: 17887, iters: 76922864289267) [nest:53] [inner] ===

; FUNC $0052A1: register -> A:X [LI]
; Proto: uint32_t func_0052A1(uint16_t param_A);
; Liveness: params(A) returns(A,X,Y) [9 dead stores]
0052A1  8D 7E 52          L_0052A1    sta  $527E           ; A=[$0019] X=[$0019] Y=$0002 ; [SP-198]
0052A4  A5 19                         lda  $19             ; A=[$0019] X=[$0019] Y=$0002 ; [SP-198]
0052A6  29 FE                         and  #$FE            ; A=A&$FE X=[$0019] Y=$0002 ; [SP-198]
0052A8  AA                            tax                  ; A=A&$FE X=A Y=$0002 ; [SP-198]
0052A9  BD AA 47                      lda  $47AA,X         ; A=A&$FE X=A Y=$0002 ; [SP-198]
0052AC  18                            clc                  ; A=A&$FE X=A Y=$0002 ; [SP-198]
0052AD  69 09                         adc  #$09            ; A=A+$09 X=A Y=$0002 ; [SP-198]
0052AF  85 02                         sta  $02             ; A=A+$09 X=A Y=$0002 ; [SP-198]
0052B1  A5 19                         lda  $19             ; A=[$0019] X=A Y=$0002 ; [OPT] REDUNDANT_LOAD: Redundant LDA: same value loaded at $0052A4 ; [SP-198]
0052B3  4A                            lsr  a               ; A=[$0019] X=A Y=$0002 ; [SP-198]
0052B4  AA                            tax                  ; A=[$0019] X=[$0019] Y=$0002 ; [SP-198]
0052B5  BD 92 46                      lda  $4692,X         ; A=[$0019] X=[$0019] Y=$0002 ; [SP-198]
0052B8  AA                            tax                  ; A=[$0019] X=[$0019] Y=$0002 ; [SP-198]
0052B9  BD D3 48                      lda  $48D3,X         ; A=[$0019] X=[$0019] Y=$0002 ; [SP-198]
0052BC  18                            clc                  ; A=[$0019] X=[$0019] Y=$0002 ; [SP-198]
0052BD  6D 7E 52                      adc  $527E           ; A=[$0019] X=[$0019] Y=$0002 ; [SP-198]
0052C0  4C C0 40                      jmp  L_0040C0        ; A=[$0019] X=[$0019] Y=$0002 ; [SP-198]
; === End of while loop (counter: $00) ===


; === while loop starts here (counter: $00 '', range: 0..18888, step: 18894, iters: 81389630278129) [nest:55] [inner] ===

; FUNC $0052C3: register -> A:X []
; Proto: uint32_t func_0052C3(uint16_t param_X);
; Liveness: params(X) returns(A,X,Y) [2 dead stores]
0052C3  20 CF 52          L_0052C3    jsr  L_0052CF        ; A=[$0019] X=[$0019] Y=$0002 ; [SP-200]
0052C6  4C 7F 52                      jmp  L_00527F        ; A=[$0019] X=[$0019] Y=$0002 ; [SP-200]
; === End of while loop (counter: $00) ===


; === while loop starts here (counter: $00 '', range: 0..17915, step: 17795, iters: 76755360564620) [nest:56] [inner] ===

; FUNC $0052C9: register -> A:X []
; Proto: uint32_t func_0052C9(uint16_t param_X);
; Liveness: params(X) returns(A,X,Y) [2 dead stores]
0052C9  20 CF 52          L_0052C9    jsr  L_0052CF        ; A=[$0019] X=[$0019] Y=$0002 ; [SP-202]
0052CC  4C A1 52                      jmp  L_0052A1        ; A=[$0019] X=[$0019] Y=$0002 ; [SP-202]
; === End of while loop (counter: $00) ===


; FUNC $0052CF: register -> A:X [L]
; Proto: uint32_t func_0052CF(uint16_t param_X);
; Liveness: params(X) returns(A,X,Y) [2 dead stores]
0052CF  BD 0E 52          L_0052CF    lda  $520E,X         ; A=[$0019] X=[$0019] Y=$0002 ; [SP-202]
0052D2  A8                            tay                  ; A=[$0019] X=[$0019] Y=[$0019] ; [SP-202]
0052D3  B9 02 51                      lda  $5102,Y         ; A=[$0019] X=[$0019] Y=[$0019] ; [SP-202]
0052D6  85 04                         sta  $04             ; A=[$0019] X=[$0019] Y=[$0019] ; [SP-202]
0052D8  B9 02 50                      lda  $5002,Y         ; A=[$0019] X=[$0019] Y=[$0019] ; [SP-202]
0052DB  85 19                         sta  $19             ; A=[$0019] X=[$0019] Y=[$0019] ; [SP-202]
0052DD  BD 12 52                      lda  $5212,X         ; A=[$0019] X=[$0019] Y=[$0019] ; [SP-202]
0052E0  A8                            tay                  ; A=[$0019] X=[$0019] Y=[$0019] ; [SP-202]
0052E1  B9 1A 52                      lda  $521A,Y         ; A=[$0019] X=[$0019] Y=[$0019] ; [SP-202]
0052E4  60                            rts                  ; A=[$0019] X=[$0019] Y=[$0019] ; [SP-200]

; === while loop starts here (counter: Y 'j', range: 0..192, iters: 192) [nest:42] ===

; FUNC $0052E5: register -> A:X [L]
; Proto: uint32_t func_0052E5(uint16_t param_Y);
; Liveness: params(Y) returns(A,X,Y)
0052E5  A2 03             L_0052E5    ldx  #$03            ; A=[$0019] X=$0003 Y=[$0019] ; [SP-200]
0052E7  A9 00                         lda  #$00            ; A=$0000 X=$0003 Y=[$0019] ; [SP-200]

; === while loop starts here [nest:59] ===
0052E9  9D 12 52          L_0052E9    sta  $5212,X         ; -> $5215 ; A=$0000 X=$0003 Y=[$0019] ; [SP-200]
0052EC  CA                            dex                  ; A=$0000 X=$0002 Y=[$0019] ; [SP-200]
0052ED  10 FA                         bpl  L_0052E9        ; A=$0000 X=$0002 Y=[$0019] ; [SP-200]
; === End of while loop ===

0052EF  60                            rts                  ; A=$0000 X=$0002 Y=[$0019] ; [SP-198]

; --- Data region ---
0052F0  00E0E0                  HEX     00E0E0

; === while loop starts here (counter: $00 '', range: 0..16723, step: 16718, iters: 71743133729112) [nest:37] [inner] ===

; FUNC $0052F3: register -> A:X []
; Proto: uint32_t func_0052F3(uint16_t param_A, uint16_t param_X, uint16_t param_Y);
; Liveness: params(A,X,Y) returns(A,X,Y)
; --- End data region (3 bytes) ---

0052F3  EE F1 52          L_0052F3    inc  $52F1           ; A=$0000 X=$0002 Y=[$0019] ; [SP-201]
0052F6  F0 01                         beq  L_0052F9        ; A=$0000 X=$0002 Y=[$0019] ; [SP-201]
0052F8  60                            rts                  ; A=$0000 X=$0002 Y=[$0019] ; [SP-199]
0052F9  AD F2 52          L_0052F9    lda  $52F2           ; A=[$52F2] X=$0002 Y=[$0019] ; [SP-199]
0052FC  8D F1 52                      sta  $52F1           ; A=[$52F2] X=$0002 Y=[$0019] ; [SP-199]
0052FF  CE F0 52                      dec  $52F0           ; A=[$52F2] X=$0002 Y=[$0019] ; [SP-199]
005302  10 05                         bpl  L_005309        ; A=[$52F2] X=$0002 Y=[$0019] ; [SP-199]
005304  A9 03                         lda  #$03            ; A=$0003 X=$0002 Y=[$0019] ; [SP-199]
005306  8D F0 52                      sta  $52F0           ; A=$0003 X=$0002 Y=[$0019] ; [SP-199]
005309  AE F0 52          L_005309    ldx  $52F0           ; A=$0003 X=$0002 Y=[$0019] ; [SP-199]
00530C  BD 12 52                      lda  $5212,X         ; -> $5214 ; A=$0003 X=$0002 Y=[$0019] ; [SP-199]
00530F  F0 25                         beq  L_005336        ; A=$0003 X=$0002 Y=[$0019] ; [SP-199]
005311  BD 0E 52                      lda  $520E,X         ; -> $5210 ; A=$0003 X=$0002 Y=[$0019] ; [SP-199]
005314  A2 03                         ldx  #$03            ; A=$0003 X=$0003 Y=[$0019] ; [SP-199]

; === while loop starts here (counter: $00, range: 0..22619, step: 22622, iters: 97173635094622) [nest:60] [inner] ===
005316  DD 37 53          L_005316    cmp  $5337,X         ; -> $533A ; A=$0003 X=$0003 Y=[$0019] ; [SP-199]
005319  D0 09                         bne  L_005324        ; A=$0003 X=$0003 Y=[$0019] ; [SP-199]
00531B  20 3B 53                      jsr  L_00533B        ; A=$0003 X=$0003 Y=[$0019] ; [SP-201]
00531E  AE F0 52                      ldx  $52F0           ; A=$0003 X=$0003 Y=[$0019] ; [SP-201]
005321  4C 2A 53                      jmp  L_00532A        ; A=$0003 X=$0003 Y=[$0019] ; [SP-201]
005324  CA                L_005324    dex                  ; A=$0003 X=$0002 Y=[$0019] ; [SP-201]
005325  10 EF                         bpl  L_005316        ; A=$0003 X=$0002 Y=[$0019] ; [SP-201]
; === End of while loop (counter: $00) ===

005327  AE F0 52                      ldx  $52F0           ; A=$0003 X=$0002 Y=[$0019] ; [SP-201]
00532A  20 C9 52          L_00532A    jsr  L_0052C9        ; A=$0003 X=$0002 Y=[$0019] ; [SP-203]
; === End of while loop (counter: $00) ===

00532D  AE F0 52                      ldx  $52F0           ; A=$0003 X=$0002 Y=[$0019] ; [SP-203]
005330  DE 0E 52                      dec  $520E,X         ; -> $5210 ; A=$0003 X=$0002 Y=[$0019] ; [SP-203]
005333  20 C3 52                      jsr  L_0052C3        ; A=$0003 X=$0002 Y=[$0019] ; [OPT] TAIL_CALL: Tail call: JSR/JSL at $005333 followed by RTS ; [SP-205]
; === End of while loop (counter: $00) ===

005336  60                L_005336    rts                  ; A=$0003 X=$0002 Y=[$0019] ; [SP-203]

; --- Data region ---
005337  96D61656                HEX     96D61656

; FUNC $00533B: register -> A:X []
; Proto: uint32_t func_00533B(uint16_t param_X);
; Liveness: params(X) returns(A,X,Y) [1 dead stores]
; --- End data region (4 bytes) ---

00533B  BD 54 5D          L_00533B    lda  $5D54,X         ; -> $5D56 ; A=$0003 X=$0002 Y=[$0019] ; [SP-203]
00533E  D0 21                         bne  L_005361        ; A=$0003 X=$0002 Y=[$0019] ; [SP-203]
005340  A9 01                         lda  #$01            ; A=$0001 X=$0002 Y=[$0019] ; [SP-203]
005342  9D 54 5D                      sta  $5D54,X         ; -> $5D56 ; A=$0001 X=$0002 Y=[$0019] ; [SP-203]
005345  BD 62 53                      lda  $5362,X         ; -> $5364 ; A=$0001 X=$0002 Y=[$0019] ; [SP-203]
005348  9D 48 5D                      sta  $5D48,X         ; -> $5D4A ; A=$0001 X=$0002 Y=[$0019] ; [SP-203]
00534B  BD 66 53                      lda  $5366,X         ; -> $5368 ; A=$0001 X=$0002 Y=[$0019] ; [SP-203]
00534E  9D 4C 5D                      sta  $5D4C,X         ; -> $5D4E ; A=$0001 X=$0002 Y=[$0019] ; [SP-203]
005351  BD 6A 53                      lda  $536A,X         ; -> $536C ; A=$0001 X=$0002 Y=[$0019] ; [SP-203]
005354  9D 50 5D                      sta  $5D50,X         ; -> $5D52 ; A=$0001 X=$0002 Y=[$0019] ; [SP-203]
005357  A0 10                         ldy  #$10            ; A=$0001 X=$0002 Y=$0010 ; [SP-203]
005359  A9 45                         lda  #$45            ; A=$0045 X=$0002 Y=$0010 ; [SP-203]
00535B  8D 67 5B                      sta  $5B67           ; A=$0045 X=$0002 Y=$0010 ; [SP-203]
00535E  4C 62 5B                      jmp  L_005B62        ; A=$0045 X=$0002 Y=$0010 ; [SP-203]
005361  60                L_005361    rts                  ; A=$0045 X=$0002 Y=$0010 ; [SP-201]

; --- Data region ---
005362  A9E5A96D                HEX     A9E5A96D 00000000 225E9A5E 0000

; === while loop starts here (counter: Y 'j', range: 0..192, iters: 192) [nest:44] ===

; FUNC $005370: register -> A:X [L]
; Proto: uint32_t func_005370(uint16_t param_X, uint16_t param_Y);
; Liveness: params(X,Y) returns(A,X,Y)
; --- End data region (14 bytes) ---

005370  A9 03             L_005370    lda  #$03            ; A=$0003 X=$0002 Y=$0010 ; [SP-213]
005372  8D 6F 53                      sta  $536F           ; A=$0003 X=$0002 Y=$0010 ; [SP-213]
005375  60                            rts                  ; A=$0003 X=$0002 Y=$0010 ; [SP-211]

; === while loop starts here (counter: X 'iter_x') [nest:51] ===

; FUNC $005376: register -> A:X []
; Proto: uint32_t func_005376(uint16_t param_X, uint16_t param_Y);
; Liveness: params(X,Y) returns(A,X,Y)
005376  EE 6F 53          L_005376    inc  $536F           ; A=$0003 X=$0002 Y=$0010 ; [SP-211]
005379  D0 05                         bne  L_005380        ; A=$0003 X=$0002 Y=$0010 ; [SP-211]
00537B  A9 FF                         lda  #$FF            ; A=$00FF X=$0002 Y=$0010 ; [SP-211]
00537D  8D 6F 53                      sta  $536F           ; A=$00FF X=$0002 Y=$0010 ; [SP-211]
005380  60                L_005380    rts                  ; A=$00FF X=$0002 Y=$0010 ; [SP-209]
005381  AD 6F 53          L_005381    lda  $536F           ; A=[$536F] X=$0002 Y=$0010 ; [SP-209]
005384  F0 2D                         beq  L_0053B3        ; A=[$536F] X=$0002 Y=$0010 ; [SP-209]
005386  CE 6F 53                      dec  $536F           ; A=[$536F] X=$0002 Y=$0010 ; [SP-209]
005389  A2 03                         ldx  #$03            ; A=[$536F] X=$0003 Y=$0010 ; [SP-209]
00538B  8E 6E 53                      stx  $536E           ; A=[$536F] X=$0003 Y=$0010 ; [SP-209]

; === while loop starts here [nest:62] ===
00538E  AE 6E 53          L_00538E    ldx  $536E           ; A=[$536F] X=$0003 Y=$0010 ; [SP-209]
005391  BD 58 5D                      lda  $5D58,X         ; -> $5D5B ; A=[$536F] X=$0003 Y=$0010 ; [SP-209]
005394  D0 17                         bne  L_0053AD        ; A=[$536F] X=$0003 Y=$0010 ; [SP-209]
005396  A9 01                         lda  #$01            ; A=$0001 X=$0003 Y=$0010 ; [SP-209]
005398  9D 58 5D                      sta  $5D58,X         ; -> $5D5B ; A=$0001 X=$0003 Y=$0010 ; [SP-209]
00539B  BD 68 5D                      lda  $5D68,X         ; -> $5D6B ; A=$0001 X=$0003 Y=$0010 ; [SP-209]
00539E  9D 5C 5D                      sta  $5D5C,X         ; -> $5D5F ; A=$0001 X=$0003 Y=$0010 ; [SP-209]
0053A1  BD 6C 5D                      lda  $5D6C,X         ; -> $5D6F ; A=$0001 X=$0003 Y=$0010 ; [SP-209]
0053A4  9D 60 5D                      sta  $5D60,X         ; -> $5D63 ; A=$0001 X=$0003 Y=$0010 ; [SP-209]
0053A7  BD 70 5D                      lda  $5D70,X         ; -> $5D73 ; A=$0001 X=$0003 Y=$0010 ; [SP-209]
0053AA  9D 64 5D                      sta  $5D64,X         ; -> $5D67 ; A=$0001 X=$0003 Y=$0010 ; [SP-209]
0053AD  CE 6E 53          L_0053AD    dec  $536E           ; A=$0001 X=$0003 Y=$0010 ; [SP-209]
0053B0  10 DC                         bpl  L_00538E        ; A=$0001 X=$0003 Y=$0010 ; [SP-209]
; === End of while loop ===

0053B2  60                            rts                  ; A=$0001 X=$0003 Y=$0010 ; [SP-207]
0053B3  A9 01             L_0053B3    lda  #$01            ; A=$0001 X=$0003 Y=$0010 ; [SP-207]
0053B5  85 36                         sta  $36             ; A=$0001 X=$0003 Y=$0010 ; [SP-207]
0053B7  60                            rts                  ; A=$0001 X=$0003 Y=$0010 ; [SP-205]

; --- Data region ---
0053B8  C6A5D4A0                HEX     C6A5D4A0 A0E7A0A0 C9A0A0A0 D5A0A9A0
0053C8  0074355F                HEX     0074355F 666D7B00 74355F66 6D7B0074
0053D8  355F666D                HEX     355F666D 7B007435 5F666D7B 00152A3F
0053E8  00152A3F                HEX     00152A3F 14141414 14141414 FEFE0202
0053F8  00000000                HEX     00000000 00

; === while loop starts here (counter: Y 'iter_y') [nest:55] ===
; --- End data region (69 bytes) ---

0053FD  AD F3 53          L_0053FD    lda  $53F3           ; A=[$53F3] X=$0003 Y=$0010 ; [SP-231]
005400  8D F9 53                      sta  $53F9           ; A=[$53F3] X=$0003 Y=$0010 ; [SP-231]
005403  18                            clc                  ; A=[$53F3] X=$0003 Y=$0010 ; [SP-231]
005404  6D F7 53                      adc  $53F7           ; A=[$53F3] X=$0003 Y=$0010 ; [SP-231]
005407  8D FA 53                      sta  $53FA           ; A=[$53F3] X=$0003 Y=$0010 ; [SP-231]
00540A  8D F3 53                      sta  $53F3           ; A=[$53F3] X=$0003 Y=$0010 ; [SP-231]
00540D  C9 0A                         cmp  #$0A            ; A=[$53F3] X=$0003 Y=$0010 ; [SP-231]
00540F  90 04                         bcc  L_005415        ; A=[$53F3] X=$0003 Y=$0010 ; [SP-231]
005411  C9 6C                         cmp  #$6C            ; A=[$53F3] X=$0003 Y=$0010 ; [SP-231]
005413  90 09                         bcc  L_00541E        ; A=[$53F3] X=$0003 Y=$0010 ; [SP-231]
005415  38                L_005415    sec                  ; A=[$53F3] X=$0003 Y=$0010 ; [SP-231]
005416  A9 00                         lda  #$00            ; A=$0000 X=$0003 Y=$0010 ; [SP-231]
005418  ED F7 53                      sbc  $53F7           ; A=$0000 X=$0003 Y=$0010 ; [SP-231]
00541B  8D F7 53                      sta  $53F7           ; A=$0000 X=$0003 Y=$0010 ; [SP-231]
00541E  A9 03             L_00541E    lda  #$03            ; A=$0003 X=$0003 Y=$0010 ; [SP-231]
005420  8D F8 53                      sta  $53F8           ; A=$0003 X=$0003 Y=$0010 ; [SP-231]

; === while loop starts here (counter: X 'iter_x') [nest:62] ===
005423  AE F8 53          L_005423    ldx  $53F8           ; A=$0003 X=$0003 Y=$0010 ; [SP-231]
005426  BD C4 53                      lda  $53C4,X         ; -> $53C7 ; A=$0003 X=$0003 Y=$0010 ; [SP-231]
005429  F0 30                         beq  L_00545B        ; A=$0003 X=$0003 Y=$0010 ; [SP-231]
00542B  48                            pha                  ; A=$0003 X=$0003 Y=$0010 ; [SP-232]
00542C  AD F9 53                      lda  $53F9           ; A=[$53F9] X=$0003 Y=$0010 ; [SP-232]
00542F  18                            clc                  ; A=[$53F9] X=$0003 Y=$0010 ; [SP-232]
005430  7D E8 53                      adc  $53E8,X         ; -> $53EB ; A=[$53F9] X=$0003 Y=$0010 ; [SP-232]
005433  85 04                         sta  $04             ; A=[$53F9] X=$0003 Y=$0010 ; [SP-232]
005435  A9 09                         lda  #$09            ; A=$0009 X=$0003 Y=$0010 ; [SP-232]
005437  85 02                         sta  $02             ; A=$0009 X=$0003 Y=$0010 ; [SP-232]
005439  68                            pla                  ; A=[stk] X=$0003 Y=$0010 ; [SP-231]
00543A  AA                            tax                  ; A=[stk] X=[stk] Y=$0010 ; [SP-231]
00543B  BD D6 53                      lda  $53D6,X         ; A=[stk] X=[stk] Y=$0010 ; [SP-231]
00543E  20 C0 40                      jsr  L_0040C0        ; A=[stk] X=[stk] Y=$0010 ; [SP-233]
; === End of while loop (counter: X) ===

005441  AE F8 53                      ldx  $53F8           ; A=[stk] X=[stk] Y=$0010 ; [SP-233]
005444  AD FA 53                      lda  $53FA           ; A=[$53FA] X=[stk] Y=$0010 ; [SP-233]
005447  18                            clc                  ; A=[$53FA] X=[stk] Y=$0010 ; [SP-233]
005448  7D E8 53                      adc  $53E8,X         ; A=[$53FA] X=[stk] Y=$0010 ; [SP-233]
00544B  85 04                         sta  $04             ; A=[$53FA] X=[stk] Y=$0010 ; [SP-233]
00544D  A9 09                         lda  #$09            ; A=$0009 X=[stk] Y=$0010 ; [SP-233]
00544F  85 02                         sta  $02             ; A=$0009 X=[stk] Y=$0010 ; [SP-233]
005451  BD C4 53                      lda  $53C4,X         ; A=$0009 X=[stk] Y=$0010 ; [SP-233]
005454  AA                            tax                  ; A=$0009 X=$0009 Y=$0010 ; [SP-233]
005455  BD D6 53                      lda  $53D6,X         ; -> $53DF ; A=$0009 X=$0009 Y=$0010 ; [SP-233]
005458  20 16 04                      jsr  $0416           ; A=$0009 X=$0009 Y=$0010 ; [SP-235]
00545B  CE F8 53          L_00545B    dec  $53F8           ; A=$0009 X=$0009 Y=$0010 ; [SP-235]
00545E  10 C3                         bpl  L_005423        ; A=$0009 X=$0009 Y=$0010 ; [SP-235]
; === End of while loop (counter: X) ===

005460  60                            rts                  ; A=$0009 X=$0009 Y=$0010 ; [SP-233]

; === while loop starts here (counter: Y 'iter_y') [nest:55] ===
005461  AD F1 53          L_005461    lda  $53F1           ; A=[$53F1] X=$0009 Y=$0010 ; [SP-233]
005464  8D F9 53                      sta  $53F9           ; A=[$53F1] X=$0009 Y=$0010 ; [SP-233]
005467  18                            clc                  ; A=[$53F1] X=$0009 Y=$0010 ; [SP-233]
005468  6D F5 53                      adc  $53F5           ; A=[$53F1] X=$0009 Y=$0010 ; [SP-233]
00546B  8D FA 53                      sta  $53FA           ; A=[$53F1] X=$0009 Y=$0010 ; [SP-233]
00546E  8D F1 53                      sta  $53F1           ; A=[$53F1] X=$0009 Y=$0010 ; [SP-233]
005471  C9 0A                         cmp  #$0A            ; A=[$53F1] X=$0009 Y=$0010 ; [SP-233]
005473  90 04                         bcc  L_005479        ; A=[$53F1] X=$0009 Y=$0010 ; [SP-233]
005475  C9 6C                         cmp  #$6C            ; A=[$53F1] X=$0009 Y=$0010 ; [SP-233]
005477  90 09                         bcc  L_005482        ; A=[$53F1] X=$0009 Y=$0010 ; [SP-233]
005479  38                L_005479    sec                  ; A=[$53F1] X=$0009 Y=$0010 ; [SP-233]
00547A  A9 00                         lda  #$00            ; A=$0000 X=$0009 Y=$0010 ; [SP-233]
00547C  ED F5 53                      sbc  $53F5           ; A=$0000 X=$0009 Y=$0010 ; [SP-233]
00547F  8D F5 53                      sta  $53F5           ; A=$0000 X=$0009 Y=$0010 ; [SP-233]
005482  A9 03             L_005482    lda  #$03            ; A=$0003 X=$0009 Y=$0010 ; [SP-233]
005484  8D F8 53                      sta  $53F8           ; A=$0003 X=$0009 Y=$0010 ; [SP-233]

; === while loop starts here (counter: X 'iter_x') [nest:62] ===
005487  AE F8 53          L_005487    ldx  $53F8           ; A=$0003 X=$0009 Y=$0010 ; [SP-233]
00548A  BD BC 53                      lda  $53BC,X         ; -> $53C5 ; A=$0003 X=$0009 Y=$0010 ; [SP-233]
00548D  F0 30                         beq  L_0054BF        ; A=$0003 X=$0009 Y=$0010 ; [SP-233]
00548F  48                            pha                  ; A=$0003 X=$0009 Y=$0010 ; [SP-234]
005490  AD F9 53                      lda  $53F9           ; A=[$53F9] X=$0009 Y=$0010 ; [SP-234]
005493  18                            clc                  ; A=[$53F9] X=$0009 Y=$0010 ; [SP-234]
005494  7D E8 53                      adc  $53E8,X         ; -> $53F1 ; A=[$53F9] X=$0009 Y=$0010 ; [SP-234]
005497  85 04                         sta  $04             ; A=[$53F9] X=$0009 Y=$0010 ; [SP-234]
005499  A9 25                         lda  #$25            ; A=$0025 X=$0009 Y=$0010 ; [SP-234]
00549B  85 02                         sta  $02             ; A=$0025 X=$0009 Y=$0010 ; [SP-234]
00549D  68                            pla                  ; A=[stk] X=$0009 Y=$0010 ; [SP-233]
00549E  AA                            tax                  ; A=[stk] X=[stk] Y=$0010 ; [SP-233]
00549F  BD DD 53                      lda  $53DD,X         ; A=[stk] X=[stk] Y=$0010 ; [SP-233]
0054A2  20 C0 40                      jsr  L_0040C0        ; A=[stk] X=[stk] Y=$0010 ; [SP-235]
; === End of while loop (counter: X) ===

0054A5  AE F8 53                      ldx  $53F8           ; A=[stk] X=[stk] Y=$0010 ; [SP-235]
0054A8  AD FA 53                      lda  $53FA           ; A=[$53FA] X=[stk] Y=$0010 ; [SP-235]
0054AB  18                            clc                  ; A=[$53FA] X=[stk] Y=$0010 ; [SP-235]
0054AC  7D E8 53                      adc  $53E8,X         ; A=[$53FA] X=[stk] Y=$0010 ; [SP-235]
0054AF  85 04                         sta  $04             ; A=[$53FA] X=[stk] Y=$0010 ; [SP-235]
0054B1  A9 25                         lda  #$25            ; A=$0025 X=[stk] Y=$0010 ; [SP-235]
0054B3  85 02                         sta  $02             ; A=$0025 X=[stk] Y=$0010 ; [SP-235]
0054B5  BD BC 53                      lda  $53BC,X         ; A=$0025 X=[stk] Y=$0010 ; [SP-235]
0054B8  AA                            tax                  ; A=$0025 X=$0025 Y=$0010 ; [SP-235]
0054B9  BD DD 53                      lda  $53DD,X         ; -> $5402 ; A=$0025 X=$0025 Y=$0010 ; [SP-235]
0054BC  20 16 04                      jsr  $0416           ; A=$0025 X=$0025 Y=$0010 ; [SP-237]
0054BF  CE F8 53          L_0054BF    dec  $53F8           ; A=$0025 X=$0025 Y=$0010 ; [SP-237]
0054C2  10 C3                         bpl  L_005487        ; A=$0025 X=$0025 Y=$0010 ; [SP-237]
; === End of while loop (counter: X) ===

0054C4  60                            rts                  ; A=$0025 X=$0025 Y=$0010 ; [SP-235]

; === while loop starts here (counter: Y 'iter_y') [nest:56] ===
; case 1:
0054C5  AD EC 53          L_0054C5    lda  $53EC           ; A=[$53EC] X=$0025 Y=$0010 ; [SP-235]
0054C8  8D FB 53                      sta  $53FB           ; A=[$53EC] X=$0025 Y=$0010 ; [SP-235]
0054CB  18                            clc                  ; A=[$53EC] X=$0025 Y=$0010 ; [SP-235]
0054CC  6D F4 53                      adc  $53F4           ; A=[$53EC] X=$0025 Y=$0010 ; [SP-235]
0054CF  8D FC 53                      sta  $53FC           ; A=[$53EC] X=$0025 Y=$0010 ; [SP-235]
0054D2  8D EC 53                      sta  $53EC           ; A=[$53EC] X=$0025 Y=$0010 ; [SP-235]
0054D5  C9 0A                         cmp  #$0A            ; A=[$53EC] X=$0025 Y=$0010 ; [SP-235]
0054D7  90 04                         bcc  L_0054DD        ; A=[$53EC] X=$0025 Y=$0010 ; [SP-235]
0054D9  C9 85                         cmp  #$85            ; A=[$53EC] X=$0025 Y=$0010 ; [SP-235]
0054DB  90 09                         bcc  L_0054E6        ; A=[$53EC] X=$0025 Y=$0010 ; [SP-235]
0054DD  38                L_0054DD    sec                  ; A=[$53EC] X=$0025 Y=$0010 ; [SP-235]
0054DE  A9 00                         lda  #$00            ; A=$0000 X=$0025 Y=$0010 ; [SP-235]
0054E0  ED F4 53                      sbc  $53F4           ; A=$0000 X=$0025 Y=$0010 ; [SP-235]
0054E3  8D F4 53                      sta  $53F4           ; A=$0000 X=$0025 Y=$0010 ; [SP-235]
0054E6  A9 03             L_0054E6    lda  #$03            ; A=$0003 X=$0025 Y=$0010 ; [SP-235]
0054E8  8D F8 53                      sta  $53F8           ; A=$0003 X=$0025 Y=$0010 ; [SP-235]

; === while loop starts here (counter: Y 'iter_y') [nest:61] ===
0054EB  AE F8 53          L_0054EB    ldx  $53F8           ; A=$0003 X=$0025 Y=$0010 ; [SP-235]
0054EE  BD B8 53                      lda  $53B8,X         ; -> $53DD ; A=$0003 X=$0025 Y=$0010 ; [SP-235]
0054F1  F0 30                         beq  L_005523        ; A=$0003 X=$0025 Y=$0010 ; [SP-235]
0054F3  48                            pha                  ; A=$0003 X=$0025 Y=$0010 ; [SP-236]
0054F4  AD FB 53                      lda  $53FB           ; A=[$53FB] X=$0025 Y=$0010 ; [SP-236]
0054F7  18                            clc                  ; A=[$53FB] X=$0025 Y=$0010 ; [SP-236]
0054F8  7D E4 53                      adc  $53E4,X         ; -> $5409 ; A=[$53FB] X=$0025 Y=$0010 ; [SP-236]
0054FB  85 19                         sta  $19             ; A=[$53FB] X=$0025 Y=$0010 ; [SP-236]
0054FD  A9 01                         lda  #$01            ; A=$0001 X=$0025 Y=$0010 ; [SP-236]
0054FF  85 04                         sta  $04             ; A=$0001 X=$0025 Y=$0010 ; [SP-236]
005501  68                            pla                  ; A=[stk] X=$0025 Y=$0010 ; [SP-235]
005502  AA                            tax                  ; A=[stk] X=[stk] Y=$0010 ; [SP-235]
005503  BD C8 53                      lda  $53C8,X         ; A=[stk] X=[stk] Y=$0010 ; [SP-235]
005506  20 A1 52                      jsr  L_0052A1        ; A=[stk] X=[stk] Y=$0010 ; [SP-237]
; === End of while loop (counter: Y) ===

005509  AE F8 53                      ldx  $53F8           ; A=[stk] X=[stk] Y=$0010 ; [SP-237]
00550C  AD FC 53                      lda  $53FC           ; A=[$53FC] X=[stk] Y=$0010 ; [SP-237]
00550F  18                            clc                  ; A=[$53FC] X=[stk] Y=$0010 ; [SP-237]
005510  7D E4 53                      adc  $53E4,X         ; A=[$53FC] X=[stk] Y=$0010 ; [SP-237]
005513  85 19                         sta  $19             ; A=[$53FC] X=[stk] Y=$0010 ; [SP-237]
005515  A9 01                         lda  #$01            ; A=$0001 X=[stk] Y=$0010 ; [SP-237]
005517  85 04                         sta  $04             ; A=$0001 X=[stk] Y=$0010 ; [SP-237]
005519  BD B8 53                      lda  $53B8,X         ; A=$0001 X=[stk] Y=$0010 ; [SP-237]
00551C  AA                            tax                  ; A=$0001 X=$0001 Y=$0010 ; [SP-237]
00551D  BD C8 53                      lda  $53C8,X         ; -> $53C9 ; A=$0001 X=$0001 Y=$0010 ; [SP-237]
005520  20 7F 52                      jsr  L_00527F        ; A=$0001 X=$0001 Y=$0010 ; [SP-239]
; === End of while loop (counter: Y) ===

005523  CE F8 53          L_005523    dec  $53F8           ; A=$0001 X=$0001 Y=$0010 ; [SP-239]
005526  10 C3                         bpl  L_0054EB        ; A=$0001 X=$0001 Y=$0010 ; [SP-239]
; === End of while loop (counter: Y) ===

005528  60                            rts                  ; A=$0001 X=$0001 Y=$0010 ; [SP-237]

; === while loop starts here [nest:55] ===
005529  AD EE 53          L_005529    lda  $53EE           ; A=[$53EE] X=$0001 Y=$0010 ; [SP-237]
00552C  8D FB 53                      sta  $53FB           ; A=[$53EE] X=$0001 Y=$0010 ; [SP-237]
00552F  18                            clc                  ; A=[$53EE] X=$0001 Y=$0010 ; [SP-237]
005530  6D F6 53                      adc  $53F6           ; A=[$53EE] X=$0001 Y=$0010 ; [SP-237]
005533  8D FC 53                      sta  $53FC           ; A=[$53EE] X=$0001 Y=$0010 ; [SP-237]
005536  8D EE 53                      sta  $53EE           ; A=[$53EE] X=$0001 Y=$0010 ; [SP-237]
005539  C9 0A                         cmp  #$0A            ; A=[$53EE] X=$0001 Y=$0010 ; [SP-237]
00553B  90 04                         bcc  L_005541        ; A=[$53EE] X=$0001 Y=$0010 ; [SP-237]
00553D  C9 85                         cmp  #$85            ; A=[$53EE] X=$0001 Y=$0010 ; [SP-237]
00553F  90 09                         bcc  L_00554A        ; A=[$53EE] X=$0001 Y=$0010 ; [SP-237]
005541  38                L_005541    sec                  ; A=[$53EE] X=$0001 Y=$0010 ; [SP-237]
005542  A9 00                         lda  #$00            ; A=$0000 X=$0001 Y=$0010 ; [SP-237]
005544  ED F6 53                      sbc  $53F6           ; A=$0000 X=$0001 Y=$0010 ; [SP-237]
005547  8D F6 53                      sta  $53F6           ; A=$0000 X=$0001 Y=$0010 ; [SP-237]
00554A  A9 03             L_00554A    lda  #$03            ; A=$0003 X=$0001 Y=$0010 ; [SP-237]
00554C  8D F8 53                      sta  $53F8           ; A=$0003 X=$0001 Y=$0010 ; [SP-237]

; === while loop starts here [nest:60] ===
00554F  AE F8 53          L_00554F    ldx  $53F8           ; A=$0003 X=$0001 Y=$0010 ; [SP-237]
005552  BD C0 53                      lda  $53C0,X         ; -> $53C1 ; A=$0003 X=$0001 Y=$0010 ; [SP-237]
005555  F0 30                         beq  L_005587        ; A=$0003 X=$0001 Y=$0010 ; [SP-237]
005557  48                            pha                  ; A=$0003 X=$0001 Y=$0010 ; [SP-238]
005558  AD FB 53                      lda  $53FB           ; A=[$53FB] X=$0001 Y=$0010 ; [SP-238]
00555B  18                            clc                  ; A=[$53FB] X=$0001 Y=$0010 ; [SP-238]
00555C  7D E4 53                      adc  $53E4,X         ; -> $53E5 ; A=[$53FB] X=$0001 Y=$0010 ; [SP-238]
00555F  85 19                         sta  $19             ; A=[$53FB] X=$0001 Y=$0010 ; [SP-238]
005561  A9 B4                         lda  #$B4            ; A=$00B4 X=$0001 Y=$0010 ; [SP-238]
005563  85 04                         sta  $04             ; A=$00B4 X=$0001 Y=$0010 ; [SP-238]
005565  68                            pla                  ; A=[stk] X=$0001 Y=$0010 ; [SP-237]
005566  AA                            tax                  ; A=[stk] X=[stk] Y=$0010 ; [SP-237]
005567  BD CF 53                      lda  $53CF,X         ; A=[stk] X=[stk] Y=$0010 ; [SP-237]
00556A  20 A1 52                      jsr  L_0052A1        ; A=[stk] X=[stk] Y=$0010 ; [SP-239]
; === End of while loop (counter: Y) ===

00556D  AE F8 53                      ldx  $53F8           ; A=[stk] X=[stk] Y=$0010 ; [SP-239]
005570  AD FC 53                      lda  $53FC           ; A=[$53FC] X=[stk] Y=$0010 ; [SP-239]
005573  18                            clc                  ; A=[$53FC] X=[stk] Y=$0010 ; [SP-239]
005574  7D E4 53                      adc  $53E4,X         ; A=[$53FC] X=[stk] Y=$0010 ; [SP-239]
005577  85 19                         sta  $19             ; A=[$53FC] X=[stk] Y=$0010 ; [SP-239]
005579  A9 B4                         lda  #$B4            ; A=$00B4 X=[stk] Y=$0010 ; [SP-239]
00557B  85 04                         sta  $04             ; A=$00B4 X=[stk] Y=$0010 ; [SP-239]
00557D  BD C0 53                      lda  $53C0,X         ; A=$00B4 X=[stk] Y=$0010 ; [SP-239]
005580  AA                            tax                  ; A=$00B4 X=$00B4 Y=$0010 ; [SP-239]
005581  BD CF 53                      lda  $53CF,X         ; -> $5483 ; A=$00B4 X=$00B4 Y=$0010 ; [SP-239]
005584  20 7F 52                      jsr  L_00527F        ; A=$00B4 X=$00B4 Y=$0010 ; [SP-241]
; === End of while loop (counter: Y) ===

005587  CE F8 53          L_005587    dec  $53F8           ; A=$00B4 X=$00B4 Y=$0010 ; [SP-241]
00558A  10 C3                         bpl  L_00554F        ; A=$00B4 X=$00B4 Y=$0010 ; [SP-241]
; === End of while loop ===

00558C  60                            rts                  ; A=$00B4 X=$00B4 Y=$0010 ; [SP-239]

; --- Data region ---
00558D  F8F80000                HEX     F8F80000

; === while loop starts here (counter: X 'iter_x') [nest:27] ===

; FUNC $005591: register -> A:X []
; Liveness: returns(A,X,Y) [5 dead stores]
; --- End data region (4 bytes) ---

005591  EE 8D 55          L_005591    inc  $558D           ; A=$00B4 X=$00B4 Y=$0010 ; [SP-242]
005594  D0 49                         bne  L_0055DF        ; A=$00B4 X=$00B4 Y=$0010 ; [SP-242]
005596  AD 8E 55                      lda  $558E           ; A=[$558E] X=$00B4 Y=$0010 ; [SP-242]
005599  8D 8D 55                      sta  $558D           ; A=[$558E] X=$00B4 Y=$0010 ; [SP-242]
00559C  EE 8F 55                      inc  $558F           ; A=[$558E] X=$00B4 Y=$0010 ; [SP-242]
00559F  AD 8F 55                      lda  $558F           ; A=[$558F] X=$00B4 Y=$0010 ; [SP-242]
0055A2  29 03                         and  #$03            ; A=A&$03 X=$00B4 Y=$0010 ; [SP-242]
0055A4  8D 8F 55                      sta  $558F           ; A=A&$03 X=$00B4 Y=$0010 ; [SP-242]
0055A7  AA                            tax                  ; A=A&$03 X=A Y=$0010 ; [SP-242]
0055A8  BD 54 5D                      lda  $5D54,X         ; A=A&$03 X=A Y=$0010 ; [SP-242]
0055AB  D0 32                         bne  L_0055DF        ; A=A&$03 X=A Y=$0010 ; [SP-242]
0055AD  20 0E 56                      jsr  L_00560E        ; A=A&$03 X=A Y=$0010 ; [SP-244]
0055B0  F0 2D                         beq  L_0055DF        ; A=A&$03 X=A Y=$0010 ; [SP-244]
0055B2  E6 2C                         inc  $2C             ; A=A&$03 X=A Y=$0010 ; [SP-244]
0055B4  D0 29                         bne  L_0055DF        ; A=A&$03 X=A Y=$0010 ; [SP-244]
0055B6  A5 32                         lda  $32             ; A=[$0032] X=A Y=$0010 ; [SP-244]
0055B8  85 2C                         sta  $2C             ; A=[$0032] X=A Y=$0010 ; [SP-244]
0055BA  AD 8F 55                      lda  $558F           ; A=[$558F] X=A Y=$0010 ; [SP-244]
0055BD  0A                            asl  a               ; A=[$558F] X=A Y=$0010 ; [OPT] STRENGTH_RED: Multiple ASL A: consider using lookup table for multiply ; [SP-244]
0055BE  0A                            asl  a               ; A=[$558F] X=A Y=$0010 ; [SP-244]
0055BF  18                            clc                  ; A=[$558F] X=A Y=$0010 ; [SP-244]
0055C0  69 03                         adc  #$03            ; A=A+$03 X=A Y=$0010 ; [SP-244]
0055C2  AA                            tax                  ; A=A+$03 X=A Y=$0010 ; [SP-244]
0055C3  BD B8 53                      lda  $53B8,X         ; A=A+$03 X=A Y=$0010 ; [SP-244]
0055C6  CA                            dex                  ; A=A+$03 X=X-$01 Y=$0010 ; [SP-244]
0055C7  A0 02                         ldy  #$02            ; A=A+$03 X=X-$01 Y=$0002 ; [SP-244]

; === while loop starts here [nest:61] ===
0055C9  DD B8 53          L_0055C9    cmp  $53B8,X         ; A=A+$03 X=X-$01 Y=$0002 ; [SP-244]
0055CC  D0 0B                         bne  L_0055D9        ; A=A+$03 X=X-$01 Y=$0002 ; [SP-244]
0055CE  CA                            dex                  ; A=A+$03 X=X-$01 Y=$0002 ; [SP-244]
0055CF  88                            dey                  ; A=A+$03 X=X-$01 Y=$0001 ; [SP-244]
0055D0  10 F7                         bpl  L_0055C9        ; A=A+$03 X=X-$01 Y=$0001 ; [SP-244]
; === End of while loop ===

0055D2  20 03 04                      jsr  $0403           ; A=A+$03 X=X-$01 Y=$0001 ; [SP-246]
0055D5  C9 80                         cmp  #$80            ; A=A+$03 X=X-$01 Y=$0001 ; [SP-246]
0055D7  B0 06                         bcs  L_0055DF        ; A=A+$03 X=X-$01 Y=$0001 ; [SP-246]
0055D9  AE 8F 55          L_0055D9    ldx  $558F           ; A=A+$03 X=X-$01 Y=$0001 ; [SP-246]
0055DC  20 0C 4B                      jsr  L_004B0C        ; A=A+$03 X=X-$01 Y=$0001 ; [OPT] TAIL_CALL: Tail call: JSR/JSL at $0055DC followed by RTS ; [SP-248]
; === End of while loop (counter: Y) ===

0055DF  60                L_0055DF    rts                  ; A=A+$03 X=X-$01 Y=$0001 ; [SP-246]

; --- Data region ---
0055E0  E0E000                  HEX     E0E000

; === while loop starts here (counter: X 'iter_x') [nest:27] ===

; FUNC $0055E3: register -> A:X [L]
; Proto: uint32_t func_0055E3(uint16_t param_A, uint16_t param_X, uint16_t param_Y);
; Liveness: params(A,X,Y) returns(A,X,Y)
; --- End data region (3 bytes) ---

0055E3  EE E1 55          L_0055E3    inc  $55E1           ; A=A+$03 X=X-$01 Y=$0001 ; [SP-249]
0055E6  F0 01                         beq  L_0055E9        ; A=A+$03 X=X-$01 Y=$0001 ; [SP-249]
0055E8  60                            rts                  ; A=A+$03 X=X-$01 Y=$0001 ; [SP-247]
0055E9  AD E0 55          L_0055E9    lda  $55E0           ; A=[$55E0] X=X-$01 Y=$0001 ; [SP-247]
0055EC  8D E1 55                      sta  $55E1           ; A=[$55E0] X=X-$01 Y=$0001 ; [SP-247]
0055EF  CE E2 55                      dec  $55E2           ; A=[$55E0] X=X-$01 Y=$0001 ; [SP-247]
0055F2  AD E2 55                      lda  $55E2           ; A=[$55E2] X=X-$01 Y=$0001 ; [SP-247]
0055F5  10 08                         bpl  L_0055FF        ; A=[$55E2] X=X-$01 Y=$0001 ; [SP-247]
0055F7  A9 03                         lda  #$03            ; A=$0003 X=X-$01 Y=$0001 ; [SP-247]
0055F9  8D E2 55                      sta  $55E2           ; A=$0003 X=X-$01 Y=$0001 ; [SP-247]
0055FC  4C FD 53                      jmp  L_0053FD        ; A=$0003 X=X-$01 Y=$0001 ; [SP-247]
; === End of while loop (counter: Y) ===

0055FF  D0 03             L_0055FF    bne  L_005604        ; A=$0003 X=X-$01 Y=$0001 ; [SP-247]
005601  4C C5 54                      jmp  L_0054C5        ; A=$0003 X=X-$01 Y=$0001 ; [SP-247]
; === End of while loop (counter: Y) ===

005604  C9 01             L_005604    cmp  #$01            ; A=$0003 X=X-$01 Y=$0001 ; [SP-247]
005606  D0 03                         bne  L_00560B        ; A=$0003 X=X-$01 Y=$0001 ; [SP-247]
005608  4C 61 54                      jmp  L_005461        ; A=$0003 X=X-$01 Y=$0001 ; [SP-247]
; === End of while loop (counter: Y) ===

00560B  4C 29 55          L_00560B    jmp  L_005529        ; A=$0003 X=X-$01 Y=$0001 ; [SP-247]
; === End of while loop ===


; FUNC $00560E: register -> A:X [L]
; Proto: uint32_t func_00560E(uint16_t param_Y);
; Liveness: params(Y) returns(A,X,Y) [2 dead stores]
00560E  E0 01             L_00560E    cpx  #$01            ; A=$0003 X=X-$01 Y=$0001 ; [SP-247]
005610  D0 03                         bne  L_005615        ; A=$0003 X=X-$01 Y=$0001 ; [SP-247]
005612  4C 9E 56                      jmp  L_00569E        ; A=$0003 X=X-$01 Y=$0001 ; [SP-247]
005615  E0 02             L_005615    cpx  #$02            ; A=$0003 X=X-$01 Y=$0001 ; [SP-247]
005617  D0 03                         bne  L_00561C        ; A=$0003 X=X-$01 Y=$0001 ; [SP-247]
005619  4C 4C 56                      jmp  L_00564C        ; A=$0003 X=X-$01 Y=$0001 ; [SP-247]
00561C  E0 03             L_00561C    cpx  #$03            ; A=$0003 X=X-$01 Y=$0001 ; [SP-247]
00561E  D0 03                         bne  L_005623        ; A=$0003 X=X-$01 Y=$0001 ; [SP-247]
005620  4C 75 56                      jmp  L_005675        ; A=$0003 X=X-$01 Y=$0001 ; [SP-247]
005623  AD EC 53          L_005623    lda  $53EC           ; A=[$53EC] X=X-$01 Y=$0001 ; [SP-247]
005626  8D FB 53                      sta  $53FB           ; A=[$53EC] X=X-$01 Y=$0001 ; [SP-247]
005629  A9 03                         lda  #$03            ; A=$0003 X=X-$01 Y=$0001 ; [SP-247]
00562B  8D F8 53                      sta  $53F8           ; A=$0003 X=X-$01 Y=$0001 ; [SP-247]

; === while loop starts here (counter: $00, range: 0..19878, step: 19881, iters: 86388972211856) [nest:57] [inner] ===
00562E  AE F8 53          L_00562E    ldx  $53F8           ; A=$0003 X=X-$01 Y=$0001 ; [SP-247]
005631  AD FB 53                      lda  $53FB           ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-247]
005634  18                            clc                  ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-247]
005635  7D E4 53                      adc  $53E4,X         ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-247]
005638  C9 5F                         cmp  #$5F            ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-247]
00563A  90 08                         bcc  L_005644        ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-247]
00563C  C9 6F                         cmp  #$6F            ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-247]
00563E  B0 04                         bcs  L_005644        ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-247]
005640  BD B8 53                      lda  $53B8,X         ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-247]
005643  60                            rts                  ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-245]
005644  CE F8 53          L_005644    dec  $53F8           ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-245]
005647  10 E5                         bpl  L_00562E        ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-245]
; === End of while loop (counter: $00) ===

005649  A9 00                         lda  #$00            ; A=$0000 X=X-$01 Y=$0001 ; [SP-245]
00564B  60                            rts                  ; A=$0000 X=X-$01 Y=$0001 ; [SP-243]
00564C  AD EE 53          L_00564C    lda  $53EE           ; A=[$53EE] X=X-$01 Y=$0001 ; [SP-243]
00564F  8D FB 53                      sta  $53FB           ; A=[$53EE] X=X-$01 Y=$0001 ; [SP-243]
005652  A9 03                         lda  #$03            ; A=$0003 X=X-$01 Y=$0001 ; [SP-243]
005654  8D F8 53                      sta  $53F8           ; A=$0003 X=X-$01 Y=$0001 ; [SP-243]

; === while loop starts here (counter: $00, range: 0..20188, step: 20191, iters: 86638080315083) [nest:57] [inner] ===
005657  AE F8 53          L_005657    ldx  $53F8           ; A=$0003 X=X-$01 Y=$0001 ; [SP-243]
00565A  AD FB 53                      lda  $53FB           ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-243]
00565D  18                            clc                  ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-243]
00565E  7D E4 53                      adc  $53E4,X         ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-243]
005661  C9 5F                         cmp  #$5F            ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-243]
005663  90 08                         bcc  L_00566D        ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-243]
005665  C9 6F                         cmp  #$6F            ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-243]
005667  B0 04                         bcs  L_00566D        ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-243]
005669  BD C0 53                      lda  $53C0,X         ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-243]
00566C  60                            rts                  ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-241]
00566D  CE F8 53          L_00566D    dec  $53F8           ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-241]
005670  10 E5                         bpl  L_005657        ; A=[$53FB] X=X-$01 Y=$0001 ; [SP-241]
; === End of while loop (counter: $00) ===

005672  A9 00                         lda  #$00            ; A=$0000 X=X-$01 Y=$0001 ; [SP-241]
005674  60                            rts                  ; A=$0000 X=X-$01 Y=$0001 ; [SP-239]
005675  AD F3 53          L_005675    lda  $53F3           ; A=[$53F3] X=X-$01 Y=$0001 ; [SP-239]
005678  8D F9 53                      sta  $53F9           ; A=[$53F3] X=X-$01 Y=$0001 ; [SP-239]
00567B  A9 03                         lda  #$03            ; A=$0003 X=X-$01 Y=$0001 ; [SP-239]
00567D  8D F8 53                      sta  $53F8           ; A=$0003 X=X-$01 Y=$0001 ; [SP-239]

; === while loop starts here (counter: $00 '', range: 0..20122, step: 19908, iters: 90851443232439) [nest:57] [inner] ===
005680  AE F8 53          L_005680    ldx  $53F8           ; A=$0003 X=X-$01 Y=$0001 ; [SP-239]
005683  AD F9 53                      lda  $53F9           ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-239]
005686  18                            clc                  ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-239]
005687  7D E8 53                      adc  $53E8,X         ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-239]
00568A  C9 5A                         cmp  #$5A            ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-239]
00568C  90 08                         bcc  L_005696        ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-239]
00568E  C9 63                         cmp  #$63            ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-239]
005690  B0 04                         bcs  L_005696        ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-239]
005692  BD C4 53                      lda  $53C4,X         ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-239]
005695  60                            rts                  ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-237]
005696  CE F8 53          L_005696    dec  $53F8           ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-237]
005699  10 E5                         bpl  L_005680        ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-237]
; === End of while loop (counter: $00) ===

00569B  A9 00                         lda  #$00            ; A=$0000 X=X-$01 Y=$0001 ; [SP-237]
00569D  60                            rts                  ; A=$0000 X=X-$01 Y=$0001 ; [SP-235]
00569E  AD F1 53          L_00569E    lda  $53F1           ; A=[$53F1] X=X-$01 Y=$0001 ; [SP-235]
0056A1  8D F9 53                      sta  $53F9           ; A=[$53F1] X=X-$01 Y=$0001 ; [SP-235]
0056A4  A9 03                         lda  #$03            ; A=$0003 X=X-$01 Y=$0001 ; [SP-235]
0056A6  8D F8 53                      sta  $53F8           ; A=$0003 X=X-$01 Y=$0001 ; [SP-235]

; === while loop starts here (counter: $00, range: 0..19884, step: 19887, iters: 86023899991611) [nest:57] [inner] ===
0056A9  AE F8 53          L_0056A9    ldx  $53F8           ; A=$0003 X=X-$01 Y=$0001 ; [SP-235]
0056AC  AD F9 53                      lda  $53F9           ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-235]
0056AF  18                            clc                  ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-235]
0056B0  7D E8 53                      adc  $53E8,X         ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-235]
0056B3  C9 5A                         cmp  #$5A            ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-235]
0056B5  90 08                         bcc  L_0056BF        ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-235]
0056B7  C9 63                         cmp  #$63            ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-235]
0056B9  B0 04                         bcs  L_0056BF        ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-235]
0056BB  BD BC 53                      lda  $53BC,X         ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-235]
0056BE  60                            rts                  ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-233]
0056BF  CE F8 53          L_0056BF    dec  $53F8           ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-233]
0056C2  10 E5                         bpl  L_0056A9        ; A=[$53F9] X=X-$01 Y=$0001 ; [SP-233]
; === End of while loop (counter: $00) ===

0056C4  A9 00                         lda  #$00            ; A=$0000 X=X-$01 Y=$0001 ; [SP-233]
0056C6  60                            rts                  ; A=$0000 X=X-$01 Y=$0001 ; [SP-231]

; --- Data region ---
0056C7  0000                    HEX     0000

; === while loop starts here (counter: X 'iter_x') [nest:27] ===

; FUNC $0056C9: register -> A:X []
; Proto: uint32_t func_0056C9(uint16_t param_Y);
; Liveness: params(Y) returns(A,X,Y) [2 dead stores]
; --- End data region (2 bytes) ---

0056C9  20 03 04          L_0056C9    jsr  $0403           ; A=$0000 X=X-$01 Y=$0001 ; [SP-236]
0056CC  29 03                         and  #$03            ; A=A&$03 X=X-$01 Y=$0001 ; [SP-236]
0056CE  AA                            tax                  ; A=A&$03 X=A Y=$0001 ; [SP-236]
0056CF  BD 54 5D                      lda  $5D54,X         ; A=A&$03 X=A Y=$0001 ; [SP-236]
0056D2  F0 0E                         beq  L_0056E2        ; A=A&$03 X=A Y=$0001 ; [SP-236]
0056D4  8E C7 56                      stx  $56C7           ; A=A&$03 X=A Y=$0001 ; [SP-236]
0056D7  20 C4 44                      jsr  L_0044C4        ; A=A&$03 X=A Y=$0001 ; [SP-238]
; === End of while loop (counter: X) ===

0056DA  AE C7 56                      ldx  $56C7           ; A=A&$03 X=A Y=$0001 ; [SP-238]
0056DD  A9 00                         lda  #$00            ; A=$0000 X=A Y=$0001 ; [SP-238]
0056DF  9D 54 5D                      sta  $5D54,X         ; A=$0000 X=A Y=$0001 ; [SP-238]
0056E2  60                L_0056E2    rts                  ; A=$0000 X=A Y=$0001 ; [SP-236]

; --- Data region ---
0056E3  50                      HEX     50

; FUNC $0056E4: register -> A:X [L]
; Proto: uint32_t func_0056E4(uint16_t param_X, uint16_t param_Y);
; Liveness: params(X,Y) returns(A,X,Y)
; --- End data region (1 bytes) ---

0056E4  C6 31             L_0056E4    dec  $31             ; A=$0000 X=A Y=$0001 ; [SP-236]
0056E6  D0 09                         bne  L_0056F1        ; A=$0000 X=A Y=$0001 ; [SP-236]
0056E8  A5 30                         lda  $30             ; A=[$0030] X=A Y=$0001 ; [SP-236]
0056EA  F0 05                         beq  L_0056F1        ; A=[$0030] X=A Y=$0001 ; [SP-236]
0056EC  C6 30                         dec  $30             ; A=[$0030] X=A Y=$0001 ; [SP-236]
0056EE  4C F3 56                      jmp  L_0056F3        ; A=[$0030] X=A Y=$0001 ; [SP-236]
0056F1  60                L_0056F1    rts                  ; A=[$0030] X=A Y=$0001 ; [SP-234]

; --- Data region ---
0056F2  00                      HEX     00

; === while loop starts here (counter: Y 'iter_y', range: 0..192, iters: 192) [nest:48] ===

; FUNC $0056F3: register -> A:X [J]
; Proto: uint32_t func_0056F3(uint16_t param_Y);
; Liveness: params(Y) returns(A,X,Y) [5 dead stores]
; --- End data region (1 bytes) ---

0056F3  A6 30             L_0056F3    ldx  $30             ; A=[$0030] X=A Y=$0001 ; [SP-237]
0056F5  BD 6C 57                      lda  $576C,X         ; A=[$0030] X=A Y=$0001 ; [SP-237]
0056F8  85 2F                         sta  $2F             ; A=[$0030] X=A Y=$0001 ; [SP-237]
0056FA  BD 78 57                      lda  $5778,X         ; A=[$0030] X=A Y=$0001 ; [SP-237]
0056FD  8D F2 52                      sta  $52F2           ; A=[$0030] X=A Y=$0001 ; [SP-237]
005700  BD 84 57                      lda  $5784,X         ; A=[$0030] X=A Y=$0001 ; [SP-237]
005703  8D E0 55                      sta  $55E0           ; A=[$0030] X=A Y=$0001 ; [SP-237]
005706  BD 90 57                      lda  $5790,X         ; A=[$0030] X=A Y=$0001 ; [SP-237]
005709  85 32                         sta  $32             ; A=[$0030] X=A Y=$0001 ; [SP-237]
00570B  BD 9C 57                      lda  $579C,X         ; A=[$0030] X=A Y=$0001 ; [SP-237]
00570E  8D CC 57                      sta  $57CC           ; A=[$0030] X=A Y=$0001 ; [SP-237]
005711  BD A8 57                      lda  $57A8,X         ; A=[$0030] X=A Y=$0001 ; [SP-237]
005714  8D CF 57                      sta  $57CF           ; A=[$0030] X=A Y=$0001 ; [SP-237]
005717  BD B4 57                      lda  $57B4,X         ; A=[$0030] X=A Y=$0001 ; [SP-237]
00571A  8D D2 57                      sta  $57D2           ; A=[$0030] X=A Y=$0001 ; [SP-237]
00571D  BD C0 57                      lda  $57C0,X         ; A=[$0030] X=A Y=$0001 ; [SP-237]
005720  85 31                         sta  $31             ; A=[$0030] X=A Y=$0001 ; [SP-237]
005722  20 76 53                      jsr  L_005376        ; A=[$0030] X=A Y=$0001 ; [SP-239]
; === End of while loop (counter: X) ===

005725  20 76 53                      jsr  L_005376        ; A=[$0030] X=A Y=$0001 ; [SP-241]
; === End of while loop (counter: X) ===

005728  20 76 53                      jsr  L_005376        ; Call $005376(A, Y, 1 stack)
; === End of while loop (counter: X) ===

00572B  A5 30                         lda  $30             ; A=[$0030] X=A Y=$0001 ; [SP-243]
00572D  4A                            lsr  a               ; A=[$0030] X=A Y=$0001 ; [SP-243]
00572E  8D F2 56                      sta  $56F2           ; A=[$0030] X=A Y=$0001 ; [SP-243]
005731  A9 06                         lda  #$06            ; A=$0006 X=A Y=$0001 ; [SP-243]
005733  38                            sec                  ; A=$0006 X=A Y=$0001 ; [SP-243]
005734  ED F2 56                      sbc  $56F2           ; A=$0006 X=A Y=$0001 ; [SP-243]
005737  8D F2 56                      sta  $56F2           ; A=$0006 X=A Y=$0001 ; [SP-243]
00573A  A2 03                         ldx  #$03            ; A=$0006 X=$0003 Y=$0001 ; [SP-243]

; === while loop starts here [nest:55] ===
00573C  BD B8 53          L_00573C    lda  $53B8,X         ; -> $53BB ; A=$0006 X=$0003 Y=$0001 ; [SP-243]
00573F  D0 06                         bne  L_005747        ; A=$0006 X=$0003 Y=$0001 ; [SP-243]
005741  AD F2 56                      lda  $56F2           ; A=[$56F2] X=$0003 Y=$0001 ; [SP-243]
005744  9D B8 53                      sta  $53B8,X         ; -> $53BB ; A=[$56F2] X=$0003 Y=$0001 ; [SP-243]
005747  BD C0 53          L_005747    lda  $53C0,X         ; -> $53C3 ; A=[$56F2] X=$0003 Y=$0001 ; [SP-243]
00574A  D0 06                         bne  L_005752        ; A=[$56F2] X=$0003 Y=$0001 ; [SP-243]
00574C  AD F2 56                      lda  $56F2           ; A=[$56F2] X=$0003 Y=$0001 ; [OPT] REDUNDANT_LOAD: Redundant LDA: same value loaded at $005741 ; [SP-243]
00574F  9D C0 53                      sta  $53C0,X         ; -> $53C3 ; A=[$56F2] X=$0003 Y=$0001 ; [SP-243]
005752  BD BC 53          L_005752    lda  $53BC,X         ; -> $53BF ; A=[$56F2] X=$0003 Y=$0001 ; [SP-243]
005755  D0 06                         bne  L_00575D        ; A=[$56F2] X=$0003 Y=$0001 ; [SP-243]
005757  AD F2 56                      lda  $56F2           ; A=[$56F2] X=$0003 Y=$0001 ; [OPT] REDUNDANT_LOAD: Redundant LDA: same value loaded at $00574C ; [SP-243]
00575A  9D BC 53                      sta  $53BC,X         ; -> $53BF ; A=[$56F2] X=$0003 Y=$0001 ; [SP-243]
00575D  BD C4 53          L_00575D    lda  $53C4,X         ; -> $53C7 ; A=[$56F2] X=$0003 Y=$0001 ; [SP-243]
005760  D0 06                         bne  L_005768        ; A=[$56F2] X=$0003 Y=$0001 ; [SP-243]
005762  AD F2 56                      lda  $56F2           ; A=[$56F2] X=$0003 Y=$0001 ; [OPT] REDUNDANT_LOAD: Redundant LDA: same value loaded at $005757 ; [SP-243]
005765  9D C4 53                      sta  $53C4,X         ; -> $53C7 ; A=[$56F2] X=$0003 Y=$0001 ; [SP-243]
005768  CA                L_005768    dex                  ; A=[$56F2] X=$0002 Y=$0001 ; [SP-243]
005769  10 D1                         bpl  L_00573C        ; A=[$56F2] X=$0002 Y=$0001 ; [SP-243]
; === End of while loop ===

00576B  60                            rts                  ; A=[$56F2] X=$0002 Y=$0001 ; [SP-241]

; --- Data region ---
00576C  FCFAF9F7                HEX     FCFAF9F7 F5F4F0EB E6E4E2E0 F9F7F6F4
00577C  F3F0ECEB                HEX     F3F0ECEB E8E6E4E4 F8F6F4F1 EFEDEBE9
00578C  E7E5E3E1                HEX     E7E5E3E1 FCFAF7F5 F0EEEDEC E7E4E2E0
00579C  F4F4F3F3                HEX     F4F4F3F3 F2F2F1F1 F0F0F0F0 F0F0F0F0
0057AC  EFE8E0D8                HEX     EFE8E0D8 D0C8C0C0 F0F0F0F0 F0F0F0F0
0057BC  F0F0F0F0                HEX     F0F0F0F0 FF2A2A30 281E1E18 18101010
0057CC  00000000                HEX     00000000 000000F4 000000
; --- End data region (107 bytes) ---

0057D7  D8                            cld                  ; A=[$56F2] X=$0002 Y=$0001 ; [SP-264]
0057D8  20 5B 41                      jsr  L_00415B        ; A=[$56F2] X=$0002 Y=$0001 ; [SP-266]
; === End of while loop (counter: Y) ===

0057DB  20 20 41                      jsr  L_004120        ; A=[$56F2] X=$0002 Y=$0001 ; [SP-268]
; === End of while loop (counter: Y) ===

0057DE  20 B5 43                      jsr  L_0043B5        ; A=[$56F2] X=$0002 Y=$0001 ; [SP-270]
; === End of while loop (counter: Y) ===

0057E1  A9 00                         lda  #$00            ; A=$0000 X=$0002 Y=$0001 ; [SP-270]
0057E3  85 0C                         sta  $0C             ; A=$0000 X=$0002 Y=$0001 ; [SP-270]
0057E5  85 0D                         sta  $0D             ; A=$0000 X=$0002 Y=$0001 ; [SP-270]
0057E7  85 0E                         sta  $0E             ; A=$0000 X=$0002 Y=$0001 ; [SP-270]
0057E9  85 0F                         sta  $0F             ; A=$0000 X=$0002 Y=$0001 ; [SP-270]
0057EB  85 11                         sta  $11             ; A=$0000 X=$0002 Y=$0001 ; [SP-270]
0057ED  A9 F0                         lda  #$F0            ; A=$00F0 X=$0002 Y=$0001 ; [SP-270]
0057EF  85 2C                         sta  $2C             ; A=$00F0 X=$0002 Y=$0001 ; [SP-270]
0057F1  85 2D                         sta  $2D             ; A=$00F0 X=$0002 Y=$0001 ; [SP-270]
0057F3  85 2E                         sta  $2E             ; A=$00F0 X=$0002 Y=$0001 ; [SP-270]
0057F5  A9 03                         lda  #$03            ; A=$0003 X=$0002 Y=$0001 ; [SP-270]
0057F7  85 10                         sta  $10             ; A=$0003 X=$0002 Y=$0001 ; [SP-270]
0057F9  85 00                         sta  $00             ; A=$0003 X=$0002 Y=$0001 ; [SP-270]
0057FB  20 FC 42                      jsr  L_0042FC        ; A=$0003 X=$0002 Y=$0001 ; [SP-272]
; === End of while loop (counter: Y) ===


; === while loop starts here [nest:51] ===
0057FE  E6 00             L_0057FE    inc  $00             ; A=$0003 X=$0002 Y=$0001 ; [SP-272]
005800  C6 01                         dec  $01             ; A=$0003 X=$0002 Y=$0001 ; [SP-272]
005802  AD 00 C0                      lda  $C000           ; KBD - Keyboard data / 80STORE off {Keyboard} <keyboard_read>
005805  C9 8D                         cmp  #$8D            ; A=[$C000] X=$0002 Y=$0001 ; [SP-272]
005807  D0 F5                         bne  L_0057FE        ; A=[$C000] X=$0002 Y=$0001 ; [SP-272]
; === End of while loop ===


; === while loop starts here [nest:45] ===
005809  A9 03             L_005809    lda  #$03            ; A=$0003 X=$0002 Y=$0001 ; [SP-272]
00580B  85 10                         sta  $10             ; A=$0003 X=$0002 Y=$0001 ; [SP-272]
00580D  A9 05                         lda  #$05            ; A=$0005 X=$0002 Y=$0001 ; [SP-272]
00580F  85 3A                         sta  $3A             ; A=$0005 X=$0002 Y=$0001 ; [SP-272]
005811  20 73 4D                      jsr  L_004D73        ; A=$0005 X=$0002 Y=$0001 ; [SP-274]
; === End of while loop (counter: A) ===

005814  A9 00                         lda  #$00            ; A=$0000 X=$0002 Y=$0001 ; [SP-274]
005816  85 0C                         sta  $0C             ; A=$0000 X=$0002 Y=$0001 ; [SP-274]
005818  85 0D                         sta  $0D             ; A=$0000 X=$0002 Y=$0001 ; [SP-274]
00581A  85 11                         sta  $11             ; A=$0000 X=$0002 Y=$0001 ; [SP-274]
00581C  85 34                         sta  $34             ; A=$0000 X=$0002 Y=$0001 ; [SP-274]
00581E  85 36                         sta  $36             ; A=$0000 X=$0002 Y=$0001 ; [SP-274]
005820  20 87 43                      jsr  L_004387        ; Call $004387(A)
; === End of while loop (counter: A) ===

005823  A9 0B                         lda  #$0B            ; A=$000B X=$0002 Y=$0001 ; [SP-276]
005825  85 2B                         sta  $2B             ; A=$000B X=$0002 Y=$0001 ; [SP-276]
005827  85 30                         sta  $30             ; A=$000B X=$0002 Y=$0001 ; [SP-276]
005829  20 F3 56                      jsr  L_0056F3        ; A=$000B X=$0002 Y=$0001 ; [SP-278]
; === End of while loop (counter: Y) ===

00582C  20 70 53                      jsr  L_005370        ; Call $005370(1 stack)
; === End of while loop (counter: Y) ===

00582F  20 77 5B                      jsr  L_005B77        ; A=$000B X=$0002 Y=$0001 ; [SP-282]
005832  A9 05                         lda  #$05            ; A=$0005 X=$0002 Y=$0001 ; [SP-282]
005834  85 35                         sta  $35             ; A=$0005 X=$0002 Y=$0001 ; [SP-282]
005836  20 E5 52                      jsr  L_0052E5        ; A=$0005 X=$0002 Y=$0001 ; [SP-284]
; === End of while loop (counter: Y) ===


; === while loop starts here (counter: $00, range: 0..23792, step: 23795, iters: 102211631734003) [nest:3] [inner] ===
005839  A5 10             L_005839    lda  $10             ; A=[$0010] X=$0002 Y=$0001 ; [SP-284]
00583B  38                            sec                  ; A=[$0010] X=$0002 Y=$0001 ; [SP-284]
00583C  E9 01                         sbc  #$01            ; A=A-$01 X=$0002 Y=$0001 ; [SP-284]
00583E  10 06                         bpl  L_005846        ; A=A-$01 X=$0002 Y=$0001 ; [SP-284]
005840  20 86 4A                      jsr  L_004A86        ; A=A-$01 X=$0002 Y=$0001 ; [SP-286]
; === End of while loop (counter: Y) ===

005843  4C 09 58                      jmp  L_005809        ; A=A-$01 X=$0002 Y=$0001 ; [SP-286]
; === End of while loop ===

005846  85 10             L_005846    sta  $10             ; A=A-$01 X=$0002 Y=$0001 ; [SP-286]
005848  20 CD 43                      jsr  L_0043CD        ; A=A-$01 X=$0002 Y=$0001 ; [SP-288]
; === End of while loop (counter: Y) ===

00584B  20 3E 41                      jsr  L_00413E        ; A=A-$01 X=$0002 Y=$0001 ; [SP-290]
; === End of while loop (counter: Y) ===

00584E  A2 03                         ldx  #$03            ; A=A-$01 X=$0003 Y=$0001 ; [SP-290]
005850  A9 00                         lda  #$00            ; A=$0000 X=$0003 Y=$0001 ; [SP-290]

; === while loop starts here [nest:46] ===
005852  9D 58 5D          L_005852    sta  $5D58,X         ; -> $5D5B ; A=$0000 X=$0003 Y=$0001 ; [SP-290]
005855  9D 54 5D                      sta  $5D54,X         ; -> $5D57 ; A=$0000 X=$0003 Y=$0001 ; [SP-290]
005858  CA                            dex                  ; A=$0000 X=$0002 Y=$0001 ; [SP-290]
005859  10 F7                         bpl  L_005852        ; A=$0000 X=$0002 Y=$0001 ; [SP-290]
; === End of while loop ===

00585B  20 7A 43                      jsr  L_00437A        ; A=$0000 X=$0002 Y=$0001 ; [SP-292]
; === End of while loop (counter: $00) ===

00585E  20 4F 5B                      jsr  L_005B4F        ; A=$0000 X=$0002 Y=$0001 ; [SP-294]
005861  AD D3 57                      lda  $57D3           ; A=[$57D3] X=$0002 Y=$0001 ; [SP-294]
005864  8D D4 57                      sta  $57D4           ; A=[$57D3] X=$0002 Y=$0001 ; [SP-294]
005867  8D D5 57                      sta  $57D5           ; A=[$57D3] X=$0002 Y=$0001 ; [SP-294]
00586A  A9 F0                         lda  #$F0            ; A=$00F0 X=$0002 Y=$0001 ; [SP-294]
00586C  85 2C                         sta  $2C             ; A=$00F0 X=$0002 Y=$0001 ; [SP-294]
00586E  85 2D                         sta  $2D             ; A=$00F0 X=$0002 Y=$0001 ; [SP-294]
005870  85 2E                         sta  $2E             ; A=$00F0 X=$0002 Y=$0001 ; [SP-294]
005872  8D 10 C0                      sta  $C010           ; KBDSTRB - Clear keyboard strobe {Keyboard} <keyboard_strobe>

; === while loop starts here (counter: X 'iter_x') [nest:29] ===
005875  20 7F 45          L_005875    jsr  L_00457F        ; A=$00F0 X=$0002 Y=$0001 ; [SP-296]
; === End of while loop (counter: Y) ===

005878  20 F3 52                      jsr  L_0052F3        ; A=$00F0 X=$0002 Y=$0001 ; [SP-298]
; === End of while loop (counter: $00) ===

00587B  20 5B 4F                      jsr  L_004F5B        ; A=$00F0 X=$0002 Y=$0001 ; [SP-300]
; === End of while loop (counter: $00) ===

00587E  20 1C 5C                      jsr  L_005C1C        ; A=$00F0 X=$0002 Y=$0001 ; [SP-302]
005881  20 78 5C                      jsr  L_005C78        ; A=$00F0 X=$0002 Y=$0001 ; [SP-304]
005884  A5 36                         lda  $36             ; A=[$0036] X=$0002 Y=$0001 ; [SP-304]
005886  F0 09                         beq  L_005891        ; A=[$0036] X=$0002 Y=$0001 ; [SP-304]
005888  E6 01                         inc  $01             ; A=[$0036] X=$0002 Y=$0001 ; [SP-304]
00588A  A9 00                         lda  #$00            ; A=$0000 X=$0002 Y=$0001 ; [SP-304]
00588C  85 36                         sta  $36             ; A=$0000 X=$0002 Y=$0001 ; [SP-304]
00588E  4C A5 58                      jmp  L_0058A5        ; A=$0000 X=$0002 Y=$0001 ; [SP-304]
005891  AD 61 C0          L_005891    lda  $C061           ; BUTN0 - Button 0 / Open Apple {Joystick} <joystick_read>
005894  30 05                         bmi  L_00589B        ; A=[$C061] X=$0002 Y=$0001 ; [SP-304]
005896  85 2B                         sta  $2B             ; A=[$C061] X=$0002 Y=$0001 ; [SP-304]
005898  4C C3 58                      jmp  L_0058C3        ; A=[$C061] X=$0002 Y=$0001 ; [SP-304]
00589B  25 2B             L_00589B    and  $2B             ; A=[$C061] X=$0002 Y=$0001 ; [SP-304]
00589D  30 24                         bmi  L_0058C3        ; A=[$C061] X=$0002 Y=$0001 ; [SP-304]
00589F  E6 01                         inc  $01             ; A=[$C061] X=$0002 Y=$0001 ; [SP-304]
0058A1  A9 80                         lda  #$80            ; A=$0080 X=$0002 Y=$0001 ; [SP-304]
0058A3  85 2B                         sta  $2B             ; A=$0080 X=$0002 Y=$0001 ; [SP-304]
0058A5  A6 11             L_0058A5    ldx  $11             ; A=$0080 X=$0002 Y=$0001 ; [SP-304]
0058A7  BD 58 5D                      lda  $5D58,X         ; -> $5D5A ; A=$0080 X=$0002 Y=$0001 ; [SP-304]
0058AA  D0 17                         bne  L_0058C3        ; A=$0080 X=$0002 Y=$0001 ; [SP-304]
0058AC  A9 01                         lda  #$01            ; A=$0001 X=$0002 Y=$0001 ; [SP-304]
0058AE  9D 58 5D                      sta  $5D58,X         ; -> $5D5A ; A=$0001 X=$0002 Y=$0001 ; [SP-304]
0058B1  BD 68 5D                      lda  $5D68,X         ; -> $5D6A ; A=$0001 X=$0002 Y=$0001 ; [SP-304]
0058B4  9D 5C 5D                      sta  $5D5C,X         ; -> $5D5E ; A=$0001 X=$0002 Y=$0001 ; [SP-304]
0058B7  BD 6C 5D                      lda  $5D6C,X         ; -> $5D6E ; A=$0001 X=$0002 Y=$0001 ; [SP-304]
0058BA  9D 60 5D                      sta  $5D60,X         ; -> $5D62 ; A=$0001 X=$0002 Y=$0001 ; [SP-304]
0058BD  BD 70 5D                      lda  $5D70,X         ; -> $5D72 ; A=$0001 X=$0002 Y=$0001 ; [SP-304]
0058C0  9D 64 5D                      sta  $5D64,X         ; -> $5D66 ; A=$0001 X=$0002 Y=$0001 ; [SP-304]
0058C3  20 87 4D          L_0058C3    jsr  L_004D87        ; A=$0001 X=$0002 Y=$0001 ; [SP-306]
; === End of while loop (counter: $00) ===

0058C6  A2 03                         ldx  #$03            ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
0058C8  8E D6 57                      stx  $57D6           ; A=$0001 X=$0003 Y=$0001 ; [SP-306]

; === while loop starts here [nest:37] ===
0058CB  AE D6 57          L_0058CB    ldx  $57D6           ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
0058CE  BD 58 5D                      lda  $5D58,X         ; -> $5D5B ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
0058D1  F0 08                         beq  L_0058DB        ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
0058D3  BD 54 5D                      lda  $5D54,X         ; -> $5D57 ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
0058D6  F0 03                         beq  L_0058DB        ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
0058D8  4C DE 58                      jmp  L_0058DE        ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
0058DB  4C 6E 59          L_0058DB    jmp  L_00596E        ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
0058DE  E0 03             L_0058DE    cpx  #$03            ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
0058E0  F0 31                         beq  L_005913        ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
0058E2  E0 02                         cpx  #$02            ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
0058E4  F0 22                         beq  L_005908        ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
0058E6  E0 01                         cpx  #$01            ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
0058E8  F0 0B                         beq  L_0058F5        ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
0058EA  BD 64 5D                      lda  $5D64,X         ; -> $5D67 ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
0058ED  DD 50 5D                      cmp  $5D50,X         ; -> $5D53 ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
0058F0  90 2C                         bcc  L_00591E        ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
0058F2  4C 6E 59                      jmp  L_00596E        ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
0058F5  BD 60 5D          L_0058F5    lda  $5D60,X         ; -> $5D63 ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
0058F8  DD 4C 5D                      cmp  $5D4C,X         ; -> $5D4F ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
0058FB  90 71                         bcc  L_00596E        ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
0058FD  BD 5C 5D                      lda  $5D5C,X         ; -> $5D5F ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
005900  DD 48 5D                      cmp  $5D48,X         ; -> $5D4B ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
005903  90 69                         bcc  L_00596E        ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
005905  4C 1E 59                      jmp  L_00591E        ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
005908  BD 64 5D          L_005908    lda  $5D64,X         ; -> $5D67 ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
00590B  DD 50 5D                      cmp  $5D50,X         ; -> $5D53 ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
00590E  B0 0E                         bcs  L_00591E        ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
005910  4C 6E 59                      jmp  L_00596E        ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
005913  BD 5C 5D          L_005913    lda  $5D5C,X         ; -> $5D5F ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
005916  DD 48 5D                      cmp  $5D48,X         ; -> $5D4B ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
005919  90 03                         bcc  L_00591E        ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
00591B  4C 6E 59                      jmp  L_00596E        ; A=$0001 X=$0003 Y=$0001 ; [SP-306]
00591E  20 C4 44          L_00591E    jsr  L_0044C4        ; A=$0001 X=$0003 Y=$0001 ; [SP-308]
; === End of while loop (counter: Y) ===

005921  AE D6 57                      ldx  $57D6           ; A=$0001 X=$0003 Y=$0001 ; [SP-308]
005924  20 41 44                      jsr  L_004441        ; A=$0001 X=$0003 Y=$0001 ; [SP-310]
; === End of while loop (counter: Y) ===

005927  AE D6 57                      ldx  $57D6           ; A=$0001 X=$0003 Y=$0001 ; [SP-310]
00592A  BD 54 5D                      lda  $5D54,X         ; -> $5D57 ; A=$0001 X=$0003 Y=$0001 ; [SP-310]
00592D  C9 02                         cmp  #$02            ; A=$0001 X=$0003 Y=$0001 ; [SP-310]
00592F  D0 09                         bne  L_00593A        ; A=$0001 X=$0003 Y=$0001 ; [SP-310]
005931  20 65 4B                      jsr  L_004B65        ; A=$0001 X=$0003 Y=$0001 ; [SP-312]
; === End of while loop (counter: Y) ===

005934  AE D6 57                      ldx  $57D6           ; A=$0001 X=$0003 Y=$0001 ; [SP-312]
005937  4C 54 59                      jmp  L_005954        ; A=$0001 X=$0003 Y=$0001 ; [SP-312]
00593A  C9 03             L_00593A    cmp  #$03            ; A=$0001 X=$0003 Y=$0001 ; [SP-312]
00593C  D0 16                         bne  L_005954        ; A=$0001 X=$0003 Y=$0001 ; [SP-312]
00593E  AE D6 57                      ldx  $57D6           ; A=$0001 X=$0003 Y=$0001 ; [SP-312]
005941  A9 02                         lda  #$02            ; A=$0002 X=$0003 Y=$0001 ; [SP-312]
005943  9D 54 5D                      sta  $5D54,X         ; -> $5D57 ; A=$0002 X=$0003 Y=$0001 ; [SP-312]
005946  20 99 44                      jsr  L_004499        ; A=$0002 X=$0003 Y=$0001 ; [SP-314]
; === End of while loop (counter: Y) ===

005949  A9 00                         lda  #$00            ; A=$0000 X=$0003 Y=$0001 ; [SP-314]
00594B  AE D6 57                      ldx  $57D6           ; A=$0000 X=$0003 Y=$0001 ; [SP-314]
00594E  9D 58 5D                      sta  $5D58,X         ; -> $5D5B ; A=$0000 X=$0003 Y=$0001 ; [SP-314]
005951  4C 5C 59                      jmp  L_00595C        ; A=$0000 X=$0003 Y=$0001 ; [SP-314]
005954  A9 00             L_005954    lda  #$00            ; A=$0000 X=$0003 Y=$0001 ; [SP-314]
005956  9D 54 5D                      sta  $5D54,X         ; -> $5D57 ; A=$0000 X=$0003 Y=$0001 ; [SP-314]
005959  9D 58 5D                      sta  $5D58,X         ; -> $5D5B ; A=$0000 X=$0003 Y=$0001 ; [SP-314]
00595C  A9 01             L_00595C    lda  #$01            ; A=$0001 X=$0003 Y=$0001 ; [SP-314]
00595E  20 E0 4A                      jsr  L_004AE0        ; A=$0001 X=$0003 Y=$0001 ; [SP-316]
; === End of while loop (counter: Y) ===

005961  A0 14                         ldy  #$14            ; A=$0001 X=$0003 Y=$0014 ; [SP-316]
005963  A9 C4                         lda  #$C4            ; A=$00C4 X=$0003 Y=$0014 ; [SP-316]
005965  8D 67 5B                      sta  $5B67           ; A=$00C4 X=$0003 Y=$0014 ; [SP-316]
005968  20 62 5B                      jsr  L_005B62        ; A=$00C4 X=$0003 Y=$0014 ; [SP-318]
00596B  20 4F 5B                      jsr  L_005B4F        ; A=$00C4 X=$0003 Y=$0014 ; [SP-320]
00596E  CE D6 57          L_00596E    dec  $57D6           ; A=$00C4 X=$0003 Y=$0014 ; [SP-320]
005971  30 03                         bmi  L_005976        ; A=$00C4 X=$0003 Y=$0014 ; [SP-320]
005973  4C CB 58                      jmp  L_0058CB        ; A=$00C4 X=$0003 Y=$0014 ; [SP-320]
; === End of while loop ===

005976  A2 03             L_005976    ldx  #$03            ; A=$00C4 X=$0003 Y=$0014 ; [SP-320]
005978  86 12                         stx  $12             ; A=$00C4 X=$0003 Y=$0014 ; [SP-320]

; === while loop starts here [nest:36] ===
00597A  A6 12             L_00597A    ldx  $12             ; A=$00C4 X=$0003 Y=$0014 ; [SP-320]
00597C  BD 58 5D                      lda  $5D58,X         ; -> $5D5B ; A=$00C4 X=$0003 Y=$0014 ; [SP-320]
00597F  F0 41                         beq  L_0059C2        ; A=$00C4 X=$0003 Y=$0014 ; [SP-320]
005981  E0 03                         cpx  #$03            ; A=$00C4 X=$0003 Y=$0014 ; [SP-320]
005983  F0 29                         beq  L_0059AE        ; A=$00C4 X=$0003 Y=$0014 ; [SP-320]
005985  E0 02                         cpx  #$02            ; A=$00C4 X=$0003 Y=$0014 ; [SP-320]
005987  F0 1B                         beq  L_0059A4        ; A=$00C4 X=$0003 Y=$0014 ; [SP-320]
005989  E0 01                         cpx  #$01            ; A=$00C4 X=$0003 Y=$0014 ; [SP-320]
00598B  F0 08                         beq  L_005995        ; A=$00C4 X=$0003 Y=$0014 ; [SP-320]
00598D  BD 64 5D                      lda  $5D64,X         ; -> $5D67 ; A=$00C4 X=$0003 Y=$0014 ; [SP-320]
005990  F0 23                         beq  L_0059B5        ; A=$00C4 X=$0003 Y=$0014 ; [SP-320]
005992  4C C2 59                      jmp  L_0059C2        ; A=$00C4 X=$0003 Y=$0014 ; [SP-320]
005995  BD 5C 5D          L_005995    lda  $5D5C,X         ; -> $5D5F ; A=$00C4 X=$0003 Y=$0014 ; [SP-320]
005998  C9 16                         cmp  #$16            ; A=$00C4 X=$0003 Y=$0014 ; [SP-320]
00599A  BD 60 5D                      lda  $5D60,X         ; -> $5D63 ; A=$00C4 X=$0003 Y=$0014 ; [SP-320]
00599D  E9 01                         sbc  #$01            ; A=A-$01 X=$0003 Y=$0014 ; [SP-320]
00599F  B0 14                         bcs  L_0059B5        ; A=A-$01 X=$0003 Y=$0014 ; [SP-320]
0059A1  4C C2 59                      jmp  L_0059C2        ; A=A-$01 X=$0003 Y=$0014 ; [SP-320]
0059A4  BD 64 5D          L_0059A4    lda  $5D64,X         ; -> $5D67 ; A=A-$01 X=$0003 Y=$0014 ; [SP-320]
0059A7  C9 BF                         cmp  #$BF            ; A=A-$01 X=$0003 Y=$0014 ; [SP-320]
0059A9  F0 0A                         beq  L_0059B5        ; A=A-$01 X=$0003 Y=$0014 ; [SP-320]
0059AB  4C C2 59                      jmp  L_0059C2        ; A=A-$01 X=$0003 Y=$0014 ; [SP-320]
0059AE  BD 5C 5D          L_0059AE    lda  $5D5C,X         ; -> $5D5F ; A=A-$01 X=$0003 Y=$0014 ; [SP-320]
0059B1  C9 3E                         cmp  #$3E            ; A=A-$01 X=$0003 Y=$0014 ; [SP-320]
0059B3  D0 0D                         bne  L_0059C2        ; A=A-$01 X=$0003 Y=$0014 ; [SP-320]
0059B5  20 41 44          L_0059B5    jsr  L_004441        ; A=A-$01 X=$0003 Y=$0014 ; [SP-322]
; === End of while loop (counter: Y) ===

0059B8  20 4F 5B                      jsr  L_005B4F        ; A=A-$01 X=$0003 Y=$0014 ; [SP-324]
0059BB  A6 12                         ldx  $12             ; A=A-$01 X=$0003 Y=$0014 ; [SP-324]
0059BD  A9 00                         lda  #$00            ; A=$0000 X=$0003 Y=$0014 ; [SP-324]
0059BF  9D 58 5D                      sta  $5D58,X         ; -> $5D5B ; A=$0000 X=$0003 Y=$0014 ; [SP-324]
0059C2  C6 12             L_0059C2    dec  $12             ; A=$0000 X=$0003 Y=$0014 ; [SP-324]
0059C4  10 B4                         bpl  L_00597A        ; A=$0000 X=$0003 Y=$0014 ; [SP-324]
; === End of while loop ===

0059C6  A6 11                         ldx  $11             ; A=$0000 X=$0003 Y=$0014 ; [SP-324]
0059C8  20 E0 43                      jsr  L_0043E0        ; A=$0000 X=$0003 Y=$0014 ; [SP-326]
; === End of while loop (counter: Y) ===

0059CB  E4 11                         cpx  $11             ; A=$0000 X=$0003 Y=$0014 ; [SP-326]
0059CD  D0 03                         bne  L_0059D2        ; A=$0000 X=$0003 Y=$0014 ; [SP-326]
0059CF  4C E8 59                      jmp  L_0059E8        ; A=$0000 X=$0003 Y=$0014 ; [SP-326]
0059D2  BD 34 5D          L_0059D2    lda  $5D34,X         ; -> $5D37 ; A=$0000 X=$0003 Y=$0014 ; [SP-326]
0059D5  85 02                         sta  $02             ; A=$0000 X=$0003 Y=$0014 ; [SP-326]
0059D7  BD 38 5D                      lda  $5D38,X         ; -> $5D3B ; A=$0000 X=$0003 Y=$0014 ; [SP-326]
0059DA  85 04                         sta  $04             ; A=$0000 X=$0003 Y=$0014 ; [SP-326]
0059DC  8A                            txa                  ; A=$0003 X=$0003 Y=$0014 ; [SP-326]
0059DD  18                            clc                  ; A=$0003 X=$0003 Y=$0014 ; [SP-326]
0059DE  69 0B                         adc  #$0B            ; A=A+$0B X=$0003 Y=$0014 ; [SP-326]
0059E0  20 C0 40                      jsr  L_0040C0        ; A=A+$0B X=$0003 Y=$0014 ; [SP-328]
; === End of while loop (counter: X) ===

0059E3  20 4F 5B                      jsr  L_005B4F        ; A=A+$0B X=$0003 Y=$0014 ; [SP-330]
0059E6  E6 01                         inc  $01             ; A=A+$0B X=$0003 Y=$0014 ; [SP-330]
0059E8  20 91 55          L_0059E8    jsr  L_005591        ; A=A+$0B X=$0003 Y=$0014 ; [SP-332]
; === End of while loop (counter: X) ===

0059EB  20 E3 55                      jsr  L_0055E3        ; A=A+$0B X=$0003 Y=$0014 ; [SP-334]
; === End of while loop (counter: X) ===

0059EE  EE CD 57                      inc  $57CD           ; A=A+$0B X=$0003 Y=$0014 ; [SP-334]
0059F1  D0 11                         bne  L_005A04        ; A=A+$0B X=$0003 Y=$0014 ; [SP-334]
0059F3  EE CE 57                      inc  $57CE           ; A=A+$0B X=$0003 Y=$0014 ; [SP-334]
0059F6  D0 0C                         bne  L_005A04        ; A=A+$0B X=$0003 Y=$0014 ; [SP-334]
0059F8  AD CC 57                      lda  $57CC           ; A=[$57CC] X=$0003 Y=$0014 ; [SP-334]
0059FB  8D CD 57                      sta  $57CD           ; A=[$57CC] X=$0003 Y=$0014 ; [SP-334]
0059FE  8D CE 57                      sta  $57CE           ; A=[$57CC] X=$0003 Y=$0014 ; [SP-334]
005A01  20 C9 56                      jsr  L_0056C9        ; A=[$57CC] X=$0003 Y=$0014 ; [SP-336]
; === End of while loop (counter: X) ===

005A04  E6 2E             L_005A04    inc  $2E             ; A=[$57CC] X=$0003 Y=$0014 ; [SP-336]
005A06  D0 52                         bne  L_005A5A        ; A=[$57CC] X=$0003 Y=$0014 ; [SP-336]
005A08  A5 2F                         lda  $2F             ; A=[$002F] X=$0003 Y=$0014 ; [SP-336]
005A0A  85 2E                         sta  $2E             ; A=[$002F] X=$0003 Y=$0014 ; [SP-336]
005A0C  20 0E 45                      jsr  L_00450E        ; Call $00450E(A)
; === End of while loop (counter: X) ===

005A0F  A2 03                         ldx  #$03            ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A11  86 12                         stx  $12             ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]

; === while loop starts here [nest:30] ===
005A13  A6 12             L_005A13    ldx  $12             ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A15  BD 54 5D                      lda  $5D54,X         ; -> $5D57 ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A18  F0 3C                         beq  L_005A56        ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A1A  E0 03                         cpx  #$03            ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A1C  F0 1C                         beq  L_005A3A        ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A1E  E0 02                         cpx  #$02            ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A20  F0 0E                         beq  L_005A30        ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A22  E0 01                         cpx  #$01            ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A24  F0 1E                         beq  L_005A44        ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A26  BD 50 5D                      lda  $5D50,X         ; -> $5D53 ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A29  C9 52                         cmp  #$52            ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A2B  B0 30                         bcs  L_005A5D        ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A2D  4C 56 5A                      jmp  L_005A56        ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A30  BD 50 5D          L_005A30    lda  $5D50,X         ; -> $5D53 ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A33  C9 6B                         cmp  #$6B            ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A35  90 26                         bcc  L_005A5D        ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A37  4C 56 5A                      jmp  L_005A56        ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A3A  BD 48 5D          L_005A3A    lda  $5D48,X         ; -> $5D4B ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A3D  C9 9B                         cmp  #$9B            ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A3F  90 15                         bcc  L_005A56        ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A41  4C 5D 5A                      jmp  L_005A5D        ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A44  BD 48 5D          L_005A44    lda  $5D48,X         ; -> $5D4B ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A47  C9 B6                         cmp  #$B6            ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A49  90 03                         bcc  L_005A4E        ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A4B  4C 56 5A                      jmp  L_005A56        ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A4E  BD 4C 5D          L_005A4E    lda  $5D4C,X         ; -> $5D4F ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A51  D0 03                         bne  L_005A56        ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A53  4C 5D 5A                      jmp  L_005A5D        ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]

; === while loop starts here [nest:23] ===
005A56  C6 12             L_005A56    dec  $12             ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A58  10 B9                         bpl  L_005A13        ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
; === End of while loop ===

005A5A  4C 75 58          L_005A5A    jmp  L_005875        ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
; === End of while loop (counter: X) ===

005A5D  BD 54 5D          L_005A5D    lda  $5D54,X         ; -> $5D57 ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A60  C9 02                         cmp  #$02            ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A62  D0 18                         bne  L_005A7C        ; A=[$002F] X=$0003 Y=$0014 ; [SP-338]
005A64  20 C4 44                      jsr  L_0044C4        ; A=[$002F] X=$0003 Y=$0014 ; [SP-340]
; === End of while loop (counter: X) ===

005A67  A6 12                         ldx  $12             ; A=[$002F] X=$0003 Y=$0014 ; [SP-340]
005A69  A9 00                         lda  #$00            ; A=$0000 X=$0003 Y=$0014 ; [SP-340]
005A6B  9D 54 5D                      sta  $5D54,X         ; -> $5D57 ; A=$0000 X=$0003 Y=$0014 ; [SP-340]
005A6E  20 7A 43                      jsr  L_00437A        ; A=$0000 X=$0003 Y=$0014 ; [SP-342]
; === End of while loop (counter: X) ===

005A71  20 4F 5B                      jsr  L_005B4F        ; A=$0000 X=$0003 Y=$0014 ; [SP-344]
005A74  A9 05                         lda  #$05            ; A=$0005 X=$0003 Y=$0014 ; [SP-344]
005A76  20 E0 4A                      jsr  L_004AE0        ; A=$0005 X=$0003 Y=$0014 ; [SP-346]
; === End of while loop (counter: X) ===

005A79  4C 56 5A                      jmp  L_005A56        ; A=$0005 X=$0003 Y=$0014 ; [SP-346]
; === End of while loop ===

005A7C  C9 03             L_005A7C    cmp  #$03            ; A=$0005 X=$0003 Y=$0014 ; [SP-346]
005A7E  D0 1A                         bne  L_005A9A        ; A=$0005 X=$0003 Y=$0014 ; [SP-346]
005A80  8E D6 57                      stx  $57D6           ; A=$0005 X=$0003 Y=$0014 ; [SP-346]
005A83  20 C4 44                      jsr  L_0044C4        ; A=$0005 X=$0003 Y=$0014 ; [SP-348]
; === End of while loop (counter: X) ===

005A86  AE D6 57                      ldx  $57D6           ; A=$0005 X=$0003 Y=$0014 ; [SP-348]
005A89  A9 00                         lda  #$00            ; A=$0000 X=$0003 Y=$0014 ; [SP-348]
005A8B  9D 54 5D                      sta  $5D54,X         ; -> $5D57 ; A=$0000 X=$0003 Y=$0014 ; [SP-348]
005A8E  20 7A 43                      jsr  L_00437A        ; A=$0000 X=$0003 Y=$0014 ; [SP-350]
; === End of while loop (counter: X) ===

005A91  20 4F 5B                      jsr  L_005B4F        ; A=$0000 X=$0003 Y=$0014 ; [SP-352]
005A94  20 65 4B                      jsr  L_004B65        ; A=$0000 X=$0003 Y=$0014 ; [SP-354]
; === End of while loop (counter: X) ===

005A97  4C 56 5A                      jmp  L_005A56        ; A=$0000 X=$0003 Y=$0014 ; [SP-354]
; === End of while loop ===

005A9A  A2 03             L_005A9A    ldx  #$03            ; A=$0000 X=$0003 Y=$0014 ; [SP-354]
005A9C  86 12                         stx  $12             ; A=$0000 X=$0003 Y=$0014 ; [SP-354]

; === while loop starts here [nest:22] ===
005A9E  A6 12             L_005A9E    ldx  $12             ; A=$0000 X=$0003 Y=$0014 ; [SP-354]
005AA0  BD 54 5D                      lda  $5D54,X         ; -> $5D57 ; A=$0000 X=$0003 Y=$0014 ; [SP-354]
005AA3  F0 03                         beq  L_005AA8        ; A=$0000 X=$0003 Y=$0014 ; [SP-354]
005AA5  20 C4 44                      jsr  L_0044C4        ; A=$0000 X=$0003 Y=$0014 ; [SP-356]
; === End of while loop (counter: X) ===

005AA8  C6 12             L_005AA8    dec  $12             ; A=$0000 X=$0003 Y=$0014 ; [SP-356]
005AAA  10 F2                         bpl  L_005A9E        ; A=$0000 X=$0003 Y=$0014 ; [SP-356]
; === End of while loop ===

005AAC  A6 11                         ldx  $11             ; A=$0000 X=$0003 Y=$0014 ; [SP-356]
005AAE  BD 34 5D                      lda  $5D34,X         ; -> $5D37 ; A=$0000 X=$0003 Y=$0014 ; [SP-356]
005AB1  85 02                         sta  $02             ; A=$0000 X=$0003 Y=$0014 ; [SP-356]
005AB3  BD 38 5D                      lda  $5D38,X         ; -> $5D3B ; A=$0000 X=$0003 Y=$0014 ; [SP-356]
005AB6  85 04                         sta  $04             ; A=$0000 X=$0003 Y=$0014 ; [SP-356]
005AB8  8A                            txa                  ; A=$0003 X=$0003 Y=$0014 ; [SP-356]
005AB9  18                            clc                  ; A=$0003 X=$0003 Y=$0014 ; [SP-356]
005ABA  69 0B                         adc  #$0B            ; A=A+$0B X=$0003 Y=$0014 ; [SP-356]
005ABC  20 C0 40                      jsr  L_0040C0        ; A=A+$0B X=$0003 Y=$0014 ; [SP-358]
; === End of while loop (counter: X) ===

005ABF  A9 56                         lda  #$56            ; A=$0056 X=$0003 Y=$0014 ; [SP-358]
005AC1  85 04                         sta  $04             ; A=$0056 X=$0003 Y=$0014 ; [SP-358]
005AC3  A9 17                         lda  #$17            ; A=$0017 X=$0003 Y=$0014 ; [SP-358]
005AC5  85 02                         sta  $02             ; A=$0017 X=$0003 Y=$0014 ; [SP-358]
005AC7  A9 18                         lda  #$18            ; A=$0018 X=$0003 Y=$0014 ; [SP-358]
005AC9  20 C0 40                      jsr  L_0040C0        ; A=$0018 X=$0003 Y=$0014 ; [SP-360]
; === End of while loop (counter: X) ===

005ACC  A2 03                         ldx  #$03            ; A=$0018 X=$0003 Y=$0014 ; [SP-360]
005ACE  86 12                         stx  $12             ; A=$0018 X=$0003 Y=$0014 ; [SP-360]

; === while loop starts here [nest:19] ===
005AD0  A6 12             L_005AD0    ldx  $12             ; A=$0018 X=$0003 Y=$0014 ; [SP-360]
005AD2  BD 58 5D                      lda  $5D58,X         ; -> $5D5B ; A=$0018 X=$0003 Y=$0014 ; [SP-360]
005AD5  F0 03                         beq  L_005ADA        ; A=$0018 X=$0003 Y=$0014 ; [SP-360]
005AD7  20 41 44                      jsr  L_004441        ; A=$0018 X=$0003 Y=$0014 ; [SP-362]
; === End of while loop (counter: X) ===

005ADA  C6 12             L_005ADA    dec  $12             ; A=$0018 X=$0003 Y=$0014 ; [SP-362]
005ADC  10 F2                         bpl  L_005AD0        ; A=$0018 X=$0003 Y=$0014 ; [SP-362]
; === End of while loop ===

005ADE  A2 03                         ldx  #$03            ; A=$0018 X=$0003 Y=$0014 ; [SP-362]
005AE0  86 12                         stx  $12             ; A=$0018 X=$0003 Y=$0014 ; [SP-362]

; === while loop starts here [nest:19] ===
005AE2  A9 D0             L_005AE2    lda  #$D0            ; A=$00D0 X=$0003 Y=$0014 ; [SP-362]
005AE4  85 2C                         sta  $2C             ; A=$00D0 X=$0003 Y=$0014 ; [SP-362]
005AE6  85 2D                         sta  $2D             ; A=$00D0 X=$0003 Y=$0014 ; [SP-362]

; === while loop starts here [nest:20] ===
005AE8  A9 56             L_005AE8    lda  #$56            ; A=$0056 X=$0003 Y=$0014 ; [SP-362]
005AEA  85 04                         sta  $04             ; A=$0056 X=$0003 Y=$0014 ; [SP-362]
005AEC  A9 17                         lda  #$17            ; A=$0017 X=$0003 Y=$0014 ; [SP-362]
005AEE  85 02                         sta  $02             ; A=$0017 X=$0003 Y=$0014 ; [SP-362]
005AF0  A5 12                         lda  $12             ; A=[$0012] X=$0003 Y=$0014 ; [SP-362]
005AF2  29 03                         and  #$03            ; A=A&$03 X=$0003 Y=$0014 ; [SP-362]
005AF4  18                            clc                  ; A=A&$03 X=$0003 Y=$0014 ; [SP-362]
005AF5  69 26                         adc  #$26            ; A=A+$26 X=$0003 Y=$0014 ; [SP-362]
005AF7  20 16 04                      jsr  $0416           ; A=A+$26 X=$0003 Y=$0014 ; [SP-364]
005AFA  20 1C 5C                      jsr  L_005C1C        ; A=A+$26 X=$0003 Y=$0014 ; [SP-366]
005AFD  A0 80                         ldy  #$80            ; A=A+$26 X=$0003 Y=$0080 ; [SP-366]
005AFF  A9 F2                         lda  #$F2            ; A=$00F2 X=$0003 Y=$0080 ; [SP-366]
005B01  8D 67 5B                      sta  $5B67           ; A=$00F2 X=$0003 Y=$0080 ; [SP-366]
005B04  20 62 5B                      jsr  L_005B62        ; A=$00F2 X=$0003 Y=$0080 ; [SP-368]
005B07  C6 2C                         dec  $2C             ; A=$00F2 X=$0003 Y=$0080 ; [SP-368]
005B09  10 DD                         bpl  L_005AE8        ; A=$00F2 X=$0003 Y=$0080 ; [SP-368]
; === End of while loop ===

005B0B  C6 2D                         dec  $2D             ; A=$00F2 X=$0003 Y=$0080 ; [SP-368]
005B0D  10 D9                         bpl  L_005AE8        ; A=$00F2 X=$0003 Y=$0080 ; [SP-368]
; === End of while loop ===

005B0F  C6 12                         dec  $12             ; A=$00F2 X=$0003 Y=$0080 ; [SP-368]
005B11  10 CF                         bpl  L_005AE2        ; A=$00F2 X=$0003 Y=$0080 ; [SP-368]
; === End of while loop ===

005B13  A5 10                         lda  $10             ; A=[$0010] X=$0003 Y=$0080 ; [SP-368]
005B15  D0 1D                         bne  L_005B34        ; A=[$0010] X=$0003 Y=$0080 ; [SP-368]
005B17  A9 56                         lda  #$56            ; A=$0056 X=$0003 Y=$0080 ; [SP-368]
005B19  85 04                         sta  $04             ; A=$0056 X=$0003 Y=$0080 ; [SP-368]
005B1B  A9 17                         lda  #$17            ; A=$0017 X=$0003 Y=$0080 ; [SP-368]
005B1D  85 02                         sta  $02             ; A=$0017 X=$0003 Y=$0080 ; [SP-368]
005B1F  A9 26                         lda  #$26            ; A=$0026 X=$0003 Y=$0080 ; [SP-368]
005B21  20 C0 40                      jsr  L_0040C0        ; A=$0026 X=$0003 Y=$0080 ; [SP-370]
; === End of while loop (counter: X) ===

005B24  A9 56                         lda  #$56            ; A=$0056 X=$0003 Y=$0080 ; [SP-370]
005B26  85 04                         sta  $04             ; A=$0056 X=$0003 Y=$0080 ; [SP-370]
005B28  A9 17                         lda  #$17            ; A=$0017 X=$0003 Y=$0080 ; [SP-370]
005B2A  85 02                         sta  $02             ; A=$0017 X=$0003 Y=$0080 ; [SP-370]
005B2C  A9 90                         lda  #$90            ; A=$0090 X=$0003 Y=$0080 ; [SP-370]
005B2E  20 16 04                      jsr  $0416           ; A=$0090 X=$0003 Y=$0080 ; [SP-372]
005B31  4C 39 58                      jmp  L_005839        ; A=$0090 X=$0003 Y=$0080 ; [SP-372]
; === End of while loop (counter: X) ===

005B34  A9 00             L_005B34    lda  #$00            ; A=$0000 X=$0003 Y=$0080 ; [SP-372]
005B36  85 2C                         sta  $2C             ; A=$0000 X=$0003 Y=$0080 ; [SP-372]
005B38  A9 19                         lda  #$19            ; A=$0019 X=$0003 Y=$0080 ; [SP-372]
005B3A  85 2D                         sta  $2D             ; A=$0019 X=$0003 Y=$0080 ; [SP-372]

; === while loop starts here [nest:17] ===
005B3C  A9 0A             L_005B3C    lda  #$0A            ; A=$000A X=$0003 Y=$0080 ; [SP-372]
005B3E  20 6C 5C                      jsr  L_005C6C        ; A=$000A X=$0003 Y=$0080 ; [SP-374]
005B41  20 1C 5C                      jsr  L_005C1C        ; A=$000A X=$0003 Y=$0080 ; [SP-376]
005B44  C6 2C                         dec  $2C             ; A=$000A X=$0003 Y=$0080 ; [SP-376]
005B46  D0 F4                         bne  L_005B3C        ; A=$000A X=$0003 Y=$0080 ; [SP-376]
; === End of while loop ===

005B48  C6 2D                         dec  $2D             ; A=$000A X=$0003 Y=$0080 ; [SP-376]
005B4A  D0 F0                         bne  L_005B3C        ; A=$000A X=$0003 Y=$0080 ; [SP-376]
; === End of while loop ===

005B4C  4C 39 58                      jmp  L_005839        ; A=$000A X=$0003 Y=$0080 ; [SP-376]
; === End of while loop (counter: X) ===


; === while loop starts here (counter: $00, range: 0..21103, step: 21105, iters: 90473486111293) [nest:8] [inner] ===

; FUNC $005B4F: register -> A:X [L]
; Proto: uint32_t func_005B4F(uint16_t param_Y);
; Liveness: params(Y) returns(A,X,Y) [3 dead stores]
005B4F  A6 11             L_005B4F    ldx  $11             ; A=$000A X=$0003 Y=$0080 ; [SP-376]
005B51  BD 34 5D                      lda  $5D34,X         ; -> $5D37 ; A=$000A X=$0003 Y=$0080 ; [SP-376]
005B54  85 02                         sta  $02             ; A=$000A X=$0003 Y=$0080 ; [SP-376]
005B56  BD 38 5D                      lda  $5D38,X         ; -> $5D3B ; A=$000A X=$0003 Y=$0080 ; [SP-376]
005B59  85 04                         sta  $04             ; A=$000A X=$0003 Y=$0080 ; [SP-376]
005B5B  8A                            txa                  ; A=$0003 X=$0003 Y=$0080 ; [SP-376]
005B5C  18                            clc                  ; A=$0003 X=$0003 Y=$0080 ; [SP-376]
005B5D  69 0B                         adc  #$0B            ; A=A+$0B X=$0003 Y=$0080 ; [SP-376]
005B5F  4C 62 04                      jmp  $0462           ; A=A+$0B X=$0003 Y=$0080 ; [SP-376]

; === loop starts here (counter: Y, range: 0..18967, iters: 71347996737762) [nest:17] [inner] ===

; FUNC $005B62: register -> A:X []
; Proto: uint32_t func_005B62(uint16_t param_X, uint16_t param_Y);
; Liveness: params(X,Y) returns(A,X,Y) [1 dead stores]
005B62  98                L_005B62    tya                  ; A=$0080 X=$0003 Y=$0080 ; [SP-376]
005B63  20 6F 5B                      jsr  L_005B6F        ; A=$0080 X=$0003 Y=$0080 ; [SP-378]
005B66  49 FF                         eor  #$FF            ; A=A^$FF X=$0003 Y=$0080 ; [SP-378]
005B68  20 6F 5B                      jsr  L_005B6F        ; Call $005B6F(1 stack)
005B6B  88                            dey                  ; A=A^$FF X=$0003 Y=$007F ; [SP-380]
005B6C  D0 F4                         bne  L_005B62        ; A=A^$FF X=$0003 Y=$007F ; [SP-380]
; === End of loop (counter: Y) ===

005B6E  60                            rts                  ; A=A^$FF X=$0003 Y=$007F ; [SP-378]

; FUNC $005B6F: register -> A:X [L]
; Proto: uint32_t func_005B6F(uint16_t param_A, uint16_t param_Y);
; Liveness: params(A,Y) returns(A,X,Y)
005B6F  AA                L_005B6F    tax                  ; A=A^$FF X=A Y=$007F ; [SP-378]

; === loop starts here (counter: X, range: 0..18727, iters: 81518479297058) [nest:18] [inner] ===
005B70  CA                L_005B70    dex                  ; A=A^$FF X=X-$01 Y=$007F ; [SP-378]
005B71  D0 FD                         bne  L_005B70        ; A=A^$FF X=X-$01 Y=$007F ; [SP-378]
; === End of loop (counter: X) ===

005B73  2C 30 C0                      bit  $C030           ; SPKR - Speaker toggle {Speaker} <speaker_toggle>
005B76  60                            rts                  ; A=A^$FF X=X-$01 Y=$007F ; [SP-376]

; FUNC $005B77: register -> A:X []
; Proto: uint32_t func_005B77(uint16_t param_Y);
; Liveness: params(Y) returns(A,X,Y) [4 dead stores]
005B77  A2 1F             L_005B77    ldx  #$1F            ; A=A^$FF X=$001F Y=$007F ; [SP-376]

; === while loop starts here [nest:18] ===
005B79  20 03 04          L_005B79    jsr  $0403           ; A=A^$FF X=$001F Y=$007F ; [SP-378]
005B7C  29 1F                         and  #$1F            ; A=A&$1F X=$001F Y=$007F ; [SP-378]
005B7E  18                            clc                  ; A=A&$1F X=$001F Y=$007F ; [SP-378]
005B7F  69 01                         adc  #$01            ; A=A+$01 X=$001F Y=$007F ; [SP-378]
005B81  29 1F                         and  #$1F            ; A=A&$1F X=$001F Y=$007F ; [SP-378]
005B83  F0 F4                         beq  L_005B79        ; A=A&$1F X=$001F Y=$007F ; [SP-378]
; === End of while loop ===

005B85  18                            clc                  ; A=A&$1F X=$001F Y=$007F ; [SP-378]
005B86  69 08                         adc  #$08            ; A=A+$08 X=$001F Y=$007F ; [SP-378]
005B88  9D B4 5B                      sta  $5BB4,X         ; -> $5BD3 ; A=A+$08 X=$001F Y=$007F ; [SP-378]

; === while loop starts here [nest:20] ===
005B8B  20 03 04          L_005B8B    jsr  $0403           ; A=A+$08 X=$001F Y=$007F ; [SP-380]
005B8E  C9 C0                         cmp  #$C0            ; A=A+$08 X=$001F Y=$007F ; [SP-380]
005B90  B0 F9                         bcs  L_005B8B        ; A=A+$08 X=$001F Y=$007F ; [SP-380]
; === End of while loop ===

005B92  9D D4 5B                      sta  $5BD4,X         ; -> $5BF3 ; A=A+$08 X=$001F Y=$007F ; [SP-380]
005B95  C9 50                         cmp  #$50            ; A=A+$08 X=$001F Y=$007F ; [SP-380]
005B97  90 0F                         bcc  L_005BA8        ; A=A+$08 X=$001F Y=$007F ; [SP-380]
005B99  C9 71                         cmp  #$71            ; A=A+$08 X=$001F Y=$007F ; [SP-380]
005B9B  B0 0B                         bcs  L_005BA8        ; A=A+$08 X=$001F Y=$007F ; [SP-380]
005B9D  BD B4 5B                      lda  $5BB4,X         ; -> $5BD3 ; A=A+$08 X=$001F Y=$007F ; [SP-380]
005BA0  C9 1B                         cmp  #$1B            ; A=A+$08 X=$001F Y=$007F ; [SP-380]
005BA2  B0 04                         bcs  L_005BA8        ; A=A+$08 X=$001F Y=$007F ; [SP-380]
005BA4  C9 16                         cmp  #$16            ; A=A+$08 X=$001F Y=$007F ; [SP-380]
005BA6  B0 D1                         bcs  L_005B79        ; A=A+$08 X=$001F Y=$007F ; [SP-380]
; === End of while loop ===

005BA8  20 03 04          L_005BA8    jsr  $0403           ; A=A+$08 X=$001F Y=$007F ; [SP-382]
005BAB  29 07                         and  #$07            ; A=A&$07 X=$001F Y=$007F ; [SP-382]
005BAD  9D F4 5B                      sta  $5BF4,X         ; -> $5C13 ; A=A&$07 X=$001F Y=$007F ; [SP-382]
005BB0  CA                            dex                  ; A=A&$07 X=$001E Y=$007F ; [SP-382]
005BB1  10 C6                         bpl  L_005B79        ; A=A&$07 X=$001E Y=$007F ; [SP-382]
; === End of while loop ===

005BB3  60                            rts                  ; A=A&$07 X=$001E Y=$007F ; [SP-380]

; --- Data region ---
005BB4  AEB8A092                HEX     AEB8A092 A0C5C3A0 CAA4A5C4 B1FFA092
005BC4  A0FBCD90                HEX     A0FBCD90 A0A0E0A0 BDC9E0D3 A085A0A4
005BD4  A085A0A4                HEX     A085A0A4 A0A0C6A0 D0A085A0 90C9A0A5
005BE4  AC92A0A0                HEX     AC92A0A0 A0A0A0A0 A5CFD6A0 A0A0AE83
005BF4  AABAA0A0                HEX     AABAA0A0 A0A5AEA0 C3AFACA0 CFA089A0
005C04  99A0A0AE                HEX     99A0A0AE C38AA0D0 A0F480A0 A5A0D6A0
005C14  00081018                HEX     00081018 00889098

; FUNC $005C1C: register -> A:X [L]
; Proto: uint32_t func_005C1C(uint16_t param_X, uint16_t param_Y);
; Liveness: params(X,Y) returns(A,X,Y) [1 dead stores]
; --- End data region (104 bytes) ---

005C1C  A5 34             L_005C1C    lda  $34             ; A=[$0034] X=$001E Y=$007F ; [SP-386]
005C1E  18                            clc                  ; A=[$0034] X=$001E Y=$007F ; [SP-386]
005C1F  69 01                         adc  #$01            ; A=A+$01 X=$001E Y=$007F ; [SP-386]
005C21  85 34                         sta  $34             ; A=A+$01 X=$001E Y=$007F ; [SP-386]
005C23  C9 28                         cmp  #$28            ; A=A+$01 X=$001E Y=$007F ; [SP-386]
005C25  B0 01                         bcs  L_005C28        ; A=A+$01 X=$001E Y=$007F ; [SP-386]
005C27  60                            rts                  ; A=A+$01 X=$001E Y=$007F ; [SP-384]

; FUNC $005C28: register -> A:X []
; Liveness: returns(A,X,Y) [7 dead stores]
005C28  A9 00             L_005C28    lda  #$00            ; A=$0000 X=$001E Y=$007F ; [SP-384]
005C2A  85 34                         sta  $34             ; A=$0000 X=$001E Y=$007F ; [SP-384]
005C2C  A6 33                         ldx  $33             ; A=$0000 X=$001E Y=$007F ; [SP-384]
005C2E  E8                            inx                  ; A=$0000 X=$001F Y=$007F ; [SP-384]
005C2F  E0 20                         cpx  #$20            ; A=$0000 X=$001F Y=$007F ; [SP-384]
005C31  90 02                         bcc  L_005C35        ; A=$0000 X=$001F Y=$007F ; [SP-384]
005C33  A2 00                         ldx  #$00            ; A=$0000 X=$0000 Y=$007F ; [SP-384]
005C35  86 33             L_005C35    stx  $33             ; A=$0000 X=$0000 Y=$007F ; [SP-384]
005C37  BD D4 5B                      lda  $5BD4,X         ; A=$0000 X=$0000 Y=$007F ; [SP-384]
005C3A  A8                            tay                  ; A=$0000 X=$0000 Y=$0000 ; [SP-384]
005C3B  B9 6C 41                      lda  $416C,Y         ; A=$0000 X=$0000 Y=$0000 ; [SP-384]
005C3E  85 06                         sta  $06             ; A=$0000 X=$0000 Y=$0000 ; [SP-384]
005C40  B9 2C 42                      lda  $422C,Y         ; A=$0000 X=$0000 Y=$0000 ; [SP-384]
005C43  85 07                         sta  $07             ; A=$0000 X=$0000 Y=$0000 ; [SP-384]
005C45  BD F4 5B                      lda  $5BF4,X         ; A=$0000 X=$0000 Y=$0000 ; [SP-384]
005C48  A8                            tay                  ; A=$0000 X=$0000 Y=$0000 ; [SP-384]
005C49  18                            clc                  ; A=$0000 X=$0000 Y=$0000 ; [SP-384]
005C4A  69 01                         adc  #$01            ; A=A+$01 X=$0000 Y=$0000 ; [SP-384]
005C4C  29 07                         and  #$07            ; A=A&$07 X=$0000 Y=$0000 ; [SP-384]
005C4E  9D F4 5B                      sta  $5BF4,X         ; A=A&$07 X=$0000 Y=$0000 ; [SP-384]
005C51  B9 14 5C                      lda  $5C14,Y         ; A=A&$07 X=$0000 Y=$0000 ; [SP-384]
005C54  48                            pha                  ; A=A&$07 X=$0000 Y=$0000 ; [SP-385]
005C55  BD B4 5B                      lda  $5BB4,X         ; A=A&$07 X=$0000 Y=$0000 ; [SP-385]
005C58  A8                            tay                  ; A=A&$07 X=$0000 Y=A ; [SP-385]
005C59  68                            pla                  ; A=[stk] X=$0000 Y=A ; [SP-384]
005C5A  49 FF                         eor  #$FF            ; A=A^$FF X=$0000 Y=A ; [SP-384]
005C5C  31 06                         and  ($06),Y         ; A=A^$FF X=$0000 Y=A ; [SP-384]
005C5E  91 06                         sta  ($06),Y         ; A=A^$FF X=$0000 Y=A ; [SP-384]
005C60  BD F4 5B                      lda  $5BF4,X         ; A=A^$FF X=$0000 Y=A ; [SP-384]
005C63  AA                            tax                  ; A=A^$FF X=A Y=A ; [SP-384]
005C64  BD 14 5C                      lda  $5C14,X         ; A=A^$FF X=A Y=A ; [SP-384]
005C67  11 06                         ora  ($06),Y         ; A=A^$FF X=A Y=A ; [SP-384]
005C69  91 06                         sta  ($06),Y         ; A=A^$FF X=A Y=A ; [SP-384]
005C6B  60                            rts                  ; A=A^$FF X=A Y=A ; [SP-382]

; FUNC $005C6C: register -> A:X []
; Proto: uint32_t func_005C6C(uint16_t param_A, uint16_t param_X, uint16_t param_Y);
; Frame: push_only [saves: A]
; Liveness: params(A,X,Y) returns(A,X,Y) [2 dead stores]
005C6C  38                L_005C6C    sec                  ; A=A^$FF X=A Y=A ; [SP-382]

; === while loop starts here (counter: $00, range: 0..23601, step: 23603, iters: 101670465853569) [nest:18] [inner] ===
005C6D  48                L_005C6D    pha                  ; A=A^$FF X=A Y=A ; [SP-383]

; === while loop starts here (counter: $00 '', range: 0..20348, step: 20469, iters: 101275328862334) [nest:19] [inner] ===
005C6E  E9 01             L_005C6E    sbc  #$01            ; A=A-$01 X=A Y=A ; [SP-383]
005C70  D0 FC                         bne  L_005C6E        ; A=A-$01 X=A Y=A ; [SP-383]
; === End of while loop (counter: $00) ===

005C72  68                            pla                  ; A=[stk] X=A Y=A ; [SP-382]
005C73  E9 01                         sbc  #$01            ; A=A-$01 X=A Y=A ; [SP-382]
005C75  D0 F6                         bne  L_005C6D        ; A=A-$01 X=A Y=A ; [SP-382]
; === End of while loop (counter: $00) ===

005C77  60                            rts                  ; A=A-$01 X=A Y=A ; [SP-380]

; FUNC $005C78: register -> A:X []
; Proto: uint32_t func_005C78(uint16_t param_Y);
; Liveness: params(Y) returns(A,X,Y)
005C78  A2 0F             L_005C78    ldx  #$0F            ; A=A-$01 X=$000F Y=A ; [SP-380]

; === while loop starts here (counter: $00 '', range: 0..20467, step: 20383, iters: 87913685602292) [nest:18] [inner] ===
005C7A  BD B8 53          L_005C7A    lda  $53B8,X         ; -> $53C7 ; A=A-$01 X=$000F Y=A ; [SP-380]
005C7D  C9 04                         cmp  #$04            ; A=A-$01 X=$000F Y=A ; [SP-380]
005C7F  F0 01                         beq  L_005C82        ; A=A-$01 X=$000F Y=A ; [SP-380]
005C81  60                            rts                  ; A=A-$01 X=$000F Y=A ; [SP-378]
005C82  CA                L_005C82    dex                  ; A=A-$01 X=$000E Y=A ; [SP-378]
005C83  10 F5                         bpl  L_005C7A        ; A=A-$01 X=$000E Y=A ; [SP-378]
; === End of while loop (counter: $00) ===

005C85  20 27 5D                      jsr  L_005D27        ; A=A-$01 X=$000E Y=A ; [SP-380]
005C88  20 14 5D                      jsr  L_005D14        ; A=A-$01 X=$000E Y=A ; [SP-382]
005C8B  A9 03                         lda  #$03            ; A=$0003 X=$000E Y=A ; [SP-382]
005C8D  8D 13 5D                      sta  $5D13           ; A=$0003 X=$000E Y=A ; [SP-382]

; === while loop starts here (counter: $00, range: 0..19187, step: 19190, iters: 82502026808070) [nest:16] [inner] ===
005C90  AE 13 5D          L_005C90    ldx  $5D13           ; A=$0003 X=$000E Y=A ; [SP-382]
005C93  BD 54 5D                      lda  $5D54,X         ; -> $5D62 ; A=$0003 X=$000E Y=A ; [SP-382]
005C96  F0 0B                         beq  L_005CA3        ; A=$0003 X=$000E Y=A ; [SP-382]
005C98  20 C4 44                      jsr  L_0044C4        ; A=$0003 X=$000E Y=A ; [SP-384]
; === End of while loop (counter: $00) ===

005C9B  AE 13 5D                      ldx  $5D13           ; A=$0003 X=$000E Y=A ; [SP-384]
005C9E  A9 00                         lda  #$00            ; A=$0000 X=$000E Y=A ; [SP-384]
005CA0  9D 54 5D                      sta  $5D54,X         ; -> $5D62 ; A=$0000 X=$000E Y=A ; [SP-384]
005CA3  BD 12 52          L_005CA3    lda  $5212,X         ; -> $5220 ; A=$0000 X=$000E Y=A ; [SP-384]
005CA6  F0 0B                         beq  L_005CB3        ; A=$0000 X=$000E Y=A ; [SP-384]
005CA8  20 C9 52                      jsr  L_0052C9        ; A=$0000 X=$000E Y=A ; [SP-386]
; === End of while loop (counter: $00) ===

005CAB  AE 13 5D                      ldx  $5D13           ; A=$0000 X=$000E Y=A ; [SP-386]
005CAE  A9 00                         lda  #$00            ; A=$0000 X=$000E Y=A ; [SP-386]
005CB0  9D 12 52                      sta  $5212,X         ; -> $5220 ; A=$0000 X=$000E Y=A ; [SP-386]
005CB3  CE 13 5D          L_005CB3    dec  $5D13           ; A=$0000 X=$000E Y=A ; [SP-386]
005CB6  10 D8                         bpl  L_005C90        ; A=$0000 X=$000E Y=A ; [SP-386]
; === End of while loop (counter: $00) ===

005CB8  A9 50                         lda  #$50            ; A=$0050 X=$000E Y=A ; [SP-386]
005CBA  20 E0 4A                      jsr  L_004AE0        ; A=$0050 X=$000E Y=A ; [SP-388]
; === End of while loop (counter: $00) ===

005CBD  C6 3A                         dec  $3A             ; A=$0050 X=$000E Y=A ; [SP-388]
005CBF  20 33 4D                      jsr  L_004D33        ; A=$0050 X=$000E Y=A ; [SP-390]
; === End of while loop (counter: $00) ===

005CC2  20 99 4C                      jsr  L_004C99        ; A=$0050 X=$000E Y=A ; [SP-392]
; === End of while loop (counter: $00) ===

005CC5  A9 32                         lda  #$32            ; A=$0032 X=$000E Y=A ; [SP-392]
005CC7  A0 FF                         ldy  #$FF            ; A=$0032 X=$000E Y=$00FF ; [SP-392]
005CC9  8D 67 5B                      sta  $5B67           ; A=$0032 X=$000E Y=$00FF ; [SP-392]
005CCC  20 62 5B                      jsr  L_005B62        ; A=$0032 X=$000E Y=$00FF ; [SP-394]
; === End of while loop (counter: $00) ===

005CCF  A9 03                         lda  #$03            ; A=$0003 X=$000E Y=$00FF ; [SP-394]
005CD1  8D 13 5D                      sta  $5D13           ; A=$0003 X=$000E Y=$00FF ; [OPT] PEEPHOLE: Load after store: 2 byte pattern at $005CD1 ; [SP-394]

; === while loop starts here (counter: $00, range: 0..19472, step: 19474, iters: 83618718305290) [nest:11] [inner] ===
005CD4  AD 13 5D          L_005CD4    lda  $5D13           ; A=[$5D13] X=$000E Y=$00FF ; [SP-394]
005CD7  20 3C 4C                      jsr  L_004C3C        ; A=[$5D13] X=$000E Y=$00FF ; [SP-396]
; === End of while loop (counter: $00) ===

005CDA  CE 13 5D                      dec  $5D13           ; A=[$5D13] X=$000E Y=$00FF ; [SP-396]
005CDD  10 F5                         bpl  L_005CD4        ; A=[$5D13] X=$000E Y=$00FF ; [SP-396]
; === End of while loop (counter: $00) ===

005CDF  A2 0F                         ldx  #$0F            ; A=[$5D13] X=$000F Y=$00FF ; [SP-396]
005CE1  A9 01                         lda  #$01            ; A=$0001 X=$000F Y=$00FF ; [SP-396]

; === while loop starts here (counter: $00, range: 0..23783, step: 23785, iters: 102172977028331) [nest:11] [inner] ===
005CE3  9D B8 53          L_005CE3    sta  $53B8,X         ; -> $53C7 ; A=$0001 X=$000F Y=$00FF ; [SP-396]
005CE6  CA                            dex                  ; A=$0001 X=$000E Y=$00FF ; [SP-396]
005CE7  10 FA                         bpl  L_005CE3        ; A=$0001 X=$000E Y=$00FF ; [SP-396]
; === End of while loop (counter: $00) ===

005CE9  A5 3A                         lda  $3A             ; A=[$003A] X=$000E Y=$00FF ; [SP-396]
005CEB  F0 1C                         beq  L_005D09        ; A=[$003A] X=$000E Y=$00FF ; [SP-396]
005CED  20 3E 41                      jsr  L_00413E        ; A=[$003A] X=$000E Y=$00FF ; [SP-398]
; === End of while loop (counter: $00) ===

005CF0  20 7A 43                      jsr  L_00437A        ; A=[$003A] X=$000E Y=$00FF ; [SP-400]
; === End of while loop (counter: $00) ===

005CF3  20 4F 5B                      jsr  L_005B4F        ; A=[$003A] X=$000E Y=$00FF ; [SP-402]
; === End of while loop (counter: $00) ===

005CF6  A5 3A                         lda  $3A             ; A=[$003A] X=$000E Y=$00FF ; [SP-402]
005CF8  C9 04                         cmp  #$04            ; A=[$003A] X=$000E Y=$00FF ; [SP-402]
005CFA  B0 0C                         bcs  L_005D08        ; A=[$003A] X=$000E Y=$00FF ; [SP-402]
005CFC  20 27 52                      jsr  L_005227        ; A=[$003A] X=$000E Y=$00FF ; [SP-404]
; === End of while loop (counter: $00) ===

005CFF  20 27 52                      jsr  L_005227        ; A=[$003A] X=$000E Y=$00FF ; [SP-406]
; === End of while loop (counter: $00) ===

005D02  20 27 52                      jsr  L_005227        ; A=[$003A] X=$000E Y=$00FF ; [SP-408]
; === End of while loop (counter: $00) ===

005D05  20 27 52                      jsr  L_005227        ; A=[$003A] X=$000E Y=$00FF ; [OPT] TAIL_CALL: Tail call: JSR/JSL at $005D05 followed by RTS ; [SP-410]
; === End of while loop (counter: $00) ===

005D08  60                L_005D08    rts                  ; A=[$003A] X=$000E Y=$00FF ; [SP-408]
005D09  A9 00             L_005D09    lda  #$00            ; A=$0000 X=$000E Y=$00FF ; [SP-408]
005D0B  85 10                         sta  $10             ; A=$0000 X=$000E Y=$00FF ; [SP-408]
005D0D  68                            pla                  ; A=[stk] X=$000E Y=$00FF ; [SP-407]
005D0E  68                            pla                  ; A=[stk] X=$000E Y=$00FF ; [SP-406]
005D0F  4C 39 58                      jmp  L_005839        ; A=[stk] X=$000E Y=$00FF ; [SP-406]
; === End of while loop (counter: $00) ===


; === while loop starts here (counter: Y 'iter_y') [nest:1] ===
005D12  60                L_005D12    rts                  ; A=[stk] X=$000E Y=$00FF ; [SP-404]

; --- Data region ---
005D13  00                      HEX     00

; FUNC $005D14: register -> A:X [LI]
; Proto: uint32_t func_005D14(uint16_t param_Y);
; Liveness: params(Y) returns(A,X,Y) [24 dead stores]
; --- End data region (1 bytes) ---

005D14  A6 11             L_005D14    ldx  $11             ; A=[stk] X=$000E Y=$00FF ; [SP-407]
005D16  BD 34 5D                      lda  $5D34,X         ; -> $5D42 ; A=[stk] X=$000E Y=$00FF ; [SP-407]
005D19  85 02                         sta  $02             ; A=[stk] X=$000E Y=$00FF ; [SP-407]
005D1B  BD 38 5D                      lda  $5D38,X         ; -> $5D46 ; A=[stk] X=$000E Y=$00FF ; [SP-407]
005D1E  85 04                         sta  $04             ; A=[stk] X=$000E Y=$00FF ; [SP-407]
005D20  8A                            txa                  ; A=$000E X=$000E Y=$00FF ; [SP-407]
005D21  18                            clc                  ; A=$000E X=$000E Y=$00FF ; [SP-407]
005D22  69 0B                         adc  #$0B            ; A=A+$0B X=$000E Y=$00FF ; [SP-407]
005D24  4C C0 40                      jmp  L_0040C0        ; A=A+$0B X=$000E Y=$00FF ; [SP-407]
; === End of while loop (counter: $00) ===


; FUNC $005D27: register -> A:X [IJ]
; Proto: uint32_t func_005D27(uint16_t param_X, uint16_t param_Y);
; Liveness: params(X,Y) returns(A,X,Y) [22 dead stores]
005D27  A9 56             L_005D27    lda  #$56            ; A=$0056 X=$000E Y=$00FF ; [SP-407]
005D29  85 04                         sta  $04             ; A=$0056 X=$000E Y=$00FF ; [SP-407]
005D2B  A9 17                         lda  #$17            ; A=$0017 X=$000E Y=$00FF ; [SP-407]
005D2D  85 02                         sta  $02             ; A=$0017 X=$000E Y=$00FF ; [SP-407]
005D2F  A9 18                         lda  #$18            ; A=$0018 X=$000E Y=$00FF ; [SP-407]
005D31  4C C0 40                      jmp  L_0040C0        ; A=$0018 X=$000E Y=$00FF ; [SP-407]
; === End of while loop (counter: $00) ===


; --- Data region ---
005D34  181A1816                HEX     181A1816 525D6B
; --- End data region (7 bytes) ---

005D3B  5D 17 25          L_005D3B    eor  $2517,X         ; -> $2525 ; A=$0018 X=$000E Y=$00FF ; [SP-407]
005D3E  17 09                         ora  [$09],Y         ; A=$0018 X=$000E Y=$00FF ; [SP-407]
005D40  01 56                         ora  ($56,X)         ; A=$0018 X=$000E Y=$00FF ; [SP-407]
005D42  B1 56                         lda  ($56),Y         ; A=$0018 X=$000E Y=$00FF ; [SP-407]
005D44  01 58                         ora  ($58,X)         ; A=$0018 X=$000E Y=$00FF ; [SP-407]
005D46  B1 58                         lda  ($58),Y         ; A=$0018 X=$000E Y=$00FF ; [SP-407]
005D48  A0 8C                         ldy  #$8C            ; A=$0018 X=$000E Y=$008C ; [SP-407]
005D4A  BA                            tsx                  ; A=$0018 X=$000E Y=$008C ; [SP-407]
005D4B  A0 A0                         ldy  #$A0            ; A=$0018 X=$000E Y=$00A0 ; [SP-407]
005D4D  E6 D2                         inc  $D2             ; A=$0018 X=$000E Y=$00A0 ; [SP-407]
005D4F  A0 A0                         ldy  #$A0            ; A=$0018 X=$000E Y=$00A0 ; [OPT] REDUNDANT_LOAD: Redundant LDY: same value loaded at $005D4B ; [SP-407]
005D51  A0 C8                         ldy  #$C8            ; A=$0018 X=$000E Y=$00C8 ; [SP-407]
005D53  A0 A0                         ldy  #$A0            ; A=$0018 X=$000E Y=$00A0 ; [SP-407]
005D55  C8                            iny                  ; A=$0018 X=$000E Y=$00A1 ; [SP-407]
005D56  A0 80                         ldy  #$80            ; A=$0018 X=$000E Y=$0080 ; [SP-407]
005D58  D4 AC                         pei  ($AC)           ; A=$0018 X=$000E Y=$0080 ; [SP-409]
005D5A  BA                            tsx                  ; A=$0018 X=$000E Y=$0080 ; [SP-409]
005D5B  A0 A0                         ldy  #$A0            ; A=$0018 X=$000E Y=$00A0 ; [SP-409]
005D5D  BB                            tyx                  ; A=$0018 X=$000E Y=$00A0 ; [SP-409]
005D5E  A0 AC                         ldy  #$AC            ; A=$0018 X=$000E Y=$00AC ; [SP-409]
005D60  A0 A0                         ldy  #$A0            ; A=$0018 X=$000E Y=$00A0 ; [SP-409]
005D62  D0 AE                         bne  L_005D12        ; A=$0018 X=$000E Y=$00A0 ; [SP-409]
; === End of while loop (counter: Y) ===

005D64  E6 AF                         inc  $AF             ; A=$0018 X=$000E Y=$00A0 ; [SP-409]
005D66  8C B0 AB                      sty  $ABB0           ; A=$0018 X=$000E Y=$00A0 ; [SP-409]
005D69  BC AB 9A                      ldy  $9AAB,X         ; -> $9AB9 ; A=$0018 X=$000E Y=$00A0 ; [SP-409]
005D6C  00 00                         brk  #$00            ; A=$0018 X=$000E Y=$00A0 ; [SP-412]

; --- Data region ---
005D6E  00005160                HEX     00005160
; --- End data region (4 bytes) ---

005D72  6C 60 A9          L_005D72    jmp  ($A960)         ; A=$0018 X=$000E Y=$00A0 ; [SP-415]

; --- Data region ---
005D75  A0                      HEX     A0
; --- End data region (1 bytes) ---

005D76  C6 A0                         dec  $A0             ; A=$0018 X=$000E Y=$00A0 ; [SP-415]
005D78  C3 A0                         cmp  $A0,S           ; A=$0018 X=$000E Y=$00A0 ; [SP-415]
005D7A  81 D4                         sta  ($D4,X)         ; A=$0018 X=$000E Y=$00A0 ; [SP-415]
005D7C  00 07                         brk  #$07            ; A=$0018 X=$000E Y=$00A0 ; [SP-417]

; --- Data region ---
005D7E  0E151C23                HEX     0E151C23 2A31383F 4670747B 7F86B7DA
005D8E  E80B3543                HEX     E80B3543 6697C807 2A5487B1 C6CBD0D5
005D9E  DFE9F3FD                HEX     DFE9F3FD BA7B38F9 77A4E310 4F566472
005DAE  808E9CAA                HEX     808E9CAA BFD4E9FE 13283D43 4F5B6773
005DBE  7F8B92A0                HEX     7F8B92A0 AEBCCAD8 E6F40210 1E2C3A48
005DCE  4F5D6B                  HEX     4F5D6B
; --- End data region (83 bytes) ---

005DD1  79 87 95          L_005DD1    adc  $9587,Y         ; -> $9627 ; A=$0018 X=$000E Y=$00A0 ; [SP-424]
005DD4  A3 AA                         lda  $AA,S           ; A=$0018 X=$000E Y=$00A0 ; [SP-424]
005DD6  B8                            clv                  ; A=$0018 X=$000E Y=$00A0 ; [SP-424]
005DD7  C6 D4                         dec  $D4             ; A=$0018 X=$000E Y=$00A0 ; [SP-424]
005DD9  E2 F0                         sep  #$F0            ; A=$0018 X=$000E Y=$00A0 ; [SP-424]
005DDB  59 6E 83                      eor  $836E,Y         ; -> $840E ; A=$0018 X=$000E Y=$00A0 ; [SP-424]
005DDE  FE 1A 2F                      inc  $2F1A,X         ; -> $2F28 ; A=$0018 X=$000E Y=$00A0 ; [SP-424]
; Block move (MVP)
005DE1  44 98 AA                      mvp  $AA,$98         ; A=$0018 X=$000E Y=$00A0 ; [SP-424]
005DE4  BC CE E9                      ldy  $E9CE,X         ; -> $E9DC ; A=$0018 X=$000E Y=$00A0 ; [SP-424]
005DE7  FB                            xce                  ; A=$0018 X=$000E Y=$00A0 ; [SP-424]
005DE8  0D 1F 2D                      ora  $2D1F           ; A=$0018 X=$000E Y=$00A0 ; [SP-424]
005DEB  42 57                         wdm  #$57            ; A=$0018 X=$000E Y=$00A0 ; [SP-424]
005DED  6C 81 96                      jmp  ($9681)         ; A=$0018 X=$000E Y=$00A0 ; [SP-424]

; --- Data region ---
005DF0  ABB9CEE3                HEX     ABB9CEE3 F8061B30 3E53687D 92A7BCC2
005E00  CEDAE6F2                HEX     CEDAE6F2 FE0A101C 2834404C 5818B878
005E10  F050B010                HEX     F050B010 33B1C50D 55B5155D BD60
; --- End data region (46 bytes) ---

005E1E  60                L_005E1E    rts                  ; A=$0018 X=$000E Y=$00A0 ; [SP-421]

; --- Data region ---
005E1F  60606060                HEX     60606060 60606060 60606060 60606060
005E2F  60616161                HEX     60616161 61616162 62626262 62626262
005E3F  62626262                HEX     62626262 63636463 64646465 65656565
005E4F  65656565                HEX     65656565 65656565 66666666 66666666
005E5F  66666666                HEX     66666666 66666666 66666767 67676767
005E6F  67676767                HEX     67676767 67676767 67676767 67686868
005E7F  67686868                HEX     67686868 68686868 68686969 69696969
005E8F  69696969                HEX     69696969 6969696A 6A6A6A6A 6A6A6A6A
005E9F  6A6A6A6A                HEX     6A6A6A6A 6A6A6A6B 6B6B6B6B 6B6B6B6C
005EAF  6B6C6C6D                HEX     6B6C6C6D 6D6E6E6E 6E6F6F6F 70707001
005EBF  01010101                HEX     01010101 01010101 01060101 01010705
005ECF  02050602                HEX     02050602 05070703 05030303 03010101
005EDF  02020202                HEX     02020202 09030303 03030303 03010202
005EEF  02020202                HEX     02020202 03030303 03030301 02020202
005EFF  02020102                HEX     02020102 02020202 02020202 02020202
005F0F  01020202                HEX     01020202 02020201 02020202 02020303
005F1F  03040303                HEX     03040303 03020202 03020202 02030303
005F2F  03030302                HEX     03030302 03030302 03030203 03030303
005F3F  03010202                HEX     03010202 02020202 01020202 02020204
005F4F  04040504                HEX     04040504 04040509 02030304 04030404
005F5F  07070707                HEX     07070707 07070707 07070704 07040707
005F6F  07070707                HEX     07070707 07070707 15070E11 0E070505
005F7F  05050505                HEX     05050505 050E1515 15150F15 0F150707
005F8F  07070707                HEX     07070707 07070707 07070707 06060606
005F9F  06060607                HEX     06060607 07070707 07070707 07070707
005FAF  07070707                HEX     07070707 07070707 07070707 07070707
005FBF  07070707                HEX     07070707 07070909 09090909 09070707
005FCF  07070707                HEX     07070707 07070707 07070707 07070707
005FDF  07070606                HEX     07070606 06060606 06060606 06060606
005FEF  18181818                HEX     18181818 18181807 0E0A1818 18181818
005FFF  181E3333                HEX     181E3333 3333331E 3C363330 3030301E
00600F  3F33380E                HEX     3F33380E 3F3F1E3F 303E303F 1E383C36
00601F  333F3030                HEX     333F3030 3F3F031F 303F1E1C 06031F33
00602F  331E3F3F                HEX     331E3F3F 30180C0C 0C1E3F33 1E333F1E
00603F  1E3F333E                HEX     1E3F333E 303E1E1E 1E1E1F3F 003F3F3F
00604F  3F3F0003                HEX     3F3F0003 33333303 001E0333 3F1F0030
00605F  33331F03                HEX     33331F03 003F3F3F 3B3F001E 1E1E333F
00606F  00889CBE                HEX     00889CBE FF818387 8F878381 FFBE9C88
00607F  C0E0F0F8                HEX     C0E0F0F8 F0E0C01E 3F333F3F 3F1E3F3F
00608F  333F3F3F                HEX     333F3F3F 3F030337 030C0C33 3B1F3F1F
00609F  0C0C0333                HEX     0C0C0333 033B030C 0C333F3F 333F0C3F
0060AF  3F1E3F33                HEX     3F1E3F33 3F0C3F1E 1F1F3F3F 3F3F3F3F
0060BF  3F3F3333                HEX     3F3F3333 0C030C33 3F0C1F0C 331F0C1F
0060CF  0C3F3B3F                HEX     0C3F3B3F 030C1F33 3F030C1F 333F3333
0060DF  331F1E33                HEX     331F1E33 0C3F0C1F 0C1E1E1E 3F3F3F3F
0060EF  3F3F3F03                HEX     3F3F3F03 33330C0C 1E03330C 0C303333
0060FF  0C0C3F3F                HEX     0C0C3F3F 3F0C0C1E 1E1E0C0C 1E1E331F
00610F  1E633F3F                HEX     1E633F3F 333F3F77 03333333 336B1E03
00611F  3F3F3F63                HEX     3F3F3F63 30333F1F 3F633F3F 333B3363
00612F  1E1E3333                HEX     1E1E3333 3363333F 333F330C 3F0C3F0C
00613F  333F333F                HEX     333F333F 3E3C1E1E 3C41363F 3F365D33
00614F  33333345                HEX     33333345 303E1E30 5D303033 3041303E
00615F  3F303E30                HEX     3F303E30 1E1E301E 3300033F 333F3F33
00616F  00033F33                HEX     00033F33 3F333700 030C3703 333F3F03
00617F  0C3F1F33                HEX     0C3F1F33 3B3F030C 3B033F33 003F3F33
00618F  3F1E3300                HEX     3F1E3300 3F3F333F 1E331E3F 3F633C3F
00619F  333F3F3F                HEX     333F3F3F 777E0333 030C036B
; --- End data region (908 bytes) ---

0061AB  06 1E             L_0061AB    asl  $1E             ; A=$0018 X=$000E Y=$00A0 ; [SP-474]
0061AD  1E 1E 0C                      asl  $0C1E,X         ; -> $0C2C ; A=$0018 X=$000E Y=$00A0 ; [SP-474]
0061B0  1F 63 3C 30                   ora  >$303C63,X      ; -> $303C71 ; A=$0018 X=$000E Y=$00A0 ; [SP-474]
0061B4  0C 30 0C                      tsb  $0C30           ; A=$0018 X=$000E Y=$00A0 ; [SP-474]
0061B7  03 63                         ora  $63,S           ; A=$0018 X=$000E Y=$00A0 ; [SP-474]
0061B9  60                            rts                  ; A=$0018 X=$000E Y=$00A0 ; [SP-472]

; --- Data region ---
0061BA  3F0C3F0C                HEX     3F0C3F0C 3F637E1E 0C1E0C3F 633C80FF
0061CA  80C0FF81                HEX     80C0FF81 A0DD82B0 DD86A8DD 8AACDD9A
0061DA  AADDAAAB                HEX     AADDAAAB DDEAABDD EAFFFFFF FFFFFFFF
0061EA  FFFFABDD                HEX     FFFFABDD EAABDDEA AADDAAAC DD9AA8DD
0061FA  8AB0DD86                HEX     8AB0DD86 A0DD82C0 FF8180FF 80033F33
00620A  3F1E033F                HEX     3F1E033F 333F3F03 0C330303 030C331F
00621A  1E030C33                HEX     1E030C33 03303F3F 1E3F3F3F 3F0C3F1E
00622A  D40095D4                HEX     D40095D4 C195D0FF 85D0FF85 C0948100
00623A  94000094                HEX     94000094 00009400 00940000 940000AA
00624A  0000AA00                HEX     0000AA00 00AA0000 88000000 C00000D0
00625A  0000D000                HEX     0000D000 00D40000 D40000B8 008A9800
00626A  DA9AC0DA                HEX     DA9AC0DA 9A00DA9A 008A9800 00B80000
00627A  D40000D4                HEX     D40000D4 0000D000 00D00000 C0008800
00628A  00AA0000                HEX     00AA0000 AA0000AA 00009400 00940000
00629A  94000094                HEX     94000094 00009400 C09481D0 FF85D0FF
0062AA  85D4C195                HEX     85D4C195 D40095E0 8700B89D 00AEF500
0062BA  AFF481AE                HEX     AFF481AE F500B89D 00E08700 150E1B0E
0062CA  152A1C36                HEX     152A1C36 1C2A5438 6C385428 01700058
0062DA  01700028                HEX     01700028 01500260
; --- End data region (296 bytes) ---

0062E2  01 30             L_0062E2    ora  ($30,X)         ; A=$0018 X=$000E Y=$00A0 ; [SP-582]
0062E4  03 60                         ora  $60,S           ; A=$0018 X=$000E Y=$00A0 ; [SP-582]
0062E6  01 50                         ora  ($50,X)         ; A=$0018 X=$000E Y=$00A0 ; [SP-582]
0062E8  02 20                         cop  #$20            ; A=$0018 X=$000E Y=$00A0 ; [SP-585]

; --- Data region ---
0062EA  05400360                HEX     05400360
; --- End data region (4 bytes) ---

0062EE  06 40             L_0062EE    asl  $40             ; A=$0018 X=$000E Y=$00A0 ; [SP-585]
0062F0  03 20                         ora  $20,S           ; A=$0018 X=$000E Y=$00A0 ; [SP-585]
0062F2  05 40                         ora  $40             ; A=$0018 X=$000E Y=$00A0 ; [SP-585]
0062F4  0A                            asl  a               ; A=$0018 X=$000E Y=$00A0 ; [SP-585]
0062F5  00 07                         brk  #$07            ; A=$0018 X=$000E Y=$00A0 ; [SP-588]
; Interrupt return (RTI)

; --- Data region ---
0062F7  400D0007                HEX     400D0007 400A1E1E 637E001E 333F1F1E
006307  1E637E00                HEX     1E637E00 1E333F1F 3F3F777E 003F333F
006317  3F3F3F77                HEX     3F3F3F77 7E003F33 3F3F0333 6B
; --- End data region (45 bytes) ---

006324  06 00             L_006324    asl  $00             ; A=$0018 X=$000E Y=$00A0 ; [SP-582]
006326  33 33                         and  ($33,S),Y       ; A=$0018 X=$000E Y=$00A0 ; [SP-582]
006328  03 33                         ora  $33,S           ; A=$0018 X=$000E Y=$00A0 ; [SP-582]
00632A  03 33                         ora  $33,S           ; A=$0018 X=$000E Y=$00A0 ; [SP-582]
00632C  6B                            rtl                  ; A=$0018 X=$000E Y=$00A0 ; [SP-579]

; --- Data region ---
00632D  06003333                HEX     06003333 03333B3F 633E0033 331F3F3B
00633D  3F633E00                HEX     3F633E00 33331F3F 333F6306 00333303
00634D  1F333F63                HEX     1F333F63 06003333 031F3F33 637E003F
00635D  1E3F3B3F                HEX     1E3F3B3F 33637E00 3F1E3F3B 1E33637E
00636D  001E0C3F                HEX     001E0C3F 331E3363 7E001E0C 3F33007F
00637D  00407F01                HEX     00407F01 205D0230 5D06285D 0A2C5D1A
00638D  2A5D2A2B                HEX     2A5D2A2B 5D6A2B5D 6A7F7F7F 7F7F7F7F
00639D  7F7F2B5D                HEX     7F7F2B5D 6A2B5D6A 2A5D2A2C 5D1A285D
0063AD  0A305D06                HEX     0A305D06 205D0240 7F01007F 0080FF80
0063BD  C0FF81A0                HEX     C0FF81A0 DD82B0DD 86A8DD8A ACDD9AAA
0063CD  DDAAABDD                HEX     DDAAABDD EAABDDEA FFFFFFFF FFFFFFFF
0063DD  FFABDDEA                HEX     FFABDDEA ABDDEAAA DDAAACDD 9AA8DD8A
0063ED  B0DD86A0                HEX     B0DD86A0 DD82C0FF 8180FF80 007F0040
0063FD  7F01205D                HEX     7F01205D 02305D06 285D0A2C 5D1A2A5D
00640D  2A2B5D6A                HEX     2A2B5D6A 2B5D6A7F 7F7F7F7F 7F7F7F7F
00641D  2B5D6A2B                HEX     2B5D6A2B 5D6A2A5D 2A2C5D1A 285D0A30
00642D  5D06205D                HEX     5D06205D 02407F01 007F0080 FF80C0FF
00643D  81A0DD82                HEX     81A0DD82 B0DD86A8 DD8AACDD
; --- End data region (284 bytes) ---

006449  9A                L_006449    txs                  ; A=$0018 X=$000E Y=$00A0 ; [SP-600]
00644A  AA                            tax                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-600]
00644B  DD AA AB                      cmp  $ABAA,X         ; -> $ABC2 ; A=$0018 X=$0018 Y=$00A0 ; [SP-600]
00644E  DD EA AB                      cmp  $ABEA,X         ; -> $AC02 ; A=$0018 X=$0018 Y=$00A0 ; [SP-600]
006451  DD EA FF                      cmp  $FFEA,X         ; NMI_VEC_N - NMI vector (native mode)
006454  FF FF FF FF                   sbc  >$FFFFFF,X      ; -> $000017 ; A=$0018 X=$0018 Y=$00A0 ; [SP-600]
006458  FF FF FF FF                   sbc  >$FFFFFF,X      ; -> $000017 ; A=$0018 X=$0018 Y=$00A0 ; [SP-600]
00645C  AB                            plb                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-599]
00645D  DD EA AB                      cmp  $ABEA,X         ; -> $AC02 ; A=$0018 X=$0018 Y=$00A0 ; [SP-599]
006460  DD EA AA                      cmp  $AAEA,X         ; -> $AB02 ; A=$0018 X=$0018 Y=$00A0 ; [SP-599]
006463  DD AA AC                      cmp  $ACAA,X         ; -> $ACC2 ; A=$0018 X=$0018 Y=$00A0 ; [SP-599]
006466  DD 9A A8                      cmp  $A89A,X         ; -> $A8B2 ; A=$0018 X=$0018 Y=$00A0 ; [SP-599]
006469  DD 8A B0                      cmp  $B08A,X         ; -> $B0A2 ; A=$0018 X=$0018 Y=$00A0 ; [SP-599]
00646C  DD 86 A0                      cmp  $A086,X         ; -> $A09E ; A=$0018 X=$0018 Y=$00A0 ; [SP-599]
00646F  DD 82 C0                      cmp  $C082,X         ; LCBANK2RO - LC Bank 2, read ROM, no write {Language Card} <language_card>
006472  FF 81 80 FF                   sbc  >$FF8081,X      ; -> $FF8099 ; A=$0018 X=$0018 Y=$00A0 ; [SP-599]
006476  80 FD                         bra  $6475           ; A=$0018 X=$0018 Y=$00A0 ; [SP-599]
; === End of while loop ===


; --- Data region ---
006478  00                      HEX     00
; --- End data region (1 bytes) ---

006479  DF FD 00 DF                   cmp  >$DF00FD,X      ; -> $DF0115 ; A=$0018 X=$0018 Y=$00A0 ; [SP-602]
00647D  F9 FF CF                      sbc  $CFFF,Y         ; SLOTEXP_$7FF - Slot expansion ROM offset $7FF {Slot}
006480  F4 FF 97                      pea  $97FF           ; A=$0018 X=$0018 Y=$00A0 ; [SP-604]
006483  C4 9C                         cpy  $9C             ; A=$0018 X=$0018 Y=$00A0 ; [SP-604]
006485  91 D4                         sta  ($D4),Y         ; A=$0018 X=$0018 Y=$00A0 ; [SP-604]
006487  AA                            tax                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-604]
006488  95 C0                         sta  $C0,X           ; -> $00D8 ; A=$0018 X=$0018 Y=$00A0 ; [SP-604]
00648A  AA                            tax                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-604]
00648B  81 C0                         sta  ($C0,X)         ; A=$0018 X=$0018 Y=$00A0 ; [SP-604]
00648D  AA                            tax                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-604]
00648E  81 C0                         sta  ($C0,X)         ; A=$0018 X=$0018 Y=$00A0 ; [SP-604]
; -- language_card: LC Bank 2, read ROM, write RAM --
006490  9C 81 C0                      stz  $C081           ; LCBANK2RD - LC Bank 2, read ROM, write RAM {Language Card} <language_card>
006493  BE 81 C0                      ldx  $C081,Y         ; LCBANK2RD - LC Bank 2, read ROM, write RAM {Language Card} <language_card>
006496  BE 81 C0                      ldx  $C081,Y         ; LCBANK2RD - LC Bank 2, read ROM, write RAM {Language Card} <language_card>
006499  BE 81 C0                      ldx  $C081,Y         ; LCBANK2RD - LC Bank 2, read ROM, write RAM {Language Card} <language_card>
00649C  BE 81 C0                      ldx  $C081,Y         ; LCBANK2RD - LC Bank 2, read ROM, write RAM {Language Card} <language_card>
00649F  AA                            tax                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-604]
0064A0  81 00                         sta  ($00,X)         ; A=$0018 X=$0018 Y=$00A0 ; [SP-604]
0064A2  AA                            tax                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-604]
0064A3  00 00                         brk  #$00            ; A=$0018 X=$0018 Y=$00A0 ; [SP-607]

; --- Data region ---
0064A5  00D00000                HEX     00D00000 D40000E4 0000F500 00F90000
0064B5  F900AAF9                HEX     F900AAF9 C000B9D0 9E99D0BD 9DD0BD9D
0064C5  D0BD9DD0                HEX     D0BD9DD0 9E99C000 B900AAF9 0000F100
0064D5  00F90000                HEX     00F90000 F50000E4 0000D400 00D000AA
0064E5  00C0AA81                HEX     00C0AA81 C0BE81C0 BE81C0BE 81C0BE81
0064F5  C09C81C0                HEX     C09C81C0 AA81C0AA 81D4AA95 C49C91F4
006505  FF97F9FF                HEX     FF97F9FF CFFD00DF FD00DF85 00009500
006515  00930000                HEX     00930000 D70000CF 0000CF00 00CFAA00
006525  CE0081CC                HEX     CE0081CC BC85DCBE 85DCBE85 DCBE85CC
006535  BC85CE00                HEX     BC85CE00 81CFAA00 CF0000CF 0000D700
006545  00930000                HEX     00930000 95000085 00009494 D5D5D594
006555  94D000D0                HEX     94D000D0 00D482D4 82D482D0 00D000C0
006565  82C082D0                HEX     82C082D0 8AD08AD0 8AC082C0 82008A00
006575  8AC0AAC0                HEX     8AC0AAC0 AAC0AA00 8A0008A8 00A800AA
006585  81AA81AA                HEX     81AA81AA 81A800A8 00A081A0 81A885A8
006595  85A885A0                HEX     85A885A0 81A08100 850085A0 95A095A0
0065A5  95008500                HEX     95008500 85E08700 B89D00AE F500AFF4
0065B5  81AEF500                HEX     81AEF500 B89D00E0 8700009F 00E0F500
0065C5  B8D583BC                HEX     B8D583BC D187B8D5 83E0F500 009F0000
0065D5  FC0000D7                HEX     FC0000D7 83E0D58E F0C59EE0 D58E00D7
0065E5  8300FC00                HEX     8300FC00 00F08300 DC8E00D7 BAC097FA
0065F5  00D7BA00                HEX     00D7BA00 DC8E00F0 83C08F00 F0BA00DC
006605  EA81DEE8                HEX     EA81DEE8 83DCEA81 F0BA00C0 8F0000BE
006615  00C0EB81                HEX     00C0EB81 F0AA87F8 A28FF0AA 87C0EB81
006625  00BE0000                HEX     00BE0000 F88100AE 87C0AB9D E08BBDC0
006635  AB9D00AE                HEX     AB9D00AE 8700F881 3E6B
; --- End data region (410 bytes) ---

00663F  7F 5D 63 3E       L_00663F    adc  >$3E635D,X      ; -> $3E6375 ; A=$0018 X=$0018 Y=$00A0 ; [SP-740]
006643  78                            sei                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-740]
006644  01 2C                         ora  ($2C,X)         ; A=$0018 X=$0018 Y=$00A0 ; [SP-740]
006646  03 7C                         ora  $7C,S           ; A=$0018 X=$0018 Y=$00A0 ; [SP-740]
006648  03 74                         ora  $74,S           ; A=$0018 X=$0018 Y=$00A0 ; [SP-740]
00664A  02 0C                         cop  #$0C            ; A=$0018 X=$0018 Y=$00A0 ; [SP-743]

; --- Data region ---
00664C  03780160                HEX     03780160
; --- End data region (4 bytes) ---

006650  07 30             L_006650    ora  [$30]           ; A=$0018 X=$0018 Y=$00A0 ; [SP-743]
006652  0D 70 0F                      ora  $0F70           ; A=$0018 X=$0018 Y=$00A0 ; [SP-743]
006655  50 0B                         bvc  L_006662        ; A=$0018 X=$0018 Y=$00A0 ; [SP-743]
006657  30 0C                         bmi  L_006665        ; A=$0018 X=$0018 Y=$00A0 ; [SP-743]
006659  60                            rts                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-741]

; --- Data region ---
00665A  07001F40                HEX     07001F40 35403F40
; --- End data region (8 bytes) ---

006662  2E 40 31          L_006662    rol  $3140           ; A=$0018 X=$0018 Y=$00A0 ; [SP-741]
006665  00 1F             L_006665    brk  #$1F            ; A=$0018 X=$0018 Y=$00A0 ; [SP-741]

; --- Data region ---
006667  7C005601                HEX     7C005601 7E013A01 46017C00 70035806
006677  78076805                HEX     78076805 18067003 400F60
; --- End data region (27 bytes) ---

006682  1A                L_006682    inc  a               ; A=$0018 X=$0018 Y=$00A0 ; [SP-744]
006683  60                            rts                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-744]

; --- Data region ---
006684  1F201760                HEX     1F201760
; --- End data region (4 bytes) ---

006688  18                L_006688    clc                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-744]
; Interrupt return (RTI)
006689  40                            rti                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-741]

; --- Data region ---
00668A  0F0B1C3E                HEX     0F0B1C3E 7F3E1C08 20007000 78017C03
00669A  78017000                HEX     78017000 20000001 400360
; --- End data region (27 bytes) ---

0066A5  07 70             L_0066A5    ora  [$70]           ; A=$0018 X=$0018 Y=$00A0 ; [SP-752]
0066A7  0F 60 07 40                   ora  >$400760        ; A=$0018 X=$0018 Y=$00A0 ; [SP-752]
0066AB  03 00                         ora  $00,S           ; A=$0018 X=$0018 Y=$00A0 ; [SP-752]
0066AD  01 00                         ora  ($00,X)         ; A=$0018 X=$0018 Y=$00A0 ; [SP-752]
0066AF  04 00                         tsb  $00             ; A=$0018 X=$0018 Y=$00A0 ; [SP-752]
0066B1  0E 00 1F                      asl  $1F00           ; A=$0018 X=$0018 Y=$00A0 ; [SP-752]
; Interrupt return (RTI)
0066B4  40                            rti                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-749]

; --- Data region ---
0066B5  3F001F00                HEX     3F001F00 0E000410 0038007C 007E017C
0066C5  00380010                HEX     00380010 00400060
; --- End data region (24 bytes) ---

0066CD  01 70             L_0066CD    ora  ($70,X)         ; A=$0018 X=$0018 Y=$00A0 ; [SP-767]
0066CF  03 78                         ora  $78,S           ; A=$0018 X=$0018 Y=$00A0 ; [SP-767]
0066D1  07 70                         ora  [$70]           ; A=$0018 X=$0018 Y=$00A0 ; [SP-767]
0066D3  03 60                         ora  $60,S           ; A=$0018 X=$0018 Y=$00A0 ; [SP-767]
0066D5  01 40                         ora  ($40,X)         ; A=$0018 X=$0018 Y=$00A0 ; [SP-767]
0066D7  00 00                         brk  #$00            ; A=$0018 X=$0018 Y=$00A0 ; [SP-770]

; --- Data region ---
0066D9  02000740                HEX     02000740 0F60
; --- End data region (6 bytes) ---

0066DF  1F 40 0F 00       L_0066DF    ora  >$000F40,X      ; -> $000F58 ; A=$0018 X=$0018 Y=$00A0 ; [SP-773]
0066E3  07 00                         ora  [$00]           ; A=$0018 X=$0018 Y=$00A0 ; [SP-773]
0066E5  02 28                         cop  #$28            ; A=$0018 X=$0018 Y=$00A0 ; [SP-776]

; --- Data region ---
0066E7  002A012A                HEX     002A012A 01D480AA 81AA81A8 00200128
0066F7  052805D0                HEX     052805D0 82A885A8 85A08100 05201520
006707  15008AA0                HEX     15008AA0 95A09500 85001400 55005500
006717  AA00D500                HEX     AA00D500 D5009450 00540254 02A800D4
006727  82D482D0                HEX     82D482D0 00400250 0A500AA0 84D08AD0
006737  8AC08200                HEX     8AC08200 0A402A40 2A0095C0 AAC0AA00
006747  AA94D5F7                HEX     AA94D5F7 D5115544 D000D482 DC83D482
006757  10025402                HEX     10025402 4400C082 D08AF08E D08A1002
006767  500A400B                HEX     500A400B 008AC0AA C0BBC0AA 0022402A
; Interrupt return (RTI)
006777  4008A880                HEX     4008A880 AA81EE81 AA812200 2A010801
006787  A081A885                HEX     A081A885 B887A885 20042805 08010085
006797  A095E09D                HEX     A095E09D A0952004 20150011 04045555
0067A7  55040450                HEX     55040450 00500054 02540254 02500050
0067B7  00400240                HEX     00400240 02500A50 0A500A40 02400200
0067C7  0A000A40                HEX     0A000A40 2A402A40 2A000A00 00280028
0067D7  002A012A                HEX     002A012A 012A0128 00280020 01200128
0067E7  05280528                HEX     05280528 05200120 01000500 05201520
0067F7  15201500                HEX     15201500 05000500 60
; --- End data region (281 bytes) ---

006800  07 00             L_006800    ora  [$00]           ; A=$0018 X=$0018 Y=$00A0 ; [SP-854]
006802  00 38                         brk  #$38            ; A=$0018 X=$0018 Y=$00A0 ; [SP-857]

; --- Data region ---
006804  1D00002E                HEX     1D00002E 7500002F 7401002E 75000038
006814  1D000060                HEX     1D000060
; --- End data region (20 bytes) ---

006818  07 00             L_006818    ora  [$00]           ; A=$0018 X=$0018 Y=$00A0 ; [SP-864]
00681A  00 1F                         brk  #$1F            ; A=$0018 X=$0018 Y=$00A0 ; [SP-867]

; --- Data region ---
00681C  0060                    HEX     0060
; --- End data region (2 bytes) ---

00681E  75 00             L_00681E    adc  $00,X           ; -> $0018 ; A=$0018 X=$0018 Y=$00A0 ; [SP-870]
006820  38                            sec                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-870]
006821  55 03                         eor  $03,X           ; -> $001B ; A=$0018 X=$0018 Y=$00A0 ; [SP-870]
006823  3C 51 07                      bit  $0751,X         ; -> $0769 ; A=$0018 X=$0018 Y=$00A0 ; [SP-870]
006826  38                            sec                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-870]
006827  55 03                         eor  $03,X           ; -> $001B ; A=$0018 X=$0018 Y=$00A0 ; [SP-870]
006829  60                            rts                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-868]

; --- Data region ---
00682A  7500001F                HEX     7500001F 00007C00 00570360
; --- End data region (12 bytes) ---

006836  55 0E             L_006836    eor  $0E,X           ; -> $0026 ; A=$0018 X=$0018 Y=$00A0 ; [SP-872]
006838  70 45                         bvs  L_00687F        ; A=$0018 X=$0018 Y=$00A0 ; [SP-872]
00683A  1E 60 55                      asl  $5560,X         ; -> $5578 ; A=$0018 X=$0018 Y=$00A0 ; [SP-872]
00683D  0E 00 57                      asl  $5700           ; A=$0018 X=$0018 Y=$00A0 ; [SP-872]
006840  03 00                         ora  $00,S           ; A=$0018 X=$0018 Y=$00A0 ; [SP-872]
006842  7C 00 00                      jmp  ($0000,X)       ; A=$0018 X=$0018 Y=$00A0 ; [SP-872]

; --- Data region ---
006845  7003005C                HEX     7003005C 0E00573A 40177A00 573A005C
006855  0E007083                HEX     0E007083 400F0070 3A005C6A 015E6803
006865  5C6A0170                HEX     5C6A0170 3A00400F 00003E00 406B
; --- End data region (46 bytes) ---

006873  01 70             L_006873    ora  ($70,X)         ; A=$0018 X=$0018 Y=$00A0 ; [SP-883]
006875  2A                            rol  a               ; A=$0018 X=$0018 Y=$00A0 ; [SP-883]
006876  07 78                         ora  [$78]           ; A=$0018 X=$0018 Y=$00A0 ; [SP-883]
006878  22 0F 70 2A                   jsl  >$2A700F        ; A=$0018 X=$0018 Y=$00A0 ; [SP-886]
00687C  07 40                         ora  [$40]           ; A=$0018 X=$0018 Y=$00A0 ; [SP-886]
00687E  6B                            rtl                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-883]
00687F  01 00             L_00687F    ora  ($00,X)         ; A=$0018 X=$0018 Y=$00A0 ; [SP-883]
006881  3E 00 00                      rol  !$0000,X        ; -> $0018 ; A=$0018 X=$0018 Y=$00A0 ; [SP-883]
006884  78                            sei                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-883]
006885  01 00                         ora  ($00,X)         ; A=$0018 X=$0018 Y=$00A0 ; [SP-883]
006887  2E 07 40                      rol  $4007           ; A=$0018 X=$0018 Y=$00A0 ; [SP-883]
00688A  2B                            pld                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-882]
00688B  1D 60 0B                      ora  $0B60,X         ; -> $0B78 ; A=$0018 X=$0018 Y=$00A0 ; [SP-882]
00688E  3D 40 2B                      and  $2B40,X         ; -> $2B58 ; A=$0018 X=$0018 Y=$00A0 ; [SP-882]
006891  1D 00 2E                      ora  $2E00,X         ; -> $2E18 ; A=$0018 X=$0018 Y=$00A0 ; [SP-882]
006894  07 00                         ora  [$00]           ; A=$0018 X=$0018 Y=$00A0 ; [SP-882]
006896  78                            sei                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-882]
006897  01 44                         ora  ($44,X)         ; A=$0018 X=$0018 Y=$00A0 ; [SP-882]
006899  00 28                         brk  #$28            ; A=$0018 X=$0018 Y=$00A0 ; [SP-885]

; --- Data region ---
00689B  0010007F                HEX     0010007F 03410241 03410241 037F0310
0068AB  02200140                HEX     02200140 007C0F04 0A040E04 0A040E7C
0068BB  0F400800                HEX     0F400800 05000270 3F102810 38102810
; String: "8p?"
0068CB  38703F00                HEX     38703F00 22000014 00000800 407F0140
0068DB  20014060                HEX     20014060
; --- End data region (68 bytes) ---

0068DF  01 40             L_0068DF    ora  ($40,X)         ; A=$0018 X=$0018 Y=$00A0 ; [SP-920]
0068E1  20 01 40                      jsr  L_004001        ; A=$0018 X=$0018 Y=$00A0 ; [OPT] TAIL_CALL: Tail call: JSR/JSL at $0068E1 followed by RTS ; [SP-922]
; === End of while loop (counter: X) ===

0068E4  60                            rts                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-920]

; --- Data region ---
0068E5  01407F01                HEX     01407F01 08015000 20007E07 02050207
0068F5  02050207                HEX     02050207 7E072004 40020001 781F0814
006905  081C0814                HEX     081C0814 081C781F 00110004 000460
; --- End data region (47 bytes) ---

006914  7F 20 50 20       L_006914    adc  >$205020,X      ; -> $205038 ; A=$0018 X=$0018 Y=$00A0 ; [SP-933]
006918  70 20                         bvs  L_00693A        ; A=$0018 X=$0018 Y=$00A0 ; [SP-933]
00691A  50 20                         bvc  L_00693C        ; A=$0018 X=$0018 Y=$00A0 ; [SP-933]
00691C  70 60                         bvs  L_00697E        ; A=$0018 X=$0018 Y=$00A0 ; [SP-933]
00691E  7F C0 81 D0                   adc  >$D081C0,X      ; -> $D081D8 ; A=$0018 X=$0018 Y=$00A0 ; [SP-933]
006922  85 D4                         sta  $D4             ; A=$0018 X=$0018 Y=$00A0 ; [SP-933]
006924  95 DD                         sta  $DD,X           ; -> $00F5 ; A=$0018 X=$0018 Y=$00A0 ; [SP-933]
006926  D5 D4                         cmp  $D4,X           ; -> $00EC ; A=$0018 X=$0018 Y=$00A0 ; [SP-933]
006928  95 D0                         sta  $D0,X           ; -> $00E8 ; A=$0018 X=$0018 Y=$00A0 ; [SP-933]
00692A  85 C0                         sta  $C0             ; A=$0018 X=$0018 Y=$00A0 ; [SP-933]
00692C  81 00                         sta  ($00,X)         ; A=$0018 X=$0018 Y=$00A0 ; [SP-933]
00692E  86 00                         stx  $00             ; A=$0018 X=$0018 Y=$00A0 ; [SP-933]
006930  C0 96                         cpy  #$96            ; A=$0018 X=$0018 Y=$00A0 ; [SP-933]
006932  00 D0                         brk  #$D0            ; A=$0018 X=$0018 Y=$00A0 ; [SP-936]

; --- Data region ---
006934  D600F4D6                HEX     D600F4D6 82D0
; --- End data region (6 bytes) ---

00693A  D6 00             L_00693A    dec  $00,X           ; -> $0018 ; A=$0018 X=$0018 Y=$00A0 ; [SP-938]
00693C  C0 96             L_00693C    cpy  #$96            ; A=$0018 X=$0018 Y=$00A0 ; [SP-941]
00693E  00 00                         brk  #$00            ; A=$0018 X=$0018 Y=$00A0 ; [SP-941]

; --- Data region ---
006940  86000098                HEX     86000098 0000DA00 C0DA82D0 D88AC0DA
006950  8200DA00                HEX     8200DA00 00980000 E08000E8 8200EA8A
006960  C0EEAA00                HEX     C0EEAA00 EA8A00E8 8200E080 008300A0
006970  8B00A8AB                HEX     8B00A8AB 00BAAB81 A8AB00A0 8B00
; --- End data region (62 bytes) ---

00697E  00 83             L_00697E    brk  #$83            ; A=$0018 X=$0018 Y=$00A0 ; [SP-980]

; --- Data region ---
006980  00008C80                HEX     00008C80 00AD00A0 AD81E8AD 85A0AD81
006990  00AD0000                HEX     00AD0000 8C8000B0 8000B481 00B58540
0069A0  B79500B5                HEX     B79500B5 8500B481 00B08060
; --- End data region (44 bytes) ---

0069AC  01 5C             L_0069AC    ora  ($5C,X)         ; A=$0018 X=$0018 Y=$00A0 ; [SP-989]
0069AE  0E 56 1A                      asl  $1A56           ; A=$0018 X=$0018 Y=$00A0 ; [SP-989]
0069B1  55 2A                         eor  $2A,X           ; -> $0042 ; A=$0018 X=$0018 Y=$00A0 ; [SP-989]
0069B3  7F 3F 4E 1C                   adc  >$1C4E3F,X      ; -> $1C4E57 ; A=$0018 X=$0018 Y=$00A0 ; [SP-989]
0069B7  04 08                         tsb  $08             ; A=$0018 X=$0018 Y=$00A0 ; [SP-989]
0069B9  00 0F                         brk  #$0F            ; A=$0018 X=$0018 Y=$00A0 ; [SP-992]

; --- Data region ---
0069BB  00703A00                HEX     00703A00 586A0054 2A01747F 01387200
0069CB  10200000                HEX     10200000 1C00406B
; --- End data region (24 bytes) ---

0069D3  01 60             L_0069D3    ora  ($60,X)         ; A=$0018 X=$0018 Y=$00A0 ; [SP-1003]
0069D5  2A                            rol  a               ; A=$0018 X=$0018 Y=$00A0 ; [SP-1003]
0069D6  03 50                         ora  $50,S           ; A=$0018 X=$0018 Y=$00A0 ; [SP-1003]
0069D8  2A                            rol  a               ; A=$0018 X=$0018 Y=$00A0 ; [SP-1003]
0069D9  05 70                         ora  $70             ; A=$0018 X=$0018 Y=$00A0 ; [SP-1003]
0069DB  7F 07 60 49                   adc  >$496007,X      ; -> $49601F ; A=$0018 X=$0018 Y=$00A0 ; [SP-1003]
0069DF  03 40                         ora  $40,S           ; A=$0018 X=$0018 Y=$00A0 ; [SP-1003]
0069E1  00 01                         brk  #$01            ; A=$0018 X=$0018 Y=$00A0 ; [SP-1006]

; --- Data region ---
0069E3  00700000                HEX     00700000 2E07002B 0D402A15 407F1F00
0069F3  270E0002                HEX     270E0002 04400338 1D2C352A 557E7F1C
006A03  39081000                HEX     39081000 0E0060
; --- End data region (39 bytes) ---

006A0A  75 00             L_006A0A    adc  $00,X           ; -> $0018 ; A=$0018 X=$0018 Y=$00A0 ; [SP-1011]
006A0C  30 55                         bmi  L_006A63        ; A=$0018 X=$0018 Y=$00A0 ; [SP-1011]
006A0E  01 28                         ora  ($28,X)         ; A=$0018 X=$0018 Y=$00A0 ; [SP-1011]
006A10  55 02                         eor  $02,X           ; -> $001A ; A=$0018 X=$0018 Y=$00A0 ; [SP-1011]
006A12  78                            sei                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-1011]
006A13  7F 03 70 64                   adc  >$647003,X      ; -> $64701B ; A=$0018 X=$0018 Y=$00A0 ; [SP-1011]
006A17  01 20                         ora  ($20,X)         ; A=$0018 X=$0018 Y=$00A0 ; [SP-1011]
; Interrupt return (RTI)
006A19  40                            rti                  ; A=$0018 X=$0018 Y=$00A0 ; [SP-1008]

; --- Data region ---
006A1A  00003800                HEX     00003800 00570340 55062055 0A60
; --- End data region (14 bytes) ---

006A28  7F 0F A0 13       L_006A28    adc  >$13A00F,X      ; -> $13A027 ; A=$0018 X=$0018 Y=$00A0 ; [SP-1011]
006A2C  07 00                         ora  [$00]           ; A=$0018 X=$0018 Y=$00A0 ; [SP-1011]
006A2E  01 02                         ora  ($02,X)         ; A=$0018 X=$0018 Y=$00A0 ; [SP-1011]
006A30  C2 C2                         rep  #$C2            ; A=$0018 X=$0018 Y=$00A0 ; [SP-1011]
006A32  CA                            dex                  ; A=$0018 X=$0017 Y=$00A0 ; [SP-1011]
006A33  D2 AA                         cmp  ($AA)           ; A=$0018 X=$0017 Y=$00A0 ; [SP-1011]
006A35  D4 AA                         pei  ($AA)           ; A=$0018 X=$0017 Y=$00A0 ; [SP-1013]
006A37  D5 AA                         cmp  $AA,X           ; -> $00C1 ; A=$0018 X=$0017 Y=$00A0 ; [SP-1013]
006A39  D4 CA                         pei  ($CA)           ; A=$0018 X=$0017 Y=$00A0 ; [SP-1015]
006A3B  D2 C2                         cmp  ($C2)           ; A=$0018 X=$0017 Y=$00A0 ; [SP-1015]
006A3D  C2 88                         rep  #$88            ; A=$0018 X=$0017 Y=$00A0 ; [SP-1015]
006A3F  8A                            txa                  ; A=$0017 X=$0017 Y=$00A0 ; [SP-1015]
006A40  82 A8 CA                      brl  $34EB           ; SLOTEXP_$2A8 - Slot expansion ROM offset $2A8 {Slot}

; --- Data region ---
006A43  82A8D182                HEX     82A8D182 A8D582A8 D182A8CA 82888A82
; Loop counter: Y=#$A8
006A53  A0A888A0                HEX     A0A888A0 A98AA0C5 8AA0D58A A0C58AA0
; --- End data region (32 bytes) ---

006A63  A9 8A             L_006A63    lda  #$8A            ; A=$008A X=$0017 Y=$00A0 ; [SP-1015]
; Loop counter: Y=#$A8
006A65  A0 A8                         ldy  #$A8            ; A=$008A X=$0017 Y=$00A8 ; [SP-1015]
006A67  88                            dey                  ; A=$008A X=$0017 Y=$00A7 ; [SP-1015]
006A68  00 A1                         brk  #$A1            ; A=$008A X=$0017 Y=$00A7 ; [SP-1018]

; --- Data region ---
006A6A  A100A5A9                HEX     A100A5A9 0095AA00 D5AA0095 AA00A5A9
006A7A  00A1A184                HEX     00A1A184 858194A5 81D4A881 D4AA81D4
006A8A  A88194A5                HEX     A88194A5 81848581 909484D0 9485D0A2
006A9A  85D0AA85                HEX     85D0AA85 D0A285D0 94859094 84C0D090
006AAA  C0D294C0                HEX     C0D294C0 8A95C0AA 95C08A95 C0D294C0
006ABA  D0902277                HEX     D0902277 7F3E1C08 44006E01 7E017C00
006ACA  38001000                HEX     38001000 08015C03 7C037801 70002000
006ADA  10023807                HEX     10023807 78077003 60
; --- End data region (121 bytes) ---

006AE3  01 40             L_006AE3    ora  ($40,X)         ; A=$008A X=$0017 Y=$00A7 ; [SP-1050]
006AE5  00 20                         brk  #$20            ; A=$008A X=$0017 Y=$00A7 ; [SP-1053]

; --- Data region ---
006AE7  04700E70                HEX     04700E70 0F60
; --- End data region (6 bytes) ---

006AED  07 40             L_006AED    ora  [$40]           ; A=$008A X=$0017 Y=$00A7 ; [SP-1051]
006AEF  03 00                         ora  $00,S           ; A=$008A X=$0017 Y=$00A7 ; [SP-1051]
006AF1  01 40                         ora  ($40,X)         ; A=$008A X=$0017 Y=$00A7 ; [SP-1051]
006AF3  08                            php                  ; A=$008A X=$0017 Y=$00A7 ; [SP-1052]
006AF4  60                            rts                  ; A=$008A X=$0017 Y=$00A7 ; [SP-1050]

; --- Data region ---
006AF5  1D60                    HEX     1D60
; --- End data region (2 bytes) ---

006AF7  1F 40 0F 00       L_006AF7    ora  >$000F40,X      ; -> $000F57 ; A=$008A X=$0017 Y=$00A7 ; [SP-1050]
006AFB  07 00                         ora  [$00]           ; A=$008A X=$0017 Y=$00A7 ; [SP-1047]
006AFD  02 00                         cop  #$00            ; A=$008A X=$0017 Y=$00A7 ; [SP-1050]

; --- Data region ---
006AFF  11403B40                HEX     11403B40 3F001F00 0E000408 1C3E7F77
006B0F  22100038                HEX     22100038 007C007E 016E0144 00200070
006B1F  0078017C                HEX     0078017C 035C0308 01400060
; --- End data region (44 bytes) ---

006B2B  01 70             L_006B2B    ora  ($70,X)         ; A=$008A X=$0017 Y=$00A7 ; [SP-1066]
006B2D  03 78                         ora  $78,S           ; A=$008A X=$0017 Y=$00A7 ; [SP-1066]
006B2F  07 38                         ora  [$38]           ; A=$008A X=$0017 Y=$00A7 ; [SP-1066]
006B31  07 10                         ora  [$10]           ; A=$008A X=$0017 Y=$00A7 ; [SP-1066]
006B33  02 00                         cop  #$00            ; A=$008A X=$0017 Y=$00A7 ; [SP-1069]

; --- Data region ---
006B35  01400360                HEX     01400360
; --- End data region (4 bytes) ---

006B39  07 70             L_006B39    ora  [$70]           ; A=$008A X=$0017 Y=$00A7 ; [SP-1069]
006B3B  0F 70 0E 20                   ora  >$200E70        ; A=$008A X=$0017 Y=$00A7 ; [SP-1069]
006B3F  04 00                         tsb  $00             ; A=$008A X=$0017 Y=$00A7 ; [SP-1069]
006B41  02 00                         cop  #$00            ; A=$008A X=$0017 Y=$00A7 ; [SP-1072]

; --- Data region ---
006B43  07400F60                HEX     07400F60
; --- End data region (4 bytes) ---

006B47  1F 60 1D 40       L_006B47    ora  >$401D60,X      ; -> $401D77 ; A=$008A X=$0017 Y=$00A7 ; [SP-1072]
006B4B  08                            php                  ; A=$008A X=$0017 Y=$00A7 ; [SP-1072]
006B4C  00 04                         brk  #$04            ; A=$008A X=$0017 Y=$00A7 ; [SP-1075]

; --- Data region ---
006B4E  000E001F                HEX     000E001F 403F403B 00114000 04000001
006B5E  02000002                HEX     02000002 01000044 00000028 00000010
006B6E  00007F7F                HEX     00007F7F 7F037F7F 7F030300 1C030300
006B7E  1C030300                HEX     1C030300 7C030300 7C030300 1C030300
006B8E  1C030300                HEX     1C030300 7C030300 7C030300 7C030300
006B9E  7C030300                HEX     7C030300 7C030300 7C030300 7C030300
006BAE  7C037F7F                HEX     7C037F7F 7F037F7F 7F030008 40000010
006BBE  20000020                HEX     20000020 10000040 08000000 05000000
006BCE  0200707F                HEX     0200707F 7F3F707F 7F3F3000 40333000
; Interrupt return (RTI)
; String: "@30"
006BDE  40333000                HEX     40333000 403F3000 403F3000 40333000
; Interrupt return (RTI)
; String: "@30"
006BEE  40333000                HEX     40333000 403F3000 403F3000 403F3000
; Interrupt return (RTI)
; String: "@?0"
006BFE  403F3000                HEX     403F3000 403F3000 403F3000 403F3000
; Interrupt return (RTI)
006C0E  403F707F                HEX     403F707F 7F3F707F 7F3F0002 10000004
006C1E  08000008                HEX     08000008 04000010 02000020 01000040
006C2E  00007C7F                HEX     00007C7F 7F0F7C7F 7F0F0C00 700C0C00
006C3E  700C0C00                HEX     700C0C00 700F0C00 700F0C00 700C0C00
006C4E  700C0C00                HEX     700C0C00 700F0C00 700F0C00 700F0C00
006C5E  700F0C00                HEX     700F0C00 700F0C00 700F0C00 700F0C00
006C6E  700F7C7F                HEX     700F7C7F 7F0F7C7F 7F0F0020 00020000
; Interrupt return (RTI)
006C7E  40000100                HEX     40000100 00004100 00000022 00000000
006C8E  14000000                HEX     14000000 00080000 407F7F7F 01407F7F
006C9E  7F014001                HEX     7F014001 004E0140 01004E01 4001007E
006CAE  01400100                HEX     01400100 7E014001 004E0140 01004E01
; Interrupt return (RTI)
006CBE  4001007E                HEX     4001007E 01400100 7E014001 007E0140
006CCE  01007E01                HEX     01007E01 4001007E 01400100 7E014001
006CDE  007E0140                HEX     007E0140 01007E01 407F7F7F 01407F7F
006CEE  7F010001                HEX     7F010001 08000002 04000004 02000008
006CFE  01000050                HEX     01000050 00000020 00007E7F 7F077E7F
006D0E  7F070600                HEX     7F070600 38060600 38060600 78070600
006D1E  78070600                HEX     78070600 38060600 38060600 78070600
006D2E  78070600                HEX     78070600 78070600 78070600 78070600
006D3E  78070600                HEX     78070600 78070600 78077E7F 7F077E7F
006D4E  7F070004                HEX     7F070004 20000008 10000010 08000020
006D5E  04000040                HEX     04000040 02000000 0100787F 7F1F787F
006D6E  7F1F1800                HEX     7F1F1800 60
; --- End data region (549 bytes) ---

006D73  19 18 00          L_006D73    ora  !$0018,Y        ; -> $00BF ; A=$008A X=$0017 Y=$00A7 ; [SP-1327]
006D76  60                            rts                  ; A=$008A X=$0017 Y=$00A7 ; [SP-1325]

; --- Data region ---
006D77  19180060                HEX     19180060
; --- End data region (4 bytes) ---

006D7B  1F 18 00 60       L_006D7B    ora  >$600018,X      ; -> $60002F ; A=$008A X=$0017 Y=$00A7 ; [SP-1323]
006D7F  1F 18 00 60                   ora  >$600018,X      ; -> $60002F ; A=$008A X=$0017 Y=$00A7 ; [SP-1323]
006D83  19 18 00                      ora  !$0018,Y        ; -> $00BF ; A=$008A X=$0017 Y=$00A7 ; [SP-1323]
006D86  60                            rts                  ; A=$008A X=$0017 Y=$00A7 ; [SP-1321]

; --- Data region ---
006D87  19180060                HEX     19180060
; --- End data region (4 bytes) ---

006D8B  1F 18 00 60       L_006D8B    ora  >$600018,X      ; -> $60002F ; A=$008A X=$0017 Y=$00A7 ; [SP-1319]
006D8F  1F 18 00 60                   ora  >$600018,X      ; -> $60002F ; A=$008A X=$0017 Y=$00A7 ; [SP-1319]
006D93  1F 18 00 60                   ora  >$600018,X      ; -> $60002F ; A=$008A X=$0017 Y=$00A7 ; [SP-1319]
006D97  1F 18 00 60                   ora  >$600018,X      ; -> $60002F ; A=$008A X=$0017 Y=$00A7 ; [SP-1319]
006D9B  1F 18 00 60                   ora  >$600018,X      ; -> $60002F ; A=$008A X=$0017 Y=$00A7 ; [SP-1319]
006D9F  1F 18 00 60                   ora  >$600018,X      ; -> $60002F ; A=$008A X=$0017 Y=$00A7 ; [SP-1319]
006DA3  1F 18 00 60                   ora  >$600018,X      ; -> $60002F ; A=$008A X=$0017 Y=$00A7 ; [SP-1319]
006DA7  1F 78 7F 7F                   ora  >$7F7F78,X      ; -> $7F7F8F ; A=$008A X=$0017 Y=$00A7 ; [SP-1319]
006DAB  1F 78 7F 7F                   ora  >$7F7F78,X      ; -> $7F7F8F ; A=$008A X=$0017 Y=$00A7 ; [SP-1319]
006DAF  1F 00 10 00                   ora  >$001000,X      ; -> $001017 ; A=$008A X=$0017 Y=$00A7 ; [SP-1319]
006DB3  00 00                         brk  #$00            ; A=$008A X=$0017 Y=$00A7 ; [SP-1322]

; --- Data region ---
006DB5  20400000                HEX     20400000 40200000 00110000 000A0000
006DC5  00040060                HEX     00040060
; --- End data region (20 bytes) ---

006DC9  7F 7F 7F 60       L_006DC9    adc  >$607F7F,X      ; -> $607F96 ; A=$008A X=$0017 Y=$00A7 ; [SP-1347]
006DCD  7F 7F 7F 60                   adc  >$607F7F,X      ; -> $607F96 ; A=$008A X=$0017 Y=$00A7 ; [SP-1347]
006DD1  00 00                         brk  #$00            ; A=$008A X=$0017 Y=$00A7 ; [SP-1350]

; --- Data region ---
006DD3  67600000                HEX     67600000 67600000 7F600000 7F600000
006DE3  67600000                HEX     67600000 67600000 7F600000 7F600000
006DF3  7F600000                HEX     7F600000 7F600000 7F600000 7F600000
006E03  7F600000                HEX     7F600000 7F60
; --- End data region (54 bytes) ---

006E09  7F 7F 7F 60       L_006E09    adc  >$607F7F,X      ; -> $607F96 ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E0D  7F 7F 7F 03                   adc  >$037F7F,X      ; -> $037F96 ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E11  3F 33 3F 03                   and  >$033F33,X      ; -> $033F4A ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E15  03 3F                         ora  $3F,S           ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E17  33 3F                         and  ($3F,S),Y       ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E19  03 03                         ora  $03,S           ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E1B  03 33                         ora  $33,S           ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E1D  03 03                         ora  $03,S           ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E1F  03 1F                         ora  $1F,S           ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E21  33 1F                         and  ($1F,S),Y       ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E23  03 03                         ora  $03,S           ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E25  03 33                         ora  $33,S           ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E27  03 03                         ora  $03,S           ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E29  3F 3F 1E 3F                   and  >$3F1E3F,X      ; -> $3F1E56 ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E2D  3F 3F 3F 0C                   and  >$0C3F3F,X      ; -> $0C3F56 ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E31  3F 3F 33 1E                   and  >$1E333F,X      ; -> $1E3356 ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E35  33 40                         and  ($40,S),Y       ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E37  31 3F                         and  ($3F),Y         ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E39  33 00                         and  ($00,S),Y       ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E3B  1C 33 1E                      trb  $1E33           ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E3E  33 40                         and  ($40,S),Y       ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E40  31 3F                         and  ($3F),Y         ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E42  33 00                         and  ($00,S),Y       ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E44  1C 33 3F                      trb  $3F33           ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E47  33 40                         and  ($40,S),Y       ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E49  31 3F                         and  ($3F),Y         ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E4B  33 00                         and  ($00,S),Y       ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E4D  1C 33 3F                      trb  $3F33           ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E50  33 40                         and  ($40,S),Y       ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E52  31 3F                         and  ($3F),Y         ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E54  33 00                         and  ($00,S),Y       ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E56  1C 33 33                      trb  $3333           ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E59  33 40                         and  ($40,S),Y       ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E5B  31 0C                         and  ($0C),Y         ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E5D  37 00                         and  [$00],Y         ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E5F  1C 33 33                      trb  $3333           ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E62  33 40                         and  ($40,S),Y       ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E64  31 0C                         and  ($0C),Y         ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E66  37 00                         and  [$00],Y         ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E68  1C 1E 33                      trb  $331E           ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E6B  33 40                         and  ($40,S),Y       ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E6D  35 0C                         and  $0C,X           ; -> $0023 ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E6F  3F 00 1C 1E                   and  >$1E1C00,X      ; -> $1E1C17 ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
006E73  33 33                         and  ($33,S),Y       ; A=$008A X=$0017 Y=$00A7 ; [SP-1362]
; Interrupt return (RTI)
006E75  40                            rti                  ; A=$008A X=$0017 Y=$00A7 ; [SP-1359]

; --- Data region ---
006E76  350C3F00                HEX     350C3F00 1C0C3333 40350C3B 00000C33
006E86  3340350C                HEX     3340350C 3B00000C 3F3F403B 3F33001C
006E96  0C3F3F40                HEX     0C3F3F40 3B3F3300 1C0C1E1E 40313F33
006EA6  001C0C1E                HEX     001C0C1E 1E40313F 33001C18 003C0019
006EB6  017F0118                HEX     017F0118 0018003C 00240024 002400FE
006EC6  FF8F8180                HEX     FF8F8180 90FFFF9F D5AA9581 80908180
006ED6  90DDBB97                HEX     90DDBB97 D58895CD 9993D588 95DDBB95
006EE6  81809081                HEX     81809081 80908180 90819F90 E1F590B9
006EF6  D593BDD1                HEX     D593BDD1 97B9D593 E1F59081 9F908180
006F06  90818090                HEX     90818090 FEFF8FF8 FFBF8480 C0FCFFFF
006F16  D4AAD584                HEX     D4AAD584 80C08480 C0F4EEDD D4A2D4B4
006F26  E6CCD4A2                HEX     E6CCD4A2 D4F4EED5 8480C084 80C08480
006F36  C084FCC0                HEX     C084FCC0 84D7C3E4 D5CEF4C5 DEE4D5CE
006F46  84D7C384                HEX     84D7C384 FCC08480 C08480C0 F8FFBFE0
006F56  FFFF8190                HEX     FFFF8190 808082F0 FFFF83D0 AAD58290
006F66  80808290                HEX     80808290 808082D0 BBF782D0 8AD182D0
006F76  99B382D0                HEX     99B382D0 8AD182D0 BBD78290 80808290
006F86  80808290                HEX     80808290 80808290 F0838290 DC8E8290
006F96  D7BA82D0                HEX     D7BA82D0 97FA8290 D7BA8290 DC8E8290
006FA6  F0838290                HEX     F0838290 80808290 808082E0 FFFF8180
006FB6  FFFF87C0                HEX     FFFF87C0 808088C0 FFFF8FC0 AAD58AC0
006FC6  808088C0                HEX     808088C0 808088C0 EEDD8BC0 AAC48AC0
006FD6  E6CC89C0                HEX     E6CC89C0 AAC48AC0 EEDD8AC0 808088C0
006FE6  808088C0                HEX     808088C0 808088C0 C08F88C0 F0BA88C0
006FF6  DCEA89C0                HEX     DCEA89C0 DEE88BC0 DCEA89C0 F0BA88C0
007006  C08F88C0                HEX     C08F88C0 808088C0 80808880 FFFF87FC
007016  FF9F8280                HEX     FF9F8280 A0FEFFBF AAD5AA82 80A08280
007026  A0BAF7AE                HEX     A0BAF7AE AA91AA9A B3A6AA91 AABAF7AA
007036  8280A082                HEX     8280A082 80A08280 A082BEA0 C2EBA1F2
007046  AAA7FAA2                HEX     AAA7FAA2 AFF2AAA7 C2EBA182 BEA08280
007056  A08280A0                HEX     A08280A0 FCFF9FF0 FFFF8088 808081F8
007066  FFFF81A8                HEX     FFFF81A8 D5AA8188 80808188 808081E8
007076  DDBB81A8                HEX     DDBB81A8 C5A881E8 CC9981A8 C5A881E8
007086  DDAB8188                HEX     DDAB8188 80808188 80808188 80808188
007096  F8818188                HEX     F8818188 AE8781C8 AB9D81E8 8BBD81C8
0070A6  AB9D8188                HEX     AB9D8188 AE878188 F8818188 80808188
0070B6  808081F0                HEX     808081F0 FFFF80C0 FFFF83A0 808084E0
0070C6  FFFF87A0                HEX     FFFF87A0 D5AA85A0 808084A0 808084A0
0070D6  F7EE85A0                HEX     F7EE85A0 95A285A0 B3E684A0 95A285A0
0070E6  F7AE85A0                HEX     F7AE85A0 808084A0 808084A0 808084A0
0070F6  E08784A0                HEX     E08784A0 B89D84A0 AEF584A0 AFF485A0
007106  AEF584A0                HEX     AEF584A0 B89D84A0 E08784A0 808084A0
007116  808084C0                HEX     808084C0 FFFF8300 00000000 00000000
007126  00000000                HEX     00000000 00000000 00000000 00000000
007136  00000000                HEX     00000000 00000000 00000000 00000000
007146  00000000                HEX     00000000 00000000 00000000 00000000
007156  00000000                HEX     00000000 00000000 00000000 00000000
007166  00000000                HEX     00000000 00000000 00000000 00000000
007176  00000000                HEX     00000000 00000000 00000000 00000000
007186  00000000                HEX     00000000 00000000 00000000 00000000
007196  00000000                HEX     00000000 00000000 00000000 00000000
0071A6  00000000                HEX     00000000 00000000 00000000 00000000
0071B6  00000000                HEX     00000000 00000000 00000000 00000000
0071C6  00000000                HEX     00000000 00000000 00000000 00000000
0071D6  00000000                HEX     00000000 00000000 00000000 00000000
0071E6  00000000                HEX     00000000 00000000 00000000 00000000
0071F6  00000000                HEX     00000000 00000000 0000

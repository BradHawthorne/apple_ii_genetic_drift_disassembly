; Disassembly of genetic_drift.bin
; Load address: $37D7
; Length: 14889 bytes ($3A29)
; End address: $71FF

; Strings found:
;   $37F0: "HPyf"
;   $3858: "TPw="
;   $385F: "{IUPs="
;   $3868: "{I;Ps="
;   $38B4: "}/*}"
;   $38BB: "}.-n]"
;   $38C5: "{I[Ps="
;   $38CE: "{I/Ps="
;   $38E4: "HPlf"
;   $38F1: "{I.P3="
;   $38FA: "{InP*"
;   $39D9: "{}{}2{"
;   $39F0: "h{{}"
;   $3A23: "hHPj"
;   $3A65: "UPw="
;   $3A6C: "{I*Psj="
;   $3A76: "{I5p"
;   $3A9D: "P>0= "
;   $3AC3: "HPo<"
;   $3E38: "HP{f"
;   $3E3D: "JPv%"
;   $3E65: "JP}F"
;   $3E6A: "Ptpd"
;   $3E83: "hPx""
;   $3EF0: "BR0DERBUND"
;   $3F04: "PPPPPPPP"
;   $3F14: "PPPPPPPP"
;   $3F24: "PPPPPPPP"
;   $412B: "HPzn"
;   $4131: "JPt-"
;   $41B4: "(((((((("
;   $41C4: "(((((((("
;   $41D4: "(((((((("
;   $41E4: "(((((((("
;   $41F4: "PPPPPPPP"
;   $4204: "PPPPPPPP"
;   $4214: "PPPPPPPP"
;   $4224: "PPPPPPPP"
;   $4F45: "@JPr""
;   $4F55: "@jJPq"
;   $50C9: "  !!""###$$$$$$$$$$$$$$$###"""!!  "
;   $520F: " % ) "
;   $5221: "O ~."
;   $5254: "Ip0y"
;   $526C: "dIv0`"
;   $5285: "~*=*"
;   $52A7: "~*=*"
;   $52F1: "``nq"
;   $53B8: "F%T  g  I   U ) "
;   $576C: "|zywutpkfdb`ywvtsplkhfddxvtqomkigeca|zwupnmlgdb`ttssrrqqppppppppoh`XPH@@pppppppppppp"
;   $5B6F: "*JP}"
;   $5B8E: "I@0y"
;   $5BB8: " EC J$%D1"
;   $5BC8: "  ` =I`S "
;   $5BD6: " $  F P "
;   $5BE1: "I %,"
;   $5BE6: "      %OV   ."
;   $5BF4: "*:   %. C/, O "
;   $5C05: "  .C"
;   $5C0A: " P t"
;   $5C0F: " % V "
;   $5D4A: ":  fR   H  H "
;   $5D58: "T,:  ; ,  P.f/"
;   $5D67: "0+<+"
;   $5D74: ") F C "
;   $5D99: "1FKPU_is}:"
;   $5DB1: "*?Ti~"
;   $5DC1: " .<JXft"
;   $5DD4: "#*8FTbp"
;   $5DE3: "*<Ni{"
;   $5DF0: "+9Ncx"
;   $5DFD: "'<BNZfr~"
;   $607F: "@`pxp`@"
;   $61DA: "*]*+]j+]j"
;   $61EC: "+]j+]j*]*,]"
;   $63CC: "*]*+]j+]j"
;   $63DE: "+]j+]j*]*,]"
;   $644A: "*]*+]j+]j"
;   $645C: "+]j+]j*]*,]"
;   $6576: "@*@*@*"
;   $6742: "@*@*"
;   $676D: "@*@;@*"
;   $6A30: "BBJR*T*U*TJRBB"
;   $6F1E: "@tn]T"T4fLT"TtnU"
;   $6F3B: "WCdUNtE^dUN"
;   $701D: "?*U*"
;   $7026: " :w.*"
;   $7032: "*:w*"
;   $7040: "> Bk!r*'z"/r*'Bk!"

    $37D7: 8D 10 C0    STA  $C010  ; KBDSTRB
    $37DA: A9 38       LDA  #$38
    $37DC: 85 01       STA  $01
    $37DE: A9 00       LDA  #$00
    $37E0: 85 03       STA  $03
    $37E2: A9 40       LDA  #$40
    $37E4: 85 04       STA  $04
    $37E6: A0 00       LDY  #$00
    $37E8: 84 00       STY  $00
    $37EA: 84 02       STY  $02

L_37EC:
    $37EC: B1 00       LDA  ($00),Y
    $37EE: 91 02       STA  ($02),Y
    $37F0: C8          INY  
    $37F1: D0 F9       BNE  L_37EC
    $37F3: E6 01       INC  $01
    $37F5: E6 03       INC  $03
    $37F7: A5 01       LDA  $01
    $37F9: C5 04       CMP  $04
    $37FB: D0 EF       BNE  L_37EC
    $37FD: 4C D7 57    JMP  $57D7
    $3800: 00          BRK  
    $3801: 38          SEC  
    $3802: 00          BRK  
    $3803: 00          BRK  
    $3804: 40          RTI  
    $3805: 93          .BYTE $93
    $3806: 50 29       BVC  L_3831
    $3808: 01 C0       ORA  ($C0,X)
    $380A: 09 28       ORA  #$28
    $380C: 00          BRK  
    $380D: 00          BRK  
    $380E: 00          BRK  
    $380F: 00          BRK  
    $3810: 03          .BYTE $03
    $3811: 00          BRK  
    $3812: 6C 1D B2    JMP  ($B21D)
    $3815: 13          .BYTE $13
    $3816: D1 D1       CMP  ($D1),Y
    $3818: 3C          .BYTE $3C
    $3819: 3B          .BYTE $3B
    $381A: D4          .BYTE $D4
    $381B: 99 9B D1    STA  $D19B,Y

L_381E:
    $381E: F9 BA 00    SBC  $00BA,Y
    $3821: 28          PLP  
    $3822: 00          BRK  
    $3823: 18          CLC  
    $3824: AE 17 02    LDX  $0217
    $3827: 25 D0       AND  $D0
    $3829: 07          .BYTE $07
    $382A: EF          .BYTE $EF
    $382B: 60          RTS  
    $382C: F0 F0       BEQ  L_381E
    $382E: F0 88       BEQ  L_37B8
    $3830: CA          DEX  

L_3831:
    $3831: D7          .BYTE $D7
    $3832: FF          .BYTE $FF
    $3833: 90 84       BCC  L_37B9

L_3835:
    $3835: 1B          .BYTE $1B
    $3836: F0 FD       BEQ  L_3835
    $3838: 1B          .BYTE $1B
    $3839: FD AD 85    SBC  $85AD,X
    $383C: 00          BRK  
    $383D: 72          .BYTE $72
    $383E: 00          BRK  
    $383F: 55 00       EOR  $00,X
    $3841: 25 FF       AND  $FF
    $3843: 85 23       STA  $23
    $3845: 85 24       STA  $24
    $3847: AD 00 02    LDA  $0200
    $384A: 45 25       EOR  $25
    $384C: 0A          ASL  
    $384D: 8D 80 0C    STA  $0C80
    $3850: A6 2B       LDX  $2B

L_3852:
    $3852: BD 8C C0    LDA  $C08C,X
    $3855: 10 FB       BPL  L_3852

L_3857:
    $3857: 49 D4       EOR  #$D4
    $3859: D0 F7       BNE  L_3852

L_385B:
    $385B: BD 8C C0    LDA  $C08C,X
    $385E: 10 FB       BPL  L_385B

L_3860:
    $3860: C9 D5       CMP  #$D5
    $3862: D0 F3       BNE  L_3857

L_3864:
    $3864: BD 8C C0    LDA  $C08C,X
    $3867: 10 FB       BPL  L_3864
    $3869: C9 BB       CMP  #$BB
    $386B: D0 F3       BNE  L_3860

L_386D:
    $386D: BD 8C C0    LDA  $C08C,X
    $3870: 10 FB       BPL  L_386D
    $3872: 38          SEC  
    $3873: 2A          ROL  
    $3874: 85 48       STA  $48

L_3876:
    $3876: BD 8C C0    LDA  $C08C,X
    $3879: 10 FB       BPL  L_3876
    $387B: 25 48       AND  $48
    $387D: 85 A2       STA  $A2

L_387F:
    $387F: BD 8C C0    LDA  $C08C,X
    $3882: 10 FB       BPL  L_387F
    $3884: 38          SEC  
    $3885: 2A          ROL  
    $3886: 85 48       STA  $48

L_3888:
    $3888: BD 8C C0    LDA  $C08C,X
    $388B: 10 FB       BPL  L_3888
    $388D: 25 48       AND  $48
    $388F: 85 A3       STA  $A3

L_3891:
    $3891: BD 8C C0    LDA  $C08C,X
    $3894: 10 FB       BPL  L_3891
    $3896: 38          SEC  
    $3897: 2A          ROL  
    $3898: 85 48       STA  $48

L_389A:
    $389A: BD 8C C0    LDA  $C08C,X
    $389D: 10 FB       BPL  L_389A
    $389F: 25 48       AND  $48
    $38A1: 8D FF FF    STA  $FFFF
    $38A4: C9 FF       CMP  #$FF
    $38A6: D0 C5       BNE  L_386D

L_38A8:
    $38A8: BD 8C C0    LDA  $C08C,X
    $38AB: 10 FB       BPL  L_38A8
    $38AD: C9 FF       CMP  #$FF
    $38AF: D0 07       BNE  L_38B8
    $38B1: 6C 28 00    JMP  ($0028)
    $38B4: FD AF AA    SBC  $AAAF,X
    $38B7: FD 4C 09    SBC  $094C,X
    $38BA: 06 FD       ASL  $FD
    $38BC: AE AD EE    LDX  $EEAD
    $38BF: DD 7B BD    CMP  $BD7B,X
    $38C2: 8C C0 10    STY  $10C0
    $38C5: FB          .BYTE $FB

L_38C6:
    $38C6: C9 DB       CMP  #$DB
    $38C8: D0 F3       BNE  L_38BD

L_38CA:
    $38CA: BD 8C C0    LDA  $C08C,X
    $38CD: 10 FB       BPL  L_38CA
    $38CF: C9 AF       CMP  #$AF
    $38D1: D0 F3       BNE  L_38C6

L_38D3:
    $38D3: BD 8C C0    LDA  $C08C,X
    $38D6: 10 FB       BPL  L_38D3
    $38D8: 2A          ROL  
    $38D9: 85 3F       STA  $3F

L_38DB:
    $38DB: BD 8C C0    LDA  $C08C,X
    $38DE: 10 FB       BPL  L_38DB
    $38E0: 25 3F       AND  $3F
    $38E2: 91 3C       STA  ($3C),Y
    $38E4: C8          INY  
    $38E5: D0 EC       BNE  L_38D3
    $38E7: E6 3D       INC  $3D
    $38E9: C6 40       DEC  $40
    $38EB: D0 E6       BNE  L_38D3

L_38ED:
    $38ED: BD 8C C0    LDA  $C08C,X
    $38F0: 10 FB       BPL  L_38ED
    $38F2: C9 AE       CMP  #$AE
    $38F4: D0 B3       BNE  L_38A9

L_38F6:
    $38F6: BD 8C C0    LDA  $C08C,X
    $38F9: 10 FB       BPL  L_38F6
    $38FB: C9 EE       CMP  #$EE
    $38FD: D0 AA       BNE  L_38A9
    $38FF: 60          RTS  
    $3900: 07          .BYTE $07
    $3901: 00          BRK  
    $3902: A9 4C       LDA  #$4C
    $3904: 8D 00 06    STA  $0600
    $3907: A9 00       LDA  #$00
    $3909: 8D 01 06    STA  $0601
    $390C: A9 B0       LDA  #$B0
    $390E: 8D 02 06    STA  $0602
    $3911: A9 EE       LDA  #$EE
    $3913: 60          RTS  
    $3914: FF          .BYTE $FF
    $3915: FF          .BYTE $FF
    $3916: 00          BRK  
    $3917: 00          BRK  
    $3918: FF          .BYTE $FF
    $3919: FF          .BYTE $FF
    $391A: 00          BRK  
    $391B: 00          BRK  
    $391C: FF          .BYTE $FF
    $391D: FF          .BYTE $FF
    $391E: 00          BRK  
    $391F: 00          BRK  
    $3920: FF          .BYTE $FF
    $3921: FF          .BYTE $FF
    $3922: 00          BRK  
    $3923: 00          BRK  
    $3924: FF          .BYTE $FF
    $3925: FF          .BYTE $FF
    $3926: 00          BRK  
    $3927: 00          BRK  
    $3928: FF          .BYTE $FF
    $3929: FF          .BYTE $FF
    $392A: 00          BRK  
    $392B: 00          BRK  
    $392C: FF          .BYTE $FF
    $392D: FF          .BYTE $FF
    $392E: 00          BRK  
    $392F: 00          BRK  
    $3930: FF          .BYTE $FF
    $3931: FF          .BYTE $FF
    $3932: 00          BRK  
    $3933: 00          BRK  
    $3934: FF          .BYTE $FF
    $3935: FF          .BYTE $FF
    $3936: 00          BRK  
    $3937: 00          BRK  
    $3938: FF          .BYTE $FF
    $3939: FF          .BYTE $FF
    $393A: 00          BRK  
    $393B: 00          BRK  
    $393C: FF          .BYTE $FF
    $393D: FF          .BYTE $FF
    $393E: 00          BRK  
    $393F: 00          BRK  
    $3940: FF          .BYTE $FF
    $3941: FF          .BYTE $FF
    $3942: 00          BRK  
    $3943: 00          BRK  
    $3944: FF          .BYTE $FF
    $3945: FF          .BYTE $FF
    $3946: 00          BRK  
    $3947: 00          BRK  
    $3948: FF          .BYTE $FF
    $3949: FF          .BYTE $FF
    $394A: 00          BRK  
    $394B: 00          BRK  
    $394C: FF          .BYTE $FF
    $394D: FF          .BYTE $FF
    $394E: 00          BRK  
    $394F: 00          BRK  
    $3950: FF          .BYTE $FF
    $3951: FF          .BYTE $FF
    $3952: 00          BRK  
    $3953: 00          BRK  
    $3954: FF          .BYTE $FF
    $3955: FF          .BYTE $FF
    $3956: 00          BRK  
    $3957: 00          BRK  
    $3958: FF          .BYTE $FF
    $3959: FF          .BYTE $FF
    $395A: 00          BRK  
    $395B: 00          BRK  
    $395C: FF          .BYTE $FF
    $395D: FF          .BYTE $FF
    $395E: 00          BRK  
    $395F: 00          BRK  
    $3960: FF          .BYTE $FF
    $3961: FF          .BYTE $FF
    $3962: 00          BRK  
    $3963: 00          BRK  
    $3964: FF          .BYTE $FF
    $3965: FF          .BYTE $FF
    $3966: 00          BRK  
    $3967: 00          BRK  
    $3968: FF          .BYTE $FF
    $3969: FF          .BYTE $FF
    $396A: 00          BRK  
    $396B: 00          BRK  
    $396C: FF          .BYTE $FF
    $396D: FF          .BYTE $FF
    $396E: 00          BRK  
    $396F: 00          BRK  
    $3970: FF          .BYTE $FF
    $3971: FF          .BYTE $FF
    $3972: 00          BRK  
    $3973: 00          BRK  
    $3974: FF          .BYTE $FF
    $3975: FF          .BYTE $FF
    $3976: 00          BRK  
    $3977: 00          BRK  
    $3978: FF          .BYTE $FF
    $3979: FF          .BYTE $FF
    $397A: 00          BRK  
    $397B: 00          BRK  
    $397C: FF          .BYTE $FF
    $397D: FF          .BYTE $FF
    $397E: 00          BRK  
    $397F: 00          BRK  
    $3980: FF          .BYTE $FF
    $3981: FF          .BYTE $FF
    $3982: 00          BRK  
    $3983: 00          BRK  
    $3984: FF          .BYTE $FF
    $3985: FF          .BYTE $FF
    $3986: 00          BRK  
    $3987: 00          BRK  
    $3988: FF          .BYTE $FF
    $3989: FF          .BYTE $FF
    $398A: 00          BRK  
    $398B: 00          BRK  
    $398C: FF          .BYTE $FF
    $398D: FF          .BYTE $FF
    $398E: 00          BRK  
    $398F: 00          BRK  
    $3990: FF          .BYTE $FF
    $3991: FF          .BYTE $FF
    $3992: 00          BRK  
    $3993: 00          BRK  
    $3994: FF          .BYTE $FF
    $3995: FF          .BYTE $FF
    $3996: 00          BRK  
    $3997: 00          BRK  
    $3998: FF          .BYTE $FF
    $3999: FF          .BYTE $FF
    $399A: 00          BRK  
    $399B: 00          BRK  
    $399C: FF          .BYTE $FF
    $399D: FF          .BYTE $FF
    $399E: 00          BRK  
    $399F: 00          BRK  
    $39A0: FF          .BYTE $FF
    $39A1: FF          .BYTE $FF
    $39A2: 00          BRK  
    $39A3: 00          BRK  
    $39A4: FF          .BYTE $FF
    $39A5: FF          .BYTE $FF
    $39A6: 00          BRK  
    $39A7: 00          BRK  
    $39A8: FF          .BYTE $FF
    $39A9: FF          .BYTE $FF
    $39AA: 00          BRK  
    $39AB: 00          BRK  
    $39AC: FF          .BYTE $FF
    $39AD: FF          .BYTE $FF
    $39AE: 00          BRK  
    $39AF: 00          BRK  
    $39B0: FF          .BYTE $FF
    $39B1: FF          .BYTE $FF
    $39B2: 00          BRK  
    $39B3: 00          BRK  
    $39B4: FF          .BYTE $FF
    $39B5: FF          .BYTE $FF
    $39B6: 00          BRK  
    $39B7: 00          BRK  
    $39B8: FF          .BYTE $FF
    $39B9: FF          .BYTE $FF
    $39BA: 00          BRK  
    $39BB: 00          BRK  
    $39BC: FF          .BYTE $FF
    $39BD: FF          .BYTE $FF
    $39BE: 00          BRK  
    $39BF: 00          BRK  
    $39C0: FF          .BYTE $FF
    $39C1: FF          .BYTE $FF
    $39C2: 00          BRK  
    $39C3: 00          BRK  
    $39C4: FF          .BYTE $FF
    $39C5: FF          .BYTE $FF
    $39C6: 00          BRK  
    $39C7: 00          BRK  
    $39C8: FF          .BYTE $FF
    $39C9: FF          .BYTE $FF
    $39CA: 00          BRK  
    $39CB: 00          BRK  
    $39CC: FF          .BYTE $FF
    $39CD: FF          .BYTE $FF
    $39CE: 00          BRK  
    $39CF: 00          BRK  
    $39D0: FF          .BYTE $FF
    $39D1: FF          .BYTE $FF
    $39D2: 00          BRK  
    $39D3: 00          BRK  
    $39D4: FF          .BYTE $FF
    $39D5: FF          .BYTE $FF
    $39D6: 00          BRK  
    $39D7: 00          BRK  
    $39D8: 17          .BYTE $17
    $39D9: FB          .BYTE $FB
    $39DA: FD FB FD    SBC  $FDFB,X
    $39DD: B2          .BYTE $B2
    $39DE: FB          .BYTE $FB
    $39DF: 17          .BYTE $17
    $39E0: 26 17       ROL  $17
    $39E2: 26 FC       ROL  $FC
    $39E4: 17          .BYTE $17
    $39E5: 26 FC       ROL  $FC
    $39E7: 68          PLA  
    $39E8: 00          BRK  
    $39E9: 00          BRK  
    $39EA: 84 17       STY  $17
    $39EC: FB          .BYTE $FB
    $39ED: FD FB 01    SBC  $01FB,X
    $39F0: E8          INX  
    $39F1: FB          .BYTE $FB
    $39F2: FB          .BYTE $FB
    $39F3: FD 87 84    SBC  $8487,X
    $39F6: FA          .BYTE $FA
    $39F7: 43          .BYTE $43
    $39F8: FD 57 4F    SBC  $4F57,X
    $39FB: 0F          .BYTE $0F
    $39FC: 24 64       BIT  $64
    $39FE: EE 04 06    INC  $0604
    $3A01: A2 00       LDX  #$00

L_3A03:
    $3A03: BD 00 08    LDA  $0800,X
    $3A06: 9D 00 02    STA  $0200,X
    $3A09: E8          INX  
    $3A0A: D0 F7       BNE  L_3A03
    $3A0C: 4C 0F 02    JMP  $020F
    $3A0F: A0 AB       LDY  #$AB

L_3A11:
    $3A11: 98          TYA  
    $3A12: 85 3C       STA  $3C
    $3A14: 4A          LSR  
    $3A15: 05 3C       ORA  $3C
    $3A17: C9 FF       CMP  #$FF
    $3A19: D0 09       BNE  L_3A24
    $3A1B: C0 D5       CPY  #$D5
    $3A1D: F0 05       BEQ  L_3A24
    $3A1F: 8A          TXA  
    $3A20: 99 00 08    STA  $0800,Y
    $3A23: E8          INX  

L_3A24:
    $3A24: C8          INY  
    $3A25: D0 EA       BNE  L_3A11
    $3A27: 84 3D       STY  $3D
    $3A29: 84 26       STY  $26
    $3A2B: A9 03       LDA  #$03
    $3A2D: 85 27       STA  $27
    $3A2F: A6 2B       LDX  $2B
    $3A31: 20 5D 02    JSR  $025D
    $3A34: 20 D1 02    JSR  $02D1
    $3A37: 4C 00 88    JMP  $8800
    $3A3A: 00          BRK  
    $3A3B: 00          BRK  
    $3A3C: 00          BRK  
    $3A3D: 00          BRK  
    $3A3E: 00          BRK  
    $3A3F: 00          BRK  
    $3A40: 00          BRK  
    $3A41: 00          BRK  
    $3A42: 00          BRK  
    $3A43: 00          BRK  
    $3A44: 00          BRK  
    $3A45: 00          BRK  
    $3A46: 00          BRK  
    $3A47: 00          BRK  
    $3A48: 00          BRK  
    $3A49: 00          BRK  
    $3A4A: 00          BRK  
    $3A4B: 00          BRK  
    $3A4C: 00          BRK  
    $3A4D: 00          BRK  
    $3A4E: 00          BRK  
    $3A4F: 00          BRK  
    $3A50: 00          BRK  
    $3A51: 00          BRK  
    $3A52: 00          BRK  
    $3A53: 00          BRK  
    $3A54: 00          BRK  
    $3A55: 00          BRK  
    $3A56: 00          BRK  
    $3A57: 00          BRK  
    $3A58: 00          BRK  
    $3A59: 00          BRK  
    $3A5A: 00          BRK  
    $3A5B: 00          BRK  
    $3A5C: 00          BRK  

L_3A5D:
    $3A5D: 18          CLC  

L_3A5E:
    $3A5E: 08          PHP  

L_3A5F:
    $3A5F: BD 8C C0    LDA  $C08C,X
    $3A62: 10 FB       BPL  L_3A5F

L_3A64:
    $3A64: 49 D5       EOR  #$D5
    $3A66: D0 F7       BNE  L_3A5F

L_3A68:
    $3A68: BD 8C C0    LDA  $C08C,X
    $3A6B: 10 FB       BPL  L_3A68
    $3A6D: C9 AA       CMP  #$AA
    $3A6F: D0 F3       BNE  L_3A64
    $3A71: EA          NOP  

L_3A72:
    $3A72: BD 8C C0    LDA  $C08C,X
    $3A75: 10 FB       BPL  L_3A72
    $3A77: C9 B5       CMP  #$B5
    $3A79: F0 09       BEQ  L_3A84
    $3A7B: 28          PLP  
    $3A7C: 90 DF       BCC  L_3A5D
    $3A7E: 49 AD       EOR  #$AD
    $3A80: F0 1F       BEQ  L_3AA1
    $3A82: D0 D9       BNE  L_3A5D

L_3A84:
    $3A84: A0 03       LDY  #$03
    $3A86: 84 2A       STY  $2A

L_3A88:
    $3A88: BD 8C C0    LDA  $C08C,X
    $3A8B: 10 FB       BPL  L_3A88
    $3A8D: 2A          ROL  
    $3A8E: 85 3C       STA  $3C

L_3A90:
    $3A90: BD 8C C0    LDA  $C08C,X
    $3A93: 10 FB       BPL  L_3A90
    $3A95: 25 3C       AND  $3C
    $3A97: 88          DEY  
    $3A98: D0 EE       BNE  L_3A88
    $3A9A: 28          PLP  
    $3A9B: C5 3D       CMP  $3D
    $3A9D: D0 BE       BNE  L_3A5D
    $3A9F: B0 BD       BCS  L_3A5E

L_3AA1:
    $3AA1: A0 9A       LDY  #$9A

L_3AA3:
    $3AA3: 84 3C       STY  $3C

L_3AA5:
    $3AA5: BC 8C C0    LDY  $C08C,X
    $3AA8: 10 FB       BPL  L_3AA5
    $3AAA: 59 00 08    EOR  $0800,Y
    $3AAD: A4 3C       LDY  $3C
    $3AAF: 88          DEY  
    $3AB0: 99 00 08    STA  $0800,Y
    $3AB3: D0 EE       BNE  L_3AA3

L_3AB5:
    $3AB5: 84 3C       STY  $3C

L_3AB7:
    $3AB7: BC 8C C0    LDY  $C08C,X
    $3ABA: 10 FB       BPL  L_3AB7
    $3ABC: 59 00 08    EOR  $0800,Y
    $3ABF: A4 3C       LDY  $3C
    $3AC1: 91 26       STA  ($26),Y
    $3AC3: C8          INY  
    $3AC4: D0 EF       BNE  L_3AB5

L_3AC6:
    $3AC6: BC 8C C0    LDY  $C08C,X
    $3AC9: 10 FB       BPL  L_3AC6
    $3ACB: 59 00 08    EOR  $0800,Y
    $3ACE: D0 8D       BNE  L_3A5D
    $3AD0: 60          RTS  
    $3AD1: A8          TAY  

L_3AD2:
    $3AD2: A2 00       LDX  #$00

L_3AD4:
    $3AD4: B9 00 08    LDA  $0800,Y
    $3AD7: 4A          LSR  
    $3AD8: 3E CC 03    ROL  $03CC,X
    $3ADB: 4A          LSR  
    $3ADC: 3E 99 03    ROL  $0399,X
    $3ADF: 85 3C       STA  $3C
    $3AE1: B1 26       LDA  ($26),Y
    $3AE3: 0A          ASL  
    $3AE4: 0A          ASL  
    $3AE5: 0A          ASL  
    $3AE6: 05 3C       ORA  $3C
    $3AE8: 91 26       STA  ($26),Y
    $3AEA: C8          INY  
    $3AEB: E8          INX  
    $3AEC: E0 33       CPX  #$33
    $3AEE: D0 E4       BNE  L_3AD4
    $3AF0: C6 2A       DEC  $2A
    $3AF2: D0 DE       BNE  L_3AD2
    $3AF4: CC 00 03    CPY  $0300
    $3AF7: D0 03       BNE  L_3AFC
    $3AF9: 60          RTS  
    $3AFA: 00          BRK  
    $3AFB: 00          BRK  

L_3AFC:
    $3AFC: 4C 2D FF    JMP  $FF2D
    $3AFF: 00          BRK  
    $3B00: 00          BRK  
    $3B01: 00          BRK  
    $3B02: 00          BRK  
    $3B03: 00          BRK  
    $3B04: 00          BRK  
    $3B05: 00          BRK  
    $3B06: 00          BRK  
    $3B07: 00          BRK  
    $3B08: 00          BRK  
    $3B09: 00          BRK  
    $3B0A: 00          BRK  
    $3B0B: 00          BRK  
    $3B0C: 00          BRK  
    $3B0D: 00          BRK  
    $3B0E: 00          BRK  
    $3B0F: 00          BRK  
    $3B10: 00          BRK  
    $3B11: 00          BRK  
    $3B12: 00          BRK  
    $3B13: 00          BRK  
    $3B14: 00          BRK  
    $3B15: 00          BRK  
    $3B16: 00          BRK  
    $3B17: 00          BRK  
    $3B18: 00          BRK  
    $3B19: 00          BRK  
    $3B1A: 00          BRK  
    $3B1B: 00          BRK  
    $3B1C: 00          BRK  
    $3B1D: 00          BRK  
    $3B1E: 00          BRK  
    $3B1F: 00          BRK  
    $3B20: 00          BRK  
    $3B21: 00          BRK  
    $3B22: 00          BRK  
    $3B23: 00          BRK  
    $3B24: 00          BRK  
    $3B25: 00          BRK  
    $3B26: 00          BRK  
    $3B27: 00          BRK  
    $3B28: 00          BRK  
    $3B29: 00          BRK  
    $3B2A: 00          BRK  
    $3B2B: 00          BRK  
    $3B2C: 00          BRK  
    $3B2D: 00          BRK  
    $3B2E: 00          BRK  
    $3B2F: 00          BRK  
    $3B30: 00          BRK  
    $3B31: 00          BRK  
    $3B32: 00          BRK  
    $3B33: 00          BRK  
    $3B34: 00          BRK  
    $3B35: 00          BRK  
    $3B36: 00          BRK  
    $3B37: 00          BRK  
    $3B38: 00          BRK  
    $3B39: 00          BRK  
    $3B3A: 00          BRK  
    $3B3B: 00          BRK  
    $3B3C: 00          BRK  
    $3B3D: 00          BRK  
    $3B3E: 00          BRK  
    $3B3F: 00          BRK  
    $3B40: 00          BRK  
    $3B41: 00          BRK  
    $3B42: 00          BRK  
    $3B43: 00          BRK  
    $3B44: 00          BRK  
    $3B45: 00          BRK  
    $3B46: 00          BRK  
    $3B47: 00          BRK  
    $3B48: 00          BRK  
    $3B49: 00          BRK  
    $3B4A: 00          BRK  
    $3B4B: 00          BRK  
    $3B4C: 00          BRK  
    $3B4D: 00          BRK  
    $3B4E: 00          BRK  
    $3B4F: 00          BRK  
    $3B50: 00          BRK  
    $3B51: 00          BRK  
    $3B52: 00          BRK  
    $3B53: 00          BRK  
    $3B54: 00          BRK  
    $3B55: 00          BRK  
    $3B56: 00          BRK  
    $3B57: 00          BRK  
    $3B58: 00          BRK  
    $3B59: 00          BRK  
    $3B5A: 00          BRK  
    $3B5B: 00          BRK  
    $3B5C: 00          BRK  
    $3B5D: 00          BRK  
    $3B5E: 00          BRK  
    $3B5F: 00          BRK  
    $3B60: 00          BRK  
    $3B61: 00          BRK  
    $3B62: 00          BRK  
    $3B63: 00          BRK  
    $3B64: 00          BRK  
    $3B65: 00          BRK  
    $3B66: 00          BRK  
    $3B67: 00          BRK  
    $3B68: 00          BRK  
    $3B69: 00          BRK  
    $3B6A: 00          BRK  
    $3B6B: 00          BRK  
    $3B6C: 00          BRK  
    $3B6D: 00          BRK  
    $3B6E: 00          BRK  
    $3B6F: 00          BRK  
    $3B70: 00          BRK  
    $3B71: 00          BRK  
    $3B72: 00          BRK  
    $3B73: 00          BRK  
    $3B74: 00          BRK  
    $3B75: 00          BRK  
    $3B76: 00          BRK  
    $3B77: 00          BRK  
    $3B78: 00          BRK  
    $3B79: 00          BRK  
    $3B7A: 00          BRK  
    $3B7B: 00          BRK  
    $3B7C: 00          BRK  
    $3B7D: 00          BRK  
    $3B7E: 00          BRK  
    $3B7F: 00          BRK  
    $3B80: 00          BRK  
    $3B81: 00          BRK  
    $3B82: 00          BRK  
    $3B83: 00          BRK  
    $3B84: 00          BRK  
    $3B85: 00          BRK  
    $3B86: 00          BRK  
    $3B87: 00          BRK  
    $3B88: 00          BRK  
    $3B89: 00          BRK  
    $3B8A: 00          BRK  
    $3B8B: 00          BRK  
    $3B8C: 00          BRK  
    $3B8D: 00          BRK  
    $3B8E: 00          BRK  
    $3B8F: 00          BRK  
    $3B90: 00          BRK  
    $3B91: 00          BRK  
    $3B92: 00          BRK  
    $3B93: 00          BRK  
    $3B94: 00          BRK  
    $3B95: 00          BRK  
    $3B96: 00          BRK  
    $3B97: 00          BRK  
    $3B98: 00          BRK  
    $3B99: 00          BRK  
    $3B9A: 00          BRK  
    $3B9B: 00          BRK  
    $3B9C: 00          BRK  
    $3B9D: 00          BRK  
    $3B9E: 00          BRK  
    $3B9F: 00          BRK  
    $3BA0: 00          BRK  
    $3BA1: 00          BRK  
    $3BA2: 00          BRK  
    $3BA3: 00          BRK  
    $3BA4: 00          BRK  
    $3BA5: 00          BRK  
    $3BA6: 00          BRK  
    $3BA7: 00          BRK  
    $3BA8: 00          BRK  
    $3BA9: 00          BRK  
    $3BAA: 00          BRK  
    $3BAB: 00          BRK  
    $3BAC: 00          BRK  
    $3BAD: 00          BRK  
    $3BAE: 00          BRK  
    $3BAF: 00          BRK  
    $3BB0: 00          BRK  
    $3BB1: 00          BRK  
    $3BB2: 00          BRK  
    $3BB3: 00          BRK  
    $3BB4: 00          BRK  
    $3BB5: 00          BRK  
    $3BB6: 00          BRK  
    $3BB7: 00          BRK  
    $3BB8: 00          BRK  
    $3BB9: 00          BRK  
    $3BBA: 00          BRK  
    $3BBB: 00          BRK  
    $3BBC: 00          BRK  
    $3BBD: 00          BRK  
    $3BBE: 00          BRK  
    $3BBF: 00          BRK  
    $3BC0: 00          BRK  
    $3BC1: 00          BRK  
    $3BC2: 00          BRK  
    $3BC3: 00          BRK  
    $3BC4: 00          BRK  
    $3BC5: 00          BRK  
    $3BC6: 00          BRK  
    $3BC7: 00          BRK  
    $3BC8: 00          BRK  
    $3BC9: 00          BRK  
    $3BCA: 00          BRK  
    $3BCB: 00          BRK  
    $3BCC: 00          BRK  
    $3BCD: 00          BRK  
    $3BCE: 00          BRK  
    $3BCF: 00          BRK  
    $3BD0: 00          BRK  
    $3BD1: 00          BRK  
    $3BD2: 00          BRK  
    $3BD3: 00          BRK  
    $3BD4: 00          BRK  
    $3BD5: 00          BRK  
    $3BD6: 00          BRK  
    $3BD7: 00          BRK  
    $3BD8: 00          BRK  
    $3BD9: 00          BRK  
    $3BDA: 00          BRK  
    $3BDB: 00          BRK  
    $3BDC: 00          BRK  
    $3BDD: 00          BRK  
    $3BDE: 00          BRK  
    $3BDF: 00          BRK  
    $3BE0: 00          BRK  
    $3BE1: 00          BRK  
    $3BE2: 00          BRK  
    $3BE3: 00          BRK  
    $3BE4: 00          BRK  
    $3BE5: 00          BRK  
    $3BE6: 00          BRK  
    $3BE7: 00          BRK  
    $3BE8: 00          BRK  
    $3BE9: 00          BRK  
    $3BEA: 00          BRK  
    $3BEB: 00          BRK  
    $3BEC: 00          BRK  
    $3BED: 00          BRK  
    $3BEE: 00          BRK  
    $3BEF: 00          BRK  
    $3BF0: 03          .BYTE $03
    $3BF1: 06 00       ASL  $00
    $3BF3: 06 A3       ASL  $A3
    $3BF5: 00          BRK  
    $3BF6: 00          BRK  
    $3BF7: 00          BRK  
    $3BF8: 00          BRK  
    $3BF9: 00          BRK  
    $3BFA: 00          BRK  
    $3BFB: 00          BRK  
    $3BFC: 00          BRK  
    $3BFD: 00          BRK  
    $3BFE: 00          BRK  
    $3BFF: 00          BRK  
    $3C00: A5 00       LDA  $00
    $3C02: 2A          ROL  
    $3C03: A5 00       LDA  $00
    $3C05: 26 00       ROL  $00
    $3C07: 45 00       EOR  $00
    $3C09: 66 00       ROR  $00
    $3C0B: E6 01       INC  $01
    $3C0D: 65 01       ADC  $01
    $3C0F: 50 02       BVC  L_3C13
    $3C11: E6 01       INC  $01

L_3C13:
    $3C13: 85 00       STA  $00
    $3C15: 60          RTS  
    $3C16: A8          TAY  
    $3C17: B9 7C 5D    LDA  $5D7C,Y
    $3C1A: 8D 4B 04    STA  $044B
    $3C1D: B9 1D 5E    LDA  $5E1D,Y
    $3C20: 8D 4C 04    STA  $044C
    $3C23: A5 02       LDA  $02
    $3C25: 85 03       STA  $03
    $3C27: 18          CLC  
    $3C28: 79 BE 5E    ADC  $5EBE,Y
    $3C2B: 85 02       STA  $02
    $3C2D: A5 04       LDA  $04
    $3C2F: AA          TAX  
    $3C30: 18          CLC  
    $3C31: 79 5F 5F    ADC  $5F5F,Y
    $3C34: 85 05       STA  $05

L_3C36:
    $3C36: E0 C0       CPX  #$C0
    $3C38: B0 27       BCS  L_3C61
    $3C3A: BD 6C 41    LDA  $416C,X
    $3C3D: 85 06       STA  $06
    $3C3F: BD 2C 42    LDA  $422C,X
    $3C42: 85 07       STA  $07
    $3C44: A4 03       LDY  $03

L_3C46:
    $3C46: C0 28       CPY  #$28
    $3C48: B0 05       BCS  L_3C4F
    $3C4A: AD 1C 60    LDA  $601C
    $3C4D: 91 06       STA  ($06),Y

L_3C4F:
    $3C4F: EE 4B 04    INC  $044B
    $3C52: D0 03       BNE  L_3C57
    $3C54: EE 4C 04    INC  $044C

L_3C57:
    $3C57: C8          INY  
    $3C58: C4 02       CPY  $02
    $3C5A: 90 EA       BCC  L_3C46
    $3C5C: E8          INX  
    $3C5D: E4 05       CPX  $05
    $3C5F: 90 D5       BCC  L_3C36

L_3C61:
    $3C61: 60          RTS  
    $3C62: A8          TAY  
    $3C63: B9 7C 5D    LDA  $5D7C,Y
    $3C66: 8D A7 04    STA  $04A7
    $3C69: B9 1D 5E    LDA  $5E1D,Y
    $3C6C: 8D A8 04    STA  $04A8
    $3C6F: A5 02       LDA  $02
    $3C71: 85 03       STA  $03
    $3C73: 18          CLC  
    $3C74: 79 BE 5E    ADC  $5EBE,Y
    $3C77: 85 02       STA  $02
    $3C79: A5 04       LDA  $04
    $3C7B: AA          TAX  
    $3C7C: 18          CLC  
    $3C7D: 79 5F 5F    ADC  $5F5F,Y
    $3C80: 85 05       STA  $05

L_3C82:
    $3C82: E0 C0       CPX  #$C0
    $3C84: B0 39       BCS  L_3CBF
    $3C86: E4 08       CPX  $08
    $3C88: 90 23       BCC  L_3CAD
    $3C8A: E4 09       CPX  $09
    $3C8C: B0 1F       BCS  L_3CAD
    $3C8E: BD 6C 41    LDA  $416C,X
    $3C91: 85 06       STA  $06
    $3C93: BD 2C 42    LDA  $422C,X
    $3C96: 85 07       STA  $07
    $3C98: A4 03       LDY  $03

L_3C9A:
    $3C9A: C0 28       CPY  #$28
    $3C9C: B0 0F       BCS  L_3CAD
    $3C9E: C4 0A       CPY  $0A
    $3CA0: 90 0B       BCC  L_3CAD
    $3CA2: C4 0B       CPY  $0B
    $3CA4: B0 07       BCS  L_3CAD
    $3CA6: AD 00 00    LDA  $0000
    $3CA9: 11 06       ORA  ($06),Y
    $3CAB: 91 06       STA  ($06),Y

L_3CAD:
    $3CAD: EE A7 04    INC  $04A7
    $3CB0: D0 03       BNE  L_3CB5
    $3CB2: EE A8 04    INC  $04A8

L_3CB5:
    $3CB5: C8          INY  
    $3CB6: C4 02       CPY  $02
    $3CB8: 90 E0       BCC  L_3C9A
    $3CBA: E8          INX  
    $3CBB: E4 05       CPX  $05
    $3CBD: 90 C3       BCC  L_3C82

L_3CBF:
    $3CBF: 60          RTS  
    $3CC0: A8          TAY  
    $3CC1: B9 7C 5D    LDA  $5D7C,Y
    $3CC4: 8D 05 41    STA  $4105
    $3CC7: B9 1D 5E    LDA  $5E1D,Y
    $3CCA: 8D 06 41    STA  $4106
    $3CCD: A5 02       LDA  $02
    $3CCF: 85 03       STA  $03
    $3CD1: 18          CLC  
    $3CD2: 79 BE 5E    ADC  $5EBE,Y
    $3CD5: 85 02       STA  $02
    $3CD7: A5 04       LDA  $04
    $3CD9: AA          TAX  
    $3CDA: 18          CLC  
    $3CDB: 79 5F 5F    ADC  $5F5F,Y
    $3CDE: 85 05       STA  $05
    $3CE0: E0 C0       CPX  #$C0
    $3CE2: B0 3B       BCS  L_3D1F
    $3CE4: E4 08       CPX  $08
    $3CE6: 90 25       BCC  L_3D0D
    $3CE8: E4 09       CPX  $09
    $3CEA: B0 21       BCS  L_3D0D
    $3CEC: BD 6C 41    LDA  $416C,X
    $3CEF: 85 06       STA  $06
    $3CF1: BD 2C 42    LDA  $422C,X
    $3CF4: 85 07       STA  $07
    $3CF6: A4 03       LDY  $03
    $3CF8: C0 28       CPY  #$28
    $3CFA: B0 11       BCS  L_3D0D
    $3CFC: C4 0A       CPY  $0A
    $3CFE: 90 0D       BCC  L_3D0D
    $3D00: 61 0B       ADC  ($0B,X)
    $3D02: 9A          TXS  
    $3D03: AC AD 26    LDY  $26AD
    $3D06: 00          BRK  
    $3D07: 0C          .BYTE $0C
    $3D08: FF          .BYTE $FF
    $3D09: 57          .BYTE $57
    $3D0A: 06 77       ASL  $77
    $3D0C: 07          .BYTE $07

L_3D0D:
    $3D0D: 8B          .BYTE $8B
    $3D0E: 04          .BYTE $04
    $3D0F: 11 D2       ORA  ($D2),Y
    $3D11: E5 EF       SBC  $EF
    $3D13: 83          .BYTE $83
    $3D14: 41 A8       EOR  ($A8,X)
    $3D16: 6C BB EC    JMP  ($ECBB)
    $3D19: 83          .BYTE $83
    $3D1A: 65 AF       ADC  $AF
    $3D1C: 01 29       ORA  ($29,X)
    $3D1E: DC          .BYTE $DC

L_3D1F:
    $3D1F: 3E 24 4C    ROL  $4C24,X
    $3D22: A6 85       LDX  $85
    $3D24: AA          TAX  
    $3D25: 0B          .BYTE $0B
    $3D26: 29 59       AND  #$59
    $3D28: E0 BE       CPX  #$BE
    $3D2A: 1E 4D D2    ASL  $D24D,X

L_3D2D:
    $3D2D: 5F          .BYTE $5F
    $3D2E: EA          NOP  
    $3D2F: 80          .BYTE $80
    $3D30: 59 B3 8F    EOR  $8FB3,Y
    $3D33: AB          .BYTE $AB
    $3D34: 28          PLP  
    $3D35: 55 20       EOR  $20,X
    $3D37: 6D E7 E7    ADC  $E7E7
    $3D3A: 10 3E       BPL  L_3D7A
    $3D3C: 81 E5       STA  ($E5,X)
    $3D3E: A0 B5       LDY  #$B5
    $3D40: 91 2E       STA  ($2E),Y
    $3D42: C4 82       CPY  $82
    $3D44: A2 BE       LDX  #$BE
    $3D46: EC 6A 35    CPX  $356A
    $3D49: 02          .BYTE $02
    $3D4A: 09 0A       ORA  #$0A
    $3D4C: A9 91       LDA  #$91
    $3D4E: 97          .BYTE $97
    $3D4F: E8          INX  
    $3D50: 83          .BYTE $83
    $3D51: C0 DB       CPY  #$DB
    $3D53: 93          .BYTE $93
    $3D54: 17          .BYTE $17
    $3D55: A4 E0       LDY  $E0
    $3D57: C1 54       CMP  ($54,X)
    $3D59: E4 F0       CPX  $F0
    $3D5B: 43          .BYTE $43
    $3D5C: E1 61       SBC  ($61,X)
    $3D5E: 0F          .BYTE $0F
    $3D5F: 39 D4 E5    AND  $E5D4,Y
    $3D62: A0 10       LDY  #$10
    $3D64: 54          .BYTE $54
    $3D65: D8          CLD  
    $3D66: 86 0E       STX  $0E
    $3D68: C4 3C       CPY  $3C
    $3D6A: 14          .BYTE $14
    $3D6B: 3E 8D A8    ROL  $A88D,X
    $3D6E: 04          .BYTE $04
    $3D6F: A5 02       LDA  $02
    $3D71: 85 03       STA  $03
    $3D73: 18          CLC  
    $3D74: F9 3E DE    SBC  $DE3E,Y
    $3D77: 05 82       ORA  $82
    $3D79: 25 84       AND  $84
    $3D7B: 2A          ROL  
    $3D7C: 18          CLC  
    $3D7D: 79 5F 5F    ADC  $5F5F,Y
    $3D80: 85 05       STA  $05
    $3D82: E0 C0       CPX  #$C0
    $3D84: 30 B9       BMI  L_3D3F
    $3D86: 64          .BYTE $64
    $3D87: 88          DEY  
    $3D88: 10 A3       BPL  L_3D2D
    $3D8A: 64          .BYTE $64
    $3D8B: 89          .BYTE $89
    $3D8C: B0 1F       BCS  L_3DAD
    $3D8E: BD 6C 41    LDA  $416C,X
    $3D91: 85 06       STA  $06
    $3D93: BD AC C2    LDA  $C2AC,X
    $3D96: 05 87       ORA  $87
    $3D98: 24 83       BIT  $83
    $3D9A: 40          RTI  
    $3D9B: A8          TAY  
    $3D9C: B0 0F       BCS  L_3DAD
    $3D9E: C4 0A       CPY  $0A
    $3DA0: 90 0B       BCC  L_3DAD
    $3DA2: C4 0B       CPY  $0B
    $3DA4: 30 87       BMI  L_3D2D
    $3DA6: 2D 80 80    AND  $8080
    $3DA9: 91 86       STA  ($86),Y
    $3DAB: 11 2E       ORA  ($2E),Y

L_3DAD:
    $3DAD: C6 8F       DEC  $8F
    $3DAF: 2C F8 2B    BIT  $2BF8
    $3DB2: C6 80       DEC  $80
    $3DB4: AC 60 6C    LDY  $6C60
    $3DB7: AA          TAX  
    $3DB8: 38          SEC  
    $3DB9: 48          PHA  
    $3DBA: 40          RTI  
    $3DBB: 4C 2D B8    JMP  $B82D
    $3DBE: EB          .BYTE $EB
    $3DBF: 48          PHA  
    $3DC0: 80          .BYTE $80
    $3DC1: 91 54       STA  ($54),Y
    $3DC3: 75 25       ADC  $25,X
    $3DC5: AD E9 11    LDA  $11E9
    $3DC8: B5 F6       LDA  $F6,X
    $3DCA: 25 AE       AND  $AE
    $3DCC: 69 8D       ADC  #$8D
    $3DCE: 2A          ROL  
    $3DCF: AD 2B 30    LDA  $302B
    $3DD2: 51 96       EOR  ($96),Y
    $3DD4: F6 2D       INC  $2D,X
    $3DD6: AA          TAX  
    $3DD7: 0D AC 02    ORA  $02AC
    $3DDA: B0 D1       BCS  L_3DAD
    $3DDC: 77          .BYTE $77
    $3DDD: 77          .BYTE $77
    $3DDE: AD 2D C8    LDA  $C82D
    $3DE1: E8          INX  
    $3DE2: 98          TYA  
    $3DE3: 13          .BYTE $13
    $3DE4: 4C A0 38    JMP  $38A0
    $3DE7: 8D 4C A1    STA  $A14C
    $3DEA: 18          CLC  
    $3DEB: 89          .BYTE $89
    $3DEC: ED 3C 11    SBC  $113C
    $3DEF: D5 56       CMP  $56,X
    $3DF1: ED 7C 12    SBC  $127C
    $3DF4: 55 D7       EOR  $D7,X
    $3DF6: 74          .BYTE $74
    $3DF7: D3          .BYTE $D3
    $3DF8: 10 F8       BPL  L_3DF2
    $3DFA: 60          RTS  
    $3DFB: C1 94       CMP  ($94,X)
    $3DFD: 5A          .BYTE $5A
    $3DFE: C0 5D       CPY  #$5D
    $3E00: A9 D2       LDA  #$D2
    $3E02: 2C A9 D0    BIT  $D0A9
    $3E05: 2C A9 CD    BIT  $CDA9
    $3E08: 2C A9 C3    BIT  $C3A9
    $3E0B: 85 02       STA  $02
    $3E0D: A2 00       LDX  #$00

L_3E0F:
    $3E0F: BD 00 06    LDA  $0600,X
    $3E12: 9D 00 02    STA  $0200,X
    $3E15: E8          INX  
    $3E16: D0 F7       BNE  L_3E0F
    $3E18: 4C 1B 02    JMP  $021B
    $3E1B: AD 51 C0    LDA  $C051  ; TXTSET
    $3E1E: AD 54 C0    LDA  $C054  ; LOWSCR
    $3E21: A0 00       LDY  #$00
    $3E23: A9 04       LDA  #$04
    $3E25: 84 00       STY  $00
    $3E27: 85 01       STA  $01
    $3E29: A9 02       LDA  #$02
    $3E2B: A0 1B       LDY  #$1B
    $3E2D: 20 D0 02    JSR  $02D0
    $3E30: A2 BC       LDX  #$BC
    $3E32: A0 00       LDY  #$00
    $3E34: A9 A0       LDA  #$A0

L_3E36:
    $3E36: 91 00       STA  ($00),Y
    $3E38: C8          INY  
    $3E39: D0 FB       BNE  L_3E36
    $3E3B: E6 01       INC  $01
    $3E3D: CA          DEX  
    $3E3E: D0 F6       BNE  L_3E36
    $3E40: A5 02       LDA  $02
    $3E42: 8D 00 04    STA  $0400
    $3E45: 8D 27 04    STA  $0427
    $3E48: 8D D0 07    STA  $07D0
    $3E4B: 8D F7 07    STA  $07F7
    $3E4E: A0 00       LDY  #$00
    $3E50: 84 00       STY  $00

L_3E52:
    $3E52: B9 C0 02    LDA  $02C0,Y
    $3E55: F0 17       BEQ  L_3E6E
    $3E57: 85 01       STA  $01
    $3E59: B9 C1 02    LDA  $02C1,Y
    $3E5C: 85 03       STA  $03
    $3E5E: C8          INY  
    $3E5F: C8          INY  

L_3E60:
    $3E60: AE 30 C0    LDX  $C030  ; SPKR
    $3E63: A6 03       LDX  $03

L_3E65:
    $3E65: CA          DEX  
    $3E66: D0 FD       BNE  L_3E65
    $3E68: C6 01       DEC  $01
    $3E6A: D0 F4       BNE  L_3E60
    $3E6C: F0 E4       BEQ  L_3E52

L_3E6E:
    $3E6E: 4C 00 C6    JMP  $C600
    $3E71: 4A          LSR  
    $3E72: 4A          LSR  
    $3E73: 4A          LSR  
    $3E74: 09 C0       ORA  #$C0
    $3E76: A0 00       LDY  #$00
    $3E78: 20 D0 02    JSR  $02D0
    $3E7B: A2 00       LDX  #$00
    $3E7D: 8A          TXA  

L_3E7E:
    $3E7E: 95 00       STA  $00,X
    $3E80: 9D 00 01    STA  $0100,X
    $3E83: E8          INX  
    $3E84: D0 F8       BNE  L_3E7E
    $3E86: A2 09       LDX  #$09

L_3E88:
    $3E88: BD F0 02    LDA  $02F0,X
    $3E8B: 9D 0F 04    STA  $040F,X
    $3E8E: CA          DEX  
    $3E8F: 10 F7       BPL  L_3E88

L_3E91:
    $3E91: 99 00 02    STA  $0200,Y
    $3E94: 99 A0 02    STA  $02A0,Y
    $3E97: C8          INY  
    $3E98: C0 92       CPY  #$92
    $3E9A: D0 F5       BNE  L_3E91
    $3E9C: 6C F2 03    JMP  ($03F2)
    $3E9F: 00          BRK  
    $3EA0: 84 01       STY  $01
    $3EA2: A4 01       LDY  $01
    $3EA4: E6 01       INC  $01
    $3EA6: B9 00 07    LDA  $0700,Y
    $3EA9: F0 11       BEQ  L_3EBC
    $3EAB: 20 58 07    JSR  $0758
    $3EAE: A4 01       LDY  $01
    $3EB0: E6 01       INC  $01
    $3EB2: B9 00 07    LDA  $0700,Y
    $3EB5: 20 00 07    JSR  $0700

L_3EB8:
    $3EB8: 4C A2 06    JMP  $06A2
    $3EBB: 00          BRK  

L_3EBC:
    $3EBC: BD 88 C0    LDA  $C088,X
    $3EBF: 60          RTS  
    $3EC0: 20 E0 20    JSR  $20E0
    $3EC3: D0 20       BNE  L_3EE5
    $3EC5: C0 20       CPY  #$20
    $3EC7: B0 20       BCS  L_3EE9
    $3EC9: C0 20       CPY  #$20
    $3ECB: D0 20       BNE  L_3EED
    $3ECD: E0 00       CPX  #$00
    $3ECF: 00          BRK  
    $3ED0: 48          PHA  
    $3ED1: AD 83 C0    LDA  $C083
    $3ED4: AD 83 C0    LDA  $C083
    $3ED7: 68          PLA  

L_3ED8:
    $3ED8: 48          PHA  
    $3ED9: 8D FD FF    STA  $FFFD

L_3EDC:
    $3EDC: 8D F3 03    STA  $03F3
    $3EDF: 49 A5       EOR  #$A5
    $3EE1: 8D F4 03    STA  $03F4
    $3EE4: 68          PLA  

L_3EE5:
    $3EE5: 8C FC FF    STY  $FFFC

L_3EE8:
    $3EE8: 8C F2 03    STY  $03F2
    $3EEB: 60          RTS  

L_3EEC:
    $3EEC: 00          BRK  

L_3EED:
    $3EED: 00          BRK  
    $3EEE: 00          BRK  
    $3EEF: 00          BRK  
    $3EF0: C2          .BYTE $C2
    $3EF1: D2          .BYTE $D2
    $3EF2: B0 C4       BCS  L_3EB8
    $3EF4: C5 D2       CMP  $D2

L_3EF6:
    $3EF6: C2          .BYTE $C2
    $3EF7: D5 CE       CMP  $CE,X
    $3EF9: C4 00       CPY  $00
    $3EFB: 00          BRK  

L_3EFC:
    $3EFC: 00          BRK  
    $3EFD: 00          BRK  
    $3EFE: 00          BRK  
    $3EFF: 00          BRK  
    $3F00: 50 50       BVC  L_3F52
    $3F02: 50 50       BVC  L_3F54
    $3F04: D0 D0       BNE  L_3ED6
    $3F06: D0 D0       BNE  L_3ED8
    $3F08: D0 D0       BNE  L_3EDA
    $3F0A: D0 D0       BNE  L_3EDC
    $3F0C: 50 50       BVC  L_3F5E
    $3F0E: 50 50       BVC  L_3F60
    $3F10: 50 50       BVC  L_3F62
    $3F12: 50 50       BVC  L_3F64
    $3F14: D0 D0       BNE  L_3EE6
    $3F16: D0 D0       BNE  L_3EE8
    $3F18: D0 D0       BNE  L_3EEA
    $3F1A: D0 D0       BNE  L_3EEC
    $3F1C: 50 50       BVC  L_3F6E
    $3F1E: 50 50       BVC  L_3F70
    $3F20: 50 50       BVC  L_3F72
    $3F22: 50 50       BVC  L_3F74
    $3F24: D0 D0       BNE  L_3EF6
    $3F26: D0 D0       BNE  L_3EF8
    $3F28: D0 D0       BNE  L_3EFA
    $3F2A: D0 D0       BNE  L_3EFC
    $3F2C: 20 24 28    JSR  $2824
    $3F2F: 2C 30 34    BIT  $3430
    $3F32: 38          SEC  
    $3F33: 3C          .BYTE $3C
    $3F34: 20 24 28    JSR  $2824
    $3F37: 2C 30 34    BIT  $3430
    $3F3A: 38          SEC  
    $3F3B: 3C          .BYTE $3C
    $3F3C: 21 25       AND  ($25,X)
    $3F3E: 29 2D       AND  #$2D
    $3F40: 31 35       AND  ($35),Y
    $3F42: 39 3D 21    AND  $213D,Y
    $3F45: 25 29       AND  $29
    $3F47: 2D 31 35    AND  $3531
    $3F4A: 39 3D 22    AND  $223D,Y
    $3F4D: 26 2A       ROL  $2A
    $3F4F: 2E 32 36    ROL  $3632

L_3F52:
    $3F52: 3A          .BYTE $3A
    $3F53: 3E 22 26    ROL  $2622,X
    $3F56: 2A          ROL  
    $3F57: 2E 32 36    ROL  $3632
    $3F5A: 3A          .BYTE $3A
    $3F5B: 3E 23 27    ROL  $2723,X

L_3F5E:
    $3F5E: 2B          .BYTE $2B
    $3F5F: 2F          .BYTE $2F

L_3F60:
    $3F60: 33          .BYTE $33
    $3F61: 37          .BYTE $37

L_3F62:
    $3F62: 3B          .BYTE $3B
    $3F63: 3F          .BYTE $3F

L_3F64:
    $3F64: 23          .BYTE $23
    $3F65: 27          .BYTE $27
    $3F66: 2B          .BYTE $2B
    $3F67: 2F          .BYTE $2F
    $3F68: 33          .BYTE $33
    $3F69: 37          .BYTE $37
    $3F6A: 3B          .BYTE $3B
    $3F6B: 3F          .BYTE $3F
    $3F6C: 20 24 28    JSR  $2824
    $3F6F: 2C 30 34    BIT  $3430

L_3F72:
    $3F72: 38          SEC  
    $3F73: 3C          .BYTE $3C

L_3F74:
    $3F74: 20 24 28    JSR  $2824
    $3F77: 2C 30 34    BIT  $3430
    $3F7A: 38          SEC  
    $3F7B: 3C          .BYTE $3C
    $3F7C: 21 25       AND  ($25,X)
    $3F7E: 29 2D       AND  #$2D
    $3F80: 31 35       AND  ($35),Y
    $3F82: 39 3D 21    AND  $213D,Y
    $3F85: 25 29       AND  $29
    $3F87: 2D 31 35    AND  $3531
    $3F8A: 39 3D 22    AND  $223D,Y
    $3F8D: 26 2A       ROL  $2A
    $3F8F: 2E 32 36    ROL  $3632
    $3F92: 3A          .BYTE $3A
    $3F93: 3E 22 26    ROL  $2622,X
    $3F96: 2A          ROL  
    $3F97: 2E 32 36    ROL  $3632
    $3F9A: 3A          .BYTE $3A
    $3F9B: 3E 23 27    ROL  $2723,X
    $3F9E: 2B          .BYTE $2B
    $3F9F: 2F          .BYTE $2F
    $3FA0: 33          .BYTE $33
    $3FA1: 37          .BYTE $37
    $3FA2: 3B          .BYTE $3B
    $3FA3: 3F          .BYTE $3F
    $3FA4: 23          .BYTE $23
    $3FA5: 27          .BYTE $27
    $3FA6: 2B          .BYTE $2B
    $3FA7: 2F          .BYTE $2F
    $3FA8: 33          .BYTE $33
    $3FA9: 37          .BYTE $37
    $3FAA: 3B          .BYTE $3B
    $3FAB: 3F          .BYTE $3F
    $3FAC: 20 24 28    JSR  $2824
    $3FAF: 2C 30 34    BIT  $3430
    $3FB2: 38          SEC  
    $3FB3: 3C          .BYTE $3C
    $3FB4: 20 24 28    JSR  $2824
    $3FB7: 2C 30 34    BIT  $3430
    $3FBA: 38          SEC  
    $3FBB: 3C          .BYTE $3C
    $3FBC: 21 25       AND  ($25,X)
    $3FBE: 29 2D       AND  #$2D
    $3FC0: 31 35       AND  ($35),Y
    $3FC2: 39 3D 21    AND  $213D,Y
    $3FC5: 25 29       AND  $29
    $3FC7: 2D 31 35    AND  $3531
    $3FCA: 39 3D 22    AND  $223D,Y
    $3FCD: 26 2A       ROL  $2A
    $3FCF: 2E 32 36    ROL  $3632
    $3FD2: 3A          .BYTE $3A
    $3FD3: 3E 22 26    ROL  $2622,X
    $3FD6: 2A          ROL  
    $3FD7: 2E 32 36    ROL  $3632
    $3FDA: 3A          .BYTE $3A
    $3FDB: 3E 23 27    ROL  $2723,X
    $3FDE: 2B          .BYTE $2B
    $3FDF: 2F          .BYTE $2F
    $3FE0: 33          .BYTE $33
    $3FE1: 37          .BYTE $37
    $3FE2: 3B          .BYTE $3B
    $3FE3: 3F          .BYTE $3F
    $3FE4: 23          .BYTE $23
    $3FE5: 27          .BYTE $27
    $3FE6: 2B          .BYTE $2B
    $3FE7: 2F          .BYTE $2F
    $3FE8: 33          .BYTE $33
    $3FE9: 37          .BYTE $37
    $3FEA: 3B          .BYTE $3B
    $3FEB: 3F          .BYTE $3F
    $3FEC: 48          PHA  
    $3FED: 4A          LSR  
    $3FEE: 4A          LSR  
    $3FEF: 4A          LSR  
    $3FF0: 4A          LSR  
    $3FF1: 29 0F       AND  #$0F
    $3FF3: 20 16 04    JSR  $0416
    $3FF6: 68          PLA  
    $3FF7: 29 0F       AND  #$0F
    $3FF9: 4C 16 04    JMP  $0416
    $3FFC: A9 01       LDA  #$01
    $3FFE: 85 02       STA  $02
    $4000: 49 24       EOR  #$24
    $4002: 12          .BYTE $12
    $4003: 49 24       EOR  #$24

SUB_4005:
    $4005: 12          .BYTE $12
    $4006: 49 24       EOR  #$24
    $4008: 12          .BYTE $12
    $4009: 49 24       EOR  #$24
    $400B: 12          .BYTE $12
    $400C: 49 24       EOR  #$24
    $400E: 12          .BYTE $12
    $400F: 49 24       EOR  #$24
    $4011: 12          .BYTE $12
    $4012: 49 24       EOR  #$24
    $4014: 12          .BYTE $12
    $4015: 49 24       EOR  #$24
    $4017: 12          .BYTE $12
    $4018: 49 24       EOR  #$24
    $401A: 12          .BYTE $12
    $401B: 49 24       EOR  #$24
    $401D: 12          .BYTE $12
    $401E: 49 24       EOR  #$24
    $4020: 12          .BYTE $12
    $4021: 49 24       EOR  #$24
    $4023: 12          .BYTE $12
    $4024: 49 24       EOR  #$24
    $4026: 12          .BYTE $12
    $4027: 49 11       EOR  #$11
    $4029: 22          .BYTE $22
    $402A: 44          .BYTE $44
    $402B: 08          PHP  
    $402C: 11 22       ORA  ($22),Y
    $402E: 44          .BYTE $44
    $402F: 08          PHP  
    $4030: 11 22       ORA  ($22),Y
    $4032: 44          .BYTE $44
    $4033: 08          PHP  
    $4034: 11 22       ORA  ($22),Y
    $4036: 44          .BYTE $44
    $4037: 08          PHP  
    $4038: 11 22       ORA  ($22),Y
    $403A: 44          .BYTE $44
    $403B: 08          PHP  
    $403C: 11 22       ORA  ($22),Y
    $403E: 44          .BYTE $44
    $403F: 08          PHP  
    $4040: 11 22       ORA  ($22),Y
    $4042: 44          .BYTE $44
    $4043: 08          PHP  
    $4044: 11 22       ORA  ($22),Y
    $4046: 44          .BYTE $44
    $4047: 08          PHP  
    $4048: 11 22       ORA  ($22),Y
    $404A: 44          .BYTE $44
    $404B: 08          PHP  
    $404C: 11 22       ORA  ($22),Y
    $404E: 44          .BYTE $44
    $404F: 08          PHP  
    $4050: 21 08       AND  ($08,X)
    $4052: 42          .BYTE $42
    $4053: 10 04       BPL  L_4059
    $4055: 21 08       AND  ($08,X)
    $4057: 42          .BYTE $42
    $4058: 10 04       BPL  L_405E
    $405A: 21 08       AND  ($08,X)
    $405C: 42          .BYTE $42
    $405D: 10 04       BPL  L_4063
    $405F: 21 08       AND  ($08,X)
    $4061: 42          .BYTE $42
    $4062: 10 04       BPL  L_4068
    $4064: 21 08       AND  ($08,X)
    $4066: 42          .BYTE $42
    $4067: 10 04       BPL  L_406D
    $4069: 21 08       AND  ($08,X)
    $406B: 42          .BYTE $42
    $406C: 10 04       BPL  L_4072
    $406E: 21 08       AND  ($08,X)
    $4070: 42          .BYTE $42
    $4071: 10 04       BPL  L_4077
    $4073: 21 08       AND  ($08,X)
    $4075: 42          .BYTE $42
    $4076: 10 04       BPL  L_407C
    $4078: 41 20       EOR  ($20,X)
    $407A: 10 08       BPL  L_4084

L_407C:
    $407C: 04          .BYTE $04
    $407D: 02          .BYTE $02
    $407E: 41 20       EOR  ($20,X)
    $4080: 10 08       BPL  L_408A
    $4082: 04          .BYTE $04
    $4083: 02          .BYTE $02

L_4084:
    $4084: 41 20       EOR  ($20,X)
    $4086: 10 08       BPL  L_4090
    $4088: 04          .BYTE $04
    $4089: 02          .BYTE $02

L_408A:
    $408A: 41 20       EOR  ($20,X)
    $408C: 10 08       BPL  L_4096
    $408E: 04          .BYTE $04
    $408F: 02          .BYTE $02

L_4090:
    $4090: 41 20       EOR  ($20,X)
    $4092: 10 08       BPL  L_409C
    $4094: 04          .BYTE $04
    $4095: 02          .BYTE $02

L_4096:
    $4096: 41 20       EOR  ($20,X)
    $4098: 10 08       BPL  L_40A2
    $409A: 04          .BYTE $04
    $409B: 02          .BYTE $02

L_409C:
    $409C: 41 20       EOR  ($20,X)
    $409E: 10 08       BPL  L_40A8
    $40A0: 7F          .BYTE $7F
    $40A1: 7F          .BYTE $7F

L_40A2:
    $40A2: 7F          .BYTE $7F
    $40A3: 7F          .BYTE $7F
    $40A4: 7F          .BYTE $7F
    $40A5: 7F          .BYTE $7F
    $40A6: 7F          .BYTE $7F
    $40A7: 7F          .BYTE $7F

L_40A8:
    $40A8: 7F          .BYTE $7F
    $40A9: 7F          .BYTE $7F
    $40AA: 7F          .BYTE $7F
    $40AB: 7F          .BYTE $7F
    $40AC: 7F          .BYTE $7F
    $40AD: 7F          .BYTE $7F
    $40AE: 7F          .BYTE $7F
    $40AF: 7F          .BYTE $7F
    $40B0: 7F          .BYTE $7F
    $40B1: 7F          .BYTE $7F
    $40B2: 7F          .BYTE $7F
    $40B3: 7F          .BYTE $7F
    $40B4: 7F          .BYTE $7F
    $40B5: 7F          .BYTE $7F
    $40B6: 7F          .BYTE $7F
    $40B7: 7F          .BYTE $7F
    $40B8: 7F          .BYTE $7F
    $40B9: 7F          .BYTE $7F
    $40BA: 7F          .BYTE $7F
    $40BB: 7F          .BYTE $7F
    $40BC: 7F          .BYTE $7F
    $40BD: 7F          .BYTE $7F
    $40BE: 7F          .BYTE $7F
    $40BF: 7F          .BYTE $7F

L_40C0:
    $40C0: A8          TAY  
    $40C1: B9 7C 5D    LDA  $5D7C,Y
    $40C4: 8D 05 41    STA  $4105
    $40C7: B9 1D 5E    LDA  $5E1D,Y
    $40CA: 8D 06 41    STA  $4106
    $40CD: A5 02       LDA  $02
    $40CF: 85 03       STA  $03
    $40D1: 18          CLC  
    $40D2: 79 BE 5E    ADC  $5EBE,Y
    $40D5: 85 02       STA  $02
    $40D7: A5 04       LDA  $04
    $40D9: AA          TAX  
    $40DA: 18          CLC  
    $40DB: 79 5F 5F    ADC  $5F5F,Y
    $40DE: 85 05       STA  $05

L_40E0:
    $40E0: E0 C0       CPX  #$C0
    $40E2: B0 3B       BCS  L_411F
    $40E4: E4 08       CPX  $08
    $40E6: 90 25       BCC  L_410D
    $40E8: E4 09       CPX  $09
    $40EA: B0 21       BCS  L_410D
    $40EC: BD 6C 41    LDA  $416C,X
    $40EF: 85 06       STA  $06
    $40F1: BD 2C 42    LDA  $422C,X
    $40F4: 85 07       STA  $07
    $40F6: A4 03       LDY  $03

L_40F8:
    $40F8: C0 28       CPY  #$28
    $40FA: B0 11       BCS  L_410D
    $40FC: C4 0A       CPY  $0A
    $40FE: 90 0D       BCC  L_410D
    $4100: C4 0B       CPY  $0B
    $4102: B0 09       BCS  L_410D
    $4104: AD 00 00    LDA  $0000
    $4107: 49 FF       EOR  #$FF
    $4109: 31 06       AND  ($06),Y
    $410B: 91 06       STA  ($06),Y

L_410D:
    $410D: EE 05 41    INC  $4105
    $4110: D0 03       BNE  L_4115
    $4112: EE 06 41    INC  $4106

L_4115:
    $4115: C8          INY  
    $4116: C4 02       CPY  $02
    $4118: 90 DE       BCC  L_40F8
    $411A: E8          INX  
    $411B: E4 05       CPX  $05
    $411D: 90 C1       BCC  L_40E0

L_411F:
    $411F: 60          RTS

; ============================================================================
; SUB_4120: Initialize Hi-Res Graphics Mode
; Clears hi-res page 1 ($2000-$3FFF) and sets graphics soft switches
; Note: Only Page 1 used - NO page flipping in this game
; ============================================================================
SUB_4120:
    $4120: A9 00       LDA  #$00   ; Clear value
    $4122: A2 20       LDX  #$20   ; 32 pages ($2000-$3FFF)
    $4124: A8          TAY
    $4125: 8E 2A 41    STX  $412A  ; Self-modifying: page high byte

L_4128:
    $4128: 99 00 40    STA  $4000,Y ; Clear screen (addr modified)
    $412B: C8          INY
    $412C: D0 FA       BNE  L_4128
    $412E: EE 2A 41    INC  $412A  ; Next page
    $4131: CA          DEX
    $4132: D0 F4       BNE  L_4128
    $4134: AD 50 C0    LDA  $C050  ; TXTCLR - enable graphics
    $4137: AD 57 C0    LDA  $C057  ; HIRES - hi-res mode
    $413A: AD 52 C0    LDA  $C052  ; MIXCLR - full screen (no text window)
    $413D: 60          RTS  

SUB_413E:
    $413E: A6 08       LDX  $08

L_4140:
    $4140: BD 6C 41    LDA  $416C,X
    $4143: 85 06       STA  $06
    $4145: BD 2C 42    LDA  $422C,X
    $4148: 85 07       STA  $07
    $414A: A4 0A       LDY  $0A
    $414C: A9 00       LDA  #$00

L_414E:
    $414E: 91 06       STA  ($06),Y
    $4150: C8          INY  
    $4151: C4 0B       CPY  $0B
    $4153: 90 F9       BCC  L_414E
    $4155: E8          INX  
    $4156: E4 09       CPX  $09
    $4158: 90 E6       BCC  L_4140
    $415A: 60          RTS  

SUB_415B:
    $415B: A9 09       LDA  #$09
    $415D: 85 0A       STA  $0A
    $415F: A9 01       LDA  #$01
    $4161: 85 08       STA  $08
    $4163: A9 28       LDA  #$28
    $4165: 85 0B       STA  $0B
    $4167: A9 C0       LDA  #$C0
    $4169: 85 09       STA  $09
    $416B: 60          RTS  
    $416C: 00          BRK  
    $416D: 00          BRK  
    $416E: 00          BRK  
    $416F: 00          BRK  
    $4170: 00          BRK  
    $4171: 00          BRK  
    $4172: 00          BRK  
    $4173: 00          BRK  
    $4174: 80          .BYTE $80
    $4175: 80          .BYTE $80
    $4176: 80          .BYTE $80
    $4177: 80          .BYTE $80
    $4178: 80          .BYTE $80
    $4179: 80          .BYTE $80
    $417A: 80          .BYTE $80
    $417B: 80          .BYTE $80
    $417C: 00          BRK  
    $417D: 00          BRK  
    $417E: 00          BRK  
    $417F: 00          BRK  
    $4180: 00          BRK  
    $4181: 00          BRK  
    $4182: 00          BRK  
    $4183: 00          BRK  
    $4184: 80          .BYTE $80
    $4185: 80          .BYTE $80
    $4186: 80          .BYTE $80
    $4187: 80          .BYTE $80
    $4188: 80          .BYTE $80
    $4189: 80          .BYTE $80
    $418A: 80          .BYTE $80
    $418B: 80          .BYTE $80
    $418C: 00          BRK  
    $418D: 00          BRK  
    $418E: 00          BRK  
    $418F: 00          BRK  
    $4190: 00          BRK  
    $4191: 00          BRK  
    $4192: 00          BRK  
    $4193: 00          BRK  
    $4194: 80          .BYTE $80
    $4195: 80          .BYTE $80
    $4196: 80          .BYTE $80
    $4197: 80          .BYTE $80
    $4198: 80          .BYTE $80
    $4199: 80          .BYTE $80
    $419A: 80          .BYTE $80
    $419B: 80          .BYTE $80
    $419C: 00          BRK  
    $419D: 00          BRK  
    $419E: 00          BRK  
    $419F: 00          BRK  
    $41A0: 00          BRK  
    $41A1: 00          BRK  
    $41A2: 00          BRK  
    $41A3: 00          BRK  
    $41A4: 80          .BYTE $80
    $41A5: 80          .BYTE $80
    $41A6: 80          .BYTE $80
    $41A7: 80          .BYTE $80
    $41A8: 80          .BYTE $80
    $41A9: 80          .BYTE $80
    $41AA: 80          .BYTE $80
    $41AB: 80          .BYTE $80
    $41AC: 28          PLP  
    $41AD: 28          PLP  
    $41AE: 28          PLP  
    $41AF: 28          PLP  
    $41B0: 28          PLP  
    $41B1: 28          PLP  
    $41B2: 28          PLP  
    $41B3: 28          PLP  
    $41B4: A8          TAY  
    $41B5: A8          TAY  
    $41B6: A8          TAY  
    $41B7: A8          TAY  
    $41B8: A8          TAY  
    $41B9: A8          TAY  
    $41BA: A8          TAY  
    $41BB: A8          TAY  
    $41BC: 28          PLP  
    $41BD: 28          PLP  
    $41BE: 28          PLP  
    $41BF: 28          PLP  
    $41C0: 28          PLP  
    $41C1: 28          PLP  
    $41C2: 28          PLP  
    $41C3: 28          PLP  
    $41C4: A8          TAY  
    $41C5: A8          TAY  

L_41C6:
    $41C6: A8          TAY  
    $41C7: A8          TAY  

L_41C8:
    $41C8: A8          TAY  
    $41C9: A8          TAY  

L_41CA:
    $41CA: A8          TAY  
    $41CB: A8          TAY  

L_41CC:
    $41CC: 28          PLP  
    $41CD: 28          PLP  
    $41CE: 28          PLP  
    $41CF: 28          PLP  
    $41D0: 28          PLP  
    $41D1: 28          PLP  
    $41D2: 28          PLP  
    $41D3: 28          PLP  
    $41D4: A8          TAY  
    $41D5: A8          TAY  

L_41D6:
    $41D6: A8          TAY  
    $41D7: A8          TAY  

L_41D8:
    $41D8: A8          TAY  
    $41D9: A8          TAY  

L_41DA:
    $41DA: A8          TAY  
    $41DB: A8          TAY  

L_41DC:
    $41DC: 28          PLP  
    $41DD: 28          PLP  
    $41DE: 28          PLP  
    $41DF: 28          PLP  
    $41E0: 28          PLP  
    $41E1: 28          PLP  
    $41E2: 28          PLP  
    $41E3: 28          PLP  
    $41E4: A8          TAY  
    $41E5: A8          TAY  

L_41E6:
    $41E6: A8          TAY  
    $41E7: A8          TAY  

L_41E8:
    $41E8: A8          TAY  
    $41E9: A8          TAY  

L_41EA:
    $41EA: A8          TAY  
    $41EB: A8          TAY  

L_41EC:
    $41EC: 50 50       BVC  L_423E
    $41EE: 50 50       BVC  L_4240
    $41F0: 50 50       BVC  L_4242
    $41F2: 50 50       BVC  L_4244
    $41F4: D0 D0       BNE  L_41C6

L_41F6:
    $41F6: D0 D0       BNE  L_41C8

L_41F8:
    $41F8: D0 D0       BNE  L_41CA

L_41FA:
    $41FA: D0 D0       BNE  L_41CC

L_41FC:
    $41FC: 50 50       BVC  L_424E
    $41FE: 50 50       BVC  L_4250
    $4200: 50 50       BVC  L_4252
    $4202: 50 50       BVC  L_4254
    $4204: D0 D0       BNE  L_41D6
    $4206: D0 D0       BNE  L_41D8
    $4208: D0 D0       BNE  L_41DA
    $420A: D0 D0       BNE  L_41DC
    $420C: 50 50       BVC  L_425E
    $420E: 50 50       BVC  L_4260
    $4210: 50 50       BVC  L_4262
    $4212: 50 50       BVC  L_4264
    $4214: D0 D0       BNE  L_41E6
    $4216: D0 D0       BNE  L_41E8
    $4218: D0 D0       BNE  L_41EA
    $421A: D0 D0       BNE  L_41EC
    $421C: 50 50       BVC  L_426E
    $421E: 50 50       BVC  L_4270
    $4220: 50 50       BVC  L_4272
    $4222: 50 50       BVC  L_4274
    $4224: D0 D0       BNE  L_41F6
    $4226: D0 D0       BNE  L_41F8
    $4228: D0 D0       BNE  L_41FA
    $422A: D0 D0       BNE  L_41FC
    $422C: 20 24 28    JSR  $2824
    $422F: 2C 30 34    BIT  $3430
    $4232: 38          SEC  
    $4233: 3C          .BYTE $3C
    $4234: 20 24 28    JSR  $2824
    $4237: 2C 30 34    BIT  $3430
    $423A: 38          SEC  
    $423B: 3C          .BYTE $3C
    $423C: 21 25       AND  ($25,X)

L_423E:
    $423E: 29 2D       AND  #$2D

L_4240:
    $4240: 31 35       AND  ($35),Y

L_4242:
    $4242: 39 3D 21    AND  $213D,Y
    $4245: 25 29       AND  $29
    $4247: 2D 31 35    AND  $3531
    $424A: 39 3D 22    AND  $223D,Y
    $424D: 26 2A       ROL  $2A
    $424F: 2E 32 36    ROL  $3632

L_4252:
    $4252: 3A          .BYTE $3A
    $4253: 3E 22 26    ROL  $2622,X
    $4256: 2A          ROL  
    $4257: 2E 32 36    ROL  $3632
    $425A: 3A          .BYTE $3A
    $425B: 3E 23 27    ROL  $2723,X

L_425E:
    $425E: 2B          .BYTE $2B
    $425F: 2F          .BYTE $2F

L_4260:
    $4260: 33          .BYTE $33
    $4261: 37          .BYTE $37

L_4262:
    $4262: 3B          .BYTE $3B
    $4263: 3F          .BYTE $3F

L_4264:
    $4264: 23          .BYTE $23
    $4265: 27          .BYTE $27
    $4266: 2B          .BYTE $2B
    $4267: 2F          .BYTE $2F
    $4268: 33          .BYTE $33
    $4269: 37          .BYTE $37
    $426A: 3B          .BYTE $3B
    $426B: 3F          .BYTE $3F
    $426C: 20 24 28    JSR  $2824
    $426F: 2C 30 34    BIT  $3430

L_4272:
    $4272: 38          SEC  
    $4273: 3C          .BYTE $3C

L_4274:
    $4274: 20 24 28    JSR  $2824
    $4277: 2C 30 34    BIT  $3430
    $427A: 38          SEC  
    $427B: 3C          .BYTE $3C
    $427C: 21 25       AND  ($25,X)
    $427E: 29 2D       AND  #$2D
    $4280: 31 35       AND  ($35),Y
    $4282: 39 3D 21    AND  $213D,Y
    $4285: 25 29       AND  $29
    $4287: 2D 31 35    AND  $3531
    $428A: 39 3D 22    AND  $223D,Y
    $428D: 26 2A       ROL  $2A
    $428F: 2E 32 36    ROL  $3632
    $4292: 3A          .BYTE $3A
    $4293: 3E 22 26    ROL  $2622,X
    $4296: 2A          ROL  
    $4297: 2E 32 36    ROL  $3632
    $429A: 3A          .BYTE $3A
    $429B: 3E 23 27    ROL  $2723,X
    $429E: 2B          .BYTE $2B
    $429F: 2F          .BYTE $2F
    $42A0: 33          .BYTE $33
    $42A1: 37          .BYTE $37
    $42A2: 3B          .BYTE $3B
    $42A3: 3F          .BYTE $3F
    $42A4: 23          .BYTE $23
    $42A5: 27          .BYTE $27
    $42A6: 2B          .BYTE $2B
    $42A7: 2F          .BYTE $2F
    $42A8: 33          .BYTE $33
    $42A9: 37          .BYTE $37
    $42AA: 3B          .BYTE $3B
    $42AB: 3F          .BYTE $3F
    $42AC: 20 24 28    JSR  $2824
    $42AF: 2C 30 34    BIT  $3430
    $42B2: 38          SEC  
    $42B3: 3C          .BYTE $3C
    $42B4: 20 24 28    JSR  $2824
    $42B7: 2C 30 34    BIT  $3430
    $42BA: 38          SEC  
    $42BB: 3C          .BYTE $3C
    $42BC: 21 25       AND  ($25,X)
    $42BE: 29 2D       AND  #$2D
    $42C0: 31 35       AND  ($35),Y
    $42C2: 39 3D 21    AND  $213D,Y
    $42C5: 25 29       AND  $29
    $42C7: 2D 31 35    AND  $3531
    $42CA: 39 3D 22    AND  $223D,Y
    $42CD: 26 2A       ROL  $2A
    $42CF: 2E 32 36    ROL  $3632
    $42D2: 3A          .BYTE $3A
    $42D3: 3E 22 26    ROL  $2622,X
    $42D6: 2A          ROL  
    $42D7: 2E 32 36    ROL  $3632
    $42DA: 3A          .BYTE $3A
    $42DB: 3E 23 27    ROL  $2723,X
    $42DE: 2B          .BYTE $2B
    $42DF: 2F          .BYTE $2F
    $42E0: 33          .BYTE $33
    $42E1: 37          .BYTE $37
    $42E2: 3B          .BYTE $3B
    $42E3: 3F          .BYTE $3F
    $42E4: 23          .BYTE $23
    $42E5: 27          .BYTE $27
    $42E6: 2B          .BYTE $2B
    $42E7: 2F          .BYTE $2F
    $42E8: 33          .BYTE $33
    $42E9: 37          .BYTE $37
    $42EA: 3B          .BYTE $3B
    $42EB: 3F          .BYTE $3F

SUB_42EC:
    $42EC: 48          PHA  
    $42ED: 4A          LSR  
    $42EE: 4A          LSR  
    $42EF: 4A          LSR  
    $42F0: 4A          LSR  
    $42F1: 29 0F       AND  #$0F
    $42F3: 20 16 04    JSR  $0416
    $42F6: 68          PLA  
    $42F7: 29 0F       AND  #$0F
    $42F9: 4C 16 04    JMP  $0416

SUB_42FC:
    $42FC: A9 01       LDA  #$01
    $42FE: 85 02       STA  $02
    $4300: A9 08       LDA  #$08
    $4302: 85 04       STA  $04
    $4304: A9 0F       LDA  #$0F
    $4306: 20 16 04    JSR  $0416
    $4309: A9 01       LDA  #$01
    $430B: 85 02       STA  $02
    $430D: A9 10       LDA  #$10
    $430F: 85 04       STA  $04
    $4311: A9 10       LDA  #$10
    $4313: 20 16 04    JSR  $0416
    $4316: A9 01       LDA  #$01
    $4318: 85 02       STA  $02
    $431A: A9 A7       LDA  #$A7
    $431C: 85 04       STA  $04
    $431E: A9 15       LDA  #$15
    $4320: 20 16 04    JSR  $0416
    $4323: A9 01       LDA  #$01
    $4325: 85 02       STA  $02
    $4327: A9 AF       LDA  #$AF
    $4329: 85 04       STA  $04
    $432B: A9 12       LDA  #$12
    $432D: 20 16 04    JSR  $0416
    $4330: A9 01       LDA  #$01
    $4332: 85 02       STA  $02
    $4334: A9 B7       LDA  #$B7
    $4336: 85 04       STA  $04
    $4338: A9 13       LDA  #$13
    $433A: 20 16 04    JSR  $0416
    $433D: A9 01       LDA  #$01
    $433F: 85 02       STA  $02
    $4341: A9 4C       LDA  #$4C
    $4343: 85 04       STA  $04
    $4345: A9 0A       LDA  #$0A
    $4347: 20 16 04    JSR  $0416
    $434A: A9 02       LDA  #$02
    $434C: 85 02       STA  $02
    $434E: A9 64       LDA  #$64
    $4350: 85 04       STA  $04
    $4352: A9 14       LDA  #$14
    $4354: 20 16 04    JSR  $0416
    $4357: A9 01       LDA  #$01
    $4359: 85 02       STA  $02
    $435B: A9 6C       LDA  #$6C
    $435D: 85 04       STA  $04
    $435F: A9 0A       LDA  #$0A
    $4361: 20 16 04    JSR  $0416
    $4364: A9 01       LDA  #$01
    $4366: 85 02       STA  $02
    $4368: A9 84       LDA  #$84
    $436A: 85 04       STA  $04
    $436C: A9 19       LDA  #$19
    $436E: 20 16 04    JSR  $0416
    $4371: 20 87 43    JSR  $4387
    $4374: 20 9E 43    JSR  $439E
    $4377: 4C CD 43    JMP  $43CD

SUB_437A:
    $437A: A9 56       LDA  #$56
    $437C: 85 04       STA  $04
    $437E: A9 17       LDA  #$17
    $4380: 85 02       STA  $02
    $4382: A9 18       LDA  #$18
    $4384: 4C 16 04    JMP  $0416

L_4387:
    $4387: A9 01       LDA  #$01
    $4389: 85 02       STA  $02
    $438B: A9 54       LDA  #$54
    $438D: 85 04       STA  $04
    $438F: A5 0D       LDA  $0D
    $4391: 20 EC 42    JSR  $42EC
    $4394: A5 0C       LDA  $0C
    $4396: 20 EC 42    JSR  $42EC
    $4399: A9 00       LDA  #$00
    $439B: 4C 16 04    JMP  $0416

SUB_439E:
    $439E: A9 01       LDA  #$01
    $43A0: 85 02       STA  $02
    $43A2: A9 74       LDA  #$74
    $43A4: 85 04       STA  $04
    $43A6: A5 0F       LDA  $0F
    $43A8: 20 EC 42    JSR  $42EC
    $43AB: A5 0E       LDA  $0E
    $43AD: 20 EC 42    JSR  $42EC
    $43B0: A9 00       LDA  #$00
    $43B2: 4C 16 04    JMP  $0416

SUB_43B5:
    $43B5: A0 08       LDY  #$08
    $43B7: A2 00       LDX  #$00

L_43B9:
    $43B9: BD 6C 41    LDA  $416C,X
    $43BC: 85 06       STA  $06
    $43BE: BD 2C 42    LDA  $422C,X
    $43C1: 85 07       STA  $07
    $43C3: A9 94       LDA  #$94
    $43C5: 91 06       STA  ($06),Y
    $43C7: E8          INX  
    $43C8: E0 C0       CPX  #$C0
    $43CA: 90 ED       BCC  L_43B9
    $43CC: 60          RTS  

L_43CD:
    $43CD: A9 03       LDA  #$03
    $43CF: 85 02       STA  $02
    $43D1: A9 8C       LDA  #$8C
    $43D3: 85 04       STA  $04
    $43D5: A5 10       LDA  $10
    $43D7: C9 0A       CMP  #$0A
    $43D9: 90 02       BCC  L_43DD
    $43DB: A9 09       LDA  #$09

L_43DD:
    $43DD: 4C 16 04    JMP  $0416

; ============================================================================
; SUB_43E0: KEYBOARD HANDLER
; Direction keys set $11 (current aim direction)
; Fire keys set $36 flag or trigger 4-direction fire
; Keys: Y=UP, J=RIGHT, SPACE=DOWN, G=LEFT, ESC=fire, A/F=4-dir fire
; ============================================================================
SUB_43E0:
    $43E0: AD 00 C0    LDA  $C000  ; KEYBOARD - read key
    $43E3: 10 12       BPL  L_43F7 ; No key pressed, return
    $43E5: 8D 10 C0    STA  $C010  ; KBDSTRB - clear keyboard strobe
    $43E8: C9 9B       CMP  #$9B   ; ESC key? ($9B)
    $43EA: D0 03       BNE  L_43EF
    $43EC: 85 36       STA  $36    ; Set fire flag
    $43EE: 60          RTS

L_43EF:
    $43EF: C9 D9       CMP  #$D9   ; Y key? ($D9)
    $43F1: D0 05       BNE  L_43F8
    $43F3: A9 00       LDA  #$00   ; Direction 0 = UP
    $43F5: 85 11       STA  $11

L_43F7:
    $43F7: 60          RTS

L_43F8:
    $43F8: C9 CA       CMP  #$CA   ; J key? ($CA)
    $43FA: D0 05       BNE  L_4401
    $43FC: A9 01       LDA  #$01   ; Direction 1 = RIGHT
    $43FE: 85 11       STA  $11
    $4400: 60          RTS

L_4401:
    $4401: C9 A0       CMP  #$A0   ; SPACE key? ($A0)
    $4403: D0 05       BNE  L_440A
    $4405: A9 02       LDA  #$02   ; Direction 2 = DOWN
    $4407: 85 11       STA  $11
    $4409: 60          RTS

L_440A:
    $440A: C9 C7       CMP  #$C7   ; G key? ($C7)
    $440C: D0 05       BNE  L_4413
    $440E: A9 03       LDA  #$03   ; Direction 3 = LEFT
    $4410: 85 11       STA  $11
    $4412: 60          RTS

L_4413:
    $4413: C9 C1       CMP  #$C1   ; A key? ($C1) - 4-direction fire
    $4415: F0 05       BEQ  L_441C
    $4417: C9 C6       CMP  #$C6   ; F key? ($C6) - 4-direction fire
    $4419: F0 01       BEQ  L_441C
    $441B: 60          RTS

L_441C:
    $441C: 4C 81 53    JMP  L_5381 ; 4-direction simultaneous fire (limited uses at $536F)
    $441F: BD 3C 5D    LDA  $5D3C,X
    $4422: 85 02       STA  $02
    $4424: BD 44 5D    LDA  $5D44,X
    $4427: 85 04       STA  $04
    $4429: 8A          TXA  
    $442A: 18          CLC  
    $442B: 69 1A       ADC  #$1A
    $442D: 4C 62 04    JMP  $0462
    $4430: BD 3C 5D    LDA  $5D3C,X
    $4433: 85 02       STA  $02
    $4435: BD 44 5D    LDA  $5D44,X
    $4438: 85 04       STA  $04
    $443A: 8A          TXA  
    $443B: 18          CLC  
    $443C: 69 1A       ADC  #$1A
    $443E: 4C C0 40    JMP  $40C0

SUB_4441:
    $4441: E0 03       CPX  #$03
    $4443: F0 31       BEQ  L_4476
    $4445: E0 02       CPX  #$02
    $4447: F0 22       BEQ  L_446B
    $4449: E0 01       CPX  #$01
    $444B: F0 45       BEQ  L_4492
    $444D: A2 00       LDX  #$00
    $444F: A0 18       LDY  #$18
    $4451: A9 51       LDA  #$51
    $4453: 85 05       STA  $05

L_4455:
    $4455: BD 6C 41    LDA  $416C,X
    $4458: 85 06       STA  $06
    $445A: BD 2C 42    LDA  $422C,X
    $445D: 85 07       STA  $07
    $445F: A9 73       LDA  #$73
    $4461: 31 06       AND  ($06),Y
    $4463: 91 06       STA  ($06),Y
    $4465: E8          INX  
    $4466: E4 05       CPX  $05
    $4468: D0 EB       BNE  L_4455
    $446A: 60          RTS  

L_446B:
    $446B: A2 6E       LDX  #$6E
    $446D: A0 18       LDY  #$18
    $446F: A5 09       LDA  $09
    $4471: 85 05       STA  $05
    $4473: 4C 55 44    JMP  $4455

L_4476:
    $4476: A0 09       LDY  #$09
    $4478: A9 17       LDA  #$17

L_447A:
    $447A: 85 05       STA  $05
    $447C: A2 60       LDX  #$60
    $447E: BD 6C 41    LDA  $416C,X
    $4481: 85 06       STA  $06
    $4483: BD 2C 42    LDA  $422C,X
    $4486: 85 07       STA  $07
    $4488: A9 00       LDA  #$00

L_448A:
    $448A: 91 06       STA  ($06),Y
    $448C: C8          INY  
    $448D: C4 05       CPY  $05
    $448F: D0 F9       BNE  L_448A
    $4491: 60          RTS  

L_4492:
    $4492: A0 1A       LDY  #$1A
    $4494: A5 0B       LDA  $0B
    $4496: 4C 7A 44    JMP  $447A

SUB_4499:
    $4499: 20 EF 44    JSR  $44EF
    $449C: A6 19       LDX  $19
    $449E: A5 1A       LDA  $1A
    $44A0: D0 0F       BNE  L_44B1
    $44A2: BD AA 47    LDA  $47AA,X
    $44A5: 85 02       STA  $02
    $44A7: BD 92 46    LDA  $4692,X
    $44AA: AA          TAX  
    $44AB: BD D3 48    LDA  $48D3,X
    $44AE: 4C BD 44    JMP  $44BD

L_44B1:
    $44B1: BD AD 48    LDA  $48AD,X
    $44B4: 85 02       STA  $02
    $44B6: BD 8B 47    LDA  $478B,X
    $44B9: AA          TAX  
    $44BA: BD D3 48    LDA  $48D3,X

L_44BD:
    $44BD: 18          CLC  
    $44BE: 6D 09 45    ADC  $4509
    $44C1: 4C 62 04    JMP  $0462

SUB_44C4:
    $44C4: 20 EF 44    JSR  $44EF
    $44C7: A6 19       LDX  $19
    $44C9: A5 1A       LDA  $1A
    $44CB: D0 0F       BNE  L_44DC
    $44CD: BD AA 47    LDA  $47AA,X
    $44D0: 85 02       STA  $02
    $44D2: BD 92 46    LDA  $4692,X
    $44D5: AA          TAX  
    $44D6: BD D3 48    LDA  $48D3,X
    $44D9: 4C E8 44    JMP  $44E8

L_44DC:
    $44DC: BD AD 48    LDA  $48AD,X
    $44DF: 85 02       STA  $02
    $44E1: BD 8B 47    LDA  $478B,X
    $44E4: AA          TAX  
    $44E5: BD D3 48    LDA  $48D3,X

L_44E8:
    $44E8: 18          CLC  
    $44E9: 6D 09 45    ADC  $4509
    $44EC: 4C C0 40    JMP  $40C0

SUB_44EF:
    $44EF: BD 48 5D    LDA  $5D48,X
    $44F2: 85 19       STA  $19
    $44F4: BD 4C 5D    LDA  $5D4C,X
    $44F7: 85 1A       STA  $1A
    $44F9: BD 50 5D    LDA  $5D50,X
    $44FC: 85 04       STA  $04
    $44FE: BD 54 5D    LDA  $5D54,X
    $4501: AA          TAX  
    $4502: BD 0A 45    LDA  $450A,X
    $4505: 8D 09 45    STA  $4509
    $4508: 60          RTS  
    $4509: 00          BRK  
    $450A: 1E 1E 82    ASL  $821E,X
    $450D: 89          .BYTE $89

SUB_450E:
    $450E: A2 03       LDX  #$03
    $4510: 86 12       STX  $12

L_4512:
    $4512: A6 12       LDX  $12
    $4514: BD 54 5D    LDA  $5D54,X
    $4517: F0 61       BEQ  L_457A
    $4519: 20 C4 44    JSR  $44C4
    $451C: A6 12       LDX  $12
    $451E: E0 03       CPX  #$03
    $4520: F0 28       BEQ  L_454A
    $4522: E0 02       CPX  #$02
    $4524: F0 14       BEQ  L_453A
    $4526: E0 01       CPX  #$01
    $4528: F0 30       BEQ  L_455A
    $452A: BD 50 5D    LDA  $5D50,X
    $452D: 18          CLC  
    $452E: 69 01       ADC  #$01
    $4530: C9 60       CMP  #$60
    $4532: B0 46       BCS  L_457A
    $4534: 9D 50 5D    STA  $5D50,X
    $4537: 4C 77 45    JMP  $4577

L_453A:
    $453A: BD 50 5D    LDA  $5D50,X
    $453D: 38          SEC  
    $453E: E9 01       SBC  #$01
    $4540: C9 60       CMP  #$60
    $4542: 90 36       BCC  L_457A
    $4544: 9D 50 5D    STA  $5D50,X
    $4547: 4C 77 45    JMP  $4577

L_454A:
    $454A: BD 48 5D    LDA  $5D48,X
    $454D: 18          CLC  
    $454E: 69 01       ADC  #$01
    $4550: C9 AB       CMP  #$AB
    $4552: B0 26       BCS  L_457A
    $4554: 9D 48 5D    STA  $5D48,X
    $4557: 4C 77 45    JMP  $4577

L_455A:
    $455A: BD 4C 5D    LDA  $5D4C,X
    $455D: D0 07       BNE  L_4566
    $455F: BD 48 5D    LDA  $5D48,X
    $4562: C9 AB       CMP  #$AB
    $4564: 90 14       BCC  L_457A

L_4566:
    $4566: BD 48 5D    LDA  $5D48,X
    $4569: 38          SEC  
    $456A: E9 01       SBC  #$01
    $456C: 9D 48 5D    STA  $5D48,X
    $456F: BD 4C 5D    LDA  $5D4C,X
    $4572: E9 00       SBC  #$00
    $4574: 9D 4C 5D    STA  $5D4C,X

L_4577:
    $4577: 20 99 44    JSR  $4499

L_457A:
    $457A: C6 12       DEC  $12
    $457C: 10 94       BPL  L_4512
    $457E: 60          RTS  

SUB_457F:
    $457F: A2 03       LDX  #$03
    $4581: 86 12       STX  $12

L_4583:
    $4583: A6 12       LDX  $12
    $4585: BD 58 5D    LDA  $5D58,X
    $4588: F0 6F       BEQ  L_45F9
    $458A: E0 03       CPX  #$03
    $458C: F0 41       BEQ  L_45CF
    $458E: E0 02       CPX  #$02
    $4590: F0 28       BEQ  L_45BA
    $4592: E0 01       CPX  #$01
    $4594: F0 68       BEQ  L_45FE
    $4596: BD 64 5D    LDA  $5D64,X
    $4599: F0 5E       BEQ  L_45F9
    $459B: 85 04       STA  $04
    $459D: 38          SEC  
    $459E: E9 03       SBC  #$03
    $45A0: B0 02       BCS  L_45A4
    $45A2: A9 00       LDA  #$00

L_45A4:
    $45A4: 85 1E       STA  $1E
    $45A6: 9D 64 5D    STA  $5D64,X
    $45A9: BD 5C 5D    LDA  $5D5C,X
    $45AC: 85 19       STA  $19
    $45AE: 85 1C       STA  $1C
    $45B0: BD 60 5D    LDA  $5D60,X
    $45B3: 85 1A       STA  $1A
    $45B5: 85 1D       STA  $1D
    $45B7: 4C F3 45    JMP  $45F3

L_45BA:
    $45BA: BD 64 5D    LDA  $5D64,X
    $45BD: C9 BF       CMP  #$BF
    $45BF: F0 38       BEQ  L_45F9
    $45C1: 85 04       STA  $04
    $45C3: 18          CLC  
    $45C4: 69 03       ADC  #$03
    $45C6: C9 BF       CMP  #$BF
    $45C8: 90 DA       BCC  L_45A4
    $45CA: A9 BF       LDA  #$BF
    $45CC: 4C A4 45    JMP  $45A4

L_45CF:
    $45CF: BD 5C 5D    LDA  $5D5C,X
    $45D2: C9 3E       CMP  #$3E
    $45D4: 90 23       BCC  L_45F9
    $45D6: 85 1C       STA  $1C
    $45D8: 38          SEC  
    $45D9: E9 03       SBC  #$03
    $45DB: C9 3E       CMP  #$3E
    $45DD: B0 02       BCS  L_45E1
    $45DF: A9 3E       LDA  #$3E

L_45E1:
    $45E1: 85 19       STA  $19
    $45E3: 9D 5C 5D    STA  $5D5C,X
    $45E6: A9 00       LDA  #$00
    $45E8: 85 1D       STA  $1D
    $45EA: 85 1A       STA  $1A

L_45EC:
    $45EC: BD 64 5D    LDA  $5D64,X
    $45EF: 85 1E       STA  $1E
    $45F1: 85 04       STA  $04

L_45F3:
    $45F3: 20 40 49    JSR  $4940
    $45F6: 8D 30 C0    STA  $C030  ; SPKR

L_45F9:
    $45F9: C6 12       DEC  $12
    $45FB: 10 86       BPL  L_4583
    $45FD: 60          RTS  

L_45FE:
    $45FE: BD 5C 5D    LDA  $5D5C,X
    $4601: C9 17       CMP  #$17
    $4603: BD 60 5D    LDA  $5D60,X
    $4606: E9 01       SBC  #$01
    $4608: B0 EF       BCS  L_45F9
    $460A: BD 60 5D    LDA  $5D60,X
    $460D: 85 1A       STA  $1A
    $460F: BD 5C 5D    LDA  $5D5C,X
    $4612: 85 19       STA  $19
    $4614: 18          CLC  
    $4615: 69 03       ADC  #$03
    $4617: 9D 5C 5D    STA  $5D5C,X
    $461A: 85 1C       STA  $1C
    $461C: BD 60 5D    LDA  $5D60,X
    $461F: 69 00       ADC  #$00
    $4621: 9D 60 5D    STA  $5D60,X
    $4624: 85 1D       STA  $1D
    $4626: A5 1C       LDA  $1C
    $4628: C9 17       CMP  #$17
    $462A: A5 1D       LDA  $1D
    $462C: E9 01       SBC  #$01
    $462E: 90 BC       BCC  L_45EC
    $4630: A9 17       LDA  #$17
    $4632: 9D 5C 5D    STA  $5D5C,X
    $4635: 85 1C       STA  $1C
    $4637: A9 01       LDA  #$01
    $4639: 85 1D       STA  $1D
    $463B: 9D 60 5D    STA  $5D60,X
    $463E: 4C EC 45    JMP  $45EC

SUB_4641:
    $4641: 8D 55 46    STA  $4655
    $4644: 8E 56 46    STX  $4656
    $4647: 8C 57 46    STY  $4657
    $464A: 60          RTS  

SUB_464B:
    $464B: AD 55 46    LDA  $4655
    $464E: AE 56 46    LDX  $4656
    $4651: AC 57 46    LDY  $4657
    $4654: 60          RTS  
    $4655: 00          BRK  
    $4656: 00          BRK  
    $4657: 00          BRK  

SUB_4658:
    $4658: 85 13       STA  $13
    $465A: 86 14       STX  $14
    $465C: 84 15       STY  $15
    $465E: A6 04       LDX  $04
    $4660: BD 6C 41    LDA  $416C,X
    $4663: 85 06       STA  $06
    $4665: BD 2C 42    LDA  $422C,X
    $4668: 85 07       STA  $07
    $466A: A6 19       LDX  $19
    $466C: A5 1A       LDA  $1A
    $466E: D0 11       BNE  L_4681
    $4670: BD 92 46    LDA  $4692,X
    $4673: 85 16       STA  $16
    $4675: BD AA 47    LDA  $47AA,X
    $4678: 85 17       STA  $17
    $467A: A5 13       LDA  $13
    $467C: A6 14       LDX  $14
    $467E: A4 15       LDY  $15
    $4680: 60          RTS  

L_4681:
    $4681: BD 8B 47    LDA  $478B,X
    $4684: 85 16       STA  $16
    $4686: BD AD 48    LDA  $48AD,X
    $4689: 85 17       STA  $17
    $468B: A5 13       LDA  $13
    $468D: A6 14       LDX  $14
    $468F: A4 15       LDY  $15
    $4691: 60          RTS  
    $4692: 01 02       ORA  ($02,X)
    $4694: 04          .BYTE $04
    $4695: 08          PHP  
    $4696: 10 20       BPL  L_46B8
    $4698: 40          RTI  
    $4699: 01 02       ORA  ($02,X)
    $469B: 04          .BYTE $04
    $469C: 08          PHP  
    $469D: 10 20       BPL  L_46BF
    $469F: 40          RTI  
    $46A0: 01 02       ORA  ($02,X)
    $46A2: 04          .BYTE $04
    $46A3: 08          PHP  
    $46A4: 10 20       BPL  L_46C6
    $46A6: 40          RTI  
    $46A7: 01 02       ORA  ($02,X)
    $46A9: 04          .BYTE $04
    $46AA: 08          PHP  
    $46AB: 10 20       BPL  L_46CD
    $46AD: 40          RTI  
    $46AE: 01 02       ORA  ($02,X)
    $46B0: 04          .BYTE $04
    $46B1: 08          PHP  
    $46B2: 10 20       BPL  L_46D4
    $46B4: 40          RTI  
    $46B5: 01 02       ORA  ($02,X)
    $46B7: 04          .BYTE $04

L_46B8:
    $46B8: 08          PHP  
    $46B9: 10 20       BPL  L_46DB
    $46BB: 40          RTI  
    $46BC: 01 02       ORA  ($02,X)
    $46BE: 04          .BYTE $04

L_46BF:
    $46BF: 08          PHP  
    $46C0: 10 20       BPL  L_46E2
    $46C2: 40          RTI  
    $46C3: 01 02       ORA  ($02,X)
    $46C5: 04          .BYTE $04

L_46C6:
    $46C6: 08          PHP  
    $46C7: 10 20       BPL  L_46E9
    $46C9: 40          RTI  
    $46CA: 01 02       ORA  ($02,X)
    $46CC: 04          .BYTE $04

L_46CD:
    $46CD: 08          PHP  
    $46CE: 10 20       BPL  L_46F0
    $46D0: 40          RTI  
    $46D1: 01 02       ORA  ($02,X)
    $46D3: 04          .BYTE $04

L_46D4:
    $46D4: 08          PHP  
    $46D5: 10 20       BPL  L_46F7
    $46D7: 40          RTI  
    $46D8: 01 02       ORA  ($02,X)
    $46DA: 04          .BYTE $04

L_46DB:
    $46DB: 08          PHP  
    $46DC: 10 20       BPL  L_46FE
    $46DE: 40          RTI  
    $46DF: 01 02       ORA  ($02,X)
    $46E1: 04          .BYTE $04

L_46E2:
    $46E2: 08          PHP  
    $46E3: 10 20       BPL  L_4705
    $46E5: 40          RTI  
    $46E6: 01 02       ORA  ($02,X)
    $46E8: 04          .BYTE $04

L_46E9:
    $46E9: 08          PHP  
    $46EA: 10 20       BPL  L_470C
    $46EC: 40          RTI  
    $46ED: 01 02       ORA  ($02,X)
    $46EF: 04          .BYTE $04

L_46F0:
    $46F0: 08          PHP  
    $46F1: 10 20       BPL  L_4713
    $46F3: 40          RTI  
    $46F4: 01 02       ORA  ($02,X)
    $46F6: 04          .BYTE $04

L_46F7:
    $46F7: 08          PHP  
    $46F8: 10 20       BPL  L_471A
    $46FA: 40          RTI  
    $46FB: 01 02       ORA  ($02,X)
    $46FD: 04          .BYTE $04

L_46FE:
    $46FE: 08          PHP  
    $46FF: 10 20       BPL  L_4721
    $4701: 40          RTI  
    $4702: 01 02       ORA  ($02,X)
    $4704: 04          .BYTE $04

L_4705:
    $4705: 08          PHP  
    $4706: 10 20       BPL  L_4728
    $4708: 40          RTI  
    $4709: 01 02       ORA  ($02,X)
    $470B: 04          .BYTE $04

L_470C:
    $470C: 08          PHP  
    $470D: 10 20       BPL  L_472F
    $470F: 40          RTI  
    $4710: 01 02       ORA  ($02,X)
    $4712: 04          .BYTE $04

L_4713:
    $4713: 08          PHP  
    $4714: 10 20       BPL  L_4736
    $4716: 40          RTI  
    $4717: 01 02       ORA  ($02,X)
    $4719: 04          .BYTE $04

L_471A:
    $471A: 08          PHP  
    $471B: 10 20       BPL  L_473D
    $471D: 40          RTI  
    $471E: 01 02       ORA  ($02,X)
    $4720: 04          .BYTE $04

L_4721:
    $4721: 08          PHP  
    $4722: 10 20       BPL  L_4744
    $4724: 40          RTI  
    $4725: 01 02       ORA  ($02,X)
    $4727: 04          .BYTE $04

L_4728:
    $4728: 08          PHP  
    $4729: 10 20       BPL  L_474B
    $472B: 40          RTI  
    $472C: 01 02       ORA  ($02,X)
    $472E: 04          .BYTE $04

L_472F:
    $472F: 08          PHP  
    $4730: 10 20       BPL  L_4752
    $4732: 40          RTI  
    $4733: 01 02       ORA  ($02,X)
    $4735: 04          .BYTE $04

L_4736:
    $4736: 08          PHP  
    $4737: 10 20       BPL  L_4759
    $4739: 40          RTI  
    $473A: 01 02       ORA  ($02,X)
    $473C: 04          .BYTE $04

L_473D:
    $473D: 08          PHP  
    $473E: 10 20       BPL  L_4760
    $4740: 40          RTI  
    $4741: 01 02       ORA  ($02,X)
    $4743: 04          .BYTE $04

L_4744:
    $4744: 08          PHP  
    $4745: 10 20       BPL  L_4767
    $4747: 40          RTI  
    $4748: 01 02       ORA  ($02,X)
    $474A: 04          .BYTE $04

L_474B:
    $474B: 08          PHP  
    $474C: 10 20       BPL  L_476E
    $474E: 40          RTI  
    $474F: 01 02       ORA  ($02,X)
    $4751: 04          .BYTE $04

L_4752:
    $4752: 08          PHP  
    $4753: 10 20       BPL  L_4775
    $4755: 40          RTI  
    $4756: 01 02       ORA  ($02,X)
    $4758: 04          .BYTE $04

L_4759:
    $4759: 08          PHP  
    $475A: 10 20       BPL  L_477C
    $475C: 40          RTI  
    $475D: 01 02       ORA  ($02,X)
    $475F: 04          .BYTE $04

L_4760:
    $4760: 08          PHP  
    $4761: 10 20       BPL  L_4783
    $4763: 40          RTI  
    $4764: 01 02       ORA  ($02,X)
    $4766: 04          .BYTE $04

L_4767:
    $4767: 08          PHP  
    $4768: 10 20       BPL  L_478A
    $476A: 40          RTI  
    $476B: 01 02       ORA  ($02,X)
    $476D: 04          .BYTE $04

L_476E:
    $476E: 08          PHP  
    $476F: 10 20       BPL  L_4791
    $4771: 40          RTI  
    $4772: 01 02       ORA  ($02,X)
    $4774: 04          .BYTE $04

L_4775:
    $4775: 08          PHP  
    $4776: 10 20       BPL  L_4798
    $4778: 40          RTI  
    $4779: 01 02       ORA  ($02,X)
    $477B: 04          .BYTE $04

L_477C:
    $477C: 08          PHP  
    $477D: 10 20       BPL  L_479F
    $477F: 40          RTI  
    $4780: 01 02       ORA  ($02,X)
    $4782: 04          .BYTE $04

L_4783:
    $4783: 08          PHP  
    $4784: 10 20       BPL  L_47A6
    $4786: 40          RTI  
    $4787: 01 02       ORA  ($02,X)
    $4789: 04          .BYTE $04

L_478A:
    $478A: 08          PHP  
    $478B: 10 20       BPL  L_47AD
    $478D: 40          RTI  
    $478E: 01 02       ORA  ($02,X)
    $4790: 04          .BYTE $04

L_4791:
    $4791: 08          PHP  
    $4792: 10 20       BPL  L_47B4
    $4794: 40          RTI  
    $4795: 01 02       ORA  ($02,X)
    $4797: 04          .BYTE $04

L_4798:
    $4798: 08          PHP  
    $4799: 10 20       BPL  L_47BB
    $479B: 40          RTI  
    $479C: 01 02       ORA  ($02,X)
    $479E: 04          .BYTE $04

L_479F:
    $479F: 08          PHP  
    $47A0: 10 20       BPL  L_47C2
    $47A2: 40          RTI  
    $47A3: 01 02       ORA  ($02,X)
    $47A5: 04          .BYTE $04

L_47A6:
    $47A6: 08          PHP  
    $47A7: 10 20       BPL  L_47C9
    $47A9: 40          RTI  
    $47AA: 00          BRK  
    $47AB: 00          BRK  
    $47AC: 00          BRK  

L_47AD:
    $47AD: 00          BRK  
    $47AE: 00          BRK  
    $47AF: 00          BRK  
    $47B0: 00          BRK  
    $47B1: 01 01       ORA  ($01,X)
    $47B3: 01 01       ORA  ($01,X)
    $47B5: 01 01       ORA  ($01,X)
    $47B7: 01 02       ORA  ($02,X)
    $47B9: 02          .BYTE $02
    $47BA: 02          .BYTE $02

L_47BB:
    $47BB: 02          .BYTE $02
    $47BC: 02          .BYTE $02
    $47BD: 02          .BYTE $02
    $47BE: 02          .BYTE $02
    $47BF: 03          .BYTE $03
    $47C0: 03          .BYTE $03
    $47C1: 03          .BYTE $03

L_47C2:
    $47C2: 03          .BYTE $03
    $47C3: 03          .BYTE $03
    $47C4: 03          .BYTE $03
    $47C5: 03          .BYTE $03
    $47C6: 04          .BYTE $04
    $47C7: 04          .BYTE $04
    $47C8: 04          .BYTE $04

L_47C9:
    $47C9: 04          .BYTE $04
    $47CA: 04          .BYTE $04
    $47CB: 04          .BYTE $04
    $47CC: 04          .BYTE $04
    $47CD: 05 05       ORA  $05
    $47CF: 05 05       ORA  $05
    $47D1: 05 05       ORA  $05
    $47D3: 05 06       ORA  $06
    $47D5: 06 06       ASL  $06
    $47D7: 06 06       ASL  $06
    $47D9: 06 06       ASL  $06
    $47DB: 07          .BYTE $07
    $47DC: 07          .BYTE $07
    $47DD: 07          .BYTE $07
    $47DE: 07          .BYTE $07
    $47DF: 07          .BYTE $07
    $47E0: 07          .BYTE $07
    $47E1: 07          .BYTE $07
    $47E2: 08          PHP  
    $47E3: 08          PHP  
    $47E4: 08          PHP  
    $47E5: 08          PHP  
    $47E6: 08          PHP  
    $47E7: 08          PHP  
    $47E8: 08          PHP  
    $47E9: 09 09       ORA  #$09
    $47EB: 09 09       ORA  #$09
    $47ED: 09 09       ORA  #$09
    $47EF: 09 0A       ORA  #$0A
    $47F1: 0A          ASL  
    $47F2: 0A          ASL  
    $47F3: 0A          ASL  
    $47F4: 0A          ASL  
    $47F5: 0A          ASL  
    $47F6: 0A          ASL  
    $47F7: 0B          .BYTE $0B
    $47F8: 0B          .BYTE $0B
    $47F9: 0B          .BYTE $0B
    $47FA: 0B          .BYTE $0B
    $47FB: 0B          .BYTE $0B
    $47FC: 0B          .BYTE $0B
    $47FD: 0B          .BYTE $0B
    $47FE: 0C          .BYTE $0C
    $47FF: 0C          .BYTE $0C
    $4800: 0C          .BYTE $0C
    $4801: 0C          .BYTE $0C
    $4802: 0C          .BYTE $0C
    $4803: 0C          .BYTE $0C
    $4804: 0C          .BYTE $0C
    $4805: 0D 0D 0D    ORA  $0D0D
    $4808: 0D 0D 0D    ORA  $0D0D
    $480B: 0D 0E 0E    ORA  $0E0E
    $480E: 0E 0E 0E    ASL  $0E0E
    $4811: 0E 0E 0F    ASL  $0F0E
    $4814: 0F          .BYTE $0F
    $4815: 0F          .BYTE $0F
    $4816: 0F          .BYTE $0F
    $4817: 0F          .BYTE $0F
    $4818: 0F          .BYTE $0F
    $4819: 0F          .BYTE $0F
    $481A: 10 10       BPL  L_482C
    $481C: 10 10       BPL  L_482E
    $481E: 10 10       BPL  L_4830
    $4820: 10 11       BPL  L_4833
    $4822: 11 11       ORA  ($11),Y
    $4824: 11 11       ORA  ($11),Y
    $4826: 11 11       ORA  ($11),Y
    $4828: 12          .BYTE $12
    $4829: 12          .BYTE $12
    $482A: 12          .BYTE $12
    $482B: 12          .BYTE $12

L_482C:
    $482C: 12          .BYTE $12
    $482D: 12          .BYTE $12

L_482E:
    $482E: 12          .BYTE $12
    $482F: 13          .BYTE $13

L_4830:
    $4830: 13          .BYTE $13
    $4831: 13          .BYTE $13
    $4832: 13          .BYTE $13

L_4833:
    $4833: 13          .BYTE $13
    $4834: 13          .BYTE $13
    $4835: 13          .BYTE $13
    $4836: 14          .BYTE $14
    $4837: 14          .BYTE $14
    $4838: 14          .BYTE $14
    $4839: 14          .BYTE $14
    $483A: 14          .BYTE $14
    $483B: 14          .BYTE $14
    $483C: 14          .BYTE $14
    $483D: 15 15       ORA  $15,X
    $483F: 15 15       ORA  $15,X
    $4841: 15 15       ORA  $15,X
    $4843: 15 16       ORA  $16,X
    $4845: 16 16       ASL  $16,X
    $4847: 16 16       ASL  $16,X
    $4849: 16 16       ASL  $16,X
    $484B: 17          .BYTE $17
    $484C: 17          .BYTE $17
    $484D: 17          .BYTE $17
    $484E: 17          .BYTE $17
    $484F: 17          .BYTE $17
    $4850: 17          .BYTE $17
    $4851: 17          .BYTE $17
    $4852: 18          CLC  
    $4853: 18          CLC  
    $4854: 18          CLC  
    $4855: 18          CLC  
    $4856: 18          CLC  
    $4857: 18          CLC  
    $4858: 18          CLC  
    $4859: 19 19 19    ORA  $1919,Y
    $485C: 19 19 19    ORA  $1919,Y
    $485F: 19 1A 1A    ORA  $1A1A,Y
    $4862: 1A          .BYTE $1A
    $4863: 1A          .BYTE $1A
    $4864: 1A          .BYTE $1A
    $4865: 1A          .BYTE $1A
    $4866: 1A          .BYTE $1A
    $4867: 1B          .BYTE $1B
    $4868: 1B          .BYTE $1B
    $4869: 1B          .BYTE $1B
    $486A: 1B          .BYTE $1B
    $486B: 1B          .BYTE $1B
    $486C: 1B          .BYTE $1B
    $486D: 1B          .BYTE $1B
    $486E: 1C          .BYTE $1C
    $486F: 1C          .BYTE $1C
    $4870: 1C          .BYTE $1C
    $4871: 1C          .BYTE $1C
    $4872: 1C          .BYTE $1C
    $4873: 1C          .BYTE $1C
    $4874: 1C          .BYTE $1C
    $4875: 1D 1D 1D    ORA  $1D1D,X
    $4878: 1D 1D 1D    ORA  $1D1D,X
    $487B: 1D 1E 1E    ORA  $1E1E,X
    $487E: 1E 1E 1E    ASL  $1E1E,X
    $4881: 1E 1E 1F    ASL  $1F1E,X
    $4884: 1F          .BYTE $1F
    $4885: 1F          .BYTE $1F
    $4886: 1F          .BYTE $1F
    $4887: 1F          .BYTE $1F
    $4888: 1F          .BYTE $1F
    $4889: 1F          .BYTE $1F
    $488A: 20 20 20    JSR  $2020
    $488D: 20 20 20    JSR  $2020
    $4890: 20 21 21    JSR  $2121
    $4893: 21 21       AND  ($21,X)
    $4895: 21 21       AND  ($21,X)
    $4897: 21 22       AND  ($22,X)
    $4899: 22          .BYTE $22
    $489A: 22          .BYTE $22
    $489B: 22          .BYTE $22
    $489C: 22          .BYTE $22
    $489D: 22          .BYTE $22
    $489E: 22          .BYTE $22
    $489F: 23          .BYTE $23
    $48A0: 23          .BYTE $23
    $48A1: 23          .BYTE $23
    $48A2: 23          .BYTE $23
    $48A3: 23          .BYTE $23
    $48A4: 23          .BYTE $23
    $48A5: 23          .BYTE $23
    $48A6: 24 24       BIT  $24
    $48A8: 24 24       BIT  $24
    $48AA: 24 24       BIT  $24
    $48AC: 24 24       BIT  $24
    $48AE: 24 24       BIT  $24
    $48B0: 25 25       AND  $25
    $48B2: 25 25       AND  $25
    $48B4: 25 25       AND  $25
    $48B6: 25 26       AND  $26
    $48B8: 26 26       ROL  $26
    $48BA: 26 26       ROL  $26
    $48BC: 26 26       ROL  $26
    $48BE: 27          .BYTE $27
    $48BF: 27          .BYTE $27
    $48C0: 27          .BYTE $27
    $48C1: 27          .BYTE $27
    $48C2: 27          .BYTE $27
    $48C3: 27          .BYTE $27
    $48C4: 27          .BYTE $27
    $48C5: 28          PLP  
    $48C6: 28          PLP  
    $48C7: 28          PLP  
    $48C8: 28          PLP  
    $48C9: 28          PLP  
    $48CA: 28          PLP  
    $48CB: 28          PLP  
    $48CC: 29 29       AND  #$29
    $48CE: 29 29       AND  #$29
    $48D0: 29 29       AND  #$29
    $48D2: 29 00       AND  #$00
    $48D4: 00          BRK  
    $48D5: 01 00       ORA  ($00,X)
    $48D7: 02          .BYTE $02
    $48D8: 00          BRK  
    $48D9: 00          BRK  
    $48DA: 00          BRK  
    $48DB: 03          .BYTE $03
    $48DC: 00          BRK  
    $48DD: 00          BRK  
    $48DE: 00          BRK  
    $48DF: 00          BRK  
    $48E0: 00          BRK  
    $48E1: 00          BRK  
    $48E2: 00          BRK  
    $48E3: 04          .BYTE $04
    $48E4: 00          BRK  
    $48E5: 00          BRK  
    $48E6: 00          BRK  
    $48E7: 00          BRK  
    $48E8: 00          BRK  
    $48E9: 00          BRK  
    $48EA: 00          BRK  
    $48EB: 00          BRK  
    $48EC: 00          BRK  
    $48ED: 00          BRK  
    $48EE: 00          BRK  
    $48EF: 00          BRK  
    $48F0: 00          BRK  
    $48F1: 00          BRK  
    $48F2: 00          BRK  
    $48F3: 05 00       ORA  $00
    $48F5: 00          BRK  
    $48F6: 00          BRK  
    $48F7: 00          BRK  
    $48F8: 00          BRK  
    $48F9: 00          BRK  
    $48FA: 00          BRK  
    $48FB: 00          BRK  
    $48FC: 00          BRK  
    $48FD: 00          BRK  
    $48FE: 00          BRK  
    $48FF: 00          BRK  
    $4900: 00          BRK  
    $4901: 00          BRK  
    $4902: 00          BRK  
    $4903: 00          BRK  
    $4904: 00          BRK  
    $4905: 00          BRK  
    $4906: 00          BRK  
    $4907: 00          BRK  
    $4908: 00          BRK  
    $4909: 00          BRK  
    $490A: 00          BRK  
    $490B: 00          BRK  
    $490C: 00          BRK  
    $490D: 00          BRK  
    $490E: 00          BRK  
    $490F: 00          BRK  
    $4910: 00          BRK  
    $4911: 00          BRK  
    $4912: 00          BRK  
    $4913: 06 48       ASL  $48
    $4915: 98          TYA  
    $4916: 48          PHA  
    $4917: A5 19       LDA  $19
    $4919: 29 01       AND  #$01
    $491B: F0 0B       BEQ  L_4928
    $491D: 20 58 46    JSR  $4658
    $4920: A4 17       LDY  $17
    $4922: A5 16       LDA  $16
    $4924: 11 06       ORA  ($06),Y
    $4926: 91 06       STA  ($06),Y

L_4928:
    $4928: 68          PLA  
    $4929: A8          TAY  
    $492A: 68          PLA  
    $492B: 60          RTS  
    $492C: 48          PHA  
    $492D: 98          TYA  
    $492E: 48          PHA  
    $492F: 20 58 46    JSR  $4658
    $4932: A4 17       LDY  $17
    $4934: A5 16       LDA  $16
    $4936: 49 FF       EOR  #$FF
    $4938: 31 06       AND  ($06),Y
    $493A: 91 06       STA  ($06),Y
    $493C: 68          PLA  
    $493D: A8          TAY  
    $493E: 68          PLA  
    $493F: 60          RTS  

SUB_4940:
    $4940: 20 41 46    JSR  $4641
    $4943: A9 00       LDA  #$00
    $4945: 85 1B       STA  $1B
    $4947: 4C 51 49    JMP  $4951
    $494A: 20 41 46    JSR  $4641
    $494D: A9 FF       LDA  #$FF
    $494F: 85 1B       STA  $1B

L_4951:
    $4951: 38          SEC  
    $4952: A5 1C       LDA  $1C
    $4954: E5 19       SBC  $19
    $4956: 85 23       STA  $23
    $4958: A5 1D       LDA  $1D
    $495A: E5 1A       SBC  $1A
    $495C: 85 24       STA  $24
    $495E: 38          SEC  
    $495F: A5 1E       LDA  $1E
    $4961: E5 04       SBC  $04
    $4963: 85 25       STA  $25
    $4965: A9 00       LDA  #$00
    $4967: E9 00       SBC  #$00
    $4969: 85 26       STA  $26
    $496B: A5 24       LDA  $24
    $496D: 10 16       BPL  L_4985
    $496F: A9 FF       LDA  #$FF
    $4971: 85 1F       STA  $1F
    $4973: 85 20       STA  $20
    $4975: 38          SEC  
    $4976: A9 00       LDA  #$00
    $4978: E5 23       SBC  $23
    $497A: 85 23       STA  $23
    $497C: A9 00       LDA  #$00
    $497E: E5 24       SBC  $24
    $4980: 85 24       STA  $24
    $4982: 4C 8D 49    JMP  $498D

L_4985:
    $4985: A9 01       LDA  #$01
    $4987: 85 1F       STA  $1F
    $4989: A9 00       LDA  #$00
    $498B: 85 20       STA  $20

L_498D:
    $498D: A5 26       LDA  $26
    $498F: 10 16       BPL  L_49A7
    $4991: A9 FF       LDA  #$FF
    $4993: 85 21       STA  $21
    $4995: 85 22       STA  $22
    $4997: 38          SEC  
    $4998: A9 00       LDA  #$00
    $499A: E5 25       SBC  $25
    $499C: 85 25       STA  $25
    $499E: A9 00       LDA  #$00
    $49A0: E5 26       SBC  $26
    $49A2: 85 26       STA  $26
    $49A4: 4C AF 49    JMP  $49AF

L_49A7:
    $49A7: A9 01       LDA  #$01
    $49A9: 85 21       STA  $21
    $49AB: A9 00       LDA  #$00
    $49AD: 85 22       STA  $22

L_49AF:
    $49AF: A5 23       LDA  $23
    $49B1: C5 25       CMP  $25
    $49B3: A5 24       LDA  $24
    $49B5: E5 26       SBC  $26
    $49B7: B0 06       BCS  L_49BF
    $49B9: 20 2F 4A    JSR  $4A2F
    $49BC: 4C C2 49    JMP  $49C2

L_49BF:
    $49BF: 20 C6 49    JSR  $49C6

L_49C2:
    $49C2: 20 4B 46    JSR  $464B
    $49C5: 60          RTS  

SUB_49C6:
    $49C6: A5 23       LDA  $23
    $49C8: D0 04       BNE  L_49CE
    $49CA: A5 24       LDA  $24
    $49CC: F0 60       BEQ  L_4A2E

L_49CE:
    $49CE: A5 24       LDA  $24
    $49D0: 85 2A       STA  $2A
    $49D2: 4A          LSR  
    $49D3: 85 28       STA  $28
    $49D5: A5 23       LDA  $23
    $49D7: 85 29       STA  $29
    $49D9: 6A          ROR  
    $49DA: 85 27       STA  $27

L_49DC:
    $49DC: 18          CLC  
    $49DD: A5 27       LDA  $27
    $49DF: 65 25       ADC  $25
    $49E1: 85 27       STA  $27
    $49E3: A5 28       LDA  $28
    $49E5: 65 26       ADC  $26
    $49E7: 85 28       STA  $28
    $49E9: A5 27       LDA  $27
    $49EB: C5 23       CMP  $23
    $49ED: A5 28       LDA  $28
    $49EF: E5 24       SBC  $24
    $49F1: 90 13       BCC  L_4A06
    $49F3: A5 27       LDA  $27
    $49F5: E5 23       SBC  $23
    $49F7: 85 27       STA  $27
    $49F9: A5 28       LDA  $28
    $49FB: E5 24       SBC  $24
    $49FD: 85 28       STA  $28
    $49FF: 18          CLC  
    $4A00: A5 04       LDA  $04
    $4A02: 65 21       ADC  $21
    $4A04: 85 04       STA  $04

L_4A06:
    $4A06: 18          CLC  
    $4A07: A5 19       LDA  $19
    $4A09: 65 1F       ADC  $1F
    $4A0B: 85 19       STA  $19
    $4A0D: A5 1A       LDA  $1A
    $4A0F: 65 20       ADC  $20
    $4A11: 85 1A       STA  $1A
    $4A13: 24 1B       BIT  $1B
    $4A15: 10 06       BPL  L_4A1D
    $4A17: 20 C0 40    JSR  $40C0
    $4A1A: 4C 20 4A    JMP  $4A20

L_4A1D:
    $4A1D: 20 14 49    JSR  $4914

L_4A20:
    $4A20: A5 29       LDA  $29
    $4A22: D0 02       BNE  L_4A26
    $4A24: C6 2A       DEC  $2A

L_4A26:
    $4A26: C6 29       DEC  $29
    $4A28: A5 29       LDA  $29
    $4A2A: 05 2A       ORA  $2A
    $4A2C: D0 AE       BNE  L_49DC

L_4A2E:
    $4A2E: 60          RTS  

SUB_4A2F:
    $4A2F: A5 26       LDA  $26
    $4A31: 85 2A       STA  $2A
    $4A33: 4A          LSR  
    $4A34: 85 28       STA  $28
    $4A36: A5 25       LDA  $25
    $4A38: 85 29       STA  $29
    $4A3A: 6A          ROR  
    $4A3B: 85 27       STA  $27

L_4A3D:
    $4A3D: 18          CLC  
    $4A3E: A5 27       LDA  $27
    $4A40: 65 23       ADC  $23
    $4A42: 85 27       STA  $27
    $4A44: A5 28       LDA  $28
    $4A46: 65 24       ADC  $24
    $4A48: 85 28       STA  $28
    $4A4A: A5 27       LDA  $27
    $4A4C: C5 25       CMP  $25
    $4A4E: A5 28       LDA  $28
    $4A50: E5 26       SBC  $26
    $4A52: 90 19       BCC  L_4A6D
    $4A54: A5 27       LDA  $27
    $4A56: E5 25       SBC  $25
    $4A58: 85 27       STA  $27
    $4A5A: A5 28       LDA  $28
    $4A5C: E5 26       SBC  $26
    $4A5E: 85 28       STA  $28
    $4A60: 18          CLC  
    $4A61: A5 19       LDA  $19
    $4A63: 65 1F       ADC  $1F
    $4A65: 85 19       STA  $19
    $4A67: A5 1A       LDA  $1A
    $4A69: 65 20       ADC  $20
    $4A6B: 85 1A       STA  $1A

L_4A6D:
    $4A6D: 18          CLC  
    $4A6E: A5 04       LDA  $04
    $4A70: 65 21       ADC  $21
    $4A72: 85 04       STA  $04
    $4A74: 20 14 49    JSR  $4914
    $4A77: A5 29       LDA  $29
    $4A79: D0 02       BNE  L_4A7D
    $4A7B: C6 2A       DEC  $2A

L_4A7D:
    $4A7D: C6 29       DEC  $29
    $4A7F: A5 29       LDA  $29
    $4A81: 05 2A       ORA  $2A
    $4A83: D0 B8       BNE  L_4A3D
    $4A85: 60          RTS  

SUB_4A86:
    $4A86: A5 0D       LDA  $0D
    $4A88: C5 0F       CMP  $0F
    $4A8A: 90 13       BCC  L_4A9F
    $4A8C: D0 06       BNE  L_4A94
    $4A8E: A5 0C       LDA  $0C
    $4A90: C5 0E       CMP  $0E
    $4A92: 90 0B       BCC  L_4A9F

L_4A94:
    $4A94: A5 0C       LDA  $0C
    $4A96: 85 0E       STA  $0E
    $4A98: A5 0D       LDA  $0D
    $4A9A: 85 0F       STA  $0F
    $4A9C: 20 9E 43    JSR  $439E

L_4A9F:
    $4A9F: A9 00       LDA  #$00
    $4AA1: 85 12       STA  $12
    $4AA3: 85 11       STA  $11

L_4AA5:
    $4AA5: E6 12       INC  $12
    $4AA7: A5 12       LDA  $12
    $4AA9: C9 50       CMP  #$50
    $4AAB: D0 0A       BNE  L_4AB7
    $4AAD: A9 00       LDA  #$00
    $4AAF: 85 12       STA  $12
    $4AB1: A5 11       LDA  $11
    $4AB3: 49 FF       EOR  #$FF
    $4AB5: 85 11       STA  $11

L_4AB7:
    $4AB7: A9 14       LDA  #$14
    $4AB9: 85 02       STA  $02
    $4ABB: A9 42       LDA  #$42
    $4ABD: 85 04       STA  $04
    $4ABF: A5 11       LDA  $11
    $4AC1: F0 08       BEQ  L_4ACB
    $4AC3: A9 25       LDA  #$25
    $4AC5: 20 C0 40    JSR  $40C0
    $4AC8: 4C D0 4A    JMP  $4AD0

L_4ACB:
    $4ACB: A9 25       LDA  #$25
    $4ACD: 20 62 04    JSR  $0462

L_4AD0:
    $4AD0: 20 28 5C    JSR  $5C28
    $4AD3: A9 40       LDA  #$40
    $4AD5: 20 6C 5C    JSR  $5C6C
    $4AD8: AD 00 C0    LDA  $C000  ; KEYBOARD
    $4ADB: C9 8D       CMP  #$8D
    $4ADD: D0 C6       BNE  L_4AA5
    $4ADF: 60          RTS

; ============================================================================
; SUB_4AE0: ADD SCORE (BCD arithmetic)
; Input: A = points to add
; Score stored in BCD at $0C (low) and $0D (high)
; Awards extra life at score thresholds ($35 tracks next bonus)
; ============================================================================
SUB_4AE0:
    $4AE0: F8          SED         ; Set decimal mode (BCD)
    $4AE1: 18          CLC
    $4AE2: 65 0C       ADC  $0C    ; Add to score low byte
    $4AE4: 85 0C       STA  $0C
    $4AE6: A5 0D       LDA  $0D    ; Handle carry to high byte
    $4AE8: 69 00       ADC  #$00
    $4AEA: 85 0D       STA  $0D
    $4AEC: D8          CLD         ; Clear decimal mode
    $4AED: C5 35       CMP  $35    ; Check for bonus life threshold
    $4AEF: D0 18       BNE  L_4B09 ; Not yet, skip bonus
    $4AF1: E6 10       INC  $10    ; Award extra life!
    $4AF3: 20 CD 43    JSR  $43CD  ; Update lives display
    $4AF6: F8          SED
    $4AF7: A9 10       LDA  #$10   ; Next bonus at +1000 points (BCD)
    $4AF9: 18          CLC
    $4AFA: 65 35       ADC  $35
    $4AFC: D8          CLD
    $4AFD: 85 35       STA  $35    ; Update next bonus threshold
    $4AFF: A0 00       LDY  #$00
    $4B01: A9 3C       LDA  #$3C
    $4B03: 8D 67 5B    STA  $5B67
    $4B06: 20 62 5B    JSR  $5B62

L_4B09:
    $4B09: 4C 87 43    JMP  $4387

SUB_4B0C:
    $4B0C: 8A          TXA  
    $4B0D: 8E 64 4B    STX  $4B64
    $4B10: 0A          ASL  
    $4B11: 0A          ASL  
    $4B12: 18          CLC  
    $4B13: 69 03       ADC  #$03
    $4B15: AA          TAX  
    $4B16: A0 03       LDY  #$03

L_4B18:
    $4B18: BD B8 53    LDA  $53B8,X
    $4B1B: C9 04       CMP  #$04
    $4B1D: D0 15       BNE  L_4B34
    $4B1F: CA          DEX  
    $4B20: 88          DEY  
    $4B21: 10 F5       BPL  L_4B18
    $4B23: 20 03 04    JSR  $0403
    $4B26: C9 10       CMP  #$10
    $4B28: B0 05       BCS  L_4B2F
    $4B2A: A9 03       LDA  #$03
    $4B2C: 4C 36 4B    JMP  $4B36

L_4B2F:
    $4B2F: A9 02       LDA  #$02
    $4B31: 4C 36 4B    JMP  $4B36

L_4B34:
    $4B34: A9 01       LDA  #$01

L_4B36:
    $4B36: AE 64 4B    LDX  $4B64
    $4B39: 9D 54 5D    STA  $5D54,X
    $4B3C: BD 58 4B    LDA  $4B58,X
    $4B3F: 9D 48 5D    STA  $5D48,X
    $4B42: BD 5C 4B    LDA  $4B5C,X
    $4B45: 9D 4C 5D    STA  $5D4C,X
    $4B48: BD 60 4B    LDA  $4B60,X
    $4B4B: 9D 50 5D    STA  $5D50,X
    $4B4E: A0 10       LDY  #$10
    $4B50: A9 45       LDA  #$45
    $4B52: 8D 67 5B    STA  $5B67
    $4B55: 4C 62 5B    JMP  $5B62
    $4B58: A9 00       LDA  #$00
    $4B5A: A9 50       LDA  #$50
    $4B5C: 00          BRK  
    $4B5D: 01 00       ORA  ($00,X)
    $4B5F: 00          BRK  
    $4B60: 10 5E       BPL  L_4BC0
    $4B62: AC 5E 00    LDY  $005E

; ============================================================================
; SUB_4B65: PUNISHMENT ROUTINE - Transform all aliens on one side to DIAMONDS!
; Called when: hitting a heart OR missing an upside-down heart
; Input: $57D6 = direction (0=UP, 1=LEFT, 2=DOWN, 3=RIGHT)
; Sets all 4 aliens on that side to type 5 (Diamond - the penalty state!)
; ============================================================================
SUB_4B65:
    $4B65: AD D6 57    LDA  $57D6  ; Get current direction
    $4B68: 20 3C 4C    JSR  $4C3C  ; Play punishment sound effect
    ; Calculate starting index: (direction * 4) + 3
    $4B6B: AD D6 57    LDA  $57D6  ; Get direction again
    $4B6E: 0A          ASL         ; × 2
    $4B6F: 0A          ASL         ; × 4
    $4B70: 18          CLC
    $4B71: 69 03       ADC  #$03   ; Add 3 (start at end of group)
    $4B73: AA          TAX         ; X = starting index into $53B8
    $4B74: A0 03       LDY  #$03   ; Loop counter (4 aliens)
    $4B76: A9 05       LDA  #$05   ; Type 5 = DIAMOND (penalty state!)

L_4B78:
    $4B78: 9D B8 53    STA  $53B8,X ; Set alien type to DIAMOND
    $4B7B: CA          DEX         ; Previous alien
    $4B7C: 88          DEY         ; Decrement counter
    $4B7D: 10 F9       BPL  L_4B78 ; Loop until all 4 done

    ; Jump to direction-specific redraw routine
    $4B7F: AE D6 57    LDX  $57D6  ; Get direction
    $4B82: D0 03       BNE  L_4B87
    $4B84: 4C C5 54    JMP  $54C5  ; Direction 0 (UP) - redraw top aliens

L_4B87:
    $4B87: E0 01       CPX  #$01
    $4B89: D0 03       BNE  L_4B8E
    $4B8B: 4C 61 54    JMP  $5461  ; Direction 1 (LEFT) - redraw left aliens

L_4B8E:
    $4B8E: E0 02       CPX  #$02
    $4B90: D0 03       BNE  L_4B95
    $4B92: 4C 29 55    JMP  $5529  ; Direction 2 (DOWN) - redraw bottom aliens

L_4B95:
    $4B95: 4C FD 53    JMP  $53FD  ; Direction 3 (RIGHT) - redraw right aliens

L_4B98:
    $4B98: A9 03       LDA  #$03
    $4B9A: 8D F8 53    STA  $53F8

L_4B9D:
    $4B9D: AE F8 53    LDX  $53F8
    $4BA0: BD C4 53    LDA  $53C4,X
    $4BA3: F0 16       BEQ  L_4BBB
    $4BA5: 48          PHA  
    $4BA6: AD F3 53    LDA  $53F3
    $4BA9: 18          CLC  
    $4BAA: 7D E8 53    ADC  $53E8,X
    $4BAD: 85 04       STA  $04
    $4BAF: A9 09       LDA  #$09
    $4BB1: 85 02       STA  $02
    $4BB3: 68          PLA  
    $4BB4: AA          TAX  
    $4BB5: BD D6 53    LDA  $53D6,X
    $4BB8: 20 C0 40    JSR  $40C0

L_4BBB:
    $4BBB: CE F8 53    DEC  $53F8
    $4BBE: 10 DD       BPL  L_4B9D

L_4BC0:
    $4BC0: 60          RTS  

L_4BC1:
    $4BC1: A9 03       LDA  #$03
    $4BC3: 8D F8 53    STA  $53F8

L_4BC6:
    $4BC6: AE F8 53    LDX  $53F8
    $4BC9: BD BC 53    LDA  $53BC,X
    $4BCC: F0 16       BEQ  L_4BE4
    $4BCE: 48          PHA  
    $4BCF: AD F1 53    LDA  $53F1
    $4BD2: 18          CLC  
    $4BD3: 7D E8 53    ADC  $53E8,X
    $4BD6: 85 04       STA  $04
    $4BD8: A9 25       LDA  #$25
    $4BDA: 85 02       STA  $02
    $4BDC: 68          PLA  
    $4BDD: AA          TAX  
    $4BDE: BD DD 53    LDA  $53DD,X
    $4BE1: 20 C0 40    JSR  $40C0

L_4BE4:
    $4BE4: CE F8 53    DEC  $53F8
    $4BE7: 10 DD       BPL  L_4BC6
    $4BE9: 60          RTS  

L_4BEA:
    $4BEA: A9 03       LDA  #$03
    $4BEC: 8D F8 53    STA  $53F8

L_4BEF:
    $4BEF: AE F8 53    LDX  $53F8
    $4BF2: BD B8 53    LDA  $53B8,X
    $4BF5: F0 16       BEQ  L_4C0D
    $4BF7: 48          PHA  
    $4BF8: AD EC 53    LDA  $53EC
    $4BFB: 18          CLC  
    $4BFC: 7D E4 53    ADC  $53E4,X
    $4BFF: 85 19       STA  $19
    $4C01: A9 01       LDA  #$01
    $4C03: 85 04       STA  $04
    $4C05: 68          PLA  
    $4C06: AA          TAX  
    $4C07: BD C8 53    LDA  $53C8,X
    $4C0A: 20 A1 52    JSR  $52A1

L_4C0D:
    $4C0D: CE F8 53    DEC  $53F8
    $4C10: 10 DD       BPL  L_4BEF
    $4C12: 60          RTS  

L_4C13:
    $4C13: A9 03       LDA  #$03
    $4C15: 8D F8 53    STA  $53F8

L_4C18:
    $4C18: AE F8 53    LDX  $53F8
    $4C1B: BD C0 53    LDA  $53C0,X
    $4C1E: F0 16       BEQ  L_4C36
    $4C20: 48          PHA  
    $4C21: AD EE 53    LDA  $53EE
    $4C24: 18          CLC  
    $4C25: 7D E4 53    ADC  $53E4,X
    $4C28: 85 19       STA  $19
    $4C2A: A9 B4       LDA  #$B4
    $4C2C: 85 04       STA  $04
    $4C2E: 68          PLA  
    $4C2F: AA          TAX  
    $4C30: BD CF 53    LDA  $53CF,X
    $4C33: 20 A1 52    JSR  $52A1

L_4C36:
    $4C36: CE F8 53    DEC  $53F8
    $4C39: 10 DD       BPL  L_4C18
    $4C3B: 60          RTS  

SUB_4C3C:
    $4C3C: C9 00       CMP  #$00
    $4C3E: D0 03       BNE  L_4C43
    $4C40: 4C EA 4B    JMP  $4BEA

L_4C43:
    $4C43: C9 03       CMP  #$03
    $4C45: D0 03       BNE  L_4C4A
    $4C47: 4C 98 4B    JMP  $4B98

L_4C4A:
    $4C4A: C9 01       CMP  #$01
    $4C4C: D0 03       BNE  L_4C51
    $4C4E: 4C C1 4B    JMP  $4BC1

L_4C51:
    $4C51: 4C 13 4C    JMP  $4C13
    $4C54: 00          BRK  
    $4C55: 00          BRK  

SUB_4C56:
    $4C56: AD 54 4C    LDA  $4C54
    $4C59: 85 19       STA  $19
    $4C5B: AD 55 4C    LDA  $4C55
    $4C5E: 85 04       STA  $04
    $4C60: A5 3A       LDA  $3A
    $4C62: D0 05       BNE  L_4C69
    $4C64: A9 9A       LDA  #$9A
    $4C66: 4C 6B 4C    JMP  $4C6B

L_4C69:
    $4C69: A9 90       LDA  #$90

L_4C6B:
    $4C6B: 2C 30 C0    BIT  $C030  ; SPKR
    $4C6E: 4C 7F 52    JMP  $527F

SUB_4C71:
    $4C71: AD 54 4C    LDA  $4C54
    $4C74: 85 19       STA  $19
    $4C76: AD 55 4C    LDA  $4C55
    $4C79: 85 04       STA  $04
    $4C7B: A5 3A       LDA  $3A
    $4C7D: D0 05       BNE  L_4C84
    $4C7F: A9 9A       LDA  #$9A
    $4C81: 4C 86 4C    JMP  $4C86

L_4C84:
    $4C84: A9 90       LDA  #$90

L_4C86:
    $4C86: 2C 30 C0    BIT  $C030  ; SPKR
    $4C89: 4C A1 52    JMP  $52A1
    $4C8C: 00          BRK  
    $4C8D: 00          BRK  
    $4C8E: 60          RTS  
    $4C8F: C0 C0       CPY  #$C0
    $4C91: 00          BRK  
    $4C92: 00          BRK  
    $4C93: 51 01       EOR  ($01),Y
    $4C95: A5 A5       LDA  $A5
    $4C97: 01 00       ORA  ($00,X)

SUB_4C99:
    $4C99: A9 C0       LDA  #$C0
    $4C9B: 8D 54 4C    STA  $4C54
    $4C9E: A9 01       LDA  #$01
    $4CA0: 8D 55 4C    STA  $4C55
    $4CA3: A9 04       LDA  #$04
    $4CA5: 8D 98 4C    STA  $4C98

L_4CA8:
    $4CA8: AE 98 4C    LDX  $4C98
    $4CAB: BD 8E 4C    LDA  $4C8E,X
    $4CAE: 8D 8C 4C    STA  $4C8C
    $4CB1: BD 93 4C    LDA  $4C93,X
    $4CB4: 8D 8D 4C    STA  $4C8D

L_4CB7:
    $4CB7: 20 71 4C    JSR  $4C71
    $4CBA: AD 54 4C    LDA  $4C54
    $4CBD: CD 8C 4C    CMP  $4C8C
    $4CC0: F0 11       BEQ  L_4CD3
    $4CC2: B0 09       BCS  L_4CCD
    $4CC4: 18          CLC  
    $4CC5: 69 04       ADC  #$04
    $4CC7: 8D 54 4C    STA  $4C54
    $4CCA: 4C D3 4C    JMP  $4CD3

L_4CCD:
    $4CCD: 38          SEC  
    $4CCE: E9 04       SBC  #$04
    $4CD0: 8D 54 4C    STA  $4C54

L_4CD3:
    $4CD3: AD 55 4C    LDA  $4C55
    $4CD6: CD 8D 4C    CMP  $4C8D
    $4CD9: F0 11       BEQ  L_4CEC
    $4CDB: B0 09       BCS  L_4CE6
    $4CDD: 18          CLC  
    $4CDE: 69 04       ADC  #$04
    $4CE0: 8D 55 4C    STA  $4C55
    $4CE3: 4C EC 4C    JMP  $4CEC

L_4CE6:
    $4CE6: 38          SEC  
    $4CE7: E9 04       SBC  #$04
    $4CE9: 8D 55 4C    STA  $4C55

L_4CEC:
    $4CEC: 20 56 4C    JSR  $4C56
; ============================================================================
; CHEAT CODE: Press Shift-N (caret ^) during level completion animation
; On Apple II/II+ keyboard, Shift-N produces the caret character (code $9E)
; Effect: +3 lives AND resets difficulty to easiest (index 11)
; ============================================================================
    $4CEF: AD 00 C0    LDA  $C000  ; KEYBOARD - read current key
    $4CF2: C9 9E       CMP  #$9E   ; Is it Shift-N (caret ^)?
    $4CF4: D0 0E       BNE  L_4D04 ; No - skip cheat
    $4CF6: AD 10 C0    LDA  $C010  ; KBDSTRB - clear keyboard strobe
    $4CF9: A9 0B       LDA  #$0B   ; Reset difficulty index to 11 (easiest)
    $4CFB: 85 30       STA  $30    ; Next SUB_56E4 call will reload easy timing
    $4CFD: A9 03       LDA  #$03   ; Add 3 lives
    $4CFF: 18          CLC
    $4D00: 65 10       ADC  $10    ; Add to current lives
    $4D02: 85 10       STA  $10    ; Store new total
; ============================================================================

L_4D04:
    $4D04: A9 20       LDA  #$20
    $4D06: 8D 32 4D    STA  $4D32

L_4D09:
    $4D09: 20 1C 5C    JSR  $5C1C
    $4D0C: 2C 30 C0    BIT  $C030  ; SPKR
    $4D0F: CE 32 4D    DEC  $4D32
    $4D12: 10 F5       BPL  L_4D09
    $4D14: A9 FF       LDA  #$FF
    $4D16: 20 6C 5C    JSR  $5C6C
    $4D19: AD 54 4C    LDA  $4C54
    $4D1C: CD 8C 4C    CMP  $4C8C
    $4D1F: D0 96       BNE  L_4CB7
    $4D21: AD 55 4C    LDA  $4C55
    $4D24: CD 8D 4C    CMP  $4C8D
    $4D27: D0 8E       BNE  L_4CB7
    $4D29: CE 98 4C    DEC  $4C98
    $4D2C: 30 03       BMI  L_4D31
    $4D2E: 4C A8 4C    JMP  $4CA8

L_4D31:
    $4D31: 60          RTS  
    $4D32: 00          BRK  

SUB_4D33:
    $4D33: A9 14       LDA  #$14
    $4D35: 85 02       STA  $02
    $4D37: A9 75       LDA  #$75
    $4D39: 85 04       STA  $04
    $4D3B: A9 97       LDA  #$97
    $4D3D: 20 16 04    JSR  $0416
    $4D40: A9 77       LDA  #$77
    $4D42: 85 19       STA  $19
    $4D44: A9 75       LDA  #$75
    $4D46: 85 04       STA  $04
    $4D48: A6 3A       LDX  $3A
    $4D4A: F0 07       BEQ  L_4D53
    $4D4C: BD 6E 4D    LDA  $4D6E,X
    $4D4F: 20 7F 52    JSR  $527F
    $4D52: 60          RTS  

L_4D53:
    $4D53: A9 14       LDA  #$14
    $4D55: 85 02       STA  $02
    $4D57: A9 82       LDA  #$82
    $4D59: 85 04       STA  $04
    $4D5B: A9 98       LDA  #$98
    $4D5D: 20 16 04    JSR  $0416
    $4D60: A9 1A       LDA  #$1A
    $4D62: 85 02       STA  $02
    $4D64: A9 75       LDA  #$75
    $4D66: 85 04       STA  $04
    $4D68: A9 99       LDA  #$99
    $4D6A: 20 16 04    JSR  $0416
    $4D6D: 60          RTS  
    $4D6E: 00          BRK  
    $4D6F: 66 5F       ROR  $5F
    $4D71: 35 74       AND  $74,X

SUB_4D73:
    $4D73: A2 03       LDX  #$03
    $4D75: A9 00       LDA  #$00

L_4D77:
    $4D77: 9D B8 53    STA  $53B8,X
    $4D7A: 9D C0 53    STA  $53C0,X
    $4D7D: 9D BC 53    STA  $53BC,X
    $4D80: 9D C4 53    STA  $53C4,X
    $4D83: CA          DEX  
    $4D84: 10 F1       BPL  L_4D77
    $4D86: 60          RTS  

SUB_4D87:
    $4D87: A2 03       LDX  #$03
    $4D89: 8E BB 4D    STX  $4DBB

L_4D8C:
    $4D8C: AE BB 4D    LDX  $4DBB
    $4D8F: BD 58 5D    LDA  $5D58,X
    $4D92: F0 21       BEQ  L_4DB5
    $4D94: E0 03       CPX  #$03
    $4D96: F0 1A       BEQ  L_4DB2
    $4D98: E0 02       CPX  #$02
    $4D9A: F0 0A       BEQ  L_4DA6
    $4D9C: E0 01       CPX  #$01
    $4D9E: F0 0C       BEQ  L_4DAC
    $4DA0: 20 E3 4D    JSR  $4DE3
    $4DA3: 4C B5 4D    JMP  $4DB5

L_4DA6:
    $4DA6: 20 8B 4E    JSR  $4E8B
    $4DA9: 4C B5 4D    JMP  $4DB5

L_4DAC:
    $4DAC: 20 38 4E    JSR  $4E38
    $4DAF: 4C B5 4D    JMP  $4DB5

L_4DB2:
    $4DB2: 20 E0 4E    JSR  $4EE0

L_4DB5:
    $4DB5: CE BB 4D    DEC  $4DBB
    $4DB8: 10 D2       BPL  L_4D8C
    $4DBA: 60          RTS  
    $4DBB: 00          BRK  
    $4DBC: 00          BRK  
    $4DBD: 00          BRK  
    $4DBE: 03          .BYTE $03
    $4DBF: 06 09       ASL  $09
    $4DC1: 00          BRK  
    $4DC2: 01 02       ORA  ($02,X)

SUB_4DC4:
    $4DC4: AA          TAX  
    $4DC5: BD BD 4D    LDA  $4DBD,X
    $4DC8: 20 E0 4A    JSR  $4AE0
    $4DCB: A9 14       LDA  #$14
    $4DCD: A0 0A       LDY  #$0A
    $4DCF: 20 35 4F    JSR  $4F35
    $4DD2: AE BB 4D    LDX  $4DBB
    $4DD5: A9 00       LDA  #$00
    $4DD7: 9D 58 5D    STA  $5D58,X
    $4DDA: 20 41 44    JSR  $4441
    $4DDD: 20 E4 56    JSR  SUB_56E4 ; Increase difficulty (projectile hit)
    $4DE0: 4C 4F 5B    JMP  $5B4F

SUB_4DE3:
    $4DE3: AD 64 5D    LDA  $5D64
    $4DE6: C9 0A       CMP  #$0A
    $4DE8: B0 4D       BCS  L_4E37
    $4DEA: 20 0E 56    JSR  $560E
    $4DED: F0 48       BEQ  L_4E37
    $4DEF: 8E BC 4D    STX  $4DBC
    $4DF2: 20 C4 4D    JSR  $4DC4
    $4DF5: AE BC 4D    LDX  $4DBC
    $4DF8: AD EC 53    LDA  $53EC
    $4DFB: 18          CLC  
    $4DFC: 7D E4 53    ADC  $53E4,X
    $4DFF: 8D FC 53    STA  $53FC
    $4E02: 85 19       STA  $19
    $4E04: A9 01       LDA  #$01
    $4E06: 85 04       STA  $04
    $4E08: BD B8 53    LDA  $53B8,X ; Get alien type
    $4E0B: AA          TAX
    $4E0C: BD C8 53    LDA  $53C8,X ; Look up sprite index
    $4E0F: 20 A1 52    JSR  $52A1   ; Draw old sprite (erase)
    $4E12: AE BC 4D    LDX  $4DBC
; ALIEN EVOLUTION - "Genetic Drift" mechanic!
; Cycle: UFO(1) → Eye1(2) → Eye2(3) → TV(4) → Diamond(5) → Bowtie(6) → UFO(1)...
    $4E15: FE B8 53    INC  $53B8,X ; Evolve to next form!
    $4E18: BD B8 53    LDA  $53B8,X ; Get new type
    $4E1B: C9 07       CMP  #$07   ; If reached 7...
    $4E1D: 90 05       BCC  L_4E24 ; ...no, still valid
    $4E1F: A9 01       LDA  #$01   ; ...yes, wrap back to type 1 (UFO)
    $4E21: 9D B8 53    STA  $53B8,X

L_4E24:
    $4E24: AD FC 53    LDA  $53FC
    $4E27: 85 19       STA  $19
    $4E29: A9 01       LDA  #$01
    $4E2B: 85 04       STA  $04
    $4E2D: BD B8 53    LDA  $53B8,X
    $4E30: AA          TAX  
    $4E31: BD C8 53    LDA  $53C8,X
    $4E34: 20 7F 52    JSR  $527F

L_4E37:
    $4E37: 60          RTS  

SUB_4E38:
    $4E38: AD 61 5D    LDA  $5D61
    $4E3B: F0 4D       BEQ  L_4E8A
    $4E3D: 20 0E 56    JSR  $560E
    $4E40: 8E BC 4D    STX  $4DBC
    $4E43: F0 45       BEQ  L_4E8A
    $4E45: 20 C4 4D    JSR  $4DC4
    $4E48: AE BC 4D    LDX  $4DBC
    $4E4B: AD F1 53    LDA  $53F1
    $4E4E: 18          CLC  
    $4E4F: 7D E4 53    ADC  $53E4,X
    $4E52: 8D FA 53    STA  $53FA
    $4E55: 85 04       STA  $04
    $4E57: A9 C4       LDA  #$C4
    $4E59: 85 19       STA  $19
    $4E5B: BD BC 53    LDA  $53BC,X
    $4E5E: AA          TAX  
    $4E5F: BD DD 53    LDA  $53DD,X
    $4E62: 20 A1 52    JSR  $52A1
    $4E65: AE BC 4D    LDX  $4DBC
    $4E68: FE BC 53    INC  $53BC,X
    $4E6B: BD BC 53    LDA  $53BC,X
    $4E6E: C9 07       CMP  #$07
    $4E70: 90 05       BCC  L_4E77
    $4E72: A9 01       LDA  #$01
    $4E74: 9D BC 53    STA  $53BC,X

L_4E77:
    $4E77: AD FA 53    LDA  $53FA
    $4E7A: 85 04       STA  $04
    $4E7C: A9 C4       LDA  #$C4
    $4E7E: 85 19       STA  $19
    $4E80: BD BC 53    LDA  $53BC,X
    $4E83: AA          TAX  
    $4E84: BD DD 53    LDA  $53DD,X
    $4E87: 20 7F 52    JSR  $527F

L_4E8A:
    $4E8A: 60          RTS  

SUB_4E8B:
    $4E8B: AD 66 5D    LDA  $5D66
    $4E8E: C9 B4       CMP  #$B4
    $4E90: 90 4D       BCC  L_4EDF
    $4E92: 20 0E 56    JSR  $560E
    $4E95: F0 48       BEQ  L_4EDF
    $4E97: 8E BC 4D    STX  $4DBC
    $4E9A: 20 C4 4D    JSR  $4DC4
    $4E9D: AE BC 4D    LDX  $4DBC
    $4EA0: AD EE 53    LDA  $53EE
    $4EA3: 18          CLC  
    $4EA4: 7D E4 53    ADC  $53E4,X
    $4EA7: 8D FC 53    STA  $53FC
    $4EAA: 85 19       STA  $19
    $4EAC: A9 B4       LDA  #$B4
    $4EAE: 85 04       STA  $04
    $4EB0: BD C0 53    LDA  $53C0,X
    $4EB3: AA          TAX  
    $4EB4: BD CF 53    LDA  $53CF,X
    $4EB7: 20 A1 52    JSR  $52A1
    $4EBA: AE BC 4D    LDX  $4DBC
    $4EBD: FE C0 53    INC  $53C0,X
    $4EC0: BD C0 53    LDA  $53C0,X
    $4EC3: C9 07       CMP  #$07
    $4EC5: 90 05       BCC  L_4ECC
    $4EC7: A9 01       LDA  #$01
    $4EC9: 9D C0 53    STA  $53C0,X

L_4ECC:
    $4ECC: AD FC 53    LDA  $53FC
    $4ECF: 85 19       STA  $19
    $4ED1: A9 B4       LDA  #$B4
    $4ED3: 85 04       STA  $04
    $4ED5: BD C0 53    LDA  $53C0,X
    $4ED8: AA          TAX  
    $4ED9: BD CF 53    LDA  $53CF,X
    $4EDC: 20 7F 52    JSR  $527F

L_4EDF:
    $4EDF: 60          RTS  

SUB_4EE0:
    $4EE0: AD 5F 5D    LDA  $5D5F
    $4EE3: C9 46       CMP  #$46
    $4EE5: B0 4D       BCS  L_4F34
    $4EE7: 20 0E 56    JSR  $560E
    $4EEA: F0 48       BEQ  L_4F34
    $4EEC: 8E BC 4D    STX  $4DBC
    $4EEF: 20 C4 4D    JSR  $4DC4
    $4EF2: AE BC 4D    LDX  $4DBC
    $4EF5: AD F3 53    LDA  $53F3
    $4EF8: 18          CLC  
    $4EF9: 7D E4 53    ADC  $53E4,X
    $4EFC: 8D FA 53    STA  $53FA
    $4EFF: 85 04       STA  $04
    $4F01: A9 00       LDA  #$00
    $4F03: 85 19       STA  $19
    $4F05: BD C4 53    LDA  $53C4,X
    $4F08: AA          TAX  
    $4F09: BD D6 53    LDA  $53D6,X
    $4F0C: 20 A1 52    JSR  $52A1
    $4F0F: AE BC 4D    LDX  $4DBC
    $4F12: FE C4 53    INC  $53C4,X
    $4F15: BD C4 53    LDA  $53C4,X
    $4F18: C9 07       CMP  #$07
    $4F1A: 90 05       BCC  L_4F21
    $4F1C: A9 01       LDA  #$01
    $4F1E: 9D C4 53    STA  $53C4,X

L_4F21:
    $4F21: AD FA 53    LDA  $53FA
    $4F24: 85 04       STA  $04
    $4F26: A9 00       LDA  #$00
    $4F28: 85 19       STA  $19
    $4F2A: BD C4 53    LDA  $53C4,X
    $4F2D: AA          TAX  
    $4F2E: BD D6 53    LDA  $53D6,X
    $4F31: 20 7F 52    JSR  $527F

L_4F34:
    $4F34: 60          RTS  

SUB_4F35:
    $4F35: 85 38       STA  $38
    $4F37: 84 39       STY  $39
    $4F39: A2 30       LDX  #$30

L_4F3B:
    $4F3B: A4 38       LDY  $38

L_4F3D:
    $4F3D: EA          NOP  
    $4F3E: EA          NOP  
    $4F3F: EA          NOP  
    $4F40: 88          DEY  
    $4F41: D0 FA       BNE  L_4F3D
    $4F43: 8D 30 C0    STA  $C030  ; SPKR
    $4F46: CA          DEX  
    $4F47: D0 F2       BNE  L_4F3B
    $4F49: A2 30       LDX  #$30

L_4F4B:
    $4F4B: A4 39       LDY  $39

L_4F4D:
    $4F4D: EA          NOP  

L_4F4E:
    $4F4E: EA          NOP  
    $4F4F: EA          NOP  
    $4F50: 88          DEY  
    $4F51: D0 FA       BNE  L_4F4D
    $4F53: 8D 30 C0    STA  $C030  ; SPKR
    $4F56: EA          NOP  
    $4F57: CA          DEX  
    $4F58: D0 F1       BNE  L_4F4B
    $4F5A: 60          RTS  

SUB_4F5B:
    $4F5B: A2 03       LDX  #$03
    $4F5D: 86 12       STX  $12

L_4F5F:
    $4F5F: A6 12       LDX  $12
    $4F61: BD 58 5D    LDA  $5D58,X
    $4F64: D0 03       BNE  L_4F69
    $4F66: 4C F5 4F    JMP  $4FF5

L_4F69:
    $4F69: E0 03       CPX  #$03
    $4F6B: F0 26       BEQ  L_4F93
    $4F6D: E0 02       CPX  #$02
    $4F6F: F0 18       BEQ  L_4F89
    $4F71: E0 01       CPX  #$01
    $4F73: F0 0A       BEQ  L_4F7F
    $4F75: BD 64 5D    LDA  $5D64,X
    $4F78: C9 26       CMP  #$26
    $4F7A: 90 1E       BCC  L_4F9A
    $4F7C: 4C F5 4F    JMP  $4FF5

L_4F7F:
    $4F7F: BD 5C 5D    LDA  $5D5C,X
    $4F82: C9 E3       CMP  #$E3
    $4F84: B0 14       BCS  L_4F9A
    $4F86: 4C F5 4F    JMP  $4FF5

L_4F89:
    $4F89: BD 64 5D    LDA  $5D64,X
    $4F8C: C9 98       CMP  #$98
    $4F8E: B0 0A       BCS  L_4F9A
    $4F90: 4C F5 4F    JMP  $4FF5

L_4F93:
    $4F93: BD 5C 5D    LDA  $5D5C,X
    $4F96: C9 71       CMP  #$71
    $4F98: B0 5B       BCS  L_4FF5

L_4F9A:
    $4F9A: A0 03       LDY  #$03
    $4F9C: 8C 01 50    STY  $5001

L_4F9F:
    $4F9F: AC 01 50    LDY  $5001
    $4FA2: B9 12 52    LDA  $5212,Y
    $4FA5: F0 49       BEQ  L_4FF0
    $4FA7: B9 0E 52    LDA  $520E,Y
    $4FAA: 38          SEC  
    $4FAB: A6 12       LDX  $12
    $4FAD: FD FD 4F    SBC  $4FFD,X
    $4FB0: C9 05       CMP  #$05
    $4FB2: B0 3C       BCS  L_4FF0
    $4FB4: A9 08       LDA  #$08
    $4FB6: A0 10       LDY  #$10
    $4FB8: 20 35 4F    JSR  $4F35
    $4FBB: AE 01 50    LDX  $5001
    $4FBE: BD 12 52    LDA  $5212,X
    $4FC1: 20 E0 4A    JSR  $4AE0    ; Add score
    $4FC4: 20 E4 56    JSR  SUB_56E4 ; Increase difficulty (heart collected)
    $4FC7: A6 12       LDX  $12
    $4FC9: A9 00       LDA  #$00
    $4FCB: 9D 58 5D    STA  $5D58,X
    $4FCE: 20 41 44    JSR  $4441
    $4FD1: 20 4F 5B    JSR  $5B4F
    $4FD4: AE 01 50    LDX  $5001
    $4FD7: DE 21 52    DEC  $5221,X
    $4FDA: D0 14       BNE  L_4FF0
    $4FDC: 20 C9 52    JSR  $52C9
    $4FDF: AE 01 50    LDX  $5001
    $4FE2: DE 12 52    DEC  $5212,X
    $4FE5: BD 12 52    LDA  $5212,X
    $4FE8: 9D 21 52    STA  $5221,X
    $4FEB: F0 03       BEQ  L_4FF0
    $4FED: 20 C3 52    JSR  $52C3

L_4FF0:
    $4FF0: CE 01 50    DEC  $5001
    $4FF3: 10 AA       BPL  L_4F9F

L_4FF5:
    $4FF5: C6 12       DEC  $12
    $4FF7: 30 03       BMI  L_4FFC
    $4FF9: 4C 5F 4F    JMP  $4F5F

L_4FFC:
    $4FFC: 60          RTS  
    $4FFD: 97          .BYTE $97
    $4FFE: D7          .BYTE $D7
    $4FFF: 17          .BYTE $17
    $5000: 57          .BYTE $57
    $5001: 00          BRK  
    $5002: 89          .BYTE $89
    $5003: 88          DEY  
    $5004: 86 85       STX  $85
    $5006: 84 82       STY  $82
    $5008: 81 80       STA  ($80,X)
    $500A: 7E 7D 7C    ROR  $7C7D,X
    $500D: 7A          .BYTE $7A
    $500E: 79 77 76    ADC  $7677,Y
    $5011: 75 73       ADC  $73,X
    $5013: 72          .BYTE $72
    $5014: 70 6F       BVS  L_5085
    $5016: 6D 6C 6A    ADC  $6A6C
    $5019: 69 67       ADC  #$67
    $501B: 66 64       ROR  $64
    $501D: 63          .BYTE $63
    $501E: 62          .BYTE $62
    $501F: 60          RTS  
    $5020: 5F          .BYTE $5F
    $5021: 5D 5C 5A    EOR  $5A5C,X
    $5024: 59 57 56    EOR  $5657,Y
    $5027: 55 53       EOR  $53,X
    $5029: 52          .BYTE $52
    $502A: 51 4F       EOR  ($4F),Y
    $502C: 4E 4D 4B    LSR  $4B4D
    $502F: 4A          LSR  
    $5030: 49 47       EOR  #$47
    $5032: 46 45       LSR  $45
    $5034: 44          .BYTE $44
    $5035: 43          .BYTE $43
    $5036: 42          .BYTE $42
    $5037: 40          RTI  
    $5038: 3F          .BYTE $3F
    $5039: 3E 3D 3C    ROL  $3C3D,X
    $503C: 3B          .BYTE $3B
    $503D: 3A          .BYTE $3A
    $503E: 39 39 38    AND  $3839,Y
    $5041: 37          .BYTE $37
    $5042: 36 35       ROL  $35,X
    $5044: 34          .BYTE $34
    $5045: 34          .BYTE $34
    $5046: 33          .BYTE $33
    $5047: 32          .BYTE $32
    $5048: 32          .BYTE $32
    $5049: 31 31       AND  ($31),Y
    $504B: 30 30       BMI  L_507D
    $504D: 2F          .BYTE $2F
    $504E: 2F          .BYTE $2F
    $504F: 2E 2E 2E    ROL  $2E2E
    $5052: 2D 2D 2D    AND  $2D2D
    $5055: 2D 2D 2D    AND  $2D2D
    $5058: 2D 2D 2D    AND  $2D2D
    $505B: 2D 2D 2D    AND  $2D2D
    $505E: 2D 2D 2D    AND  $2D2D
    $5061: 2E 2E 2E    ROL  $2E2E
    $5064: 2F          .BYTE $2F
    $5065: 2F          .BYTE $2F
    $5066: 2F          .BYTE $2F
    $5067: 30 30       BMI  L_5099
    $5069: 31 31       AND  ($31),Y
    $506B: 32          .BYTE $32
    $506C: 33          .BYTE $33
    $506D: 33          .BYTE $33
    $506E: 34          .BYTE $34
    $506F: 35 36       AND  $36,X
    $5071: 36 37       ROL  $37,X
    $5073: 38          SEC  
    $5074: 39 3A 3B    AND  $3B3A,Y
    $5077: 3C          .BYTE $3C
    $5078: 3D 3E 3F    AND  $3F3E,X
    $507B: 40          RTI  
    $507C: 41 42       EOR  ($42,X)
    $507E: 43          .BYTE $43
    $507F: 44          .BYTE $44
    $5080: 46 47       LSR  $47
    $5082: 48          PHA  
    $5083: 49 4B       EOR  #$4B

L_5085:
    $5085: 4C 4D 4F    JMP  $4F4D
    $5088: 50 51       BVC  L_50DB
    $508A: 53          .BYTE $53
    $508B: 54          .BYTE $54
    $508C: 55 57       EOR  $57,X
    $508E: 58          CLI  
    $508F: 5A          .BYTE $5A
    $5090: 5B          .BYTE $5B
    $5091: 5C          .BYTE $5C
    $5092: 5E 5F 61    LSR  $615F,X
    $5095: 62          .BYTE $62

L_5096:
    $5096: 64          .BYTE $64
    $5097: 65 67       ADC  $67

L_5099:
    $5099: 68          PLA  
    $509A: 6A          ROR  
    $509B: 6B          .BYTE $6B
    $509C: 6D 6E 6F    ADC  $6F6E
    $509F: 71 72       ADC  ($72),Y
    $50A1: 74          .BYTE $74
    $50A2: 75 77       ADC  $77,X
    $50A4: 78          SEI  
    $50A5: 7A          .BYTE $7A
    $50A6: 7B          .BYTE $7B
    $50A7: 7C          .BYTE $7C
    $50A8: 7E 7F 80    ROR  $807F,X
    $50AB: 82          .BYTE $82
    $50AC: 83          .BYTE $83
    $50AD: 84 86       STY  $86
    $50AF: 87          .BYTE $87
    $50B0: 88          DEY  
    $50B1: 8A          TXA  
    $50B2: 8B          .BYTE $8B
    $50B3: 8C 8D 8E    STY  $8E8D
    $50B6: 8F          .BYTE $8F
    $50B7: 91 92       STA  ($92),Y
    $50B9: 93          .BYTE $93
    $50BA: 94 95       STY  $95,X
    $50BC: 96 97       STX  $97,Y
    $50BE: 98          TYA  
    $50BF: 98          TYA  
    $50C0: 99 9A 9B    STA  $9B9A,Y
    $50C3: 9C          .BYTE $9C
    $50C4: 9D 9D 9E    STA  $9E9D,X
    $50C7: 9F          .BYTE $9F
    $50C8: 9F          .BYTE $9F
    $50C9: A0 A0       LDY  #$A0
    $50CB: A1 A1       LDA  ($A1,X)
    $50CD: A2 A2       LDX  #$A2
    $50CF: A3          .BYTE $A3
    $50D0: A3          .BYTE $A3
    $50D1: A3          .BYTE $A3
    $50D2: A4 A4       LDY  $A4
    $50D4: A4 A4       LDY  $A4
    $50D6: A4 A4       LDY  $A4
    $50D8: A4 A4       LDY  $A4
    $50DA: A4 A4       LDY  $A4
    $50DC: A4 A4       LDY  $A4
    $50DE: A4 A4       LDY  $A4
    $50E0: A4 A3       LDY  $A3
    $50E2: A3          .BYTE $A3
    $50E3: A3          .BYTE $A3
    $50E4: A2 A2       LDX  #$A2
    $50E6: A2 A1       LDX  #$A1
    $50E8: A1 A0       LDA  ($A0,X)
    $50EA: A0 9F       LDY  #$9F
    $50EC: 9E          .BYTE $9E
    $50ED: 9E          .BYTE $9E
    $50EE: 9D 9C 9B    STA  $9B9C,X
    $50F1: 9B          .BYTE $9B
    $50F2: 9A          TXS  
    $50F3: 99 98 97    STA  $9798,Y
    $50F6: 96 95       STX  $95,Y
    $50F8: 94 93       STY  $93,X
    $50FA: 92          .BYTE $92
    $50FB: 91 90       STA  ($90),Y
    $50FD: 8F          .BYTE $8F
    $50FE: 8E 8D 8B    STX  $8B8D
    $5101: 8A          TXA  
    $5102: 8F          .BYTE $8F
    $5103: 90 91       BCC  L_5096
    $5105: 91 92       STA  ($92),Y
    $5107: 93          .BYTE $93
    $5108: 93          .BYTE $93
    $5109: 94 94       STY  $94,X
    $510B: 95 95       STA  $95,X
    $510D: 96 96       STX  $96,Y
    $510F: 97          .BYTE $97
    $5110: 97          .BYTE $97
    $5111: 97          .BYTE $97
    $5112: 98          TYA  
    $5113: 98          TYA  
    $5114: 98          TYA  
    $5115: 98          TYA  
    $5116: 98          TYA  
    $5117: 98          TYA  
    $5118: 98          TYA  
    $5119: 98          TYA  
    $511A: 98          TYA  
    $511B: 98          TYA  
    $511C: 98          TYA  
    $511D: 98          TYA  
    $511E: 98          TYA  
    $511F: 98          TYA  
    $5120: 98          TYA  
    $5121: 97          .BYTE $97
    $5122: 97          .BYTE $97
    $5123: 97          .BYTE $97
    $5124: 96 96       STX  $96,Y
    $5126: 96 95       STX  $95,Y
    $5128: 95 94       STA  $94,X
    $512A: 94 93       STY  $93,X
    $512C: 92          .BYTE $92
    $512D: 92          .BYTE $92
    $512E: 91 90       STA  ($90),Y
    $5130: 8F          .BYTE $8F
    $5131: 8F          .BYTE $8F
    $5132: 8E 8D 8C    STX  $8C8D
    $5135: 8B          .BYTE $8B
    $5136: 8A          TXA  
    $5137: 89          .BYTE $89
    $5138: 88          DEY  
    $5139: 87          .BYTE $87
    $513A: 86 85       STX  $85
    $513C: 84 83       STY  $83
    $513E: 82          .BYTE $82
    $513F: 81 7F       STA  ($7F,X)
    $5141: 7E 7D 7C    ROR  $7C7D,X
    $5144: 7A          .BYTE $7A
    $5145: 79 78 76    ADC  $7678,Y
    $5148: 75 74       ADC  $74,X
    $514A: 72          .BYTE $72
    $514B: 71 70       ADC  ($70),Y
    $514D: 6E 6D 6B    ROR  $6B6D
    $5150: 6A          ROR  
    $5151: 69 67       ADC  #$67
    $5153: 66 64       ROR  $64
    $5155: 63          .BYTE $63
    $5156: 61 60       ADC  ($60,X)
    $5158: 5E 5D 5B    LSR  $5B5D,X
    $515B: 5A          .BYTE $5A
    $515C: 58          CLI  
    $515D: 57          .BYTE $57
    $515E: 56 54       LSR  $54,X
    $5160: 53          .BYTE $53
    $5161: 51 50       EOR  ($50),Y
    $5163: 4E 4D 4B    LSR  $4B4D
    $5166: 4A          LSR  
    $5167: 49 47       EOR  #$47
    $5169: 46 45       LSR  $45
    $516B: 43          .BYTE $43
    $516C: 42          .BYTE $42
    $516D: 41 3F       EOR  ($3F,X)
    $516F: 3E 3D 3B    ROL  $3B3D,X
    $5172: 3A          .BYTE $3A
    $5173: 39 38 37    AND  $3738,Y
    $5176: 36 34       ROL  $34,X
    $5178: 33          .BYTE $33
    $5179: 32          .BYTE $32
    $517A: 31 30       AND  ($30),Y
    $517C: 2F          .BYTE $2F
    $517D: 2E 2D 2D    ROL  $2D2D
    $5180: 2C 2B 2A    BIT  $2A2B
    $5183: 29 28       AND  #$28
    $5185: 28          PLP  
    $5186: 27          .BYTE $27
    $5187: 26 26       ROL  $26
    $5189: 25 25       AND  $25
    $518B: 24 24       BIT  $24
    $518D: 23          .BYTE $23
    $518E: 23          .BYTE $23
    $518F: 22          .BYTE $22
    $5190: 22          .BYTE $22
    $5191: 22          .BYTE $22
    $5192: 21 21       AND  ($21,X)
    $5194: 21 21       AND  ($21,X)
    $5196: 21 21       AND  ($21,X)
    $5198: 21 21       AND  ($21,X)
    $519A: 21 21       AND  ($21,X)
    $519C: 21 21       AND  ($21,X)
    $519E: 21 21       AND  ($21,X)
    $51A0: 21 22       AND  ($22,X)
    $51A2: 22          .BYTE $22
    $51A3: 22          .BYTE $22
    $51A4: 23          .BYTE $23
    $51A5: 23          .BYTE $23
    $51A6: 23          .BYTE $23
    $51A7: 24 24       BIT  $24
    $51A9: 25 25       AND  $25
    $51AB: 26 27       ROL  $27
    $51AD: 27          .BYTE $27
    $51AE: 28          PLP  
    $51AF: 29 2A       AND  #$2A
    $51B1: 2A          ROL  
    $51B2: 2B          .BYTE $2B
    $51B3: 2C 2D 2E    BIT  $2E2D
    $51B6: 2F          .BYTE $2F
    $51B7: 30 31       BMI  L_51EA
    $51B9: 32          .BYTE $32
    $51BA: 33          .BYTE $33
    $51BB: 34          .BYTE $34
    $51BC: 35 36       AND  $36,X
    $51BE: 37          .BYTE $37
    $51BF: 38          SEC  
    $51C0: 3A          .BYTE $3A
    $51C1: 3B          .BYTE $3B
    $51C2: 3C          .BYTE $3C
    $51C3: 3D 3F 40    AND  $403F,X
    $51C6: 41 43       EOR  ($43,X)
    $51C8: 44          .BYTE $44
    $51C9: 45 47       EOR  $47
    $51CB: 48          PHA  
    $51CC: 49 4B       EOR  #$4B
    $51CE: 4C 4E 4F    JMP  $4F4E
    $51D1: 50 52       BVC  L_5225
    $51D3: 53          .BYTE $53
    $51D4: 55 56       EOR  $56,X
    $51D6: 58          CLI  
    $51D7: 59 5B 5C    EOR  $5C5B,Y
    $51DA: 5E 5F 61    LSR  $615F,X
    $51DD: 62          .BYTE $62
    $51DE: 63          .BYTE $63
    $51DF: 65 66       ADC  $66
    $51E1: 68          PLA  
    $51E2: 69 6B       ADC  #$6B
    $51E4: 6C 6E 6F    JMP  ($6F6E)
    $51E7: 70 72       BVS  L_525B
    $51E9: 73          .BYTE $73

L_51EA:
    $51EA: 74          .BYTE $74
    $51EB: 76 77       ROR  $77,X
    $51ED: 78          SEI  
    $51EE: 7A          .BYTE $7A
    $51EF: 7B          .BYTE $7B
    $51F0: 7C          .BYTE $7C
    $51F1: 7E 7F 80    ROR  $807F,X
    $51F4: 81 82       STA  ($82,X)
    $51F6: 83          .BYTE $83
    $51F7: 85 86       STA  $86
    $51F9: 87          .BYTE $87
    $51FA: 88          DEY  
    $51FB: 89          .BYTE $89
    $51FC: 8A          TXA  
    $51FD: 8B          .BYTE $8B
    $51FE: 8C 8C 8D    STY  $8D8C
    $5201: 8E AD 10    STX  $10AD
    $5204: C0 AD       CPY  #$AD
    $5206: 00          BRK  
    $5207: C0 10       CPY  #$10
    $5209: FB          .BYTE $FB
    $520A: 8D 10 C0    STA  $C010  ; KBDSTRB
    $520D: 60          RTS  
    $520E: 81 A0       STA  ($A0,X)
    $5210: A5 A0       LDA  $A0
    $5212: A9 A0       LDA  #$A0
    $5214: 87          .BYTE $87
    $5215: CD 93 A0    CMP  $A093
    $5218: 95 D4       STA  $D4,X
    $521A: 00          BRK  
    $521B: 2E 58 3C    ROL  $3C58
    $521E: 43          .BYTE $43
    $521F: 4A          LSR  
    $5220: 51 CF       EOR  ($CF),Y
    $5222: A0 FE       LDY  #$FE
    $5224: AE 00 00    LDX  $0000

SUB_5227:
    $5227: A2 03       LDX  #$03

L_5229:
    $5229: BD 12 52    LDA  $5212,X
    $522C: F0 04       BEQ  L_5232
    $522E: CA          DEX  
    $522F: 10 F8       BPL  L_5229
    $5231: 60          RTS  

L_5232:
    $5232: 8E 25 52    STX  $5225
    $5235: A5 3A       LDA  $3A
    $5237: C9 03       CMP  #$03
    $5239: F0 09       BEQ  L_5244
    $523B: C9 02       CMP  #$02
    $523D: D0 0A       BNE  L_5249
    $523F: A9 04       LDA  #$04
    $5241: 4C 4B 52    JMP  $524B

L_5244:
    $5244: A9 02       LDA  #$02
    $5246: 4C 4B 52    JMP  $524B

L_5249:
    $5249: A9 06       LDA  #$06

L_524B:
    $524B: 9D 12 52    STA  $5212,X
    $524E: 9D 21 52    STA  $5221,X

L_5251:
    $5251: 20 03 04    JSR  $0403
    $5254: C9 F0       CMP  #$F0
    $5256: B0 F9       BCS  L_5251
    $5258: 8D 26 52    STA  $5226

L_525B:
    $525B: A0 03       LDY  #$03

L_525D:
    $525D: B9 12 52    LDA  $5212,Y
    $5260: F0 0F       BEQ  L_5271
    $5262: AD 26 52    LDA  $5226
    $5265: 38          SEC  
    $5266: F9 0E 52    SBC  $520E,Y
    $5269: C9 0A       CMP  #$0A
    $526B: 90 E4       BCC  L_5251
    $526D: C9 F6       CMP  #$F6
    $526F: B0 E0       BCS  L_5251

L_5271:
    $5271: 88          DEY  
    $5272: 10 E9       BPL  L_525D
    $5274: AD 26 52    LDA  $5226
    $5277: AE 25 52    LDX  $5225
    $527A: 9D 0E 52    STA  $520E,X
    $527D: 60          RTS  
    $527E: 00          BRK  

L_527F:
    $527F: 8D 7E 52    STA  $527E
    $5282: A5 19       LDA  $19
    $5284: 29 FE       AND  #$FE
    $5286: AA          TAX  
    $5287: BD AA 47    LDA  $47AA,X
    $528A: 18          CLC  
    $528B: 69 09       ADC  #$09
    $528D: 85 02       STA  $02
    $528F: A5 19       LDA  $19
    $5291: 4A          LSR  
    $5292: AA          TAX  
    $5293: BD 92 46    LDA  $4692,X
    $5296: AA          TAX  
    $5297: BD D3 48    LDA  $48D3,X
    $529A: 18          CLC  
    $529B: 6D 7E 52    ADC  $527E
    $529E: 4C 16 04    JMP  $0416

L_52A1:
    $52A1: 8D 7E 52    STA  $527E
    $52A4: A5 19       LDA  $19
    $52A6: 29 FE       AND  #$FE
    $52A8: AA          TAX  
    $52A9: BD AA 47    LDA  $47AA,X
    $52AC: 18          CLC  
    $52AD: 69 09       ADC  #$09
    $52AF: 85 02       STA  $02
    $52B1: A5 19       LDA  $19
    $52B3: 4A          LSR  
    $52B4: AA          TAX  
    $52B5: BD 92 46    LDA  $4692,X
    $52B8: AA          TAX  
    $52B9: BD D3 48    LDA  $48D3,X
    $52BC: 18          CLC  
    $52BD: 6D 7E 52    ADC  $527E
    $52C0: 4C C0 40    JMP  $40C0

SUB_52C3:
    $52C3: 20 CF 52    JSR  $52CF
    $52C6: 4C 7F 52    JMP  $527F

SUB_52C9:
    $52C9: 20 CF 52    JSR  $52CF
    $52CC: 4C A1 52    JMP  $52A1

SUB_52CF:
    $52CF: BD 0E 52    LDA  $520E,X
    $52D2: A8          TAY  
    $52D3: B9 02 51    LDA  $5102,Y
    $52D6: 85 04       STA  $04
    $52D8: B9 02 50    LDA  $5002,Y
    $52DB: 85 19       STA  $19
    $52DD: BD 12 52    LDA  $5212,X
    $52E0: A8          TAY  
    $52E1: B9 1A 52    LDA  $521A,Y
    $52E4: 60          RTS  

SUB_52E5:
    $52E5: A2 03       LDX  #$03
    $52E7: A9 00       LDA  #$00

L_52E9:
    $52E9: 9D 12 52    STA  $5212,X
    $52EC: CA          DEX  
    $52ED: 10 FA       BPL  L_52E9
    $52EF: 60          RTS  
    $52F0: 00          BRK  
    $52F1: E0 E0       CPX  #$E0

SUB_52F3:
    $52F3: EE F1 52    INC  $52F1
    $52F6: F0 01       BEQ  L_52F9
    $52F8: 60          RTS  

L_52F9:
    $52F9: AD F2 52    LDA  $52F2
    $52FC: 8D F1 52    STA  $52F1
    $52FF: CE F0 52    DEC  $52F0
    $5302: 10 05       BPL  L_5309
    $5304: A9 03       LDA  #$03
    $5306: 8D F0 52    STA  $52F0

L_5309:
    $5309: AE F0 52    LDX  $52F0
    $530C: BD 12 52    LDA  $5212,X
    $530F: F0 25       BEQ  L_5336
    $5311: BD 0E 52    LDA  $520E,X
    $5314: A2 03       LDX  #$03

L_5316:
    $5316: DD 37 53    CMP  $5337,X
    $5319: D0 09       BNE  L_5324
    $531B: 20 3B 53    JSR  $533B
    $531E: AE F0 52    LDX  $52F0
    $5321: 4C 2A 53    JMP  $532A

L_5324:
    $5324: CA          DEX  
    $5325: 10 EF       BPL  L_5316
    $5327: AE F0 52    LDX  $52F0

L_532A:
    $532A: 20 C9 52    JSR  $52C9
    $532D: AE F0 52    LDX  $52F0
    $5330: DE 0E 52    DEC  $520E,X
    $5333: 20 C3 52    JSR  $52C3

L_5336:
    $5336: 60          RTS  
    $5337: 96 D6       STX  $D6,Y
    $5339: 16 56       ASL  $56,X

SUB_533B:
    $533B: BD 54 5D    LDA  $5D54,X
    $533E: D0 21       BNE  L_5361
    $5340: A9 01       LDA  #$01
    $5342: 9D 54 5D    STA  $5D54,X
    $5345: BD 62 53    LDA  $5362,X
    $5348: 9D 48 5D    STA  $5D48,X
    $534B: BD 66 53    LDA  $5366,X
    $534E: 9D 4C 5D    STA  $5D4C,X
    $5351: BD 6A 53    LDA  $536A,X
    $5354: 9D 50 5D    STA  $5D50,X
    $5357: A0 10       LDY  #$10
    $5359: A9 45       LDA  #$45
    $535B: 8D 67 5B    STA  $5B67
    $535E: 4C 62 5B    JMP  $5B62

L_5361:
    $5361: 60          RTS  
    $5362: A9 E5       LDA  #$E5
    $5364: A9 6D       LDA  #$6D
    $5366: 00          BRK  
    $5367: 00          BRK  
    $5368: 00          BRK
    $5369: 00          BRK
    $536A: 22          .BYTE $22
    $536B: 5E 9A 5E    LSR  $5E9A,X
    $536E: 00          BRK
    $536F: 00          .BYTE $00   ; 4-DIRECTION FIRE AMMO COUNTER

; ============================================================================
; SUB_5370: Reset 4-direction fire ammo to 3 (called at level start)
; ============================================================================
SUB_5370:
    $5370: A9 03       LDA  #$03   ; 3 shots per level
    $5372: 8D 6F 53    STA  $536F  ; Store in ammo counter
    $5375: 60          RTS

; ============================================================================
; SUB_5376: Increment 4-direction fire ammo (called during difficulty reload)
; ============================================================================
SUB_5376:
    $5376: EE 6F 53    INC  $536F  ; Add 1 ammo
    $5379: D0 05       BNE  L_5380
    $537B: A9 FF       LDA  #$FF   ; Cap at 255
    $537D: 8D 6F 53    STA  $536F

L_5380:
    $5380: 60          RTS

; ============================================================================
; L_5381: 4-DIRECTION SIMULTANEOUS FIRE (A or F key)
; Fires projectiles in all 4 directions at once! Uses ammo at $536F
; When ammo=0, falls back to single-direction fire like ESC
; ============================================================================
L_5381:
    $5381: AD 6F 53    LDA  $536F  ; Check ammo
    $5384: F0 2D       BEQ  L_53B3 ; No ammo - just set fire flag
    $5386: CE 6F 53    DEC  $536F  ; Use 1 ammo
    $5389: A2 03       LDX  #$03
    $538B: 8E 6E 53    STX  $536E

L_538E:
    $538E: AE 6E 53    LDX  $536E
    $5391: BD 58 5D    LDA  $5D58,X
    $5394: D0 17       BNE  L_53AD
    $5396: A9 01       LDA  #$01
    $5398: 9D 58 5D    STA  $5D58,X
    $539B: BD 68 5D    LDA  $5D68,X
    $539E: 9D 5C 5D    STA  $5D5C,X
    $53A1: BD 6C 5D    LDA  $5D6C,X
    $53A4: 9D 60 5D    STA  $5D60,X
    $53A7: BD 70 5D    LDA  $5D70,X
    $53AA: 9D 64 5D    STA  $5D64,X

L_53AD:
    $53AD: CE 6E 53    DEC  $536E
    $53B0: 10 DC       BPL  L_538E
    $53B2: 60          RTS  

L_53B3:
    $53B3: A9 01       LDA  #$01
    $53B5: 85 36       STA  $36
    $53B7: 60          RTS

; ============================================================================
; ALIEN TYPE TABLE - $53B8 (16 entries, 4 per direction)
; Each byte is alien type: 0=empty, 1=UFO, 2=Eye1, 3=Eye2, 4=TV, 5=Diamond, 6=Bowtie
; Layout: $53B8-$53BB=UP, $53BC-$53BF=LEFT, $53C0-$53C3=DOWN, $53C4-$53C7=RIGHT
; ============================================================================
TBL_ALIEN_TYPES:
    $53B8: C6 A5 D4 A0   ; Direction 0 (UP) - 4 aliens (runtime values)
    $53BC: A0 E7 A0 A0   ; Direction 1 (LEFT) - 4 aliens
    $53C0: C9 A0 A0 A0   ; Direction 2 (DOWN) - 4 aliens
    $53C4: D5 A0 A9 A0   ; Direction 3 (RIGHT) - 4 aliens

; ============================================================================
; ALIEN TYPE TO SPRITE INDEX LOOKUP - $53C8
; Maps alien type (0-6) to sprite index for shape table lookup
; Type 0=$00, 1=$74(UFO), 2=$35(Eye1), 3=$5F(Eye2), 4=$66(TV), 5=$6D(Diamond), 6=$7B(Bowtie)
; ============================================================================
TBL_TYPE_TO_SPRITE:
    $53C8: 00          ; Type 0: Empty
    $53C9: 74          ; Type 1: UFO alien (sprite at $69AB)
    $53CA: 35          ; Type 2: Eye alien color 1 (sprite at $65AA)
    $53CB: 5F          ; Type 3: Eye alien color 2 (sprite at $6859)
    $53CC: 66          ; Type 4: TV - THE GOAL! (sprite at $6898)
    $53CD: 6D          ; Type 5: Diamond - PENALTY STATE! (sprite at $691F)
    $53CE: 7B          ; Type 6: Bowtie alien (sprite at $6A30)
    $53CF: 00          BRK  
    $53D0: 74          .BYTE $74
    $53D1: 35 5F       AND  $5F,X
    $53D3: 66 6D       ROR  $6D
    $53D5: 7B          .BYTE $7B
    $53D6: 00          BRK  
    $53D7: 74          .BYTE $74
    $53D8: 35 5F       AND  $5F,X
    $53DA: 66 6D       ROR  $6D
    $53DC: 7B          .BYTE $7B
    $53DD: 00          BRK  
    $53DE: 74          .BYTE $74
    $53DF: 35 5F       AND  $5F,X
    $53E1: 66 6D       ROR  $6D
    $53E3: 7B          .BYTE $7B
    $53E4: 00          BRK  
    $53E5: 15 2A       ORA  $2A,X
    $53E7: 3F          .BYTE $3F
    $53E8: 00          BRK  
    $53E9: 15 2A       ORA  $2A,X
    $53EB: 3F          .BYTE $3F
    $53EC: 14          .BYTE $14
    $53ED: 14          .BYTE $14
    $53EE: 14          .BYTE $14
    $53EF: 14          .BYTE $14
    $53F0: 14          .BYTE $14
    $53F1: 14          .BYTE $14
    $53F2: 14          .BYTE $14
    $53F3: 14          .BYTE $14
    $53F4: FE FE 02    INC  $02FE,X
    $53F7: 02          .BYTE $02
    $53F8: 00          BRK  
    $53F9: 00          BRK  
    $53FA: 00          BRK  
    $53FB: 00          BRK  
    $53FC: 00          BRK  

L_53FD:
    $53FD: AD F3 53    LDA  $53F3
    $5400: 8D F9 53    STA  $53F9
    $5403: 18          CLC  
    $5404: 6D F7 53    ADC  $53F7
    $5407: 8D FA 53    STA  $53FA
    $540A: 8D F3 53    STA  $53F3
    $540D: C9 0A       CMP  #$0A
    $540F: 90 04       BCC  L_5415
    $5411: C9 6C       CMP  #$6C
    $5413: 90 09       BCC  L_541E

L_5415:
    $5415: 38          SEC  
    $5416: A9 00       LDA  #$00
    $5418: ED F7 53    SBC  $53F7
    $541B: 8D F7 53    STA  $53F7

L_541E:
    $541E: A9 03       LDA  #$03
    $5420: 8D F8 53    STA  $53F8

L_5423:
    $5423: AE F8 53    LDX  $53F8
    $5426: BD C4 53    LDA  $53C4,X
    $5429: F0 30       BEQ  L_545B
    $542B: 48          PHA  
    $542C: AD F9 53    LDA  $53F9
    $542F: 18          CLC  
    $5430: 7D E8 53    ADC  $53E8,X
    $5433: 85 04       STA  $04
    $5435: A9 09       LDA  #$09
    $5437: 85 02       STA  $02
    $5439: 68          PLA  
    $543A: AA          TAX  
    $543B: BD D6 53    LDA  $53D6,X
    $543E: 20 C0 40    JSR  $40C0
    $5441: AE F8 53    LDX  $53F8
    $5444: AD FA 53    LDA  $53FA
    $5447: 18          CLC  
    $5448: 7D E8 53    ADC  $53E8,X
    $544B: 85 04       STA  $04
    $544D: A9 09       LDA  #$09
    $544F: 85 02       STA  $02
    $5451: BD C4 53    LDA  $53C4,X
    $5454: AA          TAX  
    $5455: BD D6 53    LDA  $53D6,X
    $5458: 20 16 04    JSR  $0416

L_545B:
    $545B: CE F8 53    DEC  $53F8
    $545E: 10 C3       BPL  L_5423
    $5460: 60          RTS  

L_5461:
    $5461: AD F1 53    LDA  $53F1
    $5464: 8D F9 53    STA  $53F9
    $5467: 18          CLC  
    $5468: 6D F5 53    ADC  $53F5
    $546B: 8D FA 53    STA  $53FA
    $546E: 8D F1 53    STA  $53F1
    $5471: C9 0A       CMP  #$0A
    $5473: 90 04       BCC  L_5479
    $5475: C9 6C       CMP  #$6C
    $5477: 90 09       BCC  L_5482

L_5479:
    $5479: 38          SEC  
    $547A: A9 00       LDA  #$00
    $547C: ED F5 53    SBC  $53F5
    $547F: 8D F5 53    STA  $53F5

L_5482:
    $5482: A9 03       LDA  #$03
    $5484: 8D F8 53    STA  $53F8

L_5487:
    $5487: AE F8 53    LDX  $53F8
    $548A: BD BC 53    LDA  $53BC,X
    $548D: F0 30       BEQ  L_54BF
    $548F: 48          PHA  
    $5490: AD F9 53    LDA  $53F9
    $5493: 18          CLC  
    $5494: 7D E8 53    ADC  $53E8,X
    $5497: 85 04       STA  $04
    $5499: A9 25       LDA  #$25
    $549B: 85 02       STA  $02
    $549D: 68          PLA  
    $549E: AA          TAX  
    $549F: BD DD 53    LDA  $53DD,X
    $54A2: 20 C0 40    JSR  $40C0
    $54A5: AE F8 53    LDX  $53F8
    $54A8: AD FA 53    LDA  $53FA
    $54AB: 18          CLC  
    $54AC: 7D E8 53    ADC  $53E8,X
    $54AF: 85 04       STA  $04
    $54B1: A9 25       LDA  #$25
    $54B3: 85 02       STA  $02
    $54B5: BD BC 53    LDA  $53BC,X
    $54B8: AA          TAX  
    $54B9: BD DD 53    LDA  $53DD,X
    $54BC: 20 16 04    JSR  $0416

L_54BF:
    $54BF: CE F8 53    DEC  $53F8
    $54C2: 10 C3       BPL  L_5487
    $54C4: 60          RTS  

L_54C5:
    $54C5: AD EC 53    LDA  $53EC
    $54C8: 8D FB 53    STA  $53FB
    $54CB: 18          CLC  
    $54CC: 6D F4 53    ADC  $53F4
    $54CF: 8D FC 53    STA  $53FC
    $54D2: 8D EC 53    STA  $53EC
    $54D5: C9 0A       CMP  #$0A
    $54D7: 90 04       BCC  L_54DD
    $54D9: C9 85       CMP  #$85
    $54DB: 90 09       BCC  L_54E6

L_54DD:
    $54DD: 38          SEC  
    $54DE: A9 00       LDA  #$00
    $54E0: ED F4 53    SBC  $53F4
    $54E3: 8D F4 53    STA  $53F4

L_54E6:
    $54E6: A9 03       LDA  #$03
    $54E8: 8D F8 53    STA  $53F8

L_54EB:
    $54EB: AE F8 53    LDX  $53F8
    $54EE: BD B8 53    LDA  $53B8,X
    $54F1: F0 30       BEQ  L_5523
    $54F3: 48          PHA  
    $54F4: AD FB 53    LDA  $53FB
    $54F7: 18          CLC  
    $54F8: 7D E4 53    ADC  $53E4,X
    $54FB: 85 19       STA  $19
    $54FD: A9 01       LDA  #$01
    $54FF: 85 04       STA  $04
    $5501: 68          PLA  
    $5502: AA          TAX  
    $5503: BD C8 53    LDA  $53C8,X
    $5506: 20 A1 52    JSR  $52A1
    $5509: AE F8 53    LDX  $53F8
    $550C: AD FC 53    LDA  $53FC
    $550F: 18          CLC  
    $5510: 7D E4 53    ADC  $53E4,X
    $5513: 85 19       STA  $19
    $5515: A9 01       LDA  #$01
    $5517: 85 04       STA  $04
    $5519: BD B8 53    LDA  $53B8,X
    $551C: AA          TAX  
    $551D: BD C8 53    LDA  $53C8,X
    $5520: 20 7F 52    JSR  $527F

L_5523:
    $5523: CE F8 53    DEC  $53F8
    $5526: 10 C3       BPL  L_54EB
    $5528: 60          RTS  

L_5529:
    $5529: AD EE 53    LDA  $53EE
    $552C: 8D FB 53    STA  $53FB
    $552F: 18          CLC  
    $5530: 6D F6 53    ADC  $53F6
    $5533: 8D FC 53    STA  $53FC
    $5536: 8D EE 53    STA  $53EE
    $5539: C9 0A       CMP  #$0A
    $553B: 90 04       BCC  L_5541
    $553D: C9 85       CMP  #$85
    $553F: 90 09       BCC  L_554A

L_5541:
    $5541: 38          SEC  
    $5542: A9 00       LDA  #$00
    $5544: ED F6 53    SBC  $53F6
    $5547: 8D F6 53    STA  $53F6

L_554A:
    $554A: A9 03       LDA  #$03
    $554C: 8D F8 53    STA  $53F8

L_554F:
    $554F: AE F8 53    LDX  $53F8
    $5552: BD C0 53    LDA  $53C0,X
    $5555: F0 30       BEQ  L_5587
    $5557: 48          PHA  
    $5558: AD FB 53    LDA  $53FB
    $555B: 18          CLC  
    $555C: 7D E4 53    ADC  $53E4,X
    $555F: 85 19       STA  $19
    $5561: A9 B4       LDA  #$B4
    $5563: 85 04       STA  $04
    $5565: 68          PLA  
    $5566: AA          TAX  
    $5567: BD CF 53    LDA  $53CF,X
    $556A: 20 A1 52    JSR  $52A1
    $556D: AE F8 53    LDX  $53F8
    $5570: AD FC 53    LDA  $53FC
    $5573: 18          CLC  
    $5574: 7D E4 53    ADC  $53E4,X
    $5577: 85 19       STA  $19
    $5579: A9 B4       LDA  #$B4
    $557B: 85 04       STA  $04
    $557D: BD C0 53    LDA  $53C0,X
    $5580: AA          TAX  
    $5581: BD CF 53    LDA  $53CF,X
    $5584: 20 7F 52    JSR  $527F

L_5587:
    $5587: CE F8 53    DEC  $53F8
    $558A: 10 C3       BPL  L_554F
    $558C: 60          RTS  
    $558D: F8          SED  
    $558E: F8          SED  
    $558F: 00          BRK  
    $5590: 00          BRK  

SUB_5591:
    $5591: EE 8D 55    INC  $558D
    $5594: D0 49       BNE  L_55DF
    $5596: AD 8E 55    LDA  $558E
    $5599: 8D 8D 55    STA  $558D
    $559C: EE 8F 55    INC  $558F
    $559F: AD 8F 55    LDA  $558F
    $55A2: 29 03       AND  #$03
    $55A4: 8D 8F 55    STA  $558F
    $55A7: AA          TAX  
    $55A8: BD 54 5D    LDA  $5D54,X
    $55AB: D0 32       BNE  L_55DF
    $55AD: 20 0E 56    JSR  $560E
    $55B0: F0 2D       BEQ  L_55DF
    $55B2: E6 2C       INC  $2C
    $55B4: D0 29       BNE  L_55DF
    $55B6: A5 32       LDA  $32
    $55B8: 85 2C       STA  $2C
    $55BA: AD 8F 55    LDA  $558F
    $55BD: 0A          ASL  
    $55BE: 0A          ASL  
    $55BF: 18          CLC  
    $55C0: 69 03       ADC  #$03
    $55C2: AA          TAX  
    $55C3: BD B8 53    LDA  $53B8,X
    $55C6: CA          DEX  
    $55C7: A0 02       LDY  #$02

L_55C9:
    $55C9: DD B8 53    CMP  $53B8,X
    $55CC: D0 0B       BNE  L_55D9
    $55CE: CA          DEX  
    $55CF: 88          DEY  
    $55D0: 10 F7       BPL  L_55C9
    $55D2: 20 03 04    JSR  $0403
    $55D5: C9 80       CMP  #$80
    $55D7: B0 06       BCS  L_55DF

L_55D9:
    $55D9: AE 8F 55    LDX  $558F
    $55DC: 20 0C 4B    JSR  $4B0C

L_55DF:
    $55DF: 60          RTS  
    $55E0: E0 E0       CPX  #$E0
    $55E2: 00          BRK  

SUB_55E3:
    $55E3: EE E1 55    INC  $55E1
    $55E6: F0 01       BEQ  L_55E9
    $55E8: 60          RTS  

L_55E9:
    $55E9: AD E0 55    LDA  $55E0
    $55EC: 8D E1 55    STA  $55E1
    $55EF: CE E2 55    DEC  $55E2
    $55F2: AD E2 55    LDA  $55E2
    $55F5: 10 08       BPL  L_55FF
    $55F7: A9 03       LDA  #$03
    $55F9: 8D E2 55    STA  $55E2
    $55FC: 4C FD 53    JMP  $53FD

L_55FF:
    $55FF: D0 03       BNE  L_5604
    $5601: 4C C5 54    JMP  $54C5

L_5604:
    $5604: C9 01       CMP  #$01
    $5606: D0 03       BNE  L_560B
    $5608: 4C 61 54    JMP  $5461

L_560B:
    $560B: 4C 29 55    JMP  $5529

SUB_560E:
    $560E: E0 01       CPX  #$01
    $5610: D0 03       BNE  L_5615
    $5612: 4C 9E 56    JMP  $569E

L_5615:
    $5615: E0 02       CPX  #$02
    $5617: D0 03       BNE  L_561C
    $5619: 4C 4C 56    JMP  $564C

L_561C:
    $561C: E0 03       CPX  #$03
    $561E: D0 03       BNE  L_5623
    $5620: 4C 75 56    JMP  $5675

L_5623:
    $5623: AD EC 53    LDA  $53EC
    $5626: 8D FB 53    STA  $53FB
    $5629: A9 03       LDA  #$03
    $562B: 8D F8 53    STA  $53F8

L_562E:
    $562E: AE F8 53    LDX  $53F8
    $5631: AD FB 53    LDA  $53FB
    $5634: 18          CLC  
    $5635: 7D E4 53    ADC  $53E4,X
    $5638: C9 5F       CMP  #$5F
    $563A: 90 08       BCC  L_5644
    $563C: C9 6F       CMP  #$6F
    $563E: B0 04       BCS  L_5644
    $5640: BD B8 53    LDA  $53B8,X
    $5643: 60          RTS  

L_5644:
    $5644: CE F8 53    DEC  $53F8
    $5647: 10 E5       BPL  L_562E
    $5649: A9 00       LDA  #$00
    $564B: 60          RTS  

L_564C:
    $564C: AD EE 53    LDA  $53EE
    $564F: 8D FB 53    STA  $53FB
    $5652: A9 03       LDA  #$03
    $5654: 8D F8 53    STA  $53F8

L_5657:
    $5657: AE F8 53    LDX  $53F8
    $565A: AD FB 53    LDA  $53FB
    $565D: 18          CLC  
    $565E: 7D E4 53    ADC  $53E4,X
    $5661: C9 5F       CMP  #$5F
    $5663: 90 08       BCC  L_566D
    $5665: C9 6F       CMP  #$6F
    $5667: B0 04       BCS  L_566D
    $5669: BD C0 53    LDA  $53C0,X
    $566C: 60          RTS  

L_566D:
    $566D: CE F8 53    DEC  $53F8
    $5670: 10 E5       BPL  L_5657
    $5672: A9 00       LDA  #$00
    $5674: 60          RTS  

L_5675:
    $5675: AD F3 53    LDA  $53F3
    $5678: 8D F9 53    STA  $53F9
    $567B: A9 03       LDA  #$03
    $567D: 8D F8 53    STA  $53F8

L_5680:
    $5680: AE F8 53    LDX  $53F8
    $5683: AD F9 53    LDA  $53F9
    $5686: 18          CLC  
    $5687: 7D E8 53    ADC  $53E8,X
    $568A: C9 5A       CMP  #$5A
    $568C: 90 08       BCC  L_5696
    $568E: C9 63       CMP  #$63
    $5690: B0 04       BCS  L_5696
    $5692: BD C4 53    LDA  $53C4,X
    $5695: 60          RTS  

L_5696:
    $5696: CE F8 53    DEC  $53F8
    $5699: 10 E5       BPL  L_5680
    $569B: A9 00       LDA  #$00
    $569D: 60          RTS  

L_569E:
    $569E: AD F1 53    LDA  $53F1
    $56A1: 8D F9 53    STA  $53F9
    $56A4: A9 03       LDA  #$03
    $56A6: 8D F8 53    STA  $53F8

L_56A9:
    $56A9: AE F8 53    LDX  $53F8
    $56AC: AD F9 53    LDA  $53F9
    $56AF: 18          CLC  
    $56B0: 7D E8 53    ADC  $53E8,X
    $56B3: C9 5A       CMP  #$5A
    $56B5: 90 08       BCC  L_56BF
    $56B7: C9 63       CMP  #$63
    $56B9: B0 04       BCS  L_56BF
    $56BB: BD BC 53    LDA  $53BC,X
    $56BE: 60          RTS  

L_56BF:
    $56BF: CE F8 53    DEC  $53F8
    $56C2: 10 E5       BPL  L_56A9
    $56C4: A9 00       LDA  #$00
    $56C6: 60          RTS  
    $56C7: 00          BRK  
    $56C8: 00          BRK  

SUB_56C9:
    $56C9: 20 03 04    JSR  $0403
    $56CC: 29 03       AND  #$03
    $56CE: AA          TAX  
    $56CF: BD 54 5D    LDA  $5D54,X
    $56D2: F0 0E       BEQ  L_56E2
    $56D4: 8E C7 56    STX  $56C7
    $56D7: 20 C4 44    JSR  $44C4
    $56DA: AE C7 56    LDX  $56C7
    $56DD: A9 00       LDA  #$00
    $56DF: 9D 54 5D    STA  $5D54,X

L_56E2:
    $56E2: 60          RTS
    $56E3: 50          .BYTE $50     ; Unreachable byte (filler)

; ============================================================================
; SUB_56E4: Progressive Difficulty Increase
; Called from $4DDD (projectile hit) and $4FC4 (heart collected)
; Decrements $31; when it reaches 0, decrements $30 and reloads timing tables
; This makes the game progressively faster as you play!
; ============================================================================
SUB_56E4:
    $56E4: C6 31       DEC  $31      ; Decrement difficulty step counter
    $56E6: D0 09       BNE  L_56F1   ; If not zero, just return
    $56E8: A5 30       LDA  $30      ; Load difficulty index (11=easy, 0=hard)
    $56EA: F0 05       BEQ  L_56F1   ; If already 0 (max difficulty), return
    $56EC: C6 30       DEC  $30      ; Decrease index = increase difficulty!
    $56EE: 4C F3 56    JMP  SUB_56F3 ; Reload all timing tables with new index

L_56F1:
    $56F1: 60          RTS
    $56F2: 00          .BYTE $00     ; Temp storage used by SUB_56F3

; ============================================================================
; SUB_56F3: Load Difficulty Parameters from Tables
; Uses $30 as index (0-11) into 8 lookup tables at $576C-$57C0
; Called at game start ($5829) and when difficulty increases (from SUB_56E4)
; Higher index = easier (slower), lower index = harder (faster)
; ============================================================================
SUB_56F3:
    $56F3: A6 30       LDX  $30      ; X = difficulty index (0-11)
    $56F5: BD 6C 57    LDA  $576C,X  ; Load from table 1
    $56F8: 85 2F       STA  $2F      ; $2F = frame delay reload (for $2E counter)
    $56FA: BD 78 57    LDA  $5778,X  ; Load from table 2
    $56FD: 8D F2 52    STA  $52F2    ; Timing parameter
    $5700: BD 84 57    LDA  $5784,X  ; Load from table 3
    $5703: 8D E0 55    STA  $55E0    ; Timing parameter
    $5706: BD 90 57    LDA  $5790,X  ; Load from table 4
    $5709: 85 32       STA  $32      ; $32 = alien fire rate reload (for $2C counter)
    $570B: BD 9C 57    LDA  $579C,X  ; Load from table 5
    $570E: 8D CC 57    STA  $57CC    ; Timing parameter
    $5711: BD A8 57    LDA  $57A8,X  ; Load from table 6
    $5714: 8D CF 57    STA  $57CF    ; Timing parameter
    $5717: BD B4 57    LDA  $57B4,X  ; Load from table 7
    $571A: 8D D2 57    STA  $57D2    ; Timing parameter (constant $F0)
    $571D: BD C0 57    LDA  $57C0,X  ; Load from table 8
    $5720: 85 31       STA  $31      ; $31 = steps until next difficulty increase
    $5722: 20 76 53    JSR  $5376    ; SUB_5376: Increment 4-dir fire ammo
    $5725: 20 76 53    JSR  $5376    ; (called 3x = +3 ammo)
    $5728: 20 76 53    JSR  $5376
    ; Calculate starting alien type based on difficulty
    $572B: A5 30       LDA  $30      ; Load difficulty index
    $572D: 4A          LSR           ; Divide by 2
    $572E: 8D F2 56    STA  $56F2    ; Store temp
    $5731: A9 06       LDA  #$06     ; 6 - (index/2) = starting alien type
    $5733: 38          SEC           ; At index 11: 6-5=1 (UFO)
    $5734: ED F2 56    SBC  $56F2    ; At index 0: 6-0=6 (Bowtie)
    $5737: 8D F2 56    STA  $56F2    ; Store starting alien type
    $573A: A2 03       LDX  #$03

L_573C:
    $573C: BD B8 53    LDA  $53B8,X
    $573F: D0 06       BNE  L_5747
    $5741: AD F2 56    LDA  $56F2
    $5744: 9D B8 53    STA  $53B8,X

L_5747:
    $5747: BD C0 53    LDA  $53C0,X
    $574A: D0 06       BNE  L_5752
    $574C: AD F2 56    LDA  $56F2
    $574F: 9D C0 53    STA  $53C0,X

L_5752:
    $5752: BD BC 53    LDA  $53BC,X
    $5755: D0 06       BNE  L_575D
    $5757: AD F2 56    LDA  $56F2
    $575A: 9D BC 53    STA  $53BC,X

L_575D:
    $575D: BD C4 53    LDA  $53C4,X
    $5760: D0 06       BNE  L_5768
    $5762: AD F2 56    LDA  $56F2
    $5765: 9D C4 53    STA  $53C4,X

L_5768:
    $5768: CA          DEX  
    $5769: 10 D1       BPL  L_573C

L_576B:
    $576B: 60          RTS

; ============================================================================
; DIFFICULTY LOOKUP TABLES (12 entries each, indexed 0-11 by $30)
; Index 0 = hardest/fastest, Index 11 = easiest/slowest
; ============================================================================

; Table 1 at $576C: Frame delay reload values -> $2F
; Higher = faster game (fewer frames to wait)
TBL_576C:
    $576C: FC FA F9 F7 F5 F4 F0 EB E6 E4 E2 E0
    ;      [0] [1] [2] [3] [4] [5] [6] [7] [8] [9] [10][11]

; Table 2 at $5778: Timing parameter -> $52F2
TBL_5778:
    $5778: F9 F7 F6 F4 F3 F0 EC EB E8 E6 E4 E4

; Table 3 at $5784: Timing parameter -> $55E0
TBL_5784:
    $5784: F8 F6 F4 F1 EF ED EB E9 E7 E5 E3 E1

; Table 4 at $5790: Alien fire rate reload -> $32
TBL_5790:
    $5790: FC FA F7 F5 F0 EE ED EC E7 E4 E2 E0

; Table 5 at $579C: Timing parameter -> $57CC
TBL_579C:
    $579C: F4 F4 F3 F3 F2 F2 F1 F1 F0 F0 F0 F0

; Table 6 at $57A8: Timing parameter -> $57CF
TBL_57A8:
    $57A8: F0 F0 F0 F0 EF E8 E0 D8 D0 C8 C0 C0

; Table 7 at $57B4: Timing parameter -> $57D2 (constant $F0)
TBL_57B4:
    $57B4: F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0

; Table 8 at $57C0: Steps until difficulty increase -> $31
; Lower values = fewer actions before game speeds up again
TBL_57C0:
    $57C0: FF 2A 2A 30 28 1E 1E 18 18 10 10 10
    ;      [0] [1] [2] [3] [4] [5] [6] [7] [8] [9] [10][11]
    ; At index 11 (easiest): $10 = 16 actions before speed increase
    ; At index 0 (hardest): $FF = 255 actions (but already at max speed)

; Runtime variables (loaded from tables above)
    $57CC: 00          .BYTE $00     ; Timing param (from TBL_579C)
    $57CD: 00          .BYTE $00
    $57CE: 00          .BYTE $00
    $57CF: 00          .BYTE $00     ; Timing param (from TBL_57A8)
    $57D0: 00          .BYTE $00
    $57D1: 00          .BYTE $00
    $57D2: 00          .BYTE $00     ; Timing param (from TBL_57B4)
    $57D3: F4          .BYTE $F4
    $57D4: 00          BRK  
    $57D5: 00          BRK
    $57D6: 00          .BYTE $00     ; Temp storage for direction

; ============================================================================
; MAIN ENTRY POINT - Game starts here after bootstrap loader
; ============================================================================
L_57D7:
    $57D7: D8          CLD           ; Clear decimal mode
    $57D8: 20 5B 41    JSR  $415B    ; Initialize game

; Title screen setup
L_57DB:
    $57DB: 20 20 41    JSR  $4120    ; SUB_4120: Init hi-res graphics mode
    $57DE: 20 B5 43    JSR  $43B5    ; Setup/init title screen
    $57E1: A9 00       LDA  #$00     ; Clear score
    $57E3: 85 0C       STA  $0C      ; Score low byte (BCD)
    $57E5: 85 0D       STA  $0D      ; Score high byte (BCD)
    $57E7: 85 0E       STA  $0E      ; High score low
    $57E9: 85 0F       STA  $0F      ; High score high
    $57EB: 85 11       STA  $11

L_57ED:
    $57ED: A9 F0       LDA  #$F0
    $57EF: 85 2C       STA  $2C
    $57F1: 85 2D       STA  $2D
    $57F3: 85 2E       STA  $2E
    $57F5: A9 03       LDA  #$03
    $57F7: 85 10       STA  $10
    $57F9: 85 00       STA  $00
    $57FB: 20 FC 42    JSR  $42FC

; Wait for RETURN key to start game
L_57FE:
    $57FE: E6 00       INC  $00
    $5800: C6 01       DEC  $01
    $5802: AD 00 C0    LDA  $C000  ; KEYBOARD
    $5805: C9 8D       CMP  #$8D   ; RETURN key?
    $5807: D0 F5       BNE  L_57FE ; Loop until pressed

; ============================================================================
; GAME START - Initialize new game
; ============================================================================
L_5809:
    $5809: A9 03       LDA  #$03   ; Starting lives
    $580B: 85 10       STA  $10    ; $10 = lives counter
    $580D: A9 05       LDA  #$05   ; Level counter (counts DOWN: 5,4,3,2,1,0)
    $580F: 85 3A       STA  $3A    ; $3A = level (5=first, 0=victory)
    $5811: 20 73 4D    JSR  $4D73  ; SUB_4D73: Level setup
    $5814: A9 00       LDA  #$00   ; Clear score
    $5816: 85 0C       STA  $0C    ; Score low (BCD)
    $5818: 85 0D       STA  $0D    ; Score high (BCD)
    $581A: 85 11       STA  $11    ; $11 = current direction (0=UP,1=RIGHT,2=DOWN,3=LEFT)
    $581C: 85 34       STA  $34
    $581E: 85 36       STA  $36
    $5820: 20 87 43    JSR  $4387
    $5823: A9 0B       LDA  #$0B   ; Initialize difficulty to easiest (index 11)
    $5825: 85 2B       STA  $2B    ; Paddle button debounce
    $5827: 85 30       STA  $30    ; Difficulty index (0=hard, 11=easy)
    $5829: 20 F3 56    JSR  SUB_56F3 ; Load timing params from difficulty tables
    $582C: 20 70 53    JSR  $5370
    $582F: 20 77 5B    JSR  $5B77
    $5832: A9 05       LDA  #$05
    $5834: 85 35       STA  $35
    $5836: 20 E5 52    JSR  $52E5

L_5839:
    $5839: A5 10       LDA  $10
    $583B: 38          SEC  
    $583C: E9 01       SBC  #$01
    $583E: 10 06       BPL  L_5846
    $5840: 20 86 4A    JSR  $4A86
    $5843: 4C 09 58    JMP  $5809

L_5846:
    $5846: 85 10       STA  $10
    $5848: 20 CD 43    JSR  $43CD
    $584B: 20 3E 41    JSR  $413E
    $584E: A2 03       LDX  #$03
    $5850: A9 00       LDA  #$00

L_5852:
    $5852: 9D 58 5D    STA  $5D58,X
    $5855: 9D 54 5D    STA  $5D54,X
    $5858: CA          DEX  
    $5859: 10 F7       BPL  L_5852
    $585B: 20 7A 43    JSR  $437A
    $585E: 20 4F 5B    JSR  $5B4F
    $5861: AD D3 57    LDA  $57D3
    $5864: 8D D4 57    STA  $57D4
    $5867: 8D D5 57    STA  $57D5
    $586A: A9 F0       LDA  #$F0   ; Initialize timing counters
    $586C: 85 2C       STA  $2C    ; $2C = alien fire rate counter
    $586E: 85 2D       STA  $2D
    $5870: 85 2E       STA  $2E    ; $2E = main frame delay counter
    $5872: 8D 10 C0    STA  $C010  ; KBDSTRB - clear keyboard

; ============================================================================
; MAIN GAME LOOP - Runs every frame during gameplay
; ============================================================================
L_5875:
    $5875: 20 7F 45    JSR  $457F  ; SUB_457F: Move all 4 laser beams
    $5878: 20 F3 52    JSR  $52F3  ; SUB_52F3: Redraw screen/sprites
    $587B: 20 5B 4F    JSR  $4F5B  ; SUB_4F5B: Check laser vs SATELLITE collision
    $587E: 20 1C 5C    JSR  $5C1C  ; SUB_5C1C: Update star twinkle animation
    $5881: 20 78 5C    JSR  $5C78  ; SUB_5C78: Check if all aliens are TVs (level complete?)
    $5884: A5 36       LDA  $36    ; Check ESC fire flag
    $5886: F0 09       BEQ  L_5891 ; If not set, check paddle button
    $5888: E6 01       INC  $01
    $588A: A9 00       LDA  #$00
    $588C: 85 36       STA  $36    ; Clear fire flag
    $588E: 4C A5 58    JMP  $58A5  ; Jump to fire projectile

L_5891:
    $5891: AD 61 C0    LDA  $C061  ; PB0
    $5894: 30 05       BMI  L_589B
    $5896: 85 2B       STA  $2B
    $5898: 4C C3 58    JMP  $58C3

L_589B:
    $589B: 25 2B       AND  $2B
    $589D: 30 24       BMI  L_58C3
    $589F: E6 01       INC  $01
    $58A1: A9 80       LDA  #$80
    $58A3: 85 2B       STA  $2B

L_58A5:
    $58A5: A6 11       LDX  $11
    $58A7: BD 58 5D    LDA  $5D58,X
    $58AA: D0 17       BNE  L_58C3
    $58AC: A9 01       LDA  #$01
    $58AE: 9D 58 5D    STA  $5D58,X
    $58B1: BD 68 5D    LDA  $5D68,X
    $58B4: 9D 5C 5D    STA  $5D5C,X
    $58B7: BD 6C 5D    LDA  $5D6C,X
    $58BA: 9D 60 5D    STA  $5D60,X
    $58BD: BD 70 5D    LDA  $5D70,X
    $58C0: 9D 64 5D    STA  $5D64,X

L_58C3:
    $58C3: 20 87 4D    JSR  $4D87
    $58C6: A2 03       LDX  #$03
    $58C8: 8E D6 57    STX  $57D6

L_58CB:
    $58CB: AE D6 57    LDX  $57D6
    $58CE: BD 58 5D    LDA  $5D58,X
    $58D1: F0 08       BEQ  L_58DB
    $58D3: BD 54 5D    LDA  $5D54,X
    $58D6: F0 03       BEQ  L_58DB
    $58D8: 4C DE 58    JMP  $58DE

L_58DB:
    $58DB: 4C 6E 59    JMP  $596E

L_58DE:
    $58DE: E0 03       CPX  #$03
    $58E0: F0 31       BEQ  L_5913
    $58E2: E0 02       CPX  #$02
    $58E4: F0 22       BEQ  L_5908
    $58E6: E0 01       CPX  #$01
    $58E8: F0 0B       BEQ  L_58F5
    $58EA: BD 64 5D    LDA  $5D64,X
    $58ED: DD 50 5D    CMP  $5D50,X
    $58F0: 90 2C       BCC  L_591E
    $58F2: 4C 6E 59    JMP  $596E

L_58F5:
    $58F5: BD 60 5D    LDA  $5D60,X
    $58F8: DD 4C 5D    CMP  $5D4C,X
    $58FB: 90 71       BCC  L_596E
    $58FD: BD 5C 5D    LDA  $5D5C,X
    $5900: DD 48 5D    CMP  $5D48,X
    $5903: 90 69       BCC  L_596E
    $5905: 4C 1E 59    JMP  $591E

L_5908:
    $5908: BD 64 5D    LDA  $5D64,X
    $590B: DD 50 5D    CMP  $5D50,X
    $590E: B0 0E       BCS  L_591E
    $5910: 4C 6E 59    JMP  $596E

L_5913:
    $5913: BD 5C 5D    LDA  $5D5C,X
    $5916: DD 48 5D    CMP  $5D48,X
    $5919: 90 03       BCC  L_591E
    $591B: 4C 6E 59    JMP  $596E

L_591E:
    $591E: 20 C4 44    JSR  $44C4
    $5921: AE D6 57    LDX  $57D6
    $5924: 20 41 44    JSR  $4441
    $5927: AE D6 57    LDX  $57D6
    $592A: BD 54 5D    LDA  $5D54,X
    $592D: C9 02       CMP  #$02
    $592F: D0 09       BNE  L_593A
    $5931: 20 65 4B    JSR  $4B65
    $5934: AE D6 57    LDX  $57D6
    $5937: 4C 54 59    JMP  $5954

L_593A:
    $593A: C9 03       CMP  #$03
    $593C: D0 16       BNE  L_5954
    $593E: AE D6 57    LDX  $57D6
    $5941: A9 02       LDA  #$02
    $5943: 9D 54 5D    STA  $5D54,X
    $5946: 20 99 44    JSR  $4499
    $5949: A9 00       LDA  #$00
    $594B: AE D6 57    LDX  $57D6
    $594E: 9D 58 5D    STA  $5D58,X
    $5951: 4C 5C 59    JMP  $595C

L_5954:
    $5954: A9 00       LDA  #$00
    $5956: 9D 54 5D    STA  $5D54,X
    $5959: 9D 58 5D    STA  $5D58,X

L_595C:
    $595C: A9 01       LDA  #$01
    $595E: 20 E0 4A    JSR  $4AE0
    $5961: A0 14       LDY  #$14
    $5963: A9 C4       LDA  #$C4
    $5965: 8D 67 5B    STA  $5B67
    $5968: 20 62 5B    JSR  $5B62
    $596B: 20 4F 5B    JSR  $5B4F

L_596E:
    $596E: CE D6 57    DEC  $57D6
    $5971: 30 03       BMI  L_5976
    $5973: 4C CB 58    JMP  $58CB

L_5976:
    $5976: A2 03       LDX  #$03
    $5978: 86 12       STX  $12

L_597A:
    $597A: A6 12       LDX  $12
    $597C: BD 58 5D    LDA  $5D58,X
    $597F: F0 41       BEQ  L_59C2
    $5981: E0 03       CPX  #$03
    $5983: F0 29       BEQ  L_59AE
    $5985: E0 02       CPX  #$02
    $5987: F0 1B       BEQ  L_59A4
    $5989: E0 01       CPX  #$01
    $598B: F0 08       BEQ  L_5995
    $598D: BD 64 5D    LDA  $5D64,X
    $5990: F0 23       BEQ  L_59B5
    $5992: 4C C2 59    JMP  $59C2

L_5995:
    $5995: BD 5C 5D    LDA  $5D5C,X
    $5998: C9 16       CMP  #$16
    $599A: BD 60 5D    LDA  $5D60,X
    $599D: E9 01       SBC  #$01
    $599F: B0 14       BCS  L_59B5
    $59A1: 4C C2 59    JMP  $59C2

L_59A4:
    $59A4: BD 64 5D    LDA  $5D64,X
    $59A7: C9 BF       CMP  #$BF
    $59A9: F0 0A       BEQ  L_59B5
    $59AB: 4C C2 59    JMP  $59C2

L_59AE:
    $59AE: BD 5C 5D    LDA  $5D5C,X
    $59B1: C9 3E       CMP  #$3E
    $59B3: D0 0D       BNE  L_59C2

L_59B5:
    $59B5: 20 41 44    JSR  $4441
    $59B8: 20 4F 5B    JSR  $5B4F
    $59BB: A6 12       LDX  $12
    $59BD: A9 00       LDA  #$00
    $59BF: 9D 58 5D    STA  $5D58,X

L_59C2:
    $59C2: C6 12       DEC  $12
    $59C4: 10 B4       BPL  L_597A
    $59C6: A6 11       LDX  $11
    $59C8: 20 E0 43    JSR  $43E0
    $59CB: E4 11       CPX  $11
    $59CD: D0 03       BNE  L_59D2
    $59CF: 4C E8 59    JMP  $59E8

L_59D2:
    $59D2: BD 34 5D    LDA  $5D34,X
    $59D5: 85 02       STA  $02
    $59D7: BD 38 5D    LDA  $5D38,X
    $59DA: 85 04       STA  $04
    $59DC: 8A          TXA  
    $59DD: 18          CLC  
    $59DE: 69 0B       ADC  #$0B
    $59E0: 20 C0 40    JSR  $40C0
    $59E3: 20 4F 5B    JSR  $5B4F
    $59E6: E6 01       INC  $01

L_59E8:
    $59E8: 20 91 55    JSR  $5591
    $59EB: 20 E3 55    JSR  $55E3
    $59EE: EE CD 57    INC  $57CD
    $59F1: D0 11       BNE  L_5A04
    $59F3: EE CE 57    INC  $57CE
    $59F6: D0 0C       BNE  L_5A04
    $59F8: AD CC 57    LDA  $57CC
    $59FB: 8D CD 57    STA  $57CD
    $59FE: 8D CE 57    STA  $57CE
    $5A01: 20 C9 56    JSR  $56C9

; ============================================================================
; MAIN FRAME TIMING LOOP
; $2E counts up from $2F to $FF, then wraps and triggers periodic logic
; Higher $2F = faster game (fewer frames between periodic actions)
; ============================================================================
L_5A04:
    $5A04: E6 2E       INC  $2E      ; Increment frame counter
    $5A06: D0 52       BNE  L_5A5A   ; If not wrapped, skip to end of loop
    $5A08: A5 2F       LDA  $2F      ; Counter wrapped! Reload from $2F
    $5A0A: 85 2E       STA  $2E      ; (set by difficulty tables)
    $5A0C: 20 0E 45    JSR  $450E    ; Execute periodic game logic
    $5A0F: A2 03       LDX  #$03
    $5A11: 86 12       STX  $12

L_5A13:
    $5A13: A6 12       LDX  $12
    $5A15: BD 54 5D    LDA  $5D54,X
    $5A18: F0 3C       BEQ  L_5A56
    $5A1A: E0 03       CPX  #$03
    $5A1C: F0 1C       BEQ  L_5A3A
    $5A1E: E0 02       CPX  #$02
    $5A20: F0 0E       BEQ  L_5A30
    $5A22: E0 01       CPX  #$01
    $5A24: F0 1E       BEQ  L_5A44
    $5A26: BD 50 5D    LDA  $5D50,X
    $5A29: C9 52       CMP  #$52
    $5A2B: B0 30       BCS  L_5A5D
    $5A2D: 4C 56 5A    JMP  $5A56

L_5A30:
    $5A30: BD 50 5D    LDA  $5D50,X
    $5A33: C9 6B       CMP  #$6B
    $5A35: 90 26       BCC  L_5A5D
    $5A37: 4C 56 5A    JMP  $5A56

L_5A3A:
    $5A3A: BD 48 5D    LDA  $5D48,X
    $5A3D: C9 9B       CMP  #$9B
    $5A3F: 90 15       BCC  L_5A56
    $5A41: 4C 5D 5A    JMP  $5A5D

L_5A44:
    $5A44: BD 48 5D    LDA  $5D48,X
    $5A47: C9 B6       CMP  #$B6
    $5A49: 90 03       BCC  L_5A4E
    $5A4B: 4C 56 5A    JMP  $5A56

L_5A4E:
    $5A4E: BD 4C 5D    LDA  $5D4C,X
    $5A51: D0 03       BNE  L_5A56
    $5A53: 4C 5D 5A    JMP  $5A5D

L_5A56:
    $5A56: C6 12       DEC  $12
    $5A58: 10 B9       BPL  L_5A13

L_5A5A:
    $5A5A: 4C 75 58    JMP  $5875    ; Back to top of main game loop (L_5875)

L_5A5D:
    $5A5D: BD 54 5D    LDA  $5D54,X
    $5A60: C9 02       CMP  #$02
    $5A62: D0 18       BNE  L_5A7C
    $5A64: 20 C4 44    JSR  $44C4
    $5A67: A6 12       LDX  $12
    $5A69: A9 00       LDA  #$00
    $5A6B: 9D 54 5D    STA  $5D54,X
    $5A6E: 20 7A 43    JSR  $437A
    $5A71: 20 4F 5B    JSR  $5B4F
    $5A74: A9 05       LDA  #$05
    $5A76: 20 E0 4A    JSR  $4AE0
    $5A79: 4C 56 5A    JMP  $5A56

L_5A7C:
    $5A7C: C9 03       CMP  #$03
    $5A7E: D0 1A       BNE  L_5A9A
    $5A80: 8E D6 57    STX  $57D6
    $5A83: 20 C4 44    JSR  $44C4
    $5A86: AE D6 57    LDX  $57D6
    $5A89: A9 00       LDA  #$00
    $5A8B: 9D 54 5D    STA  $5D54,X
    $5A8E: 20 7A 43    JSR  $437A
    $5A91: 20 4F 5B    JSR  $5B4F
    $5A94: 20 65 4B    JSR  $4B65
    $5A97: 4C 56 5A    JMP  $5A56

L_5A9A:
    $5A9A: A2 03       LDX  #$03
    $5A9C: 86 12       STX  $12

L_5A9E:
    $5A9E: A6 12       LDX  $12
    $5AA0: BD 54 5D    LDA  $5D54,X
    $5AA3: F0 03       BEQ  L_5AA8
    $5AA5: 20 C4 44    JSR  $44C4

L_5AA8:
    $5AA8: C6 12       DEC  $12
    $5AAA: 10 F2       BPL  L_5A9E
    $5AAC: A6 11       LDX  $11
    $5AAE: BD 34 5D    LDA  $5D34,X
    $5AB1: 85 02       STA  $02
    $5AB3: BD 38 5D    LDA  $5D38,X
    $5AB6: 85 04       STA  $04
    $5AB8: 8A          TXA  
    $5AB9: 18          CLC  
    $5ABA: 69 0B       ADC  #$0B
    $5ABC: 20 C0 40    JSR  $40C0
    $5ABF: A9 56       LDA  #$56
    $5AC1: 85 04       STA  $04
    $5AC3: A9 17       LDA  #$17
    $5AC5: 85 02       STA  $02
    $5AC7: A9 18       LDA  #$18
    $5AC9: 20 C0 40    JSR  $40C0
    $5ACC: A2 03       LDX  #$03
    $5ACE: 86 12       STX  $12

L_5AD0:
    $5AD0: A6 12       LDX  $12
    $5AD2: BD 58 5D    LDA  $5D58,X
    $5AD5: F0 03       BEQ  L_5ADA
    $5AD7: 20 41 44    JSR  $4441

L_5ADA:
    $5ADA: C6 12       DEC  $12
    $5ADC: 10 F2       BPL  L_5AD0
    $5ADE: A2 03       LDX  #$03
    $5AE0: 86 12       STX  $12

L_5AE2:
    $5AE2: A9 D0       LDA  #$D0
    $5AE4: 85 2C       STA  $2C
    $5AE6: 85 2D       STA  $2D

L_5AE8:
    $5AE8: A9 56       LDA  #$56
    $5AEA: 85 04       STA  $04
    $5AEC: A9 17       LDA  #$17
    $5AEE: 85 02       STA  $02
    $5AF0: A5 12       LDA  $12
    $5AF2: 29 03       AND  #$03
    $5AF4: 18          CLC  
    $5AF5: 69 26       ADC  #$26
    $5AF7: 20 16 04    JSR  $0416
    $5AFA: 20 1C 5C    JSR  $5C1C
    $5AFD: A0 80       LDY  #$80
    $5AFF: A9 F2       LDA  #$F2
    $5B01: 8D 67 5B    STA  $5B67
    $5B04: 20 62 5B    JSR  $5B62
    $5B07: C6 2C       DEC  $2C
    $5B09: 10 DD       BPL  L_5AE8
    $5B0B: C6 2D       DEC  $2D
    $5B0D: 10 D9       BPL  L_5AE8
    $5B0F: C6 12       DEC  $12
    $5B11: 10 CF       BPL  L_5AE2
    $5B13: A5 10       LDA  $10
    $5B15: D0 1D       BNE  L_5B34
    $5B17: A9 56       LDA  #$56
    $5B19: 85 04       STA  $04
    $5B1B: A9 17       LDA  #$17
    $5B1D: 85 02       STA  $02
    $5B1F: A9 26       LDA  #$26
    $5B21: 20 C0 40    JSR  $40C0
    $5B24: A9 56       LDA  #$56
    $5B26: 85 04       STA  $04
    $5B28: A9 17       LDA  #$17
    $5B2A: 85 02       STA  $02
    $5B2C: A9 90       LDA  #$90
    $5B2E: 20 16 04    JSR  $0416
    $5B31: 4C 39 58    JMP  $5839

L_5B34:
    $5B34: A9 00       LDA  #$00
    $5B36: 85 2C       STA  $2C
    $5B38: A9 19       LDA  #$19
    $5B3A: 85 2D       STA  $2D

L_5B3C:
    $5B3C: A9 0A       LDA  #$0A
    $5B3E: 20 6C 5C    JSR  $5C6C
    $5B41: 20 1C 5C    JSR  $5C1C
    $5B44: C6 2C       DEC  $2C
    $5B46: D0 F4       BNE  L_5B3C
    $5B48: C6 2D       DEC  $2D
    $5B4A: D0 F0       BNE  L_5B3C
    $5B4C: 4C 39 58    JMP  $5839

L_5B4F:
    $5B4F: A6 11       LDX  $11
    $5B51: BD 34 5D    LDA  $5D34,X
    $5B54: 85 02       STA  $02
    $5B56: BD 38 5D    LDA  $5D38,X
    $5B59: 85 04       STA  $04
    $5B5B: 8A          TXA  
    $5B5C: 18          CLC  
    $5B5D: 69 0B       ADC  #$0B
    $5B5F: 4C 62 04    JMP  $0462

L_5B62:
    $5B62: 98          TYA  
    $5B63: 20 6F 5B    JSR  $5B6F
    $5B66: 49 FF       EOR  #$FF
    $5B68: 20 6F 5B    JSR  $5B6F
    $5B6B: 88          DEY  
    $5B6C: D0 F4       BNE  SUB_5B62
    $5B6E: 60          RTS  

SUB_5B6F:
    $5B6F: AA          TAX  

L_5B70:
    $5B70: CA          DEX  
    $5B71: D0 FD       BNE  L_5B70
    $5B73: 2C 30 C0    BIT  $C030  ; SPKR
    $5B76: 60          RTS  

SUB_5B77:
    $5B77: A2 1F       LDX  #$1F

L_5B79:
    $5B79: 20 03 04    JSR  $0403
    $5B7C: 29 1F       AND  #$1F

L_5B7E:
    $5B7E: 18          CLC  
    $5B7F: 69 01       ADC  #$01
    $5B81: 29 1F       AND  #$1F
    $5B83: F0 F4       BEQ  L_5B79
    $5B85: 18          CLC  
    $5B86: 69 08       ADC  #$08
    $5B88: 9D B4 5B    STA  $5BB4,X

L_5B8B:
    $5B8B: 20 03 04    JSR  $0403
    $5B8E: C9 C0       CMP  #$C0
    $5B90: B0 F9       BCS  L_5B8B
    $5B92: 9D D4 5B    STA  $5BD4,X
    $5B95: C9 50       CMP  #$50
    $5B97: 90 0F       BCC  L_5BA8
    $5B99: C9 71       CMP  #$71
    $5B9B: B0 0B       BCS  L_5BA8
    $5B9D: BD B4 5B    LDA  $5BB4,X
    $5BA0: C9 1B       CMP  #$1B
    $5BA2: B0 04       BCS  L_5BA8
    $5BA4: C9 16       CMP  #$16
    $5BA6: B0 D1       BCS  L_5B79

L_5BA8:
    $5BA8: 20 03 04    JSR  $0403

L_5BAB:
    $5BAB: 29 07       AND  #$07
    $5BAD: 9D F4 5B    STA  $5BF4,X
    $5BB0: CA          DEX  
    $5BB1: 10 C6       BPL  L_5B79
    $5BB3: 60          RTS  

L_5BB4:
    $5BB4: AE B8 A0    LDX  $A0B8
    $5BB7: 92          .BYTE $92
    $5BB8: A0 C5       LDY  #$C5
    $5BBA: C3          .BYTE $C3
    $5BBB: A0 CA       LDY  #$CA
    $5BBD: A4 A5       LDY  $A5
    $5BBF: C4 B1       CPY  $B1
    $5BC1: FF          .BYTE $FF
    $5BC2: A0 92       LDY  #$92
    $5BC4: A0 FB       LDY  #$FB
    $5BC6: CD 90 A0    CMP  $A090
    $5BC9: A0 E0       LDY  #$E0
    $5BCB: A0 BD       LDY  #$BD
    $5BCD: C9 E0       CMP  #$E0
    $5BCF: D3          .BYTE $D3
    $5BD0: A0 85       LDY  #$85
    $5BD2: A0 A4       LDY  #$A4
    $5BD4: A0 85       LDY  #$85
    $5BD6: A0 A4       LDY  #$A4
    $5BD8: A0 A0       LDY  #$A0
    $5BDA: C6 A0       DEC  $A0
    $5BDC: D0 A0       BNE  L_5B7E
    $5BDE: 85 A0       STA  $A0
    $5BE0: 90 C9       BCC  L_5BAB
    $5BE2: A0 A5       LDY  #$A5
    $5BE4: AC 92 A0    LDY  $A092
    $5BE7: A0 A0       LDY  #$A0
    $5BE9: A0 A0       LDY  #$A0
    $5BEB: A0 A5       LDY  #$A5
    $5BED: CF          .BYTE $CF
    $5BEE: D6 A0       DEC  $A0,X
    $5BF0: A0 A0       LDY  #$A0
    $5BF2: AE 83 AA    LDX  $AA83
    $5BF5: BA          TSX  
    $5BF6: A0 A0       LDY  #$A0
    $5BF8: A0 A5       LDY  #$A5
    $5BFA: AE A0 C3    LDX  $C3A0
    $5BFD: AF          .BYTE $AF
    $5BFE: AC A0 CF    LDY  $CFA0
    $5C01: A0 89       LDY  #$89
    $5C03: A0 99       LDY  #$99
    $5C05: A0 A0       LDY  #$A0
    $5C07: AE C3 8A    LDX  $8AC3
    $5C0A: A0 D0       LDY  #$D0
    $5C0C: A0 F4       LDY  #$F4
    $5C0E: 80          .BYTE $80
    $5C0F: A0 A5       LDY  #$A5
    $5C11: A0 D6       LDY  #$D6
    $5C13: A0 00       LDY  #$00
    $5C15: 08          PHP  
    $5C16: 10 18       BPL  L_5C30
    $5C18: 00          BRK  
    $5C19: 88          DEY  
    $5C1A: 90 98       BCC  L_5BB4

SUB_5C1C:
    $5C1C: A5 34       LDA  $34
    $5C1E: 18          CLC  
    $5C1F: 69 01       ADC  #$01
    $5C21: 85 34       STA  $34
    $5C23: C9 28       CMP  #$28
    $5C25: B0 01       BCS  SUB_5C28
    $5C27: 60          RTS  

L_5C28:
    $5C28: A9 00       LDA  #$00
    $5C2A: 85 34       STA  $34
    $5C2C: A6 33       LDX  $33
    $5C2E: E8          INX  
    $5C2F: E0 20       CPX  #$20
    $5C31: 90 02       BCC  L_5C35
    $5C33: A2 00       LDX  #$00

L_5C35:
    $5C35: 86 33       STX  $33
    $5C37: BD D4 5B    LDA  $5BD4,X
    $5C3A: A8          TAY  
    $5C3B: B9 6C 41    LDA  $416C,Y
    $5C3E: 85 06       STA  $06
    $5C40: B9 2C 42    LDA  $422C,Y
    $5C43: 85 07       STA  $07
    $5C45: BD F4 5B    LDA  $5BF4,X
    $5C48: A8          TAY  
    $5C49: 18          CLC  
    $5C4A: 69 01       ADC  #$01
    $5C4C: 29 07       AND  #$07
    $5C4E: 9D F4 5B    STA  $5BF4,X
    $5C51: B9 14 5C    LDA  $5C14,Y
    $5C54: 48          PHA  
    $5C55: BD B4 5B    LDA  $5BB4,X
    $5C58: A8          TAY  
    $5C59: 68          PLA  
    $5C5A: 49 FF       EOR  #$FF
    $5C5C: 31 06       AND  ($06),Y
    $5C5E: 91 06       STA  ($06),Y
    $5C60: BD F4 5B    LDA  $5BF4,X
    $5C63: AA          TAX  
    $5C64: BD 14 5C    LDA  $5C14,X
    $5C67: 11 06       ORA  ($06),Y
    $5C69: 91 06       STA  ($06),Y
    $5C6B: 60          RTS  

SUB_5C6C:
    $5C6C: 38          SEC  

L_5C6D:
    $5C6D: 48          PHA  

L_5C6E:
    $5C6E: E9 01       SBC  #$01
    $5C70: D0 FC       BNE  L_5C6E
    $5C72: 68          PLA  
    $5C73: E9 01       SBC  #$01
    $5C75: D0 F6       BNE  L_5C6D
    $5C77: 60          RTS  

SUB_5C78:
    $5C78: A2 0F       LDX  #$0F

L_5C7A:
    $5C7A: BD B8 53    LDA  $53B8,X
    $5C7D: C9 04       CMP  #$04
    $5C7F: F0 01       BEQ  L_5C82
    $5C81: 60          RTS  

L_5C82:
    $5C82: CA          DEX  
    $5C83: 10 F5       BPL  L_5C7A
    $5C85: 20 27 5D    JSR  $5D27
    $5C88: 20 14 5D    JSR  $5D14
    $5C8B: A9 03       LDA  #$03
    $5C8D: 8D 13 5D    STA  $5D13

L_5C90:
    $5C90: AE 13 5D    LDX  $5D13
    $5C93: BD 54 5D    LDA  $5D54,X
    $5C96: F0 0B       BEQ  L_5CA3
    $5C98: 20 C4 44    JSR  $44C4
    $5C9B: AE 13 5D    LDX  $5D13
    $5C9E: A9 00       LDA  #$00
    $5CA0: 9D 54 5D    STA  $5D54,X

L_5CA3:
    $5CA3: BD 12 52    LDA  $5212,X
    $5CA6: F0 0B       BEQ  L_5CB3
    $5CA8: 20 C9 52    JSR  $52C9
    $5CAB: AE 13 5D    LDX  $5D13
    $5CAE: A9 00       LDA  #$00
    $5CB0: 9D 12 52    STA  $5212,X

L_5CB3:
    $5CB3: CE 13 5D    DEC  $5D13
    $5CB6: 10 D8       BPL  L_5C90

; ============================================================================
; LEVEL COMPLETE! All 16 aliens are TVs (type 4)
; Award bonus, advance level, play animation (with cheat check!)
; ============================================================================
    $5CB8: A9 50       LDA  #$50   ; 50 points level completion bonus
    $5CBA: 20 E0 4A    JSR  SUB_4AE0 ; Add to score
    $5CBD: C6 3A       DEC  $3A    ; Advance level (5→4→3→2→1→0)
    $5CBF: 20 33 4D    JSR  $4D33  ; Display level number
    $5CC2: 20 99 4C    JSR  SUB_4C99 ; Level completion animation (CHEAT CHECK HERE!)
    $5CC5: A9 32       LDA  #$32
    $5CC7: A0 FF       LDY  #$FF
    $5CC9: 8D 67 5B    STA  $5B67
    $5CCC: 20 62 5B    JSR  $5B62  ; More animation/sound
    $5CCF: A9 03       LDA  #$03
    $5CD1: 8D 13 5D    STA  $5D13

L_5CD4:
    $5CD4: AD 13 5D    LDA  $5D13
    $5CD7: 20 3C 4C    JSR  $4C3C  ; Sound effect
    $5CDA: CE 13 5D    DEC  $5D13
    $5CDD: 10 F5       BPL  L_5CD4

    ; Reset all 16 aliens to type 1 (UFO) for next level
    $5CDF: A2 0F       LDX  #$0F   ; 16 aliens (index 0-15)
    $5CE1: A9 01       LDA  #$01   ; Type 1 = UFO

L_5CE3:
    $5CE3: 9D B8 53    STA  $53B8,X ; Reset alien type
    $5CE6: CA          DEX
    $5CE7: 10 FA       BPL  L_5CE3

    $5CE9: A5 3A       LDA  $3A    ; Check level counter
    $5CEB: F0 1C       BEQ  L_5D09 ; If 0, VICTORY!
    $5CED: 20 3E 41    JSR  $413E
    $5CF0: 20 7A 43    JSR  $437A
    $5CF3: 20 4F 5B    JSR  $5B4F
    $5CF6: A5 3A       LDA  $3A
    $5CF8: C9 04       CMP  #$04
    $5CFA: B0 0C       BCS  L_5D08
    $5CFC: 20 27 52    JSR  $5227
    $5CFF: 20 27 52    JSR  $5227
    $5D02: 20 27 52    JSR  $5227
    $5D05: 20 27 52    JSR  $5227

L_5D08:
    $5D08: 60          RTS  

L_5D09:
    $5D09: A9 00       LDA  #$00
    $5D0B: 85 10       STA  $10
    $5D0D: 68          PLA  
    $5D0E: 68          PLA  
    $5D0F: 4C 39 58    JMP  $5839

L_5D12:
    $5D12: 60          RTS  
    $5D13: 00          BRK  

SUB_5D14:
    $5D14: A6 11       LDX  $11
    $5D16: BD 34 5D    LDA  $5D34,X
    $5D19: 85 02       STA  $02
    $5D1B: BD 38 5D    LDA  $5D38,X
    $5D1E: 85 04       STA  $04
    $5D20: 8A          TXA  
    $5D21: 18          CLC  
    $5D22: 69 0B       ADC  #$0B
    $5D24: 4C C0 40    JMP  $40C0

SUB_5D27:
    $5D27: A9 56       LDA  #$56
    $5D29: 85 04       STA  $04
    $5D2B: A9 17       LDA  #$17
    $5D2D: 85 02       STA  $02
    $5D2F: A9 18       LDA  #$18
    $5D31: 4C C0 40    JMP  $40C0
    $5D34: 18          CLC  
    $5D35: 1A          .BYTE $1A
    $5D36: 18          CLC  
    $5D37: 16 52       ASL  $52,X
    $5D39: 5D 6B 5D    EOR  $5D6B,X
    $5D3C: 17          .BYTE $17
    $5D3D: 25 17       AND  $17
    $5D3F: 09 01       ORA  #$01
    $5D41: 56 B1       LSR  $B1,X
    $5D43: 56 01       LSR  $01,X
    $5D45: 58          CLI  
    $5D46: B1 58       LDA  ($58),Y
    $5D48: A0 8C       LDY  #$8C
    $5D4A: BA          TSX  
    $5D4B: A0 A0       LDY  #$A0
    $5D4D: E6 D2       INC  $D2
    $5D4F: A0 A0       LDY  #$A0
    $5D51: A0 C8       LDY  #$C8
    $5D53: A0 A0       LDY  #$A0
    $5D55: C8          INY  
    $5D56: A0 80       LDY  #$80
    $5D58: D4          .BYTE $D4
    $5D59: AC BA A0    LDY  $A0BA
    $5D5C: A0 BB       LDY  #$BB
    $5D5E: A0 AC       LDY  #$AC
    $5D60: A0 A0       LDY  #$A0
    $5D62: D0 AE       BNE  L_5D12
    $5D64: E6 AF       INC  $AF
    $5D66: 8C B0 AB    STY  $ABB0
    $5D69: BC AB 9A    LDY  $9AAB,X
    $5D6C: 00          BRK  
    $5D6D: 00          BRK  
    $5D6E: 00          BRK  
    $5D6F: 00          BRK  
    $5D70: 51 60       EOR  ($60),Y
    $5D72: 6C 60 A9    JMP  ($A960)
    $5D75: A0 C6       LDY  #$C6
    $5D77: A0 C3       LDY  #$C3
    $5D79: A0 81       LDY  #$81
    $5D7B: D4          .BYTE $D4

; ============================================================================
; SHAPE TABLE POINTERS - Used for sprite drawing
; Each sprite index looks up: low ptr at $5D7C+idx, high ptr at $5E1D+idx
; Width at $5EBE+idx, Height at $5F5F+idx
; Pre-shifted sprites: 7 copies per sprite for fast drawing at any X position
; ============================================================================
TBL_SHAPE_PTR_LO:
    $5D7C: 00          ; Sprite 0 low byte
    $5D7D: 07          ; Sprite 1 low byte (increments by 7 for each shift)
    $5D7E: 0E 15 1C    ; Sprites 2-4...
    $5D81: 23          .BYTE $23
    $5D82: 2A          ROL  
    $5D83: 31 38       AND  ($38),Y
    $5D85: 3F          .BYTE $3F
    $5D86: 46 70       LSR  $70
    $5D88: 74          .BYTE $74
    $5D89: 7B          .BYTE $7B
    $5D8A: 7F          .BYTE $7F
    $5D8B: 86 B7       STX  $B7
    $5D8D: DA          .BYTE $DA
    $5D8E: E8          INX  
    $5D8F: 0B          .BYTE $0B
    $5D90: 35 43       AND  $43,X
    $5D92: 66 97       ROR  $97
    $5D94: C8          INY  
    $5D95: 07          .BYTE $07
    $5D96: 2A          ROL  
    $5D97: 54          .BYTE $54
    $5D98: 87          .BYTE $87
    $5D99: B1 C6       LDA  ($C6),Y
    $5D9B: CB          .BYTE $CB
    $5D9C: D0 D5       BNE  L_5D73
    $5D9E: DF          .BYTE $DF
    $5D9F: E9 F3       SBC  #$F3
    $5DA1: FD BA 7B    SBC  $7BBA,X
    $5DA4: 38          SEC  
    $5DA5: F9 77 A4    SBC  $A477,Y
    $5DA8: E3          .BYTE $E3
    $5DA9: 10 4F       BPL  L_5DFA
    $5DAB: 56 64       LSR  $64,X
    $5DAD: 72          .BYTE $72
    $5DAE: 80          .BYTE $80
    $5DAF: 8E 9C AA    STX  $AA9C
    $5DB2: BF          .BYTE $BF
    $5DB3: D4          .BYTE $D4
    $5DB4: E9 FE       SBC  #$FE
    $5DB6: 13          .BYTE $13
    $5DB7: 28          PLP  
    $5DB8: 3D 43 4F    AND  $4F43,X
    $5DBB: 5B          .BYTE $5B
    $5DBC: 67          .BYTE $67
    $5DBD: 73          .BYTE $73
    $5DBE: 7F          .BYTE $7F
    $5DBF: 8B          .BYTE $8B
    $5DC0: 92          .BYTE $92
    $5DC1: A0 AE       LDY  #$AE
    $5DC3: BC CA D8    LDY  $D8CA,X
    $5DC6: E6 F4       INC  $F4
    $5DC8: 02          .BYTE $02
    $5DC9: 10 1E       BPL  L_5DE9
    $5DCB: 2C 3A 48    BIT  $483A
    $5DCE: 4F          .BYTE $4F
    $5DCF: 5D 6B 79    EOR  $796B,X
    $5DD2: 87          .BYTE $87
    $5DD3: 95 A3       STA  $A3,X
    $5DD5: AA          TAX  
    $5DD6: B8          CLV  
    $5DD7: C6 D4       DEC  $D4
    $5DD9: E2          .BYTE $E2
    $5DDA: F0 59       BEQ  L_5E35
    $5DDC: 6E 83 FE    ROR  $FE83
    $5DDF: 1A          .BYTE $1A
    $5DE0: 2F          .BYTE $2F
    $5DE1: 44          .BYTE $44
    $5DE2: 98          TYA  
    $5DE3: AA          TAX  
    $5DE4: BC CE E9    LDY  $E9CE,X
    $5DE7: FB          .BYTE $FB
    $5DE8: 0D 1F 2D    ORA  $2D1F
    $5DEB: 42          .BYTE $42
    $5DEC: 57          .BYTE $57
    $5DED: 6C 81 96    JMP  ($9681)
    $5DF0: AB          .BYTE $AB
    $5DF1: B9 CE E3    LDA  $E3CE,Y
    $5DF4: F8          SED  
    $5DF5: 06 1B       ASL  $1B
    $5DF7: 30 3E       BMI  L_5E37
    $5DF9: 53          .BYTE $53

L_5DFA:
    $5DFA: 68          PLA  
    $5DFB: 7D 92 A7    ADC  $A792,X
    $5DFE: BC C2 CE    LDY  $CEC2,X
    $5E01: DA          .BYTE $DA
    $5E02: E6 F2       INC  $F2
    $5E04: FE 0A 10    INC  $100A,X
    $5E07: 1C          .BYTE $1C
    $5E08: 28          PLP  
    $5E09: 34          .BYTE $34
    $5E0A: 40          RTI  
    $5E0B: 4C 58 18    JMP  $1858
    $5E0E: B8          CLV  
    $5E0F: 78          SEI  
    $5E10: F0 50       BEQ  L_5E62
    $5E12: B0 10       BCS  L_5E24
    $5E14: 33          .BYTE $33
    $5E15: B1 C5       LDA  ($C5),Y
    $5E17: 0D 55 B5    ORA  $B555
    $5E1A: 15 5D       ORA  $5D,X
    $5E1C: BD 60 60    LDA  $6060,X
    $5E1F: 60          RTS  
    $5E20: 60          RTS  
    $5E21: 60          RTS  
    $5E22: 60          RTS  
    $5E23: 60          RTS  

L_5E24:
    $5E24: 60          RTS  
    $5E25: 60          RTS  
    $5E26: 60          RTS  
    $5E27: 60          RTS  
    $5E28: 60          RTS  
    $5E29: 60          RTS  
    $5E2A: 60          RTS  
    $5E2B: 60          RTS  
    $5E2C: 60          RTS  
    $5E2D: 60          RTS  
    $5E2E: 60          RTS  
    $5E2F: 60          RTS  
    $5E30: 61 61       ADC  ($61,X)
    $5E32: 61 61       ADC  ($61,X)
    $5E34: 61 61       ADC  ($61,X)
    $5E36: 62          .BYTE $62

L_5E37:
    $5E37: 62          .BYTE $62
    $5E38: 62          .BYTE $62
    $5E39: 62          .BYTE $62
    $5E3A: 62          .BYTE $62
    $5E3B: 62          .BYTE $62
    $5E3C: 62          .BYTE $62
    $5E3D: 62          .BYTE $62
    $5E3E: 62          .BYTE $62
    $5E3F: 62          .BYTE $62
    $5E40: 62          .BYTE $62
    $5E41: 62          .BYTE $62
    $5E42: 62          .BYTE $62
    $5E43: 63          .BYTE $63
    $5E44: 63          .BYTE $63
    $5E45: 64          .BYTE $64
    $5E46: 63          .BYTE $63
    $5E47: 64          .BYTE $64
    $5E48: 64          .BYTE $64
    $5E49: 64          .BYTE $64
    $5E4A: 65 65       ADC  $65
    $5E4C: 65 65       ADC  $65
    $5E4E: 65 65       ADC  $65
    $5E50: 65 65       ADC  $65
    $5E52: 65 65       ADC  $65
    $5E54: 65 65       ADC  $65
    $5E56: 65 66       ADC  $66
    $5E58: 66 66       ROR  $66
    $5E5A: 66 66       ROR  $66
    $5E5C: 66 66       ROR  $66
    $5E5E: 66 66       ROR  $66
    $5E60: 66 66       ROR  $66

L_5E62:
    $5E62: 66 66       ROR  $66
    $5E64: 66 66       ROR  $66
    $5E66: 66 66       ROR  $66
    $5E68: 66 67       ROR  $67
    $5E6A: 67          .BYTE $67
    $5E6B: 67          .BYTE $67
    $5E6C: 67          .BYTE $67
    $5E6D: 67          .BYTE $67
    $5E6E: 67          .BYTE $67
    $5E6F: 67          .BYTE $67
    $5E70: 67          .BYTE $67
    $5E71: 67          .BYTE $67
    $5E72: 67          .BYTE $67
    $5E73: 67          .BYTE $67
    $5E74: 67          .BYTE $67
    $5E75: 67          .BYTE $67
    $5E76: 67          .BYTE $67
    $5E77: 67          .BYTE $67
    $5E78: 67          .BYTE $67
    $5E79: 67          .BYTE $67
    $5E7A: 67          .BYTE $67
    $5E7B: 67          .BYTE $67
    $5E7C: 68          PLA  
    $5E7D: 68          PLA  
    $5E7E: 68          PLA  
    $5E7F: 67          .BYTE $67
    $5E80: 68          PLA  
    $5E81: 68          PLA  
    $5E82: 68          PLA  
    $5E83: 68          PLA  
    $5E84: 68          PLA  
    $5E85: 68          PLA  
    $5E86: 68          PLA  
    $5E87: 68          PLA  
    $5E88: 68          PLA  
    $5E89: 69 69       ADC  #$69
    $5E8B: 69 69       ADC  #$69
    $5E8D: 69 69       ADC  #$69
    $5E8F: 69 69       ADC  #$69
    $5E91: 69 69       ADC  #$69
    $5E93: 69 69       ADC  #$69
    $5E95: 69 6A       ADC  #$6A
    $5E97: 6A          ROR  
    $5E98: 6A          ROR  
    $5E99: 6A          ROR  
    $5E9A: 6A          ROR  
    $5E9B: 6A          ROR  
    $5E9C: 6A          ROR  
    $5E9D: 6A          ROR  
    $5E9E: 6A          ROR  
    $5E9F: 6A          ROR  
    $5EA0: 6A          ROR  
    $5EA1: 6A          ROR  
    $5EA2: 6A          ROR  
    $5EA3: 6A          ROR  
    $5EA4: 6A          ROR  
    $5EA5: 6A          ROR  
    $5EA6: 6B          .BYTE $6B
    $5EA7: 6B          .BYTE $6B
    $5EA8: 6B          .BYTE $6B
    $5EA9: 6B          .BYTE $6B
    $5EAA: 6B          .BYTE $6B
    $5EAB: 6B          .BYTE $6B
    $5EAC: 6B          .BYTE $6B
    $5EAD: 6B          .BYTE $6B
    $5EAE: 6C 6B 6C    JMP  ($6C6B)
    $5EB1: 6C 6D 6D    JMP  ($6D6D)
    $5EB4: 6E 6E 6E    ROR  $6E6E
    $5EB7: 6E 6F 6F    ROR  $6F6F
    $5EBA: 6F          .BYTE $6F
    $5EBB: 70 70       BVS  L_5F2D
    $5EBD: 70 01       BVS  L_5EC0
    $5EBF: 01 01       ORA  ($01,X)
    $5EC1: 01 01       ORA  ($01,X)
    $5EC3: 01 01       ORA  ($01,X)
    $5EC5: 01 01       ORA  ($01,X)
    $5EC7: 01 06       ORA  ($06,X)
    $5EC9: 01 01       ORA  ($01,X)
    $5ECB: 01 01       ORA  ($01,X)
    $5ECD: 07          .BYTE $07
    $5ECE: 05 02       ORA  $02
    $5ED0: 05 06       ORA  $06
    $5ED2: 02          .BYTE $02
    $5ED3: 05 07       ORA  $07
    $5ED5: 07          .BYTE $07
    $5ED6: 03          .BYTE $03
    $5ED7: 05 03       ORA  $03
    $5ED9: 03          .BYTE $03
    $5EDA: 03          .BYTE $03
    $5EDB: 03          .BYTE $03
    $5EDC: 01 01       ORA  ($01,X)
    $5EDE: 01 02       ORA  ($02,X)
    $5EE0: 02          .BYTE $02
    $5EE1: 02          .BYTE $02
    $5EE2: 02          .BYTE $02
    $5EE3: 09 03       ORA  #$03
    $5EE5: 03          .BYTE $03
    $5EE6: 03          .BYTE $03
    $5EE7: 03          .BYTE $03
    $5EE8: 03          .BYTE $03
    $5EE9: 03          .BYTE $03
    $5EEA: 03          .BYTE $03
    $5EEB: 03          .BYTE $03
    $5EEC: 01 02       ORA  ($02,X)
    $5EEE: 02          .BYTE $02
    $5EEF: 02          .BYTE $02
    $5EF0: 02          .BYTE $02
    $5EF1: 02          .BYTE $02
    $5EF2: 02          .BYTE $02
    $5EF3: 03          .BYTE $03
    $5EF4: 03          .BYTE $03
    $5EF5: 03          .BYTE $03
    $5EF6: 03          .BYTE $03
    $5EF7: 03          .BYTE $03
    $5EF8: 03          .BYTE $03
    $5EF9: 03          .BYTE $03
    $5EFA: 01 02       ORA  ($02,X)
    $5EFC: 02          .BYTE $02
    $5EFD: 02          .BYTE $02
    $5EFE: 02          .BYTE $02
    $5EFF: 02          .BYTE $02
    $5F00: 02          .BYTE $02
    $5F01: 01 02       ORA  ($02,X)
    $5F03: 02          .BYTE $02
    $5F04: 02          .BYTE $02
    $5F05: 02          .BYTE $02
    $5F06: 02          .BYTE $02
    $5F07: 02          .BYTE $02
    $5F08: 02          .BYTE $02
    $5F09: 02          .BYTE $02
    $5F0A: 02          .BYTE $02
    $5F0B: 02          .BYTE $02
    $5F0C: 02          .BYTE $02
    $5F0D: 02          .BYTE $02
    $5F0E: 02          .BYTE $02
    $5F0F: 01 02       ORA  ($02,X)
    $5F11: 02          .BYTE $02
    $5F12: 02          .BYTE $02
    $5F13: 02          .BYTE $02
    $5F14: 02          .BYTE $02
    $5F15: 02          .BYTE $02
    $5F16: 01 02       ORA  ($02,X)
    $5F18: 02          .BYTE $02
    $5F19: 02          .BYTE $02
    $5F1A: 02          .BYTE $02
    $5F1B: 02          .BYTE $02
    $5F1C: 02          .BYTE $02
    $5F1D: 03          .BYTE $03
    $5F1E: 03          .BYTE $03
    $5F1F: 03          .BYTE $03
    $5F20: 04          .BYTE $04
    $5F21: 03          .BYTE $03
    $5F22: 03          .BYTE $03
    $5F23: 03          .BYTE $03
    $5F24: 02          .BYTE $02
    $5F25: 02          .BYTE $02
    $5F26: 02          .BYTE $02
    $5F27: 03          .BYTE $03
    $5F28: 02          .BYTE $02
    $5F29: 02          .BYTE $02
    $5F2A: 02          .BYTE $02
    $5F2B: 02          .BYTE $02
    $5F2C: 03          .BYTE $03

L_5F2D:
    $5F2D: 03          .BYTE $03
    $5F2E: 03          .BYTE $03
    $5F2F: 03          .BYTE $03
    $5F30: 03          .BYTE $03
    $5F31: 03          .BYTE $03
    $5F32: 02          .BYTE $02
    $5F33: 03          .BYTE $03
    $5F34: 03          .BYTE $03
    $5F35: 03          .BYTE $03
    $5F36: 02          .BYTE $02
    $5F37: 03          .BYTE $03
    $5F38: 03          .BYTE $03
    $5F39: 02          .BYTE $02
    $5F3A: 03          .BYTE $03
    $5F3B: 03          .BYTE $03
    $5F3C: 03          .BYTE $03
    $5F3D: 03          .BYTE $03
    $5F3E: 03          .BYTE $03
    $5F3F: 03          .BYTE $03
    $5F40: 01 02       ORA  ($02,X)
    $5F42: 02          .BYTE $02
    $5F43: 02          .BYTE $02
    $5F44: 02          .BYTE $02
    $5F45: 02          .BYTE $02
    $5F46: 02          .BYTE $02
    $5F47: 01 02       ORA  ($02,X)
    $5F49: 02          .BYTE $02
    $5F4A: 02          .BYTE $02
    $5F4B: 02          .BYTE $02
    $5F4C: 02          .BYTE $02
    $5F4D: 02          .BYTE $02
    $5F4E: 04          .BYTE $04
    $5F4F: 04          .BYTE $04
    $5F50: 04          .BYTE $04
    $5F51: 05 04       ORA  $04
    $5F53: 04          .BYTE $04
    $5F54: 04          .BYTE $04
    $5F55: 05 09       ORA  $09
    $5F57: 02          .BYTE $02
    $5F58: 03          .BYTE $03
    $5F59: 03          .BYTE $03
    $5F5A: 04          .BYTE $04
    $5F5B: 04          .BYTE $04
    $5F5C: 03          .BYTE $03
    $5F5D: 04          .BYTE $04
    $5F5E: 04          .BYTE $04
    $5F5F: 07          .BYTE $07
    $5F60: 07          .BYTE $07
    $5F61: 07          .BYTE $07
    $5F62: 07          .BYTE $07
    $5F63: 07          .BYTE $07
    $5F64: 07          .BYTE $07
    $5F65: 07          .BYTE $07
    $5F66: 07          .BYTE $07
    $5F67: 07          .BYTE $07
    $5F68: 07          .BYTE $07
    $5F69: 07          .BYTE $07
    $5F6A: 04          .BYTE $04
    $5F6B: 07          .BYTE $07
    $5F6C: 04          .BYTE $04
    $5F6D: 07          .BYTE $07
    $5F6E: 07          .BYTE $07
    $5F6F: 07          .BYTE $07
    $5F70: 07          .BYTE $07
    $5F71: 07          .BYTE $07
    $5F72: 07          .BYTE $07
    $5F73: 07          .BYTE $07
    $5F74: 07          .BYTE $07
    $5F75: 07          .BYTE $07
    $5F76: 07          .BYTE $07
    $5F77: 15 07       ORA  $07,X
    $5F79: 0E 11 0E    ASL  $0E11
    $5F7C: 07          .BYTE $07
    $5F7D: 05 05       ORA  $05
    $5F7F: 05 05       ORA  $05
    $5F81: 05 05       ORA  $05
    $5F83: 05 0E       ORA  $0E
    $5F85: 15 15       ORA  $15,X
    $5F87: 15 15       ORA  $15,X
    $5F89: 0F          .BYTE $0F
    $5F8A: 15 0F       ORA  $0F,X
    $5F8C: 15 07       ORA  $07,X
    $5F8E: 07          .BYTE $07
    $5F8F: 07          .BYTE $07
    $5F90: 07          .BYTE $07
    $5F91: 07          .BYTE $07
    $5F92: 07          .BYTE $07
    $5F93: 07          .BYTE $07
    $5F94: 07          .BYTE $07
    $5F95: 07          .BYTE $07
    $5F96: 07          .BYTE $07
    $5F97: 07          .BYTE $07
    $5F98: 07          .BYTE $07
    $5F99: 07          .BYTE $07
    $5F9A: 07          .BYTE $07
    $5F9B: 06 06       ASL  $06
    $5F9D: 06 06       ASL  $06
    $5F9F: 06 06       ASL  $06
    $5FA1: 06 07       ASL  $07
    $5FA3: 07          .BYTE $07
    $5FA4: 07          .BYTE $07
    $5FA5: 07          .BYTE $07
    $5FA6: 07          .BYTE $07
    $5FA7: 07          .BYTE $07
    $5FA8: 07          .BYTE $07
    $5FA9: 07          .BYTE $07
    $5FAA: 07          .BYTE $07
    $5FAB: 07          .BYTE $07
    $5FAC: 07          .BYTE $07
    $5FAD: 07          .BYTE $07
    $5FAE: 07          .BYTE $07
    $5FAF: 07          .BYTE $07
    $5FB0: 07          .BYTE $07
    $5FB1: 07          .BYTE $07
    $5FB2: 07          .BYTE $07
    $5FB3: 07          .BYTE $07
    $5FB4: 07          .BYTE $07
    $5FB5: 07          .BYTE $07
    $5FB6: 07          .BYTE $07
    $5FB7: 07          .BYTE $07
    $5FB8: 07          .BYTE $07
    $5FB9: 07          .BYTE $07
    $5FBA: 07          .BYTE $07
    $5FBB: 07          .BYTE $07
    $5FBC: 07          .BYTE $07
    $5FBD: 07          .BYTE $07
    $5FBE: 07          .BYTE $07
    $5FBF: 07          .BYTE $07
    $5FC0: 07          .BYTE $07
    $5FC1: 07          .BYTE $07
    $5FC2: 07          .BYTE $07
    $5FC3: 07          .BYTE $07
    $5FC4: 07          .BYTE $07
    $5FC5: 09 09       ORA  #$09
    $5FC7: 09 09       ORA  #$09
    $5FC9: 09 09       ORA  #$09
    $5FCB: 09 07       ORA  #$07
    $5FCD: 07          .BYTE $07
    $5FCE: 07          .BYTE $07
    $5FCF: 07          .BYTE $07
    $5FD0: 07          .BYTE $07
    $5FD1: 07          .BYTE $07
    $5FD2: 07          .BYTE $07
    $5FD3: 07          .BYTE $07
    $5FD4: 07          .BYTE $07
    $5FD5: 07          .BYTE $07
    $5FD6: 07          .BYTE $07
    $5FD7: 07          .BYTE $07
    $5FD8: 07          .BYTE $07
    $5FD9: 07          .BYTE $07
    $5FDA: 07          .BYTE $07
    $5FDB: 07          .BYTE $07
    $5FDC: 07          .BYTE $07
    $5FDD: 07          .BYTE $07
    $5FDE: 07          .BYTE $07
    $5FDF: 07          .BYTE $07
    $5FE0: 07          .BYTE $07
    $5FE1: 06 06       ASL  $06
    $5FE3: 06 06       ASL  $06
    $5FE5: 06 06       ASL  $06
    $5FE7: 06 06       ASL  $06
    $5FE9: 06 06       ASL  $06
    $5FEB: 06 06       ASL  $06
    $5FED: 06 06       ASL  $06
    $5FEF: 18          CLC  
    $5FF0: 18          CLC  
    $5FF1: 18          CLC  
    $5FF2: 18          CLC  
    $5FF3: 18          CLC  
    $5FF4: 18          CLC  
    $5FF5: 18          CLC  
    $5FF6: 07          .BYTE $07
    $5FF7: 0E 0A 18    ASL  $180A
    $5FFA: 18          CLC  
    $5FFB: 18          CLC  
    $5FFC: 18          CLC  
    $5FFD: 18          CLC  
    $5FFE: 18          CLC  
    $5FFF: 18          CLC  
    $6000: 1E 33 33    ASL  $3333,X
    $6003: 33          .BYTE $33
    $6004: 33          .BYTE $33
    $6005: 33          .BYTE $33
    $6006: 1E 3C 36    ASL  $363C,X
    $6009: 33          .BYTE $33
    $600A: 30 30       BMI  L_603C
    $600C: 30 30       BMI  L_603E
    $600E: 1E 3F 33    ASL  $333F,X
    $6011: 38          SEC  
    $6012: 0E 3F 3F    ASL  $3F3F
    $6015: 1E 3F 30    ASL  $303F,X
    $6018: 3E 30 3F    ROL  $3F30,X
    $601B: 1E 38 3C    ASL  $3C38,X
    $601E: 36 33       ROL  $33,X
    $6020: 3F          .BYTE $3F
    $6021: 30 30       BMI  L_6053
    $6023: 3F          .BYTE $3F
    $6024: 3F          .BYTE $3F
    $6025: 03          .BYTE $03
    $6026: 1F          .BYTE $1F
    $6027: 30 3F       BMI  L_6068
    $6029: 1E 1C 06    ASL  $061C,X
    $602C: 03          .BYTE $03
    $602D: 1F          .BYTE $1F
    $602E: 33          .BYTE $33
    $602F: 33          .BYTE $33
    $6030: 1E 3F 3F    ASL  $3F3F,X
    $6033: 30 18       BMI  L_604D
    $6035: 0C          .BYTE $0C
    $6036: 0C          .BYTE $0C
    $6037: 0C          .BYTE $0C
    $6038: 1E 3F 33    ASL  $333F,X
    $603B: 1E 33 3F    ASL  $3F33,X

L_603E:
    $603E: 1E 1E 3F    ASL  $3F1E,X
    $6041: 33          .BYTE $33
    $6042: 3E 30 3E    ROL  $3E30,X
    $6045: 1E 1E 1E    ASL  $1E1E,X
    $6048: 1E 1F 3F    ASL  $3F1F,X
    $604B: 00          BRK  
    $604C: 3F          .BYTE $3F

L_604D:
    $604D: 3F          .BYTE $3F
    $604E: 3F          .BYTE $3F
    $604F: 3F          .BYTE $3F
    $6050: 3F          .BYTE $3F
    $6051: 00          BRK  
    $6052: 03          .BYTE $03

L_6053:
    $6053: 33          .BYTE $33
    $6054: 33          .BYTE $33
    $6055: 33          .BYTE $33
    $6056: 03          .BYTE $03
    $6057: 00          BRK  
    $6058: 1E 03 33    ASL  $3303,X
    $605B: 3F          .BYTE $3F
    $605C: 1F          .BYTE $1F
    $605D: 00          BRK  
    $605E: 30 33       BMI  L_6093
    $6060: 33          .BYTE $33
    $6061: 1F          .BYTE $1F
    $6062: 03          .BYTE $03
    $6063: 00          BRK  
    $6064: 3F          .BYTE $3F

L_6065:
    $6065: 3F          .BYTE $3F
    $6066: 3F          .BYTE $3F
    $6067: 3B          .BYTE $3B

L_6068:
    $6068: 3F          .BYTE $3F
    $6069: 00          BRK  
    $606A: 1E 1E 1E    ASL  $1E1E,X
    $606D: 33          .BYTE $33
    $606E: 3F          .BYTE $3F
    $606F: 00          BRK  
    $6070: 88          DEY  
    $6071: 9C          .BYTE $9C
    $6072: BE FF 81    LDX  $81FF,Y
    $6075: 83          .BYTE $83
    $6076: 87          .BYTE $87
    $6077: 8F          .BYTE $8F
    $6078: 87          .BYTE $87
    $6079: 83          .BYTE $83
    $607A: 81 FF       STA  ($FF,X)
    $607C: BE 9C 88    LDX  $889C,Y
    $607F: C0 E0       CPY  #$E0
    $6081: F0 F8       BEQ  L_607B
    $6083: F0 E0       BEQ  L_6065
    $6085: C0 1E       CPY  #$1E
    $6087: 3F          .BYTE $3F
    $6088: 33          .BYTE $33
    $6089: 3F          .BYTE $3F
    $608A: 3F          .BYTE $3F
    $608B: 3F          .BYTE $3F
    $608C: 1E 3F 3F    ASL  $3F3F,X
    $608F: 33          .BYTE $33
    $6090: 3F          .BYTE $3F
    $6091: 3F          .BYTE $3F
    $6092: 3F          .BYTE $3F

L_6093:
    $6093: 3F          .BYTE $3F
    $6094: 03          .BYTE $03
    $6095: 03          .BYTE $03
    $6096: 37          .BYTE $37
    $6097: 03          .BYTE $03
    $6098: 0C          .BYTE $0C
    $6099: 0C          .BYTE $0C
    $609A: 33          .BYTE $33
    $609B: 3B          .BYTE $3B
    $609C: 1F          .BYTE $1F
    $609D: 3F          .BYTE $3F
    $609E: 1F          .BYTE $1F
    $609F: 0C          .BYTE $0C
    $60A0: 0C          .BYTE $0C
    $60A1: 03          .BYTE $03
    $60A2: 33          .BYTE $33
    $60A3: 03          .BYTE $03
    $60A4: 3B          .BYTE $3B
    $60A5: 03          .BYTE $03
    $60A6: 0C          .BYTE $0C
    $60A7: 0C          .BYTE $0C
    $60A8: 33          .BYTE $33
    $60A9: 3F          .BYTE $3F
    $60AA: 3F          .BYTE $3F
    $60AB: 33          .BYTE $33
    $60AC: 3F          .BYTE $3F
    $60AD: 0C          .BYTE $0C
    $60AE: 3F          .BYTE $3F
    $60AF: 3F          .BYTE $3F
    $60B0: 1E 3F 33    ASL  $333F,X
    $60B3: 3F          .BYTE $3F
    $60B4: 0C          .BYTE $0C
    $60B5: 3F          .BYTE $3F
    $60B6: 1E 1F 1F    ASL  $1F1F,X
    $60B9: 3F          .BYTE $3F
    $60BA: 3F          .BYTE $3F
    $60BB: 3F          .BYTE $3F
    $60BC: 3F          .BYTE $3F
    $60BD: 3F          .BYTE $3F
    $60BE: 3F          .BYTE $3F
    $60BF: 3F          .BYTE $3F
    $60C0: 3F          .BYTE $3F
    $60C1: 33          .BYTE $33
    $60C2: 33          .BYTE $33
    $60C3: 0C          .BYTE $0C
    $60C4: 03          .BYTE $03
    $60C5: 0C          .BYTE $0C
    $60C6: 33          .BYTE $33
    $60C7: 3F          .BYTE $3F
    $60C8: 0C          .BYTE $0C
    $60C9: 1F          .BYTE $1F
    $60CA: 0C          .BYTE $0C
    $60CB: 33          .BYTE $33
    $60CC: 1F          .BYTE $1F
    $60CD: 0C          .BYTE $0C
    $60CE: 1F          .BYTE $1F
    $60CF: 0C          .BYTE $0C
    $60D0: 3F          .BYTE $3F
    $60D1: 3B          .BYTE $3B
    $60D2: 3F          .BYTE $3F
    $60D3: 03          .BYTE $03
    $60D4: 0C          .BYTE $0C
    $60D5: 1F          .BYTE $1F
    $60D6: 33          .BYTE $33
    $60D7: 3F          .BYTE $3F
    $60D8: 03          .BYTE $03
    $60D9: 0C          .BYTE $0C
    $60DA: 1F          .BYTE $1F
    $60DB: 33          .BYTE $33
    $60DC: 3F          .BYTE $3F
    $60DD: 33          .BYTE $33
    $60DE: 33          .BYTE $33
    $60DF: 33          .BYTE $33
    $60E0: 1F          .BYTE $1F
    $60E1: 1E 33 0C    ASL  $0C33,X
    $60E4: 3F          .BYTE $3F
    $60E5: 0C          .BYTE $0C
    $60E6: 1F          .BYTE $1F
    $60E7: 0C          .BYTE $0C
    $60E8: 1E 1E 1E    ASL  $1E1E,X
    $60EB: 3F          .BYTE $3F
    $60EC: 3F          .BYTE $3F
    $60ED: 3F          .BYTE $3F
    $60EE: 3F          .BYTE $3F
    $60EF: 3F          .BYTE $3F
    $60F0: 3F          .BYTE $3F
    $60F1: 3F          .BYTE $3F
    $60F2: 03          .BYTE $03
    $60F3: 33          .BYTE $33
    $60F4: 33          .BYTE $33
    $60F5: 0C          .BYTE $0C
    $60F6: 0C          .BYTE $0C
    $60F7: 1E 03 33    ASL  $3303,X
    $60FA: 0C          .BYTE $0C
    $60FB: 0C          .BYTE $0C
    $60FC: 30 33       BMI  L_6131
    $60FE: 33          .BYTE $33
    $60FF: 0C          .BYTE $0C
    $6100: 0C          .BYTE $0C
    $6101: 3F          .BYTE $3F
    $6102: 3F          .BYTE $3F
    $6103: 3F          .BYTE $3F
    $6104: 0C          .BYTE $0C
    $6105: 0C          .BYTE $0C
    $6106: 1E 1E 1E    ASL  $1E1E,X
    $6109: 0C          .BYTE $0C
    $610A: 0C          .BYTE $0C
    $610B: 1E 1E 33    ASL  $331E,X
    $610E: 1F          .BYTE $1F
    $610F: 1E 63 3F    ASL  $3F63,X
    $6112: 3F          .BYTE $3F
    $6113: 33          .BYTE $33
    $6114: 3F          .BYTE $3F
    $6115: 3F          .BYTE $3F
    $6116: 77          .BYTE $77
    $6117: 03          .BYTE $03
    $6118: 33          .BYTE $33
    $6119: 33          .BYTE $33
    $611A: 33          .BYTE $33
    $611B: 33          .BYTE $33
    $611C: 6B          .BYTE $6B
    $611D: 1E 03 3F    ASL  $3F03,X
    $6120: 3F          .BYTE $3F
    $6121: 3F          .BYTE $3F
    $6122: 63          .BYTE $63
    $6123: 30 33       BMI  L_6158
    $6125: 3F          .BYTE $3F
    $6126: 1F          .BYTE $1F
    $6127: 3F          .BYTE $3F
    $6128: 63          .BYTE $63
    $6129: 3F          .BYTE $3F
    $612A: 3F          .BYTE $3F
    $612B: 33          .BYTE $33
    $612C: 3B          .BYTE $3B
    $612D: 33          .BYTE $33
    $612E: 63          .BYTE $63
    $612F: 1E 1E 33    ASL  $331E,X
    $6132: 33          .BYTE $33
    $6133: 33          .BYTE $33
    $6134: 63          .BYTE $63
    $6135: 33          .BYTE $33
    $6136: 3F          .BYTE $3F
    $6137: 33          .BYTE $33
    $6138: 3F          .BYTE $3F
    $6139: 33          .BYTE $33
    $613A: 0C          .BYTE $0C
    $613B: 3F          .BYTE $3F
    $613C: 0C          .BYTE $0C
    $613D: 3F          .BYTE $3F
    $613E: 0C          .BYTE $0C
    $613F: 33          .BYTE $33
    $6140: 3F          .BYTE $3F
    $6141: 33          .BYTE $33
    $6142: 3F          .BYTE $3F
    $6143: 3E 3C 1E    ROL  $1E3C,X
    $6146: 1E 3C 41    ASL  $413C,X
    $6149: 36 3F       ROL  $3F,X
    $614B: 3F          .BYTE $3F
    $614C: 36 5D       ROL  $5D,X
    $614E: 33          .BYTE $33
    $614F: 33          .BYTE $33
    $6150: 33          .BYTE $33
    $6151: 33          .BYTE $33
    $6152: 45 30       EOR  $30
    $6154: 3E 1E 30    ROL  $301E,X
    $6157: 5D 30 30    EOR  $3030,X
    $615A: 33          .BYTE $33
    $615B: 30 41       BMI  L_619E
    $615D: 30 3E       BMI  L_619D
    $615F: 3F          .BYTE $3F
    $6160: 30 3E       BMI  L_61A0
    $6162: 30 1E       BMI  L_6182
    $6164: 1E 30 1E    ASL  $1E30,X
    $6167: 33          .BYTE $33
    $6168: 00          BRK  
    $6169: 03          .BYTE $03
    $616A: 3F          .BYTE $3F
    $616B: 33          .BYTE $33
    $616C: 3F          .BYTE $3F
    $616D: 3F          .BYTE $3F
    $616E: 33          .BYTE $33
    $616F: 00          BRK  
    $6170: 03          .BYTE $03
    $6171: 3F          .BYTE $3F
    $6172: 33          .BYTE $33
    $6173: 3F          .BYTE $3F
    $6174: 33          .BYTE $33
    $6175: 37          .BYTE $37
    $6176: 00          BRK  
    $6177: 03          .BYTE $03
    $6178: 0C          .BYTE $0C
    $6179: 37          .BYTE $37
    $617A: 03          .BYTE $03
    $617B: 33          .BYTE $33
    $617C: 3F          .BYTE $3F
    $617D: 3F          .BYTE $3F
    $617E: 03          .BYTE $03
    $617F: 0C          .BYTE $0C
    $6180: 3F          .BYTE $3F
    $6181: 1F          .BYTE $1F

L_6182:
    $6182: 33          .BYTE $33
    $6183: 3B          .BYTE $3B
    $6184: 3F          .BYTE $3F
    $6185: 03          .BYTE $03
    $6186: 0C          .BYTE $0C
    $6187: 3B          .BYTE $3B
    $6188: 03          .BYTE $03
    $6189: 3F          .BYTE $3F
    $618A: 33          .BYTE $33
    $618B: 00          BRK  
    $618C: 3F          .BYTE $3F
    $618D: 3F          .BYTE $3F
    $618E: 33          .BYTE $33
    $618F: 3F          .BYTE $3F
    $6190: 1E 33 00    ASL  $0033,X
    $6193: 3F          .BYTE $3F
    $6194: 3F          .BYTE $3F
    $6195: 33          .BYTE $33
    $6196: 3F          .BYTE $3F
    $6197: 1E 33 1E    ASL  $1E33,X
    $619A: 3F          .BYTE $3F
    $619B: 3F          .BYTE $3F
    $619C: 63          .BYTE $63

L_619D:
    $619D: 3C          .BYTE $3C

L_619E:
    $619E: 3F          .BYTE $3F
    $619F: 33          .BYTE $33

L_61A0:
    $61A0: 3F          .BYTE $3F
    $61A1: 3F          .BYTE $3F
    $61A2: 3F          .BYTE $3F
    $61A3: 77          .BYTE $77
    $61A4: 7E 03 33    ROR  $3303,X
    $61A7: 03          .BYTE $03
    $61A8: 0C          .BYTE $0C
    $61A9: 03          .BYTE $03
    $61AA: 6B          .BYTE $6B
    $61AB: 06 1E       ASL  $1E
    $61AD: 1E 1E 0C    ASL  $0C1E,X
    $61B0: 1F          .BYTE $1F
    $61B1: 63          .BYTE $63
    $61B2: 3C          .BYTE $3C
    $61B3: 30 0C       BMI  L_61C1
    $61B5: 30 0C       BMI  L_61C3
    $61B7: 03          .BYTE $03
    $61B8: 63          .BYTE $63
    $61B9: 60          RTS  
    $61BA: 3F          .BYTE $3F
    $61BB: 0C          .BYTE $0C
    $61BC: 3F          .BYTE $3F
    $61BD: 0C          .BYTE $0C
    $61BE: 3F          .BYTE $3F
    $61BF: 63          .BYTE $63
    $61C0: 7E 1E 0C    ROR  $0C1E,X

L_61C3:
    $61C3: 1E 0C 3F    ASL  $3F0C,X
    $61C6: 63          .BYTE $63
    $61C7: 3C          .BYTE $3C
    $61C8: 80          .BYTE $80
    $61C9: FF          .BYTE $FF
    $61CA: 80          .BYTE $80
    $61CB: C0 FF       CPY  #$FF
    $61CD: 81 A0       STA  ($A0,X)
    $61CF: DD 82 B0    CMP  $B082,X
    $61D2: DD 86 A8    CMP  $A886,X
    $61D5: DD 8A AC    CMP  $AC8A,X
    $61D8: DD 9A AA    CMP  $AA9A,X
    $61DB: DD AA AB    CMP  $ABAA,X
    $61DE: DD EA AB    CMP  $ABEA,X
    $61E1: DD EA FF    CMP  $FFEA,X
    $61E4: FF          .BYTE $FF
    $61E5: FF          .BYTE $FF
    $61E6: FF          .BYTE $FF
    $61E7: FF          .BYTE $FF
    $61E8: FF          .BYTE $FF
    $61E9: FF          .BYTE $FF
    $61EA: FF          .BYTE $FF
    $61EB: FF          .BYTE $FF
    $61EC: AB          .BYTE $AB
    $61ED: DD EA AB    CMP  $ABEA,X
    $61F0: DD EA AA    CMP  $AAEA,X
    $61F3: DD AA AC    CMP  $ACAA,X
    $61F6: DD 9A A8    CMP  $A89A,X
    $61F9: DD 8A B0    CMP  $B08A,X
    $61FC: DD 86 A0    CMP  $A086,X
    $61FF: DD 82 C0    CMP  $C082,X
    $6202: FF          .BYTE $FF
    $6203: 81 80       STA  ($80,X)
    $6205: FF          .BYTE $FF
    $6206: 80          .BYTE $80
    $6207: 03          .BYTE $03
    $6208: 3F          .BYTE $3F
    $6209: 33          .BYTE $33
    $620A: 3F          .BYTE $3F
    $620B: 1E 03 3F    ASL  $3F03,X
    $620E: 33          .BYTE $33
    $620F: 3F          .BYTE $3F
    $6210: 3F          .BYTE $3F
    $6211: 03          .BYTE $03
    $6212: 0C          .BYTE $0C
    $6213: 33          .BYTE $33
    $6214: 03          .BYTE $03
    $6215: 03          .BYTE $03
    $6216: 03          .BYTE $03
    $6217: 0C          .BYTE $0C
    $6218: 33          .BYTE $33
    $6219: 1F          .BYTE $1F
    $621A: 1E 03 0C    ASL  $0C03,X
    $621D: 33          .BYTE $33
    $621E: 03          .BYTE $03
    $621F: 30 3F       BMI  L_6260
    $6221: 3F          .BYTE $3F
    $6222: 1E 3F 3F    ASL  $3F3F,X
    $6225: 3F          .BYTE $3F
    $6226: 3F          .BYTE $3F
    $6227: 0C          .BYTE $0C
    $6228: 3F          .BYTE $3F
    $6229: 1E D4 00    ASL  $00D4,X
    $622C: 95 D4       STA  $D4,X
    $622E: C1 95       CMP  ($95,X)
    $6230: D0 FF       BNE  L_6231
    $6232: 85 D0       STA  $D0
    $6234: FF          .BYTE $FF
    $6235: 85 C0       STA  $C0
    $6237: 94 81       STY  $81,X
    $6239: 00          BRK  
    $623A: 94 00       STY  $00,X
    $623C: 00          BRK  
    $623D: 94 00       STY  $00,X
    $623F: 00          BRK  
    $6240: 94 00       STY  $00,X
    $6242: 00          BRK  
    $6243: 94 00       STY  $00,X
    $6245: 00          BRK  
    $6246: 94 00       STY  $00,X
    $6248: 00          BRK  
    $6249: AA          TAX  
    $624A: 00          BRK  
    $624B: 00          BRK  
    $624C: AA          TAX  
    $624D: 00          BRK  
    $624E: 00          BRK  
    $624F: AA          TAX  
    $6250: 00          BRK  
    $6251: 00          BRK  
    $6252: 88          DEY  
    $6253: 00          BRK  
    $6254: 00          BRK  
    $6255: 00          BRK  
    $6256: C0 00       CPY  #$00
    $6258: 00          BRK  
    $6259: D0 00       BNE  L_625B

L_625B:
    $625B: 00          BRK  
    $625C: D0 00       BNE  L_625E

L_625E:
    $625E: 00          BRK  
    $625F: D4          .BYTE $D4

L_6260:
    $6260: 00          BRK  
    $6261: 00          BRK  
    $6262: D4          .BYTE $D4
    $6263: 00          BRK  
    $6264: 00          BRK  
    $6265: B8          CLV  
    $6266: 00          BRK  
    $6267: 8A          TXA  
    $6268: 98          TYA  
    $6269: 00          BRK  
    $626A: DA          .BYTE $DA
    $626B: 9A          TXS  
    $626C: C0 DA       CPY  #$DA
    $626E: 9A          TXS  
    $626F: 00          BRK  
    $6270: DA          .BYTE $DA
    $6271: 9A          TXS  
    $6272: 00          BRK  
    $6273: 8A          TXA  
    $6274: 98          TYA  
    $6275: 00          BRK  
    $6276: 00          BRK  
    $6277: B8          CLV  
    $6278: 00          BRK  
    $6279: 00          BRK  
    $627A: D4          .BYTE $D4
    $627B: 00          BRK  
    $627C: 00          BRK  
    $627D: D4          .BYTE $D4
    $627E: 00          BRK  
    $627F: 00          BRK  
    $6280: D0 00       BNE  L_6282

L_6282:
    $6282: 00          BRK  
    $6283: D0 00       BNE  L_6285

L_6285:
    $6285: 00          BRK  
    $6286: C0 00       CPY  #$00
    $6288: 88          DEY  
    $6289: 00          BRK  
    $628A: 00          BRK  
    $628B: AA          TAX  
    $628C: 00          BRK  
    $628D: 00          BRK  
    $628E: AA          TAX  
    $628F: 00          BRK  
    $6290: 00          BRK  
    $6291: AA          TAX  
    $6292: 00          BRK  
    $6293: 00          BRK  
    $6294: 94 00       STY  $00,X
    $6296: 00          BRK  
    $6297: 94 00       STY  $00,X
    $6299: 00          BRK  
    $629A: 94 00       STY  $00,X
    $629C: 00          BRK  
    $629D: 94 00       STY  $00,X
    $629F: 00          BRK  
    $62A0: 94 00       STY  $00,X
    $62A2: C0 94       CPY  #$94
    $62A4: 81 D0       STA  ($D0,X)
    $62A6: FF          .BYTE $FF
    $62A7: 85 D0       STA  $D0
    $62A9: FF          .BYTE $FF
    $62AA: 85 D4       STA  $D4
    $62AC: C1 95       CMP  ($95,X)
    $62AE: D4          .BYTE $D4
    $62AF: 00          BRK  
    $62B0: 95 E0       STA  $E0,X
    $62B2: 87          .BYTE $87
    $62B3: 00          BRK  
    $62B4: B8          CLV  
    $62B5: 9D 00 AE    STA  $AE00,X
    $62B8: F5 00       SBC  $00,X
    $62BA: AF          .BYTE $AF
    $62BB: F4          .BYTE $F4
    $62BC: 81 AE       STA  ($AE,X)
    $62BE: F5 00       SBC  $00,X
    $62C0: B8          CLV  
    $62C1: 9D 00 E0    STA  $E000,X
    $62C4: 87          .BYTE $87
    $62C5: 00          BRK  
    $62C6: 15 0E       ORA  $0E,X
    $62C8: 1B          .BYTE $1B
    $62C9: 0E 15 2A    ASL  $2A15
    $62CC: 1C          .BYTE $1C
    $62CD: 36 1C       ROL  $1C,X
    $62CF: 2A          ROL  
    $62D0: 54          .BYTE $54
    $62D1: 38          SEC  
    $62D2: 6C 38 54    JMP  ($5438)
    $62D5: 28          PLP  
    $62D6: 01 70       ORA  ($70,X)
    $62D8: 00          BRK  
    $62D9: 58          CLI  
    $62DA: 01 70       ORA  ($70,X)
    $62DC: 00          BRK  
    $62DD: 28          PLP  
    $62DE: 01 50       ORA  ($50,X)
    $62E0: 02          .BYTE $02
    $62E1: 60          RTS  
    $62E2: 01 30       ORA  ($30,X)
    $62E4: 03          .BYTE $03
    $62E5: 60          RTS  
    $62E6: 01 50       ORA  ($50,X)
    $62E8: 02          .BYTE $02
    $62E9: 20 05 40    JSR  $4005
    $62EC: 03          .BYTE $03
    $62ED: 60          RTS  
    $62EE: 06 40       ASL  $40
    $62F0: 03          .BYTE $03
    $62F1: 20 05 40    JSR  $4005
    $62F4: 0A          ASL  
    $62F5: 00          BRK  
    $62F6: 07          .BYTE $07
    $62F7: 40          RTI  
    $62F8: 0D 00 07    ORA  $0700
    $62FB: 40          RTI  
    $62FC: 0A          ASL  
    $62FD: 1E 1E 63    ASL  $631E,X
    $6300: 7E 00 1E    ROR  $1E00,X
    $6303: 33          .BYTE $33
    $6304: 3F          .BYTE $3F
    $6305: 1F          .BYTE $1F
    $6306: 1E 1E 63    ASL  $631E,X
    $6309: 7E 00 1E    ROR  $1E00,X
    $630C: 33          .BYTE $33
    $630D: 3F          .BYTE $3F
    $630E: 1F          .BYTE $1F
    $630F: 3F          .BYTE $3F
    $6310: 3F          .BYTE $3F
    $6311: 77          .BYTE $77
    $6312: 7E 00 3F    ROR  $3F00,X
    $6315: 33          .BYTE $33
    $6316: 3F          .BYTE $3F
    $6317: 3F          .BYTE $3F
    $6318: 3F          .BYTE $3F
    $6319: 3F          .BYTE $3F
    $631A: 77          .BYTE $77
    $631B: 7E 00 3F    ROR  $3F00,X
    $631E: 33          .BYTE $33
    $631F: 3F          .BYTE $3F
    $6320: 3F          .BYTE $3F
    $6321: 03          .BYTE $03
    $6322: 33          .BYTE $33
    $6323: 6B          .BYTE $6B
    $6324: 06 00       ASL  $00
    $6326: 33          .BYTE $33
    $6327: 33          .BYTE $33
    $6328: 03          .BYTE $03
    $6329: 33          .BYTE $33
    $632A: 03          .BYTE $03
    $632B: 33          .BYTE $33
    $632C: 6B          .BYTE $6B
    $632D: 06 00       ASL  $00
    $632F: 33          .BYTE $33
    $6330: 33          .BYTE $33
    $6331: 03          .BYTE $03
    $6332: 33          .BYTE $33
    $6333: 3B          .BYTE $3B
    $6334: 3F          .BYTE $3F
    $6335: 63          .BYTE $63
    $6336: 3E 00 33    ROL  $3300,X
    $6339: 33          .BYTE $33
    $633A: 1F          .BYTE $1F
    $633B: 3F          .BYTE $3F
    $633C: 3B          .BYTE $3B
    $633D: 3F          .BYTE $3F
    $633E: 63          .BYTE $63
    $633F: 3E 00 33    ROL  $3300,X
    $6342: 33          .BYTE $33
    $6343: 1F          .BYTE $1F
    $6344: 3F          .BYTE $3F
    $6345: 33          .BYTE $33
    $6346: 3F          .BYTE $3F
    $6347: 63          .BYTE $63
    $6348: 06 00       ASL  $00
    $634A: 33          .BYTE $33
    $634B: 33          .BYTE $33
    $634C: 03          .BYTE $03
    $634D: 1F          .BYTE $1F
    $634E: 33          .BYTE $33
    $634F: 3F          .BYTE $3F
    $6350: 63          .BYTE $63
    $6351: 06 00       ASL  $00
    $6353: 33          .BYTE $33
    $6354: 33          .BYTE $33
    $6355: 03          .BYTE $03
    $6356: 1F          .BYTE $1F
    $6357: 3F          .BYTE $3F
    $6358: 33          .BYTE $33
    $6359: 63          .BYTE $63
    $635A: 7E 00 3F    ROR  $3F00,X
    $635D: 1E 3F 3B    ASL  $3B3F,X
    $6360: 3F          .BYTE $3F
    $6361: 33          .BYTE $33
    $6362: 63          .BYTE $63
    $6363: 7E 00 3F    ROR  $3F00,X
    $6366: 1E 3F 3B    ASL  $3B3F,X
    $6369: 1E 33 63    ASL  $6333,X
    $636C: 7E 00 1E    ROR  $1E00,X
    $636F: 0C          .BYTE $0C
    $6370: 3F          .BYTE $3F
    $6371: 33          .BYTE $33
    $6372: 1E 33 63    ASL  $6333,X
    $6375: 7E 00 1E    ROR  $1E00,X
    $6378: 0C          .BYTE $0C
    $6379: 3F          .BYTE $3F
    $637A: 33          .BYTE $33
    $637B: 00          BRK  
    $637C: 7F          .BYTE $7F
    $637D: 00          BRK  
    $637E: 40          RTI  
    $637F: 7F          .BYTE $7F
    $6380: 01 20       ORA  ($20,X)
    $6382: 5D 02 30    EOR  $3002,X
    $6385: 5D 06 28    EOR  $2806,X
    $6388: 5D 0A 2C    EOR  $2C0A,X
    $638B: 5D 1A 2A    EOR  $2A1A,X
    $638E: 5D 2A 2B    EOR  $2B2A,X
    $6391: 5D 6A 2B    EOR  $2B6A,X
    $6394: 5D 6A 7F    EOR  $7F6A,X
    $6397: 7F          .BYTE $7F
    $6398: 7F          .BYTE $7F
    $6399: 7F          .BYTE $7F
    $639A: 7F          .BYTE $7F
    $639B: 7F          .BYTE $7F
    $639C: 7F          .BYTE $7F
    $639D: 7F          .BYTE $7F
    $639E: 7F          .BYTE $7F
    $639F: 2B          .BYTE $2B
    $63A0: 5D 6A 2B    EOR  $2B6A,X
    $63A3: 5D 6A 2A    EOR  $2A6A,X
    $63A6: 5D 2A 2C    EOR  $2C2A,X
    $63A9: 5D 1A 28    EOR  $281A,X
    $63AC: 5D 0A 30    EOR  $300A,X
    $63AF: 5D 06 20    EOR  $2006,X
    $63B2: 5D 02 40    EOR  $4002,X
    $63B5: 7F          .BYTE $7F
    $63B6: 01 00       ORA  ($00,X)
    $63B8: 7F          .BYTE $7F
    $63B9: 00          BRK  
    $63BA: 80          .BYTE $80
    $63BB: FF          .BYTE $FF
    $63BC: 80          .BYTE $80
    $63BD: C0 FF       CPY  #$FF
    $63BF: 81 A0       STA  ($A0,X)
    $63C1: DD 82 B0    CMP  $B082,X
    $63C4: DD 86 A8    CMP  $A886,X
    $63C7: DD 8A AC    CMP  $AC8A,X
    $63CA: DD 9A AA    CMP  $AA9A,X
    $63CD: DD AA AB    CMP  $ABAA,X
    $63D0: DD EA AB    CMP  $ABEA,X
    $63D3: DD EA FF    CMP  $FFEA,X
    $63D6: FF          .BYTE $FF
    $63D7: FF          .BYTE $FF
    $63D8: FF          .BYTE $FF
    $63D9: FF          .BYTE $FF
    $63DA: FF          .BYTE $FF
    $63DB: FF          .BYTE $FF
    $63DC: FF          .BYTE $FF
    $63DD: FF          .BYTE $FF
    $63DE: AB          .BYTE $AB
    $63DF: DD EA AB    CMP  $ABEA,X
    $63E2: DD EA AA    CMP  $AAEA,X
    $63E5: DD AA AC    CMP  $ACAA,X
    $63E8: DD 9A A8    CMP  $A89A,X
    $63EB: DD 8A B0    CMP  $B08A,X
    $63EE: DD 86 A0    CMP  $A086,X
    $63F1: DD 82 C0    CMP  $C082,X
    $63F4: FF          .BYTE $FF
    $63F5: 81 80       STA  ($80,X)
    $63F7: FF          .BYTE $FF
    $63F8: 80          .BYTE $80
    $63F9: 00          BRK  
    $63FA: 7F          .BYTE $7F
    $63FB: 00          BRK  
    $63FC: 40          RTI  
    $63FD: 7F          .BYTE $7F
    $63FE: 01 20       ORA  ($20,X)
    $6400: 5D 02 30    EOR  $3002,X
    $6403: 5D 06 28    EOR  $2806,X
    $6406: 5D 0A 2C    EOR  $2C0A,X
    $6409: 5D 1A 2A    EOR  $2A1A,X
    $640C: 5D 2A 2B    EOR  $2B2A,X
    $640F: 5D 6A 2B    EOR  $2B6A,X
    $6412: 5D 6A 7F    EOR  $7F6A,X
    $6415: 7F          .BYTE $7F
    $6416: 7F          .BYTE $7F
    $6417: 7F          .BYTE $7F
    $6418: 7F          .BYTE $7F
    $6419: 7F          .BYTE $7F
    $641A: 7F          .BYTE $7F
    $641B: 7F          .BYTE $7F
    $641C: 7F          .BYTE $7F
    $641D: 2B          .BYTE $2B
    $641E: 5D 6A 2B    EOR  $2B6A,X
    $6421: 5D 6A 2A    EOR  $2A6A,X
    $6424: 5D 2A 2C    EOR  $2C2A,X
    $6427: 5D 1A 28    EOR  $281A,X
    $642A: 5D 0A 30    EOR  $300A,X
    $642D: 5D 06 20    EOR  $2006,X
    $6430: 5D 02 40    EOR  $4002,X
    $6433: 7F          .BYTE $7F
    $6434: 01 00       ORA  ($00,X)
    $6436: 7F          .BYTE $7F
    $6437: 00          BRK  
    $6438: 80          .BYTE $80
    $6439: FF          .BYTE $FF
    $643A: 80          .BYTE $80
    $643B: C0 FF       CPY  #$FF
    $643D: 81 A0       STA  ($A0,X)
    $643F: DD 82 B0    CMP  $B082,X
    $6442: DD 86 A8    CMP  $A886,X
    $6445: DD 8A AC    CMP  $AC8A,X
    $6448: DD 9A AA    CMP  $AA9A,X
    $644B: DD AA AB    CMP  $ABAA,X
    $644E: DD EA AB    CMP  $ABEA,X
    $6451: DD EA FF    CMP  $FFEA,X
    $6454: FF          .BYTE $FF
    $6455: FF          .BYTE $FF
    $6456: FF          .BYTE $FF
    $6457: FF          .BYTE $FF
    $6458: FF          .BYTE $FF
    $6459: FF          .BYTE $FF
    $645A: FF          .BYTE $FF
    $645B: FF          .BYTE $FF
    $645C: AB          .BYTE $AB
    $645D: DD EA AB    CMP  $ABEA,X
    $6460: DD EA AA    CMP  $AAEA,X
    $6463: DD AA AC    CMP  $ACAA,X
    $6466: DD 9A A8    CMP  $A89A,X
    $6469: DD 8A B0    CMP  $B08A,X
    $646C: DD 86 A0    CMP  $A086,X
    $646F: DD 82 C0    CMP  $C082,X
    $6472: FF          .BYTE $FF
    $6473: 81 80       STA  ($80,X)
    $6475: FF          .BYTE $FF
    $6476: 80          .BYTE $80
    $6477: FD 00 DF    SBC  $DF00,X
    $647A: FD 00 DF    SBC  $DF00,X
    $647D: F9 FF CF    SBC  $CFFF,Y
    $6480: F4          .BYTE $F4
    $6481: FF          .BYTE $FF
    $6482: 97          .BYTE $97
    $6483: C4 9C       CPY  $9C
    $6485: 91 D4       STA  ($D4),Y
    $6487: AA          TAX  
    $6488: 95 C0       STA  $C0,X
    $648A: AA          TAX  
    $648B: 81 C0       STA  ($C0,X)
    $648D: AA          TAX  
    $648E: 81 C0       STA  ($C0,X)
    $6490: 9C          .BYTE $9C
    $6491: 81 C0       STA  ($C0,X)
    $6493: BE 81 C0    LDX  $C081,Y
    $6496: BE 81 C0    LDX  $C081,Y
    $6499: BE 81 C0    LDX  $C081,Y
    $649C: BE 81 C0    LDX  $C081,Y
    $649F: AA          TAX  
    $64A0: 81 00       STA  ($00,X)
    $64A2: AA          TAX  
    $64A3: 00          BRK  
    $64A4: 00          BRK  
    $64A5: 00          BRK  
    $64A6: D0 00       BNE  L_64A8

L_64A8:
    $64A8: 00          BRK  
    $64A9: D4          .BYTE $D4
    $64AA: 00          BRK  
    $64AB: 00          BRK  
    $64AC: E4 00       CPX  $00
    $64AE: 00          BRK  
    $64AF: F5 00       SBC  $00,X
    $64B1: 00          BRK  
    $64B2: F9 00 00    SBC  $0000,Y
    $64B5: F9 00 AA    SBC  $AA00,Y
    $64B8: F9 C0 00    SBC  $00C0,Y
    $64BB: B9 D0 9E    LDA  $9ED0,Y
    $64BE: 99 D0 BD    STA  $BDD0,Y
    $64C1: 9D D0 BD    STA  $BDD0,X
    $64C4: 9D D0 BD    STA  $BDD0,X
    $64C7: 9D D0 9E    STA  $9ED0,X
    $64CA: 99 C0 00    STA  $00C0,Y
    $64CD: B9 00 AA    LDA  $AA00,Y
    $64D0: F9 00 00    SBC  $0000,Y
    $64D3: F1 00       SBC  ($00),Y
    $64D5: 00          BRK  
    $64D6: F9 00 00    SBC  $0000,Y
    $64D9: F5 00       SBC  $00,X
    $64DB: 00          BRK  
    $64DC: E4 00       CPX  $00
    $64DE: 00          BRK  
    $64DF: D4          .BYTE $D4
    $64E0: 00          BRK  
    $64E1: 00          BRK  
    $64E2: D0 00       BNE  L_64E4

L_64E4:
    $64E4: AA          TAX  
    $64E5: 00          BRK  
    $64E6: C0 AA       CPY  #$AA
    $64E8: 81 C0       STA  ($C0,X)
    $64EA: BE 81 C0    LDX  $C081,Y
    $64ED: BE 81 C0    LDX  $C081,Y
    $64F0: BE 81 C0    LDX  $C081,Y
    $64F3: BE 81 C0    LDX  $C081,Y

L_64F6:
    $64F6: 9C          .BYTE $9C
    $64F7: 81 C0       STA  ($C0,X)
    $64F9: AA          TAX  
    $64FA: 81 C0       STA  ($C0,X)
    $64FC: AA          TAX  
    $64FD: 81 D4       STA  ($D4,X)
    $64FF: AA          TAX  
    $6500: 95 C4       STA  $C4,X
    $6502: 9C          .BYTE $9C
    $6503: 91 F4       STA  ($F4),Y
    $6505: FF          .BYTE $FF
    $6506: 97          .BYTE $97
    $6507: F9 FF CF    SBC  $CFFF,Y
    $650A: FD 00 DF    SBC  $DF00,X
    $650D: FD 00 DF    SBC  $DF00,X
    $6510: 85 00       STA  $00
    $6512: 00          BRK  
    $6513: 95 00       STA  $00,X
    $6515: 00          BRK  
    $6516: 93          .BYTE $93
    $6517: 00          BRK  
    $6518: 00          BRK  
    $6519: D7          .BYTE $D7
    $651A: 00          BRK  
    $651B: 00          BRK  
    $651C: CF          .BYTE $CF
    $651D: 00          BRK  
    $651E: 00          BRK  
    $651F: CF          .BYTE $CF
    $6520: 00          BRK  
    $6521: 00          BRK  
    $6522: CF          .BYTE $CF
    $6523: AA          TAX  
    $6524: 00          BRK  
    $6525: CE 00 81    DEC  $8100
    $6528: CC BC 85    CPY  $85BC
    $652B: DC          .BYTE $DC
    $652C: BE 85 DC    LDX  $DC85,Y
    $652F: BE 85 DC    LDX  $DC85,Y
    $6532: BE 85 CC    LDX  $CC85,Y
    $6535: BC 85 CE    LDY  $CE85,X
    $6538: 00          BRK  
    $6539: 81 CF       STA  ($CF,X)
    $653B: AA          TAX  
    $653C: 00          BRK  
    $653D: CF          .BYTE $CF
    $653E: 00          BRK  
    $653F: 00          BRK  
    $6540: CF          .BYTE $CF
    $6541: 00          BRK  
    $6542: 00          BRK  
    $6543: D7          .BYTE $D7
    $6544: 00          BRK  
    $6545: 00          BRK  
    $6546: 93          .BYTE $93
    $6547: 00          BRK  
    $6548: 00          BRK  
    $6549: 95 00       STA  $00,X
    $654B: 00          BRK  
    $654C: 85 00       STA  $00
    $654E: 00          BRK  
    $654F: 94 94       STY  $94,X
    $6551: D5 D5       CMP  $D5,X
    $6553: D5 94       CMP  $94,X
    $6555: 94 D0       STY  $D0,X
    $6557: 00          BRK  
    $6558: D0 00       BNE  L_655A

L_655A:
    $655A: D4          .BYTE $D4
    $655B: 82          .BYTE $82
    $655C: D4          .BYTE $D4
    $655D: 82          .BYTE $82
    $655E: D4          .BYTE $D4
    $655F: 82          .BYTE $82
    $6560: D0 00       BNE  L_6562

L_6562:
    $6562: D0 00       BNE  L_6564

L_6564:
    $6564: C0 82       CPY  #$82
    $6566: C0 82       CPY  #$82
    $6568: D0 8A       BNE  L_64F4
    $656A: D0 8A       BNE  L_64F6
    $656C: D0 8A       BNE  L_64F8
    $656E: C0 82       CPY  #$82
    $6570: C0 82       CPY  #$82
    $6572: 00          BRK  
    $6573: 8A          TXA  
    $6574: 00          BRK  
    $6575: 8A          TXA  
    $6576: C0 AA       CPY  #$AA
    $6578: C0 AA       CPY  #$AA
    $657A: C0 AA       CPY  #$AA
    $657C: 00          BRK  
    $657D: 8A          TXA  
    $657E: 00          BRK  
    $657F: 08          PHP  
    $6580: A8          TAY  
    $6581: 00          BRK  
    $6582: A8          TAY  
    $6583: 00          BRK  
    $6584: AA          TAX  
    $6585: 81 AA       STA  ($AA,X)
    $6587: 81 AA       STA  ($AA,X)
    $6589: 81 A8       STA  ($A8,X)
    $658B: 00          BRK  
    $658C: A8          TAY  
    $658D: 00          BRK  
    $658E: A0 81       LDY  #$81
    $6590: A0 81       LDY  #$81
    $6592: A8          TAY  
    $6593: 85 A8       STA  $A8
    $6595: 85 A8       STA  $A8
    $6597: 85 A0       STA  $A0
    $6599: 81 A0       STA  ($A0,X)
    $659B: 81 00       STA  ($00,X)
    $659D: 85 00       STA  $00
    $659F: 85 A0       STA  $A0
    $65A1: 95 A0       STA  $A0,X
    $65A3: 95 A0       STA  $A0,X
    $65A5: 95 00       STA  $00,X
    $65A7: 85 00       STA  $00
    $65A9: 85 E0       STA  $E0
    $65AB: 87          .BYTE $87
    $65AC: 00          BRK  
    $65AD: B8          CLV  
    $65AE: 9D 00 AE    STA  $AE00,X
    $65B1: F5 00       SBC  $00,X
    $65B3: AF          .BYTE $AF
    $65B4: F4          .BYTE $F4
    $65B5: 81 AE       STA  ($AE,X)
    $65B7: F5 00       SBC  $00,X
    $65B9: B8          CLV  
    $65BA: 9D 00 E0    STA  $E000,X

L_65BD:
    $65BD: 87          .BYTE $87
    $65BE: 00          BRK  
    $65BF: 00          BRK  
    $65C0: 9F          .BYTE $9F
    $65C1: 00          BRK  
    $65C2: E0 F5       CPX  #$F5
    $65C4: 00          BRK  
    $65C5: B8          CLV  
    $65C6: D5 83       CMP  $83,X
    $65C8: BC D1 87    LDY  $87D1,X

L_65CB:
    $65CB: B8          CLV  
    $65CC: D5 83       CMP  $83,X
    $65CE: E0 F5       CPX  #$F5
    $65D0: 00          BRK  
    $65D1: 00          BRK  
    $65D2: 9F          .BYTE $9F
    $65D3: 00          BRK  
    $65D4: 00          BRK  
    $65D5: FC          .BYTE $FC
    $65D6: 00          BRK  
    $65D7: 00          BRK  
    $65D8: D7          .BYTE $D7
    $65D9: 83          .BYTE $83
    $65DA: E0 D5       CPX  #$D5
    $65DC: 8E F0 C5    STX  $C5F0
    $65DF: 9E          .BYTE $9E
    $65E0: E0 D5       CPX  #$D5
    $65E2: 8E 00 D7    STX  $D700
    $65E5: 83          .BYTE $83
    $65E6: 00          BRK  
    $65E7: FC          .BYTE $FC
    $65E8: 00          BRK  
    $65E9: 00          BRK  
    $65EA: F0 83       BEQ  L_656F
    $65EC: 00          BRK  
    $65ED: DC          .BYTE $DC
    $65EE: 8E 00 D7    STX  $D700
    $65F1: BA          TSX  
    $65F2: C0 97       CPY  #$97
    $65F4: FA          .BYTE $FA
    $65F5: 00          BRK  
    $65F6: D7          .BYTE $D7
    $65F7: BA          TSX  
    $65F8: 00          BRK  
    $65F9: DC          .BYTE $DC
    $65FA: 8E 00 F0    STX  $F000
    $65FD: 83          .BYTE $83
    $65FE: C0 8F       CPY  #$8F
    $6600: 00          BRK  
    $6601: F0 BA       BEQ  L_65BD
    $6603: 00          BRK  
    $6604: DC          .BYTE $DC
    $6605: EA          NOP  
    $6606: 81 DE       STA  ($DE,X)
    $6608: E8          INX  
    $6609: 83          .BYTE $83
    $660A: DC          .BYTE $DC
    $660B: EA          NOP  
    $660C: 81 F0       STA  ($F0,X)
    $660E: BA          TSX  
    $660F: 00          BRK  
    $6610: C0 8F       CPY  #$8F
    $6612: 00          BRK  
    $6613: 00          BRK  
    $6614: BE 00 C0    LDX  $C000,Y  ; KEYBOARD
    $6617: EB          .BYTE $EB
    $6618: 81 F0       STA  ($F0,X)
    $661A: AA          TAX  
    $661B: 87          .BYTE $87
    $661C: F8          SED  
    $661D: A2 8F       LDX  #$8F
    $661F: F0 AA       BEQ  L_65CB
    $6621: 87          .BYTE $87
    $6622: C0 EB       CPY  #$EB
    $6624: 81 00       STA  ($00,X)
    $6626: BE 00 00    LDX  $0000,Y
    $6629: F8          SED  
    $662A: 81 00       STA  ($00,X)
    $662C: AE 87 C0    LDX  $C087
    $662F: AB          .BYTE $AB
    $6630: 9D E0 8B    STA  $8BE0,X
    $6633: BD C0 AB    LDA  $ABC0,X
    $6636: 9D 00 AE    STA  $AE00,X
    $6639: 87          .BYTE $87
    $663A: 00          BRK  
    $663B: F8          SED  
    $663C: 81 3E       STA  ($3E,X)
    $663E: 6B          .BYTE $6B
    $663F: 7F          .BYTE $7F
    $6640: 5D 63 3E    EOR  $3E63,X
    $6643: 78          SEI  
    $6644: 01 2C       ORA  ($2C,X)
    $6646: 03          .BYTE $03
    $6647: 7C          .BYTE $7C
    $6648: 03          .BYTE $03
    $6649: 74          .BYTE $74
    $664A: 02          .BYTE $02
    $664B: 0C          .BYTE $0C
    $664C: 03          .BYTE $03
    $664D: 78          SEI  
    $664E: 01 60       ORA  ($60,X)
    $6650: 07          .BYTE $07
    $6651: 30 0D       BMI  L_6660
    $6653: 70 0F       BVS  L_6664
    $6655: 50 0B       BVC  L_6662
    $6657: 30 0C       BMI  L_6665
    $6659: 60          RTS  
    $665A: 07          .BYTE $07
    $665B: 00          BRK  
    $665C: 1F          .BYTE $1F
    $665D: 40          RTI  
    $665E: 35 40       AND  $40,X

L_6660:
    $6660: 3F          .BYTE $3F
    $6661: 40          RTI  

L_6662:
    $6662: 2E 40 31    ROL  $3140

L_6665:
    $6665: 00          BRK  
    $6666: 1F          .BYTE $1F
    $6667: 7C          .BYTE $7C
    $6668: 00          BRK  
    $6669: 56 01       LSR  $01,X
    $666B: 7E 01 3A    ROR  $3A01,X
    $666E: 01 46       ORA  ($46,X)
    $6670: 01 7C       ORA  ($7C,X)
    $6672: 00          BRK  
    $6673: 70 03       BVS  L_6678
    $6675: 58          CLI  
    $6676: 06 78       ASL  $78

L_6678:
    $6678: 07          .BYTE $07
    $6679: 68          PLA  
    $667A: 05 18       ORA  $18
    $667C: 06 70       ASL  $70
    $667E: 03          .BYTE $03
    $667F: 40          RTI  
    $6680: 0F          .BYTE $0F
    $6681: 60          RTS  
    $6682: 1A          .BYTE $1A
    $6683: 60          RTS  
    $6684: 1F          .BYTE $1F
    $6685: 20 17 60    JSR  $6017
    $6688: 18          CLC  
    $6689: 40          RTI  
    $668A: 0F          .BYTE $0F
    $668B: 0B          .BYTE $0B
    $668C: 1C          .BYTE $1C
    $668D: 3E 7F 3E    ROL  $3E7F,X
    $6690: 1C          .BYTE $1C
    $6691: 08          PHP  
    $6692: 20 00 70    JSR  $7000
    $6695: 00          BRK  
    $6696: 78          SEI  
    $6697: 01 7C       ORA  ($7C,X)
    $6699: 03          .BYTE $03
    $669A: 78          SEI  
    $669B: 01 70       ORA  ($70,X)
    $669D: 00          BRK  
    $669E: 20 00 00    JSR  $0000
    $66A1: 01 40       ORA  ($40,X)
    $66A3: 03          .BYTE $03
    $66A4: 60          RTS  
    $66A5: 07          .BYTE $07
    $66A6: 70 0F       BVS  L_66B7
    $66A8: 60          RTS  
    $66A9: 07          .BYTE $07
    $66AA: 40          RTI  
    $66AB: 03          .BYTE $03
    $66AC: 00          BRK  
    $66AD: 01 00       ORA  ($00,X)
    $66AF: 04          .BYTE $04
    $66B0: 00          BRK  
    $66B1: 0E 00 1F    ASL  $1F00
    $66B4: 40          RTI  
    $66B5: 3F          .BYTE $3F
    $66B6: 00          BRK  

L_66B7:
    $66B7: 1F          .BYTE $1F
    $66B8: 00          BRK  
    $66B9: 0E 00 04    ASL  $0400
    $66BC: 10 00       BPL  L_66BE

L_66BE:
    $66BE: 38          SEC  
    $66BF: 00          BRK  

L_66C0:
    $66C0: 7C          .BYTE $7C
    $66C1: 00          BRK  

L_66C2:
    $66C2: 7E 01 7C    ROR  $7C01,X
    $66C5: 00          BRK  
    $66C6: 38          SEC  
    $66C7: 00          BRK  
    $66C8: 10 00       BPL  L_66CA

L_66CA:
    $66CA: 40          RTI  
    $66CB: 00          BRK  
    $66CC: 60          RTS  
    $66CD: 01 70       ORA  ($70,X)
    $66CF: 03          .BYTE $03
    $66D0: 78          SEI  
    $66D1: 07          .BYTE $07
    $66D2: 70 03       BVS  L_66D7
    $66D4: 60          RTS  
    $66D5: 01 40       ORA  ($40,X)

L_66D7:
    $66D7: 00          BRK  
    $66D8: 00          BRK  
    $66D9: 02          .BYTE $02
    $66DA: 00          BRK  
    $66DB: 07          .BYTE $07
    $66DC: 40          RTI  
    $66DD: 0F          .BYTE $0F
    $66DE: 60          RTS  
    $66DF: 1F          .BYTE $1F
    $66E0: 40          RTI  
    $66E1: 0F          .BYTE $0F
    $66E2: 00          BRK  
    $66E3: 07          .BYTE $07
    $66E4: 00          BRK  
    $66E5: 02          .BYTE $02
    $66E6: 28          PLP  
    $66E7: 00          BRK  
    $66E8: 2A          ROL  
    $66E9: 01 2A       ORA  ($2A,X)

L_66EB:
    $66EB: 01 D4       ORA  ($D4,X)
    $66ED: 80          .BYTE $80
    $66EE: AA          TAX  

L_66EF:
    $66EF: 81 AA       STA  ($AA,X)

L_66F1:
    $66F1: 81 A8       STA  ($A8,X)
    $66F3: 00          BRK  
    $66F4: 20 01 28    JSR  $2801
    $66F7: 05 28       ORA  $28
    $66F9: 05 D0       ORA  $D0
    $66FB: 82          .BYTE $82
    $66FC: A8          TAY  
    $66FD: 85 A8       STA  $A8
    $66FF: 85 A0       STA  $A0
    $6701: 81 00       STA  ($00,X)
    $6703: 05 20       ORA  $20
    $6705: 15 20       ORA  $20,X
    $6707: 15 00       ORA  $00,X
    $6709: 8A          TXA  
    $670A: A0 95       LDY  #$95
    $670C: A0 95       LDY  #$95
    $670E: 00          BRK  
    $670F: 85 00       STA  $00
    $6711: 14          .BYTE $14
    $6712: 00          BRK  
    $6713: 55 00       EOR  $00,X
    $6715: 55 00       EOR  $00,X
    $6717: AA          TAX  
    $6718: 00          BRK  
    $6719: D5 00       CMP  $00,X
    $671B: D5 00       CMP  $00,X
    $671D: 94 50       STY  $50,X
    $671F: 00          BRK  
    $6720: 54          .BYTE $54
    $6721: 02          .BYTE $02
    $6722: 54          .BYTE $54
    $6723: 02          .BYTE $02
    $6724: A8          TAY  
    $6725: 00          BRK  
    $6726: D4          .BYTE $D4
    $6727: 82          .BYTE $82
    $6728: D4          .BYTE $D4
    $6729: 82          .BYTE $82
    $672A: D0 00       BNE  L_672C

L_672C:
    $672C: 40          RTI  
    $672D: 02          .BYTE $02
    $672E: 50 0A       BVC  L_673A
    $6730: 50 0A       BVC  L_673C
    $6732: A0 84       LDY  #$84
    $6734: D0 8A       BNE  L_66C0
    $6736: D0 8A       BNE  L_66C2
    $6738: C0 82       CPY  #$82

L_673A:
    $673A: 00          BRK  
    $673B: 0A          ASL  

L_673C:
    $673C: 40          RTI  
    $673D: 2A          ROL  
    $673E: 40          RTI  
    $673F: 2A          ROL  
    $6740: 00          BRK  
    $6741: 95 C0       STA  $C0,X
    $6743: AA          TAX  
    $6744: C0 AA       CPY  #$AA
    $6746: 00          BRK  
    $6747: AA          TAX  
    $6748: 94 D5       STY  $D5,X
    $674A: F7          .BYTE $F7
    $674B: D5 11       CMP  $11,X
    $674D: 55 44       EOR  $44,X
    $674F: D0 00       BNE  L_6751

L_6751:
    $6751: D4          .BYTE $D4
    $6752: 82          .BYTE $82
    $6753: DC          .BYTE $DC
    $6754: 83          .BYTE $83
    $6755: D4          .BYTE $D4
    $6756: 82          .BYTE $82
    $6757: 10 02       BPL  L_675B
    $6759: 54          .BYTE $54
    $675A: 02          .BYTE $02

L_675B:
    $675B: 44          .BYTE $44
    $675C: 00          BRK  
    $675D: C0 82       CPY  #$82
    $675F: D0 8A       BNE  L_66EB
    $6761: F0 8E       BEQ  L_66F1
    $6763: D0 8A       BNE  L_66EF
    $6765: 10 02       BPL  L_6769
    $6767: 50 0A       BVC  L_6773

L_6769:
    $6769: 40          RTI  
    $676A: 0B          .BYTE $0B
    $676B: 00          BRK  
    $676C: 8A          TXA  
    $676D: C0 AA       CPY  #$AA
    $676F: C0 BB       CPY  #$BB
    $6771: C0 AA       CPY  #$AA

L_6773:
    $6773: 00          BRK  
    $6774: 22          .BYTE $22
    $6775: 40          RTI  
    $6776: 2A          ROL  
    $6777: 40          RTI  
    $6778: 08          PHP  
    $6779: A8          TAY  
    $677A: 80          .BYTE $80
    $677B: AA          TAX  
    $677C: 81 EE       STA  ($EE,X)
    $677E: 81 AA       STA  ($AA,X)
    $6780: 81 22       STA  ($22,X)
    $6782: 00          BRK  
    $6783: 2A          ROL  
    $6784: 01 08       ORA  ($08,X)
    $6786: 01 A0       ORA  ($A0,X)
    $6788: 81 A8       STA  ($A8,X)
    $678A: 85 B8       STA  $B8
    $678C: 87          .BYTE $87
    $678D: A8          TAY  
    $678E: 85 20       STA  $20
    $6790: 04          .BYTE $04
    $6791: 28          PLP  
    $6792: 05 08       ORA  $08
    $6794: 01 00       ORA  ($00,X)
    $6796: 85 A0       STA  $A0
    $6798: 95 E0       STA  $E0,X
    $679A: 9D A0 95    STA  $95A0,X
    $679D: 20 04 20    JSR  $2004
    $67A0: 15 00       ORA  $00,X
    $67A2: 11 04       ORA  ($04),Y
    $67A4: 04          .BYTE $04
    $67A5: 55 55       EOR  $55,X
    $67A7: 55 04       EOR  $04,X
    $67A9: 04          .BYTE $04
    $67AA: 50 00       BVC  L_67AC

L_67AC:
    $67AC: 50 00       BVC  L_67AE

L_67AE:
    $67AE: 54          .BYTE $54
    $67AF: 02          .BYTE $02
    $67B0: 54          .BYTE $54
    $67B1: 02          .BYTE $02
    $67B2: 54          .BYTE $54
    $67B3: 02          .BYTE $02
    $67B4: 50 00       BVC  L_67B6

L_67B6:
    $67B6: 50 00       BVC  L_67B8

L_67B8:
    $67B8: 40          RTI  
    $67B9: 02          .BYTE $02
    $67BA: 40          RTI  
    $67BB: 02          .BYTE $02
    $67BC: 50 0A       BVC  L_67C8
    $67BE: 50 0A       BVC  L_67CA
    $67C0: 50 0A       BVC  L_67CC
    $67C2: 40          RTI  
    $67C3: 02          .BYTE $02
    $67C4: 40          RTI  
    $67C5: 02          .BYTE $02
    $67C6: 00          BRK  
    $67C7: 0A          ASL  

L_67C8:
    $67C8: 00          BRK  
    $67C9: 0A          ASL  

L_67CA:
    $67CA: 40          RTI  
    $67CB: 2A          ROL  

L_67CC:
    $67CC: 40          RTI  
    $67CD: 2A          ROL  
    $67CE: 40          RTI  
    $67CF: 2A          ROL  
    $67D0: 00          BRK  
    $67D1: 0A          ASL  
    $67D2: 00          BRK  
    $67D3: 00          BRK  
    $67D4: 28          PLP  
    $67D5: 00          BRK  
    $67D6: 28          PLP  
    $67D7: 00          BRK  
    $67D8: 2A          ROL  
    $67D9: 01 2A       ORA  ($2A,X)
    $67DB: 01 2A       ORA  ($2A,X)
    $67DD: 01 28       ORA  ($28,X)
    $67DF: 00          BRK  
    $67E0: 28          PLP  
    $67E1: 00          BRK  
    $67E2: 20 01 20    JSR  $2001
    $67E5: 01 28       ORA  ($28,X)
    $67E7: 05 28       ORA  $28
    $67E9: 05 28       ORA  $28
    $67EB: 05 20       ORA  $20
    $67ED: 01 20       ORA  ($20,X)
    $67EF: 01 00       ORA  ($00,X)
    $67F1: 05 00       ORA  $00
    $67F3: 05 20       ORA  $20
    $67F5: 15 20       ORA  $20,X
    $67F7: 15 20       ORA  $20,X
    $67F9: 15 00       ORA  $00,X
    $67FB: 05 00       ORA  $00
    $67FD: 05 00       ORA  $00
    $67FF: 60          RTS  
    $6800: 07          .BYTE $07
    $6801: 00          BRK  
    $6802: 00          BRK  
    $6803: 38          SEC  
    $6804: 1D 00 00    ORA  $0000,X
    $6807: 2E 75 00    ROL  $0075
    $680A: 00          BRK  
    $680B: 2F          .BYTE $2F
    $680C: 74          .BYTE $74
    $680D: 01 00       ORA  ($00,X)
    $680F: 2E 75 00    ROL  $0075
    $6812: 00          BRK  
    $6813: 38          SEC  
    $6814: 1D 00 00    ORA  $0000,X
    $6817: 60          RTS  
    $6818: 07          .BYTE $07
    $6819: 00          BRK  
    $681A: 00          BRK  
    $681B: 1F          .BYTE $1F
    $681C: 00          BRK  
    $681D: 60          RTS  
    $681E: 75 00       ADC  $00,X
    $6820: 38          SEC  
    $6821: 55 03       EOR  $03,X
    $6823: 3C          .BYTE $3C
    $6824: 51 07       EOR  ($07),Y
    $6826: 38          SEC  
    $6827: 55 03       EOR  $03,X
    $6829: 60          RTS  
    $682A: 75 00       ADC  $00,X
    $682C: 00          BRK  
    $682D: 1F          .BYTE $1F
    $682E: 00          BRK  
    $682F: 00          BRK  
    $6830: 7C          .BYTE $7C
    $6831: 00          BRK  
    $6832: 00          BRK  
    $6833: 57          .BYTE $57
    $6834: 03          .BYTE $03
    $6835: 60          RTS  
    $6836: 55 0E       EOR  $0E,X
    $6838: 70 45       BVS  L_687F
    $683A: 1E 60 55    ASL  $5560,X
    $683D: 0E 00 57    ASL  $5700
    $6840: 03          .BYTE $03
    $6841: 00          BRK  
    $6842: 7C          .BYTE $7C
    $6843: 00          BRK  
    $6844: 00          BRK  
    $6845: 70 03       BVS  L_684A
    $6847: 00          BRK  
    $6848: 5C          .BYTE $5C
    $6849: 0E 00 57    ASL  $5700
    $684C: 3A          .BYTE $3A
    $684D: 40          RTI  
    $684E: 17          .BYTE $17
    $684F: 7A          .BYTE $7A
    $6850: 00          BRK  
    $6851: 57          .BYTE $57
    $6852: 3A          .BYTE $3A
    $6853: 00          BRK  
    $6854: 5C          .BYTE $5C
    $6855: 0E 00 70    ASL  $7000
    $6858: 83          .BYTE $83
    $6859: 40          RTI  
    $685A: 0F          .BYTE $0F
    $685B: 00          BRK  
    $685C: 70 3A       BVS  L_6898
    $685E: 00          BRK  
    $685F: 5C          .BYTE $5C
    $6860: 6A          ROR  
    $6861: 01 5E       ORA  ($5E,X)
    $6863: 68          PLA  
    $6864: 03          .BYTE $03
    $6865: 5C          .BYTE $5C
    $6866: 6A          ROR  
    $6867: 01 70       ORA  ($70,X)
    $6869: 3A          .BYTE $3A
    $686A: 00          BRK  
    $686B: 40          RTI  
    $686C: 0F          .BYTE $0F
    $686D: 00          BRK  
    $686E: 00          BRK  
    $686F: 3E 00 40    ROL  $4000,X
    $6872: 6B          .BYTE $6B
    $6873: 01 70       ORA  ($70,X)
    $6875: 2A          ROL  
    $6876: 07          .BYTE $07
    $6877: 78          SEI  
    $6878: 22          .BYTE $22
    $6879: 0F          .BYTE $0F
    $687A: 70 2A       BVS  L_68A6
    $687C: 07          .BYTE $07
    $687D: 40          RTI  
    $687E: 6B          .BYTE $6B

L_687F:
    $687F: 01 00       ORA  ($00,X)
    $6881: 3E 00 00    ROL  $0000,X
    $6884: 78          SEI  
    $6885: 01 00       ORA  ($00,X)
    $6887: 2E 07 40    ROL  $4007
    $688A: 2B          .BYTE $2B
    $688B: 1D 60 0B    ORA  $0B60,X
    $688E: 3D 40 2B    AND  $2B40,X
    $6891: 1D 00 2E    ORA  $2E00,X
    $6894: 07          .BYTE $07
    $6895: 00          BRK  
    $6896: 78          SEI  
    $6897: 01 44       ORA  ($44,X)
    $6899: 00          BRK  
    $689A: 28          PLP  
    $689B: 00          BRK  
    $689C: 10 00       BPL  L_689E

L_689E:
    $689E: 7F          .BYTE $7F
    $689F: 03          .BYTE $03
    $68A0: 41 02       EOR  ($02,X)
    $68A2: 41 03       EOR  ($03,X)
    $68A4: 41 02       EOR  ($02,X)

L_68A6:
    $68A6: 41 03       EOR  ($03,X)

L_68A8:
    $68A8: 7F          .BYTE $7F
    $68A9: 03          .BYTE $03
    $68AA: 10 02       BPL  L_68AE
    $68AC: 20 01 40    JSR  $4001
    $68AF: 00          BRK  
    $68B0: 7C          .BYTE $7C
    $68B1: 0F          .BYTE $0F
    $68B2: 04          .BYTE $04
    $68B3: 0A          ASL  
    $68B4: 04          .BYTE $04
    $68B5: 0E 04 0A    ASL  $0A04
    $68B8: 04          .BYTE $04
    $68B9: 0E 7C 0F    ASL  $0F7C
    $68BC: 40          RTI  
    $68BD: 08          PHP  
    $68BE: 00          BRK  
    $68BF: 05 00       ORA  $00
    $68C1: 02          .BYTE $02
    $68C2: 70 3F       BVS  L_6903
    $68C4: 10 28       BPL  L_68EE
    $68C6: 10 38       BPL  L_6900
    $68C8: 10 28       BPL  L_68F2
    $68CA: 10 38       BPL  L_6904
    $68CC: 70 3F       BVS  L_690D
    $68CE: 00          BRK  
    $68CF: 22          .BYTE $22
    $68D0: 00          BRK  
    $68D1: 00          BRK  
    $68D2: 14          .BYTE $14
    $68D3: 00          BRK  
    $68D4: 00          BRK  
    $68D5: 08          PHP  
    $68D6: 00          BRK  
    $68D7: 40          RTI  
    $68D8: 7F          .BYTE $7F
    $68D9: 01 40       ORA  ($40,X)
    $68DB: 20 01 40    JSR  $4001
    $68DE: 60          RTS  
    $68DF: 01 40       ORA  ($40,X)
    $68E1: 20 01 40    JSR  $4001
    $68E4: 60          RTS  
    $68E5: 01 40       ORA  ($40,X)
    $68E7: 7F          .BYTE $7F
    $68E8: 01 08       ORA  ($08,X)
    $68EA: 01 50       ORA  ($50,X)
    $68EC: 00          BRK  
    $68ED: 20 00 7E    JSR  $7E00
    $68F0: 07          .BYTE $07
    $68F1: 02          .BYTE $02

L_68F2:
    $68F2: 05 02       ORA  $02
    $68F4: 07          .BYTE $07
    $68F5: 02          .BYTE $02
    $68F6: 05 02       ORA  $02
    $68F8: 07          .BYTE $07
    $68F9: 7E 07 20    ROR  $2007,X
    $68FC: 04          .BYTE $04
    $68FD: 40          RTI  
    $68FE: 02          .BYTE $02
    $68FF: 00          BRK  

L_6900:
    $6900: 01 78       ORA  ($78,X)
    $6902: 1F          .BYTE $1F

L_6903:
    $6903: 08          PHP  

L_6904:
    $6904: 14          .BYTE $14
    $6905: 08          PHP  
    $6906: 1C          .BYTE $1C
    $6907: 08          PHP  
    $6908: 14          .BYTE $14
    $6909: 08          PHP  
    $690A: 1C          .BYTE $1C

L_690B:
    $690B: 78          SEI  
    $690C: 1F          .BYTE $1F

L_690D:
    $690D: 00          BRK  
    $690E: 11 00       ORA  ($00),Y
    $6910: 04          .BYTE $04

L_6911:
    $6911: 00          BRK  
    $6912: 04          .BYTE $04
    $6913: 60          RTS  
    $6914: 7F          .BYTE $7F
    $6915: 20 50 20    JSR  $2050
    $6918: 70 20       BVS  L_693A
    $691A: 50 20       BVC  L_693C
    $691C: 70 60       BVS  L_697E
    $691E: 7F          .BYTE $7F
    $691F: C0 81       CPY  #$81
    $6921: D0 85       BNE  L_68A8
    $6923: D4          .BYTE $D4
    $6924: 95 DD       STA  $DD,X
    $6926: D5 D4       CMP  $D4,X
    $6928: 95 D0       STA  $D0,X
    $692A: 85 C0       STA  $C0
    $692C: 81 00       STA  ($00,X)
    $692E: 86 00       STX  $00
    $6930: C0 96       CPY  #$96
    $6932: 00          BRK  
    $6933: D0 D6       BNE  L_690B
    $6935: 00          BRK  
    $6936: F4          .BYTE $F4
    $6937: D6 82       DEC  $82,X
    $6939: D0 D6       BNE  L_6911
    $693B: 00          BRK  

L_693C:
    $693C: C0 96       CPY  #$96
    $693E: 00          BRK  
    $693F: 00          BRK  
    $6940: 86 00       STX  $00
    $6942: 00          BRK  
    $6943: 98          TYA  
    $6944: 00          BRK  
    $6945: 00          BRK  
    $6946: DA          .BYTE $DA
    $6947: 00          BRK  
    $6948: C0 DA       CPY  #$DA
    $694A: 82          .BYTE $82
    $694B: D0 D8       BNE  L_6925
    $694D: 8A          TXA  
    $694E: C0 DA       CPY  #$DA
    $6950: 82          .BYTE $82
    $6951: 00          BRK  
    $6952: DA          .BYTE $DA
    $6953: 00          BRK  
    $6954: 00          BRK  
    $6955: 98          TYA  
    $6956: 00          BRK  
    $6957: 00          BRK  
    $6958: E0 80       CPX  #$80
    $695A: 00          BRK  
    $695B: E8          INX  
    $695C: 82          .BYTE $82
    $695D: 00          BRK  
    $695E: EA          NOP  
    $695F: 8A          TXA  
    $6960: C0 EE       CPY  #$EE
    $6962: AA          TAX  
    $6963: 00          BRK  
    $6964: EA          NOP  
    $6965: 8A          TXA  
    $6966: 00          BRK  
    $6967: E8          INX  
    $6968: 82          .BYTE $82
    $6969: 00          BRK  
    $696A: E0 80       CPX  #$80
    $696C: 00          BRK  
    $696D: 83          .BYTE $83
    $696E: 00          BRK  
    $696F: A0 8B       LDY  #$8B
    $6971: 00          BRK  
    $6972: A8          TAY  
    $6973: AB          .BYTE $AB
    $6974: 00          BRK  
    $6975: BA          TSX  
    $6976: AB          .BYTE $AB
    $6977: 81 A8       STA  ($A8,X)
    $6979: AB          .BYTE $AB
    $697A: 00          BRK  
    $697B: A0 8B       LDY  #$8B
    $697D: 00          BRK  

L_697E:
    $697E: 00          BRK  
    $697F: 83          .BYTE $83
    $6980: 00          BRK  
    $6981: 00          BRK  
    $6982: 8C 80 00    STY  $0080
    $6985: AD 00 A0    LDA  $A000
    $6988: AD 81 E8    LDA  $E881
    $698B: AD 85 A0    LDA  $A085
    $698E: AD 81 00    LDA  $0081
    $6991: AD 00 00    LDA  $0000
    $6994: 8C 80 00    STY  $0080
    $6997: B0 80       BCS  L_6919
    $6999: 00          BRK  
    $699A: B4 81       LDY  $81,X
    $699C: 00          BRK  
    $699D: B5 85       LDA  $85,X
    $699F: 40          RTI  
    $69A0: B7          .BYTE $B7
    $69A1: 95 00       STA  $00,X
    $69A3: B5 85       LDA  $85,X
    $69A5: 00          BRK  
    $69A6: B4 81       LDY  $81,X
    $69A8: 00          BRK  
    $69A9: B0 80       BCS  L_692B
    $69AB: 60          RTS  
    $69AC: 01 5C       ORA  ($5C,X)
    $69AE: 0E 56 1A    ASL  $1A56
    $69B1: 55 2A       EOR  $2A,X
    $69B3: 7F          .BYTE $7F
    $69B4: 3F          .BYTE $3F
    $69B5: 4E 1C 04    LSR  $041C
    $69B8: 08          PHP  
    $69B9: 00          BRK  
    $69BA: 0F          .BYTE $0F
    $69BB: 00          BRK  
    $69BC: 70 3A       BVS  L_69F8
    $69BE: 00          BRK  
    $69BF: 58          CLI  
    $69C0: 6A          ROR  
    $69C1: 00          BRK  
    $69C2: 54          .BYTE $54
    $69C3: 2A          ROL  
    $69C4: 01 74       ORA  ($74,X)
    $69C6: 7F          .BYTE $7F
    $69C7: 01 38       ORA  ($38,X)
    $69C9: 72          .BYTE $72
    $69CA: 00          BRK  
    $69CB: 10 20       BPL  L_69ED
    $69CD: 00          BRK  
    $69CE: 00          BRK  
    $69CF: 1C          .BYTE $1C
    $69D0: 00          BRK  
    $69D1: 40          RTI  
    $69D2: 6B          .BYTE $6B
    $69D3: 01 60       ORA  ($60,X)
    $69D5: 2A          ROL  
    $69D6: 03          .BYTE $03
    $69D7: 50 2A       BVC  L_6A03
    $69D9: 05 70       ORA  $70
    $69DB: 7F          .BYTE $7F
    $69DC: 07          .BYTE $07
    $69DD: 60          RTS  
    $69DE: 49 03       EOR  #$03
    $69E0: 40          RTI  
    $69E1: 00          BRK  
    $69E2: 01 00       ORA  ($00,X)
    $69E4: 70 00       BVS  L_69E6

L_69E6:
    $69E6: 00          BRK  
    $69E7: 2E 07 00    ROL  $0007
    $69EA: 2B          .BYTE $2B
    $69EB: 0D 40 2A    ORA  $2A40
    $69EE: 15 40       ORA  $40,X
    $69F0: 7F          .BYTE $7F
    $69F1: 1F          .BYTE $1F
    $69F2: 00          BRK  
    $69F3: 27          .BYTE $27
    $69F4: 0E 00 02    ASL  $0200
    $69F7: 04          .BYTE $04

L_69F8:
    $69F8: 40          RTI  
    $69F9: 03          .BYTE $03
    $69FA: 38          SEC  
    $69FB: 1D 2C 35    ORA  $352C,X
    $69FE: 2A          ROL  
    $69FF: 55 7E       EOR  $7E,X
    $6A01: 7F          .BYTE $7F
    $6A02: 1C          .BYTE $1C

L_6A03:
    $6A03: 39 08 10    AND  $1008,Y
    $6A06: 00          BRK  
    $6A07: 0E 00 60    ASL  $6000
    $6A0A: 75 00       ADC  $00,X
    $6A0C: 30 55       BMI  L_6A63
    $6A0E: 01 28       ORA  ($28,X)
    $6A10: 55 02       EOR  $02,X
    $6A12: 78          SEI  
    $6A13: 7F          .BYTE $7F
    $6A14: 03          .BYTE $03
    $6A15: 70 64       BVS  L_6A7B
    $6A17: 01 20       ORA  ($20,X)
    $6A19: 40          RTI  
    $6A1A: 00          BRK  
    $6A1B: 00          BRK  
    $6A1C: 38          SEC  
    $6A1D: 00          BRK  
    $6A1E: 00          BRK  
    $6A1F: 57          .BYTE $57
    $6A20: 03          .BYTE $03
    $6A21: 40          RTI  
    $6A22: 55 06       EOR  $06,X
    $6A24: 20 55 0A    JSR  $0A55
    $6A27: 60          RTS  
    $6A28: 7F          .BYTE $7F
    $6A29: 0F          .BYTE $0F
    $6A2A: A0 13       LDY  #$13
    $6A2C: 07          .BYTE $07
    $6A2D: 00          BRK  
    $6A2E: 01 02       ORA  ($02,X)
    $6A30: C2          .BYTE $C2
    $6A31: C2          .BYTE $C2
    $6A32: CA          DEX  
    $6A33: D2          .BYTE $D2
    $6A34: AA          TAX  
    $6A35: D4          .BYTE $D4
    $6A36: AA          TAX  

L_6A37:
    $6A37: D5 AA       CMP  $AA,X
    $6A39: D4          .BYTE $D4
    $6A3A: CA          DEX  
    $6A3B: D2          .BYTE $D2
    $6A3C: C2          .BYTE $C2
    $6A3D: C2          .BYTE $C2
    $6A3E: 88          DEY  
    $6A3F: 8A          TXA  
    $6A40: 82          .BYTE $82
    $6A41: A8          TAY  
    $6A42: CA          DEX  
    $6A43: 82          .BYTE $82
    $6A44: A8          TAY  
    $6A45: D1 82       CMP  ($82),Y

L_6A47:
    $6A47: A8          TAY  
    $6A48: D5 82       CMP  $82,X
    $6A4A: A8          TAY  
    $6A4B: D1 82       CMP  ($82),Y
    $6A4D: A8          TAY  
    $6A4E: CA          DEX  
    $6A4F: 82          .BYTE $82
    $6A50: 88          DEY  
    $6A51: 8A          TXA  
    $6A52: 82          .BYTE $82
    $6A53: A0 A8       LDY  #$A8
    $6A55: 88          DEY  
    $6A56: A0 A9       LDY  #$A9
    $6A58: 8A          TXA  
    $6A59: A0 C5       LDY  #$C5
    $6A5B: 8A          TXA  
    $6A5C: A0 D5       LDY  #$D5
    $6A5E: 8A          TXA  
    $6A5F: A0 C5       LDY  #$C5
    $6A61: 8A          TXA  
    $6A62: A0 A9       LDY  #$A9
    $6A64: 8A          TXA  
    $6A65: A0 A8       LDY  #$A8
    $6A67: 88          DEY  
    $6A68: 00          BRK  
    $6A69: A1 A1       LDA  ($A1,X)

L_6A6B:
    $6A6B: 00          BRK  
    $6A6C: A5 A9       LDA  $A9
    $6A6E: 00          BRK  
    $6A6F: 95 AA       STA  $AA,X
    $6A71: 00          BRK  
    $6A72: D5 AA       CMP  $AA,X
    $6A74: 00          BRK  
    $6A75: 95 AA       STA  $AA,X
    $6A77: 00          BRK  
    $6A78: A5 A9       LDA  $A9
    $6A7A: 00          BRK  

L_6A7B:
    $6A7B: A1 A1       LDA  ($A1,X)
    $6A7D: 84 85       STY  $85
    $6A7F: 81 94       STA  ($94,X)
    $6A81: A5 81       LDA  $81
    $6A83: D4          .BYTE $D4
    $6A84: A8          TAY  
    $6A85: 81 D4       STA  ($D4,X)
    $6A87: AA          TAX  
    $6A88: 81 D4       STA  ($D4,X)
    $6A8A: A8          TAY  
    $6A8B: 81 94       STA  ($94,X)
    $6A8D: A5 81       LDA  $81
    $6A8F: 84 85       STY  $85
    $6A91: 81 90       STA  ($90,X)
    $6A93: 94 84       STY  $84,X
    $6A95: D0 94       BNE  L_6A2B
    $6A97: 85 D0       STA  $D0
    $6A99: A2 85       LDX  #$85
    $6A9B: D0 AA       BNE  L_6A47
    $6A9D: 85 D0       STA  $D0
    $6A9F: A2 85       LDX  #$85
    $6AA1: D0 94       BNE  L_6A37
    $6AA3: 85 90       STA  $90
    $6AA5: 94 84       STY  $84,X
    $6AA7: C0 D0       CPY  #$D0
    $6AA9: 90 C0       BCC  L_6A6B
    $6AAB: D2          .BYTE $D2
    $6AAC: 94 C0       STY  $C0,X
    $6AAE: 8A          TXA  
    $6AAF: 95 C0       STA  $C0,X
    $6AB1: AA          TAX  
    $6AB2: 95 C0       STA  $C0,X
    $6AB4: 8A          TXA  
    $6AB5: 95 C0       STA  $C0,X
    $6AB7: D2          .BYTE $D2
    $6AB8: 94 C0       STY  $C0,X
    $6ABA: D0 90       BNE  L_6A4C
    $6ABC: 22          .BYTE $22
    $6ABD: 77          .BYTE $77
    $6ABE: 7F          .BYTE $7F
    $6ABF: 3E 1C 08    ROL  $081C,X
    $6AC2: 44          .BYTE $44
    $6AC3: 00          BRK  
    $6AC4: 6E 01 7E    ROR  $7E01
    $6AC7: 01 7C       ORA  ($7C,X)
    $6AC9: 00          BRK  
    $6ACA: 38          SEC  
    $6ACB: 00          BRK  
    $6ACC: 10 00       BPL  L_6ACE

L_6ACE:
    $6ACE: 08          PHP  
    $6ACF: 01 5C       ORA  ($5C,X)
    $6AD1: 03          .BYTE $03
    $6AD2: 7C          .BYTE $7C
    $6AD3: 03          .BYTE $03
    $6AD4: 78          SEI  
    $6AD5: 01 70       ORA  ($70,X)
    $6AD7: 00          BRK  
    $6AD8: 20 00 10    JSR  $1000
    $6ADB: 02          .BYTE $02
    $6ADC: 38          SEC  
    $6ADD: 07          .BYTE $07
    $6ADE: 78          SEI  
    $6ADF: 07          .BYTE $07
    $6AE0: 70 03       BVS  L_6AE5
    $6AE2: 60          RTS  
    $6AE3: 01 40       ORA  ($40,X)

L_6AE5:
    $6AE5: 00          BRK  
    $6AE6: 20 04 70    JSR  $7004
    $6AE9: 0E 70 0F    ASL  $0F70
    $6AEC: 60          RTS  
    $6AED: 07          .BYTE $07
    $6AEE: 40          RTI  
    $6AEF: 03          .BYTE $03
    $6AF0: 00          BRK  
    $6AF1: 01 40       ORA  ($40,X)
    $6AF3: 08          PHP  
    $6AF4: 60          RTS  
    $6AF5: 1D 60 1F    ORA  $1F60,X
    $6AF8: 40          RTI  
    $6AF9: 0F          .BYTE $0F
    $6AFA: 00          BRK  
    $6AFB: 07          .BYTE $07
    $6AFC: 00          BRK  
    $6AFD: 02          .BYTE $02
    $6AFE: 00          BRK  
    $6AFF: 11 40       ORA  ($40),Y
    $6B01: 3B          .BYTE $3B
    $6B02: 40          RTI  
    $6B03: 3F          .BYTE $3F
    $6B04: 00          BRK  
    $6B05: 1F          .BYTE $1F
    $6B06: 00          BRK  
    $6B07: 0E 00 04    ASL  $0400
    $6B0A: 08          PHP  
    $6B0B: 1C          .BYTE $1C
    $6B0C: 3E 7F 77    ROL  $777F,X
    $6B0F: 22          .BYTE $22
    $6B10: 10 00       BPL  L_6B12

L_6B12:
    $6B12: 38          SEC  
    $6B13: 00          BRK  
    $6B14: 7C          .BYTE $7C
    $6B15: 00          BRK  
    $6B16: 7E 01 6E    ROR  $6E01,X
    $6B19: 01 44       ORA  ($44,X)
    $6B1B: 00          BRK  
    $6B1C: 20 00 70    JSR  $7000
    $6B1F: 00          BRK  
    $6B20: 78          SEI  
    $6B21: 01 7C       ORA  ($7C,X)
    $6B23: 03          .BYTE $03
    $6B24: 5C          .BYTE $5C
    $6B25: 03          .BYTE $03
    $6B26: 08          PHP  
    $6B27: 01 40       ORA  ($40,X)
    $6B29: 00          BRK  
    $6B2A: 60          RTS  
    $6B2B: 01 70       ORA  ($70,X)
    $6B2D: 03          .BYTE $03
    $6B2E: 78          SEI  
    $6B2F: 07          .BYTE $07
    $6B30: 38          SEC  
    $6B31: 07          .BYTE $07
    $6B32: 10 02       BPL  L_6B36
    $6B34: 00          BRK  
    $6B35: 01 40       ORA  ($40,X)
    $6B37: 03          .BYTE $03
    $6B38: 60          RTS  
    $6B39: 07          .BYTE $07
    $6B3A: 70 0F       BVS  L_6B4B
    $6B3C: 70 0E       BVS  L_6B4C
    $6B3E: 20 04 00    JSR  $0004
    $6B41: 02          .BYTE $02
    $6B42: 00          BRK  
    $6B43: 07          .BYTE $07
    $6B44: 40          RTI  
    $6B45: 0F          .BYTE $0F
    $6B46: 60          RTS  
    $6B47: 1F          .BYTE $1F
    $6B48: 60          RTS  
    $6B49: 1D 40 08    ORA  $0840,X

L_6B4C:
    $6B4C: 00          BRK  
    $6B4D: 04          .BYTE $04
    $6B4E: 00          BRK  
    $6B4F: 0E 00 1F    ASL  $1F00
    $6B52: 40          RTI  
    $6B53: 3F          .BYTE $3F
    $6B54: 40          RTI  
    $6B55: 3B          .BYTE $3B
    $6B56: 00          BRK  
    $6B57: 11 40       ORA  ($40),Y
    $6B59: 00          BRK  
    $6B5A: 04          .BYTE $04
    $6B5B: 00          BRK  
    $6B5C: 00          BRK  
    $6B5D: 01 02       ORA  ($02,X)
    $6B5F: 00          BRK  
    $6B60: 00          BRK  
    $6B61: 02          .BYTE $02
    $6B62: 01 00       ORA  ($00,X)
    $6B64: 00          BRK  
    $6B65: 44          .BYTE $44
    $6B66: 00          BRK  
    $6B67: 00          BRK  
    $6B68: 00          BRK  
    $6B69: 28          PLP  
    $6B6A: 00          BRK  
    $6B6B: 00          BRK  
    $6B6C: 00          BRK  
    $6B6D: 10 00       BPL  L_6B6F

L_6B6F:
    $6B6F: 00          BRK  
    $6B70: 7F          .BYTE $7F
    $6B71: 7F          .BYTE $7F
    $6B72: 7F          .BYTE $7F
    $6B73: 03          .BYTE $03
    $6B74: 7F          .BYTE $7F
    $6B75: 7F          .BYTE $7F
    $6B76: 7F          .BYTE $7F
    $6B77: 03          .BYTE $03
    $6B78: 03          .BYTE $03
    $6B79: 00          BRK  
    $6B7A: 1C          .BYTE $1C
    $6B7B: 03          .BYTE $03
    $6B7C: 03          .BYTE $03
    $6B7D: 00          BRK  
    $6B7E: 1C          .BYTE $1C
    $6B7F: 03          .BYTE $03
    $6B80: 03          .BYTE $03
    $6B81: 00          BRK  
    $6B82: 7C          .BYTE $7C
    $6B83: 03          .BYTE $03
    $6B84: 03          .BYTE $03
    $6B85: 00          BRK  
    $6B86: 7C          .BYTE $7C
    $6B87: 03          .BYTE $03
    $6B88: 03          .BYTE $03
    $6B89: 00          BRK  
    $6B8A: 1C          .BYTE $1C
    $6B8B: 03          .BYTE $03
    $6B8C: 03          .BYTE $03
    $6B8D: 00          BRK  
    $6B8E: 1C          .BYTE $1C
    $6B8F: 03          .BYTE $03
    $6B90: 03          .BYTE $03
    $6B91: 00          BRK  
    $6B92: 7C          .BYTE $7C
    $6B93: 03          .BYTE $03
    $6B94: 03          .BYTE $03
    $6B95: 00          BRK  
    $6B96: 7C          .BYTE $7C
    $6B97: 03          .BYTE $03
    $6B98: 03          .BYTE $03
    $6B99: 00          BRK  
    $6B9A: 7C          .BYTE $7C
    $6B9B: 03          .BYTE $03
    $6B9C: 03          .BYTE $03
    $6B9D: 00          BRK  
    $6B9E: 7C          .BYTE $7C
    $6B9F: 03          .BYTE $03
    $6BA0: 03          .BYTE $03
    $6BA1: 00          BRK  
    $6BA2: 7C          .BYTE $7C
    $6BA3: 03          .BYTE $03
    $6BA4: 03          .BYTE $03
    $6BA5: 00          BRK  
    $6BA6: 7C          .BYTE $7C
    $6BA7: 03          .BYTE $03
    $6BA8: 03          .BYTE $03
    $6BA9: 00          BRK  
    $6BAA: 7C          .BYTE $7C
    $6BAB: 03          .BYTE $03
    $6BAC: 03          .BYTE $03
    $6BAD: 00          BRK  
    $6BAE: 7C          .BYTE $7C
    $6BAF: 03          .BYTE $03
    $6BB0: 7F          .BYTE $7F
    $6BB1: 7F          .BYTE $7F
    $6BB2: 7F          .BYTE $7F
    $6BB3: 03          .BYTE $03
    $6BB4: 7F          .BYTE $7F
    $6BB5: 7F          .BYTE $7F
    $6BB6: 7F          .BYTE $7F
    $6BB7: 03          .BYTE $03
    $6BB8: 00          BRK  
    $6BB9: 08          PHP  
    $6BBA: 40          RTI  
    $6BBB: 00          BRK  
    $6BBC: 00          BRK  
    $6BBD: 10 20       BPL  L_6BDF
    $6BBF: 00          BRK  
    $6BC0: 00          BRK  
    $6BC1: 20 10 00    JSR  $0010
    $6BC4: 00          BRK  
    $6BC5: 40          RTI  
    $6BC6: 08          PHP  
    $6BC7: 00          BRK  
    $6BC8: 00          BRK  
    $6BC9: 00          BRK  
    $6BCA: 05 00       ORA  $00
    $6BCC: 00          BRK  
    $6BCD: 00          BRK  
    $6BCE: 02          .BYTE $02
    $6BCF: 00          BRK  
    $6BD0: 70 7F       BVS  L_6C51
    $6BD2: 7F          .BYTE $7F
    $6BD3: 3F          .BYTE $3F
    $6BD4: 70 7F       BVS  L_6C55
    $6BD6: 7F          .BYTE $7F
    $6BD7: 3F          .BYTE $3F
    $6BD8: 30 00       BMI  L_6BDA

L_6BDA:
    $6BDA: 40          RTI  
    $6BDB: 33          .BYTE $33
    $6BDC: 30 00       BMI  L_6BDE

L_6BDE:
    $6BDE: 40          RTI  

L_6BDF:
    $6BDF: 33          .BYTE $33
    $6BE0: 30 00       BMI  L_6BE2

L_6BE2:
    $6BE2: 40          RTI  
    $6BE3: 3F          .BYTE $3F
    $6BE4: 30 00       BMI  L_6BE6

L_6BE6:
    $6BE6: 40          RTI  
    $6BE7: 3F          .BYTE $3F
    $6BE8: 30 00       BMI  L_6BEA

L_6BEA:
    $6BEA: 40          RTI  
    $6BEB: 33          .BYTE $33
    $6BEC: 30 00       BMI  L_6BEE

L_6BEE:
    $6BEE: 40          RTI  
    $6BEF: 33          .BYTE $33
    $6BF0: 30 00       BMI  L_6BF2

L_6BF2:
    $6BF2: 40          RTI  
    $6BF3: 3F          .BYTE $3F
    $6BF4: 30 00       BMI  L_6BF6

L_6BF6:
    $6BF6: 40          RTI  
    $6BF7: 3F          .BYTE $3F
    $6BF8: 30 00       BMI  L_6BFA

L_6BFA:
    $6BFA: 40          RTI  
    $6BFB: 3F          .BYTE $3F
    $6BFC: 30 00       BMI  L_6BFE

L_6BFE:
    $6BFE: 40          RTI  
    $6BFF: 3F          .BYTE $3F
    $6C00: 30 00       BMI  L_6C02

L_6C02:
    $6C02: 40          RTI  
    $6C03: 3F          .BYTE $3F
    $6C04: 30 00       BMI  L_6C06

L_6C06:
    $6C06: 40          RTI  
    $6C07: 3F          .BYTE $3F
    $6C08: 30 00       BMI  L_6C0A

L_6C0A:
    $6C0A: 40          RTI  
    $6C0B: 3F          .BYTE $3F
    $6C0C: 30 00       BMI  L_6C0E

L_6C0E:
    $6C0E: 40          RTI  
    $6C0F: 3F          .BYTE $3F
    $6C10: 70 7F       BVS  L_6C91
    $6C12: 7F          .BYTE $7F
    $6C13: 3F          .BYTE $3F
    $6C14: 70 7F       BVS  L_6C95
    $6C16: 7F          .BYTE $7F
    $6C17: 3F          .BYTE $3F
    $6C18: 00          BRK  
    $6C19: 02          .BYTE $02
    $6C1A: 10 00       BPL  L_6C1C

L_6C1C:
    $6C1C: 00          BRK  
    $6C1D: 04          .BYTE $04
    $6C1E: 08          PHP  
    $6C1F: 00          BRK  
    $6C20: 00          BRK  
    $6C21: 08          PHP  
    $6C22: 04          .BYTE $04
    $6C23: 00          BRK  
    $6C24: 00          BRK  
    $6C25: 10 02       BPL  L_6C29
    $6C27: 00          BRK  
    $6C28: 00          BRK  

L_6C29:
    $6C29: 20 01 00    JSR  $0001
    $6C2C: 00          BRK  
    $6C2D: 40          RTI  
    $6C2E: 00          BRK  
    $6C2F: 00          BRK  
    $6C30: 7C          .BYTE $7C
    $6C31: 7F          .BYTE $7F
    $6C32: 7F          .BYTE $7F
    $6C33: 0F          .BYTE $0F
    $6C34: 7C          .BYTE $7C
    $6C35: 7F          .BYTE $7F
    $6C36: 7F          .BYTE $7F
    $6C37: 0F          .BYTE $0F
    $6C38: 0C          .BYTE $0C
    $6C39: 00          BRK  
    $6C3A: 70 0C       BVS  L_6C48
    $6C3C: 0C          .BYTE $0C
    $6C3D: 00          BRK  
    $6C3E: 70 0C       BVS  L_6C4C
    $6C40: 0C          .BYTE $0C
    $6C41: 00          BRK  
    $6C42: 70 0F       BVS  L_6C53
    $6C44: 0C          .BYTE $0C
    $6C45: 00          BRK  
    $6C46: 70 0F       BVS  L_6C57

L_6C48:
    $6C48: 0C          .BYTE $0C
    $6C49: 00          BRK  
    $6C4A: 70 0C       BVS  L_6C58

L_6C4C:
    $6C4C: 0C          .BYTE $0C
    $6C4D: 00          BRK  
    $6C4E: 70 0C       BVS  L_6C5C
    $6C50: 0C          .BYTE $0C

L_6C51:
    $6C51: 00          BRK  
    $6C52: 70 0F       BVS  L_6C63
    $6C54: 0C          .BYTE $0C

L_6C55:
    $6C55: 00          BRK  
    $6C56: 70 0F       BVS  L_6C67

L_6C58:
    $6C58: 0C          .BYTE $0C
    $6C59: 00          BRK  
    $6C5A: 70 0F       BVS  L_6C6B

L_6C5C:
    $6C5C: 0C          .BYTE $0C
    $6C5D: 00          BRK  
    $6C5E: 70 0F       BVS  L_6C6F
    $6C60: 0C          .BYTE $0C
    $6C61: 00          BRK  
    $6C62: 70 0F       BVS  L_6C73
    $6C64: 0C          .BYTE $0C
    $6C65: 00          BRK  
    $6C66: 70 0F       BVS  L_6C77
    $6C68: 0C          .BYTE $0C
    $6C69: 00          BRK  
    $6C6A: 70 0F       BVS  L_6C7B
    $6C6C: 0C          .BYTE $0C
    $6C6D: 00          BRK  
    $6C6E: 70 0F       BVS  L_6C7F
    $6C70: 7C          .BYTE $7C
    $6C71: 7F          .BYTE $7F
    $6C72: 7F          .BYTE $7F

L_6C73:
    $6C73: 0F          .BYTE $0F
    $6C74: 7C          .BYTE $7C
    $6C75: 7F          .BYTE $7F
    $6C76: 7F          .BYTE $7F

L_6C77:
    $6C77: 0F          .BYTE $0F
    $6C78: 00          BRK  
    $6C79: 20 00 02    JSR  $0200
    $6C7C: 00          BRK  
    $6C7D: 00          BRK  
    $6C7E: 40          RTI  

L_6C7F:
    $6C7F: 00          BRK  
    $6C80: 01 00       ORA  ($00,X)
    $6C82: 00          BRK  
    $6C83: 00          BRK  
    $6C84: 41 00       EOR  ($00,X)
    $6C86: 00          BRK  
    $6C87: 00          BRK  
    $6C88: 00          BRK  
    $6C89: 22          .BYTE $22
    $6C8A: 00          BRK  
    $6C8B: 00          BRK  
    $6C8C: 00          BRK  
    $6C8D: 00          BRK  
    $6C8E: 14          .BYTE $14
    $6C8F: 00          BRK  
    $6C90: 00          BRK  

L_6C91:
    $6C91: 00          BRK  
    $6C92: 00          BRK  
    $6C93: 08          PHP  
    $6C94: 00          BRK  

L_6C95:
    $6C95: 00          BRK  
    $6C96: 40          RTI  
    $6C97: 7F          .BYTE $7F
    $6C98: 7F          .BYTE $7F
    $6C99: 7F          .BYTE $7F
    $6C9A: 01 40       ORA  ($40,X)
    $6C9C: 7F          .BYTE $7F
    $6C9D: 7F          .BYTE $7F
    $6C9E: 7F          .BYTE $7F
    $6C9F: 01 40       ORA  ($40,X)
    $6CA1: 01 00       ORA  ($00,X)
    $6CA3: 4E 01 40    LSR  $4001
    $6CA6: 01 00       ORA  ($00,X)
    $6CA8: 4E 01 40    LSR  $4001
    $6CAB: 01 00       ORA  ($00,X)
    $6CAD: 7E 01 40    ROR  $4001,X
    $6CB0: 01 00       ORA  ($00,X)
    $6CB2: 7E 01 40    ROR  $4001,X
    $6CB5: 01 00       ORA  ($00,X)
    $6CB7: 4E 01 40    LSR  $4001
    $6CBA: 01 00       ORA  ($00,X)
    $6CBC: 4E 01 40    LSR  $4001
    $6CBF: 01 00       ORA  ($00,X)
    $6CC1: 7E 01 40    ROR  $4001,X
    $6CC4: 01 00       ORA  ($00,X)
    $6CC6: 7E 01 40    ROR  $4001,X
    $6CC9: 01 00       ORA  ($00,X)
    $6CCB: 7E 01 40    ROR  $4001,X
    $6CCE: 01 00       ORA  ($00,X)
    $6CD0: 7E 01 40    ROR  $4001,X
    $6CD3: 01 00       ORA  ($00,X)
    $6CD5: 7E 01 40    ROR  $4001,X
    $6CD8: 01 00       ORA  ($00,X)
    $6CDA: 7E 01 40    ROR  $4001,X
    $6CDD: 01 00       ORA  ($00,X)
    $6CDF: 7E 01 40    ROR  $4001,X
    $6CE2: 01 00       ORA  ($00,X)
    $6CE4: 7E 01 40    ROR  $4001,X
    $6CE7: 7F          .BYTE $7F
    $6CE8: 7F          .BYTE $7F
    $6CE9: 7F          .BYTE $7F
    $6CEA: 01 40       ORA  ($40,X)
    $6CEC: 7F          .BYTE $7F
    $6CED: 7F          .BYTE $7F
    $6CEE: 7F          .BYTE $7F
    $6CEF: 01 00       ORA  ($00,X)
    $6CF1: 01 08       ORA  ($08,X)
    $6CF3: 00          BRK  
    $6CF4: 00          BRK  
    $6CF5: 02          .BYTE $02
    $6CF6: 04          .BYTE $04
    $6CF7: 00          BRK  
    $6CF8: 00          BRK  
    $6CF9: 04          .BYTE $04
    $6CFA: 02          .BYTE $02
    $6CFB: 00          BRK  
    $6CFC: 00          BRK  
    $6CFD: 08          PHP  
    $6CFE: 01 00       ORA  ($00,X)
    $6D00: 00          BRK  
    $6D01: 50 00       BVC  L_6D03

L_6D03:
    $6D03: 00          BRK  
    $6D04: 00          BRK  
    $6D05: 20 00 00    JSR  $0000
    $6D08: 7E 7F 7F    ROR  $7F7F,X
    $6D0B: 07          .BYTE $07
    $6D0C: 7E 7F 7F    ROR  $7F7F,X
    $6D0F: 07          .BYTE $07
    $6D10: 06 00       ASL  $00
    $6D12: 38          SEC  
    $6D13: 06 06       ASL  $06
    $6D15: 00          BRK  
    $6D16: 38          SEC  
    $6D17: 06 06       ASL  $06
    $6D19: 00          BRK  
    $6D1A: 78          SEI  
    $6D1B: 07          .BYTE $07
    $6D1C: 06 00       ASL  $00
    $6D1E: 78          SEI  
    $6D1F: 07          .BYTE $07
    $6D20: 06 00       ASL  $00
    $6D22: 38          SEC  
    $6D23: 06 06       ASL  $06
    $6D25: 00          BRK  
    $6D26: 38          SEC  
    $6D27: 06 06       ASL  $06
    $6D29: 00          BRK  
    $6D2A: 78          SEI  
    $6D2B: 07          .BYTE $07
    $6D2C: 06 00       ASL  $00
    $6D2E: 78          SEI  
    $6D2F: 07          .BYTE $07
    $6D30: 06 00       ASL  $00
    $6D32: 78          SEI  
    $6D33: 07          .BYTE $07
    $6D34: 06 00       ASL  $00
    $6D36: 78          SEI  
    $6D37: 07          .BYTE $07
    $6D38: 06 00       ASL  $00
    $6D3A: 78          SEI  
    $6D3B: 07          .BYTE $07
    $6D3C: 06 00       ASL  $00
    $6D3E: 78          SEI  
    $6D3F: 07          .BYTE $07
    $6D40: 06 00       ASL  $00
    $6D42: 78          SEI  
    $6D43: 07          .BYTE $07
    $6D44: 06 00       ASL  $00
    $6D46: 78          SEI  
    $6D47: 07          .BYTE $07
    $6D48: 7E 7F 7F    ROR  $7F7F,X
    $6D4B: 07          .BYTE $07
    $6D4C: 7E 7F 7F    ROR  $7F7F,X
    $6D4F: 07          .BYTE $07
    $6D50: 00          BRK  
    $6D51: 04          .BYTE $04
    $6D52: 20 00 00    JSR  $0000
    $6D55: 08          PHP  
    $6D56: 10 00       BPL  L_6D58

L_6D58:
    $6D58: 00          BRK  
    $6D59: 10 08       BPL  L_6D63
    $6D5B: 00          BRK  
    $6D5C: 00          BRK  
    $6D5D: 20 04 00    JSR  $0004
    $6D60: 00          BRK  
    $6D61: 40          RTI  
    $6D62: 02          .BYTE $02

L_6D63:
    $6D63: 00          BRK  
    $6D64: 00          BRK  
    $6D65: 00          BRK  
    $6D66: 01 00       ORA  ($00,X)
    $6D68: 78          SEI  
    $6D69: 7F          .BYTE $7F
    $6D6A: 7F          .BYTE $7F
    $6D6B: 1F          .BYTE $1F
    $6D6C: 78          SEI  
    $6D6D: 7F          .BYTE $7F
    $6D6E: 7F          .BYTE $7F
    $6D6F: 1F          .BYTE $1F
    $6D70: 18          CLC  
    $6D71: 00          BRK  
    $6D72: 60          RTS  
    $6D73: 19 18 00    ORA  $0018,Y
    $6D76: 60          RTS  
    $6D77: 19 18 00    ORA  $0018,Y
    $6D7A: 60          RTS  
    $6D7B: 1F          .BYTE $1F
    $6D7C: 18          CLC  
    $6D7D: 00          BRK  
    $6D7E: 60          RTS  
    $6D7F: 1F          .BYTE $1F
    $6D80: 18          CLC  
    $6D81: 00          BRK  
    $6D82: 60          RTS  
    $6D83: 19 18 00    ORA  $0018,Y
    $6D86: 60          RTS  
    $6D87: 19 18 00    ORA  $0018,Y
    $6D8A: 60          RTS  
    $6D8B: 1F          .BYTE $1F
    $6D8C: 18          CLC  
    $6D8D: 00          BRK  
    $6D8E: 60          RTS  
    $6D8F: 1F          .BYTE $1F
    $6D90: 18          CLC  
    $6D91: 00          BRK  
    $6D92: 60          RTS  
    $6D93: 1F          .BYTE $1F
    $6D94: 18          CLC  
    $6D95: 00          BRK  
    $6D96: 60          RTS  
    $6D97: 1F          .BYTE $1F
    $6D98: 18          CLC  
    $6D99: 00          BRK  
    $6D9A: 60          RTS  
    $6D9B: 1F          .BYTE $1F
    $6D9C: 18          CLC  
    $6D9D: 00          BRK  
    $6D9E: 60          RTS  
    $6D9F: 1F          .BYTE $1F
    $6DA0: 18          CLC  
    $6DA1: 00          BRK  
    $6DA2: 60          RTS  
    $6DA3: 1F          .BYTE $1F
    $6DA4: 18          CLC  
    $6DA5: 00          BRK  
    $6DA6: 60          RTS  
    $6DA7: 1F          .BYTE $1F
    $6DA8: 78          SEI  
    $6DA9: 7F          .BYTE $7F
    $6DAA: 7F          .BYTE $7F
    $6DAB: 1F          .BYTE $1F
    $6DAC: 78          SEI  
    $6DAD: 7F          .BYTE $7F
    $6DAE: 7F          .BYTE $7F
    $6DAF: 1F          .BYTE $1F
    $6DB0: 00          BRK  
    $6DB1: 10 00       BPL  L_6DB3

L_6DB3:
    $6DB3: 00          BRK  
    $6DB4: 00          BRK  
    $6DB5: 20 40 00    JSR  $0040
    $6DB8: 00          BRK  
    $6DB9: 40          RTI  
    $6DBA: 20 00 00    JSR  $0000
    $6DBD: 00          BRK  
    $6DBE: 11 00       ORA  ($00),Y
    $6DC0: 00          BRK  
    $6DC1: 00          BRK  
    $6DC2: 0A          ASL  
    $6DC3: 00          BRK  
    $6DC4: 00          BRK  
    $6DC5: 00          BRK  
    $6DC6: 04          .BYTE $04
    $6DC7: 00          BRK  
    $6DC8: 60          RTS  
    $6DC9: 7F          .BYTE $7F
    $6DCA: 7F          .BYTE $7F
    $6DCB: 7F          .BYTE $7F
    $6DCC: 60          RTS  
    $6DCD: 7F          .BYTE $7F
    $6DCE: 7F          .BYTE $7F
    $6DCF: 7F          .BYTE $7F
    $6DD0: 60          RTS  
    $6DD1: 00          BRK  
    $6DD2: 00          BRK  
    $6DD3: 67          .BYTE $67
    $6DD4: 60          RTS  
    $6DD5: 00          BRK  
    $6DD6: 00          BRK  
    $6DD7: 67          .BYTE $67
    $6DD8: 60          RTS  
    $6DD9: 00          BRK  
    $6DDA: 00          BRK  
    $6DDB: 7F          .BYTE $7F
    $6DDC: 60          RTS  
    $6DDD: 00          BRK  
    $6DDE: 00          BRK  
    $6DDF: 7F          .BYTE $7F
    $6DE0: 60          RTS  
    $6DE1: 00          BRK  
    $6DE2: 00          BRK  
    $6DE3: 67          .BYTE $67
    $6DE4: 60          RTS  
    $6DE5: 00          BRK  
    $6DE6: 00          BRK  
    $6DE7: 67          .BYTE $67
    $6DE8: 60          RTS  
    $6DE9: 00          BRK  
    $6DEA: 00          BRK  
    $6DEB: 7F          .BYTE $7F
    $6DEC: 60          RTS  
    $6DED: 00          BRK  
    $6DEE: 00          BRK  
    $6DEF: 7F          .BYTE $7F
    $6DF0: 60          RTS  
    $6DF1: 00          BRK  
    $6DF2: 00          BRK  
    $6DF3: 7F          .BYTE $7F
    $6DF4: 60          RTS  
    $6DF5: 00          BRK  
    $6DF6: 00          BRK  
    $6DF7: 7F          .BYTE $7F
    $6DF8: 60          RTS  
    $6DF9: 00          BRK  
    $6DFA: 00          BRK  
    $6DFB: 7F          .BYTE $7F
    $6DFC: 60          RTS  
    $6DFD: 00          BRK  
    $6DFE: 00          BRK  
    $6DFF: 7F          .BYTE $7F
    $6E00: 60          RTS  
    $6E01: 00          BRK  
    $6E02: 00          BRK  
    $6E03: 7F          .BYTE $7F
    $6E04: 60          RTS  
    $6E05: 00          BRK  
    $6E06: 00          BRK  
    $6E07: 7F          .BYTE $7F
    $6E08: 60          RTS  
    $6E09: 7F          .BYTE $7F
    $6E0A: 7F          .BYTE $7F
    $6E0B: 7F          .BYTE $7F
    $6E0C: 60          RTS  
    $6E0D: 7F          .BYTE $7F
    $6E0E: 7F          .BYTE $7F
    $6E0F: 7F          .BYTE $7F
    $6E10: 03          .BYTE $03
    $6E11: 3F          .BYTE $3F
    $6E12: 33          .BYTE $33
    $6E13: 3F          .BYTE $3F
    $6E14: 03          .BYTE $03
    $6E15: 03          .BYTE $03
    $6E16: 3F          .BYTE $3F
    $6E17: 33          .BYTE $33
    $6E18: 3F          .BYTE $3F
    $6E19: 03          .BYTE $03
    $6E1A: 03          .BYTE $03
    $6E1B: 03          .BYTE $03
    $6E1C: 33          .BYTE $33
    $6E1D: 03          .BYTE $03
    $6E1E: 03          .BYTE $03
    $6E1F: 03          .BYTE $03
    $6E20: 1F          .BYTE $1F
    $6E21: 33          .BYTE $33
    $6E22: 1F          .BYTE $1F
    $6E23: 03          .BYTE $03
    $6E24: 03          .BYTE $03
    $6E25: 03          .BYTE $03
    $6E26: 33          .BYTE $33
    $6E27: 03          .BYTE $03
    $6E28: 03          .BYTE $03
    $6E29: 3F          .BYTE $3F
    $6E2A: 3F          .BYTE $3F
    $6E2B: 1E 3F 3F    ASL  $3F3F,X
    $6E2E: 3F          .BYTE $3F
    $6E2F: 3F          .BYTE $3F
    $6E30: 0C          .BYTE $0C
    $6E31: 3F          .BYTE $3F
    $6E32: 3F          .BYTE $3F
    $6E33: 33          .BYTE $33
    $6E34: 1E 33 40    ASL  $4033,X
    $6E37: 31 3F       AND  ($3F),Y
    $6E39: 33          .BYTE $33
    $6E3A: 00          BRK  
    $6E3B: 1C          .BYTE $1C
    $6E3C: 33          .BYTE $33
    $6E3D: 1E 33 40    ASL  $4033,X
    $6E40: 31 3F       AND  ($3F),Y
    $6E42: 33          .BYTE $33
    $6E43: 00          BRK  
    $6E44: 1C          .BYTE $1C
    $6E45: 33          .BYTE $33
    $6E46: 3F          .BYTE $3F
    $6E47: 33          .BYTE $33
    $6E48: 40          RTI  
    $6E49: 31 3F       AND  ($3F),Y
    $6E4B: 33          .BYTE $33
    $6E4C: 00          BRK  
    $6E4D: 1C          .BYTE $1C
    $6E4E: 33          .BYTE $33
    $6E4F: 3F          .BYTE $3F
    $6E50: 33          .BYTE $33
    $6E51: 40          RTI  
    $6E52: 31 3F       AND  ($3F),Y
    $6E54: 33          .BYTE $33
    $6E55: 00          BRK  

L_6E56:
    $6E56: 1C          .BYTE $1C
    $6E57: 33          .BYTE $33
    $6E58: 33          .BYTE $33
    $6E59: 33          .BYTE $33
    $6E5A: 40          RTI  
    $6E5B: 31 0C       AND  ($0C),Y
    $6E5D: 37          .BYTE $37
    $6E5E: 00          BRK  
    $6E5F: 1C          .BYTE $1C
    $6E60: 33          .BYTE $33
    $6E61: 33          .BYTE $33
    $6E62: 33          .BYTE $33
    $6E63: 40          RTI  
    $6E64: 31 0C       AND  ($0C),Y
    $6E66: 37          .BYTE $37
    $6E67: 00          BRK  
    $6E68: 1C          .BYTE $1C
    $6E69: 1E 33 33    ASL  $3333,X
    $6E6C: 40          RTI  
    $6E6D: 35 0C       AND  $0C,X
    $6E6F: 3F          .BYTE $3F
    $6E70: 00          BRK  

L_6E71:
    $6E71: 1C          .BYTE $1C
    $6E72: 1E 33 33    ASL  $3333,X
    $6E75: 40          RTI  
    $6E76: 35 0C       AND  $0C,X
    $6E78: 3F          .BYTE $3F
    $6E79: 00          BRK  
    $6E7A: 1C          .BYTE $1C
    $6E7B: 0C          .BYTE $0C
    $6E7C: 33          .BYTE $33
    $6E7D: 33          .BYTE $33
    $6E7E: 40          RTI  
    $6E7F: 35 0C       AND  $0C,X
    $6E81: 3B          .BYTE $3B
    $6E82: 00          BRK  

L_6E83:
    $6E83: 00          BRK  
    $6E84: 0C          .BYTE $0C
    $6E85: 33          .BYTE $33

L_6E86:
    $6E86: 33          .BYTE $33
    $6E87: 40          RTI  
    $6E88: 35 0C       AND  $0C,X
    $6E8A: 3B          .BYTE $3B
    $6E8B: 00          BRK  
    $6E8C: 00          BRK  
    $6E8D: 0C          .BYTE $0C
    $6E8E: 3F          .BYTE $3F
    $6E8F: 3F          .BYTE $3F
    $6E90: 40          RTI  
    $6E91: 3B          .BYTE $3B
    $6E92: 3F          .BYTE $3F
    $6E93: 33          .BYTE $33
    $6E94: 00          BRK  
    $6E95: 1C          .BYTE $1C
    $6E96: 0C          .BYTE $0C
    $6E97: 3F          .BYTE $3F
    $6E98: 3F          .BYTE $3F
    $6E99: 40          RTI  
    $6E9A: 3B          .BYTE $3B
    $6E9B: 3F          .BYTE $3F
    $6E9C: 33          .BYTE $33
    $6E9D: 00          BRK  
    $6E9E: 1C          .BYTE $1C
    $6E9F: 0C          .BYTE $0C
    $6EA0: 1E 1E 40    ASL  $401E,X
    $6EA3: 31 3F       AND  ($3F),Y
    $6EA5: 33          .BYTE $33
    $6EA6: 00          BRK  
    $6EA7: 1C          .BYTE $1C
    $6EA8: 0C          .BYTE $0C
    $6EA9: 1E 1E 40    ASL  $401E,X
    $6EAC: 31 3F       AND  ($3F),Y
    $6EAE: 33          .BYTE $33
    $6EAF: 00          BRK  
    $6EB0: 1C          .BYTE $1C
    $6EB1: 18          CLC  
    $6EB2: 00          BRK  
    $6EB3: 3C          .BYTE $3C
    $6EB4: 00          BRK  

L_6EB5:
    $6EB5: 19 01 7F    ORA  $7F01,Y
    $6EB8: 01 18       ORA  ($18,X)
    $6EBA: 00          BRK  
    $6EBB: 18          CLC  
    $6EBC: 00          BRK  
    $6EBD: 3C          .BYTE $3C
    $6EBE: 00          BRK  
    $6EBF: 24 00       BIT  $00
    $6EC1: 24 00       BIT  $00
    $6EC3: 24 00       BIT  $00
    $6EC5: FE FF 8F    INC  $8FFF,X
    $6EC8: 81 80       STA  ($80,X)
    $6ECA: 90 FF       BCC  L_6ECB
    $6ECC: FF          .BYTE $FF
    $6ECD: 9F          .BYTE $9F
    $6ECE: D5 AA       CMP  $AA,X
    $6ED0: 95 81       STA  $81,X
    $6ED2: 80          .BYTE $80
    $6ED3: 90 81       BCC  L_6E56
    $6ED5: 80          .BYTE $80
    $6ED6: 90 DD       BCC  L_6EB5
    $6ED8: BB          .BYTE $BB
    $6ED9: 97          .BYTE $97
    $6EDA: D5 88       CMP  $88,X
    $6EDC: 95 CD       STA  $CD,X
    $6EDE: 99 93 D5    STA  $D593,Y
    $6EE1: 88          DEY  
    $6EE2: 95 DD       STA  $DD,X
    $6EE4: BB          .BYTE $BB
    $6EE5: 95 81       STA  $81,X

L_6EE7:
    $6EE7: 80          .BYTE $80
    $6EE8: 90 81       BCC  L_6E6B
    $6EEA: 80          .BYTE $80

L_6EEB:
    $6EEB: 90 81       BCC  L_6E6E
    $6EED: 80          .BYTE $80
    $6EEE: 90 81       BCC  L_6E71
    $6EF0: 9F          .BYTE $9F
    $6EF1: 90 E1       BCC  L_6ED4
    $6EF3: F5 90       SBC  $90,X
    $6EF5: B9 D5 93    LDA  $93D5,Y
    $6EF8: BD D1 97    LDA  $97D1,X
    $6EFB: B9 D5 93    LDA  $93D5,Y
    $6EFE: E1 F5       SBC  ($F5,X)
    $6F00: 90 81       BCC  L_6E83
    $6F02: 9F          .BYTE $9F

L_6F03:
    $6F03: 90 81       BCC  L_6E86

L_6F05:
    $6F05: 80          .BYTE $80
    $6F06: 90 81       BCC  L_6E89
    $6F08: 80          .BYTE $80

L_6F09:
    $6F09: 90 FE       BCC  L_6F09

L_6F0B:
    $6F0B: FF          .BYTE $FF
    $6F0C: 8F          .BYTE $8F

L_6F0D:
    $6F0D: F8          SED  
    $6F0E: FF          .BYTE $FF
    $6F0F: BF          .BYTE $BF

L_6F10:
    $6F10: 84 80       STY  $80
    $6F12: C0 FC       CPY  #$FC
    $6F14: FF          .BYTE $FF
    $6F15: FF          .BYTE $FF
    $6F16: D4          .BYTE $D4
    $6F17: AA          TAX  
    $6F18: D5 84       CMP  $84,X
    $6F1A: 80          .BYTE $80
    $6F1B: C0 84       CPY  #$84
    $6F1D: 80          .BYTE $80
    $6F1E: C0 F4       CPY  #$F4
    $6F20: EE DD D4    INC  $D4DD
    $6F23: A2 D4       LDX  #$D4
    $6F25: B4 E6       LDY  $E6,X
    $6F27: CC D4 A2    CPY  $A2D4

L_6F2A:
    $6F2A: D4          .BYTE $D4

L_6F2B:
    $6F2B: F4          .BYTE $F4
    $6F2C: EE D5 84    INC  $84D5

L_6F2F:
    $6F2F: 80          .BYTE $80
    $6F30: C0 84       CPY  #$84

L_6F32:
    $6F32: 80          .BYTE $80
    $6F33: C0 84       CPY  #$84
    $6F35: 80          .BYTE $80
    $6F36: C0 84       CPY  #$84
    $6F38: FC          .BYTE $FC
    $6F39: C0 84       CPY  #$84
    $6F3B: D7          .BYTE $D7
    $6F3C: C3          .BYTE $C3
    $6F3D: E4 D5       CPX  $D5
    $6F3F: CE F4 C5    DEC  $C5F4
    $6F42: DE E4 D5    DEC  $D5E4,X
    $6F45: CE 84 D7    DEC  $D784
    $6F48: C3          .BYTE $C3
    $6F49: 84 FC       STY  $FC
    $6F4B: C0 84       CPY  #$84
    $6F4D: 80          .BYTE $80
    $6F4E: C0 84       CPY  #$84
    $6F50: 80          .BYTE $80
    $6F51: C0 F8       CPY  #$F8
    $6F53: FF          .BYTE $FF
    $6F54: BF          .BYTE $BF
    $6F55: E0 FF       CPX  #$FF
    $6F57: FF          .BYTE $FF
    $6F58: 81 90       STA  ($90,X)
    $6F5A: 80          .BYTE $80
    $6F5B: 80          .BYTE $80
    $6F5C: 82          .BYTE $82
    $6F5D: F0 FF       BEQ  L_6F5E
    $6F5F: FF          .BYTE $FF
    $6F60: 83          .BYTE $83
    $6F61: D0 AA       BNE  L_6F0D
    $6F63: D5 82       CMP  $82,X
    $6F65: 90 80       BCC  L_6EE7
    $6F67: 80          .BYTE $80
    $6F68: 82          .BYTE $82
    $6F69: 90 80       BCC  L_6EEB
    $6F6B: 80          .BYTE $80
    $6F6C: 82          .BYTE $82
    $6F6D: D0 BB       BNE  L_6F2A

L_6F6F:
    $6F6F: F7          .BYTE $F7
    $6F70: 82          .BYTE $82
    $6F71: D0 8A       BNE  L_6EFD
    $6F73: D1 82       CMP  ($82),Y
    $6F75: D0 99       BNE  L_6F10
    $6F77: B3          .BYTE $B3
    $6F78: 82          .BYTE $82
    $6F79: D0 8A       BNE  L_6F05
    $6F7B: D1 82       CMP  ($82),Y
    $6F7D: D0 BB       BNE  L_6F3A

L_6F7F:
    $6F7F: D7          .BYTE $D7
    $6F80: 82          .BYTE $82
    $6F81: 90 80       BCC  L_6F03
    $6F83: 80          .BYTE $80
    $6F84: 82          .BYTE $82
    $6F85: 90 80       BCC  L_6F07
    $6F87: 80          .BYTE $80
    $6F88: 82          .BYTE $82
    $6F89: 90 80       BCC  L_6F0B
    $6F8B: 80          .BYTE $80
    $6F8C: 82          .BYTE $82
    $6F8D: 90 F0       BCC  L_6F7F
    $6F8F: 83          .BYTE $83
    $6F90: 82          .BYTE $82
    $6F91: 90 DC       BCC  L_6F6F
    $6F93: 8E 82 90    STX  $9082
    $6F96: D7          .BYTE $D7
    $6F97: BA          TSX  
    $6F98: 82          .BYTE $82
    $6F99: D0 97       BNE  L_6F32
    $6F9B: FA          .BYTE $FA
    $6F9C: 82          .BYTE $82
    $6F9D: 90 D7       BCC  L_6F76
    $6F9F: BA          TSX  
    $6FA0: 82          .BYTE $82
    $6FA1: 90 DC       BCC  L_6F7F
    $6FA3: 8E 82 90    STX  $9082
    $6FA6: F0 83       BEQ  L_6F2B
    $6FA8: 82          .BYTE $82
    $6FA9: 90 80       BCC  L_6F2B
    $6FAB: 80          .BYTE $80
    $6FAC: 82          .BYTE $82
    $6FAD: 90 80       BCC  L_6F2F
    $6FAF: 80          .BYTE $80
    $6FB0: 82          .BYTE $82
    $6FB1: E0 FF       CPX  #$FF
    $6FB3: FF          .BYTE $FF
    $6FB4: 81 80       STA  ($80,X)
    $6FB6: FF          .BYTE $FF
    $6FB7: FF          .BYTE $FF
    $6FB8: 87          .BYTE $87
    $6FB9: C0 80       CPY  #$80
    $6FBB: 80          .BYTE $80
    $6FBC: 88          DEY  
    $6FBD: C0 FF       CPY  #$FF
    $6FBF: FF          .BYTE $FF
    $6FC0: 8F          .BYTE $8F
    $6FC1: C0 AA       CPY  #$AA
    $6FC3: D5 8A       CMP  $8A,X
    $6FC5: C0 80       CPY  #$80
    $6FC7: 80          .BYTE $80
    $6FC8: 88          DEY  
    $6FC9: C0 80       CPY  #$80
    $6FCB: 80          .BYTE $80
    $6FCC: 88          DEY  
    $6FCD: C0 EE       CPY  #$EE
    $6FCF: DD 8B C0    CMP  $C08B,X
    $6FD2: AA          TAX  
    $6FD3: C4 8A       CPY  $8A
    $6FD5: C0 E6       CPY  #$E6
    $6FD7: CC 89 C0    CPY  $C089
    $6FDA: AA          TAX  
    $6FDB: C4 8A       CPY  $8A
    $6FDD: C0 EE       CPY  #$EE
    $6FDF: DD 8A C0    CMP  $C08A,X
    $6FE2: 80          .BYTE $80
    $6FE3: 80          .BYTE $80
    $6FE4: 88          DEY  
    $6FE5: C0 80       CPY  #$80
    $6FE7: 80          .BYTE $80
    $6FE8: 88          DEY  
    $6FE9: C0 80       CPY  #$80
    $6FEB: 80          .BYTE $80
    $6FEC: 88          DEY  
    $6FED: C0 C0       CPY  #$C0
    $6FEF: 8F          .BYTE $8F
    $6FF0: 88          DEY  
    $6FF1: C0 F0       CPY  #$F0
    $6FF3: BA          TSX  
    $6FF4: 88          DEY  
    $6FF5: C0 DC       CPY  #$DC
    $6FF7: EA          NOP  
    $6FF8: 89          .BYTE $89
    $6FF9: C0 DE       CPY  #$DE
    $6FFB: E8          INX  
    $6FFC: 8B          .BYTE $8B
    $6FFD: C0 DC       CPY  #$DC
    $6FFF: EA          NOP  

SUB_7000:
    $7000: 89          .BYTE $89
    $7001: C0 F0       CPY  #$F0
    $7003: BA          TSX  

SUB_7004:
    $7004: 88          DEY  
    $7005: C0 C0       CPY  #$C0
    $7007: 8F          .BYTE $8F
    $7008: 88          DEY  
    $7009: C0 80       CPY  #$80
    $700B: 80          .BYTE $80
    $700C: 88          DEY  
    $700D: C0 80       CPY  #$80
    $700F: 80          .BYTE $80
    $7010: 88          DEY  
    $7011: 80          .BYTE $80
    $7012: FF          .BYTE $FF
    $7013: FF          .BYTE $FF
    $7014: 87          .BYTE $87
    $7015: FC          .BYTE $FC
    $7016: FF          .BYTE $FF
    $7017: 9F          .BYTE $9F
    $7018: 82          .BYTE $82
    $7019: 80          .BYTE $80
    $701A: A0 FE       LDY  #$FE
    $701C: FF          .BYTE $FF
    $701D: BF          .BYTE $BF
    $701E: AA          TAX  
    $701F: D5 AA       CMP  $AA,X
    $7021: 82          .BYTE $82
    $7022: 80          .BYTE $80
    $7023: A0 82       LDY  #$82
    $7025: 80          .BYTE $80
    $7026: A0 BA       LDY  #$BA
    $7028: F7          .BYTE $F7
    $7029: AE AA 91    LDX  $91AA
    $702C: AA          TAX  
    $702D: 9A          TXS  
    $702E: B3          .BYTE $B3
    $702F: A6 AA       LDX  $AA
    $7031: 91 AA       STA  ($AA),Y
    $7033: BA          TSX  
    $7034: F7          .BYTE $F7
    $7035: AA          TAX  
    $7036: 82          .BYTE $82
    $7037: 80          .BYTE $80
    $7038: A0 82       LDY  #$82
    $703A: 80          .BYTE $80
    $703B: A0 82       LDY  #$82
    $703D: 80          .BYTE $80
    $703E: A0 82       LDY  #$82
    $7040: BE A0 C2    LDX  $C2A0,Y
    $7043: EB          .BYTE $EB
    $7044: A1 F2       LDA  ($F2,X)
    $7046: AA          TAX  
    $7047: A7          .BYTE $A7
    $7048: FA          .BYTE $FA
    $7049: A2 AF       LDX  #$AF
    $704B: F2          .BYTE $F2
    $704C: AA          TAX  
    $704D: A7          .BYTE $A7
    $704E: C2          .BYTE $C2
    $704F: EB          .BYTE $EB
    $7050: A1 82       LDA  ($82,X)
    $7052: BE A0 82    LDX  $82A0,Y
    $7055: 80          .BYTE $80
    $7056: A0 82       LDY  #$82
    $7058: 80          .BYTE $80
    $7059: A0 FC       LDY  #$FC
    $705B: FF          .BYTE $FF
    $705C: 9F          .BYTE $9F
    $705D: F0 FF       BEQ  L_705E
    $705F: FF          .BYTE $FF
    $7060: 80          .BYTE $80
    $7061: 88          DEY  
    $7062: 80          .BYTE $80
    $7063: 80          .BYTE $80
    $7064: 81 F8       STA  ($F8,X)
    $7066: FF          .BYTE $FF
    $7067: FF          .BYTE $FF
    $7068: 81 A8       STA  ($A8,X)
    $706A: D5 AA       CMP  $AA,X
    $706C: 81 88       STA  ($88,X)
    $706E: 80          .BYTE $80
    $706F: 80          .BYTE $80
    $7070: 81 88       STA  ($88,X)
    $7072: 80          .BYTE $80
    $7073: 80          .BYTE $80
    $7074: 81 E8       STA  ($E8,X)
    $7076: DD BB 81    CMP  $81BB,X
    $7079: A8          TAY  
    $707A: C5 A8       CMP  $A8
    $707C: 81 E8       STA  ($E8,X)
    $707E: CC 99 81    CPY  $8199
    $7081: A8          TAY  
    $7082: C5 A8       CMP  $A8
    $7084: 81 E8       STA  ($E8,X)
    $7086: DD AB 81    CMP  $81AB,X
    $7089: 88          DEY  
    $708A: 80          .BYTE $80
    $708B: 80          .BYTE $80
    $708C: 81 88       STA  ($88,X)
    $708E: 80          .BYTE $80
    $708F: 80          .BYTE $80
    $7090: 81 88       STA  ($88,X)
    $7092: 80          .BYTE $80
    $7093: 80          .BYTE $80
    $7094: 81 88       STA  ($88,X)
    $7096: F8          SED  
    $7097: 81 81       STA  ($81,X)
    $7099: 88          DEY  
    $709A: AE 87 81    LDX  $8187
    $709D: C8          INY  
    $709E: AB          .BYTE $AB
    $709F: 9D 81 E8    STA  $E881,X
    $70A2: 8B          .BYTE $8B
    $70A3: BD 81 C8    LDA  $C881,X
    $70A6: AB          .BYTE $AB
    $70A7: 9D 81 88    STA  $8881,X
    $70AA: AE 87 81    LDX  $8187
    $70AD: 88          DEY  
    $70AE: F8          SED  
    $70AF: 81 81       STA  ($81,X)
    $70B1: 88          DEY  
    $70B2: 80          .BYTE $80
    $70B3: 80          .BYTE $80
    $70B4: 81 88       STA  ($88,X)
    $70B6: 80          .BYTE $80
    $70B7: 80          .BYTE $80
    $70B8: 81 F0       STA  ($F0,X)
    $70BA: FF          .BYTE $FF
    $70BB: FF          .BYTE $FF
    $70BC: 80          .BYTE $80
    $70BD: C0 FF       CPY  #$FF
    $70BF: FF          .BYTE $FF
    $70C0: 83          .BYTE $83
    $70C1: A0 80       LDY  #$80
    $70C3: 80          .BYTE $80
    $70C4: 84 E0       STY  $E0
    $70C6: FF          .BYTE $FF
    $70C7: FF          .BYTE $FF
    $70C8: 87          .BYTE $87
    $70C9: A0 D5       LDY  #$D5
    $70CB: AA          TAX  
    $70CC: 85 A0       STA  $A0
    $70CE: 80          .BYTE $80
    $70CF: 80          .BYTE $80
    $70D0: 84 A0       STY  $A0
    $70D2: 80          .BYTE $80
    $70D3: 80          .BYTE $80
    $70D4: 84 A0       STY  $A0
    $70D6: F7          .BYTE $F7
    $70D7: EE 85 A0    INC  $A085
    $70DA: 95 A2       STA  $A2,X
    $70DC: 85 A0       STA  $A0
    $70DE: B3          .BYTE $B3
    $70DF: E6 84       INC  $84
    $70E1: A0 95       LDY  #$95
    $70E3: A2 85       LDX  #$85
    $70E5: A0 F7       LDY  #$F7
    $70E7: AE 85 A0    LDX  $A085
    $70EA: 80          .BYTE $80
    $70EB: 80          .BYTE $80
    $70EC: 84 A0       STY  $A0
    $70EE: 80          .BYTE $80
    $70EF: 80          .BYTE $80
    $70F0: 84 A0       STY  $A0
    $70F2: 80          .BYTE $80
    $70F3: 80          .BYTE $80
    $70F4: 84 A0       STY  $A0
    $70F6: E0 87       CPX  #$87
    $70F8: 84 A0       STY  $A0
    $70FA: B8          CLV  
    $70FB: 9D 84 A0    STA  $A084,X
    $70FE: AE F5 84    LDX  $84F5
    $7101: A0 AF       LDY  #$AF
    $7103: F4          .BYTE $F4
    $7104: 85 A0       STA  $A0
    $7106: AE F5 84    LDX  $84F5
    $7109: A0 B8       LDY  #$B8
    $710B: 9D 84 A0    STA  $A084,X
    $710E: E0 87       CPX  #$87
    $7110: 84 A0       STY  $A0
    $7112: 80          .BYTE $80
    $7113: 80          .BYTE $80
    $7114: 84 A0       STY  $A0
    $7116: 80          .BYTE $80
    $7117: 80          .BYTE $80
    $7118: 84 C0       STY  $C0
    $711A: FF          .BYTE $FF
    $711B: FF          .BYTE $FF
    $711C: 83          .BYTE $83
    $711D: 00          BRK  
    $711E: 00          BRK  
    $711F: 00          BRK  
    $7120: 00          BRK  
    $7121: 00          BRK  
    $7122: 00          BRK  
    $7123: 00          BRK  
    $7124: 00          BRK  
    $7125: 00          BRK  
    $7126: 00          BRK  
    $7127: 00          BRK  
    $7128: 00          BRK  
    $7129: 00          BRK  
    $712A: 00          BRK  
    $712B: 00          BRK  
    $712C: 00          BRK  
    $712D: 00          BRK  
    $712E: 00          BRK  
    $712F: 00          BRK  
    $7130: 00          BRK  
    $7131: 00          BRK  
    $7132: 00          BRK  
    $7133: 00          BRK  
    $7134: 00          BRK  
    $7135: 00          BRK  
    $7136: 00          BRK  
    $7137: 00          BRK  
    $7138: 00          BRK  
    $7139: 00          BRK  
    $713A: 00          BRK  
    $713B: 00          BRK  
    $713C: 00          BRK  
    $713D: 00          BRK  
    $713E: 00          BRK  
    $713F: 00          BRK  
    $7140: 00          BRK  
    $7141: 00          BRK  
    $7142: 00          BRK  
    $7143: 00          BRK  
    $7144: 00          BRK  
    $7145: 00          BRK  
    $7146: 00          BRK  
    $7147: 00          BRK  
    $7148: 00          BRK  
    $7149: 00          BRK  
    $714A: 00          BRK  
    $714B: 00          BRK  
    $714C: 00          BRK  
    $714D: 00          BRK  
    $714E: 00          BRK  
    $714F: 00          BRK  
    $7150: 00          BRK  
    $7151: 00          BRK  
    $7152: 00          BRK  
    $7153: 00          BRK  
    $7154: 00          BRK  
    $7155: 00          BRK  
    $7156: 00          BRK  
    $7157: 00          BRK  
    $7158: 00          BRK  
    $7159: 00          BRK  
    $715A: 00          BRK  
    $715B: 00          BRK  
    $715C: 00          BRK  
    $715D: 00          BRK  
    $715E: 00          BRK  
    $715F: 00          BRK  
    $7160: 00          BRK  
    $7161: 00          BRK  
    $7162: 00          BRK  
    $7163: 00          BRK  
    $7164: 00          BRK  
    $7165: 00          BRK  
    $7166: 00          BRK  
    $7167: 00          BRK  
    $7168: 00          BRK  
    $7169: 00          BRK  
    $716A: 00          BRK  
    $716B: 00          BRK  
    $716C: 00          BRK  
    $716D: 00          BRK  
    $716E: 00          BRK  
    $716F: 00          BRK  
    $7170: 00          BRK  
    $7171: 00          BRK  
    $7172: 00          BRK  
    $7173: 00          BRK  
    $7174: 00          BRK  
    $7175: 00          BRK  
    $7176: 00          BRK  
    $7177: 00          BRK  
    $7178: 00          BRK  
    $7179: 00          BRK  
    $717A: 00          BRK  
    $717B: 00          BRK  
    $717C: 00          BRK  
    $717D: 00          BRK  
    $717E: 00          BRK  
    $717F: 00          BRK  
    $7180: 00          BRK  
    $7181: 00          BRK  
    $7182: 00          BRK  
    $7183: 00          BRK  
    $7184: 00          BRK  
    $7185: 00          BRK  
    $7186: 00          BRK  
    $7187: 00          BRK  
    $7188: 00          BRK  
    $7189: 00          BRK  
    $718A: 00          BRK  
    $718B: 00          BRK  
    $718C: 00          BRK  
    $718D: 00          BRK  
    $718E: 00          BRK  
    $718F: 00          BRK  
    $7190: 00          BRK  
    $7191: 00          BRK  
    $7192: 00          BRK  
    $7193: 00          BRK  
    $7194: 00          BRK  
    $7195: 00          BRK  
    $7196: 00          BRK  
    $7197: 00          BRK  
    $7198: 00          BRK  
    $7199: 00          BRK  
    $719A: 00          BRK  
    $719B: 00          BRK  
    $719C: 00          BRK  
    $719D: 00          BRK  
    $719E: 00          BRK  
    $719F: 00          BRK  
    $71A0: 00          BRK  
    $71A1: 00          BRK  
    $71A2: 00          BRK  
    $71A3: 00          BRK  
    $71A4: 00          BRK  
    $71A5: 00          BRK  
    $71A6: 00          BRK  
    $71A7: 00          BRK  
    $71A8: 00          BRK  
    $71A9: 00          BRK  
    $71AA: 00          BRK  
    $71AB: 00          BRK  
    $71AC: 00          BRK  
    $71AD: 00          BRK  
    $71AE: 00          BRK  
    $71AF: 00          BRK  
    $71B0: 00          BRK  
    $71B1: 00          BRK  
    $71B2: 00          BRK  
    $71B3: 00          BRK  
    $71B4: 00          BRK  
    $71B5: 00          BRK  
    $71B6: 00          BRK  
    $71B7: 00          BRK  
    $71B8: 00          BRK  
    $71B9: 00          BRK  
    $71BA: 00          BRK  
    $71BB: 00          BRK  
    $71BC: 00          BRK  
    $71BD: 00          BRK  
    $71BE: 00          BRK  
    $71BF: 00          BRK  
    $71C0: 00          BRK  
    $71C1: 00          BRK  
    $71C2: 00          BRK  
    $71C3: 00          BRK  
    $71C4: 00          BRK  
    $71C5: 00          BRK  
    $71C6: 00          BRK  
    $71C7: 00          BRK  
    $71C8: 00          BRK  
    $71C9: 00          BRK  
    $71CA: 00          BRK  
    $71CB: 00          BRK  
    $71CC: 00          BRK  
    $71CD: 00          BRK  
    $71CE: 00          BRK  
    $71CF: 00          BRK  
    $71D0: 00          BRK  
    $71D1: 00          BRK  
    $71D2: 00          BRK  
    $71D3: 00          BRK  
    $71D4: 00          BRK  
    $71D5: 00          BRK  
    $71D6: 00          BRK  
    $71D7: 00          BRK  
    $71D8: 00          BRK  
    $71D9: 00          BRK  
    $71DA: 00          BRK  
    $71DB: 00          BRK  
    $71DC: 00          BRK  
    $71DD: 00          BRK  
    $71DE: 00          BRK  
    $71DF: 00          BRK  
    $71E0: 00          BRK  
    $71E1: 00          BRK  
    $71E2: 00          BRK  
    $71E3: 00          BRK  
    $71E4: 00          BRK  
    $71E5: 00          BRK  
    $71E6: 00          BRK  
    $71E7: 00          BRK  
    $71E8: 00          BRK  
    $71E9: 00          BRK  
    $71EA: 00          BRK  
    $71EB: 00          BRK  
    $71EC: 00          BRK  
    $71ED: 00          BRK  
    $71EE: 00          BRK  
    $71EF: 00          BRK  
    $71F0: 00          BRK  
    $71F1: 00          BRK  
    $71F2: 00          BRK  
    $71F3: 00          BRK  
    $71F4: 00          BRK  
    $71F5: 00          BRK  
    $71F6: 00          BRK  
    $71F7: 00          BRK  
    $71F8: 00          BRK  
    $71F9: 00          BRK  
    $71FA: 00          BRK  
    $71FB: 00          BRK  
    $71FC: 00          BRK  
    $71FD: 00          BRK  
    $71FE: 00          BRK  
    $71FF: 00          BRK  

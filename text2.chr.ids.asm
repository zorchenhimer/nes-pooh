; asmsyntax=ca65

;.byte $00
TextIds_Both:
    .byte $01
    .byte $02
    .byte $03
    .byte $04
    .byte $05
    .byte $06
    .byte $07
    .byte $08
    .byte $09
    .byte $0A
    .byte $0B
    .byte $0C
    TextIds_Both_Length = * - TextIds_Both

TextIds_NoTux:
    .byte $0D
    .byte $0E
    .byte $0F
    .byte $10
    .byte $11
    .byte $12
    .byte $13
    .byte $14
    TextIds_NoTux_Length = * - TextIds_NoTux

TextIds_Tux:
    .byte $06
    .byte $15
    .byte $16
    .byte $17
    .byte $18
    .byte $19
    .byte $1A
    .byte $1B
    .byte $1C
    .byte $1D
    .byte $1E
    .byte $1F
    .byte $20

; newline
.repeat 7
    .byte $00
.endrepeat

    .byte $21
    .byte $22
    .byte $23
    .byte $24
    .byte $25
    .byte $26
    .byte $27
    .byte $1C
    .byte $28
    .byte $29
    .byte $2A
    .byte $2B
    TextIds_Tux_Length = * - TextIds_Tux

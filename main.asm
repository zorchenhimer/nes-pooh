; asmsyntax=ca65

.include "nes2header.inc"

nes2mapper 1
nes2prg 2 * 16 * 1024
nes2chr 4 *  4 * 1024
nes2mirror 'V'
nes2tv 'N'
nes2end

.feature leading_dot_in_identifiers
.feature underline_in_numbers
.feature addrsize

; Button Constants
BUTTON_A        = 1 << 7
BUTTON_B        = 1 << 6
BUTTON_SELECT   = 1 << 5
BUTTON_START    = 1 << 4
BUTTON_UP       = 1 << 3
BUTTON_DOWN     = 1 << 2
BUTTON_LEFT     = 1 << 1
BUTTON_RIGHT    = 1 << 0

TextBGTile = $00

.segment "VECTORS"
    .word NMI
    .word RESET
    .word IRQ

.segment "CHR0"
    ;.incbin "meme-text.chr"
BgTile = 0
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $00, $00, $00, $00, $00, $00, $00, $00
ShineStart = 1
:   .incbin "shine.chr"
Text1Start = ((* - :-) / 16) + ShineStart
ShineCount = Text1Start - ShineStart
:   .incbin "text1.chr"
Text2Start = ((* - :-) / 16) + Text1Start
:   .incbin "text2.chr"
Text3Start = ((* - :-) / 16) + Text2Start
:   .incbin "text3.chr"
Text4Start = ((* - :-) / 16) + Text3Start
:   .incbin "text4.chr"
;BgTile = ((* - :-) / 16) + Text4Start

.out .sprintf("ShineStart: $%02X", ShineStart)
.out .sprintf("ShineCount: %d", ShineCount)
.out .sprintf("Text1Start: $%02X", Text1Start)
.out .sprintf("Text2Start: $%02X", Text2Start)
.out .sprintf("Text3Start: $%02X", Text3Start)
.out .sprintf("Text4Start: $%02X", Text4Start)
.out .sprintf("BgTile: $%02X", BgTile)
.segment "CHR1"
    .incbin "pooh.chr"

.segment "CHR2"
    .incbin "pooh_tux.chr"

.segment "CHR3"

.segment "ZEROPAGE"
Sleeping: .res 1
Scroll: .res 1
Draw: .res 1

btnX: .res 1
btnY: .res 1
IgnoreInput: .res 1
Controller: .res 1
Controller_Old: .res 1

TmpX: .res 1
TmpY: .res 1

AddressPointer: .res 2

SpriteZeroEnabled: .res 1

.segment "OAM"
SpriteZero:   .res 4
ShineSprites: .res (4*5)

.segment "BSS"

.segment "PAGE0"
IRQ:
    rti

RESET:
    sei
    cld

    ldx #$40
    stx $4017
    ldx #$FF
    txs
    inx

    stx $2000
    stx $2001
    stx $4010

:   bit $2002
    bpl :-

@clr:
    lda #$00
    sta $0000, x
    sta $0100, x
    sta $0300, x
    sta $0400, x
    sta $0500, x
    sta $0600, x
    sta $0700, x
    lda #$FF
    sta $0200, x
    inx
    bne @clr

:   bit $2002
    bpl :-

    jsr MMC1_Init

    lda #$FF
    sta Draw

    lda #00
    sta Scroll

    ; Setup sprite zero
    lda #250
    sta SpriteZero+3
    lda #22
    sta SpriteZero+0

    lda #BgTile
    sta SpriteZero+1
    lda #0
    sta SpriteZero+2

    ; Setup the shine sprite Note that tiles
    ; aren't set here.  Those are set each frame
    ; in UpdateShine.
    ; First Row
    .repeat 5, i
    lda #64+(8*i)+16
    sta ShineSprites+(4*i)+3
    lda #0
    sta ShineSprites+(4*i)+2
    lda #168
    sta ShineSprites+(4*i)+0
    .endrepeat

    ; Second row
    .repeat 2, i
    lda #88+(8*i)+16
    sta ShineSprites+(4*(i+5))+3
    lda #0
    sta ShineSprites+(4*(i+5))+2
    lda #176
    sta ShineSprites+(4*(i+5))+0
    .endrepeat

    jsr UpdateShine

    ; Palettes
    lda #$3F
    sta $2006
    lda #$00
    sta $2006
    ldx #0
:
    lda PaletteData, x
    sta $2007
    inx
    cpx #(8*4)
    bne :-

    jsr LoadNametables

    lda #1
    sta Draw

    lda #%1000_0000
    sta $2000

    jsr WaitForNMI

Frame:
    jsr ReadControllers

    lda #BUTTON_A
    jsr ButtonPressed
    beq :+
    inc Scroll
    jsr UpdateShine
:

    lda #BUTTON_START
    jsr ButtonPressed
    beq :+
    lda Draw
    eor #$01
    sta Draw
:

    ; Don't wait for sprite zero if drawing is
    ; disabled.
    lda SpriteZeroEnabled
    bne :+
    jsr WaitForNMI
    jmp Frame
:
    ; swap BG pattern table on SpriteZero hit
:   bit $2002
    bvs :-
:   bit $2002
    bvc :-

    lda Scroll
    and #$01
    tax
    ora #%1001_0000
    sta $2000
    cpx #1
    bne :+
    jsr MMC1_CHR2
    jmp :++
:
    jsr MMC1_CHR1
:
    jsr WaitForNMI
    jmp Frame

NMI:
    pha
    lda #$FF
    sta Sleeping

    ; High bit disables NMI all together
    lda Draw
    bpl :+
    pla
    rti
:

    lda #$00
    sta $2003
    lda #$02
    sta $4014

    ; zero turns off sprites and BG
    lda #$3F
    sta $2006
    lda #$00
    sta $2006

    lda Draw
    beq :+
    ; reset BG color
    lda PaletteData
    sta $2007
    lda #1
    sta SpriteZeroEnabled

    lda #%0001_1110
    jmp :++

:   ; set black BG
    lda #$FF
    sta $2007
    lda #0
    sta SpriteZeroEnabled

    lda #%0000_0110
:
    sta $2001

    lda #0
    sta $2005
    sta $2005

    lda Scroll
    and #$01
    ora #%1000_0000
    sta $2000


    pla
    rti

UpdateShine:
    lda Scroll
    and #1
    beq :+
    .repeat 7, i
    lda #ShineStart+i+1
    sta ShineSprites+(4*i)+1
    .endrepeat
    rts

:   ; no shine
    lda #ShineStart
    .repeat 7, i
    sta ShineSprites+(4*i)+1
    .endrepeat
    rts

LoadNametables:
    bit $2002

    lda #$20
    sta $2006
    lda #$00
    sta $2006

    ; Draw blank tiles that we'll draw
    ; the text on top of
    lda #BgTile
    ldy #24
:
    sta $2007
    sta $2007
    sta $2007
    sta $2007
    dey
    bne :-

    ; Text first
    lda #$20
    sta $2006
    lda #$22
    sta $2006
    lda #Text1Start
    sta TmpX
    lda #.lobyte(Text1Data)
    sta AddressPointer+0
    lda #.hibyte(Text1Data)
    sta AddressPointer+1
    jsr DrawText

    lda #$20
    sta $2006
    lda #$42
    sta $2006
    lda #Text2Start
    sta TmpX
    lda #.lobyte(Text2Data)
    sta AddressPointer+0
    lda #.hibyte(Text2Data)
    sta AddressPointer+1
    jsr DrawText

    ; First screen
    lda #.lobyte(PoohData)
    sta AddressPointer+0
    lda #.hibyte(PoohData)
    sta AddressPointer+1

    clc
    lda AddressPointer+0
    adc #2
    sta AddressPointer+0
    lda #0
    adc AddressPointer+1
    sta AddressPointer+1

    lda #$20
    sta $2006
    lda #$60
    sta $2006
    jsr DrawScreen

    ; Attrs for first nametable
    lda #$23
    sta $2006
    lda #$C0
    sta $2006

    ; Top attr row
    lda #%0000_0000
    ldy #4
:
    sta $2007
    sta $2007
    dey
    bne :-

    ldy #28
    lda #%0101_0101
:
    sta $2007
    sta $2007
    dey
    bne :-

    ; Second Screen
    lda #$24
    sta $2006
    lda #$00
    sta $2006

    lda #BgTile
    ldy #24
:
    sta $2007
    sta $2007
    sta $2007
    sta $2007
    dey
    bne :-

    lda #$24
    sta $2006
    lda #$22
    sta $2006
    lda #Text3Start
    sta TmpX
    lda #.lobyte(Text3Data)
    sta AddressPointer+0
    lda #.hibyte(Text3Data)
    sta AddressPointer+1
    jsr DrawText

    lda #$24
    sta $2006
    lda #$42
    sta $2006
    lda #Text4Start
    sta TmpX
    lda #.lobyte(Text4Data)
    sta AddressPointer+0
    lda #.hibyte(Text4Data)
    sta AddressPointer+1
    jsr DrawText

    lda #$24
    sta $2006
    lda #$60
    sta $2006

    ; Second screen
    lda #.lobyte(PoohTuxData)
    sta AddressPointer+0
    lda #.hibyte(PoohTuxData)
    sta AddressPointer+1

    clc
    lda AddressPointer+0
    adc #2
    sta AddressPointer+0
    lda #0
    adc AddressPointer+1
    sta AddressPointer+1
    jsr DrawScreen

    ; Second screen attributes are uniform
    lda #$27
    sta $2006
    lda #$C0
    sta $2006

    ldx #16
    lda #$00
:
    sta $2007
    sta $2007
    sta $2007
    sta $2007
    dex
    bne :-
    rts

; Expects PPU address already set & data pointer in AddressPointer
DrawText:
    ldy #0
    lda (AddressPointer), y
    tax

    clc
:   iny
    lda (AddressPointer), y
    adc TmpX    ; Tile start offset
    sta $2007
    dex
    bne :-

    rts

; Expects pooh data at address in AddressPointer
DrawScreen:
    lda #26
    sta TmpY
@screen:
    ldy #0
    sty $2007
    sty $2007

    ;ldy #0
    ldx #28
@row:
    lda (AddressPointer), y
    sta $2007
    iny
    dex
    bne @row

    ldx #0
    stx $2007
    stx $2007

    clc
    lda #28
    adc AddressPointer+0
    sta AddressPointer+0
    lda #0
    adc AddressPointer+1
    sta AddressPointer+1

    dec TmpY
    bne @screen

    lda #0
    ldy #8
:
    sta $2007
    sta $2007
    sta $2007
    sta $2007
    dey
    bne :-
    rts

ButtonPressed:
    sta btnX

    lda IgnoreInput
    beq :+
    ;dec IgnoreInput
    lda #0
    rts
:

    lda btnX
    and Controller
    sta btnY

    lda Controller_Old
    and btnX

    cmp btnY
    bne btnPress_stb

    ; no button change
    rts

btnPress_stb:
    ; button released
    lda btnY
    bne btnPress_stc
    rts

btnPress_stc:
    ; button pressed
    lda #1
    rts

ReadControllers:
    lda Controller
    sta Controller_Old

    ; Freeze input
    lda #1
    sta $4016
    lda #0
    sta $4016

    ldx #$08
@player1:
    lda $4016
    lsr a           ; Bit0 -> Carry
    rol Controller  ; Bit0 <- Carry
    dex
    bne @player1
    rts

WaitForNMI:
;    lda #%1000_0000
;    ora Scroll
;    sta $2000

:   bit Sleeping
    bpl :-
    lda #0
    sta Sleeping
    rts

WaitForSpriteZero:
    rts

MMC1_Init:
    lda #$80
    sta $8000

    ; 4kCHR, 32k PRG, vertical
    lda #%0001_0010
    jsr MMC1_Setup

    ; select CHR 0
    lda #%0000_0000

    sta $A000
    lsr a
    sta $A000
    lsr a
    sta $A000
    lsr a
    sta $A000
    lsr a
    sta $A000
    ;rts

MMC1_CHR1:
    lda #1
    jmp chrPage

MMC1_CHR2:
    lda #2

chrPage:
    sta $C000
    lsr a
    sta $C000
    lsr a
    sta $C000
    lsr a
    sta $C000
    lsr a
    sta $C000
    rts

MMC1_Setup:
    sta $8000
    lsr a
    sta $8000
    lsr a
    sta $8000
    lsr a
    sta $8000
    lsr a
    sta $8000
    rts

MMC1_Select_Page:
    lda #0
    sta $E000
    lsr a
    sta $E000
    lsr a
    sta $E000
    lsr a
    sta $E000
    lsr a
    sta $E000
    rts

PaletteData:
    ;BG
    .byte $01, $0F, $27, $20
    .byte $01, $0F, $27, $16
    .byte $01, $20, $0F, $0F
    .byte $01, $0F, $0F, $0F

    ;Sprites
    .byte $01, $0F, $20, $0F
    .byte $01, $0F, $0F, $0F
    .byte $01, $0F, $0F, $0F
    .byte $01, $0F, $0F, $0F

PoohData:    .include "pooh.i"
PoohTuxData: .include "pooh_tux.i"

Text1Data: .include "text1.i"
Text2Data: .include "text2.i"
Text3Data: .include "text3.i"
Text4Data: .include "text4.i"

; asmsyntax=ca65

.include "nes2header.inc"

nes2mapper 1
nes2prg 2 * 16 * 1024
nes2chr 3 *  4 * 1024
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

.segment "VECTORS"
    .word NMI
    .word RESET
    .word IRQ

.segment "CHR0"
    .incbin "meme-text.chr"
    .incbin "shine.chr"

.segment "CHR1"
    .incbin "pooh.chr"

.segment "CHR2"
    .incbin "pooh_tux.chr"

.segment "ZEROPAGE"
Sleeping: .res 1
Scroll: .res 1
Draw: .res 1

btnX: .res 1
btnY: .res 1
IgnoreInput: .res 1
Controller: .res 1
Controller_Old: .res 1

.segment "OAM"

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

    lda #$FF
    sta Draw

    lda #00
    sta Scroll

    lda #%10010000
    sta $2000

    jsr MMC1_Init

    jsr LoadNametables

    lda #1
    sta Draw

Frame:
    jsr ReadControllers

    lda BUTTON_A
    jsr ButtonPressed
    beq :+
    inc Scroll
:

    lda BUTTON_START
    jsr ButtonPressed
    beq :+
    lda Draw
    eor #$01
    sta Draw
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

    lda Scroll
    and #$01
    ora #%0001_0000
    sta $2000

    lda #0
    sta $2005
    sta $2005

    ; zero turns off sprites and BG
    lda Draw
    beq :+
    lda #%0001_1110
    jmp :++

:   lda #%0000_0110
:   sta $2001

    pla
    rti

LoadNametables:
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
:   bit Sleeping
    bpl :-
    lda #0
    sta Sleeping
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

; asmsyntax=ca65

    ;TILES0:      load = CHR0, type = ro;
    ;TILES1:      load = CHR1, type = ro;

.include "nes2header.inc"

nes2mapper 0
nes2prg 2 * 16 * 1024
;nes2chr 1 *  8 * 1024
nes2chr 0
nes2mirror 'V'
nes2tv 'N'
nes2end

;.segment "TILES0"
;    .incbin "pooh.chr"
;.segment "TILES1"
;    .incbin "pooh_tux.chr"

.segment "VECTORS"
    .word NMI
    .word RESET
    .word RESET

.segment "ZEROPAGE"
sleeping:       .res 1
PaletteIndex:   .res 1

TmpId:  .res 1
TmpX:   .res 1
TmpY:   .res 1
TmpAddr: .res 2

ChrAddr:    .res 2
ChrIdAddr:  .res 2
ChrCount:   .res 1  ; Tile count, not byte count

controller:     .res 1
controllerTmp:  .res 1
controllerOld:  .res 1
btnPressedMask: .res 1

NMISkip:    .res 1

CurrentScreen:  .res 1
NewScreen:      .res 1
ScreenEnabled:  .res 1

; Button Constants
BUTTON_A        = 1 << 7
BUTTON_B        = 1 << 6
BUTTON_SELECT   = 1 << 5
BUTTON_START    = 1 << 4
BUTTON_UP       = 1 << 3
BUTTON_DOWN     = 1 << 2
BUTTON_LEFT     = 1 << 1
BUTTON_RIGHT    = 1 << 0

; Walls
W_TOP       = 26
W_BOTTOM    = 210
W_LEFT      = 32
W_RIGHT     = 224

.segment "BSS"
PaletteRAM:         .res 32

.segment "OAM"
SpriteZero:     .res 4
Sprites:        .res 252

.segment "PAGE1"

.enum Screens
    NoTux
    Tux
.endenum

LookupChr:
    .word NoTuxChr
    .word TuxChr

LookupIds:
    .word NoTuxId
    .word TuxId

LookupPalettes:
    .word NoTuxEnd
    .word TuxEnd

LookupText:
    .word NoTuxText
    .word TuxText

LookupSpzTile:
    .byte $08
    .byte $09

LookupBlankTile:
    .byte $00
    .byte $89

LookupShineSprites:
    .word NoTuxShine
    .word TuxShine

LookupChrLengths:
    .byte (NoTuxId - NoTuxChr) / 16
    .byte (TuxId - TuxChr) / 16

;Font:
;    .include "font.asm"
;FontEnd:
;    RUNE_COUNT = ((FontEnd - Font) / 8)
;    .assert RUNE_COUNT - 1 = '&', error, "Font values are not correct"

SpriteZeroId = $2C
SpriteZeroSpriteChr:
    ; Sprite zero tile
    .charmap '&', 73
    .byte $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF

NoTuxChr:
    .incbin "pooh.chr"
NoTuxId:
    .include "pooh.chr.ids.asm"
NoTuxEnd:
    .byte $0F, $27, $11, $16
    .byte $0F, $27, $11, $16

SpritePal:
    .byte $0F, $00, $0F, $0F

    NoTuxCount = (NoTuxId - NoTuxChr) / 16

NoTuxText:
    .byte "Hello NoTux^"
NoTuxShine:
    .byte $00, $00, $00, $00, $00

TuxChr:
    .incbin "pooh_tux.chr"
TuxId:
    .include "pooh_tux.chr.ids.asm"
TuxEnd:
    .byte $0F, $27, $11, $30
    .byte $0F, $27, $11, $0F

    TuxCount = (TuxId - TuxChr) / 16

TuxText:
    .byte "Hello Tux^"

    nop
TuxShineChr:
    .include "tux_shine.asm"
TuxShineCount = (* - TuxShineChr) / 8
TuxShine:
    .byte $F0, $F1, $F2, $F3, $F4

AttrTable:
    .byte $55, $55, $55, $55, $55, $55, $55, $55
    .byte $55, $55, $55, $55, $55, $55, $55, $55
    .byte $55, $55, $55, $55, $55, $55, $55, $55
    .byte $55, $55, $55, $55, $55, $55, $55, $55
    .byte $55, $00, $00, $00, $00, $00, $00, $55
    .byte $55, $00, $00, $00, $00, $00, $00, $55
    .byte $55, $00, $00, $00, $00, $00, $00, $55
    .byte $55, $00, $00, $00, $00, $00, $00, $55

;TextChrData:
;    .include "text.asm"
;    TextChrLength = (* - TextChrData) / 8
;    .include "text.chr.ids.asm"

TextChrData:
    .include "text2.asm"
    TextChrLength = (* - TextChrData) / 8
    .include "text2.chr.ids.asm"

.segment "PAGE0"
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
    sta $0200, x
    sta $0300, x
    sta $0400, x
    sta $0500, x
    sta $0600, x
    sta $0700, x
    inx
    bne @clr

:   bit $2002
    bpl :-

    lda #$FF
    sta NMISkip

    lda #%10010000
    sta $2000

; clear sprites
    lda #0
    ldx #1
:
    sta $0200, x
    inx
    inx
    inx
    beq :+
    inx
    jmp :-
:

    ; Clear out all palettes to $0F
    bit $2002
    lda #$3F
    sta $2006
    lda #$00
    sta $2006

    lda #$0F
    ldx #32
:
    sta $2007
    dex
    bne :-

    ;lda #Screens::Tux
    lda #Screens::NoTux
    sta CurrentScreen
    jsr LoadScreen

    jsr LoadFont
    jsr LoadShine
    jsr DrawBothBackgrounds

    ; Do this after all other init stuff
    lda #%00011110
    sta ScreenEnabled
    sta $2001

DoFrame:
    ; TODO: check for button input

    lda #0
    sta NMISkip

; wait for vblank to end
:   bit $2002
    bvs :-

; wait for sprite zero hit
:   bit $2002
    bvc :-

    lda #%10010000
    ora CurrentScreen
    sta $2000

    jsr ReadControllers

    lda #BUTTON_B
    jsr ButtonPressed
    beq :+
    lda #0
    sta ScreenEnabled
:
    lda #BUTTON_A
    jsr ButtonPressed
    beq WaitFrame

    lda CurrentScreen
    cmp #Screens::Tux
    bne :+
    lda #Screens::NoTux
    sta CurrentScreen
    jmp @load
:   lda #Screens::Tux
    sta CurrentScreen

@load:
    lda #$FF
    sta NewScreen

WaitFrame:

    lda #1
    sta sleeping

:   lda sleeping
    bne :-

    jmp DoFrame

NMI:
    bit NMISkip
    bpl :+
    rti
:

    bit NewScreen
    bpl :+

    lda #$00
    sta NewScreen
    sta $2001
    sta $2000

    lda CurrentScreen
    jsr LoadScreen

    lda #%10000000
    ora CurrentScreen
    sta $2000
    rti
:

    ; only A and X are clobbered
    pha
    txa
    pha

    bit $2002
    ; Sprites
    lda #$00
    sta $2003
    lda #$02
    sta $4014

    dec sleeping

    lda ScreenEnabled
    ;lda #%00011110
    sta $2001

    lda #%10000000
    ora CurrentScreen
    sta $2000

    lda #0
    sta $2005
    sta $2005

    ; Restore A and X
    pla
    tax
    pla
    rti

; loads full palette
LoadPalettes:
    ldx #31
    ldy #0
@loop:
    lda PaletteData, y
    sta PaletteRAM, x
    dex
    iny
    cpy #32
    bne @loop
    rts

; Uses the following variables as input
;   ChrAddr     CHR data address
;   ChrCount    number of tiles (not bytes)
LoadChr:
    bit $2002
    lda #$10
    sta $2006
    lda #$00
    sta $2006

    ldx ChrCount
@outerLoop:

    ldy #0
@tileLoop:
    lda (ChrAddr), y
    sta $2007
    iny
    cpy #16
    bne @tileLoop

    lda ChrAddr
    clc
    adc #16
    sta ChrAddr
    bcc :+
    inc ChrAddr+1
:
    dex
    bne @outerLoop
    rts

; Takes a single four-byte palette address in TmpAddr
; and loads it into the first palette
LoadBgPalette:
    bit $2002
    lda #$3F
    sta $2006
    lda #$00
    sta $2006

    ldy #0
:
    lda (TmpAddr), y
    sta $2007
    iny
    cpy #8
    bne :-
    rts

LoadSpPalette:
    bit $2002
    lda #$3F
    sta $2006
    lda #$10
    sta $2006

    ldy #0
:
    lda #$0F
    sta $2007
    iny
    cpy #4
    bne :-

    ldy #0
:
    lda SpritePal, y
    sta $2007
    iny
    cpy #4
    bne :-

    rts

DrawBothBackgrounds:
    lda #$20
    sta TmpAddr
    lda #$00
    sta TmpAddr+1

    ldx #Screens::NoTux
    asl a
    tax

    lda LookupIds, x
    sta ChrIdAddr
    lda LookupIds+1, x
    sta ChrIdAddr+1
    jsr DrawBackground

    lda #$24
    sta TmpAddr
    lda #$00
    sta TmpAddr+1

    lda #Screens::Tux
    asl a
    tax

    lda LookupIds, x
    sta ChrIdAddr
    lda LookupIds+1, x
    sta ChrIdAddr+1
    jsr DrawBackground

    ; Sprite zero BG tile, NT 0
    lda #$20
    sta $2006
    lda #$80
    sta $2006
    lda #SpriteZeroId
    sta $2007

    ; Sprite zero BG tile, NT 1
    lda #$24
    sta $2006
    lda #$80
    sta $2006
    lda #SpriteZeroId
    sta $2007

    lda #$23
    sta $2006
    lda #$C0
    sta $2006
    jsr WriteAttr

    lda #$27
    sta $2006
    lda #$C0
    sta $2006
    jsr WriteAttr

    ;
    ; First screen text
    lda #$20
    sta $2006
    lda #$42
    sta $2006

    lda #<TextIds_Both
    sta TmpAddr
    lda #>TextIds_Both
    sta TmpAddr+1

    ldx #TextIds_Both_Length
    jsr DrawSomeText

    lda #<TextIds_NoTux
    sta TmpAddr
    lda #>TextIds_NoTux
    sta TmpAddr+1

    ldx #TextIds_NoTux_Length
    jsr DrawSomeText

    ;
    ; Second screen text
    lda #$24
    sta $2006
    lda #$42
    sta $2006

    lda #<TextIds_Both
    sta TmpAddr
    lda #>TextIds_Both
    sta TmpAddr+1

    ldx #TextIds_Both_Length
    jsr DrawSomeText

    lda #<TextIds_Tux
    sta TmpAddr
    lda #>TextIds_Tux
    sta TmpAddr+1

    ldx #TextIds_Tux_Length
    jsr DrawSomeText

    rts

DrawSomeText:
    ldy #0
:
    lda (TmpAddr), y
    sta $2007
    iny
    dex
    bne :-
    rts

WriteAttr:
    ; Write attribute table
    lda #0
    ldx #$40
    ldy #0
:
    lda AttrTable, y
    sta $2007
    iny
    dex
    bne :-
    rts

; Takes variable ChrIdAddr as address input
DrawBackground:
    bit $2002
    lda TmpAddr
    sta $2006
    lda TmpAddr+1
    sta $2006

    ldx #128
:
    sta $2007
    dex
    bne :-

    sta $2007
    sta $2007

    lda #26
    sta TmpY

    ldx #0
    ldy #0
@outer:
    lda (ChrIdAddr), y
    sta $2007

    inc ChrIdAddr
    bne :+
    inc ChrIdAddr+1
:
    inx
    cpx #28
    bne @outer

    lda #0
    sta $2007
    sta $2007
    sta $2007
    sta $2007

    ldx #0
    dec TmpY
    beq @bgDone

    jmp @outer

@bgDone:
    rts

LoadFont:
    lda #<TextChrData
    sta TmpAddr
    lda #>TextChrData
    sta TmpAddr+1

    lda #$00
    sta $2006
    sta $2006

    ldx #TextChrLength
@tileLoop:
    ldy #0
:
    lda (TmpAddr), y
    sta $2007
    iny
    cpy #8  ; compare to 8 cuz it's a single plane font (two color)
    bne :-

    ; Fill in the second bit plane with zeroes
    lda #$00
.repeat 8
    sta $2007
.endrepeat

    lda TmpAddr
    clc
    adc #8
    sta TmpAddr
    bcc :+
    inc TmpAddr+1
:
    dex
    bne @tileLoop

    ldx #0
:
    lda SpriteZeroSpriteChr, x
    sta $2007
    inx
    cpx #8
    bne :-

    lda #0
.repeat 8
    sta $2007
.endrepeat
    rts

LoadShine:
    bit $2002
    lda #$0F
    sta $2006
    lda #$00
    sta $2006

    lda #<TuxShineChr
    sta TmpAddr
    lda #>TuxShineChr
    sta TmpAddr+1

    ldx #5
@tileLoop:
    ldy #0
.repeat 8
    lda (TmpAddr), y
    sta $2007
    iny
.endrepeat

    lda TmpAddr
    clc
    adc #8
    sta TmpAddr
    bcc :+
    inc TmpAddr+1
:

    lda #0
.repeat 8
    sta $2007
.endrepeat

    dex
    bne @tileLoop
    rts

DrawText:
    ldy #0
:
    lda (TmpAddr), y
    beq :+
    sta $2007
    iny
    jmp :-
:
    rts

;Sprites = $0204
LoadShineSprites:
    ldy #0
    ldx #0
    lda #$4C
    sta TmpX
:
    ; Y
    lda #$B0
    sta Sprites+0, x

    ; tile
    lda (TmpAddr), y
    sta Sprites+1, x

    ; attribute
    lda #$05
    sta Sprites+2, x

    ; X
    lda TmpX
    sta Sprites+3, x

    clc
    adc #8
    sta TmpX

    inx
    inx
    inx
    inx

    iny
    cpy #TuxShineCount
    bne :-

    rts

; Screen ID in A
LoadScreen:
    asl a
    pha
    tax
    lda LookupPalettes, x
    sta TmpAddr
    lda LookupPalettes+1, x
    sta TmpAddr+1
    jsr LoadBgPalette

    jsr LoadSpPalette

    pla
    pha
    tax
    lda LookupChr, x
    sta ChrAddr
    lda LookupChr+1, x
    sta ChrAddr+1

    txa
    lsr a
    tax
    lda LookupChrLengths, x
    sta ChrCount
    jsr LoadChr

    ; Setup sprite zero
    lda #$1F
    sta $0200

    pla
    pha
    lsr a
    tax

    lda #SpriteZeroId
    sta $0201

    lda #$00
    sta $0202

    lda #$00
    sta $0203

    pla
    ;pha
    tax
    lda LookupShineSprites, x
    sta TmpAddr
    lda LookupShineSprites+1, x
    sta TmpAddr+1
    jmp LoadShineSprites

    pla
    tax

ButtonPressed:
    sta btnPressedMask
    and controller
    sta controllerTmp

    lda controllerOld
    and btnPressedMask

    cmp controllerTmp
    bne btnPress_stb

    ; no button change
    rts

btnPress_stb:
    ; button released
    lda controllerTmp
    bne btnPress_stc
    rts

btnPress_stc:
    ; button pressed
    lda #1
    rts

; Player input
ReadControllers:
    lda controller
    sta controllerOld

    ; Freeze input
    lda #1
    sta $4016
    lda #0
    sta $4016

    LDX #$08
@player1:
    lda $4016
    lsr A           ; Bit0 -> Carry
    rol controller ; Bit0 <- Carry
    dex
    bne @player1
    rts

PaletteData:
    ;.byte $11, $16, $0F, $27
    .byte $0F, $27, $11, $30
    .byte $0F, $06, $16, $26
    .byte $0F, $06, $16, $26
    .byte $0F, $06, $16, $26

    .byte $0F, $06, $16, $26
    .byte $0F, $06, $16, $26
    .byte $0F, $06, $16, $26
    .byte $0F, $06, $16, $26

DVDPals:
    .byte $0F, $00, $10, $20
    .byte $0F, $06, $16, $26
    .byte $0F, $13, $23, $33
    .byte $0F, $0a, $2a, $3a
    .byte $0F, $11, $21, $31
    .byte $0F, $15, $25, $35
    .byte $0F, $14, $24, $34
DVDPalsEnd:

DVDPalsLength = (DVDPalsEnd - DVDPals) / 4

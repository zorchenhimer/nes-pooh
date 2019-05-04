; asmsyntax=ca65

    .charmap '^', 0
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000

    .charmap '(', 1
    .byte %01100000
    .byte %11000000
    .byte %11000000
    .byte %11000000
    .byte %11000000
    .byte %11000000
    .byte %01100000
    .byte %00000000

    .charmap ')', 2
    .byte %11000000
    .byte %01100000
    .byte %01100000
    .byte %01100000
    .byte %01100000
    .byte %01100000
    .byte %11000000
    .byte %00000000

    .charmap ',', 3
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00100000
    .byte %01100000
    .byte %11000000

    .charmap '-', 4
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %11111000
    .byte %00000000
    .byte %00000000
    .byte %00000000

    .charmap '.', 5
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %11000000
    .byte %11000000
    .byte %00000000

    .charmap '/', 6
    .byte %00110000
    .byte %00110000
    .byte %01100000
    .byte %01100000
    .byte %01100000
    .byte %11000000
    .byte %11000000
    .byte %00000000

    .charmap '0', 7
    .byte %01111100
    .byte %11000110
    .byte %11010110
    .byte %11010110
    .byte %11010110
    .byte %11000110
    .byte %01111100
    .byte %00000000

    .charmap '1', 8
    .byte %00110000
    .byte %01110000
    .byte %11110000
    .byte %00110000
    .byte %00110000
    .byte %00110000
    .byte %11111100
    .byte %00000000

    .charmap '2', 9
    .byte %01111000
    .byte %11001100
    .byte %00001100
    .byte %00111000
    .byte %11100000
    .byte %11000000
    .byte %11111100
    .byte %00000000

    .charmap '3', 10
    .byte %01111000
    .byte %11001100
    .byte %00001100
    .byte %00111000
    .byte %00001100
    .byte %11001100
    .byte %01111000
    .byte %00000000

    .charmap '4', 11
    .byte %11001100
    .byte %11001100
    .byte %11001100
    .byte %01111100
    .byte %00001100
    .byte %00001100
    .byte %00001100
    .byte %00000000

    .charmap '5', 12
    .byte %11111100
    .byte %11000000
    .byte %11111000
    .byte %00001100
    .byte %00001100
    .byte %11001100
    .byte %11111000
    .byte %00000000

    .charmap '6', 13
    .byte %01111100
    .byte %11000110
    .byte %11000000
    .byte %11111100
    .byte %11000110
    .byte %11000110
    .byte %01111100
    .byte %00000000

    .charmap '7', 14
    .byte %11111100
    .byte %00001100
    .byte %00011000
    .byte %00110000
    .byte %01100000
    .byte %01100000
    .byte %01100000
    .byte %00000000

    .charmap '8', 15
    .byte %01111100
    .byte %11000110
    .byte %11000110
    .byte %01111100
    .byte %11000110
    .byte %11000110
    .byte %01111100
    .byte %00000000

    .charmap '9', 16
    .byte %01111100
    .byte %11000110
    .byte %11000110
    .byte %01111110
    .byte %00000110
    .byte %00000110
    .byte %01111100
    .byte %00000000

    .charmap '@', 17
    .byte %01100000
    .byte %10010000
    .byte %10110000
    .byte %11010000
    .byte %10110000
    .byte %10010000
    .byte %01100000
    .byte %00000000

    .charmap 'A', 18
    .byte %01111000
    .byte %11001100
    .byte %11001100
    .byte %11111100
    .byte %11001100
    .byte %11001100
    .byte %11001100
    .byte %00000000

    .charmap 'B', 19
    .byte %11111100
    .byte %11000110
    .byte %11000110
    .byte %11111100
    .byte %11000110
    .byte %11000110
    .byte %11111100
    .byte %00000000

    .charmap 'C', 20
    .byte %01111100
    .byte %11100110
    .byte %11000000
    .byte %11000000
    .byte %11000000
    .byte %11100110
    .byte %01111100
    .byte %00000000

    .charmap 'D', 21
    .byte %11111000
    .byte %11001100
    .byte %11000110
    .byte %11000110
    .byte %11000110
    .byte %11000110
    .byte %11111100
    .byte %00000000

    .charmap 'E', 22
    .byte %11111100
    .byte %11000000
    .byte %11000000
    .byte %11111000
    .byte %11000000
    .byte %11000000
    .byte %11111100
    .byte %00000000

    .charmap 'F', 23
    .byte %11111100
    .byte %11000000
    .byte %11000000
    .byte %11111000
    .byte %11000000
    .byte %11000000
    .byte %11000000
    .byte %00000000

    .charmap 'G', 24
    .byte %01111100
    .byte %11000110
    .byte %11000000
    .byte %11011100
    .byte %11000110
    .byte %11000110
    .byte %01111100
    .byte %00000000

    .charmap 'H', 25
    ;.charmap $48, $19
    .byte %11000110
    .byte %11000110
    .byte %11000110
    .byte %11111110
    .byte %11000110
    .byte %11000110
    .byte %11000110
    .byte %00000000

    .charmap 'I', 26
    .byte %11111100
    .byte %00110000
    .byte %00110000
    .byte %00110000
    .byte %00110000
    .byte %00110000
    .byte %11111100
    .byte %00000000

    .charmap 'J', 27
    .byte %01111110
    .byte %00001100
    .byte %00001100
    .byte %00001100
    .byte %00001100
    .byte %11001100
    .byte %01111000
    .byte %00000000

    .charmap 'K', 28
    .byte %11000110
    .byte %11001100
    .byte %11011000
    .byte %11110000
    .byte %11011000
    .byte %11001100
    .byte %11000110
    .byte %00000000

    .charmap 'L', 29
    .byte %11000000
    .byte %11000000
    .byte %11000000
    .byte %11000000
    .byte %11000000
    .byte %11000000
    .byte %11111100
    .byte %00000000

    .charmap 'M', 30
    .byte %11000110
    .byte %11101110
    .byte %11111110
    .byte %11010110
    .byte %11000110
    .byte %11000110
    .byte %11000110
    .byte %00000000

    .charmap 'N', 31
    .byte %11000110
    .byte %11100110
    .byte %11110110
    .byte %11010110
    .byte %11011110
    .byte %11001110
    .byte %11000110
    .byte %00000000

    .charmap 'O', 32
    .byte %01111100
    .byte %11000110
    .byte %11000110
    .byte %11000110
    .byte %11000110
    .byte %11000110
    .byte %01111100
    .byte %00000000

    .charmap 'P', 33
    .byte %11111100
    .byte %11000110
    .byte %11000110
    .byte %11111100
    .byte %11000000
    .byte %11000000
    .byte %11000000
    .byte %00000000

    .charmap 'Q', 34
    .byte %01111100
    .byte %11000110
    .byte %11000110
    .byte %11000110
    .byte %11011110
    .byte %11001110
    .byte %01111100
    .byte %00000110

    .charmap 'R', 35
    .byte %11111100
    .byte %11000110
    .byte %11000110
    .byte %11111100
    .byte %11001100
    .byte %11000110
    .byte %11000110
    .byte %00000000

    .charmap 'S', 36
    .byte %01111100
    .byte %11000110
    .byte %11000000
    .byte %01111100
    .byte %00000110
    .byte %11000110
    .byte %01111100
    .byte %00000000

    .charmap 'T', 37
    .byte %11111100
    .byte %00110000
    .byte %00110000
    .byte %00110000
    .byte %00110000
    .byte %00110000
    .byte %00110000
    .byte %00000000

    .charmap 'U', 38
    .byte %11000110
    .byte %11000110
    .byte %11000110
    .byte %11000110
    .byte %11000110
    .byte %11000110
    .byte %01111100
    .byte %00000000

    .charmap 'V', 39
    .byte %11000110
    .byte %11000110
    .byte %11000110
    .byte %11000110
    .byte %01101100
    .byte %00111000
    .byte %00010000
    .byte %00000000

    .charmap 'W', 40
    .byte %11000110
    .byte %11000110
    .byte %11010110
    .byte %11010110
    .byte %11010110
    .byte %11111110
    .byte %01101100
    .byte %00000000

    .charmap 'X', 41
    .byte %11000110
    .byte %11000110
    .byte %01101100
    .byte %00111000
    .byte %01101100
    .byte %11000110
    .byte %11000110
    .byte %00000000

    .charmap 'Y', 42
    .byte %11001100
    .byte %11001100
    .byte %11001100
    .byte %01111000
    .byte %00110000
    .byte %00110000
    .byte %00110000
    .byte %00000000

    .charmap 'Z', 43
    .byte %11111100
    .byte %00001100
    .byte %00011000
    .byte %00110000
    .byte %01100000
    .byte %11000000
    .byte %11111100
    .byte %00000000

    .charmap '_', 44
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %11111000
    .byte %00000000

    .charmap 'a', 45
    .byte %00000000
    .byte %00000000
    .byte %01111000
    .byte %00001100
    .byte %01111100
    .byte %11001100
    .byte %01111000
    .byte %00000000

    .charmap 'b', 46
    .byte %00000000
    .byte %11000000
    .byte %11000000
    .byte %11111000
    .byte %11001100
    .byte %11001100
    .byte %11111000
    .byte %00000000

    .charmap 'c', 47
    .byte %00000000
    .byte %00000000
    .byte %01111000
    .byte %11001100
    .byte %11000000
    .byte %11001100
    .byte %01111000
    .byte %00000000

    .charmap 'd', 48
    .byte %00000000
    .byte %00001100
    .byte %00001100
    .byte %01111100
    .byte %11001100
    .byte %11001100
    .byte %01111100
    .byte %00000000

    .charmap 'e', 49
    .byte %00000000
    .byte %00000000
    .byte %01111000
    .byte %11001100
    .byte %11111100
    .byte %11000000
    .byte %01111100
    .byte %00000000

    .charmap 'f', 50
    .byte %00000000
    .byte %01111000
    .byte %11001100
    .byte %11000000
    .byte %11110000
    .byte %11000000
    .byte %11000000
    .byte %00000000

    .charmap 'g', 51
    .byte %00000000
    .byte %00000000
    .byte %01111000
    .byte %11001100
    .byte %11001100
    .byte %01111100
    .byte %00001100
    .byte %01111000

    .charmap 'h', 52
    .byte %00000000
    .byte %11000000
    .byte %11000000
    .byte %11111000
    .byte %11001100
    .byte %11001100
    .byte %11001100
    .byte %00000000

    .charmap 'i', 53
    .byte %00000000
    .byte %11000000
    .byte %00000000
    .byte %11000000
    .byte %11000000
    .byte %11000000
    .byte %11000000
    .byte %00000000

    .charmap 'j', 54
    .byte %00000000
    .byte %00011000
    .byte %00000000
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %11011000
    .byte %01110000

    .charmap 'k', 55
    .byte %00000000
    .byte %11000000
    .byte %11001100
    .byte %11011000
    .byte %11110000
    .byte %11011000
    .byte %11001100
    .byte %00000000

    .charmap 'l', 56
    .byte %00000000
    .byte %11000000
    .byte %11000000
    .byte %11000000
    .byte %11000000
    .byte %11000000
    .byte %11000000
    .byte %00000000

    .charmap 'm', 57
    .byte %00000000
    .byte %00000000
    .byte %01101100
    .byte %11111110
    .byte %11010110
    .byte %11000110
    .byte %11000110
    .byte %00000000

    .charmap 'n', 58
    .byte %00000000
    .byte %00000000
    .byte %11011000
    .byte %11101100
    .byte %11001100
    .byte %11001100
    .byte %11001100
    .byte %00000000

    .charmap 'o', 59
    .byte %00000000
    .byte %00000000
    .byte %01111000
    .byte %11001100
    .byte %11001100
    .byte %11001100
    .byte %01111000
    .byte %00000000

    .charmap 'p', 60
    .byte %00000000
    .byte %00000000
    .byte %01111000
    .byte %11001100
    .byte %11001100
    .byte %11111000
    .byte %11000000
    .byte %11000000

    .charmap 'q', 61
    .byte %00000000
    .byte %00000000
    .byte %01111000
    .byte %11001100
    .byte %11001100
    .byte %01111100
    .byte %00001100
    .byte %00001100

    .charmap 'r', 62
    .byte %00000000
    .byte %00000000
    .byte %11011000
    .byte %11110000
    .byte %11000000
    .byte %11000000
    .byte %11000000
    .byte %00000000

    .charmap 's', 63
    .byte %00000000
    .byte %00000000
    .byte %01111100
    .byte %11000000
    .byte %01111000
    .byte %00001100
    .byte %11111000
    .byte %00000000

    .charmap 't', 64
    .byte %00000000
    .byte %01100000
    .byte %11111000
    .byte %01100000
    .byte %01100000
    .byte %01100000
    .byte %00111000
    .byte %00000000

    .charmap 'u', 65
    .byte %00000000
    .byte %00000000
    .byte %11001100
    .byte %11001100
    .byte %11001100
    .byte %11001100
    .byte %01111000
    .byte %00000000

    .charmap 'v', 66
    .byte %00000000
    .byte %00000000
    .byte %11001100
    .byte %11001100
    .byte %11011000
    .byte %11110000
    .byte %01100000
    .byte %00000000

    .charmap 'w', 67
    .byte %00000000
    .byte %00000000
    .byte %11000110
    .byte %11000110
    .byte %11010110
    .byte %11111110
    .byte %01101100
    .byte %00000000

    .charmap 'x', 68
    .byte %00000000
    .byte %00000000
    .byte %11001100
    .byte %11001100
    .byte %01111000
    .byte %11001100
    .byte %11001100
    .byte %00000000

    .charmap 'y', 69
    .byte %00000000
    .byte %00000000
    .byte %11011000
    .byte %11011000
    .byte %11011000
    .byte %01110000
    .byte %00110000
    .byte %01100000

    .charmap 'z', 70
    .byte %00000000
    .byte %00000000
    .byte %11111100
    .byte %00001100
    .byte %01111000
    .byte %11000000
    .byte %11111100
    .byte %00000000

    .charmap ' ', 71
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000

    .charmap '!', 72
    .byte %11000000
    .byte %11000000
    .byte %11000000
    .byte %11000000
    .byte %00000000
    .byte %11000000
    .byte %11000000
    .byte %00000000

    ; Sprite zero tile
    .charmap '&', 73
    .byte $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF
    ;.byte %10000000
    ;.byte %00000000
    ;.byte %00000000
    ;.byte %00000000
    ;.byte %00000000
    ;.byte %00000000
    ;.byte %00000000
    ;.byte %00000000



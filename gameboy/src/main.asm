INCLUDE "gb/constants.inc"
INCLUDE "gb/hardware.inc"

SECTION "Header", ROM0[$100]

EntryPoint:
    di 
    jp Start

    REPT $150 - $104
        db 0
    ENDR

SECTION "Pong", ROM0

Start:
    call wait_v_blank
    call lcd_off 
    call clearOAM
    call copyFont
    call loadAssets
    call drawPaddles

; Draw title at the bottom
.drawStrings
    ld hl, $9a20
    ld de, GameTitle
    call showString

.displayRegisters
    ld a, %11100100
    ld [LCD_BG_PAL], a
    call reset_scan_lines
    call sound_off
    call lcd_on


Main: 
    call wait_v_blank
    call UpdateKeys

    CheckDown:
        ld a, [wCurKeys]
        and a, PADF_DOWN
        jp z, CheckUp
    Down:
        ; Move the paddle one pixel down.
        ld a, [_OAMRAM+0]
        inc a
        ; If we've already hit the edge of the playfield, don't move.
        cp a, 150
        jp z, Main
        ld [_OAMRAM+0], a
        jp Main

    CheckUp:
        ld a, [wCurKeys]
        and a, PADF_UP
        jp z, Main
    Up:
        ; Move the paddle one pixel to the right.
        ld a, [_OAMRAM+0]
        dec a
        ; If we've already hit the edge of the playfield, don't move.
        cp a, 15
        jp z, Main
        ld [_OAMRAM+0], a


    jp Main


UpdateKeys:
    ; Poll half the controller
    ld a, P1F_GET_BTN
    call .onenibble
    ld b, a ; B7-4 = 1; B3-0 = unpressed buttons

    ; Poll the other half
    ld a, P1F_GET_DPAD
    call .onenibble
    swap a ; A3-0 = unpressed directions; A7-4 = 1
    xor a, b ; A = pressed buttons + directions
    ld b, a ; B = pressed buttons + directions

    ; And release the controller
    ld a, P1F_GET_NONE
    ldh [rP1], a

    ; Combine with previous wCurKeys to make wNewKeys
    ld a, [wCurKeys]
    xor a, b ; A = keys that changed state
    and a, b ; A = keys that changed to pressed
    ld [wNewKeys], a
    ld a, b
    ld [wCurKeys], a
    ret

.onenibble
    ldh [rP1], a ; switch the key matrix
    call .knownret ; burn 10 cycles calling a known ret
    ldh a, [rP1] ; ignore value while waiting for the key matrix to settle
    ldh a, [rP1]
    ldh a, [rP1] ; this read counts
    or a, $F0 ; A7-4 = 1; A3-0 = unpressed keys
.knownret
    ret

SECTION "Input Variables", WRAM0
wCurKeys: db
wNewKeys: db

SECTION "Counter", WRAM0
wFrameCounter: db

Section "String Storage", ROM0
GameTitle:
  db "    Pong    ", 0

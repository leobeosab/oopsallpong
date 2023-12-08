INCLUDE "gb/constants.inc"

SECTION "Header", ROM0[$100]
    jp EntryPoint

    ds $150 - @, 0 ; Make room for the header
EntryPoint:
    jp Start

SECTION "Pong Code", ROM0

Start:
  call wait_v_blank
  call lcd_off 
  call copyFont

.drawStrings
  ld hl, $9a20
  ld de, GameTitle
  call showString


ld b, 1
ld c, 1

.displayRegisters
    ld a, %11100100
    ld [LCD_BG_PAL], a
    call reset_scan_lines
    call sound_off
    call lcd_on

.lockup
    jr .lockup

sound_off::
    xor a
    ld [SOUND_CONTROL], a
ret

Section "String Storage", ROM0
GameTitle:
  db "    Pong 3   ", 0

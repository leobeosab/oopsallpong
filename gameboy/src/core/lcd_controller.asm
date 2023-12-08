SECTION "LCD code", ROM0

INCLUDE "gb/constants.inc"
INCLUDE "gb/hardware.inc"

lcd_off::
    xor a
    ld [LCD_CTRL], a
ret

lcd_on::
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON
    ld [LCD_CTRL], a
ret

reset_scan_lines::
    xor a
    ld [LCD_SCROLL_Y], a
    ld [LCD_SCROLL_X], a
ret

wait_v_blank::
.waitVBlank
    ld a, [LCD_LINE_Y]
    cp 144
    jr nz, .waitVBlank
ret

clear_bg_map::
    ld HL, $9600

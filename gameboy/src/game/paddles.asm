INCLUDE "gb/hardware.inc"

SECTION "paddle_code", rom0

; paddle_one = or[0-3]
; paddle_two = or[4-7]

; draw paddle_1
drawPaddles::
    ld hl, _OAMRAM
    ld a, 128+16
    ld [hli], a
    ld a, 8
    ld [hli], a
    ld a, 0
    ld [hli], a
    ld [hl], a
ret

updatePaddles::
    ld a, [_OAMRAM+0]
    inc a
    ld [_OAMRAM+0], a
ret

INCLUDE "gb/constants.inc"
INCLUDE "gb/hardware.inc"

SECTION "graphics_storage", rom0

copyFont::
    ld hl, $9000
    ld de, FontTiles
    ld bc, FontTilesEnd - FontTiles
    call memCopy
ret

loadAssets::
    ld hl, $8000
    ld de, Paddle
    ld bc, 16
    call memCopy
ret

clearOAM::
    ld a, 0
    ld b, 160
    ld hl, _OAMRAM
ClearOam:
    ld [hli], a
    dec b
    jp nz, ClearOam
ret

showString::
.copyString
    ld a, [de]
    ld [hli], a
    inc de
    and a
    jr nz, .copyString
ret

Paddle:
DB $18, $18, $18, $18, $18, $18, $18, $18
DB $18, $18, $18, $18, $18, $18, $18, $18

FontTiles:
INCBIN "assets/font.chr"
FontTilesEnd:

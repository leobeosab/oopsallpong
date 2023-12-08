INCLUDE "gb/constants.inc"

SECTION "graphics_storage", rom0

copyFont::
    ld hl, $9000
    ld de, FontTiles
    ld bc, FontTilesEnd - FontTiles
    call memCopy
ret

loadAssets::
    ld hl, $9000 + 16
    ld de, Paddle
    ld bc, 16
    call memCopy
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
DB $e0, $e0, $e7, $e7, $e1, $e1, $ff, $ff
DB $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0
PaddleEnd:

FontTiles:
INCBIN "assets/font.chr"
FontTilesEnd:

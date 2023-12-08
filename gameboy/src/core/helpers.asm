INCLUDE "gb/constants.inc"

Section "helpers", ROM0

memCopy::
  ; hl start address
  ; ld start data address
  ; b datasize
.copyloop
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, .copyloop
ret

sound_off::
    xor a
    ld [SOUND_CONTROL], a
ret

haltProgram::
  halt
ret

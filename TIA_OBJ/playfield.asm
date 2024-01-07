    PROCESSOR 6502

    ; Include headers for VCS and macro definitions
    INCLUDE "vcs.h"
    INCLUDE "macro.h"

    ; Start the code segment at $F000
    SEG Code
    ORG $F000

Reset:
    ; Initialize game environment and set colors
    clean_start       ; Clear the screen/startup routine
    ldx #$80          ; Load the color blue into X
    stx COLUBK        ; Set background color to blue
    lda #$1C          ; Load the color yellow into A
    sta COLUPF        ; Set playfield color to yellow

StartFrame:
    ; Setup VBLANK and VSYNC to start a new frame
    lda #2
    sta VBLANK
    sta VSYNC

    ; Generate 3 lines of vertical sync
    REPEAT 3
        sta WSYNC
    REPEND

    ; Turn off VSYNC
    lda #0
    sta VSYNC

    ; Generate 37 lines of vertical blank
    REPEAT 37
        sta WSYNC
    REPEND

    ; Turn off VBLANK
    lda #0
    sta VBLANK

    ; Set CTRLPF to reflect the pixels
    ldx #01
    stx CTRLPF

    ; Draw the playfield (192 lines)
    ; First 7 blue lines
    ldx #0
    stx PF0
    stx PF1
    stx PF2
    REPEAT 7
        sta WSYNC
    REPEND

    ; Middle section with pattern
    ldx #%11100000
    stx PF0
    ldx #%11111111
    stx PF1
    stx PF2
    REPEAT 7
        sta WSYNC
    REPEND

    ; Main playfield area
    ldx #%00100000
    stx PF0
    ldx #0
    stx PF1
    stx PF2
    REPEAT 164
        sta WSYNC
    REPEND

    ; Bottom frame with pattern
    ldx #%11100000
    stx PF0
    ldx #%11111111
    stx PF1
    stx PF2
    REPEAT 7
        sta WSYNC
    REPEND

    ; Last 7 blue lines
    ldx #0
    stx PF0
    stx PF1
    stx PF2
    REPEAT 7
        sta WSYNC
    REPEND

    ; End frame rendering
    lda #2
    sta VBLANK

    ; Generate 30 lines of overscan
    REPEAT 30
        sta WSYNC
    REPEND

    ; Turn off VBLANK
    lda #0
    sta VBLANK

    ; Loop back to start of frame rendering
    jmp StartFrame

    ; Define ROM size (4KB) and set reset vector
    ORG $FFFC
    .WORD Reset  ; Reset vector
    .WORD Reset  ; Interrupt vector (unused, set to start)

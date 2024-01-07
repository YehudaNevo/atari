    PROCESSOR 6502

    ; Include VCS (Video Computer System) and macro headers
    INCLUDE "vcs.h"
    INCLUDE "macro.h"
    

    ; Set up the code segment starting at $F000
    SEG Code
    ORG $F000

Start:
    ; Initialize the game environment
    clean_start

    ; Main loop for frame rendering
NextFrame:
    ; Set up VBLANK and VSYNC for a new frame
    LDA #2
    STA VBLANK
    STA VSYNC

    ; Generate three lines of vertical sync
    STA WSYNC  ; First line of VSYNC
    STA WSYNC  ; Second line of VSYNC
    STA WSYNC  ; Third line of VSYNC

    ; Turn off vertical sync
    LDA #0
    STA VSYNC

    ; Generate 37 lines of vertical blank
    LDX #37     ; Initialize line counter
LoopVBlank:
    STA WSYNC   ; Wait for each line to complete
    DEX         ; Decrement line counter
    BNE LoopVBlank  ; Repeat until all lines are processed

    ; Disable VBLANK
    LDA #0
    STA VBLANK

   ; INC COLUBK ; ?


    ; Rendering visible scanlines (display kernel)
    LDX #192    ; Set counter for 192 visible lines
LoopScanLines:
    STX COLUBK  ; Set background color
    STA WSYNC   ; Synchronize with the TV's scanline
    DEX         ; Decrement line counter
    BNE LoopScanLines  ; Continue rendering each scanline

    ; Begin 30 lines of overscan to complete the frame
    LDA #2
    STA VBLANK

    LDX #30     ; Set overscan line counter
LoopOverscan:
    STA WSYNC   ; Synchronize with each overscan line
    DEX         ; Decrement line counter
    BNE LoopOverscan  ; Repeat until all lines are processed

    ; Repeat the frame rendering process
    JMP NextFrame

    ; Define ROM size (4KB) and reset vector
    ORG $FFFC
    .WORD Start  ; Reset vector
    .WORD Start  ; Interrupt vector (unused, set to start)

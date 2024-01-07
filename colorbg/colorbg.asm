
    PROCESSOR 6502;

    include "macro.h";
    include "vcs.h";
     

    seg code
    org $F000; def the org of the rom 

START:
    ;CLEAN_START;
    LDA #$1E; 1E IS NTSC YELLOW 
    STA COLUBK;

    JMP START

    ;END
    ORG $FFFC;
    .WORD START
    .WORD START
    





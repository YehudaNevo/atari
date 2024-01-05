    processor 6502

    seg code 
    org $F000 

Start:
    sei         ; disable interrupts 
    cld         ; disable the BCD deciaml math mode 
    ldx #$FF     ; load x reg ff
    txs         ; transfer the x reg to stuck ptr  ( now s ptr point to the last addr )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;        clean the ram and regs 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    lda #0
    ldx #$FF
    sta $FF;

MemLoop:
    dex
    sta $0,x;
    bne MemLoop



;fill the rom size to 4kb 

    org $FFFC
    .word Start 
    .word Start








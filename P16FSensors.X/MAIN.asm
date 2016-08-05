;**********************************************************************
;   This file is a basic code template for object module code         *
;   generation on the PIC16F877A. This file contains the              *
;   basic code building blocks to build upon.                         *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler and linker (Document DS33014).          *
;                                                                     *
;   Refer to the respective PIC data sheet for additional             *
;   information on the instruction set.                               *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Filename:      xxx.asm                                           *
;    Date:                                                            *
;    File Version:                                                    *
;                                                                     *
;    Author:       D.N. Amerasinghe                                   *
;    Company:                                                         *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Files required: P16F877A.INC                                     *
;                                                                     *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:                                                           *
;                                                                     *
;                                                                     *
;                                                                     *
;                                                                     *
;**********************************************************************


    list        p=16f877a   ; list directive to define processor
    #include    <p16f877a.inc>  ; processor specific variable definitions


    extern  drive_OW_low
    extern  drive_OW_high
    extern  read_OW
    extern  OW_write_byte
    extern  OW_read_byte
    extern  OW_reset_pulse
    ;extern  OW_write_bit
    ;extern  OW_read_bit

    extern  usart_init
    extern  TXPoll
    extern  RXPoll
    extern  hex2ascii
    

    ;__CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_ON & _RC_OSC & _WRT_OFF & _LVP_ON & _CPD_OFF
    __CONFIG  _FOSC_HS & _WRT_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_ON

; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.


cblock  0x20
endc

;***** VARIABLE DEFINITIONS (examples)

; example of using Shared Uninitialized Data Section
INT_VAR     UDATA_SHR
w_temp      RES     1       ; variable used for context saving
status_temp RES     1       ; variable used for context saving
pclath_temp RES	    1       ; variable used for context saving

; example of using Uninitialized Data Section
TEMP_VAR    UDATA           ; explicit address specified is not required
romcode     RES     1
scratchpad  RES     9       ; ds18B20 scratch memory

; example of using Overlayed Uninitialized Data Section
; in this example both variables are assigned the same GPR location by linker
G_DATA      UDATA_OVR       ; explicit address can be specified
flag        RES 2           ; temporary variable (shared locations - G_DATA)

G_DATA      UDATA_OVR
;count       RES 2           ; temporary variable (shared locations - G_DATA)

;**********************************************************************
RESET_VECTOR    CODE    0x0000 ; processor reset vector
    nop                        ; nop for icd
    pagesel start
    goto    start              ; go to beginning of program


INT_VECTOR      CODE    0x0004 ; interrupt vector location

INTERRUPT

    movwf   w_temp          ; save off current W register contents
    movf    STATUS,w        ; move status register into W register
    movwf   status_temp     ; save off contents of STATUS register
    movf    PCLATH,w        ; move pclath register into w register
    movwf   pclath_temp     ; save off contents of PCLATH register

; isr code can go here or be located as a call subroutine elsewhere

    movf    pclath_temp,w   ; retrieve copy of PCLATH register
    movwf   PCLATH          ; restore pre-isr PCLATH register contents
    movf    status_temp,w   ; retrieve copy of STATUS register
    movwf   STATUS          ; restore pre-isr STATUS register contents
    swapf   w_temp,f
    swapf   w_temp,w        ; restore pre-isr W register contents
    retfie                  ; return from interrupt

MAIN_PROG       CODE

start
    pagesel setup_pic
    call    setup_pic

    ;movlw   0xFF
    ;banksel PORTB
    ;movwf   PORTB

    pagesel loop
    call    loop

    goto $

loop

    pagesel OW_reset_pulse
    call    OW_reset_pulse

    ;andlw .1
    ;banksel PORTB
    ;btfss   PORTB, RB4
    ;bsf     PORTB, RB2

    nop

    ;movlw   0xCC
    ;pagesel OW_write_byte
    ;call    OW_write_byte


    movlw   0x33
    pagesel OW_write_byte
    call    OW_write_byte

    pagesel OW_read_byte
    call    OW_read_byte
    nop


    ;movlw   0x28
    banksel romcode
    movwf   romcode


    movlw   0x28
    banksel romcode
    xorwf   romcode, w
    btfsc   STATUS, Z
    bsf     PORTB, RB2

    ;bsf     PORTB, RB2
    ;banksel PORTB
    ;btfsc   PORTB, RB4
    ;goto    $-1
    ;bsf     PORTB, RB2
;_loop_
    ;movlw   'X'

    ;movlw    0x43
    ;addlw   .30
    banksel romcode
    movf    romcode, w
    ;andlw   0x0F
    pagesel hex2ascii
    call    hex2ascii
    ;movf    romcode, w
    ;pagesel TXPoll
    ;call    TXPoll


    ;goto    _loop_
    goto    $
    goto    loop
    return

setup_pic                         ; setting up pic peripherals
    ; switching to bank 0
    bcf     STATUS, RP0
    bcf     STATUS, RP1
    clrf    PORTB

    ; turning off A/D converter
    bcf    ADCON0, ADON

    ; switching to bank 1
    bsf     STATUS, RP0
    clrf    TRISB

    ; switching to bank 0
    bcf     STATUS, RP0

    ;pagesel TRISB
    ;movf    TRISB, w
    ;pagesel ow_tris
    ;movwf   ow_tris

    ;pagesel PORTB
    ;movf    PORTB, w
    ;pagesel ow_port
    ;movwf   ow_port

    ;pagesel RB4
    ;movf    RB4, w
    ;pagesel ow_pin
    ;movwf   ow_pin


    pagesel usart_init
    call    usart_init

    return

setup_sensors
    ;DS18B20 Command Sequence
	; Initialization
	; ROM Command
	; DS18B20 Function Command


    return

ds18b20_reset
    
    return
    END                       ; directive 'end of program'




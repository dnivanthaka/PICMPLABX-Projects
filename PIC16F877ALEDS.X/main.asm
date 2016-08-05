; Templates location /usr/local/microchip/mplabx/mpasmx/templates/Object
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
;    Author:                                                          *
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
    #include    "macros.inc"

    ;__CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_ON & _RC_OSC & _WRT_OFF & _LVP_ON & _CPD_OFF
    __CONFIG  _FOSC_HS & _WRT_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_ON



; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.

extern delay500us
extern delay250ms
extern delayms

;***** VARIABLE DEFINITIONS (examples)

; example of using Shared Uninitialized Data Section
INT_VAR     UDATA_SHR
w_temp      RES     1       ; variable used for context saving
status_temp RES     1       ; variable used for context saving
pclath_temp RES	    1       ; variable used for context saving

; example of using Uninitialized Data Section
TEMP_VAR    UDATA           ; explicit address specified is not required
free_counter RES    1
b_level      RES    1
tempvar      RES    1
tempvar2     RES    1
seqvar       RES    1
lvlvar       RES    1
fxdata       RES    2
sPORTD       RES    1

; example of using Overlayed Uninitialized Data Section
; in this example both variables are assigned the same GPR location by linker
G_DATA      UDATA_OVR       ; explicit address can be specified
flag        RES 2           ; temporary variable (shared locations - G_DATA)

G_DATA      UDATA_OVR
count       RES 2           ; temporary variable (shared locations - G_DATA)

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


    ;Duty cycle checking
    banksel b_level
    movf    b_level, w

    pagesel get_level
    call    get_level
    
    banksel tempvar
    movwf   tempvar

    movlw   .0
    xorwf   tempvar, w
    btfss   STATUS, Z
    goto    _duty_start_
    movlw   0x00
    banksel PORTD
    movwf   PORTD
    goto    _period_done_

_duty_start_:
    movf    tempvar, w
    ;movlw   .0
    banksel free_counter
    xorwf   free_counter, w
    btfss   STATUS, Z
    goto    _duty_done_
    movlw   0x00
    banksel PORTD
    movwf   PORTD
    ;pagesel set_leds
    ;call    set_leds


_duty_done_:
    ;Period checking
    movlw   .100                ;100us * 100 = 10ms
    banksel free_counter
    xorwf   free_counter, w
    btfss   STATUS, Z
    goto    _period_done_
    movlw   0xFF
    banksel PORTD
    movwf   PORTD

    banksel free_counter
    clrf    free_counter

_period_done_:
    banksel free_counter
    incf    free_counter, f

    banksel INTCON
    bcf     INTCON, TMR0IF


    movf    pclath_temp,w   ; retrieve copy of PCLATH register
    movwf   PCLATH          ; restore pre-isr PCLATH register contents
    movf    status_temp,w   ; retrieve copy of STATUS register
    movwf   STATUS          ; restore pre-isr STATUS register contents
    swapf   w_temp,f
    swapf   w_temp,w        ; restore pre-isr W register contents

    retfie                  ; return from interrupt

MAIN_PROG       CODE


start
    pagesel init
    call    init

    banksel free_counter
    clrf    free_counter

    banksel b_level
    clrf    b_level

    banksel sPORTD
    clrf    sPORTD

    ;pagesel serial_init
    ;call    serial_init


loop
    
    banksel PORTB
    bsf     PORTB, RB2

    movlw   .0
    banksel b_level
    movwf   b_level

    movlw   .100
    pagesel delayms
    call    delayms

    ;pagesel delay250ms
    ;call    delay250ms

    movlw   .1
    banksel b_level
    movwf   b_level

    movlw   .100
    pagesel delayms
    call    delayms

    ;pagesel delay250ms
    ;call    delay250ms

    movlw   .2
    banksel b_level
    movwf   b_level

    movlw   .100
    pagesel delayms
    call    delayms

    ;pagesel delay250ms
    ;call    delay250ms

    movlw   .3
    banksel b_level
    movwf   b_level

    movlw   .100
    pagesel delayms
    call    delayms

    ;pagesel delay250ms
    ;call    delay250ms

    movlw   .4
    banksel b_level
    movwf   b_level

    movlw   .100
    pagesel delayms
    call    delayms

    ;pagesel delay250ms
    ;call    delay250ms


    ;movlw   .5
    ;banksel b_level
    ;movwf   b_level

    ;movlw   .100
    ;pagesel delayms
    ;call    delayms

    ;pagesel delay250ms
    ;call    delay250ms

goto    loop
    ;goto $

init
    ;Shutting down ADC
    ;Switching to Bank0
    BANK0

    clrf    PORTB
    clrf    PORTD

    movlw   0x00
    movwf   ADCON0

    ;Switching to Bank 1
    BANK1

    movlw   0x06
    movwf   ADCON1

    ;Setting TRISB
    ;movlw   0x00
    ;movwf   TRISB
    bcf     TRISB, RB2

    movlw   0x00
    movwf   TRISD

    ;Enabling TMR0 interrupts
    movlw   0x00
    movwf   OPTION_REG          ;1:2 => (200ns*2) * 256 = 100us

    movlw   0xA0
    movwf   INTCON

    ;Switching to Bank 0
    BANK0

    clrf    TMR0
    return

get_level
    addwf   PCL, f
    retlw   .0
    retlw   .20
    retlw   .50
    ;retlw   .50
    ;retlw   .70
    retlw   .100

    return

get_seq
    addwf   PCL, f
    retlw   b'11100100'

    return

set_leds
    movlw   .4
    banksel tempvar
    movwf   tempvar

    movlw   .0
    banksel get_seq
    call    get_seq

    banksel seqvar
    movwf   seqvar

led_loop:

    movlw   b'11000000'
    banksel seqvar
    andwf   seqvar, w

    banksel tempvar2
    movwf   tempvar2

    swapf   tempvar2, f
    rrf     tempvar2, f
    rrf     tempvar2, f
    movf    tempvar2, w

    pagesel get_level
    call    get_level

    banksel tempvar2
    movwf   tempvar2

    ;movlw   .0
    ;xorwf   tempvar2, w
    ;btfss   STATUS, Z
    ;goto    _duty_start_
    ;movlw   0x00
    ;banksel PORTD
    ;movwf   PORTD
    ;goto    _period_done_


    movf    tempvar2, w
    ;movlw   .0
    banksel free_counter
    xorwf   free_counter, w
    btfss   STATUS, Z
    goto    _skip_
    ;movlw   0x00
    banksel sPORTD
    movf    sPORTD, w

    banksel tempvar
    andwf   tempvar, w
    banksel tempvar2
    movwf   tempvar2
    comf    tempvar2, f


    ;banksel tempvar2
    ;movwf   tempvar2
    ;comf    tempvar2, f

    banksel sPORTD
    movf    sPORTD, w
    banksel tempvar2
    andwf   tempvar2, w
    banksel sPORTD
    movwf   sPORTD


    banksel PORTD
    ;movwf   PORTD
    ;bcf     PORTD,
    movwf   PORTD

_skip_:
    banksel seqvar
    rlf     seqvar, f

    banksel tempvar
    decfsz  tempvar, f
    goto    led_loop

    return
    END                       ; directive 'end of program'












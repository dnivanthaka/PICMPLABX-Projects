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

extern i2c_slave_init
extern i2c_handler
extern ssp_buffer

    ;__CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_ON & _RC_OSC & _WRT_OFF & _LVP_ON & _CPD_OFF
    __CONFIG  _FOSC_HS & _WRT_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_ON

; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.

;***** VARIABLE DEFINITIONS (examples)

; example of using Shared Uninitialized Data Section
INT_VAR     UDATA_SHR
w_temp      RES     1       ; variable used for context saving
status_temp RES     1       ; variable used for context saving
pclath_temp RES	    1       ; variable used for context saving

; example of using Uninitialized Data Section
TEMP_VAR    UDATA           ; explicit address specified is not required
free_counter RES     1
duty_ticks   RES     1
servo1_val   RES     1
servo2_val   RES     1
main_tick    RES     1

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

    banksel PIR1
    btfss   PIR1, SSPIF
    goto    _no_ssp_
    pagesel i2c_handler
    call    i2c_handler
    banksel PIR1
    bcf     PIR1, SSPIF
    movlw   .0
    banksel ssp_buffer
    xorwf   ssp_buffer, w
    btfsc   STATUS, Z
    goto    _no_servo_
    ;banksel ssp_buffer
    ;movf    ssp_buffer+1, w
    ;movlw   .1
    movf    ssp_buffer, w
    xorlw   0x1
    ;xorwf   ssp_buffer, w
    btfss   STATUS, Z
    goto    _no_servo_
    ;goto    _set_1_
    ;goto    _set_2_

    banksel ssp_buffer
    movf    ssp_buffer+1, w
    banksel servo1_val
    movwf   servo1_val

    banksel ssp_buffer
    movf    ssp_buffer+2, w
    banksel servo2_val
    movwf   servo2_val
    goto    _no_servo_
    

;_set_1_:
    ;banksel ssp_buffer
    ;movf    ssp_buffer+1, w
    ;banksel servo2_val
    ;movwf   servo2_val
    ;goto    _no_servo_

;_set_2_:
    ;banksel ssp_buffer
    ;movf    ssp_buffer+1, w
    ;banksel servo1_val
    ;movwf   servo1_val
    ;goto    _no_servo_

    
_no_ssp_:
    banksel free_counter
    incf    free_counter, f
    movf    free_counter, w

    banksel  servo1_val
    xorwf    servo1_val, w
    btfss    STATUS, Z
    goto     _servo1_period_done_
    banksel  PORTB
    bcf      PORTB, RC1

_servo1_period_done_:
    banksel  free_counter
    movf     free_counter, w
    banksel  servo2_val
    xorwf    servo2_val, w
    btfss    STATUS, Z
    goto     _servo2_period_done_
    banksel  PORTB
    bcf      PORTB, RC2

_servo2_period_done_:
    ;Duty cycle checking
    banksel free_counter
    movf    free_counter, w
    xorlw   .255             ; 100us * 255 = 25.5ms
    btfss   STATUS, Z
    goto    _duty_done_
    movlw   0x06
    banksel PORTB
    movwf   PORTB

_duty_done_:

    ;Renabling TMR0 interrupts
    banksel INTCON
    bcf     INTCON, TMR0IF

_no_servo_:
    movf    pclath_temp,w   ; retrieve copy of PCLATH register
    movwf   PCLATH          ; restore pre-isr PCLATH register contents
    movf    status_temp,w   ; retrieve copy of STATUS register
    movwf   STATUS          ; restore pre-isr STATUS register contents
    swapf   w_temp,f
    swapf   w_temp,w        ; restore pre-isr W register contents

    retfie                  ; return from interrupt

MAIN_PROG       CODE


start
    banksel free_counter
    clrf    free_counter

    banksel main_tick
    clrf    main_tick

    movlw   .15
    banksel servo1_val
    movwf   servo1_val

    ;movlw   .15
    banksel servo2_val
    movwf   servo2_val

    pagesel init
    call    init

    pagesel i2c_slave_init
    call    i2c_slave_init

loop
    goto $

    ;banksel PIR1
    ;btfss   PIR1, SSPIF
    ;goto    _no_ssp_
    ;pagesel i2c_handler
    ;call    i2c_handler
    ;banksel PIR1
    ;bcf     PIR1, SSPIF
    ;pagesel PORTB
    ;bcf     PORTB, RB2

;_no_ssp_:

    goto    loop
    ;goto $

init
    ;Shutting down ADC
    ;Switching to Bank0
    bcf STATUS, RP0
    bcf STATUS, RP1

    clrf    PORTB

    movlw   0x00
    movwf   ADCON0

    ;movlw   0x00
    ;movwf   PORTB

    ;Switching to Bank 1
    bsf     STATUS, RP0

    movlw   0x06
    movwf   ADCON1

    ;Setting TRISB
    movlw   0x00
    movwf   TRISB

    ;Enabling TMR0 interrupts
    movlw   0x00
    movwf   OPTION_REG          ;1:2 => (200ns*2) * 256 = 100us

    movlw   0xA0
    movwf   INTCON

    ;Switching to Bank 0
    bcf STATUS, RP0

    clrf    TMR0
    return

    END                       ; directive 'end of program'



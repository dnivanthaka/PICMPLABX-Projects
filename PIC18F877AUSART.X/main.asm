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

    ;__CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_ON & _RC_OSC & _WRT_OFF & _LVP_ON & _CPD_OFF
    __CONFIG  _FOSC_HS & _WRT_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_ON

; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.

;************* Macros ****************
BANK0 MACRO
    bcf STATUS, RP0
    bcf STATUS, RP1
    ENDM

BANK1 MACRO
    bsf STATUS, RP0
    bcf STATUS, RP1
    ENDM

BANK2 MACRO
    bcf STATUS, RP0
    bsf STATUS, RP1
    ENDM

BANK3 MACRO
    bsf STATUS, RP0
    bsf STATUS, RP1
    ENDM
;*************************************

;***** VARIABLE DEFINITIONS (examples)

; example of using Shared Uninitialized Data Section
INT_VAR     UDATA_SHR
w_temp      RES     1       ; variable used for context saving
status_temp RES     1       ; variable used for context saving
pclath_temp RES	    1       ; variable used for context saving

; example of using Uninitialized Data Section
TEMP_VAR    UDATA           ; explicit address specified is not required
free_counter RES    1

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

    pagesel serial_init
    call    serial_init


loop
    movlw   'P'
    pagesel serial_txpoll
    call    serial_txpoll

    ;movlw   'X'
    ;pagesel serial_txpoll
    ;call    serial_txpoll

    movlw   0x0
    pagesel outmessage
    call    outmessage

    banksel PORTB
    bsf     PORTB, RB2

    ;goto    loop
    ;goto $

init
    ;Shutting down ADC
    ;Switching to Bank0
    BANK0

    clrf    PORTB

    movlw   0x00
    movwf   ADCON0

    ;movlw   0x00
    ;movwf   PORTB

    ;Switching to Bank 1
    BANK1

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
    BANK0

    clrf    TMR0
    return

serial_init
    BANK1
    bsf TRISC, RC7
    bcf TRISC, RC6

    ;Clearing out TX and RX registers
    BANK0
    clrf    TXREG
    clrf    RCREG

    ;Setting baud rate of 19200bps -> 15
    BANK1
    movlw   0x40
    movwf   SPBRG

    ;Transmission Mode, Asynchronous Mode, 8N1 format
	movlw	b'00100100'
	movwf	TXSTA

    ;USART enabled with async mode
    BANK0
    movlw   b'10010000'
    movwf   RCSTA

    return

serial_rxpoll
    banksel PIR1
    btfss   PIR1, RCIF
    goto    $-1

    banksel RCREG
    movf    RCREG, w

    return

serial_txpoll
    banksel PIR1
    btfss   PIR1, TXIF
    goto    $-1

    banksel TXREG
    movwf   TXREG

    return

serial_nl
    movlw   0x0D
    pagesel serial_txpoll
    call    serial_txpoll
    movlw   0x0A
    pagesel serial_txpoll
    call    serial_txpoll

    return

getmessages
	addwf	PCL, f
	;dt	"Test Message", 0
	;dt	"Test Message2", 0
	dt "-------------------------------------------", 0x0D, 0x0A
	dt "Test Message", 0x0D, 0x0A
	dt "-------------------------------------------", 0
	;return

serial_printmessage
	movwf	FSR

outmessage
	movf	FSR, w
	incf	FSR, f
    pagesel getmessages
	call	getmessages
	xorlw	0
	btfsc	STATUS, Z
	return
    pagesel serial_txpoll
    call    serial_txpoll
	goto	outmessage

MessageOK:
    dt  "OK", 0xd, 0xa
    END                       ; directive 'end of program'






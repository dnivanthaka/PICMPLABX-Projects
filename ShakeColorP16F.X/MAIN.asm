;******************************************************************************
;   This file is a basic code template for object module code                 *
;   generation on the PIC12F675. This file contains the                       *
;   basic code building blocks to build upon.                                 *
;                                                                             *
;   Refer to the MPASM User's Guide for additional information on             *
;   features of the assembler and linker (Document DS33014).                  *
;                                                                             *
;   Refer to the respective PIC data sheet for additional                     *
;   information on the instruction set.                                       *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Filename:      xxx.asm                                                   *
;    Date:                                                                    *
;    File Version:                                                            *
;                                                                             *
;    Author:                                                                  *
;    Company:                                                                 *
;                                                                             *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Files required: P12F675.INC                                              *
;                                                                             *
;                                                                             *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Notes:                                                                   *
;                                                                             *
;******************************************************************************

;------------------------------------------------------------------------------
; PROCESSOR DECLARATION
;------------------------------------------------------------------------------

     LIST      p=12f675              ; list directive to define processor
    #include <p12f675.inc>          ; processor specific variable definitions

;------------------------------------------------------------------------------
;
; CONFIGURATION WORD SETUP
;
; The 'CONFIG' directive is used to embed the configuration word within the 
; .asm file. The lables following the directive are located in the respective 
; .inc file.  See the data sheet for additional information on configuration 
; word settings.
;
;------------------------------------------------------------------------------

    __CONFIG   _CP_OFF & _CPD_OFF & _BODEN_OFF & _MCLRE_ON & _WDT_OFF & _PWRTE_ON & _INTRC_OSC_NOCLKOUT 
    ;__CONFIG   _CP_OFF & _CPD_OFF & _BODEN_OFF & _MCLRE_ON & _WDT_OFF & _PWRTE_ON & _FOSC_HS

;------------------------------------------------------------------------------
; VARIABLE DEFINITIONS
;------------------------------------------------------------------------------

	
; example of using Shared Uninitialized Data Section
INT_VAR     UDATA_SHR   0x20   
W_TEMP      RES     1             ; variable used for context saving 
STATUS_TEMP RES     1             ; variable used for context saving
counter	RES	1 


;------------------------------------------------------------------------------
; EEPROM INITIALIZATION
;
; The 12F675 has 128 bytes of non-volatile EEPROM, starting at address 0x2100
; 
;------------------------------------------------------------------------------
;DATAEE    CODE  0x2100
;    DE    "MCHP"          ; Place 'M' 'C' 'H' 'P' at address 0,1,2,3

;------------------------------------------------------------------------------
; OSCILLATOR CALIBRATION VALUE
;------------------------------------------------------------------------------

;OSC       CODE    0x03FF

; Internal RC calibration value is placed at location 0x3FF by Microchip as
; a 0xADDLW K instruction, where the K is a literal value to be loaded into 
; the OSCCAL register.  

;------------------------------------------------------------------------------
; RESET VECTOR
;------------------------------------------------------------------------------

RESET_VECTOR  CODE    0x0000  ; processor reset vector
        GOTO    START         ; go to beginning of program

;------------------------------------------------------------------------------
; INTERRUPT SERVICE ROUTINE
;------------------------------------------------------------------------------

INT_VECTOR    CODE    0x0004  ; interrupt vector location
        MOVWF   W_TEMP        ; save off current W register contents
        MOVF    STATUS,w      ; move status register into W register
        MOVWF   STATUS_TEMP   ; save off contents of STATUS register

       banksel INTCON
       btfss	    INTCON, GPIF
       goto	    __TMR1_TIMEOUT__
       
       movlw	.0
       banksel	counter
       xorwf	counter, w
       pagesel	start_counter
       btfsc		STATUS, Z
       call		start_counter
       
       
       banksel	counter
       incf counter, f
       
       ;Checking for count
       movlw	.5
       banksel	counter
       xorwf	counter, w
       pagesel	toggle_leds
       btfsc		STATUS, Z
       call		toggle_leds
       
       ;Enabling IOC interrupt
       banksel	INTCON
       bcf		INTCON, GPIF
       
__TMR1_TIMEOUT__
       
      banksel	counter
      clrf		counter
      
      banksel	TMR1H
      clrf		TMR1H
      
      banksel	TMR1L
      clrf		TMR1L
      
      ; Stopping the timer
      movlw	0<<TMR1IE
      banksel	PIE1
      movwf	PIE1
	
      movlw	0<<PEIE
      banksel	INTCON
      movwf	INTCON
      
      banksel	PIR1
      bcf		PIR1, TMR1IF
      

        MOVF    STATUS_TEMP,w ; retrieve copy of STATUS register
        MOVWF   STATUS        ; restore pre-isr STATUS register contents
        SWAPF   W_TEMP,f
        SWAPF   W_TEMP,w      ; restore pre-isr W register contents
        RETFIE                ; return from interrupt

;------------------------------------------------------------------------------
; MAIN PROGRAM
;------------------------------------------------------------------------------

MAIN_PROG     CODE

START

;------------------------------------------------------------------------------
; OSCCAL RESTORE (not required if internal OSC is not used)
;------------------------------------------------------------------------------

;        errorlevel -302
;        BSF     STATUS,RP0    ; set file register bank to 1 
;        CALL    0x3FF         ; retrieve factory calibration value
;        MOVWF   OSCCAL        ; update register with factory cal value 
;        BCF     STATUS,RP0    ; set file register bank to 0
;        errorlevel +302

;------------------------------------------------------------------------------
; PLACE USER PROGRAM HERE
;------------------------------------------------------------------------------

        GOTO $

	
pic_init
	; Shutting down A/D
	bcf STATUS, RP0
	clrf	GPIO
	movlw	0x07
	movwf	CMCON
	bsf STATUS, RP0
	clrf	ANSEL
	
	
	movlw	1<<GP1
	movwf	TRISIO
	
	; Setting up GPIO interrupts, GPIO1
	movlw	1<<IOC1
	banksel	IOC
	movwf	IOC
	
	movlw	1<<GPIE
	banksel	INTCON
	movwf	INTCON
	
	movlw	0<<TRISIO4
	banksel	TRISIO
	movwf	TRISIO
	
	movwf	1<<GP4
	banksel	GPIO
	movwf	GPIO
	
	
	;movlw	1<<GIE
	;banksel	INTCON
	;movwf	INTCON
	
	;Setting up Timer 1, but not enabling it still
	
	;movlw	1<<TMR1IE
	;banksel	PIE1
	;movwf	PIE1
	
	;movlw	1<<PEIE
	;banksel	INTCON
	;movwf	INTCON
	
	movlw	1<<GIE
	movwf	INTCON
	
	
	return
	
start_counter
	movlw	1<<TMR1IE
	banksel	PIE1
	movwf	PIE1
	
	movlw	1<<PEIE
	banksel	INTCON
	movwf	INTCON
	
	return
	
toggle_leds
	
	return
        END                       ; directive 'end of program'




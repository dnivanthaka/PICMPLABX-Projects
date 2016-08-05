;**********************************************************************
;   This file is a basic code template for object module code         *
;   generation on the PIC16F690. This file contains the               *
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
;    Files required: P16F690.INC                                      *
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

    list      p=16F690           ; list directive to define processor
    #include <p16f690.inc>        ; processor specific variable definitions

    errorlevel  -302              ; suppress message 302 from list file

    __CONFIG   _CP_OFF & _CPD_OFF & _BOR_OFF & _MCLRE_ON & _WDT_OFF & _PWRTE_ON & _INTRC_OSC_NOCLKOUT & _FCMEN_OFF & _IESO_OFF 

; '__CONFIG' directive is used to embed configuration word within .asm file.
; The lables following the directive are located in the respective .inc file.
; See data sheet for additional information on configuration word settings.

;Start
;wait for SSPIF and clear it
;Send Addresss
;wait for SSPIF and clear it
;loop while more bytes:
;  Send a byte
;  wait for SSPIF and clear it
;Stop

;***** VARIABLE DEFINITIONS (examples)
;SSPADD = ((Fosc/BitRate)/4)-1
;SSPADD = ( 4MHz / 100KHz ) - 1
#define FOSC	D'8000000'
#define	I2CCLOCK	D'100000'
;#define BAUDRATE	0x06	;100Khz
#define BAUDRATE	(((FOSC/I2CCLOCK)/4) -1)	;100Khz

#define SLAVE_ADDR	0x20

;**********************************************************************
; PORT allocations
;**********************************************************************
#define I2CTRIS	TRISB
#define I2CPORT	PORTB
#define SDA		RB4
#define SCL		RB6
;**********************************************************************
; Macro definitions
;**********************************************************************
SDAHI	MACRO
		;Setting SDA as input
		banksel	I2CTRIS
		bsf		I2CTRIS, SDA
        ;bcf		I2CTRIS, SDA

		;nop
		;nop

		;Setting SDA pin low
		;banksel	I2CPORT
		;bsf		I2CPORT, SDA

		ENDM

SDALO	MACRO
		;Setting SDA as output
		banksel	I2CTRIS
		bcf		I2CTRIS, SDA

		;Setting SDA pin low
		;banksel	I2CPORT
		;bcf		I2CPORT, SDA
		ENDM

SCLHI	MACRO
		;Setting SDA as input
		banksel	I2CTRIS
		bsf		I2CTRIS, SCL
        ;bcf		I2CTRIS, SCL

		;nop
		;nop

		;Setting SDA pin low
		;banksel	I2CPORT
		;bsf		I2CPORT, SCL
		ENDM

SCLLO	MACRO
		;Setting SDA as output
		banksel	I2CTRIS
		bcf		I2CTRIS, SCL

		;Setting SDA pin low
		;banksel	I2CPORT
		;bcf		I2CPORT, SCL
		ENDM
;**********************************************************************

; example of using Shared Uninitialized Data Section
INT_VAR     UDATA_SHR     
w_temp      RES     1       ; variable used for context saving 
status_temp RES     1       ; variable used for context saving
pclath_temp RES     1       ; variable used for context saving

UDATA
temp			RES	1
temp_data		RES	1
temp_address	RES	1
bit_counter		RES	1

;**********************************************************************
RESET_VECTOR    CODE    0x0000       ; processor reset vector
        goto    start                ; go to beginning of program

INT_VECTOR      CODE    0x0004       ; interrupt vector location

INTERRUPT

        movwf   w_temp            ; save off current W register contents
        movf    STATUS,w          ; move status register into W register
        movwf   status_temp       ; save off contents of STATUS register
        movf    PCLATH,w          ; move pclath register into W register
        movwf   pclath_temp       ; save off contents of PCLATH register



; isr code can go here or be located as a call subroutine elsewhere


        movf    pclath_temp,w     ; retrieve copy of PCLATH register
        movwf   PCLATH            ; restore pre-isr PCLATH register contents
        movf    status_temp,w     ; retrieve copy of STATUS register
        movwf   STATUS            ; restore pre-isr STATUS register contents
        swapf   w_temp,f
        swapf   w_temp,w          ; restore pre-isr W register contents
        retfie                    ; return from interrupt

MAIN_PROG       CODE

start
		pagesel	init
		call	init

		pagesel	i2c_start
		call	i2c_start

		;pagesel	i2c_stop
		;call	i2c_stop

		movlw	SLAVE_ADDR
		pagesel	i2c_sendwriteaddr
		call	i2c_sendwriteaddr

        movlw   0x00
        pagesel i2c_sendbyte
        call    i2c_sendbyte

        movlw   0x00
        pagesel i2c_sendbyte
        call    i2c_sendbyte

		pagesel	i2c_stop
		call	i2c_stop

;-------------------------------------

		pagesel	i2c_start
		call	i2c_start

		;pagesel	i2c_stop
		;call	i2c_stop

		movlw	SLAVE_ADDR
		pagesel	i2c_sendwriteaddr
		call	i2c_sendwriteaddr

        movlw   0x12
        pagesel i2c_sendbyte
        call    i2c_sendbyte

        movlw   0xFF
        pagesel i2c_sendbyte
        call    i2c_sendbyte

		pagesel	i2c_stop
		call	i2c_stop

		;movlw	SLAVE_ADDR
		;banksel	temp_address
		;movwf	temp_address

		;pagesel	i2c_sendwriteaddr
		;call	i2c_sendwriteaddr
		;pagesel	i2c_ackwait
		;call	i2c_ackwait
		xorlw	0x0
		btfss	STATUS, Z
		goto	_skip_

		banksel	PORTB
		bsf		PORTB, RB5
_skip_
		pagesel	i2c_stop
		call	i2c_stop

		;pagesel	i2c_sendwriteaddr
loop

        goto    loop             ; loop forever

;------------------------------------------------------------
; Initialization of Device
;------------------------------------------------------------
init
	; Setting Oscillator
	movlw b'01110000'
		  ;--111----	; 8Mhz Crystal
		  ;-----0---	; OSTS - Intrnal Oscillator
		  ;------0--	; HFINTOSC - High Frequency Oscillator
		  ;-------0-	; LFINTOSC - Low Freq. Oscillator
		  ;---------1	; Internal Oscillator is used for Clock
	banksel	OSCCON
	movwf	OSCCON

	; Setting Ports
	bcf	STATUS, RP0	; Bank 0
	bcf	STATUS, RP1

	clrf	PORTB

	bsf	STATUS, RP1	; Bank 2

	clrf	ANSEL
	clrf	ANSELH

	bsf	STATUS, RP0	; Bank 1
	bcf	STATUS, RP1

	;movlw	b'01010000'
	;movwf	TRISB
	movlw	b'01010000'
	;movlw	b'00000000'
	movwf	TRISB

	bcf	STATUS, RP0	; Bank 0

	; Setting up I2C peripheral
	banksel	SSPBUF
	clrf	SSPBUF

	; Setting baud rate
	movlw	BAUDRATE
	banksel	SSPADD
	movwf	SSPADD

	banksel	SSPSTAT
	bcf		SSPSTAT, 6
	bcf		SSPSTAT, 7

	; Mastermode, SSP Enable
	;movlw	b'00111000'
	movlw	b'00101011'
	banksel	SSPCON
	movwf	SSPCON

	; Enabling the SSPIF Flag
	banksel	PIR1
	bcf		PIR1, SSPIF
	;banksel	PIE1
	;bsf		PIE1, SSPIE
	
	return
;------------------------------------------------------------

;------------------------------------------------------------
; I2C Start
;------------------------------------------------------------
i2c_start

	SCLHI
	SDAHI

	SDALO

	pagesel	i2c_delay
	call	i2c_delay

	; SCL is driven Low
	SCLLO

	;banksel	PIR1
	;btfss	PIR1, SSPIF
	;goto	$-1
	;bcf		PIR1, SSPIF

	return
;------------------------------------------------------------
;------------------------------------------------------------
; I2C Restart
;------------------------------------------------------------
i2c_restart

	SCLHI
	SDAHI

    nop
    nop
	SCLLO
    nop
    SCLHI
    nop
    nop
	SDALO
	; SCL is driven Low
	SCLLO

	return
;------------------------------------------------------------

;------------------------------------------------------------
; I2C Stop
;------------------------------------------------------------
i2c_stop
	;banksel	PORTB	
	;bcf		PORTB, RB4

	;banksel	PORTB	
	;bcf		PORTB, RB6
    SCLLO
    SDALO

	SCLHI

	pagesel	i2c_delay
	call	i2c_delay

	SDAHI

	;banksel	PIR1
	;btfss	PIR1, SSPIF
	;goto	$-1
	;bcf		PIR1, SSPIF

	return
;------------------------------------------------------------

;------------------------------------------------------------
; I2C send write address, returns zero when there is a device
;------------------------------------------------------------
i2c_sendwriteaddr
	banksel	temp_address
	movwf	temp_address

	bcf		STATUS, C
	rlf		temp_address, w

	pagesel	i2c_sendbyte
	call	i2c_sendbyte

	;pagesel	i2c_read_bit
	;call	i2c_read_bit

	;pagesel	i2c_ackwait
	;call	i2c_ackwait
	;banksel	PIR1
	;btfss	PIR1, SSPIF
	;goto	$-1
	;bcf		PIR1, SSPIF

	return
;------------------------------------------------------------

;------------------------------------------------------------
; I2C send read address, returns zero when there is a device
;------------------------------------------------------------
i2c_sendreadaddr
	banksel	temp_address
	movwf	temp_address

	bsf		STATUS, C
	rlf		temp_address, w

	pagesel	i2c_sendbyte
	call	i2c_sendbyte

	;pagesel	i2c_read_bit
	;call	i2c_read_bit

	;pagesel	i2c_ackwait
	;call	i2c_ackwait
	;banksel	PIR1
	;btfss	PIR1, SSPIF
	;goto	$-1
	;bcf		PIR1, SSPIF

	return
;------------------------------------------------------------
;------------------------------------------------------------
; Write byte
;------------------------------------------------------------

i2c_sendbyte
	banksel	temp_data
	movwf	temp_data

	bcf		STATUS, C
	banksel	temp_data
	rlf		temp_data, f

    ; Bit 1
	pagesel	i2c_send_bit
	call	i2c_send_bit

	banksel	temp_data
	rlf		temp_data, f
    ; Bit 2
	pagesel	i2c_send_bit
	call	i2c_send_bit

	banksel	temp_data
	rlf		temp_data, f
    ; Bit 3
	pagesel	i2c_send_bit
	call	i2c_send_bit

	banksel	temp_data
	rlf		temp_data, f
    ; Bit 4
	pagesel	i2c_send_bit
	call	i2c_send_bit

	banksel	temp_data
	rlf		temp_data, f
    ; Bit 5
	pagesel	i2c_send_bit
	call	i2c_send_bit

	banksel	temp_data
	rlf		temp_data, f
    ; Bit 6
	pagesel	i2c_send_bit
	call	i2c_send_bit

	banksel	temp_data
	rlf		temp_data, f
    ; Bit 7
	pagesel	i2c_send_bit
	call	i2c_send_bit

	banksel	temp_data
	rlf		temp_data, f
    ; Bit 8
	pagesel	i2c_send_bit
	call	i2c_send_bit

    nop
    nop

    ; Reading Acknowledgement
	pagesel	i2c_read_bit
	call	i2c_read_bit

	;pagesel	i2c_ackwait
	;call	i2c_ackwait
	;banksel	PIR1
	;btfss	PIR1, SSPIF
	;goto	$-1
	;bcf		PIR1, SSPIF

	return
;------------------------------------------------------------
;------------------------------------------------------------
; Write bit
;------------------------------------------------------------
i2c_send_bit

	btfss	STATUS, C
	goto	_zero_
	goto	_one_

_one_
	SDAHI
	goto	_done_

_zero_
	SDALO

_done_
	SCLHI
	pagesel	i2c_delay
	call	i2c_delay
	SCLLO
    SDALO

	return


;------------------------------------------------------------
;------------------------------------------------------------
; Read bit
;------------------------------------------------------------
i2c_read_bit
	
	SDAHI
    SCLHI

	pagesel	i2c_delay
	call	i2c_delay
	;SCLLO

	banksel	I2CPORT
	btfss	I2CPORT, SDA
    goto    _read_zero_
    goto    _read_one_

_read_zero_
    SCLLO
	retlw	0x0

_read_one_
    SCLLO
	retlw	0x1

	return


;------------------------------------------------------------

;------------------------------------------------------------
; I2C Delay
;------------------------------------------------------------
i2c_delay
    ;nop
    nop
    nop
    nop
	return
;------------------------------------------------------------
; initialize eeprom locations

EE      CODE    0x2100
        DE  0x00, 0x01, 0x02, 0x03

        END                       ; directive 'end of program'
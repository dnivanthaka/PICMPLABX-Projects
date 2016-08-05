#include    <p16f877a.inc>  ; processor specific variable definitions

global  RXPoll
global  TXPoll
global  usart_init
global  hex2ascii

UDATA
temp			RES	1
temp2			RES	1
h2acount        RES 1

CODE
;----------------------------
RXPoll
	banksel	PIR1
	btfss	PIR1, RCIF
	;return
	goto	RXPoll
	; Reading value into w
	banksel	RCREG
	movf	RCREG, w

	return
;-----------------------------
TXPoll
	banksel	PIR1
	btfss	PIR1, TXIF
	goto	TXPoll
	; Writing value in w
	banksel	TXREG
	movwf	TXREG

	return
;-----------------------------
	; Initialization of Devices
usart_init
	banksel	TRISB
	bcf		TRISB, RB2

	banksel	TRISC
	bsf		TRISC, RC7
	bcf		TRISC, RC6

	; Clearing out the Transmissions and Recieve data Registers
	banksel	TXREG
	clrf	TXREG
	banksel	RCREG
	clrf	RCREG

; Switching to bank 1
	;bsf	STATUS, RP0
	; Setting baud rate of 19200bps -> 15
	banksel	SPBRG
	;movlw	0x0F
	movlw	0x40
	movwf	SPBRG

	; Transmission Mode, Asynchronous Mode, 8N1 format
	banksel	TXSTA
	movlw	b'00100100'
	movwf	TXSTA

; Switching to bank 0
	;bcf	STATUS, RP0
	; USART enabled with async mode
	banksel	RCSTA
	movlw	b'10010000'
	movwf	RCSTA

	banksel	PORTB
	bcf		PORTB, RB2



	return
;-----------------------------
;-----------------------------
hex2ascii

    banksel temp2
	movwf	temp2

    ;andlw   0xF0

    banksel temp
	movwf	temp
    swapf   temp, f
    movlw   0x0F
    andwf   temp, f

    movlw   .2
    banksel h2acount
    movwf   h2acount

_h2aloop_
    banksel temp
	btfss	temp, 3
	goto	ztn
	xorlw	0x08
	btfsc	STATUS, Z
	goto	ztn
	nop
    banksel temp
	movf	temp, w
	xorlw	0x09
	btfsc	STATUS, Z
	goto	ztn
	nop
	movlw	0x07
    banksel temp
	addwf	temp, f
	
ztn
    banksel temp
	movf	temp, w
	addlw	0x30
	call	TXPoll

    banksel temp2
    ;swapf   temp2, f

    movf    temp2, w
    andlw   0x0F
    banksel temp
    movwf   temp

    banksel h2acount
    decfsz  h2acount, f
    goto    _h2aloop_

	return

;-----------------------------
END



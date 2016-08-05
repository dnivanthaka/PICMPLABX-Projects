#include    <p16f877a.inc>  ; processor specific variable definitions

global  drive_OW_low
global  drive_OW_high
global  read_OW
global  OW_write_byte
global  OW_read_byte
global  OW_reset_pulse
;global  OW_write_bit
;global  OW_read_bit



OW_WAIT: MACRO TIME
    movlw   (TIME/5) - 1
    banksel ow_tmp
    movwf   ow_tmp
    pagesel OW_5delay
    call    OW_5delay
    ENDM

;OW_SETPP:MACRO  TRIS, PORT, PIN
;    movlw   PORT
;    movwf   ow_port

;    movlw   PIN
;    movwf   ow_pin

;	movlw	TRIS
;	movwf	ow_tris
;   ENDM


OWDATA UDATA
ow_tmp    RES     1
ow_tmp2   RES     1
ow_count  RES     1
ow_rxbyte RES     1
ow_txbyte RES     1

OWSDATA UDATA_SHR
ow_port RES     1
ow_tris RES		1
ow_pin  RES     1

CODE

OW_5delay
    banksel ow_tmp
    movwf   ow_tmp

    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1

_ow_5delay_

    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1
    ;goto    $+1
    

    ;goto    $+1
    ;goto    $+1
    ;goto    $+1
    ;goto    $+1
    ;goto    $+1

    ;goto    $+1
    ;goto    $+1
    ;goto    $+1
    ;goto    $+1
    ;goto    $+1

    decfsz  ow_tmp, f
    goto    _ow_5delay_
return

;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
drive_OW_low
    bcf		STATUS, RP0				; Switching to Bank 0
	bcf		PORTB, RB4              ; Setting sensor pin as low
	bsf		STATUS, RP0				; Switching to Bank 1
	bcf		TRISB, RB4              ; Setting pin as output
	bcf		STATUS, RP0				; Switching to Bank 0
    return
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
drive_OW_high
	bsf		STATUS, RP0				; Switching to Bank 1
	bsf		TRISB, RB4              ; Setting pin as input high impedence
	bcf		STATUS, RP0				; Switching to Bank 0
    return
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
read_OW
    pagesel PORTB
    btfss   PORTB, RB4
    retlw   0
    retlw   1

    return
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
OW_write_byte
    banksel ow_txbyte
    movwf   ow_txbyte

    movlw   .8
    banksel ow_count
    movwf   ow_count

_w_loop_
    pagesel drive_OW_low
    call    drive_OW_low
    ;nop
    ;OW_WAIT 10
    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1

    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1

    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1

    ;nop
    banksel ow_txbyte
    rrf     ow_txbyte, f

    ;pagesel drive_OW_high
    banksel TRISB
    btfsc   STATUS, C
    bsf     TRISB, RB4
    ;call    drive_OW_high
    ;nop
    OW_WAIT    .80
    ;nop
    pagesel drive_OW_high
    call    drive_OW_high

    goto    $+1
    goto    $+1
    ;goto    $+1
    ;goto    $+1
    ;goto    $+1

    banksel ow_count
    decfsz  ow_count, f
    goto    _w_loop_

    return
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
OW_read_byte
    movlw   .0
    banksel ow_rxbyte
    movwf   ow_rxbyte

    movlw   .8
    banksel ow_count
    movwf   ow_count

_w_rloop_
    pagesel drive_OW_low
    call    drive_OW_low

    ;nop
    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1

    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1

    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1

    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1


    ;nop
    pagesel drive_OW_high
    call    drive_OW_high

    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1

    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1

    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1

    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1

    ;banksel PORTB
    ;movf   PORTB, w
    ;andlw  1<<4
    ;addlw  .255

	bsf		STATUS, C
    banksel PORTB
	btfss	PORTB, RB4
	bcf		STATUS, C

    banksel ow_rxbyte
    rrf     ow_rxbyte, f
    ;nop
    OW_WAIT .60
    ;nop

    ;goto    $+1
    ;goto    $+1
    ;goto    $+1
    ;goto    $+1

    banksel ow_count
    decfsz  ow_count, f
    goto    _w_rloop_

    banksel ow_rxbyte
    movf    ow_rxbyte, w

    return
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
OW_reset_pulse
    pagesel drive_OW_high
    call    drive_OW_high
    ;nop
    OW_WAIT .20
    ;nop
    pagesel drive_OW_low
    call    drive_OW_low
    nop
    OW_WAIT .450
    nop
    pagesel drive_OW_high
    call    drive_OW_high

    OW_WAIT .60

    ;pagesel read_OW
    ;call    read_OW

    ;banksel ow_rxbyte
    ;movwf   ow_rxbyte

    OW_WAIT    .450

    ;banksel ow_rxbyte
    ;movf    ow_rxbyte, w

    return
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
;OW_write_bit
;    banksel ow_tmp
;    movwf   ow_tmp
;    btfss   ow_tmp, 0
;    goto    _ow_zero_
;    pagesel drive_OW_low
;    call    drive_OW_low
;    OW_WAIT 15
;    pagesel drive_OW_high
;    call    drive_OW_high
;    OW_WAIT 50
;    goto    _ow_done_
;
;_ow_zero_
;    pagesel drive_OW_low
;    call    drive_OW_low
;    OW_WAIT 65
;    pagesel drive_OW_high
;    call    drive_OW_high
;
;_ow_done_
;    return
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
;OW_read_bit
;    pagesel drive_OW_low
;    call    drive_OW_low
;
;    goto $+1
;    goto $+1
;    goto $+1
;    goto $+1
;
;    pagesel drive_OW_high
;    call    drive_OW_high
;
;    OW_WAIT 25
;
;    pagesel read_OW
;    call    read_OW
;
;    banksel ow_tmp2
;    movwf   ow_tmp2
;
;    OW_WAIT 30
;
;    banksel ow_tmp2
;    movf    ow_tmp2, w
;
;    return
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
;OW_write_one
;    pagesel drive_OW_low
;    call    drive_OW_low
;    OW_WAIT 15
;    pagesel drive_OW_high
;    call    drive_OW_high
;    OW_WAIT 50
;    return
;
;OW_write_zero
;    pagesel drive_OW_low
;    call    drive_OW_low
;    OW_WAIT 65
;    pagesel drive_OW_high
;    call    drive_OW_high
;    return


END





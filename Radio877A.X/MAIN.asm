list p=16f877a
#include <p16f877a.inc>

errorlevel -302

__CONFIG   _CP_OFF & _DEBUG_OFF & _WRT_OFF & _CPD_OFF & _LVP_OFF & _BODEN_OFF & _PWRTE_ON & _WDT_OFF & _HS_OSC

#define     FOSC    D'20000'    ; Speed in KHz
#define     BAUD    D'100'      ; Speed in kbps

#define     DEVICE_ADDR H'60'

UDATA
i2c_temp1   RES 1
i2c_temp2   RES 1

byte1       RES 1
byte2       RES 1
byte3       RES 1
byte4       RES 1
byte5       RES 1


org 0x00
goto main

main

    pagesel mc_init
    call    mc_init

    banksel byte1
    clrf    byte1

    banksel byte2
    clrf    byte2

    banksel byte3
    clrf    byte3

    banksel byte4
    clrf    byte4

    banksel byte5
    clrf    byte5

    movlw   0xff
    ;banksel PORTB
    ;movwf   PORTB

    pagesel i2c_init
    call    i2c_init

    ; Setting search mode on
    movlw   b'01000000'
    banksel byte1
    movwf   byte1

    movlw   b'10100000'
    banksel byte3
    movwf   byte3

    pagesel i2c_write
    call    i2c_write

    movlw   0xff
    banksel PORTB
    movwf   PORTB

    goto loop
goto $

;---------------------------------------------------------------------------
loop

goto loop
;---------------------------------------------------------------------------

mc_init
    ;Switching to bank 1
    bsf     STATUS, RP0
    bcf     STATUS, RP1

    movlw   0x00
    movwf   TRISB

    ;Switching to bank 0
    bcf     STATUS, RP0

    movlw   0x00
    movwf   PORTB

    ;Turning off AD converter
    bcf     ADCON0, ADON


return

i2c_init
    ; RC3 and RC4 as inputs
    movlw   b'00011000'
    banksel TRISC
    movwf   TRISC

    ; Configuring MSSP module for master mode
    movlw   b'00101000'
    banksel SSPCON
    movwf   SSPCON

    ; Configuring input levels and slew rate as i2c standard levels
    movlw   b'10000000'
    banksel SSPSTAT
    movwf   SSPSTAT

    ; Configure baud rate
    movlw   (FOSC / (4 * BAUD)) - 1
    banksel SSPADD
    movwf   SSPADD

return

i2c_write

    ; Initiate start condition
    banksel SSPCON2
    bsf     SSPCON2, SEN

    pagesel i2c_wait
    call    i2c_wait

    ; Send address byte and wait
    movlw   DEVICE_ADDR
    banksel i2c_temp1
    movwf   i2c_temp1

    bcf     STATUS, C
    rlf     i2c_temp1, w
    call    i2c_send_byte

    banksel SSPCON2
    btfsc   SSPCON2, ACKSTAT
    goto    i2c_fail

    ; Sending byte1
    banksel byte1
    movf    byte1, w
    pagesel i2c_send_byte
    call    i2c_send_byte

    ; Sending byte2
    banksel byte2
    movf    byte2, w
    pagesel i2c_send_byte
    call    i2c_send_byte

    ; Sending byte3
    banksel byte3
    movf    byte3, w
    pagesel i2c_send_byte
    call    i2c_send_byte

    ; Sending byte4
    banksel byte4
    movf    byte4, w
    pagesel i2c_send_byte
    call    i2c_send_byte

    ; Sending byte5
    banksel byte5
    movf    byte5, w
    pagesel i2c_send_byte
    call    i2c_send_byte

    ; Sending stop condition
    banksel SSPCON2
    bsf     SSPCON2, PEN
    pagesel i2c_wait
    call    i2c_wait

return

i2c_read

return

i2c_send_byte
    banksel SSPBUF
    movwf   SSPBUF
retlw 0

i2c_wait
    banksel PIR1
    btfss   PIR1, SSPIF
    goto    $-1
    bcf     PIR1, SSPIF
retlw 0

i2c_fail

    goto $

end
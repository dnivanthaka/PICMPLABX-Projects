#include    <p16f877a.inc>  ; processor specific variable definitions

#define DEVICE_ADDRESS 0x0A     ; Real Address is 0x5 = 0xA/2

global i2c_slave_init
global i2c_handler
global ssp_buffer

UDATA
ssp_buffer  RES 8                   ; Buffer for transactions
buffer_idx  RES 1
temp        RES 1


CODE

i2c_slave_init
     ;Switching to Bank0
    bcf     STATUS, RP0
    bcf     STATUS, RP1

    ;clrf    PORTC
    bcf     PORTC, RC3
    bcf     PORTC, RC4

    ;movlw   0x00
    ;movwf   ADCON0

    ;movlw   0x00
    ;movwf   PORTB

    ;Switching to Bank 1
    bsf     STATUS, RP0

    ;movlw   0x06
    ;movwf   ADCON1

    ;Setting TRISC
    bsf   TRISC, RC3
    bsf   TRISC, RC4

    bsf   SSPSTAT, SMP
    bcf   SSPSTAT, CKE

    movlw   DEVICE_ADDRESS
    movwf   SSPADD

    clrf    SSPCON2

    bsf     PIE1, SSPIE         ; Enabling SSP interrupts
    bsf     INTCON, PEIE        ; Enabling peripheral interrupts
    bsf     INTCON, GIE         ; Enabling global interrupts

    ;Switching to Bank 0
    bcf STATUS, RP0

    clrf    SSPCON

    movlw   0x06
    movwf   SSPCON

    bsf     SSPCON, SSPEN
    bsf     SSPCON, CKP

    banksel PIE1
    bsf     PIE1, SSPIE
    bsf     INTCON, PEIE
    ;bsf     INTCON, GIE

    banksel ssp_buffer
    clrf    ssp_buffer

    movlw   ssp_buffer
    banksel buffer_idx
    movwf   buffer_idx

    return

;---------------------------------------------------------------------
; The I2C code below checks for 5 states:
;---------------------------------------------------------------------
; State 1: I2C write operation, last byte was an address byte.
; SSPSTAT bits: S = 1, D_A = 0, R_W = 0, BF = 1
;
; State 2: I2C write operation, last byte was a data byte.
; SSPSTAT bits: S = 1, D_A = 1, R_W = 0, BF = 1
;
; State 3: I2C read operation, last byte was an address byte.
; SSPSTAT bits:
; S = 1, D_A = 0, R_W = 1 (see Appendix C for more information)
;
; State 4: I2C read operation, last byte was a data byte.
; SSPSTAT bits: S = 1, D_A = 1, R_W = 1, BF = 0
;
; State 5: Slave I2C logic reset by NACK from master.
; SSPSTAT bits:
; S = 1, D_A = 1, BF = 0, CKP = 1 (see Appendix C for more information)
;
; For convenience, WriteI2C and ReadI2C functions have been used.
;----------------------------------------------------------------------


i2c_handler
    banksel SSPSTAT
    movf    SSPSTAT, w
    andlw   b'00101101'
    banksel temp
    movwf   temp

state1:
    movlw   b'00001001'
    xorwf   temp, w
    btfss   STATUS, Z
    goto    state2
    banksel SSPBUF
    movf    SSPBUF, w               ; Do a dummy reading of the SSPBUF
    ;banksel ssp_buffer
    ;clrf   ssp_buffer
    ;banksel buffer_idx
    ;clrf    buffer_idx
    banksel ssp_buffer
    movlw   ssp_buffer
    banksel buffer_idx
    movwf   buffer_idx

    banksel ssp_buffer
    movlw   ssp_buffer
    movwf   FSR
l_clr
    clrf    INDF
    incf    FSR, f
    btfsc   FSR, 3
    goto    l_clr

    return

state2:
    movlw   b'00101001'
    xorwf   temp, w
    btfss   STATUS, Z
    goto    state3
    ;banksel SSPBUF
    ;movf    SSPBUF, w
    ;banksel ssp_buffer
    ;movwf   ssp_buffer
    banksel buffer_idx
    movf    buffer_idx, w
    movwf   FSR
    banksel SSPBUF
    movf    SSPBUF, w
    movwf   INDF
    banksel buffer_idx
    incf    buffer_idx, f
    return

state3:
    ;movf    temp, w
    ;banksel SSPBUF
    ;movf    SSPBUF, w
    return

END

update_servos
    banksel free_counter
    incf    free_counter, f
    movf    free_counter, w

    banksel  servo1_val
    xorwf    servo1_val, w
    btfss    STATUS, Z
    ;call     servo_lo
    goto     _servo1_period_done_
    ;movlw    0x00
    banksel  PORTB
    ;movwf    PORTB
    bcf       PORTB, RC1

_servo1_period_done_:
    banksel free_counter
    movf    free_counter, w
    banksel  servo2_val
    xorwf    servo2_val, w
    btfss    STATUS, Z
    ;call     servo_lo
    goto     _servo2_period_done_
    ;movlw    0x00
    banksel  PORTB
    ;movwf    PORTB
    bcf      PORTB, RC2

_servo2_period_done_:
;Duty cycle checking
    banksel free_counter
    movf    free_counter, w
    xorlw   .255             ; 100us * 255 = 25.5ms
    btfss   STATUS, Z
    goto    _duty_done_
    ;call    servo_hi
    movlw   0x06
    banksel PORTB
    movwf   PORTB

_duty_done_:
    ;banksel free_counter
    ;incf    free_counter, f

    ;movlw   0x20
    ;movwf   FSR
;next:
    ;clrf    INDF
    ;incf    FSR, f
    ;btfss   FSR, 4
    ;goto    next


    return



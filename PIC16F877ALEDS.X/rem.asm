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



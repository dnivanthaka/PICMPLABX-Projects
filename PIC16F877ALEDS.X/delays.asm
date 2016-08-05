global delay500us
global delay250ms
global delayms
;global ds18b20_start



UDATA
delay_temp    RES 1
delay_temp2   RES 1


CODE
;====================================================
delay500us
movlw   .250              ;200ns
banksel delay_temp        ;200ns
movwf   delay_temp        ;200ns

delay_loop1
    nop                   ;200ns
    nop                   ;200ns
    nop                   ;200ns
    nop                   ;200ns
    nop                   ;200ns
    nop                   ;200ns
    banksel delay_temp    ;200ns
    decfsz  delay_temp, f ;200ns/400ns
    goto    delay_loop1   ;400ns

    return                ;400ns
;====================================================
;====================================================
delay250ms
movlw   .250              ;200ns
banksel delay_temp2      ;200ns
movwf   delay_temp2      ;200ns

delay_loop12:
movlw   .255              ;200ns
banksel delay_temp        ;200ns
movwf   delay_temp        ;200ns
delay_loop11:
    goto $+1              ;400ns
    goto $+1              ;400ns
    goto $+1              ;400ns
    goto $+1              ;400ns
    goto $+1              ;400ns
    goto $+1              ;400ns
    goto $+1              ;400ns
    goto $+1              ;400ns
    banksel delay_temp    ;200ns
    decfsz  delay_temp, f ;200ns/400ns
    goto    delay_loop11  ;400ns
banksel delay_temp2    ;200ns
decfsz  delay_temp2, f ;200ns/400ns
goto    delay_loop12  ;400ns

    return                ;400ns
;====================================================
;====================================================
delayms
;movlw   .250              ;200ns
banksel delay_temp2      ;200ns
movwf   delay_temp2      ;200ns

delay_loop13:
movlw   .255              ;200ns
banksel delay_temp        ;200ns
movwf   delay_temp        ;200ns
delay_loop14:
    goto $+1              ;400ns
    goto $+1              ;400ns
    goto $+1              ;400ns
    goto $+1              ;400ns
    goto $+1              ;400ns
    goto $+1              ;400ns
    goto $+1              ;400ns
    goto $+1              ;400ns
    banksel delay_temp    ;200ns
    decfsz  delay_temp, f ;200ns/400ns
    goto    delay_loop14  ;400ns
banksel delay_temp2    ;200ns
decfsz  delay_temp2, f ;200ns/400ns
goto    delay_loop13  ;400ns

    return                ;400ns
;====================================================

END






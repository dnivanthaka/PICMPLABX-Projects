global      delay10us
global      delay20us
global      delay40us
global      delay500us
;global      delay500us2


UDATA
delay1      RES     1
delay2      RES     1
delaytemp   RES     1

CODE

;delay500us

;movlw   .10
;banksel delay1
;movwf   delay1

;movlw   .250                                ; 200ns * 250 = 50us
;banksel delay2
;movwf   delay2

;__d1_500__
    ;banksel delay1
    ;decfsz  delay1, f
    ;goto    __d2_500__
    ;goto    __d500end__
;__d2_500__
   ; banksel delay2
    ;decfsz  delay2, f
    ;goto    __d2_500__
;goto    __d1_500__
;__d500end__
;return

;---------------------------------------------------------------
delay10us
nop
nop
nop
nop
nop
nop

return
;---------------------------------------------------------------

delay20us
movlw   .4                                 ; 4800 * 4 = 19200ns
banksel delay1
movwf   delay1

movlw   .6                                 ; 800 * 6 = 4800ns
banksel delay2
movwf   delay2
banksel delaytemp
movwf   delaytemp

pagesel delaycycles
call    delaycycles

return

;---------------------------------------------------------------

delay40us
movlw   .4                                 ; 4800 * 8 = 38400ns
banksel delay1
movwf   delay1

movlw   .6                                 ; 800 * 6 = 4800ns
banksel delay2
movwf   delay2
banksel delaytemp
movwf   delaytemp

pagesel delaycycles
call    delaycycles

return

;---------------------------------------------------------------

delay500us
movlw   .10                                 ; 48000 * 10 = 480000ns
banksel delay1
movwf   delay1

movlw   .10                                 ; 800 * 60 = 48000ns
banksel delay2
movwf   delay2
banksel delaytemp
movwf   delaytemp

pagesel delaycycles
call    delaycycles

return

;---------------------------------------------------------------

;delaycycles

;movlw   .10                                 ; 48000 * 10 = 480000ns
;banksel delay1
;movwf   delay1

;movlw   .60                                 ; 800 * 60 = 48000ns
;banksel delay2
;movwf   delay2

;__d1__
    ;banksel delay1                          ;1-2
    ;decfsz  delay1, f                       ;1-2
    ;goto    __d2__                      ;2
    ;goto    __dend__                     ;2

;__d2__
    ;banksel delay2                          ;1-2
    ;decfsz  delay2, f                       ;1-2
    ;goto    __d2__                      ;2

;goto    __d1__                          ;2

;__dend__

;return                                      ;1?

;============================================================

delaycycles

;movlw   .1                      ;1
banksel delaytemp
movf    delaytemp, w
banksel delay2                  ;2
movwf   delay2                  ;1

banksel delay1                  ;2
decfsz delay1, f                ;1-2
goto    $+2                    ;2
goto    _wend_                     ;2


_w1_
banksel delay2                  ;2
decfsz  delay2, f               ;1-2
goto    $-2                    ;2
goto    delaycycles              ;2

_wend_

return

;============================================================

END



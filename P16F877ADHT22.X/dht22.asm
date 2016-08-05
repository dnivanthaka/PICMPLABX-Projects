#include    <p16f877a.inc>  ; processor specific variable definitions
#include    "macros.inc"


global dht22_init
global dht22_start
global dht22_rbyte
;extern BANK0
;extern BANK1
;extern BANK2
;extern BANK3

DHT22Hi MACRO
    BANK0
    bcf PORTB, RB4
    BANK1
    bsf TRISB, RB4
    BANK0
    ENDM

DHT22Lo MACRO
    BANK0
    bcf PORTB, RB4
    BANK1
    bcf TRISB, RB4
    BANK0
    ENDM


UDATA
dht22_buffer  RES 8                   ; Buffer for transactions
dht22_temp    RES 2
dht22_count   RES 1


CODE

dht22_delay10us
movlw   .8                ;200ns
banksel dht22_temp        ;200ns
movwf   dht22_temp        ;200ns

dht22_d_loop2
    nop                   ;200ns
    banksel dht22_temp    ;200ns
    decfsz  dht22_temp, f ;200ns/400ns
    goto    dht22_d_loop2 ;400ns

    return                ;400ns

dht22_delay20us
movlw   .20               ;200ns
banksel dht22_temp        ;200ns
movwf   dht22_temp        ;200ns

dht22_d_loop
    nop                   ;200ns
    banksel dht22_temp    ;200ns
    decfsz  dht22_temp, f ;200ns/400ns
    goto    dht22_d_loop  ;400ns

    return                ;400ns

dht22_delay512us
movlw   .255              ;200ns
banksel dht22_temp        ;200ns
movwf   dht22_temp        ;200ns

dht22_d_loop3
    nop                   ;200ns
    nop                   ;200ns
    nop                   ;200ns
    nop                   ;200ns
    nop                   ;200ns
    nop                   ;200ns
    banksel dht22_temp    ;200ns
    decfsz  dht22_temp, f ;200ns/400ns
    goto    dht22_d_loop3 ;400ns

    return                ;400ns


dht22_delay1ms
    pagesel dht22_delay512us
    call    dht22_delay512us
    pagesel dht22_delay512us
    call    dht22_delay512us
    return


dht22_delay1s
movlw   .255              ;200ns
banksel dht22_temp        ;200ns
movwf   dht22_temp+1      ;200ns

dht22_d_loop4
    pagesel dht22_delay1ms
    call    dht22_delay1ms
    pagesel dht22_delay1ms
    call    dht22_delay1ms
    pagesel dht22_delay1ms
    call    dht22_delay1ms
    pagesel dht22_delay1ms
    call    dht22_delay1ms
    banksel dht22_temp    ;200ns
    decfsz  dht22_temp+1, f ;200ns/400ns
    goto    dht22_d_loop4  ;400ns

    return                ;400ns

;====================================================
dht22_init
    ; Pulling up
    BANK0
    bcf PORTB, RB4
    BANK1
    bsf TRISB, RB4
    BANK0
    
    pagesel dht22_delay1s
    call    dht22_delay1s
    return
;===================================================
dht22_start
    ; Pulling down
    DHT22Lo

    pagesel dht22_delay512us
    call    dht22_delay512us
    ;pagesel dht22_delay1ms
    ;call    dht22_delay1ms
    ;pagesel dht22_delay1ms
    ;call    dht22_delay1ms
    ;pagesel dht22_delay1ms
    ;call    dht22_delay1ms


    ; Pulling up
    DHT22Hi

    pagesel dht22_delay20us
    call    dht22_delay20us

    ; Wait till the sensor pulls down
    banksel PORTB
    btfsc   PORTB, RB4
    goto    $-1

    ; Wait till the sensor pulls up
    banksel PORTB
    btfss   PORTB, RB4
    goto    $-1

    return
;===================================================
dht22_rbyte
    banksel dht22_buffer
    clrf    dht22_buffer

    movlw   .8
    banksel dht22_count
    movwf   dht22_count

rx_loop:
    bcf     STATUS, C
    ; Wait till the sensor pulls down
    banksel PORTB
    btfsc   PORTB, RB4
    goto    $-1

    ; Wait till the sensor up
    banksel PORTB
    btfss   PORTB, RB4
    goto    $-1

    pagesel dht22_delay20us
    call    dht22_delay20us
    pagesel dht22_delay20us
    call    dht22_delay20us
    pagesel dht22_delay10us
    call    dht22_delay10us

    banksel PORTB
    btfss   PORTB, RB4
    bsf     STATUS, C

    banksel dht22_buffer
    rlf     dht22_buffer, f

    banksel dht22_count
    decfsz  dht22_count, f
    goto    rx_loop

    banksel dht22_buffer
    movf    dht22_buffer, w

    return
END
#include    <p16f877a.inc>  ; processor specific variable definitions
#include    "macros.inc"

DS18Hi MACRO
    BANK0
    bcf PORTB, RB5
    BANK1
    bsf TRISB, RB5
    BANK0
    ENDM

DS18Lo MACRO
    BANK0
    bcf PORTB, RB5
    BANK1
    bcf TRISB, RB5
    BANK0
    ENDM

global ds18b20_init
global ds18b20_wbyte
global ds18b20_rbyte
;global ds18b20_start



UDATA
ds18b20_buffer  RES 8                   ; Buffer for transactions
ds18b20_temp    RES 2
ds18b20_count   RES 1



CODE
;====================================================
ds18b20_delay500us
movlw   .250              ;200ns
banksel ds18b20_temp      ;200ns
movwf   ds18b20_temp      ;200ns

ds18b20_d_loop1
    nop                   ;200ns
    nop                   ;200ns
    nop                   ;200ns
    nop                   ;200ns
    nop                   ;200ns
    nop                   ;200ns
    banksel ds18b20_temp    ;200ns
    decfsz  ds18b20_temp, f ;200ns/400ns
    goto    ds18b20_d_loop1 ;400ns

    return                ;400ns
;====================================================
;====================================================
ds18b20_delay10us
movlw   .5              ;200ns
banksel ds18b20_temp      ;200ns
movwf   ds18b20_temp      ;200ns

ds18b20_d_loop2
    nop                   ;200ns
    nop                   ;200ns
    nop                   ;200ns
    nop                   ;200ns
    nop                   ;200ns
    nop                   ;200ns
    banksel ds18b20_temp    ;200ns
    decfsz  ds18b20_temp, f ;200ns/400ns
    goto    ds18b20_d_loop2 ;400ns

    return                ;400ns
;====================================================
;====================================================
ds18b20_delay50us
movlw   .25              ;200ns
banksel ds18b20_temp      ;200ns
movwf   ds18b20_temp      ;200ns

ds18b20_d_loop3
    nop                   ;200ns
    nop                   ;200ns
    nop                   ;200ns
    nop                   ;200ns
    nop                   ;200ns
    nop                   ;200ns
    banksel ds18b20_temp    ;200ns
    decfsz  ds18b20_temp, f ;200ns/400ns
    goto    ds18b20_d_loop3 ;400ns

    return                ;400ns
;====================================================
ds18b20_init
    ; Pulling up
    DS18Hi

    pagesel ds18b20_delay500us
    call    ds18b20_delay500us

    ;Pulling down
    DS18Lo

    pagesel ds18b20_delay500us
    call    ds18b20_delay500us

    ; Pulling up
    DS18Hi

    ; Wait till the sensor pulls down
    banksel PORTB
    btfsc   PORTB, RB5
    goto    $-1

    return
;===================================================
ds18b20_cmd
    ; Pulling up
    DS18Hi

    pagesel ds18b20_delay500us
    call    ds18b20_delay500us

    ;Pulling down
    DS18Lo

    pagesel ds18b20_delay500us
    call    ds18b20_delay500us

    ; Pulling up
    DS18Hi

    ; Wait till the sensor pulls down
    banksel PORTB
    btfsc   PORTB, RB5
    goto    $-1

    return
;===================================================
;===================================================
ds18b20_wbyte
    banksel ds18b20_buffer
    movwf   ds18b20_buffer

    movlw   .8
    banksel ds18b20_count
    movwf   ds18b20_count

tx_loop:
    ;Pulling down
    DS18Lo

    pagesel ds18b20_delay10us
    call    ds18b20_delay10us

    banksel ds18b20_buffer
    rrf     ds18b20_buffer, f
    pagesel ds18b20_bwone
    btfsc   STATUS, C
    call    ds18b20_bwone

    pagesel ds18b20_delay50us
    call    ds18b20_delay50us

    ; Pulling up
    DS18Hi

    nop
    nop
    nop
    nop
    nop

    banksel ds18b20_count
    decfsz  ds18b20_count, f
    goto    tx_loop
    
    
    return
;===================================================
;===================================================
ds18b20_rbyte
    banksel ds18b20_buffer
    clrf   ds18b20_buffer

    movlw   .8
    banksel ds18b20_count
    movwf   ds18b20_count

rx_loop:
    ;Pulling down
    DS18Lo

    pagesel ds18b20_delay10us
    call    ds18b20_delay10us

    ; Pulling up
    DS18Hi

    nop
    nop
    nop
    nop
    nop

    bcf     STATUS, C
    banksel PORTB
    btfsc   PORTB, RB5
    bsf     STATUS, C
    banksel ds18b20_buffer
    rrf     ds18b20_buffer, f
    
    pagesel ds18b20_delay50us
    call    ds18b20_delay50us

    banksel ds18b20_count
    decfsz  ds18b20_count, f
    goto    rx_loop

    banksel ds18b20_buffer
    swapf   ds18b20_buffer, f
    movlw   0x0F
    andwf   ds18b20_buffer, f
    movf    ds18b20_buffer, w

    ;movlw   .65
    ;movlw   .15
    addlw   0x30

    return
;===================================================
ds18b20_bwone
    ;Pulling down
    ;DS18Lo

    ;pagesel ds18b20_delay10us
    ;call    ds18b20_delay10us

    ; Pulling up
    DS18Hi

    ;pagesel ds18b20_delay50us
    ;call    ds18b20_delay50us

    return
;===================================================
;===================================================
ds18b20_bwzero
    ;Pulling down
    DS18Lo

    pagesel ds18b20_delay10us
    call    ds18b20_delay10us

    pagesel ds18b20_delay50us
    call    ds18b20_delay50us

    ; Pulling up
    DS18Hi

    return
;===================================================
;===================================================
ds18b20_bread
    ;Pulling down
    DS18Lo
    
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

    ; Pulling up
    DS18Hi

    pagesel ds18b20_delay10us
    call    ds18b20_delay10us

    nop
    nop

    ;Sampling
    banksel PORTB
    btfsc   PORTB, RB5
    retlw   .1
    retlw   .0

    return
;===================================================
END



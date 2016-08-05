#include <xc.h>
#include <stdio.h>

#include "dwire.h"
/*
Start pulse

-\       /-------------------
  \-----/
  |20us |
|<-----------120us---------->|

Send One
--|            |-------------
  |------------|
  |<---40us--->|
|<----------100us---------->|

Send zero
 |
 |---------------------------
|<----------100us---------->|
*/

void dw_init()
{
    PORTCbits.RC0    = 0;
    TRISCbits.TRISC0 = 1;
}

int dw_start(uint8_t pin)
{
    //DW_LOW(pin);
    PORTCbits.RC0    = 0;
    TRISCbits.TRISC0 = 0;
    __delay_us(20);
    //DW_HIGH(pin);
    TRISCbits.TRISC0 = 1;
    __delay_us(100);

    return 0;
}

int dw_send_byte(uint8_t pin, uint8_t data)
{
    int i;
    for(i=0;i<8;i++){
        data = data >> 1;
        //OW_LOW(pin);
        PORTCbits.RC0 = 0;
        TRISCbits.TRISC0 = 0;
        __delay_us(60);
        if( data & 0x1 ){
                //OW_HIGH(pin);
                TRISCbits.TRISC0 = 1;
        }
        __delay_us(40);
    }

        return 0;
}

uint8_t dw_recieve_byte(uint8_t pin)
{
    int i;
    uint8_t data = 0;

    for(i=0;i<8;i++){
        data = data >> 1;
        __delay_us(60);
        if(pin == 1)
            data |= 1 << (7 - i);
        __delay_us(40);
    }

    return data;
}
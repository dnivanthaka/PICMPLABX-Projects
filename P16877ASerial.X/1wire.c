#include <xc.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include "1wire.h"

void ow_init()
{
    // Pulling pin high
    PORTBbits.RB5 = 0;
    TRISBbits.TRISB5 = 1;
}

int ow_reset()
{
    // Pulling pin low
    PORTBbits.RB5 = 0;
    TRISBbits.TRISB5 = 0;

    __delay_us(500);
    // Pulling up
    TRISBbits.TRISB5 = 1;
    // Checking for response
    __delay_us(100);
    if( PORTBbits.RB5 == 0 ){
        //printf("DS18b20 responded\r\n");
        __delay_us(150);
        return 0;
    }else{
        printf("1WIRE ERROR: Device didnt respond\r\n");
        return 1;
    }
}

int ow_write_byte(unsigned char data)
{
    int i;
    for(i=0;i<8;i++){
        TRISBbits.TRISB5 = 0;
        __delay_us(15);
        if( data & 1 ){
            TRISBbits.TRISB5 = 1;
        }
        __delay_us(45);
        TRISBbits.TRISB5 = 1;
        // Recovery time
        __delay_us(1);
        data = data >> 1;
    }
}

unsigned char ow_read_byte()
{
    int i;
    unsigned char data = 0;
    for(i=0;i<8;i++){
        data >>= 1;
        TRISBbits.TRISB5 = 0;
        __delay_us(1);
        TRISBbits.TRISB5 = 1;
        __delay_us(5);

       if(PORTBbits.RB5 == 1)
        data = data | 0x80;

        __delay_us(55);
       }

     return data;
}


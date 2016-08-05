#include <xc.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include "dht22.h"


void dht22_init()
{
    // Making sensor pin as input
    TRISBbits.TRISB4 = 1;
    PORTBbits.RB4    = 0;

    OPTION_REGbits.T0CS = 0;
    OPTION_REGbits.T0SE = 0;
    OPTION_REGbits.PSA  = 0;
    OPTION_REGbits.PS0  = 0;
    OPTION_REGbits.PS1  = 0;
    OPTION_REGbits.PS2  = 0;

    // 1s delay as per datasheet
    __delay_ms(1000);
}

unsigned char dht22_read(struct dht22 *s)
{
    unsigned char i, p;
    unsigned char *ptr = &(s->rhi);
    di();
    // Sending start condition
    PORTBbits.RB4    = 0;
    TRISBbits.TRISB4 = 0;

    __delay_ms(2);

    PORTBbits.RB4    = 1;
    TRISBbits.TRISB4 = 0;

    PORTBbits.RB4    = 0;
    TRISBbits.TRISB4 = 1;
    __delay_us(40);

    // Wait for sensor response
    while(PORTBbits.RB4);
    // Discard 1st bit
    while(! PORTBbits.RB4);
    while(PORTBbits.RB4);

    //__delay_us(75);
    // Reading data
    for(i=0;i<5;i++){
        for(p=0;p<8;p++){
        //p = i / 8;
            ptr[ i ] <<= 1;
            while(! PORTBbits.RB4);
            TMR0 = 0;
            while(PORTBbits.RB4);
            if(TMR0 > 100){
                ptr[ i ] |= 1;
            }
        }
    }

    ei();

    // Verify data
    if( (s->rhd + s->rhi + s->td + s->ti) != s->csum ){
        printf("Invalid data\r\n");
    }

    int temp     = (s->ti << 8) + s->td;
    int humidity = (s->rhi << 8) + s->rhd;

    printf("Temp. = %dC\r\n",  temp);
    printf("Humid = %d%%\r\n",  humidity);
    //printf("csum = %d\r\n",  s->csum);
    //printf("act = %d\r\n", (s->rhd + s->rhi + s->td + s->ti));
    //printf("val = %d\r\n", i / 8);
    return 0;
}

#include <xc.h>
#include <stdint.h>
#include <stdint.h>

#include "dht22.h"

void dht22_init(){
    //Setting line high
    PORTBbits.RB4    = 0;
    TRISBbits.TRISB4 = 1;

    OPTION_REGbits.T0CS = 0;
    OPTION_REGbits.T0SE = 0;
    OPTION_REGbits.PSA  = 0;
    OPTION_REGbits.PS0  = 0;
    OPTION_REGbits.PS1  = 0;
    OPTION_REGbits.PS2  = 0;
    
    _delay(5000000); //Clock cycles, 200ns * 5000000 = 1s

    
}

void dht22_start(){
    uint8_t sample_count;

    //Setting line high
    PORTBbits.RB4    = 0;
    TRISBbits.TRISB4 = 1;

    _delay(1250000);      //250ms delay

    //Setting line low
    PORTBbits.RB4    = 0;
    TRISBbits.TRISB4 = 0;

    _delay(100000);      //20ms delay

    //Setting line high
    PORTBbits.RB4    = 1;
    TRISBbits.TRISB4 = 0;

    _delay(200);      //40us delay

    //Setting as input
    PORTBbits.RB4    = 0;
    TRISBbits.TRISB4 = 1;

    //_delay(1750);      //35us delay
    //_delay(1750);      //35us delay

    while( PORTBbits.RB4 == 1 );
    while( PORTBbits.RB4 == 0 );
    //while( PORTBbits.RB4 == 1 );
    // Sample for 10us
    //sample_count = 0;
    //while( !PORTBbits.RB4 && sample_count++ < 5 ){
        //_delay(1000);      //2us delay
    //}

    //if( sample_count < 5 ){
        //while(1);
    //}

    //if( PORTBbits.RB4 != 0 ){
        //while(1);
    //}

    //_delay(4000);      //80us delay
    //_delay(4000);      //80us delay

    // Sample for 10us
    //sample_count = 0;
    //while( PORTBbits.RB4 && sample_count++ < 5 ){
        //_delay(1000);      //2us delay
    //}

    //if( sample_count < 5 ){
        //while(1);
    //}
    
    //if( PORTBbits.RB4 != 1 ){
        //while(1);
    //}

    //while( PORTBbits.RB4 == 1 );

    //_delay(4000); //80us delay
    //if(PORTBbits.RB4 == 0){
        //while(1);
    //}
    //_delay(2000); //80us delay
}

uint8_t dht22_read(){
    int i, j;
    uint8_t buffer[5] = {0};
    uint8_t val = 0;

    //while( PORTBbits.RB4 == 0 );
    
    while( PORTBbits.RB4 == 1 );
    
    for( j=4;j>=0;j-- ){
        for( i=7;i>=0;i-- ){
            //while( PORTBbits.RB4 == 1 );
            TMR0 = 0;
            while( PORTBbits.RB4 == 0 );
            while( PORTBbits.RB4 == 1 );

            //400ns * 100 = 40us
            if( TMR0 > 170 ){
                //buffer[j] &= 0 << i;
                buffer[j] |= 1 << i;
                //data &= 0 << i;
            }else{
                buffer[j] &= 0 << i;
                //buffer[j] |= 1 << i;
                //data |= 1 << i;
            }
            //buffer[j] = buffer[j] | 1;
            //buffer[j] = buffer[j] << 1;
            
            //_delay(1500); //40us delay

            //if(PORTBbits.RB4){
                //buffer[j] |= 1 << i;
                //data |= 1 << i;
            //}else{
                //buffer[j] &= 0 << i;
                //data &= 0 << i;
            //}

            //_delay(1000); //20us delay
            //while( PORTBbits.RB4 );

            //buffer = 1 << buffer;

            //while( PORTBbits.RB4 == 1 );
        }
    }
    //if(buffer > 1){
        //while(1);
    //}
    //PORTD = 30;
    //PORTD = ((buffer[2] << 8) | buffer[1]) / 10;
    PORTD = buffer[1];
    return buffer[3];
}






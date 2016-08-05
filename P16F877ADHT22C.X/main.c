#include <xc.h>
#include <stdio.h>
#include <stdlib.h>

#include "dht22.h"

/*
 *
 */

//#define _XTAL_FREQ      20000000 // 20MHz Clock
//#define BAUD            100   // In kbps
//#define FOSC_SPEED	20000// Oscillator clock in Khz

#pragma config BOREN = ON, CPD = OFF, FOSC = HS, WDTE = OFF, CP = OFF, LVP = OFF, PWRTE = ON

void init()
{
    //Disabling the A2D converter
    ADCON0bits.ADON = 0;

    PORTB = 0x00;
    TRISB = 0x00;

    PORTD = 0x00;
    TRISD = 0x00;
    //PORTD = 0xFF;
    //I2C SDA and SCL pins as inputs
    //TRISCbits.TRISC3 = 1;
    //TRISCbits.TRISC4 = 1;

    //Configuring MSSP module as master mode
    //SSPCON = 0b00101000;

    //Configuring i2c levels and slew rate as standard
    //SSPSTAT = 0b10000000;

    //Configuring the baud rate
    //SSPADD = (FOSC_SPEED / (4 * BAUD)) - 1;
    //__delay_mhs(10);

    dht22_init();

}

void blink(){
    PORTBbits.RB2 = 1;
    _delay(1000000);        //200ms
    PORTBbits.RB2 = 0;
    _delay(1000000);
}

int main(int argc, char** argv)
{
    uint8_t rh_hdata, rh_ldata, t_ldata, t_hdata, check;
    
    init();

    //dht22_start();
    //dht22_read();
    //dht22_read();

    //PORTBbits.RB2 = 1;
    //dht22_start();
    //dht22_read();
    while(1){
        dht22_start();
        dht22_read();
        //rh_ldata = dht22_read();
        //t_hdata  = dht22_read();
        //t_ldata  = dht22_read();
        //check  = dht22_read();

        //PORTD = t_hdata;


        //if((uint8_t)(rh_hdata + rh_ldata + t_hdata + t_ldata) != check){
            blink();
        //}
        _delay(1250000);      //250ms delay
        _delay(1250000);      //250ms delay
        _delay(1250000);      //250ms delay
        _delay(1250000);      //250ms delay
        _delay(1250000);      //250ms delay
        _delay(1250000);      //250ms delay
        _delay(1250000);      //250ms delay
        _delay(1250000);      //250ms delay
        _delay(1250000);      //250ms delay
        _delay(1250000);      //250ms delay
    }

    return (EXIT_SUCCESS);
}

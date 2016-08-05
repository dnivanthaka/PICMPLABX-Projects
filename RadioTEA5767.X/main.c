/* 
 * File:   main.c
 * Author: dinusha
 *
 * Created on October 23, 2014, 9:45 PM
 */

#include <xc.h>
#include <stdio.h>
#include <stdlib.h>

#include "I2C.h"
#include "TEA5767.h"

/*
 * 
 */

#define _XTAL_FREQ      20000000 // 20MHz Clock
//#define BAUD            100   // In kbps
//#define FOSC_SPEED	20000// Oscillator clock in Khz

#pragma config BOREN = ON, CPD = OFF, FOSC = HS, WDTE = OFF, CP = OFF, LVP = OFF, PWRTE = ON

void init()
{
    //Disabling the A2D converter
    ADCON0bits.ADON = 0;

    PORTC = 0x00;
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
    i2c_init();
    tea5767_init();
}

int main(int argc, char** argv)
{
    init();

    //tea5767_search();
    //tea5767_search();
    //tea5767_search();

    while(1);

    return (EXIT_SUCCESS);
}


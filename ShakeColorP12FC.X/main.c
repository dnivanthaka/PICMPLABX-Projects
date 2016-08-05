/*
 * File:   main.c
 * Author: dinusha
 *
 * Created on November 14, 2015, 9:17 AM
 */


#include <xc.h>

#pragma config BOREN = ON, CPD = OFF, FOSC = INTRCIO, WDTE = OFF, CP = OFF,  PWRTE = ON

#define _XTAL_FREQ      4000000 // 4MHz Clock

void pic_init();
void start_timer();
void stop_timer();

unsigned char counter = 0, pin = 0, value = 0;

void pic_init()
{
    //Disabling the A2D converter
    ADCON0bits.ADON = 0;
    CMCON = 0x07;
    ANSEL = 0;
    
    OPTION_REGbits.T0CS = 0;
    OPTION_REGbits.T0SE = 0;
    OPTION_REGbits.PSA  = 0;
    OPTION_REGbits.PS0  = 1;                // 800ns
    OPTION_REGbits.PS1  = 0;
    OPTION_REGbits.PS2  = 0;
    
    TMR1H = 0xF0;
    TMR1L = 0;
    
    TRISIObits.TRISIO4 = 0;
    TRISIObits.TRISIO5 = 0;
    
    TRISIObits.TRISIO2 = 1;
    GPIObits.GP4 = 0;
    GPIObits.GP5 = 0;
    
    // Setting up interrupt on change setting

    IOCBbits.IOC2   = 1;
    INTCONbits.GPIE = 1;
    INTCONbits.GIE  = 1;
    
    //GPIObits.GP4 = 1;
    
    pin = 0x10;
}

void interrupt isr()
{
    if(INTCONbits.GPIF){
        __delay_us(2);
        //GPIObits.GP4 = 1;
        
        if(value != GPIObits.GP2){
            value = GPIObits.GP2;
            //GPIObits.GP4 = 1;
            if(counter == 0){
                //GPIObits.GP4 = 1;
                start_timer();
            }

            counter++;

            if(counter == 7){
                //pin = ~pin;
                //GPIObits.GP4 = pin;
                
                //if(pin){
                    GPIO = pin;
                //}
                    pin++;
                    pin = pin % 0x30;
                
                counter = 0;
                stop_timer();
            }
        }
        
        INTCONbits.GPIF = 0;
    }else if(PIR1bits.TMR1IF){
        stop_timer();
        
        //GPIObits.GP4 = 0;
        
        counter = 0;
    }
}

void start_timer()
{
    PIE1bits.TMR1IE  = 1;
    INTCONbits.PEIE  = 1;
    T1CONbits.TMR1ON = 1;
}

void stop_timer()
{
    PIE1bits.TMR1IE  = 0;
    INTCONbits.PEIE  = 0;
    T1CONbits.TMR1ON = 0;
    PIR1bits.TMR1IF  = 0;
    
    TMR1H = 0xF0;
    TMR1L = 0;
}

void main(void) {
    pic_init();
    
    while(1){
        if(pin == 0x00){
            asm("sleep");
        }
    }
    
    return;
}

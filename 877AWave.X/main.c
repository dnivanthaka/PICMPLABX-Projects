#include <xc.h>
#include <stdio.h>
#include <stdlib.h>

#define _XTAL_FREQ      20000000 // 20MHz Clock


#pragma config BOREN = ON, CPD = OFF, FOSC = HS, WDTE = OFF, CP = OFF, LVP = OFF, PWRTE = ON

void init()
{
    //Disabling the A2D converter
    ADCON0bits.ADON = 0;
    
    TRISCbits.TRISC0 = 0;
    PORTCbits.RC0    = 0;
}

void init_pwm()
{
    PR2 = 0x80;
    CCPR1L = 0X0F;
    CCP1CONbits.CCP1X = 1;
    CCP1CONbits.CCP1Y = 1;

    TRISCbits.TRISC2  = 0;
    T2CONbits.T2CKPS0 = 1;
    T2CONbits.T2CKPS1 = 1;

    T2CONbits.TOUTPS0 = 1;
    T2CONbits.TOUTPS1 = 1;
    T2CONbits.TOUTPS2 = 1;
    T2CONbits.TOUTPS3 = 1;


    T2CONbits.TMR2ON  = 1;
    
    CCP1CONbits.CCP1M0 = 0;
    CCP1CONbits.CCP1M1 = 0;
    CCP1CONbits.CCP1M2 = 1;
    CCP1CONbits.CCP1M3 = 1;
    
}

void delay_ms(unsigned int cycles)
{
    unsigned int i;

    for(i=0;i<cycles;i++){
        __delay_ms(1);
    }
}

int main(int argc, char *argv[])
{
    init();
    init_pwm();

    while(1){
        PORTCbits.RC0 = 1;
        delay_ms(20);
        PORTCbits.RC0 = 0;
        delay_ms(20);
    }

    return 0;
}
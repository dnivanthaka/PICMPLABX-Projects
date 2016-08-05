#include <xc.h>
#include <stdio.h>
#include <stdint.h>
//#include <stdlib.h>


#include "uart.h"


#define _XTAL_FREQ      8000000 // 8MHz Clock

//http://picguides.com/beginner/config.php
#pragma config BOREN = OFF, MCLRE = ON, CPD = OFF, FOSC = INTRCIO, WDTE = OFF, CP = OFF, PWRTE = ON, IESO=OFF, FCMEN = OFF
//_CP_OFF & _CPD_OFF & _BOR_OFF & _MCLRE_ON & _WDT_OFF & _PWRTE_ON & _INTRC_OSC_NOCLKOUT & _FCMEN_OFF & _IESO_OFF



void pic_init()
{
    //Setting Oscillator
    OSCCON = 0b01110000;    //8Mhz Crystal, OSTS - Intrnal Oscillator, HFINTOSC - High Frequency Oscillator(1), LFINTOSC - Low Freq. Oscillator(0), Internal Oscillator is used for Clock

    ANSEL   = 0;
    ANSELH  = 0;
    //Disabling the A2D converter
    //ADCON0bits.ADON = 0;
    //CCP1CON = 0;
    //TRISCbits.TRISC6 = 0;
    //PORTCbits.RC6 = 0;
    
    ADCON1 = 0b01110000;
    TRISCbits.TRISC0 = 1;
    TRISCbits.TRISC1 = 1;
    ANSELbits.ANS4   = 1;
    
    ADCON0 = 0b10010000; // AN4 channel selected
    ADCON0bits.ADON = 1;
}



void interrupt isr()
{
    //handle_i2c();
    
   
}


int main(int argc, char** argv)
{
    uint8_t upper_byte = 0, lower_byte = 0;
    uint16_t value = 0;
    
    pic_init();
    uart_init();
    
    
    while(1){
        
        ADCON0bits.GO = 1;
        
        while(ADCON0bits.GO_nDONE);
        
        //upper_byte = ADRESH;
        //lower_byte = ADRESL;
        value = (uint16_t)ADRESH << 8 | ADRESL;
        
        //printf("It works!!!\r\n");
        printf("Read Values = %04d, %d\r\n", value, PORTCbits.RC1);
        //printf("%d\r\n", value);
        __delay_ms(200);
   
    }

    //return (EXIT_SUCCESS);
    return (0);
}

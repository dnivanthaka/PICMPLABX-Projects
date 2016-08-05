#include <xc.h>
#include <stdio.h>
#include <stdlib.h>


#include "uart.h"

#define _XTAL_FREQ      20000000 // 20MHz Clock

#define RX_TRIS TRISCbits.TRISC1
#define RX_PORT PORTCbits.RC1

#pragma config BOREN = ON, CPD = OFF, FOSC = HS, WDTE = OFF, CP = OFF, LVP = OFF, PWRTE = ON


void init()
{
    //Disabling the A2D converter
    ADCON0bits.ADON = 0;

    //PORTC = 0x00;
    //TRISC = 0x00;
    //TRISCbits.TRISC1 = 1;
    //PORTC = 0x00;
    
    OPTION_REGbits.T0CS = 0;
    OPTION_REGbits.T0SE = 0;
    OPTION_REGbits.PSA  = 0;
    OPTION_REGbits.PS0  = 1;                // 800ns
    OPTION_REGbits.PS1  = 0;
    OPTION_REGbits.PS2  = 0;
}

void rx_init(){
    RX_TRIS = 1;
    RX_PORT = 0;
}


unsigned char rx_readbit()
{
    while( !RX_PORT );
    //__delay_us(10);
    //if(!RX_PORT) return 0;
    while( RX_PORT );
    TMR0 = 0;
    while( !RX_PORT &&  TMR0 < 185 );

    if( TMR0 > 170 ){
        return 1;
    }else{
        return 0;
    }
}

unsigned char rx_readbyte()
{
    unsigned char i, data = 0;

    for(i=0;i<8;i++){
        
        data = data << 1;
        data |= rx_readbit();
        //data |= rx_readbit() << (7 - i);
        
        //printf("data = %x\r\n", data);

        
        //data |= rx_readbit();
    }

    return data;
}

unsigned char rx_read()
{
    unsigned char i=0, checksum = 0;
    unsigned char data[64] = {0};
    //unsigned char data = rx_readbyte();
    // Reading pattern 1010
    //if( rx_readbit() && !rx_readbit() && rx_readbit() && !rx_readbit() ){
        //if(rx_readbyte() == 0x55){
            //printf("Preamble byte received %x\r\n", rx_readbyte());
    //if(data == 0x53){
        //printf("%x, ", rx_readbyte());
    //}
        //}
    //}
    
//    if( rx_readbyte() == 0x55 ){
//        if(rx_readbyte() == 0x77){
//            printf("Data Received %x\r\n", rx_readbyte());
//        }
//    }
    while(i < 10){
        if(rx_readbit() == 0)
            i++;
        else
            return 0;
    }
        
    while(rx_readbit() != 1);
    
    unsigned char bt1, bt2, len, bt4;
    
    bt1 = rx_readbyte();
    bt2 = rx_readbyte();
    len = rx_readbyte();
    bt4 = rx_readbyte();
    
    //printf("- %x -", bt1);
    
    if(bt1 == 0x55 && bt4 == 0x77){
        for(i=0;i<len;i++){
            data[i] = rx_readbyte();
            //checksum += data[i];
        }
        
        //unsigned char chk = rx_readbyte();
        
        //if(chk == checksum){
        
            //for(i=0;i<8;i++){
                //printf("| Received from device %x (%x, %x, %x, %x, %x, %x, %x, %x) | ", bt2, data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7]);
            //}

            printf("| Received from device %x (", bt2);

            for(i=0;i<len;i++){
                printf("%x, ", data[i]);
            }

            printf(") | ");

            printf("[OW1 = %d, %d]", ((data[0] << 8) | data[1]), ((data[2] << 8) | data[3]));
            printf("[OW2 = %d, %d]", ((data[4] << 8) | data[5]), ((data[6] << 8) | data[7]));
            printf("[DHT22 = %d, %d]", ((data[8] << 8) | data[9]), ((data[10] << 8) | data[11]));
        //}
    }

    
    
    return 0;
}

unsigned char rx_read_data()
{
    unsigned char length, bt1, bt2, i = 0;
    
    while(i < 10){
        if(rx_readbit() == 0)
            i++;
        else
            return 0;
    }
    
    while(rx_readbit() != 1);
    
    return 0;
}

int main(int argc, char** argv)
{
    

    init();
    uart_init();
    rx_init();
    
    //ds18b20_search();
    //ds18b20_read_data();


    //dht22_read(&s1);
    //PORTC = 0x00;
    printf("Listening....\r\n");
    while(1){
        
        rx_read();
        
        //__delay_ms(20);
    }

    return (EXIT_SUCCESS);
}


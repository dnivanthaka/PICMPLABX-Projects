#include <xc.h>
#include <stdio.h>
//#include <stdlib.h>

#include "uart.h"
#include "ds18b20.h"
#include "dht22.h"
#include "i2c_slave.h"

#define _XTAL_FREQ      20000000 // 20MHz Clock


#pragma config BOREN = ON, CPD = OFF, FOSC = HS, WDTE = OFF, CP = OFF, LVP = OFF, PWRTE = ON


void pic_init()
{
    //Disabling the A2D converter
    ADCON0bits.ADON = 0;

    //PORTC = 0x00;
    TRISD = 0x00;
    PORTD = 0x00;
}

void interrupt isr()
{
    handle_i2c();
}


int main(int argc, char** argv)
{
    //char buff[2] = {5, 15};
    
    struct ds18b20 t1 = {
        {0x28, 0x69, 0x55, 0x5d, 0x5, 0, 0, 0x7c},
        0,
        0,
        {0, 0, 0, 0, 0, 0, 0, 0, 0},
        0,
        0
    };

    struct ds18b20 t2 = {
        {0x28, 0x6a, 0xf4, 0x8f, 0x6, 0, 0, 0x39},
        0,
        0,
        {0, 0, 0, 0, 0, 0, 0, 0, 0},
        0,
        0
    };

    struct dht22 d1 = {0};
    

    /*
     * id 1 = 28
       id 2 = 6a
       id 3 = f4
       id 4 = 8f
       id 5 = 6
       id 6 = 0
       id 7 = 0
       id 8 = 39*/

    /*
    id 1 = 28
    id 2 = 69
    id 3 = 55
    id 4 = 5d
    id 5 = 5
    id 6 = 0
    id 7 = 0
    id 8 = 7c

     */

    pic_init();
    uart_init();
    ds18b20_init();
    dht22_init();
    //init_i2cslave();
    //ds18b20_search();
    //ds18b20_read_data();
    //ds18b20_read_rom(&t1);
    //ds18b20_start_convert(&t1);
    //ds18b20_read_scratch(&t1);
   
    //buff = 0;

    


    //dht22_read(&s1);
    //PORTD = 0x0F;

    while(1){
        //ds18b20_read_rom(&t1);
        //printf("======== Sensor 1 ========\r\n");
        ds18b20_start_convert(&t1);
        ds18b20_read_scratch(&t1);

        __delay_ms(200);

        //printf("======== Sensor 2 ========\r\n");
        ds18b20_start_convert(&t2);
        ds18b20_read_scratch(&t2);

        __delay_ms(200);

        //printf("===========================\r\n");
        dht22_read(&d1);

        printf("READINGS_START\r\n");
        printf("ow1_tempi, ow1_tempd, ow2_tempi, ow2_tempd, dht22_temp, dht22_pressure\r\n");
        printf("%d, %d, %d, %d, %d, %d\r\n", t1.tempi, t1.tempd, t2.tempi, t2.tempd, ((d1.ti << 8)  + d1.td), ((d1.rhi << 8) + d1.rhd));
        printf("READINGS_END\r\n");

        __delay_ms(200);
    }

    //return (EXIT_SUCCESS);
    return (0);
}

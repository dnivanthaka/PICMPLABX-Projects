#include <xc.h>
#include <stdio.h>
#include <stdlib.h>

#include "i2c.h"
#include "uart.h"
#include "dht22.h"
#include "1wire.h"
#include "ds18b80.h"
#include "ds1307.h"
#include "dwire.h"

#define _XTAL_FREQ      20000000 // 20MHz Clock


#pragma config BOREN = ON, CPD = OFF, FOSC = HS, WDTE = OFF, CP = OFF, LVP = OFF, PWRTE = ON


void init()
{
    //Disabling the A2D converter
    ADCON0bits.ADON = 0;

    //PORTC = 0x00;
    TRISD = 0x00;
    PORTD = 0x00;
}



int main(int argc, char** argv)
{
    char buff[2] = {5, 15};
    struct dht22 s1 = {0, 0, 0, 0, 0};
    struct ds18b20 t1 = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0, 0};
    struct ds1307 timer = {0, 0, 0, 0, 0, 0, 0, 0};

    init();
    uart_init();
    dht22_init();
    ow_init();
    dw_init();
    //ds18b20_search();
    //ds18b20_read_data();
    ds18b20_read_rom(&t1);
    ds18b20_start_convert();
    ds18b20_read_scratch(&t1);
    ds1307_init(0);
    ds1307_write_nvram(1, buff, 2);
    //buff = 0;
    
    ds1307_read_nvram(1, buff, 1);
    printf("Read nvram = %d\r\n", buff[0]);

    timer.seconds = 1;
    timer.minutes = 3;
    timer.hours   = 11;
    timer.date    = 5;
    timer.month   = 3;
    timer.year    = 15;
    ds1307_set(&timer);


    //dht22_read(&s1);
    //PORTD = 0x0F;

    while(1){
        //printf("XP\n");
        //buff = getchar();
        dht22_read(&s1);
        //printf("%c", buff);
        ds18b20_start_convert();
        ds18b20_read_scratch(&t1);
        //ds1307_read_data();
        //ds1307_read_data();
        if(ds1307_is_running()){
            ds1307_now(&timer);
            ds1307_print(&timer);
        }else{
            printf("DS1307 ERROR: Not running\r\n");
        }

        dw_start(0);
        dw_send_byte(0, 0xFF);
        dw_send_byte(0, 0xF0);
        dw_send_byte(0, 0x0F);
        
        __delay_ms(2000);
    }

    return (EXIT_SUCCESS);
}
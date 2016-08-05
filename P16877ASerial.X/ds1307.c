#include <xc.h>
#include <stdio.h>
#include <stdlib.h>

#include "i2c.h"
#include "ds1307.h"

void ds1307_init(uint8_t addr)
{
    unsigned char ack = 1;
    
    i2c_init();
    i2c_start();
    //printf("XXXXXXXXXXXXXX");
    i2c_send_controlbyte(DS1307ADDR, 0);
    ack = i2c_read_ack();
    //i2c_send_nack();
    i2c_stop();
    
    if( ack == 0 ){
        printf("DS1307 responded\r\n");
    }else{
        printf("DS1307 didnt respond\r\n");
    }

    
}

void ds1307_read_data()
{
    unsigned char ack = 1;
    unsigned char data[2] = {0, 0};

    //i2c_init();
    i2c_start();
    i2c_send_controlbyte(DS1307ADDR, 1);
    i2c_send_repstart();
    //ack = i2c_read_ack();
    //if( ack == 0 ){
        data[0] = i2c_read_data();
        data[1] = i2c_read_data();
        //i2c_read_data();
        //i2c_read_data();
        //i2c_read_data();
        //i2c_read_data();
        //i2c_read_data();
        //i2c_read_data();

        //i2c_send_nack();

        printf("DS1307 data 1 = %x\r\n", data[0]);
        printf("DS1307 data 2 = %x\r\n", data[1]);
    //}
    i2c_stop();
}

void ds1307_now(struct ds1307 *dev)
{
    //static bit ack;
    i2c_start();
    // Write the starting address
    i2c_send_controlbyte(DS1307ADDR, 0);
    i2c_send_data(0);
    //i2c_stop();
    i2c_send_repstart();
    i2c_send_controlbyte(DS1307ADDR, 1);
    // Reading data
    dev->seconds = bcd2bin(i2c_read_data() & 0x7F);
    i2c_send_ack();
    dev->minutes = bcd2bin(i2c_read_data());
    i2c_send_ack();
    dev->hours   = bcd2bin(i2c_read_data());
    i2c_send_ack();
    dev->day     = bcd2bin(i2c_read_data());
    i2c_send_ack();
    dev->date    = bcd2bin(i2c_read_data());
    i2c_send_ack();
    dev->month   = bcd2bin(i2c_read_data());
    i2c_send_ack();
    dev->year    = bcd2bin(i2c_read_data()) + 2000;
    i2c_send_nack();
    i2c_stop();
}

void ds1307_set(struct ds1307 *dev)
{
    //static bit ack;
    i2c_start();
    // Write the starting address
    i2c_send_controlbyte(DS1307ADDR, 0);
    i2c_send_data(0);
    //i2c_send_data(0);
    i2c_read_ack();
    //i2c_stop();
    // Writing data
    //printf("Bin2bcd = %d\r\n", dev->seconds);
    //i2c_send_data(9);
    //i2c_read_ack();
    //i2c_send_data(35);
    //i2c_read_ack();
    
    i2c_send_data(bin2bcd(dev->seconds));
    i2c_read_ack();
    i2c_send_data(bin2bcd(dev->minutes));
    i2c_read_ack();
    i2c_send_data(bin2bcd(dev->hours));
    i2c_read_ack();
    i2c_send_data(bin2bcd(dev->day));
    i2c_read_ack();
    i2c_send_data(bin2bcd(dev->date));
    i2c_read_ack();
    i2c_send_data(bin2bcd(dev->month));
    i2c_read_ack();
    i2c_send_data(bin2bcd(dev->year));
    i2c_read_ack();
    
    i2c_stop();
    __delay_us(10);
}

void ds1307_read_nvram(uint8_t offset, uint8_t *buffer, uint8_t num)
{
    uint8_t i;
    uint8_t addr = DS1307NVRAM + offset;

    i2c_start();
    i2c_send_controlbyte(DS1307ADDR, 0);
    i2c_send_data(addr);
    i2c_read_ack();
    //i2c_send_data(0);
    //i2c_stop();
    i2c_start();
    //i2c_send_repstart();
    i2c_send_controlbyte(DS1307ADDR, 1);
    // Reading data
    for(i=0;i<num;i++){
        buffer[i] = i2c_read_data();
        i2c_send_ack();
    }
    i2c_send_nack();
    i2c_stop();
}

void ds1307_write_nvram(uint8_t offset, uint8_t *buffer, uint8_t num)
{
    uint8_t i;
    uint8_t addr = DS1307NVRAM + offset;

    i2c_start();
    i2c_send_controlbyte(DS1307ADDR, 0);
    i2c_send_data(addr);
    //i2c_send_data(0);
    i2c_read_ack();
    // Writing data
    for(i=0;i<num;i++){
        i2c_send_data(buffer[i]);
        i2c_read_ack();
    }
    i2c_stop();
}

void ds1307_print(struct ds1307 *dev)
{
    //printf("=====================================\r\n");
    //printf("Seconds = %d\r\n", dev->seconds );
    //printf("Minutes = %d\r\n", dev->minutes );
    //printf("Hours   = %d\r\n", dev->hours);
    //printf("Day     = %d\r\n", dev->day );
    //printf("Date    = %d\r\n", dev->date );
    //printf("Month   = %d\r\n", dev->month );
    //printf("Year    = %d\r\n", dev->year );
    printf("=====================================\r\n");
    printf("Time is now %02d:%02d:%02d (hh:mm:ss)\r\n", dev->hours, dev->minutes, dev->seconds);
    printf("Date is now %02d-%02d-%04d (d-m-y)\r\n", dev->date, dev->month, dev->year);
    printf("=====================================\r\n");
    //printf("Seconds = %d\r\n", bcd2bin( dev->seconds ));
    //printf("Minutes = %d\r\n", bcd2bin( dev->minutes ));
    //printf("Hours   = %d\r\n", bcd2bin( dev->hours ));
    //printf("Day     = %d\r\n", bcd2bin( dev->day ));
    //printf("Date    = %d\r\n", bcd2bin( dev->date ));
    //printf("Month   = %d\r\n", bcd2bin( dev->month ));
    //printf("Year    = %d\r\n", bcd2bin( dev->year )+2000);
}

uint8_t ds1307_is_running()
{
    i2c_start();
    // Write the starting address
    i2c_send_controlbyte(DS1307ADDR, 0);
    i2c_send_data(0);
    //i2c_stop();
    i2c_send_repstart();
    i2c_send_controlbyte(DS1307ADDR, 1);
    // Reading data
    uint8_t s = i2c_read_data();
    i2c_send_nack();
    i2c_stop();
    return !(s >> 7);
}

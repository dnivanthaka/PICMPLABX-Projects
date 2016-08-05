#include <xc.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include "1wire.h"
#include "ds18b80.h"

void ds18b20_read_rom(struct ds18b20 *dev)
{
    unsigned char romid[8];

    //ow_init();
    ow_reset();
    ow_write_byte(0x33);
    romid[0] = ow_read_byte();
    romid[1] = ow_read_byte();
    romid[2] = ow_read_byte();
    romid[3] = ow_read_byte();
    romid[4] = ow_read_byte();
    romid[5] = ow_read_byte();
    romid[6] = ow_read_byte();
    romid[7] = ow_read_byte();


    printf("id 1 = %x\r\n", romid[0]);
    printf("id 2 = %x\r\n", romid[1]);
    printf("id 3 = %x\r\n", romid[2]);
    printf("id 4 = %x\r\n", romid[3]);

    //*(id)     = romid[1] | romid[0];
    //*(id + 1) = romid[3] | romid[2];
    dev->address[0] = ((((unsigned long)romid[3] << 8) | (unsigned long)romid[2]) << 16) | (((unsigned long)romid[1] << 8) | romid[0]);
    dev->address[1] = ((((unsigned long)romid[7] << 8) | (unsigned long)romid[6]) << 16) | (((unsigned long)romid[5] << 8) | romid[4]);

    printf("Address 1 = %ld\r\n", dev->address[0]);
    printf("Address 2 = %ld\r\n", dev->address[1]);
}

void ds18b20_read_scratch(struct ds18b20 *dev)
{
    //unsigned char data[9];

    //ow_init();
    ow_reset();
    ow_write_byte(0xCC);
    ow_write_byte(0xBE);
    dev->scratchpad[0] = ow_read_byte();
    dev->scratchpad[1] = ow_read_byte();
    dev->scratchpad[2] = ow_read_byte();
    dev->scratchpad[3] = ow_read_byte();
    dev->scratchpad[4] = ow_read_byte();
    dev->scratchpad[5] = ow_read_byte();
    dev->scratchpad[6] = ow_read_byte();
    dev->scratchpad[7] = ow_read_byte();
    dev->scratchpad[8] = ow_read_byte();

    printf("data 1 = %x\r\n", dev->scratchpad[0]);
    printf("data 2 = %x\r\n", dev->scratchpad[1]);
    printf("data 3 = %x\r\n", dev->scratchpad[2]);
    printf("data 4 = %x\r\n", dev->scratchpad[3]);
    printf("data 5 = %x\r\n", dev->scratchpad[4]);
    printf("data 6 = %x\r\n", dev->scratchpad[5]);
    printf("data 7 = %x\r\n", dev->scratchpad[6]);
    printf("data 8 = %x\r\n", dev->scratchpad[7]);
    printf("data 9 = %x\r\n", dev->scratchpad[8]);

    dev->config = dev->scratchpad[4];
    dev->crc    = dev->scratchpad[8];

    //printf("TempDS = %d\r\n", ((dev->scratchpad[1] << 8) | (dev->scratchpad[0] >> 4)));
    dev->tempi = (((0x07 & dev->scratchpad[1]) << 8) | dev->scratchpad[0]) >> 4;
    if(dev->scratchpad[1] & 0xF0)
        dev->tempi = -dev->tempi;

    dev->tempd = dev->scratchpad[0] & 0x0F;
    if( dev->tempd & 0x08 ){
        dev->tempd = 50;
    }else if( dev->tempd & 0x04 ){
        dev->tempd = 250;
    }else if( dev->tempd & 0x02 ){
        dev->tempd = 1250;
    }else if( dev->tempd & 0x01 ){
        dev->tempd = 625;
    }

    printf("TempDS = %d.%d\r\n", dev->tempi, dev->tempd);
}

void ds18b20_start_convert()
{
    ow_reset();
    ow_write_byte(0xCC);
    ow_write_byte(0x44);
    __delay_ms(750);
}

void ds18b20_read_data()
{
    unsigned char romid[4];
    int i, j;

    //ow_init();
    ow_reset();
    ow_write_byte(0x33);
    for(j=0;j<4;j++){
        for(i=0;i<8;i++){
            romid[j] >>= 1;
            TRISBbits.TRISB5 = 0;
            __delay_us(1);
            TRISBbits.TRISB5 = 1;
            __delay_us(5);

           if(PORTBbits.RB5 == 1)
            romid[j] = romid[j] | 0x80;
            __delay_us(55);
         }
    }

    printf("id2 1 = %x\r\n", romid[0]);
    printf("id2 2 = %x\r\n", romid[1]);
    printf("id2 3 = %x\r\n", romid[2]);
    printf("id2 4 = %x\r\n", romid[3]);
}

void ds18b20_write_scratch(struct ds18b20 *dev)
{
    ow_reset();
    ow_write_byte(0xCC);
    ow_write_byte(dev->scratchpad[2]);
    ow_write_byte(dev->scratchpad[3]);
    ow_write_byte(dev->config);
}

void ds18b20_copy_scratch()
{
    ow_reset();
    ow_write_byte(0xCC);
    ow_write_byte(0x48);
}

void ds18b20_recall_eeprom()
{
    ow_reset();
    ow_write_byte(0xCC);
    ow_write_byte(0xB8);
    __delay_us(50);
}

void ds18b20_set_resolution(struct ds18b20 *dev, unsigned char res)
{
    if(res == DS18B20_9BIT){
        dev->config = dev->config & 0x9F;
    }else if(res == DS18B20_10BIT){
        dev->config = dev->config & 0x9F;
        dev->config = dev->config | 0x20;
    }else if(res == DS18B20_11BIT){
        dev->config = dev->config & 0x9F;
        dev->config = dev->config | 0x40;
    }else if(res == DS18B20_11BIT){
        dev->config = dev->config & 0x9F;
        dev->config = dev->config | 0x60;
    }

    ds18b20_write_scratch(dev);
}
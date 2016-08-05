#include <xc.h>
#include <stdint.h>
#include <spi.h>

#include "pcd8544.h"

// Pin configuration
// RES -> RC0
// CE  -> RC1
// D/C -> RC2

void pcd8544_reset()
{
    uint8_t i;
    // Issuing command
    LATCbits.LC1 = 0;
    LATCbits.LC0 = 0;

    for(i=0;i<8;i++){
        __delay_ms(25);
    }
    //__delay_ms(25);
    //__delay_ms(25);
    //__delay_ms(25);
    //__delay_ms(25);
    //__delay_ms(25);
    //__delay_ms(25);

    LATCbits.LC0 = 1;

    //__delay_ms(25);
    //__delay_ms(25);

    // Device deselect
    LATCbits.LC1 = 1;
}

void pcd8544_command(uint8_t cmd)
{
    // Device select
    LATCbits.LC1 = 0;
    // Setting command mode -> D/C = 0
    LATCbits.LC2 = 0;

    pcd8544_sendbyte(cmd);
    
    // Setting data mode -> D/C = 1
    //LATCbits.LC2 = 1;
    // Device deselect
    LATCbits.LC1 = 1;

}

void pcd8544_sendbyte(uint8_t data)
{
    // Device select
    LATCbits.LC1 = 0;

    WriteSPI(data);
    //ReadSPI();

    // Device deselect
    LATCbits.LC1 = 1;
}

void pcd8544_sendbyte_data(uint8_t *data, uint8_t count)
{
    uint8_t i;

    // Device select
    LATCbits.LC1 = 0;
    // Setting data mode -> D/C = 1
    LATCbits.LC2 = 1;

    for(i=0;i<count;i++){
        WriteSPI(data[i]);
    }
    //ReadSPI();

    // Setting command mode -> D/C = 0
    //LATCbits.LC2 = 0;
    // Device deselect
    LATCbits.LC1 = 1;
}

void pcd8544_init()
{
    //__delay_ms(25);
    //__delay_ms(25);

    pcd8544_reset();

    //__delay_ms(25);
    //__delay_ms(25);
    //__delay_ms(25);
    //__delay_ms(25);
    
    /*
    //Extended instructions enabled
    pcd8544_command(0x21);
    //Set contrast 0 - 127
    pcd8544_command(0x80 + 0x7F);
    //Temperature control
    pcd8544_command(0x04 + 0x02);
    //Set bias system
    pcd8544_command(0x10 + 0x03);
    //Return to basic instruction set, power on, set horizontal addressing
    pcd8544_command(0x20);
    //Display control set to normal mode
    pcd8544_command(0x08 + 0x04);
    */
    /*
     //Extended instructions enabled
    pcd8544_command(0x20 + 0x01);
    //Set bias system
    pcd8544_command(0x10 + 0x03);
    //Set contrast 0 - 127
    pcd8544_command(0x80 + 0x7F);
    //Temperature control
    pcd8544_command(0x04 + 0x03);

    //Return to basic instruction set, power on, set horizontal addressing
    pcd8544_command(0x20);
    //Display control set to normal mode
    pcd8544_command(0x08 + 0x04);
    */
    pcd8544_command(0x20 + 0x01);
    //pcd8544_command(0xB0 + 0x08);
    pcd8544_command(0x80 + 0x3A);
    pcd8544_command(0x04 + 0x02);
    pcd8544_command(0x10 + 0x03);
    pcd8544_command(0x20);
    pcd8544_command(0x0C);
}

void pcd8544_draw_bytes( int x, int y, uint8_t *bytes, uint8_t len )
{
    uint8_t i;
    uint16_t idx = (y * 84) + x;

    for(i=0;i<len;i++){
        pcd8544_buffer[idx + i] = bytes[i];
    }
}

void pcd8544_flash()
{
    uint8_t i;

    for(i=0;i<3;i++){
        pcd8544_command(0x08);
        __delay_ms(25);
        __delay_ms(25);
        pcd8544_command(0x09);
        __delay_ms(25);
        __delay_ms(25);
    }
    pcd8544_command(0x0C);
}

void pcd8544_clear()
{
    pcd8544_command(0x09);
    //pcd8544_command(0x0C);
}

void pcd8544_update()
{
    uint16_t i;
    uint8_t x, y;
    
    // Reset address pointer
    pcd8544_resetxy();

    // Device select
    //LATCbits.LC1 = 0;

    //putsSPI(pcd8544_buffer);
    //ReadSPI();

    // Device deselect
    //LATCbits.LC1 = 1;
     // Device select
    LATCbits.LC1 = 0;
    // Setting data mode -> D/C = 1
    LATCbits.LC2 = 1;

   
    for(y=0;y<6;y++){
        for(x=0;x<84;x++){
            //pcd8544_sendbyte(pcd8544_buffer[i]);
            //pcd8544_sendbyte(pcd8544_buffer[i+1]);
            //pcd8544_sendbyte(pcd8544_buffer[i+2]);
            //pcd8544_sendbyte(pcd8544_buffer[i+3]);
            //pcd8544_sendbyte(pcd8544_buffer[i+4]);
            //pcd8544_sendbyte(pcd8544_buffer[i+5]);
            //pcd8544_sendbyte(pcd8544_buffer[i+6]);
            //pcd8544_sendbyte(pcd8544_buffer[i+7]);
             WriteSPI(pcd8544_buffer[(y * 84) + x]);
            //ReadSPI();


        }
    }

     // Device deselect
     LATCbits.LC1 = 1;
}

void pcd8544_putpixel(uint8_t x, uint8_t y, uint8_t color)
{
    /*
    pcd8544_command(0x80 + x);
    pcd8544_command(0x40 + y);
    pcd8544_sendbyte(color);
    */
    //pcd8544_command(0x40);
    //pcd8544_buffer[0] = color & 0x01;
    //pcd8544_buffer[x] = y;
    uint16_t idx = ((y / 8) * 84) + x;
    pcd8544_buffer[ idx ] |= color << (y % 8);
    //pcd8544_buffer[ x ] = 1;
}

void pcd8544_resetxy()
{
    pcd8544_command(0x80);
    pcd8544_command(0x40);
}


void pcd8544_setxy(uint8_t x, uint8_t y)
{
    pcd8544_command(0x80 | x);
    pcd8544_command(0x40 | y);
}


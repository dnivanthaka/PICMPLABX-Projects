#include <xc.h>
#include <stdio.h>
#include <stdint.h>
#include <spi.h>
#include <string.h>

#include "pcd8544.h"

#define _XTAL_FREQ      16000000 // 16MHz Clock

//docs/chips/18f2550.html
#pragma config BOR = OFF, CPD = OFF, FOSC = HS, WDT = OFF, CP0 = OFF, CP1 = OFF, CP2 = OFF, CP3 = OFF, LVP = OFF, FCMEN = OFF
#pragma config PLLDIV = 5
#pragma config CPUDIV = OSC4_PLL6
//#pragma MCLRE = ON
//#pragma WRT0 = OFF, WRT1 = OFF, WRT2 = OFF, WRT3 = OFF

struct obj {
    uint8_t x, y;
    int8_t vel_x, vel_y;
    uint8_t w, h;
    uint8_t dta[5];
};

// Function prototypes
void pic_init();
void obj_move(struct obj *ob);
void obj_init(struct obj *ob);
void obj_draw(struct obj *ob);
void obj_delete(struct obj *ob);
uint8_t debounce_read(uint8_t pin);


uint8_t debounce_read(uint8_t pin)
{
    uint8_t i = 0;
    
    while(pin == 0 && i++ < 10){
        //i++;
        __delay_ms(1);
    }

    if(i == 10)
        return 1;
    else
        return 0;
}

void pic_init()
{
    // Shutting down unneeded peripherals
    // Shutting down the A/D converter
    ADCON0bits.ADON = 0;
    ADCON1 = 0x0F;

    //Shutting down the USB peripheral
    UCONbits.USBEN = 0;

    // Configuring ports
    TRISCbits.RC0 = 0;
    TRISCbits.RC1 = 0;
    TRISCbits.RC2 = 0;

    LATCbits.LC0  = 1;
    LATCbits.LC1  = 1;
    LATCbits.LC2  = 0;

    TRISBbits.RB2 = 1;
    TRISBbits.RB3 = 1;

    //Enabling PORTB pullups
    //INTCON2bits.RBPU = 0;
}

int main(int argc, char *argv[])
{
    int i, j;
    pic_init();
    uint8_t data[] = {0x1F, 0x15, 0x15, 0x15, 0x0E};
    uint8_t data2[] = {0x00, 0x00, 0x00, 0x00, 0x00};

    struct obj o1;

    //LATCbits.LC2 = 1;

    OpenSPI(SPI_FOSC_4, MODE_00, SMPEND);

    pcd8544_init();
    pcd8544_putpixel(1, 0, 1);
    pcd8544_update();
    //pcd8544_flash();
    //pcd8544_putpixel();
    //pcd8544_clear();
    //pcd8544_putpixel();
    //pcd8544_update();
    //pcd8544_setxy(0, 0);
    /*
    for(j=0;j<48;j++){
        for(i=0;i<84;i++){
            pcd8544_putpixel(i, j, 1);
            //pcd8544_update();
            //__delay_ms(25);
            //i++;
            //i = i % 84;
        }
        pcd8544_update();
    }
    */
    i=0;
    //pcd8544_draw_bytes( 0, 0, data, 5 );
    //pcd8544_update();
    //memcpy(o1.dta, data, 5);
    //obj_init(&o1);

    //o1.vel_x = 1;
    
//    while(1){
//        o1.vel_x = 0;
//
//        if( PORTBbits.RB2 == 0 ){
//            //pcd8544_putpixel(0, 0, 1);
//            //pcd8544_putpixel(1, 0, 1);
//            o1.vel_x = 1;
//        }else{
//            //pcd8544_putpixel(0, 0, 0);
//            //pcd8544_putpixel(1, 0, 0);
//            //o1.vel_x = 0;
//        }
//
//        if( PORTBbits.RB3 == 0 ){
//            //pcd8544_putpixel(0, 0, 1);
//            //pcd8544_putpixel(1, 0, 1);
//            o1.vel_x = -1;
//        }else{
//            //pcd8544_putpixel(0, 0, 0);
//            //pcd8544_putpixel(1, 0, 0);
//            //o1.vel_x = 0;
//        }
//        /*
//        if(o1.x < 0){
//            o1.x = 0;
//            o1.vel_x = 0;
//        }
//        */
//
//        //pcd8544_draw_bytes( i, 0, data, 5 );
//        obj_move(&o1);
//
//
//
//        obj_draw(&o1);
//        pcd8544_update();
//        obj_delete(&o1);
//        //pcd8544_draw_bytes( i, 0, data2, 5 );
//        //i++;
//        //i = i % (84 - 5);
//        //o1.vel_x++;
//
//
//        //o1.x = o1.x % (84 - 5);
//    }

    while(1);

    // This shouldnt be reached
    return 0;
}

void obj_move(struct obj *ob)
{
    if( ob->x + ob->vel_x < 0 ){
        ob->x = 0;
        ob->vel_x = 0;
    }


    if( ob->x + ob->vel_x > (84 - 5) ){
        ob->x = (84 - 5);
        ob->vel_x = 0;
    }
    
    ob->x += ob->vel_x;
    ob->y += ob->vel_y;
}

void obj_init(struct obj *ob)
{
    ob->w = 5;
    ob->h = 5;
    ob->vel_y = 0;
    ob->vel_x = 0;
    //ob->dta[];
    ob->x = 0;
    ob->y = 0;
}

void obj_draw(struct obj *ob)
{
    pcd8544_draw_bytes( ob->x, ob->y, ob->dta, 5 );
}

void obj_delete(struct obj *ob)
{
    uint8_t data2[] = {0x00, 0x00, 0x00, 0x00, 0x00};

    pcd8544_draw_bytes( ob->x, ob->y, data2, 5 );
}
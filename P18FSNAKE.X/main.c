#include <xc.h>
#include <stdio.h>
#include <stdint.h>
#include <spi.h>
#include <string.h>

#include "pcd8544.h"
#include "font5x7.h"

#define _XTAL_FREQ      16000000 // 16MHz Clock

//docs/chips/18f2550.html
#pragma config BOR = OFF, CPD = OFF, FOSC = HS, WDT = OFF, CP0 = OFF, CP1 = OFF, CP2 = OFF, CP3 = OFF, LVP = OFF, FCMEN = OFF
#pragma config PLLDIV = 5
#pragma config CPUDIV = OSC4_PLL6
//#pragma MCLRE = ON
//#pragma WRT0 = OFF, WRT1 = OFF, WRT2 = OFF, WRT3 = OFF
const uint8_t BLOCK_WIDTH  = 2;
const uint8_t BLOCK_HEIGHT = 2;

typedef struct {
    int8_t x, y;
    int8_t vel_x, vel_y;
    uint8_t w, h;
    uint8_t dta[2*2];
} entity_t;

typedef struct {
    unsigned p0:1;
    unsigned p1:1;
    unsigned p2:1;
    unsigned p3:1;
    unsigned p4:1;
    unsigned p5:1;
    unsigned p6:1;
    unsigned p7:1;
} port_t;

// Function prototypes
void pic_init();
void obj_move(entity_t *ob);
void obj_init(entity_t *ob);
void obj_draw(entity_t *ob);
void obj_delete(entity_t *ob);
//uint8_t debounce_read(volatile uint8_t *port, uint8_t pin);
//void draw_block(uint8_t x, uint8_t y);


uint8_t debounce_read(volatile uint8_t *port, uint8_t pin)
{
    uint8_t i = 0;
    
    while((*port & pin) == 0 && i < 10){
        i++;
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
    TRISBbits.RB4 = 0;

    LATBbits.LATB4 = 1;

    //Enabling PORTB pullups
    //INTCON2bits.RBPU = 0;
}

int main(int argc, char *argv[])
{
    entity_t o1, o2, o3, o4;
    //volatile uint8_t *port;
    //volatile uint8_t *pin;

    //port_t *prt = &LATB;

    //port = &PORTB;
    //pin  = PORTBbits.RB4;

    //LATCbits.LC2 = 1;
     pic_init();

    OpenSPI(SPI_FOSC_4, MODE_00, SMPEND);

    pcd8544_init();
    
    obj_init(&o1);
    obj_init(&o2);
    obj_init(&o3);
    obj_init(&o4);

    o1.dta[0] = 0xf;
    o1.dta[1] = 0x7;
    o1.dta[2] = 0x3;
    o1.dta[3] = 0x1;

    o2.dta[0] = 0x1;
    o2.dta[1] = 0x3;
    o2.dta[2] = 0x7;
    o2.dta[3] = 0xf;

    o3.dta[0] = 0xf0;
    o3.dta[1] = 0xe0;
    o3.dta[2] = 0xC0;
    o3.dta[3] = 0x80;

    o2.x = 80;
    o3.y = 5;
    //pcd8544_flash();
    while(1){
        //(*port) = 0;
        //prt = 0;
        
        //if( debounce_read(PORTB, 2) == 1 ){
            //pcd8544_putpixel(1, 0, 1);
            //pcd8544_putpixel(1, 0, 1);
            //LATBbits.LATB4 = 0;
        //}else{
            //pcd8544_putpixel(1, 0, 0);
        //}

        /*
        if( pin == 0 ){
            LATBbits.LATB4 = 0;
        }else{
            LATBbits.LATB4 = 1;
        }*/
        if(PORTBbits.RB2 == 0){
            o1.vel_x = -1;
        }else if(PORTBbits.RB3 == 0){
            o1.vel_x = 1;
        }else{
            o1.vel_x = 0;
        }

        obj_move(&o1);

        obj_draw(&o1);
        obj_draw(&o2);
        obj_draw(&o3);

        //pcd8544_draw_bytes( 0, 2, &font55[1 * 5], 5 );
        putch('0');
        //printf("Test");

        //pcd8544_putpixel(1, 0, 1);
        pcd8544_update();

        obj_delete(&o1);
    }
   
   
    while(1);

    // This shouldnt be reached
    return 0;
}


void obj_move(entity_t *ob)
{
    if( ob->x + ob->vel_x < 0 ){
        ob->x = 0;
        ob->vel_x = 0;
    }

    if( ob->x + ob->vel_x > (84 - 5) ){
        ob->x = (84 - ob->w);
        ob->vel_x = 0;
    }
    
    ob->x += ob->vel_x;
    ob->y += ob->vel_y;
}

void obj_init(entity_t *ob)
{
    ob->w = 4;
    ob->h = 2;
    ob->vel_y = 0;
    ob->vel_x = 0;
    ob->x = 0;
    ob->y = 0;
}

void putch(uint8_t c)
{
    pcd8544_draw_bytes( 0, 2, &Font5x7[c * 5], 5 );
}

void obj_draw(entity_t *ob)
{
    pcd8544_draw_bytes( ob->x, ob->y, ob->dta, ob->w );
}

void obj_delete(entity_t *ob)
{
    uint8_t data2[] = {0x00, 0x00, 0x00, 0x00, 0x00};

    pcd8544_draw_bytes( ob->x, ob->y, data2, ob->w );
}
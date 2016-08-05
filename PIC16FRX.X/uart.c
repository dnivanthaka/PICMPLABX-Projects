#include <xc.h>
#include <stdio.h>
#include <stdlib.h>

#include "uart.h"

void uart_init()
{
    TRISCbits.TRISC6 = 0;
    TRISCbits.TRISC7 = 1;
    //SPBRG = 0x19;       //9600 baud rate
    //TXEN = 1;
    //BRGH = 1;
    //SPEN = 1;
    //CREN = 1;
    TXREG = 0;
    RCREG = 0;
    SPBRG = 0x40;
    TXSTA = 0x24;
    RCSTA = 0x90;
}

void putchar(char data)
{
    while( !TXIF )
        continue;
    TXREG = data;
}

char getchar()
{
    while( !RCIF )
        continue;
    return RCREG;
}

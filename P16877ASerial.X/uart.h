/* 
 * File:   uart.h
 * Author: dinusha
 *
 * Created on February 20, 2015, 7:07 PM
 */

#ifndef UART_H
#define	UART_H

#ifdef	__cplusplus
extern "C" {
#endif
    
#include <xc.h>
#include <stdio.h>
#include <stdlib.h>


void uart_init();
void putchar(char);
char getchar();


#ifdef	__cplusplus
}
#endif

#endif	/* UART_H */


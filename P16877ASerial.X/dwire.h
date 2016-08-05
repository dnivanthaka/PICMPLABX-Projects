/* 
 * File:   dwire.h
 * Author: dinusha
 *
 * Created on March 5, 2015, 7:40 PM
 */

#ifndef DWIRE_H
#define	DWIRE_H

#ifdef	__cplusplus
extern "C" {
#endif
#include <stdint.h>
#define _XTAL_FREQ 20000000  // 20MHz Clock

void dw_init();
int dw_start(uint8_t pin);
int dw_send_byte(uint8_t pin, uint8_t data);
uint8_t dw_recieve_byte(uint8_t pin);


#ifdef	__cplusplus
}
#endif

#endif	/* DWIRE_H */


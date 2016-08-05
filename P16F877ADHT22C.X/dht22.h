/* 
 * File:   dht22.h
 * Author: dinusha
 *
 * Created on December 25, 2014, 8:06 PM
 */

#ifndef DHT22_H
#define	DHT22_H

#ifdef	__cplusplus
extern "C" {
#endif
#include <stdint.h>
    

#define _XTAL_FREQ 20000000 // 20MHz Clock
    void dht22_init();
    void dht22_start();
    uint8_t dht22_read();

    uint8_t buffer;
#ifdef	__cplusplus
}
#endif

#endif	/* DHT22_H */


/* 
 * File:   1wire.h
 * Author: dinusha
 *
 * Created on February 25, 2015, 10:42 PM
 */

#ifndef ONEWIRE_H
#define	ONEWIRE_H

#ifdef	__cplusplus
extern "C" {
#endif
    #include <xc.h>
    #define _XTAL_FREQ      20000000 // 20MHz Clock

    void ow_init();
    int ow_reset();
    int ow_write_byte(unsigned char data);
    unsigned char ow_read_byte();


#ifdef	__cplusplus
}
#endif

#endif	/* 1WIRE_H */


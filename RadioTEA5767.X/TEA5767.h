/* 
 * File:   TEA5767.h
 * Author: dinusha
 *
 * Created on October 23, 2014, 10:40 PM
 */

#ifndef TEA5767_H
#define	TEA5767_H

#ifdef	__cplusplus
extern "C" {
#endif
    #include <stdint.h>

    #define _XTAL_FREQ 20000000 // 20MHz Clock
    #define DEVICE_ADDR 0x60

    const uint8_t MUTE_ON = 0x80;
    const uint8_t SM_ON   = 0x40;
    const uint8_t SUD_UP  = 0x80;
    const uint8_t STBY    = 1 << 6;

    void tea5767_init();
    unsigned int tea5767_getpll(double freq);
    double tea5767_getfreq(uint8_t byte1, uint8_t byte2);
    void tea5767_write();
    void tea5767_read();
    void tea5767_tune(double freq);
    double tea5767_roundfreq(double freq);
    void tea5767_search();
    void tea5767_tune(double freq);
    void tea5767_search_up();
    void tea5767_search_down();

    uint8_t commandbytes[5];
    uint8_t respbytes[5];

    double current_freq;


#ifdef	__cplusplus
}
#endif

#endif	/* TEA5767_H */


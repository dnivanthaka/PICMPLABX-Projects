/* 
 * File:   ds1307.h
 * Author: dinusha
 *
 * Created on March 1, 2015, 12:29 PM
 */

#ifndef DS1307_H
#define	DS1307_H

#ifdef	__cplusplus
extern "C" {
#endif
#include <stdint.h>

    #define DS1307ADDR  0x68
    #define DS1307NVRAM 0x08

    struct ds1307{
        uint8_t seconds, minutes, hours, day, date, month, cont;
        uint16_t year;
    };
    
    static uint8_t bcd2bin(uint8_t val){
        //return (((val & 0xF0) >> 4) * 10) + (val & 0X0F);
        return val - 6 * (val >> 4);
    }
    static uint8_t bin2bcd(uint8_t val){
        //return ((val / 10) << 4 + (val % 10));
        return val + 6 * (val / 10);
    }
    
    void ds1307_init(uint8_t addr);
    void ds1307_read_data();
    void ds1307_now(struct ds1307 *dev);
    void ds1307_set(struct ds1307 *dev);
    void ds1307_print(struct ds1307 *dev);
    void ds1307_read_nvram(uint8_t offset, uint8_t *buffer, uint8_t num);
    void ds1307_write_nvram(uint8_t offset, uint8_t *buffer, uint8_t num);
    uint8_t ds1307_is_running();

#ifdef	__cplusplus
}
#endif

#endif	/* DS1307_H */


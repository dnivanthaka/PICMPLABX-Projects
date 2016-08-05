/* 
 * File:   I2C.h
 * Author: dinusha
 *
 * Created on October 23, 2014, 10:50 PM
 */

#ifndef I2C_H
#define	I2C_H

#ifdef	__cplusplus
extern "C" {
#endif
    #include <stdint.h>

    #define BAUD            100   // In kbps
    #define FOSC_SPEED	20000// Oscillator clock in Khz
    #define _XTAL_FREQ 20000000 // 20MHz Clock

    void i2c_init();
    void i2c_start();
    void i2c_stop();
    void i2c_send_controlbyte( uint8_t addr, uint8_t rw_bit );
    void i2c_send_data( uint8_t dta );
    uint8_t i2c_read_data();
    void i2c_sendack();
    void i2c_sendnack();


#ifdef	__cplusplus
}
#endif

#endif	/* I2C_H */


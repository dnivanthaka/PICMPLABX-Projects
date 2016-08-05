#include <xc.h>
#include <stdint.h>
#include <math.h>

#include "I2C.h"
#include "TEA5767.h"


void tea5767_init()
{
    __delay_ms(10);

    current_freq = 99.2;
    unsigned int pll = tea5767_getpll(current_freq);

    commandbytes[0] = (pll >> 8);
    commandbytes[1] = pll & 0xFF;
    //commandbytes[2] = 0xB0;
    commandbytes[2] = 0xD0;
    commandbytes[3] = 0x10;
    commandbytes[4] = 0x00;

    tea5767_write();
}

unsigned int tea5767_getpll(double freq)
{
    return (unsigned int)(4 * ( freq * 1000000 + 225000 ) / 32768);
}

double tea5767_getfreq(uint8_t byte1, uint8_t byte2)
{
    return (ceil(ceil(((byte1 & 0x3F) << 8) + byte2) * 32768 / 4 - 225000) / 1000000);
}

void tea5767_tune(double freq)
{
    unsigned int pll = tea5767_getpll( freq );
    current_freq = freq;

    commandbytes[0] = (pll >> 8);
    commandbytes[0] &= ~SM_ON;
    commandbytes[0] &= ~MUTE_ON;
    commandbytes[1] = pll & 0xFF;

    tea5767_write();
}

double tea5767_roundfreq( double freq )
{
   double d = freq * 10;
   d = ceil(d);
   d = d / 10.0;
   return d;
}

void tea5767_search_up()
{
	commandbytes[2] |= SUD_UP;
	tea5767_search();
}

void tea5767_search_down()
{
	commandbytes[2] &= ~SUD_UP;
	tea5767_search();
}

void tea5767_search()
{
    double prev_freq;

    current_freq += 0.1;

    if( current_freq > 108.0 ){
        current_freq = 87.0;
    }

    unsigned int pll = tea5767_getpll( current_freq );

    commandbytes[0] = (pll >> 8);
    commandbytes[0] |= SM_ON;
    commandbytes[0] |= MUTE_ON;
    commandbytes[1] = (pll & 0xFF);

    tea5767_write();

    respbytes[0] = 0x00;

    tea5767_read();
    while( (respbytes[0] & 0x80) == 0 && (respbytes[0] & 0x40) == 0 ){
            tea5767_read();
    }

    prev_freq = current_freq;

    current_freq = tea5767_roundfreq(
            tea5767_getfreq( respbytes[0], respbytes[1] ));

    if( current_freq - prev_freq == 0 ){
            current_freq += 0.1;
    }

    //commandbytes[0] &= ~SM_ON;
    //commandbytes[0] &= ~MUTE_ON;

    tea5767_tune( current_freq );
}

void tea5767_write()
{
    i2c_start();
    i2c_send_controlbyte( DEVICE_ADDR, 0 );

    i2c_send_data( commandbytes[0] );
    i2c_send_data( commandbytes[1] );
    i2c_send_data( commandbytes[2] );
    i2c_send_data( commandbytes[3] );
    i2c_send_data( commandbytes[4] );

    i2c_stop();
}

void tea5767_read()
{
    i2c_start();
    i2c_send_controlbyte( DEVICE_ADDR, 1 );

    respbytes[0] = i2c_read_data();
    i2c_send_ack();
    respbytes[1] = i2c_read_data();
    i2c_send_ack();
    respbytes[2] = i2c_read_data();
    i2c_send_ack();
    respbytes[3] = i2c_read_data();
    i2c_send_ack();
    respbytes[4] = i2c_read_data();
    i2c_send_ack();


    i2c_send_nack();
    i2c_stop();
}



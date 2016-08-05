#include <xc.h>
#include <stdint.h>

#include "I2C.h"

void i2c_init(){
    //I2C SDA and SCL pins as inputs
    TRISCbits.TRISC3 = 1;
    TRISCbits.TRISC4 = 1;

    //Configuring MSSP module as master mode
    SSPCON = 0b00101000;

    //Configuring i2c levels and slew rate as standard
    SSPSTAT = 0b10000000;

    //Configuring the baud rate
    SSPADD = (FOSC_SPEED / (4 * BAUD)) - 1;

    //Wait for stabilization
    __delay_ms(10);
}

void i2c_start()
{
    PIR1bits.SSPIF = 0;
    SSPCON2bits.SEN = 1;
    while( !PIR1bits.SSPIF ); //Wait for SSPIF to go back to high
}

void i2c_stop()
{
    PIR1bits.SSPIF = 0;
    SSPCON2bits.PEN = 1;
    while( !PIR1bits.SSPIF ); //Wait for SSPIF to go back to high
}

void i2c_send_controlbyte( uint8_t addr, uint8_t rw_bit )
{
    PIR1bits.SSPIF = 0;
    SSPBUF = (addr << 1) + rw_bit;
    while( !PIR1bits.SSPIF ); //Wait for SSPIF to go back to high
}

void i2c_send_data( uint8_t dta )
{
    PIR1bits.SSPIF = 0;
    SSPBUF = dta;
    while( !PIR1bits.SSPIF ); //Wait for SSPIF to go back to high
}

uint8_t i2c_read_data()
{
    //uint8_t dta;

    PIR1bits.SSPIF = 0;
    //#asm
    //bcf PIR1, 0
    //#endasm
    //asm("bcf PIR1, SSPIF");
    SSPCON2bits.RCEN = 1;
    while( !PIR1bits.SSPIF ); //Wait for SSPIF to go back to high
    //dta = SSPBUF;
    return SSPBUF;
}


void i2c_send_repstart()
{
    PIR1bits.SSPIF = 0;
    SSPCON2bits.RSEN = 1;
    while( !PIR1bits.SSPIF ); //Wait for SSPIF to go back to high
}

void i2c_send_ack()
{
    PIR1bits.SSPIF = 0;
    SSPCON2bits.ACKDT = 0;
    SSPCON2bits.ACKEN = 1;
    while( !PIR1bits.SSPIF ); //Wait for SSPIF to go back to high
}

void i2c_send_nack()
{
    PIR1bits.SSPIF = 0;
    SSPCON2bits.ACKDT = 1;
    SSPCON2bits.ACKEN = 1;
    while( !PIR1bits.SSPIF ); //Wait for SSPIF to go back to high
}
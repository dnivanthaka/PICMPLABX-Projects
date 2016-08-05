#include <xc.h>
#include <stdint.h>
#include <stdio.h>

#include "i2c.h"

static uint8_t tries;

void i2c_init()
{
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
    tries = 0;
    while( !PIR1bits.SSPIF && tries++ < 25 ){
        __delay_us(1);
    } //Wait for SSPIF to go back to high

    if( tries == 25 ){
        printf("I2C Error: Timeout\r\n");
        return;
    }
}

void i2c_stop()
{
    if( i2c_check_overflow() ){
        printf("I2C Warning: Buffer overflow\r\n");
        i2c_enable();
    }else{
        PIR1bits.SSPIF = 0;
        SSPCON2bits.PEN = 1;
        tries = 0;
        while( !PIR1bits.SSPIF && tries++ < 25 ){
            __delay_us(1);
        } //Wait for SSPIF to go back to high

        if( tries == 25 ){
            printf("I2C Error: Timeout\r\n");
            return;
        }
    }
}

void i2c_send_controlbyte( uint8_t addr, uint8_t rw_bit )
{
    PIR1bits.SSPIF = 0;
    SSPBUF = (addr << 1) | (rw_bit & 1);
    tries = 0;
    while( !PIR1bits.SSPIF && tries++ < 25 ){
        __delay_us(1);
    } //Wait for SSPIF to go back to high
    if( tries == 25 ){
        printf("I2C Error: Timeout\r\n");
        return;
    }
}

void i2c_send_data( uint8_t dta )
{
    PIR1bits.SSPIF = 0;
    SSPBUF = dta;
    tries = 0;
    while( !PIR1bits.SSPIF && tries++ < 25 ){
        __delay_us(1);
    } //Wait for SSPIF to go back to high
    if( tries == 25 ){
        printf("I2C Error: Timeout\r\n");
        return;
    }
}

uint8_t i2c_read_data()
{
    //uint8_t dta;

    PIR1bits.SSPIF = 0;
    SSPCON2bits.RCEN = 1;
    tries = 0;
    while( !PIR1bits.SSPIF && tries++ < 25 ){
        __delay_us(1);
    } //Wait for SSPIF to go back to high
    //dta = SSPBUF;
    if( tries == 25 ){
        printf("I2C Error: Timeout\r\n");
        return 0;
    }
    
    return SSPBUF;
}


void i2c_send_repstart()
{
    PIR1bits.SSPIF = 0;
    SSPCON2bits.RSEN = 1;
    tries = 0;
    while( !PIR1bits.SSPIF && tries++ < 25 ){
        __delay_us(1);
    } //Wait for SSPIF to go back to high
    
    if( tries == 25 ){
        printf("I2C Error: Timeout\r\n");
        return;
    }
}

void i2c_send_ack()
{
    PIR1bits.SSPIF = 0;
    SSPCON2bits.ACKDT = 0;
    SSPCON2bits.ACKEN = 1;
    tries = 0;
    while( !PIR1bits.SSPIF && tries++ < 25 ){
        __delay_us(1);
    } //Wait for SSPIF to go back to high
    if( tries == 25 ){
        printf("I2C Error: Timeout\r\n");
        return;
    }
}

void i2c_send_nack()
{
    PIR1bits.SSPIF = 0;
    SSPCON2bits.ACKDT = 1;
    SSPCON2bits.ACKEN = 1;
    tries = 0;
    while( !PIR1bits.SSPIF && tries++ < 25 ){
        __delay_us(1);
    } //Wait for SSPIF to go back to high
    if( tries == 25 ){
        printf("I2C Error: Timeout\r\n");
        return;
    }
}

uint8_t i2c_read_ack()
{
    return SSPCON2bits.ACKSTAT;
}

uint8_t i2c_check_overflow()
{
    return SSPCONbits.SSPOV;
}

void i2c_enable()
{
    SSPCONbits.SSPEN = 1;
}

uint8_t i2c_bus_busy()
{
    return !(PORTCbits.RC3 && PORTCbits.RC4);
}
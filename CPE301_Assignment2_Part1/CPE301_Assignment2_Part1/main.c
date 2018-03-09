/*
 * CPE301_Assignment2_Part1.c
 *
 * Created: 3/2/2018 10:01:49 AM
 * Author : Monty Sourjah
 */ 



#define F_CPU 16000000

#include <avr/io.h>
#include <util/delay.h>



int main(void)
{
   
	DDRB = 0b00000100;
	PORTB = 0b00000100;
    while (1)
    {
		_delay_ms(250);
		PORTB = 0b00000000;
		_delay_ms(250);
		PORTB = 0b00000100;
    }
}

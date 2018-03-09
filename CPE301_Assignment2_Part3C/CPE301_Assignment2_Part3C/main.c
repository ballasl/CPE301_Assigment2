/*
 * CPE301_Assignment2_Part3C.c
 *
 * Created: 3/5/2018 8:57:36 AM
 * Author : Monty Sourjah
 */ 

#define F_CPU 16000000	// CPU clock
#define const2ms 125

#include <avr/io.h>

void delay(int d)
{
	int i = 0; // counter variable
	TCCR0B = 1; //start TIMER0
	TCNT0 = 0; // set TIMER0 counter to 0
	
	while (i < d * const2ms / 2) // check if time elapsed
	{
		if (TIFR0 && 1) // check if timer0 overflow
		{
			TIFR0 |= 7; // clear overflow bit
			i++; // increment counter
		}
	}
}

int main(void)
{
	/* Replace with your application code */
	DDRB = 0b00000100; // set PORTB2 to output
	while (1)
	{
		delay(250); // delay 250ms
		PORTB = 0b00000100; // Set PORTB2 to 1
		delay(250); // delay 250ms
		PORTB = 0; // Set PORTB2 to 0
	}
}


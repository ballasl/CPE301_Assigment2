/*
 * CPE301_Assignment2_Part2C.c
 *
 * Created: 3/4/2018 10:47:34 AM
 * Author : Monty Sourjah
 */ 


#define F_CPU 16000000	//Clock frequency

#include <avr/io.h>	// io header file
#include <util/delay.h> // delay header file


int main(void)
{
    /* Replace with your application code */
	DDRB = 0b00000100; // set PORTB.2 to output
	PORTD = 0; // Enable pull up resistors on port D
	DDRD = 0b00000000; // Set port D to all inputs 
    while (1) 
    {
		if (PIND >> 2) // if PIND2 is 1
		{
			PORTB = 0b00000100; // SET PORTB2 to 1
			_delay_ms(1000); // wait 1s
			PORTB = 0; // Set PORTB2 to 0
		}
    }
}


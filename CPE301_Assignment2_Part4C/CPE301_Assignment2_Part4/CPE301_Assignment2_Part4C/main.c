/*
 * CPE301_Assignment2_Part4C.c
 *
 * Created: 3/6/2018 8:32:39 PM
 * Author : Monty Sourjah
 */ 

#define F_CPU 16000000 // clock frequency
#define const2ms 125 // constant 2 ms


#include <avr/io.h>
#include <avr/interrupt.h>

volatile int counter; // volatile global variable

ISR(TIMER0_OVF_vect) // interrupt function
{
	counter--; // decrement the counter
}

void delay(int d) // makes a delay of d ms
{
	int i = 0; // internal counter
	TCNT0 = 0; // set timer0 counter to 0
	TCCR0B = 1; // start timer 0
	while (i < d * const2ms / 2) // check if time elapsed
	{
		if (counter == 0) // check if counter is 0
		{
			counter = 1; // set counter to 1
			i++; // increment internal counter
		}
	}
	TCCR0B = 0; // stop timer0
}


int main(void)
{
	/* Replace with your application code */
	DDRB = 0b00000100; // set PORTB2 to output
	TIMSK0 = (1 << TOIE0); // enable timer 0 interrupt
	counter = 1; // set counter to 1
	sei(); // enable interrupts
	while (1)
	{
		PORTB = 0b00000100; // set PORTB2 to 1
		delay(250); // wait 250ms
		PORTB = 0; // set PORTB2 to 0
		delay(250); // wait 250ms
	}
}


/*
 * CPE301_Assignment2_Par5C.c
 *
 * Created: 3/9/2018 8:32:09 AM
 * Author : Monty Sourjah
 */ 

#include <avr/io.h>

#define F_CPU 16000000 // clock frequency
#define const2ms 125 // constant 2 ms


#include <avr/io.h>
#include <avr/interrupt.h>

volatile int counter; // volatile global variable
volatile int button; // volatile global variable

ISR(TIMER0_OVF_vect) // interrupt function
{
	counter--; // decrement the counter
}

ISR(INT0_vect)
{
	button = 1; // set button to 1
}

void delay(int d) // makes a delay of d ms
{
	unsigned int i = 0; // internal counter
	unsigned int j = d * const2ms / 2;
	TCNT0 = 0; // set timer0 counter to 0
	TCCR0B = 1; // start timer 0
	while (i < j) // check if time elapsed
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
	PORTD = 0b00000100; // Enable pull up on PORTD2
	PIND = 0; // SET all PINS on PORTD to input
	TIMSK0 = (1 << TOIE0); // enable timer 0 interrupt
	EICRA |= 3; // set rising edge
	EIMSK |= 1; // enable INT0 interrupt
	counter = 1; // set counter to 1
	button = 0; // set button to 0
	sei(); // enable interrupts
	while (1)
	{
		while (button == 0);
		button = 0; // set button to 0
		PORTB = 0b00000100; // set PORTB2 to 1
		delay(1000); // wait 1s
		PORTB = 0; // set PORTB2 to 0
	}
}



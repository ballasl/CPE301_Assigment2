;
; Simulation_Assignment2_Part3.asm
;Implement Task 1 using Timer 0. Count OVF occurrence if needed. Do not use interrupts.
; Created: 3/5/2018 8:42:26 AM
; Author : Monty Sourjah
;

start:
    ldi r20, 0b00000100 ; load to r20 the mask to set pin 2 as output
	out DDRB, r20 ; Set PIN 2 on port B to output and all others to input
loop:
	ldi r20, 0b00000100 ; load to r20 the mask to set pin 2 to 1
	out PORTB, r20 ; Set pin 2 to 1 on port B
	call delay ; wait for 250ms
	ldi r20, 0b00000000 ; load to r20 the mask to set pin 2 to 0
	out PORTB, r20 ; Set pin 2 to 0 on port B
	call delay ; wait for 250ms
    rjmp loop ; repeat the loop

delay:
; By default on Xplained mini is extenal clock
; On 5V it is at 16MHz
; On 3.3V it is 8MHz
; We have to do a 250ms delay
; On 16MHz 1 clock is 1/16MHz = 62.5ns
; It takes 16 clocks for 1us, a 8 bit counter counts 256 times for overflow, so there will be overflow on 256 / 16 = 16 us.
; To get 250ms, we need 250000 / 16 = 15625 overflows                                
; We can do 15625 as 125 * 125 overflows
; There will be some inaccurancy due to setting of the values.
	ldi r18, 0b00000001 ; load 1 to r18 
	out TCCR0B, r18 ; start timer 0
	ldi r16, 125 ; load 125 to r16
cycle1: ; 125 * 125 * 16us loop = 250ms
	ldi r17, 125 ; load 250 to r17 - 1 clock
cycle2: ; 125 * 16us loop = 2ms
	in r18, TIFR0 ; load TIFR0 register int r18
	sbrs r18, TOV0 ; Check TOV0 bit (timer 0 overflow occured), skip next line if set
	jmp cycle2;
	ldi r18, 1 ; load 1 into r18
	out TIFR0, r18; clear TOV0 flag
	dec r17 ; decrement r17
	brne cycle2 ; branch if r17 not 0
; it will execute 125 times, so it will spend 125 * 16us = 2ms
	dec r16 ;  decrement r16
	brne cycle1 ; branch if r16 not 0
; it will execute 125 times, so it will spend 125 * 2ms = 250ms
	ldi r18, 0b00000000 ; load 250 to r18 - 1 clock 
	out TCCR0B, r18 ; stop TIMER0
	ret ; return

;
; Simulation_CPE301_Assignment2_Part2.asm
; Author: Monty Sourjah
; Created: 3/4/2018 7:20:33 AM
start:
    ldi r20, 0b00000100 ; load to r20 the mask to set pin 2 as output
	out DDRB, r20 ; Set PIN 2 on port B to output and all others to input
	out PORTD, r20 ; Enable pull up resistors on port D
	ldi r20, 0b00000000 ; load to r20 the mask to set pin 2 as input
	out DDRD, r20 ; Set port D pins to input
loop:
	; debouncing is not considered
	in r20, PIND ; load port d pins to r20
	andi r20, 0b00000100 ; clear all bits in r20 except pin 2
	breq loop ; repeat the loop
	out PORTB, r20 ; Set pin 2 to 1 on port B
	call delay ; wait for 250ms
	call delay ; wait for 250ms
	call delay ; wait for 250ms
	call delay ; wait for 250ms
	ldi r20, 0b00000000 ; load to r20 the mask to set pin 2 to 0
	out PORTB, r20 ; Set pin 2 to 0 on port B
    rjmp loop ; repeat the loop

delay:
; By default on Xplained mini is extenal clock
; On 5V it is at 16MHz
; On 3.3V it is 8MHz
; We have to do a 250ms delay
; On 16MHz 1 clock is 1/16MHz = 62.5ns
; It takes 16 clocks for 1us, if there is a loop which will take 16 clocks (1us) executed 250 times it is 250us.
; Doing this a 250 times, it will elapse 62.5ms
; And doing this 4 times, we will have our 250ms of delay
; There will be some inaccurancy due to setting the values after end of loops.

	ldi r16, 4 ; load 4 to r16 - 1 clock
cycle1: ; 4 * 250 * 250us loop = 250ms
	ldi r17, 250 ; load 250 to r17 - 1 clock
cycle2: ; 250 * 250us loop = 62.5ms
	ldi r18, 250 ; load 250 to r18 - 1 clock 
cycle3: ; 250us loop
	dec r18 ; decement r18 - 1clock
	nop ; no operation, just spend a clock cycle - 1clock
	nop ; 1clock
	nop ; 1clock
	nop ; 1clock
	nop ; 1clock
	nop ; 1clock
	nop ; 1clock
	nop ; 1clock
	nop ; 1clock
	nop ; 1clock
	nop ; 1clock
	nop ; 1clock
	nop ; 1clock
	brne cycle3 ; branch if r18 not 0 - 2 clocks, 1 if no branching
; in total 16 clocks or 1 us
; it will execute 250 times, so it will spend 250us
	dec r17 ; decrement r17 - 1 clock
	brne cycle2 ; branch if r17 not 0 - 2 clocks, 1 if no branching
; it will execute 250 times, so it will spend 250 * 250us = 62.5ms
	dec r16 ;  decrement r16 - 1 clock
	brne cycle1 ; branch if r16 not 0 - 2 clocks, 1 if no branching
; it will execute 4 times, so it will spend 4 * 62.5ms = 250ms
	ret ; return 

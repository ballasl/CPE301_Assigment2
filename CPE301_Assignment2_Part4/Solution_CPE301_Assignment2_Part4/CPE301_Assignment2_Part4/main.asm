;
; CPE301_Assignment2_Part4.asm
;
; Created: 3/6/2018 3:35:27 PM
; Author : Monty Sourjah
;
.INCLUDE "M328pDEF.INC"
.org 0x000      ; memory location of reset handler
	rjmp start
.org 0x020      ;memory location of Timer0 overflow handler
	rjmp timer0_ovf  ; go here if a timer0 overflow interrupt occurs 
	
timer0_ovf:
	dec r17  ;decrease r17
	reti     ;releaseses the interupt

start:
    ldi r20, 0b00000100 ; load to r20 the mask to set pin 2 as output
	out DDRB, r20 ; Set PIN 2 on port B to output and all others to input
	ldi r20, 1 << TOIE0  ; bit "TOIE0" shifted to the left
	sts TIMSK0, r20  ;Store r20 Direct to data space, interupt mask register
	sei   ;enable global interrupts
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
	ldi r18, 0
	out TCNT0, r18 ;initialize the Timer/Counter to 0
	ldi r16, 125 ; load 125 to r16
cycle1: ; 125 * 125 * 16us loop = 250ms
	ldi r17, 126 ; load 126 to r17 - 1 clock
	dec r17 ; to set the flags
cycle2: ; 125 * 16us loop = 2ms
	brne cycle2 ; branch if r17 not 0
; it will execute 125 times, so it will spend 125 * 16us = 2ms
	dec r16 ;  decrement r16
	brne cycle1 ; branch if r16 not 0
; it will execute 125 times, so it will spend 125 * 2ms = 250ms
	ldi r18, 0b00000000 ; load 250 to r18 - 1 clock 
	out TCCR0B, r18 ; stop TIMER0
	ret ; return 
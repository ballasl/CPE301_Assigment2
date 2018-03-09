;
; CPE301_Assignment2_Part5.asm
;
; Created: 3/6/2018 9:55:15 PM
; Author : Monty Sourjah
;Implement Task 2 using INT0 interrupt mechanism.


.org 0x0000         ;Reset
	rjmp start       
.org 0x0002          ;external interrupt request0 pin D2
	rjmp int0_int    ;
.org 0x0020
	rjmp timer0_ovf  ;timer/counter0 overflow

int0_int:
	dec r19
	reti

timer0_ovf:
	dec r17
	reti


start:
    ldi r20, 0b00000100 ; load to r20 the mask to set pin 2 as output
	out DDRB, r20 ; Set PIN 2 on port B to output and all others to input
	out PORTD, r20 ; Enable pull up resistors on port D
	ldi r20, 0b00000000 ; load to r20 the mask to set pin 2 as input
	out DDRD, r20 ; Set port D pins to input
	ldi r20, 3
	sts EICRA, r20 ; rising edge
	ldi r20, 1 << INT0 ;enable external interrupt 0
	out EIMSK, r20 ; enable INT0
	ldi r20, 1 << TOIE0
	sts TIMSK0, r20 ; enable TIMER0 oveflow
	sei        ;Global Interrupt Enable
preloop:
	ldi r19, 1 ; 1 not pressed
loop:
	; debouncing is not considered
	cpi r19, 0 ; compare with 0;
    brne loop ; repeat the loop
	ldi r20, 0b00000100
	out PORTB, r20 ; Set pin 2 to 1 on port B	
	call delay ; wait for 250ms
	call delay ; wait for 250ms
	call delay ; wait for 250ms
	call delay ; wait for 250ms
	ldi r20, 0b00000000 ; load to r20 the mask to set pin 2 to 0
	out PORTB, r20 ; Set pin 2 to 0 on port B
	rjmp preloop

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
	out TCNT0, r18
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
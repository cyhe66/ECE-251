;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Casey He/ Prof. Stuart Kirtman       	;
; PIC Assembly 8-bit Counter			;
; 23/04/17								;
;										;
; Implement demo program on PIC16F877A  ;
; and modify the program by adding two 	;
; inputs applied via DIP switches. 		;
; One switch should start/stop the 		;
; counter, and the other switch should 	;
; cause the counter to advance by either;
; one or two (depending on the switch 	;
; position								;
;										;
;										;
; implemeent the delay in a subroutine	;
; subroutine should provide a delay 	;
; equal to the number contained in the W;
; register when the subroutine is called;
;										;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




	LIST	P=PIC16F877A
	include <p16F877A.inc>

	__CONFIG _HS_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF & _LVP_OFF

	

COUNT	EQU	0x20	; General purpose registers used for variables
VAR_I	EQU	0x21
VAR_J 	EQU	0x22
VAR_K	EQU	0x23

	ORG 0x00
	goto	start

	ORG 0x10
start
	bsf	STATUS, RP0	; switch to Bank 1
	movlw	0x10	; Set the PortC pins
	movwf	TRISC	; bit 2-7 to output, bit 0 & 1 to input 
	bcf	STATUS, RP0	; switch back to Bank 0


	clrf	COUNT	; Set COUNT to 0



L1	movf	COUNT, W	; Get value of COUNT
	movwf	PORTC		; and write it to PORTC
	
	
	BTFSS	PORTC, 0			;Get value of PortA, BIT 0
		BTFSC	PORTC, 1;
			incf	COUNT, F	; Add extra one to COUNT
								; do not increment if BIT 0 input is zero.
		incf	COUNT, F		; Add one to COUNT
	call	DELAY;
	goto	L1					; Repeat

;**** Check if the switch is closed
		


;clock speed is 4MHz provided by crystal oscillator
;each instruction line takes 1/1000th of a millisecond
;1000 instruction lines takes up a millisecond
DELAY
	movwf VAR_I	; takes the number in the W register and sets is at VAR_I	
	movlw .4
	movwf VAR_K	
Loop
	movlw .110
	movwf VAR_J

Loop1
	decfsz VAR_J, F
		goto Loop1  
	decfsz VAR_K, F
		goto Loop  
	nop					; 996th instruction
	nop	
	decfsz VAR_I, F		; subtract 1 from # in W register
		goto Loop		; 1000th instruction line
return					; 1000th instruction line when VAR_I is zero


 

END
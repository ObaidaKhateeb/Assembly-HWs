    ; 201278066, 30%
; 206538464, 70%
.ORIG X412C
CheckPrime:	
	;storing the values of the registers 
	ST R0 SAVE_R0 ;holding the number that have to be checked if prime
	ST R1 SAVE_R1 ;holding the number we're going to divide R0 by each time 
	ST R3 SAVE_R3 ;used in order to get the remainder from the DIV subroutine.
	ST R4 SAVE_R4
	ST R5 SAVE_R5
	ST R6 SAVE_R6 ;will hold the address of DIV subroutine so we cn call it
	ST R7 SAVE_R7

	LD R6, DIV_PTR ;holds the index of DIV subroutine 
Z_O:
	; checking the special cases - if the number is 0 or 1, if it's negative so it's not prime 
	ADD R0 R0 #-2 
	BRN NOT_PRIME 
	ADD R0 R0 #2 ; adding back the 2
	LD R1 TWO
	JSRR R6 ; dividing the number by two so we get the half of the number in R2, we will start checks if the number in R0 is divided by the numbers between 2 and 0.5*R1
	ADD R1 R2 #1 ; loading the result of the subroutine DIV to R1
LOOP:
	ADD R1 R1 #-2 ; checking if R1 = 0,1, so we stop and declare the R0 number as prime 
	BRNZ PRIME
	ADD R1 R1 #1 ; after adding 1 to R1, following decreasing 2 before, we have decreased it by 1 in total
	JSRR R6 ; dividing R0 by R1 
	ADD R3 R3 #0 
	BRZ NOT_PRIME ;if the remainder is zero the number is not prime, otherwise to check with R1-1
	BR LOOP
NOT_PRIME:
	LD R2 ZERO ; loading the not prime output to R2.
	BR END
PRIME:
	LD R2 ONE ; loading the prime output to R2.
	BR END
END:
	;loading the values of the registers 
	LD R0 SAVE_R0
	LD R1 SAVE_R1
	LD R3 SAVE_R3
	LD R4 SAVE_R1
	LD R5 SAVE_R1
	LD R6 SAVE_R6
	LD R7 SAVE_R7
RET
	SAVE_R0 .FILL #0
	SAVE_R1 .FILL #0
	SAVE_R3 .FILL #0
	SAVE_R4 .FILL #0
	SAVE_R5 .FILL #0
	SAVE_R6 .FILL #0
	SAVE_R7 .FILL #0
	DIV_PTR .FILL X4064
	ZERO .FILL #0 ; The value 0.
	ONE .FILL #1 ; The value 1.
	TWO .FILL #2 ; The value 2.
.END

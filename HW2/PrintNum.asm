    ; 201278066, 50%
; 206538464, 50%
.orig x4320
PrintNum:
	;storing the values of the registers
	ST R0 SAVE_R0 ; ASCII of the number zero
	ST R1 SAVE_R1 ; The address of the first cell of the array
	ST R2 SAVE_R2 ; The complete number of the division
	ST R3 SAVE_R3 ; To divide by R3 using DIV subroutine, and after that the will hold the negative value of the array address to compare it with digits number
	ST R4 SAVE_R4 ; DIV POINTER, and after that will be used to update the CC
	ST R5 SAVE_R5 ; The division remainder
	ST R6 SAVE_R6 ;
	ST R7 SAVE_R7
	
	LEA R1 ARRAY ; Loading to R1 the array address
	LD R4 DIV_PTR ; DIV subroutine pointer
	AND R2 R2 #0
	ADD R2 R0 #0 ; putting the input in R2 to send it to DIV subroutine
	LD R0 TO_ASCII ; R0 = 48
	
SIGN_CHECK:
	LD R3 SIGN ; R3 = 2^15
	AND R3 R2 R3 ; Checking if the most significant bit value
	BRZ CONTINUE ; When the most significant bit value is 0 we will not print the sign

; The most significant bit value is 1
NEG:
	LD R0 MINUS_SIGN ; R0 = ASCII of "-"
	OUT ; Printing the sign "-"
	LD R0 TO_ASCII ; Loading the 48 (the ASCII of the number 0) back

CONTINUE:
	LD R3 TEN ; Loading the value 10 to divide.

; Dividing by 10 and fill the array with their ASCII codes.
STORE_DIGITS:
	JSRR R4 ; Dividing R2 by R3 (R3 = 10)
	ADD R5 R5 R0 ; Converting to ASCII
	STR R5 R1 #0 ; Storing the digit to the array cells
	AND R2 R2 #0 ; R2 = 0
	ADD R2 R6 #0 ; R2 = R6 (R2/R3)
	BRZ PRINT ; If R6 = 0 (the complete value) go to PRINT
	ADD R1 R1 #1 ; Digits number ++
	BR STORE_DIGITS

PRINT:	LEA R3 ARRAY ; R3 = the array address
	NOT R3 R3
	ADD R3 R3 #1 ; 2's complement => R3 = -(array address)
PRINT_LOOP:
	ADD R4 R1 R3 ; Cheking if R1 (num of digits) < (array address)
	BRN END
	LDR R0 R1 #0 ; R0 = mem[R1] to print the value
	OUT ; Printing the value of R0 = mem[R1]
	ADD R1 R1 #-1 ; R1 --
	BR PRINT_LOOP
	
END: 
	;loading the values of the registers
	LD R0 SAVE_R0 
	LD R1 SAVE_R1
	LD R2 SAVE_R2 
	LD R3 SAVE_R3
	LD R4 SAVE_R4
	LD R5 SAVE_R5
	LD R6 SAVE_R6
	LD R7 SAVE_R7	
RET
	SAVE_R0 .FILL #0 
	SAVE_R1 .FILL #0
	SAVE_R2 .FILL #0 
	SAVE_R3 .FILL #0 
	SAVE_R4 .FILL #0 
	SAVE_R5 .FILL #0 
	SAVE_R6 .FILL #0
	SAVE_R7 .FILL #0
	ARRAY .BLKW #5 #0 ; Array with size of 5 and every cell initialized to 0
	SIGN .FILL 32768 ; 2^15 => |1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0| in binary
	MINUS_SIGN .FILL #45 ; the sign "-"
	TEN .FILL #10 ; To divide by ten to find every digits
	TO_ASCII .FILL #48
	DIV_PTR .FILL X4064
.END

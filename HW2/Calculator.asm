    ; 201278066, 50%
; 206538464, 50%
.ORIG x4384
Calculator: 
	;Storing the values of the registers we're not supposed to change 
	ST R0 SAVE_R0
	ST R1 SAVE_R1
	ST R2 SAVE_R2 ;will hold the number in R0 
	ST R3 SAVE_R3 ;will hold the number in R1, because DIV,MUL, and EXP subroutines accepts R2 and R3 as a variables 
	ST R4 SAVE_R4 ;will hold the operation
	ST R5 SAVE_R5 ;will hold the equal operation 
	ST R6 SAVE_R6 ;will hold the result 
	ST R7 SAVE_R7
	ADD R2 R0 #0 ;moving the value of R0 to R2
	ADD R3 R1 #0 ;moving the value of R1 to R3
	LEA R0, Operation_Message
	PUTS ;printing a message asking the client to enter an arithmetic operation 
	GETC 
	OUT
	ADD R4 R0 #0 ;saving the operation inserted in R4 
	LD R6 MinusFourtyTwo 
	ADD R0 R0 R6 
	BRz MUL ;checking if the operation which inserted is '*', if yes move to the appropiate label
	ADD R0 R0 #-1 
	BRz PLUS ;checking if the operation which inserted is '+', if yes move to the appropiate label
	ADD R0 R0 #-2
	BRz MINUS ;checking if the operation which inserted is '-', if yes move to the appropiate label
	ADD R0 R0 #-2
	BRz DIV ;checking if the operation which inserted is '/', if yes move to the appropiate label
	LD R6 MinusFourtySeven
	ADD R0 R0 R6 ;checking if the operation which inserted is '^', if yes move to the appropiate label
	BRz EXP
MUL: 
	LD R1 MUL_PTR ;loading the address of MUL subroutine to R1
	JSRR R1 ;moving to MUL subroutine
	BR PRINT ;moving to print the operation and the result
PLUS:
	ADD R6 R2 R3 ;R6 = R2+R3
	BR PRINT ;moving to print the operation and the result
MINUS: 
	NOT R3 R3
	ADD R3 R3 #1 ;flipping R3 to be negative so we can add it to R2
	ADD R6 R2 R3 ;R6 = R2-R3
	ADD R3 R1 #0 ;restore the value of it before inverse 
	BR PRINT ;moving to print the operation and the result
DIV:
	LD R1 DIV_PTR ;loading the address of DIV subroutine to R1
	JSRR R1 ;moving to DIV subroutine
	BR PRINT ;moving to print the operation and the result
EXP:
	LD R1 EXP_PTR ;loading the address of EXP subroutine to R1
	JSRR R1 ;moving to EXP subroutine
PRINT: 
	LD R5 EQUAL ;loading the ASCII code of '=' to R5
	LD R1 PrintNum_PTR ;loading the PrintNum subroutine address to R1
	AND R0 R0 #0
	ADD R0 R0 #10
	OUT ;printing a new line
	ADD R0 R2 #0
	JSRR R1 ;printing the first number
	ADD R0 R4 #0
	OUT ;printing the operation
	ADD R0 R3 #0 
	JSRR R1 ;printing the second number
	ADD R0 R5 #0 
	OUT ;printing '='
	ADD R0 R6 #0 
	JSRR R1 ;printing the result
	;loading the values that has been in the register before launching the subroutine 
	LD R0 SAVE_R0
	LD R1 SAVE_R1
	LD R2 SAVE_R2
	LD R3 SAVE_R3
	LD R4 SAVE_R4
	LD R5 SAVE_R5
	LD R6 SAVE_R6
	LD R7 SAVE_R7
RET
	MUL_PTR .fill x4000 ; MUL subroutine's address
	DIV_PTR .fill x4064 ; DIV subroutine's address
	EXP_PTR .fill x40C8 ; EXP subroutine's address
	PrintNum_PTR .fill x4320 ; PrintNum subroutine's address
	Operation_Message .stringz "Enter an arithmetic operation: "
	MinusFourtyTwo .FILL #-42 
	MinusFourtySeven .FILL #-47
	EQUAL .FILL #61 
	SAVE_R0 .FILL #0
	SAVE_R1 .FILL #0
	SAVE_R2 .FILL #0
	SAVE_R3 .FILL #0
	SAVE_R4 .FILL #0
	SAVE_R5 .FILL #0
	SAVE_R6 .FILL #0
	SAVE_R7 .FILL #0
.END

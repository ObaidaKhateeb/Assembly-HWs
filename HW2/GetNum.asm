    ; 201278066, 50%
; 206538464, 50%
.orig x41F4
GetNum:
	;Storing the values of the registers we're not supposed to change 
	ST R0 SAVE_R0
	ST R1 SAVE_R1 ;will hold the Mul subroutine address
	ST R3 SAVE_R3 ;will hold the number 10, which we will multiply the current result by it each time we get a new inserted digit
	ST R4 SAVE_R4
	ST R5 SAVE_R5
	ST R6 SAVE_R6 ;will load to it large numbers saved in the fills each time 
	ST R7 SAVE_R7
	LD R1 MUL_PTR ; Loading MUL subroutine address to R1
	AND R3 R3 #0 
	ADD R3 R3 #10 ;initializing R3 to be 10 so each time we insert new digit we multiply R2 by R3 (by 10) before
	LEA R0, Enter_Number_Message ;a message asking for entering a number will be displayed
	PUTS
FIRST_INSERT:
	AND R2 R2 #0 ;initializing R2 to be 0 
	GETC 
	OUT 
	ADD R0 R0 #-10
	BRZ NOT_DIGIT_FINISH ;checking if New Line has been entered, if yes to display a message accordingly
	ADD R0 R0 #10 ;re-adding the 10 that has been reduced before  
	LD R6 MinusFourtyFive
	ADD R0 R0 R6 ;checking if the sign '-' has been entered, if yes, to deal with the number as negative number 
	BRz NegativeNumber
	LD R6 FourtyFive 
	ADD R0 R0 R6 ;re-adding the 45 if we discovered that the first insert is not '-' 
	BR PositiveNumber ;if it's not a negative number we deal with it as a positive one 
NegativeNumber: 
	GETC ;entering the next digit
	OUT ;printing the entered digit 
	ADD R0 R0 #-10 ;checking if New Line has been entered, if yes we finish the program
	BRz FINISH
	;next lines checks if the digit was inserted is a number 
	LD R6 MinusFourtyEight 
	ADD R0 R0 R6
	BRp NOT_DIGIT
	ADD R0 R0 #10
	BRn NOT_DIGIT
	NOT R0 R0  
	ADD R0 R0 #1 ;flipping the number to be negative 
	JSRR R1 ;Moving to Mul subroutine so it multiply the current result (R2) by 10 before adding the new inserted digit 
	ADD R2 R6 #0 ;since Mul return the result in R6, we move it to R2 
	ADD R2 R2 R0 ;adding the new inserted digit to the result
	BRp OVERFLOW ;if result became positive so there's an overflow
	BR NegativeNumber ;re-doing the loop again 
PositiveNumber: 
	ADD R0 R0 #-10 ;checking if New Line has been entered, if yes we finish the program
	BRz FINISH
	;next lines checks if the digit was inserted is a number 
	LD R6 MinusFourtyEight 
	ADD R0 R0 R6
	BRp NOT_DIGIT
	ADD R0 R0 #10
	BRn NOT_DIGIT
	JSRR R1 ;Moving to Mul subroutine so it multiply the current result (R2) by 10 before adding the new inserted digit
	ADD R2 R6 #0 ;since Mul return the result in R6, we move it to R2
	ADD R2 R2 R0 ;adding the new inserted digit to the result
	BRn OVERFLOW ;if result became negative so there's an overflow
	GETC ;entering the next digit
	OUT ;printing the entered digit
	BR PositiveNumber ;re-doing the loop again 
OVERFLOW:
	GETC
	OUT ;it will keep getting and printing new digits until the client insert an enter
	ADD R0 R0 #-10
	BRz OVERFLOW_FINISH ;if Enter had been inserted display an overflow message
	;next lines check if non-digit has been entered so we move to non-digit message which has priority over overflow message in case we face both 
	LD R6 MinusFourtyEight 
	ADD R0 R0 R6
	BRp NOT_DIGIT
	ADD R0 R0 #10
	BRn NOT_DIGIT
	BR OVERFLOW ;re-doing the loop again
OVERFLOW_FINISH:
	LEA R0, OverFlow_Message
	PUTS ;prints an appropriate overflow message 
	BR FIRST_INSERT ;moving to the start of the program 
NOT_DIGIT: 
	GETC
	OUT ;it will keep getting and printing new digits until the client insert an enter
	ADD R0 R0 #-10
	BRz NOT_DIGIT_FINISH ;if Enter had been inserted display a Non-digit message
	BR NOT_DIGIT ;re-doing the loop again
NOT_DIGIT_FINISH:
	LEA R0, Not_Digit_Message
	PUTS ;prints an appropriate Not-Digit message 
	BR FIRST_INSERT ;moving to the start of the program 
FINISH: 
	;loading the values that has been in the register before launching the subroutine
	LD R0 SAVE_R0
	LD R1 SAVE_R1
	LD R3 SAVE_R3
	LD R4 SAVE_R4
	LD R5 SAVE_R5
	LD R6 SAVE_R6
	LD R7 SAVE_R7
RET
	MUL_PTR .fill x4000 ; MUL subroutine's address
	Enter_Number_Message .stringz "Enter an integer number: "
	OverFlow_Message .stringz "Error! Number overflowed! Please enter again: "
	Not_Digit_Message .stringz "Error! You did not enter a number. Please enter again: "
	MinusFourtyFive .FILL #-45
	MinusFourtyEight .FILL #-48
	FourtyFive .FILL #45
	SAVE_R0 .FILL #0
	SAVE_R1 .FILL #0
	SAVE_R3 .FILL #0
	SAVE_R4 .FILL #0
	SAVE_R5 .FILL #0
	SAVE_R6 .FILL #0
	SAVE_R7 .FILL #0
.End 
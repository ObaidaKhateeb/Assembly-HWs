    ; 201278066, 50%
; 206538464, 50%
.ORIG X4000
MUL: 
	;storing the values of the registers
	ST R7 SAVE_R7 
	ST R0 SAVE_R0 ;holding first variable value
	ST R1 SAVE_R1 ;holding the second variable value, used here as a counter of how much time the R0 will be added to R2
	ST R3 SAVE_R3
	ST R4 SAVE_R4 
	ST R5 SAVE_R5
	ST R6 SAVE_R6

	AND R2 R2 #0 ;initializing R2 to be 0
	ADD R0 R0 #0 ;checking if R0 equals to zero
	BRz END
	ADD R1 R1 #0 ;checking if R1 equals to zero
	BRz END
	BRn SWICHSIGNS ;since R1 is used as a counter, it have to be positive. so if its value is negative switch the signs of both registers, that will not change the result value or sign.
MULTIPLY: 
	ADD R2 R2 R0 ;each time we one copy of R2 will be added to R2, R1 copies in total. 
	ADD R1 R1 #-1 ;decrease counter by 1
	BRp MULTIPLY ;if counter still not zero, perform the loop again
	BR END ;if counter equals to zero end the program
SWICHSIGNS: 
	;switching sign of R1 
	NOT R1 R1 
	ADD R1 R1 #1   
  	;switching sign of R0
	NOT R0 R0
	ADD R0 R0 #1
	BR MULTIPLY
END: 
	;loading the values of the registers
	LD R0 SAVE_R0 
	LD R1 SAVE_R1 
	LD R3 SAVE_R3
	LD R4 SAVE_R4 
	LD R5 SAVE_R5
	LD R6 SAVE_R6
	LD R7 SAVE_R7 
RET 
	SAVE_R0 .fill #0 
	SAVE_R1 .fill #0 
	SAVE_R3 .fill #0 
	SAVE_R4 .fill #0 
	SAVE_R5 .fill #0 
	SAVE_R6 .fill #0
	SAVE_R7 .fill #0 
.END

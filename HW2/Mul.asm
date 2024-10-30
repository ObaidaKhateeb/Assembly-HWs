    ; 201278066, 50%
; 206538464, 50%
.ORIG X4000
MUL: 
	;storing the values of the registers
	ST R7 SAVE_R7 
	ST R0 SAVE_R0 
	ST R1 SAVE_R1 
	ST R2 SAVE_R2 ;holding first variable value
	ST R3 SAVE_R3 ;holding the second variable value, used here as a counter of how much time the R2 will be added to R6
	ST R4 SAVE_R4 
	ST R5 SAVE_R5

	AND R6 R6 #0 ;initializing R6 to be 0
	ADD R2 R2 #0 ;checking if R2 equals to zero
	BRz END
	ADD R3 R3 #0 ;checking if R3 equals to zero
	BRz END
	BRn SWICHSIGNS ;since R3 is used as a counter, it have to be positive. so if its value is negative switch the signs of both registers, that will not change the result value or sign.
MULTIPLY: 
	ADD R6 R6 R2 ;each time we one copy of R6 will be added to R6, R3 copies in total. 
	ADD R3 R3 #-1 ;decrease counter by 1
	BRp MULTIPLY ;if counter still not zero, perform the loop again
	BR END ;if counter equals to zero end the program
SWICHSIGNS: 
	;switching sign of R3
	NOT R3 R3 
	ADD R3 R3 #1   
  	;switching sign of R2
	NOT R2 R2
	ADD R2 R2 #1
	BR MULTIPLY
END: 
	;loading the values of the registers
	LD R0 SAVE_R0 
	LD R1 SAVE_R1 
	LD R2 SAVE_R2
	LD R3 SAVE_R3
	LD R4 SAVE_R4 
	LD R5 SAVE_R5
	LD R7 SAVE_R7 
RET 
	SAVE_R0 .fill #0 
	SAVE_R1 .fill #0 
	SAVE_R2 .fill #0
	SAVE_R3 .fill #0 
	SAVE_R4 .fill #0 
	SAVE_R5 .fill #0 
	SAVE_R7 .fill #0 
.END

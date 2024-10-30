    ; 201278066, 70%
; 206538464, 30%
.ORIG X4190
TriangleInequality:
	; Storing registers values.
	ST R0 SAVE_R0 ;holding the first number
	ST R1 SAVE_R1 ;holding the second number
	ST R2 SAVE_R2 ;holding the third number
	ST R4 SAVE_R4 ;stores the sum of two registers each time
	ST R5 SAVE_R5 ;flipping the value of the third register into it 
	ST R6 SAVE_R6 ;comparing the sum of two registers values with the value of the third register
	ST R7 SAVE_R7
	
	AND R3 R3 #0 ; initializing R3 to be zero

	; checking if any of the registers holding a negative number
	ADD R0 R0 #0 
	BRn NEGATIVE_ERROR
	ADD R1 R1 #0 
	BRn NEGATIVE_ERROR
	ADD R2 R2 #0 
	BRn NEGATIVE_ERROR

	;checking if R0+R1>=R2 
	ADD R4 R0 R1 
	NOT R5 R2 
	ADD R5 R5 #1 
	ADD R6 R4 R5 
	BRn END 

	;checking if R0+R2>=R1
	ADD R4 R0 R2 
	NOT R5 R1 
	ADD R5 R5 #1 
	ADD R6 R4 R5 
	BRn END

	;checking if R1+R2>=R0
	ADD R4 R1 R2 
	NOT R5 R0
	ADD R5 R5 #1 
	ADD R6 R4 R5 
	BRn END 

	ADD R3 R3 #1 ;In case all the conditions of Triangle Inequality are met, the R3 is updated to be 1
	BR END 
NEGATIVE_ERROR:
	ADD R3 R3 #-1 ;In case one of numbers held in R0,R1,R2 registers are negative, the R3 is updated to be -1
END:
	; Loading registers values
	LD R0 SAVE_R0
	LD R1 SAVE_R1 
	LD R2 SAVE_R2
	LD R4 SAVE_R4
	LD R5 SAVE_R5
	LD R6 SAVE_R6
	LD R7 SAVE_R7
RET
	SAVE_R0 .FILL #0
	SAVE_R1 .FILL #0
	SAVE_R2 .FILL #0
	SAVE_R4 .FILL #0
	SAVE_R5 .FILL #0
	SAVE_R6 .FILL #0
	SAVE_R7 .FILL #0 
.END

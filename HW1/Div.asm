    ; 201278066, 70%
; 206538464, 30%
.ORIG X4064
Div:
	;storing the values of the registers
	ST R0 SAVE_R0 ;holds the divider
	ST R1 SAVE_R1 ;holds the number that will be divided
	ST R4 SAVE_R4 ;used as flag that indicate if R0 & R1 have different signs so we change the sign of the result at the end to be negative
	ST R5 SAVE_R5
	ST R6 SAVE_R6
	ST R7 SAVE_R7

	AND R2 R2 #0 ;initiallizing it to be 0
	AND R3 R3 #0 ;initiallizing it to be 0
	AND R4 R4 #0 ;initiallizing the "different signs flag to be 0
	ADD R1 R1 #0  
	BRz DIVIDE_BY_ZERO ; checking if we divide by zero
	BRp CHANGESIGN_R1  ; Changing the sign of R1 to be negative, so we can add it each time to R1
	ADD R0 R0 #0
	BRn CHANGESIGN_R0 ; Changing the sign of R0 to be positive
	BR DIFFERENT_SIGNS ; Reaching this line indicate that R0 and R1 have different signs, R0 is positive while R1 is negative, so we have to turn the "different signs" flag on
DIVIDE:
	ADD R2 R2 #1 ;adding 1 to the result 
	ADD R3 R0 #0 ;R3 equals to R0 so that in the last loop before it became negative it will hold the remainder
	ADD R0 R0 R1 ;subtract ("add") R1 from R0 
	BRzp DIVIDE ;As long as R0 is positive or zero do the loop again, it "may contain more R1's"
	BR RESULT_ADJUST ;Reaching here means that R0 became negative
CHANGESIGN_R1: ;changing the sign of R1 to become negative so we can add it each time to R0
	NOT R1 R1 
	ADD R1 R1 #1 
	ADD R0 R0 #0 
	BRn CHANGESIGN_R0
	BR DIVIDE
CHANGESIGN_R0: ;Changing the sign of R0 in case that R0 & R1 have different signs so we need to update the Flag of different signs (R4)
	NOT R0 R0 
	ADD R0 R0 #1 
	BR DIFFERENT_SIGNS 
DIFFERENT_SIGNS: 
	ADD R4 R4 #1 ;if R0 & R1 have different signs change the value of R4 to be 1
	BR DIVIDE
DIVIDE_BY_ZERO:
	ADD R3 R3 #-1 ;no need to equal R2 to be -1, since its being done anyway in RESULT_ADJUST
RESULT_ADJUST: 
	ADD R2 R2 #-1 ;since R0 became negative in the last iteration, we counted additional R1 into R2, here we subtract it 
  	;the following two lines check if the R0 and R1 have different signs (by the value of R4) if yes we should change the sign of the result 
	ADD R4 R4 #0 
	BRz END 
	NOT R2 R2 
	ADD R2 R2 #1
END: 
	;loading the values of the registers
	LD R0 SAVE_R0 
	LD R1 SAVE_R1 
	LD R4 SAVE_R4
	LD R5 SAVE_R5
	LD R6 SAVE_R6
	LD R7 SAVE_R7 
RET
	SAVE_R0 .FILL #0 
	SAVE_R1 .FILL #0 
	SAVE_R4 .FILL #0 
	SAVE_R5 .FILL #0
	SAVE_R6 .FILL #0 
	SAVE_R7 .FILL #0 
.END

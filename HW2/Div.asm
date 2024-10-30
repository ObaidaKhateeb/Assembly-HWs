    ; 201278066, 50%
; 206538464, 50%
.ORIG X4064
Div:
	;storing the values of the registers
	ST R0 SAVE_R0 
	ST R1 SAVE_R1 
	ST R2 SAVE_R2 ;holds the divider
	ST R3 SAVE_R3 ;holds the number that will be divided
	ST R4 SAVE_R4 ;used as flag that indicate if R2 & R3 have different signs so we change the sign of the result at the end to be negative
	ST R7 SAVE_R7

	AND R6 R6 #0 ;initiallizing it to be 0
	AND R5 R5 #0 ;initiallizing it to be 0
	AND R4 R4 #0 ;initiallizing the "different signs flag" to be 0
	ADD R3 R3 #0  
	BRz DIVIDE_BY_ZERO ; checking if we divide by zero
	BRp CHANGESIGN_R3  ; Changing the sign of R3 to be negative, so we can add it each time to R3
	ADD R2 R2 #0
	BRn CHANGESIGN_R2 ; Changing the sign of R2 to be positive
	BR DIFFERENT_SIGNS ; Reaching this line indicate that R2 and R3 have different signs, R2 is positive while R3 is negative, so we have to turn the "different signs" flag on
DIVIDE:
	ADD R6 R6 #1 ;adding 1 to the result 
	ADD R5 R2 #0 ;R5 equals to R2 so that in the last loop before it became negative it will hold the remainder
	ADD R2 R2 R3 ;subtract ("add") R3 from R2 
	BRzp DIVIDE ;As long as R2 is positive or zero do the loop again, it "may contain more R3's"
	BR RESULT_ADJUST ;Reaching here means that R2 became negative
CHANGESIGN_R3: ;changing the sign of R3 to become negative so we can add it each time to R2
	NOT R3 R3 
	ADD R3 R3 #1 
	ADD R2 R2 #0 
	BRn CHANGESIGN_R2
	BR DIVIDE
CHANGESIGN_R2: ;Changing the sign of R2 in case that R2 & R3 have different signs so we need to update the Flag of different signs (R4)
	NOT R2 R2 
	ADD R2 R2 #1 
	BR DIFFERENT_SIGNS 
DIFFERENT_SIGNS: 
	ADD R4 R4 #1 ;if R2 & R3 have different signs change the value of R4 to be 1
	BR DIVIDE
DIVIDE_BY_ZERO:
	ADD R5 R5 #-1 ;no need to equal R6 to be -1, since its being done anyway in RESULT_ADJUST
RESULT_ADJUST: 
	ADD R6 R6 #-1 ;since R2 became negative in the last iteration, we counted additional R3 into R6, here we subtract it 
  	;the following two lines check if the R2 and R3 have different signs (by the value of R4), if yes we should change the sign of the result 
	ADD R4 R4 #0 
	BRz END 
	NOT R6 R6 
	ADD R6 R6 #1
END: 
	;loading the values of the registers
	LD R0 SAVE_R0
	LD R1 SAVE_R1
	LD R2 SAVE_R2 
	LD R3 SAVE_R3 
	LD R4 SAVE_R4
	LD R7 SAVE_R7 
RET
	SAVE_R0 .FILL #0
	SAVE_R1 .FILL #0
	SAVE_R2 .FILL #0 
	SAVE_R3 .FILL #0 
	SAVE_R4 .FILL #0 
	SAVE_R7 .FILL #0 
.END

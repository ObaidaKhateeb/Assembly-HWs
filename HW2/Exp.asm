    ; 201278066, 50%
; 206538464, 50%
.ORIG X40C8
Exp:
	; Storing the registers values.
	ST R0 SAVE_R0 
	ST R1 SAVE_R1 
	ST R2 SAVE_R2 ;the number that is base
	ST R3 SAVE_R3 ;the number that is exponent
	ST R4 SAVE_R4
	ST R5 SAVE_R5 ;counter for the loop
	ST R7 SAVE_R7
	

	AND R6 R6 #0 ; Initializing R6 to be zero.
	ADD R2 R2 #0 ; Cheking if R2 is negative.
	BRN INVALID ; if R2 is negative so the input is invalid.
	BRZ CHECK_R3 ; if R2 is zero so we will check R3 in label CHECK_R3.
VALID:
	ADD R3 R3 #0
	BRz ALWAYS_ONE ; R2 > 0 & R3 = 0 , the result is one.
	BRN INVALID ; R2 > 0 & R3 < 0, so the input is invalid.
	LD R4, MUL_PTR ; Loading MUL subroutine address to R4.
	ADD R5 R3 #0 ; Backup R3.
	ADD R3 R2 #0 ; R3 = R2 , so we will use MUL subroutine to calculate R2*R3.
	ADD R6 R2 #0 ; guarantee if the power is 1
EXP_LOOP:
	ADD R5 R5 #-1 ; Decrease the value of the counter by 1.
	BRz END ; Go to end if reached zero.
	jsrr R4
	ADD R2 R6 #0
	BR EXP_LOOP
CHECK_R3
	ADD R3 R3 #0 
	BRnz INVALID ; R3<= 0 & R2 = 0.
	BR VALID
INVALID:
	ADD R6 R6 #-1 ; R6  = -1 , it's invalid!.
	BR END
ALWAYS_ONE:
	ADD R6 R6 #1 ; R6  = -1 , its valid!.
END:
	; Loading the registers values.
	LD R0 SAVE_R0
	LD R1 SAVE_R1
	LD R2 SAVE_R2
	LD R3 SAVE_R3
	LD R4 SAVE_R4
	LD R5 SAVE_R5
	LD R7 SAVE_R7

RET
	SAVE_R0 .FILL #0
	SAVE_R1 .FILL #0
	SAVE_R2 .FILL #0
	SAVE_R3 .FILL #0
	SAVE_R4 .FILL #0
	SAVE_R5 .FILL #0
	SAVE_R7 .FILL #0
	MUL_PTR .FILL X4000 ; MUL subroutine's address.
.END

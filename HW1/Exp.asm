    ; 201278066, 30%
; 206538464, 70%
.ORIG X40C8
Exp:
	; Storing the registers values.
	ST R0 SAVE_R0 ;the number that is base
	ST R1 SAVE_R1 ;the number that is exponent
	ST R3 SAVE_R3 ;counter for the loop
	ST R4 SAVE_R4
	ST R5 SAVE_R5
	ST R6 SAVE_R6
	ST R7 SAVE_R7
	

	AND R2 R2 #0 ; Initializing R2 to be zero.
	ADD R0 R0 #0 ; Cheking if R0 is negative.
	BRN INVALID ; if R0 is negative so the input is invalid.
	BRZ CHECK_R1 ; if R0 is zero so we will check R1 in label CHECK_R1.
VALID:
	ADD R1 R1 #0
	BRz ALWAYS_ONE ; R0 > 0 & R1 = 0 , the result is one.
	BRN INVALID ; R0 > 0 & R1 < 0, so the input is invalid.
	LD R4, MUL_PTR ; Loading MUL subroutine address to R4.
	ADD R3 R1 #0 ; Backup R1.
	ADD R1 R0 #0 ; R1 = R0 , so we will use MUL subroutine to calculate R0*R1.
	ADD R2 R0 #0 ; guarantee if the power is 1
EXP_LOOP:
	ADD R3 R3 #-1 ; Decrease the value of the counter by 1.
	BRz END ; Go to end if reached zero.
	jsrr R4
	ADD R0 R2 #0
	BR EXP_LOOP
CHECK_R1
	ADD R1 R1 #0 
	BRnz INVALID ; R1<= 0 & R0 = 0.
	BR VALID
INVALID:
	ADD R2 R2 #-1 ; R2  = -1 , it's invalid!.
	BR END
ALWAYS_ONE:
	ADD R2 R2 #1 ; R2  = -1 , its valid!.
END:
	; Loading the registers values.
	LD R0 SAVE_R0
	LD R1 SAVE_R1
	LD R3 SAVE_R3
	LD R4 SAVE_R4
	LD R5 SAVE_R5
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
	MUL_PTR .FILL X4000 ; MUL subroutine's address.
.END

    ; 201278066, 50%
; 206538464, 50%
.ORIG X3000
main:
	AND R0 R0 #0 ; Initializing R0 to zero
	AND R1 R1 #0 ; Initializing R1 to zero
	LD R4 GetNum_PTR ; Loading GetNum subroutine pointer
	JSRR R4 ; Calling the GetNum subroutine to get the first number
	ADD R0 R2 #0 ; Updating the first number that received from the GetNum subroutine 
	JSRR R4 ; Calling the GetNum subroutine to get the second number
	ADD R1 R2 #0 ; Updating the second number that received from the GetNum subroutine 
	LD R4 Calculator_PTR ; Loading Calculator subroutine pointer
	JSRR R4 ; Calling the Calculator subroutine to calculate the received command, and print the result

HALT
	GetNum_PTR .FILL X41F4 ; GetNum subroutine pointer
	Calculator_PTR .FILL X4384 ; Calculator subroutine pointer
.END

    

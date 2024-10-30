       ; 201278066, 50%
; 206538464, 50%
.ORIG X3000
Main:
	LEA R1 Course1Size ; R1 = the first course size label
	LEA R0 Students_Num_String ; requesting the user to insert the number of student in each course
	PUTS ; printing the string that in R0
GET_COURSE_SIZE:
	GETC ;getting the next input 
	OUT ;printing the inserted input 
	ADD R2 R0 #-10
	BRZ ENTER_INSERTED ;check if ENTER has been inserted, if yes it indicates that the client finished inserting courses sizes
	LD R5 SPACE_CHAR ;loading the opposite number of the ASCII space value
	ADD R2 R0 R5 
	BRZ SPACE_INSERTED ;checking if SPACE has been inserted 
	ADD R3 R3 #0 
	BRZ NEW_INSERT ;if R3 is 0, then its a new inserted size
	AND R3 R3 #0
	ADD R3 R3 #10 ;if we reached this line in code then the client entered two consecutive numbers without spaces which mean the size he entered is formed from two digits, the only eligible two digits size is 10, that's why when reaching this line the value of R3 turns to 10 
	STR R3 R1 #0 ;the number R3 which is the size of a course is stored in the location where R1 points 
	AND R3 R3 #0 ;make R3 equals to zero preparing it to hold the next number (size)
	ADD R1 R1 #1 ;make R1 points to the next slot
	BR GET_COURSE_SIZE	

NEW_INSERT:
	ADD R3 R3 R0 ;move the value in R0 to R3
	BR GET_COURSE_SIZE ;Go to get the next input
SPACE_INSERTED: 
	ADD R3 R3 #0 
	BRz GET_COURSE_SIZE ;checking if what entered is space after another space, if yes, go back to get a new digit
	LD R2 NUM_TO_ASCII_MINUS ;loading the value of (-48), which converts ASCII value into number
	ADD R3 R3 R2 ;converting the ASCII value to a number
	STR R3 R1 #0 ;reaching this line means that the client entered space after entering a number, which means we have a size that should be saved, that's what is being done by this line
	AND R3 R3 #0 ;make R3 to equal zero, preparing it to get the next value 
	ADD R1 R1 #1 ;moving the R1 to pounts to the next slot
	BR GET_COURSE_SIZE ;moving back to get the next value 
ENTER_INSERTED:
	ADD R3 R3 #0 ;checking if there was an input that still not saved before inserting enter
	BRZ STUDENTS_GRADES ;if there's no input that was not saved to move to the next step 
	LD R2 NUM_TO_ASCII_MINUS ;loading the (-48) value which converts an ASCII value into a number 
	ADD R3 R3 R2 ;converting ASCII value into a number 
	STR R3 R1 #0 ;storing the value of R3 in the slot 
STUDENTS_GRADES:
	; 1st course
	LEA R0 Students_Grades_String1 ; requesting the user to insert the students grades in the 1st course
	PUTS ; printing the string that in R0
	LEA R1 C1_Student_1 ; R1 = the first student in the first course
	LD R2 Course1Size ; R2 = mem[Course1Size]
	JSR GetStudentGrades ; get student grades for the first course students by GetStudentGrades subroutine
	JSR AverageCalculator ; calculate the average for the first course students by AverageCalculator subroutine
	JSR BubbleSort ; Sorting the list of the 1st course
	LD R0 BEST_STUDENTS_ARR_POINTER ; loading final array address to R0 to store in it the best 6 averages of the first course
	JSR BestStudent ; storing the best 6 student in temp array 
	; 2nd course
	LEA R0 Students_Grades_String2 ; requesting the user to insert the students grades in the 2nd course
	PUTS ; printing the string that in R0
	LD R1 C2_Student_1_Pointer ; R1 = the first student in the second course
	LD R2 Course2Size ; R2 = mem[Course2Size]
	JSR GetStudentGrades ; get student grades for the 2nd course students by GetStudentGrades subroutine
	JSR AverageCalculator ; calculate the average for the 2nd course students by AverageCalculator subroutine
	JSR BubbleSort ; Sorting the list of the 2nd course 
	LD R0 TEMP_ARR_POINTER ; loading temp array to R0 to store in it the best 6 averages of the 1st course
	JSR BestStudent ; storing the best 6 student in temp array
	LD R1 BEST_STUDENTS_ARR_POINTER ; loading the final array address to R1 to store in it the best 6 averages of the 1st and 2nd course
	jsr MERGE_ARRAYS ; updating the final array of the best 6 averages
	; 3rd course
	LEA R0 Students_Grades_String3 ; requesting the user to insert the students grades in the 3rd course
	PUTS ; printing the string that in R0
	LD R1 C3_Student_1_Pointer ; R1 = the first student in the 3rd course
	LD R2 Course3Size ; R2 = mem[Course3Size]
	JSR GetStudentGrades ; get student grades for the 3rd course students by GetStudentGrades subroutine
	JSR AverageCalculator ; calculate the average for the 3rd course students by AverageCalculator subroutine
	JSR BubbleSort ; Sorting the list of the 3rd course
	LD R0 TEMP_ARR_POINTER ; loading temp array to R0 to store in it the best 6 averages of the first course
	JSR BestStudent ; storing the best 6 student in temp array
	LD R1 BEST_STUDENTS_ARR_POINTER ; loading the final array address to R1 to store in it the best 6 averages of the 1st and 2nd and 3rd course
	jsr MERGE_ARRAYS ; updating the final array
	; printing...
	LD R1 BEST_STUDENTS_ARR_POINTER ; R1 = the address of the final array of the best 6 averages
	AND R2 R2 #0 ; R2 = 0
	ADD R2 R2 #6 ; R2 = 6
	LEA R0 Highest_Scores_String
	PUTS
PRINT_BEST:
	LD R0 SPACE_CHAR_PLUS
	OUT ; print space
	LDR R0 R1 #0 ; R0 = the current cell value in the final array
	JSR PrintNum ; call PrintNum subroutine to print
	ADD R1 R1 #1 ; pointer ++
	ADD R2 R2 #-1 ; number of cells that hasn't printed yet
	BRP PRINT_BEST
HALT
NUM_TO_ASCII_MINUS .FILL #-48
Course1Size .FILL #0
Course2Size .FILL #0
Course3Size .FILL #0
SPACE_CHAR .FILL #-32
SPACE_CHAR_PLUS .FILL #32	
Students_Num_String .STRINGZ "Enter the number of students in each course:"
Students_Grades_String1 .STRINGZ "Enter the student grades in course 1:\n"
Students_Grades_String2 .STRINGZ "Enter the student grades in course 2:\n"
Students_Grades_String3 .STRINGZ "Enter the student grades in course 3:\n"
Highest_Scores_String .STRINGZ "The six highest scores are:"
GetStudentGrades_PTR .FILL GetStudentGrades
AverageCalculator_PTR .FILL AverageCalculator
BubbleSort_PTR .FILL BubbleSort
NUM_TO_ASCII .FILL #48
TEN_VALUE .FILL #0
TEMP_ARR_POINTER .FILL TEMP_ARR
BEST_STUDENTS_ARR_POINTER .FILL BEST_STUDENTS_ARR
C2_Student_1_Pointer .FILL C2_Student_1
C3_Student_1_Pointer .FILL C3_Student_1
C1_Student_1: .FILL #0 ; the first student in the first course
	.FILL #0 ; grade 1
	.FILL #0 ; grade 2 
	.FILL #0 ; grade 3
	.FILL #0 ; avg
	.FILL #0 ; prev student
	.FILL C1_Student_2 ; next student

C1_Student_2: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C1_Student_1
	.FILL C1_Student_3

C1_Student_3: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C1_Student_2
	.FILL C1_Student_4

C1_Student_4: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C1_Student_3
	.FILL C1_Student_5

C1_Student_5: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C1_Student_4
	.FILL C1_Student_6

C1_Student_6: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C1_Student_5
	.FILL C1_Student_7
	
C1_Student_7: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C1_Student_6
	.FILL C1_Student_8
	
C1_Student_8: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C1_Student_7
	.FILL C1_Student_9
	
C1_Student_9: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C1_Student_8
	.FILL C1_Student_10
	
C1_Student_10: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C1_Student_9
	.FILL #0

C2_Student_1: .FILL #0 ; the first student in the second course
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0
	.FILL C2_Student_2

C2_Student_2: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C2_Student_1
	.FILL C2_Student_3

C2_Student_3: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C2_Student_2
	.FILL C2_Student_4

C2_Student_4: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C2_Student_3
	.FILL C2_Student_5

C2_Student_5: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C2_Student_4
	.FILL C2_Student_6

C2_Student_6: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C2_Student_5
	.FILL C2_Student_7
	
C2_Student_7: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C2_Student_6
	.FILL C2_Student_8
	
C2_Student_8: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C2_Student_7
	.FILL C2_Student_9
	
C2_Student_9: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C2_Student_8
	.FILL C2_Student_10
	
C2_Student_10: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C2_Student_9
	.FILL #0

C3_Student_1: .FILL #0 ; the first student in the third course
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0
	.FILL C3_Student_2

C3_Student_2: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C3_Student_1
	.FILL C3_Student_3

C3_Student_3: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C3_Student_2
	.FILL C3_Student_4

C3_Student_4: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C3_Student_3
	.FILL C3_Student_5

C3_Student_5: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C3_Student_4
	.FILL C3_Student_6

C3_Student_6: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C3_Student_5
	.FILL C3_Student_7
	
C3_Student_7: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C3_Student_6
	.FILL C3_Student_8
	
C3_Student_8: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C3_Student_7
	.FILL C3_Student_9
	
C3_Student_9: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C3_Student_8
	.FILL C3_Student_10
	
C3_Student_10: .FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL C3_Student_9
	.FILL #0

BEST_STUDENTS_ARR: .FILL #0
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0
	.FILL #0

TEMP_ARR: .FILL #0
	.FILL #0 
	.FILL #0 
	.FILL #0 
	.FILL #0
	.FILL #0

GetStudentGrades: 
	;Storing the values of the registers
	ST R0 SAVE_R0_GetStudentGrades 
	ST R1 SAVE_R1_GetStudentGrades ;will hold a pointer to a course s linked list 
	ST R2 SAVE_R2_GetStudentGrades ;will hold the entered grade number
	ST R3 SAVE_R3_GetStudentGrades ;used to hold the number 10, by which we re going to multiply R2 each time we have a new number s digit 
	ST R4 SAVE_R4_GetStudentGrades ;used to check if SPACE or ENTER has been entered, and to help with converting inserted number from ASCII code to actual number, also will hold the subroutine address where the program going to jump in order to make calculations  
	ST R5 SAVE_R5_GetStudentGrades ;will hold the number of the students in the course, used as a counter so we know if there s more students 
	ST R6 SAVE_R6_GetStudentGrades 
	ST R7 SAVE_R7_GetStudentGrades

	ADD R5 R2 #0 ;moving the number of students from R2 to R5 
	AND R3 R3 #0 
	ADD R3 R3 #10 ;R3 = 10 

GET_GRADE: 
	AND R2 R2 #0 ;initialize R2 to be 0, so it holds the entered grade number
GET_DIGIT:
	GETC ;gets the next input 
	OUT ;printing the input 
	LD R4 SPACE_ASCII ; loading the value -32 to R3, so we check using it if SPACE has been entered 
	ADD R4 R4 R0
	BRZ NEXT_GRADE ; if SPACE has been entered that means the client finished to enter the current grade and going to enter the next one 
	ADD R4 R0 #-10
	BRZ NEXT_STUDENT ;if ENTER has been entered that means that the client finished to enter the current student grades and going to enter the next student grades/to finish 
	LD R4 MUL_PTR
	JSRR R4 ;reaching this line indicates that what was inserted is a digit, so we have to multiply R2 by 10 (R3) in order to add the next digit 
	ADD R2 R6 #0 ;since MUL returns the result in R6, we move it to R2
	LD R4 ASCII_TO_NUMBER ; Loading -48 to R4
	ADD R0 R0 R4 ;converting the ASCII code to a number  
	ADD R2 R2 R0 ;adding the digit entered (R0) to R2 
	BR GET_DIGIT ;moving back to the loop for the next input 

NEXT_GRADE:
	ADD R2 R2 #0 
	BRZ GET_DIGIT  
	STR R2 R1 #0 ;storing the entered grade in the linked list relevant slot 
	ADD R1 R1 #1 ;moving the R1 pointer to the next slot 
	BR GET_GRADE ;going back for getting the next grade 

NEXT_STUDENT:
	ADD R2 R2 #0 
	BRZ NEXT_STUDENT_WITHOUT_SAVE
	STR R2 R1 #0 ;storing the entered grade in the linked list relevant slot
NEXT_STUDENT_WITHOUT_SAVE: 
	ADD R5 R5 #-1 ;decreasing the students counter by 1 
	BRZ FINISH_GetStudentGrades ;to finish the program if the students counter equal to zero 
	LDR R1 R1 #3 ;getting the next student address 
	BR GET_GRADE ;moving back for getting the next grade 

FINISH_GetStudentGrades:
	;loading the values that have been in the register before launching the subroutine 
	LD R0 SAVE_R0_GetStudentGrades
	LD R1 SAVE_R1_GetStudentGrades
	LD R2 SAVE_R2_GetStudentGrades
	LD R3 SAVE_R3_GetStudentGrades
	LD R4 SAVE_R4_GetStudentGrades
	LD R5 SAVE_R5_GetStudentGrades
	LD R6 SAVE_R6_GetStudentGrades
	LD R7 SAVE_R7_GetStudentGrades
RET
	SPACE_ASCII .FILL #-32 ;ASCII code for SPACE
	ASCII_TO_NUMBER .FILL #-48 ;A number that substracting it from ASCII code returns its actual value
	MUL_PTR .FILL MUL
	SAVE_R0_GetStudentGrades .FILL #0
	SAVE_R1_GetStudentGrades .FILL #0
	SAVE_R2_GetStudentGrades .FILL #0
	SAVE_R3_GetStudentGrades .FILL #0
	SAVE_R4_GetStudentGrades .FILL #0
	SAVE_R5_GetStudentGrades .FILL #0
	SAVE_R6_GetStudentGrades .FILL #0
	SAVE_R7_GetStudentGrades .FILL #0




AverageCalculator:
	;Storing the values of the registers 
	ST R0 SAVE_R0_AverageCalculator ;will hold the number of students in the course, used as a counter so we know if there s more students  
	ST R1 SAVE_R1_AverageCalculator ;will hold a pointer to a course s linked list 
	ST R2 SAVE_R2_AverageCalculator ;used to hold the sum of the student 4 grades 
	ST R3 SAVE_R3_AverageCalculator ;used to hold the number 4, which is the number of the grades for each student 
	ST R4 SAVE_R4_AverageCalculator ;used to load the student grade 
	ST R5 SAVE_R5_AverageCalculator 
	ST R6 SAVE_R6_AverageCalculator 
	ST R7 SAVE_R7_AverageCalculator
	ADD R0 R2 #0 ;moving the number of students from R2 to R5 
	AND R3 R3 #0 
	ADD R3 R3 #4 ; R3 = 4
AVERAGE_CALCULATION:	
	AND R2 R2 #0 ;initializing R2 to be zero 
	LDR R4 R1 #0 ;loading the 1st student grade
	ADD R2 R2 R4 ;adding the grade to the sum
	LDR R4 R1 #1 ;loading the 2nd student grade
	ADD R2 R2 R4 ;adding the grade to the sum
	LDR R4 R1 #2 ;loading the 3rd student grade
	ADD R2 R2 R4 ;adding the grade to the sum
	LDR R4 R1 #3 ;loading the 4th student grade
	ADD R2 R2 R4 ;adding the grade to the sum
	LD R4 DIV_PTR
	JSRR R4 ;moving to DIV subroutine in order to calculate the average 
	STR R6 R1 #4 ;since DIV returns the average in R6, we store its value in the relevant slot 
	ADD R0 R0 #-1 ;decreasing the student counter by 1 
	BRZ FINISH_AverageCalculator ;if students counter equals to zero to finish the program 
	LDR R1 R1 #6 ;loading the next student first score slot address 
	BR AVERAGE_CALCULATION ;moving back to calculate next student average 
	
FINISH_AverageCalculator: 
	;loading the values that have been in the register before launching the subroutine 
	LD R0 SAVE_R0_AverageCalculator
	LD R1 SAVE_R1_AverageCalculator
	LD R2 SAVE_R2_AverageCalculator
	LD R3 SAVE_R3_AverageCalculator
	LD R4 SAVE_R4_AverageCalculator
	LD R5 SAVE_R5_AverageCalculator
	LD R6 SAVE_R6_AverageCalculator
	LD R7 SAVE_R7_AverageCalculator
RET
	DIV_PTR .FILL DIV
	SAVE_R0_AverageCalculator .FILL #0
	SAVE_R1_AverageCalculator .FILL #0
	SAVE_R2_AverageCalculator .FILL #0
	SAVE_R3_AverageCalculator .FILL #0
	SAVE_R4_AverageCalculator .FILL #0
	SAVE_R5_AverageCalculator .FILL #0
	SAVE_R6_AverageCalculator .FILL #0
	SAVE_R7_AverageCalculator .FILL #0

BubbleSort:
;storing the values of the registers
	ST R0 SAVE_R0 ; current student address
	ST R2 SAVE_R2 ; linked list size
	ST R3 SAVE_R3 ; temp
	ST R4 SAVE_R4 ; innner loop counter
	ST R5 SAVE_R5 ; saving the current student average, and using as previous student for swap
	ST R6 SAVE_R6 ; saving the next student average, and using as next student for swap
	ST R7 SAVE_R7
	
OUTER_LOOP:
	ADD R3 R2 #-1 ; when R2 <= 1 we want to stop so we want to check if R2 - 1 <= 0
	BRNZ END_BubbleSort ;the negative condition to check if the list size <= 0, it can be occurs in the first iteration
	AND R4 R4 #0
	ADD R4 R4 #-1 ; R4 = -1, the loop counter = -1 at the beginning of the inner loop
	ADD R0 R1 #0 ; R0 = linked list address = first student address
INNER_LOOP:
	ADD R3 R4 R2 ; checking the inner loop condition
	BRNZ UPDATE_OUTER ; when the inner loop index reached the "outer loop index -1" or less
	LDR R5 R0 #4 ; loading current student average
	LDR R0 R0 #6 ; R0 = current.next
	LDR R6 R0 #4 ; loading next student average
	LDR R0 R0 #5 ; giving back R0 the current address
	NOT R6 R6
	ADD R6 R6 #1 ; 2's complement
	ADD R3 R5 R6
	BRZP UPDATE_INNER ; if R5 >= R6, dont swap
SWAP:	
	LDR R6 R0 #6 ; saving current.next
	LDR R3 R6 #6 ; saving (current.next).next
	LDR R5 R0 #5 ; saving current.prev, and checking if the prev is 0, so its the head of the list
	BRP NOT_HEAD ; if the address is not zero so its not the head
	LDR R1 R0 #6 ; current.next = head
NOT_HEAD:
	BRZ LAST
	STR R0 R3 #5 ; ((current.next).next).prev = current
LAST:
	STR R3 R0 #6 ; current.next = (current.next).next
	STR R6 R0 #5 ; current.prev = current.next
	ADD R5 R5 #0
	BRZ NO_PREV
	STR R6 R5 #6 ; (current.prev).next = current.next
NO_PREV:
	STR R5 R6 #5 ; (current.next).prev = current.prev
	STR R0 R6 #6 ; (current.next).next = current
	LDR R0 R0 #5 ; R0 = current.prev (to still at the "same index")
UPDATE_INNER:
	LDR R0 R0 #6 ; current = current.next	
	ADD R4 R4 #-1 ; R4 -- (the inner loop counter)
	BR INNER_LOOP ; go to the inner loop
UPDATE_OUTER:
	ADD R2 R2 #-1 ; R2 -- (the outer loop counter)
	BR OUTER_LOOP ; go to the outer loop
END_BubbleSort: 
	;loading the values of the registers
	LD R0 SAVE_R0
	LD R2 SAVE_R2
	LD R3 SAVE_R3 
	LD R4 SAVE_R4
	LD R5 SAVE_R5
	LD R6 SAVE_R6
	LD R7 SAVE_R7 
RET
	SAVE_R0 .FILL #0
	SAVE_R2 .FILL #0 
	SAVE_R3 .FILL #0 
	SAVE_R4 .FILL #0
	SAVE_R5 .FILL #0
	SAVE_R6 .FILL #0
	SAVE_R7 .FILL #0


BestStudent:
	;Storing the values of the registers
	ST R0 SAVE_R0_BestStudent ;will hold the array 
	ST R1 SAVE_R1_BestStudent ;will hold a pointer to a course s linked list 
	ST R2 SAVE_R2_BestStudent ;will hold the linked list length; used as a students counter
	ST R3 SAVE_R3_BestStudent ;will hold a counter of 6, the number of the highest averages we aim to get
	ST R4 SAVE_R4_BestStudent ;will be used to hold the student s average each time 
	ST R5 SAVE_R5_BestStudent 
	ST R6 SAVE_R6_BestStudent ;will be used to check if two averages are equal 
	ST R7 SAVE_R7_BestStudent

	AND R3 R3 #0 
	ADD R3 R3 #6 ;initializing the averages counter to be 6 
	
	JSR AverageCalculator ;jump to the subroutine that calculates students averages
	;JSR BubbleSort ;jump to the subroutine that sorts the students by their averages
	LDR R4 R1 #4 ;loading the highest average to R4 
	STR R4 R0 #0 ;storing the highest average in the first slot of the array 
	ADD R0 R0 #1 ;moving the array s pointer to the next slot 
	LDR R1 R1 #6 ;moving the linked list s array to the next slot 
LOOP: 
	ADD R3 R3 #-1 ;decrease the averages counter by 1 
	BRZ FINISH_BestStudent ;if this counter equals to zero it means that we finished to insert the high six averages in the array 
	ADD R2 R2 #-1 ;decreasing the students counter by 1  
	BRZ NO_MORE_STUDENTS ;if this counter equals to zero it means that no more students there in the linked list 
	ADD R6 R4 #0 ;adding the previous student s average to R6 
	NOT R6 R6
	ADD R6 R6 #1 ;inverting the value of R6 
	LDR R4 R1 #4 ;loading the current student average
	LDR R1 R1 #6 ;make the linked list pointer points to the next student 
	ADD R6 R6 R4 ;checking if the current student s average equals to the previous one, if yes, it will not add it to the array 
	BRZ LOOP 
	STR R4 R0 #0 ;saving the current student average to the array 
	ADD R0 R0 #1 ;moving the array s pointer to the next slot 
	BR LOOP ;moving back to deal with the next average/finish

NO_MORE_STUDENTS:
	STR R2 R0 #0 ;since R2 became zero we can use its value to fill the rest of array cells 
	ADD R0 R0 #1 ;moving the array s pointer to the next slot 
	ADD R3 R3 #-1 ;decrease the averages counter by 1 
	BRp NO_MORE_STUDENTS ;if the R3 counter still not zero, then we have more slots in the array that have to be filled with zero value 

FINISH_BestStudent:
	;loading the values that have been in the register before launching the subroutine 
	LD R0 SAVE_R0_BestStudent
	LD R1 SAVE_R1_BestStudent
	LD R2 SAVE_R2_BestStudent
	LD R3 SAVE_R3_BestStudent
	LD R4 SAVE_R4_BestStudent
	LD R5 SAVE_R5_BestStudent
	LD R6 SAVE_R6_BestStudent
	LD R7 SAVE_R7_BestStudent
RET
	SAVE_R0_BestStudent .FILL #0
	SAVE_R1_BestStudent .FILL #0
	SAVE_R2_BestStudent .FILL #0
	SAVE_R3_BestStudent .FILL #0
	SAVE_R4_BestStudent .FILL #0
	SAVE_R5_BestStudent .FILL #0
	SAVE_R6_BestStudent .FILL #0
	SAVE_R7_BestStudent .FILL #0

MUL: 
	;storing the values of the registers
	ST R7 SAVE_R7_MUL 
	ST R0 SAVE_R0_MUL 
	ST R1 SAVE_R1_MUL 
	ST R2 SAVE_R2_MUL ;holding first variable value
	ST R3 SAVE_R3_MUL ;holding the second variable value, used here as a counter of how much time the R2 will be added to R6
	ST R4 SAVE_R4_MUL 
	ST R5 SAVE_R5_MUL

	AND R6 R6 #0 ;initializing R6 to be 0
	ADD R2 R2 #0 ;checking if R2 equals to zero
	BRz END_MUL
	ADD R3 R3 #0 ;checking if R3 equals to zero
	BRz END_MUL
	BRn SWICHSIGNS ;since R3 is used as a counter, it have to be positive. so if its value is negative switch the signs of both registers, that will not change the result value or sign.
MULTIPLY: 
	ADD R6 R6 R2 ;each time we one copy of R6 will be added to R6, R3 copies in total. 
	ADD R3 R3 #-1 ;decrease counter by 1
	BRp MULTIPLY ;if counter still not zero, perform the loop again
	BR END_MUL ;if counter equals to zero end the program
SWICHSIGNS: 
	;switching sign of R3
	NOT R3 R3 
	ADD R3 R3 #1   
  	;switching sign of R2
	NOT R2 R2
	ADD R2 R2 #1
	BR MULTIPLY
END_MUL: 
	;loading the values of the registers
	LD R0 SAVE_R0_MUL 
	LD R1 SAVE_R1_MUL 
	LD R2 SAVE_R2_MUL
	LD R3 SAVE_R3_MUL
	LD R4 SAVE_R4_MUL 
	LD R5 SAVE_R5_MUL
	LD R7 SAVE_R7_MUL 
RET 
	SAVE_R0_MUL .fill #0 
	SAVE_R1_MUL .fill #0 
	SAVE_R2_MUL .fill #0
	SAVE_R3_MUL .fill #0 
	SAVE_R4_MUL .fill #0 
	SAVE_R5_MUL .fill #0 
	SAVE_R7_MUL .fill #0 

DIV:
	;storing the values of the registers
	ST R0 SAVE_R0_DIV 
	ST R1 SAVE_R1_DIV 
	ST R2 SAVE_R2_DIV ;holds the divider
	ST R3 SAVE_R3_DIV ;holds the number that will be divided
	ST R4 SAVE_R4_DIV ;used as flag that indicate if R2 & R3 have different signs so we change the sign of the result at the end to be negative
	ST R7 SAVE_R7_DIV

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
	BRz END_DIV
	NOT R6 R6 
	ADD R6 R6 #1
END_DIV: 
	;loading the values of the registers
	LD R0 SAVE_R0_DIV
	LD R1 SAVE_R1_DIV
	LD R2 SAVE_R2_DIV
	LD R3 SAVE_R3_DIV 
	LD R4 SAVE_R4_DIV
	LD R7 SAVE_R7_DIV 
RET
	SAVE_R0_DIV .FILL #0
	SAVE_R1_DIV .FILL #0
	SAVE_R2_DIV .FILL #0 
	SAVE_R3_DIV .FILL #0 
	SAVE_R4_DIV .FILL #0 
	SAVE_R7_DIV .FILL #0 

MERGE_ARRAYS: 
	;storing the values of the registers
    ST R7 SAVE_R7_MERGEARRAYS
    ST R0 SAVE_R0_MERGEARRAYS ;used as a pointer to the temp array
    ST R1 SAVE_R1_MERGEARRAYS ;used as a pointer to the final array
    ST R2 SAVE_R2_MERGEARRAYS ;used as a counter for the array size 
    ST R3 SAVE_R3_MERGEARRAYS ;used as a counter for moving the array's values
    ST R4 SAVE_R4_MERGEARRAYS ;used for loading the temp array value
    ST R5 SAVE_R5_MERGEARRAYS ;used for loading the final array value
    ST R6 SAVE_R6_MERGEARRAYS ;used for comparing the two values of the two arrays

    AND R2 R2 #0
    ADD R2 R2 #5 ;initiallizng the R2 counter to be 5
    ADD R1 R1 #5 ;make R1 to point to the last slot in the final array 

MERGE_ARRAYS_CHECK: 
    LDR R4 R0 #0 ;loading the value first value in the temp array 
    NOT R6 R4  
    ADD R6 R6 #1 ;flipping the sign of the value that has been loaded 
    LDR R5 R1 #0 ;loading the last value of the final array  
    ADD R6 R5 R6 
    BRzp MERGE_ARRAYS_END ;comparing the two number: the current in the temp array and the last in the final array, if the last number in the final array is larger or equal than the current number in the temp array (and since both arrays are sorted), then there's no more place to values from the temp array in the final array

    ST R1 SAVE_R1_MERGEARRAYS_TEMP ;saving the pointer to the last slot in the final array so we can retrieve it later
    ST R2 SAVE_R2_MERGEARRAYS_TEMP ;saving the R2 counter so we can retrieve it later
CHECK_IF_EXISTS: ;the goal of this loop is to check if the number we're going to enter (which is taken from the temp array) is already exists in the final array 
    LDR R6 R1 #0 ;loading to R6 the value of a number in the final array
    NOT R6 R6 
    ADD R6 R6 #1 ;flipping the number in R6 
    ADD R6 R6 R4 
    BRZ SORT_ARRAY_EXIT ;comparing the two values: the one from temp array which is candidate to be inserted into the final array, and the number in the current slot of the final array, if they're equal then the number in the temp array is already exists in the final array and no need to add them 
    ADD R1 R1 #-1 ;moving the R1 pointer to points to the next number in the final array  
    ADD R2 R2 #-1 ;decreasing the R2 counter by 1 
    BRzp CHECK_IF_EXISTS ;if the counter still not negative then they are more numbers in the final array to check if they're equal to the temp array number

    LD R1 SAVE_R1_MERGEARRAYS_TEMP ;make R1 points again to the last slot in the final array
    LD R2 SAVE_R2_MERGEARRAYS_TEMP ;retrieving the counter value 
    STR R4 R1 #0 ;reaching this line means that the R4 value (from the temp array) is not exists in the final array then we add it to the last slot into it 
SORT_ARRAY_LOOP: ;the goal of this loop is to sort the final array again after a new value has been added to it (to the last slot of it)
    LDR R4 R1 #0 ;loading the value in the current slot of the final array 
    NOT R6 R4 
    ADD R6 R6 #1 ;flipping the value of the current slot (i slot) in the final array 
    LDR R5 R1 #-1 ;loading the value in the slot that before the current slot (i-1 slot) in the final array
    ADD R6 R5 R6 ;comparing the two values that have been loaded
    BRzp SORT_ARRAY_EXIT ;if the value in the (i-1) place is larger than the one in the (i) place then the array is sorted
    STR R4 R1 #-1 ;reaching this line means that the number in the (i) slot is larger than the one in the (i-1) slot, so we have to exchange between their places
    STR R5 R1 #0 
    ADD R1 R1 #-1 ;moving the R1 pointer to points to the new place of the inserted value 
    ADD R2 R2 #-1 ;decreasing the R2 counter value by 1 
    BRp SORT_ARRAY_LOOP ;if the R2 counter value still positive then there are more comparisons to make
SORT_ARRAY_EXIT: 
    LD R1 SAVE_R1_MERGEARRAYS_TEMP ;make R1 points again to the last slot in the final array
    LD R2 SAVE_R2_MERGEARRAYS_TEMP ;retrieving the counter value 
    ADD R0 R0 #1 ;moving R0 to points to the next slot in the temp array 
    ADD R2 R2 #-1 ;decreasing the R2 counter (which indicate the number of the values in the temp array that still not being checked) by 1
    BRp MERGE_ARRAYS_CHECK ;going back to check if there's more values in the temp array to be added to the final array

MERGE_ARRAYS_END: 
	;loading the values of the registers
    LD R0 SAVE_R0_MERGEARRAYS 
    LD R1 SAVE_R1_MERGEARRAYS 
    LD R2 SAVE_R2_MERGEARRAYS 
    LD R3 SAVE_R3_MERGEARRAYS 
    LD R4 SAVE_R4_MERGEARRAYS
    LD R5 SAVE_R5_MERGEARRAYS
    LD R6 SAVE_R6_MERGEARRAYS 
    LD R7 SAVE_R7_MERGEARRAYS
RET 
    SAVE_R0_MERGEARRAYS .FILL #0
    SAVE_R1_MERGEARRAYS .FILL #0
    SAVE_R2_MERGEARRAYS .FILL #0
    SAVE_R3_MERGEARRAYS .FILL #0
    SAVE_R4_MERGEARRAYS .FILL #0
    SAVE_R5_MERGEARRAYS .FILL #0
    SAVE_R6_MERGEARRAYS .FILL #0
    SAVE_R7_MERGEARRAYS .FILL #0
    SAVE_R1_MERGEARRAYS_TEMP .FILL #0
    SAVE_R2_MERGEARRAYS_TEMP .FILL #0 

PrintNum:
	;storing the values of the registers
	ST R0 SAVE_R0_PRINT ; ASCII of the number zero
	ST R1 SAVE_R1_PRINT ; The address of the first cell of the array
	ST R2 SAVE_R2_PRINT ; The complete number of the division
	ST R3 SAVE_R3_PRINT ; To divide by R3 using DIV subroutine, and after that the will hold the negative value of the array address to compare it with digits number
	ST R4 SAVE_R4_PRINT ; DIV POINTER, and after that will be used to update the CC
	ST R5 SAVE_R5_PRINT ; The division remainder
	ST R6 SAVE_R6_PRINT ;
	ST R7 SAVE_R7_PRINT
	
	LEA R1 ARRAY ; Loading to R1 the array address
	LD R4 DIV_PTR_PRINT ; DIV subroutine pointer
	AND R2 R2 #0
	ADD R2 R0 #0 ; putting the input in R2 to send it to DIV subroutine
	LD R0 TO_ASCII ; R0 = 48
	
SIGN_CHECK:
	LD R3 SIGN ; R3 = 2^15
	AND R3 R2 R3 ; Checking if the most significant bit value
	BRZ CONTINUE ; When the most significant bit value is 0 we will not print the sign

; The most significant bit value is 1
NEG:
	LD R0 MINUS_SIGN ; R0 = ASCII of "-"
	OUT ; Printing the sign "-"
	LD R0 TO_ASCII ; Loading the 48 (the ASCII of the number 0) back

CONTINUE:
	LD R3 TEN ; Loading the value 10 to divide.

; Dividing by 10 and fill the array with their ASCII codes.
STORE_DIGITS:
	JSRR R4 ; Dividing R2 by R3 (R3 = 10)
	ADD R5 R5 R0 ; Converting to ASCII
	STR R5 R1 #0 ; Storing the digit to the array cells
	AND R2 R2 #0 ; R2 = 0
	ADD R2 R6 #0 ; R2 = R6 (R2/R3)
	BRZ PRINT ; If R6 = 0 (the complete value) go to PRINT
	ADD R1 R1 #1 ; Digits number ++
	BR STORE_DIGITS

PRINT:	LEA R3 ARRAY ; R3 = the array address
	NOT R3 R3
	ADD R3 R3 #1 ; 2's complement => R3 = -(array address)
PRINT_LOOP:
	ADD R4 R1 R3 ; Cheking if R1 (num of digits) < (array address)
	BRN END
	LDR R0 R1 #0 ; R0 = mem[R1] to print the value
	OUT ; Printing the value of R0 = mem[R1]
	ADD R1 R1 #-1 ; R1 --
	BR PRINT_LOOP
	
END: 
	;loading the values of the registers
	LD R0 SAVE_R0_PRINT
	LD R1 SAVE_R1_PRINT
	LD R2 SAVE_R2_PRINT
	LD R3 SAVE_R3_PRINT
	LD R4 SAVE_R4_PRINT
	LD R5 SAVE_R5_PRINT
	LD R6 SAVE_R6_PRINT
	LD R7 SAVE_R7_PRINT
RET
	SAVE_R0_PRINT .FILL #0 
	SAVE_R1_PRINT .FILL #0
	SAVE_R2_PRINT .FILL #0 
	SAVE_R3_PRINT .FILL #0 
	SAVE_R4_PRINT .FILL #0 
	SAVE_R5_PRINT .FILL #0 
	SAVE_R6_PRINT .FILL #0
	SAVE_R7_PRINT .FILL #0
	ARRAY .BLKW #5 #0 ; Array with size of 5 and every cell initialized to 0
	SIGN .FILL 32768 ; 2^15 => |1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0| in binary
	MINUS_SIGN .FILL #45 ; the sign "-"
	TEN .FILL #10 ; To divide by ten to find every digits
	TO_ASCII .FILL #48
	DIV_PTR_PRINT .FILL DIV
.END

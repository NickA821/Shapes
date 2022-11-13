###########################################
#
# Author: Nicholas  Buchanan, Hayden Phuong
# Date: October 27th, 2022
#
# Prints shapes using a doubly nested for
# loop and logical shifting/extracting
# operations
#
# parameters: rows, bits per row, shape design
#
###########################################


.data
	firstInputPrompt:	.asciiz "Enter Rows (0 to exit): "
	secondInputPrompt:	.asciiz "Enter Bits per Row: "
	shapeInputPrompt:	.asciiz "Enter Shape Design: "
	newLine:		.asciiz	"\n"
	exitPrompt:		.asciiz "Goodbye!"
	star:			.asciiz "*"
	space:			.asciiz " "
	errorMsg:        	.asciiz "Num rows * bits per row != total num bits"
.text
	main:
		jal promptRows
		# save prompt into $s0
		move $s0, $v0
		
		# exit if row input is 0
		beq $s0, 0, exit
		
		jal promptBitsPerRow
		move $s1, $v0

		jal promptDesign
		move $s2, $v0

		jal draw
		
	promptRows:
		# prompt
		li $v0, 4
		la $a0, firstInputPrompt
		syscall
		
		# store user input in $v0
		li $v0, 5
		syscall
		
		# return to main
		jr $ra
		
	promptBitsPerRow:
		# prompt
		li $v0, 4
		la $a0, secondInputPrompt
		syscall
		
		# store user input in $v0
		li $v0, 5
		syscall
		
		# return to main
		jr $ra
		
		
	promptDesign:
		# prompt
		li $v0, 4
		la $a0, shapeInputPrompt
		syscall
		
		# store user input in $v0
		li $v0, 5
		syscall
		
		# return to main
		jr $ra
		
	errorCheck:
		# multiply rows by bits per row into $t0
		li $v0, 1
		mult $s0, $s1
		mflo $t0
			
		# if $t0 and inner loop total bit counter ($t6) are not equal, branch to error
		bne $t0, $t6, printError
		
		# exit the program
		j exit
		
	draw:	
		# start counter for outer loop
		li $t1, 0

		j outerLoop
		
		
	printError:
		# print error message
		li $v0, 4
		la $a0, errorMsg
		syscall
		
		# exit program
		j exit
			
	outerLoop:
		# if start counter > num rows, go to exit
		bge $t1, $s0, errorCheck
		
		# initialize inner loop counter
		li $t3, 0
		
		# move (bits per row * current row number) to $t0
		mul $t0, $s1, $t1
		
		# shift right by value in $t0
		srlv $t4, $s2, $t0
		
		# print new line
		li $v0, 4
		la $a0, newLine
		syscall
		
		# add one to outer loop start counter
		addi $t1, $t1, 1
		
		jal innerLoop
		
		# final outer loop run to facilitate branch instruction
		j outerLoop
		
	innerLoop:
	
		# apply mask into register $t5 to find LSB
		bge $t3, $s1, outerLoop
		
		# and $t4 into mask, $t5
		andi $t5, $t4, 0x1
		
		# shift $t4 into $t5 by 1
		srl $t4, $t4, 1
		
		addi $t3, $t3, 1
		# count bits for error checking
		addi $t6, $t6, 1
		
		# branch to printstar if lsb = 1
		bgt $t5, 0, printStar
		# branch to printSpace if lsb = 0
		beq $t5, 0, printSpace
		
	printStar:
		li $v0, 4
		la $a0, star
		syscall
		j innerLoop
		
	printSpace:
		li $v0, 4
		la $a0, space
		syscall
		j innerLoop
	
	exit:	
		
		# print new line
		li $v0, 4
		la $a0, newLine
		syscall
		
		# print exit prompt
		la $a0, exitPrompt
		li $v0, 4
		syscall
		
		# exit
		li $v0, 10
		syscall
	
	
	

###########################################################
# Assignment #: 5
#  Name: Pierce Renio
#  ASU email: prenio@asu.edu
#  Course: CSE/EEE230, your lecture time such as MWF 1:30pm
#  Description: An assembly language program to 
#	  		  -perform decision making using branch instructions.
#         		  -create loops
#         		  -use syscall operations to display integers and strings on the console window
#          		  -use syscall operations to read integers from the keyboard.
#			  -perform the functionality of the following C program (in canvas) and print the updated 
#			   array content, by listing each integer in it.
###########################################################

		.data
length:		.word	11
numbers:	.word	2, 19, 23, -7, 15, -17, 11, -4, 23, -26, 27
msg1:		.asciiz	"Enter an ending index:\n"
msg2:		.asciiz	"Enter an integer:\n"
msg3:		.asciiz	"Enter another integer:\n"
msg4:		.asciiz	"Result Array Content:\n"
space:		.asciiz "\n"
		.text
		.globl main
		
main:
#Prompting for ending index
	la $a0, msg1				#$a0 = address at msg1
	li $v0, 4
	syscall					#call print_string()
	
	li $v0, 5				
	syscall
	move $s0, $v0				#Moving value from $v0 to $s0 (Ending index)
	
#Prompting for integer	
	la $a0, msg2				#$a0 = address at msg2
	li $v0, 4
	syscall					#call print_string()
	
	li $v0, 5				
	syscall
	move $s1, $v0				#Moving value from $v0 to $s1 (First integer)
	
#Prompting for another integer
	la $a0, msg3				#$a0 = address at msg3
	li $v0, 4
	syscall					#call print_string()
	
	li $v0, 5				
	syscall
	move $s2, $v0				#Moving value from $v0 to $s2 (Another integer)


#Message for result
	la $a0, msg4				#$a0 = address at msg4
	li $v0, 4
	syscall					#call print_string()
	 
#Switching num1 and num2 if needed
	slt $t0, $s2, $s1
	bne $t0, $zero, Switch           	#If $s1 > $s2, jump to Switch
	
#Prepping the for loop
LoopPrep:
	la $s3, numbers				#Put address of numbers into $s3
	li $s4, 0				#$s4 (index j) = 0
	lw $s5, length				#$s5 = address of 11

#The for loop	
Loop:
	slt $t0, $s0, $s4			#If j > Ending Index, jump to Exit		
	bne $t0, $zero, ExitLoop
	sll $t1, $s4, 2				#$S3 = j x 4
	add $t2, $t1, $s3			#$t2 = base address + jx4
	lw $t3, 0($t2)				#$t3 = numbers[j]
	slt $t4, $s1, $t3			#If num1 < numbers[j], $t4 = 1, else: $t4 = 0
	bne $t4, $zero, Elseif			#If $t4 = 1, jump to Elseif
	j Print					#jump to Print
	
	
	
	
#The other part of the if statement in the for loop	
Elseif:
	slt $t5, $t3, $s2			#If numbers[j] < num2, $t5 = 1, else: $t5 = 0
	bne $t5, $zero, Change			#If $t5 = 1, jump to Change.
	j Print					#Jump to Print

#Changing number[j] if the conditions in the if statement are true
Change:
	mul $t6, $t3, $s1			#$t6 = numbers[j]*num1
	add $t3, $t6, $s2			#$t7 = $t6 + num2
	jal  Print				#Jump to Print
	
Switch:						#Switching the values of num1 and num2
	addi $t0, $s2, 0
	la $s2, ($s1)
	la $s1, ($t0)
	la $ra, LoopPrep			#Jump to loop prep
	jr $ra	
	
Print:
	move $a0, $t3				#$a0 = $t3
	li $v0, 1	
	syscall					#Print int
	la $a0, space				#$a0 = address at space
	li $v0, 4
	syscall					#call print_string()
	slt $t0, $s0, $s4			#If j > Ending Index, jump to Exit		
	bne $t0, $zero, ExitLoop
	addi $s4, $s4, 1			#j=j+1
	jal Loop				#Jump back to loop
ExitLoop:	
	sll $t1, $s4, 2				#$S3 = j x 4
	add $t2, $t1, $s3			#$t2 = base address + jx4
	lw $t3, 0($t2)				#$t3 = numbers[j]
	move $a0, $t3				#$a0 = $t3
	li $v0, 1	
	syscall					#Print int
	la $a0, space				#$a0 = address at space
	li $v0, 4
	syscall					#call print_string()	
	addi $s4, $s4, 1			#j=j+1
	bne $s4, $s5, ExitLoop
	j Exit
Exit:
	li $v0 10
	syscall
	

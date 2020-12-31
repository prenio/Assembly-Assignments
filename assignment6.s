###########################################################
# Assignment #: 6
#  Name: Pierce Renio
#  ASU email: prenio@asu.edu
#  Course: CSE/EEE230, your lecture time such as MWF 1:30pm
#  Description: An assembly language program to 
#	  		  -perform decision making using branch instructions.
#         		  -create loops
#         		  -use syscall operations to display integers and strings on the console window
#          		  -use syscall operations to read integers from the keyboard.
#			  -Implement a MIPS assembly language program that defines main, readArray, printArray, and changeArrayContent procedures/functions.
#			  -The readArray takes an array of integers as its parameter, asks a user how many numbers will  be entered, then reads in integers from a user to fill the array.
#			  -The printArray takes an array of integers as its parameter, prints each integer of the array.
#			  -The changeArrayContent procedure/function takes parameters of arrays of integers,  an integer that specify how many integers were entered by a user, a maximum
# 				array size, and also asks a user to enter an integer. Then it goes through each element of the array, and check if it is divisible by the entered integer, it multiplies it by the entered integer. Then it calls printArray to print out the changed content.  (Please see the C program below).
#			  -The main procedure/function calls readArray function to populate the array, calls printArray to print out its original content, then it asks a user to enter how many times the operation should be repeated, then calls changeArrayContent to change it content,
			  # parameters: $s0 = address of array , $a1 = size
# 				return value: $v0 = length
# 				registers to be used: $s3 and $s4 will be used.
###########################################################
		.data
numbers:	.word	0,0,0,0,0,0,0,0,0,0,0
specifyArray:	.asciiz	"Specify how many numbers should be stored in the array (at most 11):\n"
enter:		.asciiz "Enter an integer:\n"
originalArray:	.asciiz "Original Array Content:\n"
specifyRepeat:	.asciiz	"Specify how many times to repeat:\n"
resultArray:	.asciiz "Result Array Content:\n"
space:		.asciiz "\n"
		.text
		.globl main
		
main:
#Base address of array
	la $s0, numbers
	li $s4, 0
	li $a3, 0				#i = 0
	li $s4, 0

#Prompting for length
	la $a0, specifyArray			#$a0 = address at specifyArray
	li $v0, 4
	syscall					#call print_string()
	
	li $v0, 5				
	syscall
	move $a1, $v0				#Moving value from $v0 to $a1 (length)
	jal ReadArray				#Jump to readArray
main2:	
	bne $s4, $zero, End
	bne $a3, $zero, ChangeArray		#If in process of changing arrays, proceed to change again			
	la $a0, specifyRepeat			#$a0 = address at specifyRepeat
	li $v0, 4
	syscall					#call print_string()
	li $v0, 5				
	syscall
	move $a2, $v0				#Moving value from $v0 to $a2 (howMany)
	j ChangeArray				#Jump to changeArray



ReadArray:
	li $t0, 0				#int i = 0
	li $t2, 11				#arraySize = 11
	add $t8, $a1, -1
	slt $t1, $t8, $t0			#$t1 = 1 if i > length
	bne $t1, $zero, PrintArray		#If $t1 = 1, jump to printArray (end of length)
	beq $t0, $t2, PrintArray		#If i = 11, jump to printArray(end of array size)
	
#If while look checks out, prompt for integer	
	la $a0, enter				#$a0 = address at enter
	li $v0, 4
	syscall					#call print_string()
	
	li $v0, 5				
	syscall
	move $t6, $v0				#Moving value from $v0 to $t6 (integer)
#Storing value in array
	sll $t3, $t0, 2				#i x 4 = $t3   
	add $t4, $t3, $s0			#$t4 = base addresss + $t3
	lw  $t5, 0($t4)				#Storing the value from the array into $t5 to manipulate it
	add $t7, $t5, $t6			#$t7 = array(should be 0 first) + $t6(input value)
	sw  $t7, 0($t4)				#array[i] = $t4
	addi $t0, $t0, 1			#i++
	la $ra, ReadArray
	addi $ra, $ra, 12
	jr $ra					#Jump back to the the first slt
	
	
PrintArray:
	li $t0, 0				#i = 0
	la $a0, originalArray			#$a0 = address at originalArray
	li $v0, 4
	syscall					#call print_string()
	li $t2, 11				#arraySize = 11
	add $t6, $a1, -1
#While loop
	slt $t1, $t6, $t0			#$t1 = 1 if i > length
	bne $t1, $zero, main2			#If $t1 = 1, jump to main2 (end of length)
	beq $t0, $t2, main2			#If i = 11, jump to main2(end of array size)
#Printing integer
	sll $t3, $t0, 2				#i x 4 = $t3   
	add $t4, $t3, $s0			#$t4 = base addresss + $t3
	lw  $t5, 0($t4)				#Storing the value from the array into $t5 to manipulate it
	move $a0, $t5				#Moving value from $t5 to $a0
	li $v0, 1
	syscall					#Print integer
	la $a0, space
	li $v0, 4
	syscall					#Print new line
	addi $t0, $t0, 1			#i++
	la $ra, PrintArray
	addi $ra, $ra, 24
	jr $ra					#Jump back to the the first slt
	

#Changing Array
ChangeArray:
#Loop for howMany
	slt $t1, $a3, $a2			#$t1 = 1 if $a3 < $a2 [1-2]
	beq $t1, $zero, End			#If #t0 < $a2, break loop and print array
#"Enter an integer"
	la $a0, enter				#$a0 = address at enter
	li $v0, 4
	syscall					#call print_string()
	li $v0, 5				
	syscall
	move $s3, $v0				#Moving value from $v0 to $s3 (integer)

#Loop for changeArrayContent
	li $s2, 0				#i(index inside changeArray) = 0
	li $t4, 11
Loop:
	add $t3, $a1, -1			#$t3 = length
	slt $t1, $t3, $s2			#$t1 = 1 if i > length  [3-14]
	bne $t1, $zero, AddIndexHowMany			
	beq $s2, $t4, AddIndexHowMany			
	
#Change array contents
	sll $t5, $s2, 2				#Start index at 0, move up 1 as i increases
	add $t6, $t5, $s0
	lw $t7, 0($t6)
	div $t7, $s3				#Checking if array[i] is divisible by num1
	mfhi $t8				#Storing remainder in $t8
	bne $t8, $zero, AddIndex		#If remainder is not zero, repeat array loop[compute steps to 4]	
	mult $t7, $s3				#$t9 = array[i]*num1
	mflo $t9
	sw $t9, 0($t6)				#array[i] = $t9
AddIndex:
	addi $s2, $s2, 1			#j++  [4-28]
	j Loop
AddIndexHowMany:
	addi $a3, $a3, 1			#i++	[5-33]
	beq $a3, $a2, BreakLoop
	j PrintArray

BreakLoop:
	li $s4, 1				#Set $s4 = 1 to break loop when it jumps to PrintLoop
	j PrintArray

End:
	li $v0 10
	syscall

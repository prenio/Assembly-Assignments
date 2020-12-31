###########################################################
# Assignment #: 2
#  Name: Pierce Renio
#  ASU email: prenio@asu.edu
#  Course: CSE/EEE230, your lecture time such as MWF 1:30pm
#  Description: An assembly language program to 
#	     -perform arithmetic and logical operations on variables
#            -use syscall operations to display integers and strings on the console window
#            -use syscall operations to read integers from the keyboard.
###########################################################

	.data 
msg1:	.asciiz "Enter a value:\n"		#Prompts for entering a value
msg2:	.asciiz "Enter another value:\n"
msg3:	.asciiz "Enter one more value:\n"	
equ1:	.asciiz	"num4+num1="			#Strings to display equations
equ2:	.asciiz	"\nnum1-num2="
equ3:	.asciiz	"\nnum4*num2="
equ4:	.asciiz	"\nnum1/num3="
equ5:	.asciiz	"\nnum3 mod num1="
equ6:	.asciiz	"\n((((num2 mod 4) + num3) * 2) / num4) + num1="
	.text
	.globl main
	
main:
#First prompt
	la $a0, msg1				#$a0 = address at msg1
	li $v0, 4
	syscall					#call print_string()
	
	li $v0, 5				
	syscall
	move $s0, $v0				#Moving value from $v0 to $s0
	
#Second promt
	la $a0, msg2				#$a0 = address at msg1
	li $v0, 4
	syscall					#call print_string()
	
	li $v0, 5		
	syscall
	move $s1, $v0				#Moving value from $v0 to $s1
	
#Third prompt
	la $a0, msg3				#$a0 = address at msg3
	li $v0, 4
	syscall					#call print_string()
	
	li $v0, 5				
	syscall
	move $s2, $v0				#Moving value from $v0 to $s2
	
#Fourth prompt
	la $a0, msg3				#$a0 = address at msg3
	li $v0, 4
	syscall					#call print_string()
	
	li $v0, 5				
	syscall
	move $s3, $v0				#Moving value from $v0 to $s3

#First equation
	la $a0, equ1				#$a0 = address at equ1
	li $v0, 4
	syscall					#Calling print_string()
	
	add $t0, $s3, $s0			#$t0 = $s3 + $s0
	add $a0, $t0, 0				#$a0 = $t0
	li $v0, 1
	syscall					#Calling print_int()


#Second equation
	la $a0, equ2				#$a0 = address at equ2
	li $v0, 4
	syscall					#Calling print_string()
	
	sub $t1, $s0, $s1			#$t1 = $s0 - $s1
	add $a0, $t1, 0				#$a0 = $t1
	li $v0, 1
	syscall					#Calling print_int()


#Third equation
	la $a0, equ3				#$a0 = address at equ3
	li $v0, 4
	syscall					#Calling print_string()
	
	mult $s3, $s1				#$t2 = $s3 * $s1
	mflo $t2				#Lower 32 bits of result
	add $a0, $t2, 0				#$a0 = $t2
	li $v0, 1
	syscall					#Calling print_int()
	
	
#Fourth equation
	la $a0, equ4				#$a0 = address at equ4
	li $v0, 4
	syscall					#Calling print_string()
	
	div $s0, $s2				#$t2 = $s0 / $s2
	mflo $t3				#Lower 32 bits of result
	add $a0, $t3, 0				#$a0 = $t3
	li $v0, 1
	syscall					#Calling print_int()
	
	
#Fifth equation
	la $a0, equ5				#$a0 = address at equ5
	li $v0, 4
	syscall					#Calling print_string()
	
	div $s2, $s0				#$t2 = $s2 mod $s0
	mfhi $t4				#Higher 32 bits of result
	add $a0, $t4, 0				#$a0 = $t4
	li $v0, 1
	syscall					#Calling print_int()
	
	
#Sixth equation
	la $a0, equ6				#$a0 = address at equ6
	li $v0, 4
	syscall					#Calling print_string()
	
	li $t6, 4				#$t6 = 4
	div $s1, $t6				#$t5 = $s1 mod $t6
	mfhi $t5				#Higher 32 bits of result
	add $t5, $t5, $s2			#$t5 = $t5 + $s2
	li $t6, 2				#$t6 = 5
	mult $t5, $t6				#$t5 = $t5 * 5
	mflo $t5				#Lower 32 bits of result
	div $t5, $s3				#$t5 = $t5 / $s3
	mflo $t5				#Lower 32 bits of result
	add $a0, $t5, $s0			#$a0 = $t5 + $s0
	li $v0, 1
	syscall					#Calling print_int()
	
	jr $ra


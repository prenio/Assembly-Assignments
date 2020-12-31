###########################################################
# Assignment #: 2
#  Name: Pierce Renio
#  ASU email: prenio@asu.edu
#  Course: CSE/EEE230, your lecture time such as MWF 1:30pm
#  Description: An assembly language program to 
#	    -load addresses of variables or values of variables into registers.
#           -perform arithmetic and logical operations on variables
#           -use syscall operations to display integers and strings on the console window
###########################################################
	
	
	.data
msg1:	.asciiz "num1 is: "	#Setting up the messages
msg2:	.asciiz "\nnum2 is: "
msg3:	.asciiz "\nnum1+num2 = "
msg4:	.asciiz "\nnum1-num2 = "
num1:	.word	91543		#Setting up the numbers to use
num2:	.word 	0xD8C
	.text
	.globl main
	
main:
	la $a0, msg1
	li $v0, 4		#$v0 = 4
	syscall			#print_string()
	
	lw $a0, num1
	li $v0, 1		#$v0 = 1
	syscall 		#print_int()
	
	
	la $a0, msg2
	li $v0, 4		#$v0 = 4
	syscall			#print_string()
	
	lw $a0, num2
	li $v0, 1		#$v0 = 1
	syscall 		#print_int()
	
	
	la $a0, msg3
	li $v0, 4		#$v0 = 4
	syscall			#print_string()
	
	lw $t0, num1		#$t0 = 91543
	lw $t1, num2		#$t1 = 0xD8C (3468)
	add $t2, $t0, $t1	#$t2 = $t0 + $t1
	sub $t3, $t0, $t1	#$t3 = $t0 - $t1
	
	add $a0, $t2, 0		#$a0 = $t2
	li $v0, 1		#$v0 = 1
	syscall			#print_int()
	
	la $a0, msg4
	li $v0, 4		#$v0 = 4
	syscall			#print_string()
	
	add $a0, $t3, 0		#$a0 = $t3
	li $v0, 1		#$v0 = 1
	syscall			#print_int()
	
	jr $ra
	
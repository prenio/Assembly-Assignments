###########################################################
# Assignment #: 1
#  Name: Pierce Renio
#  ASU email: prenio@asu.edu
#  Course: CSE/EEE230, your lecture time such as MWF 1:30pm
#  Description: This is my first assembly language program.
#                         It prints "Hello world".
###########################################################

		.data
msg1:	.asciiz "Hello world.\n"
msg2:	.asciiz "Goodbye world.\n"
msg3:	.asciiz "This is my first MIPS program.\n"

		.text
		.globl main

main:


	la 	$a0, msg1
	li 	$v0, 4
	syscall

	la 	$a0, msg2
	li 	$v0, 4
	syscall

	la 	$a0, msg3	
	li 	$v0, 4
	syscall
	
	jr	$ra
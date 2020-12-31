###########################################################
# Assignment #: 7
#  Name: Pierce Renio
#  ASU email: prenio@asu.edu
#  Course: CSE/EEE230, your lecture time such as MWF 1:30pm
#  Description: An assembly language program to 
#	  		  -perform decision making using branch instructions.
#         		  -create loops
#         		  -use syscall operations to display integers and strings on the console window
#          		  -use syscall operations to read integers from the keyboard.
#			  -defines "main", and "function1" procedures.
###########################################################
		.data
enter:		.asciiz	"Enter an integer:\n"
solution:	.asciiz "The solution is:\n"
		.text
		.globl main
				
############################################################################
# Procedure/Function main
# Description: prints out prompts for the user and then calls function1
# parameters: $a0 = n value
# return value: $v0 = computed value
# registers to be used: $s3 and $s4 will be used.
############################################################################
main:
		la $a0, enter			#$a0 = address at enter
		li $v0, 4
		syscall				#call print_string()  
		
		li $v0, 5				
		syscall
		move $a0, $v0			#Moving value from $v0 to $a0 (n)
		jal function1
		move $t0, $v0
		
		
		
		la $a0, solution		#$a0 = address at solution
		li $v0, 4
		syscall				#call print_string()  
		
		move $a0, $t0
		li $v0, 1
		syscall					#Print integer
		li $v0 10
		syscall
############################################################################
# Procedure/Function function1
# Description: Recursivly computes the new value given the input
# parameters: $a0 = n value
# return value: $v0 = computed value
# registers to be used: $s3 and $s4 will be used.
############################################################################
function1:
		addi $sp, $sp, -32		#stack space
		sw $fp, 0($sp)			#save caller's frame pointer
		sw $ra, 4($sp)			#save return address
		addi $fp, $sp, 20		#setup frame pointer
		
		addi $t0, $a0, 0		#Save n
		sw $t0, 24($sp)			#Storing n on the stack
		li $t2, 3
		slt $t1, $t2, $t0		#If n > 3
		beq  $t1, $zero, base		#If n <= 3, jump to base
		
		addi $a0, $t0, -1		#$a0 =  n-1
		jal function1			#function1(n-1) call
		sw $v0, 28($sp)			#Storing the value from the $v0 into the stack
		lw $t0, 24($sp)
		addi $a0, $t0, -3
		jal function1			#function1(n-3) call
		
		lw $t0, 24($sp)			#n
		lw $t1, 28($sp)			#value of function(n-1)
		div $t1, $t0			
		mflo $t2			#function(n-1)/n
		mult $t0, $v0
		mflo $t3			#n * function(n-3)
		li $t4, 4
		mult $t0, $t4			#4 * n
		mflo $t5
		add $t6, $t3, $t5		#(n*function(n-3) + 4n)
		add $v0, $t6, $t2		#function(n-1)/n + n*function(n-3) + 4n
		j return
		
		
		
		
		
		
		base:
		li $t1, 5			#$t3 = 5
		mult $t1, $t0			# num  * 5
		mflo $t1
		addi $v0, $t1, 14		# ans1 = 5*n + 14
		
		return:
		lw $ra, 4($sp)			# get return address from stack
   		lw $fp, 0($sp) 			# restore the caller’s frame pointer
    		addi $sp, $sp, 32 		# restore the caller’s stack pointer
   		jr $ra 				# return to caller’s code
		
		
		 
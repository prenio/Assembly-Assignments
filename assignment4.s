###########################################################
# Assignment #: 4
#  Name: Pierce Renio
#  ASU email: prenio@asu.edu
#  Course: CSE/EEE230, your lecture time such as MWF 1:30pm
#  Description: An assembly language program to 
#	     -perform arithmetic and logical operations on variables
#            -use syscall operations to display integers and strings on the console window
#            -use syscall operations to read integers from the keyboard.
#	     - that reads a customer's current and previous meter readings 
#              of electricity and a month to compute its electricity bill.
###########################################################
	
	.data
new:	.asciiz "Please enter the new electricity meter reading:\n"		#Prompts for entering the electricity meter reading/month
old:	.asciiz "Please enter the old electricity meter reading\n"
month:	.asciiz "Please enter a month to compute the electricity bill,\nUse an integer between 1 and 12(1 for January, etc.):\n"
bill1:	.asciiz "Your total bill amount for this month: "
bill2:	.asciiz " dollar(s) for "
bill3:	.asciiz " KWH\n"
nobill: .asciiz "No bill to pay this month.\n"
	.text
	.globl main
	
main:
#New Reading
	la $a0, new				#$a0 = address at new
	li $v0, 4
	syscall					#call print_string()
	
	li $v0, 5				
	syscall
	move $s0, $v0				#Moving value from $v0 to $s0 (New reading)

#Old Reading
	la $a0, old				#$a0 = address at new
	li $v0, 4
	syscall					#call print_string()
	
	li $v0, 5				
	syscall
	move $s1, $v0				#Moving value from $v0 to $s1 (Old reading)
	
#Month
	la $a0, month				#$a0 = address at new
	li $v0, 4
	syscall					#call print_string()
	
	li $v0, 5				
	syscall
	move $s2, $v0				#Moving value from $v0 to $s2 (Month)
	
#Calculations
	sub $s3, $s0, $s1			#$s3(KWHforMonth) = $s0 - $s1
	slti $t0, $s3, 1			#If $s3 < 1, $t0 = 1, else, $t0 = 0
	bne $t0, $zero, Nobill
	
	slti $t0, $s3, 251			#If $s3 < 251, $t0 = 1, else, $t0 = 0
	bne $t0, $zero, TwentyFive		#Jump to TwentyFive if $t0 = 1
	
	slti $t0, $s2, 6			#If $s2 < 6, $t0 = 1, else, $t0 = 0
	bne $t0, $zero, Normal			#Jump to Normal
	slti $t0, $s2, 9			#Else if $s2 < 9, $t0 = 1, else, $t0 = 0
	bne $t0, $zero, Summer			#Jump to Summer
	j	Normal 				#Else, jump to normal
	
	
	
#Jump here if KWHforMonth is <= 0.
Nobill:
	la $a0, nobill				#$a0 = address at nobill
	li $v0, 4
	syscall					#call print_string()
	jr $ra
#Jump here if KWHforMonth is <= 250.
TwentyFive:
	li $s4, 25				#$s4(bill) = 25
	j	End				#Jump to end

#Jump here if "normal" conditions		
Normal:
	addi $t1, $s3, -250			#$t1 = KWHforMonth - 250
	li $t2, 20				#$t2 = 20
	div $t1, $t2				#$t3 = $t1/$t2
	mflo $t3
	addi $s4, $t3, 25			#$s4 = $t3 + 25
	j	End				#Jump to end
					
#Jump here if summer month (month = 6,7,8)
Summer:
	addi $t1, $s3, -250			#$t1 = KWHforMonth - 250
	li $t2, 18				#$t2 = 20
	div $t1, $t2				#$t3 = $t1/$t2
	mflo $t3
	addi $s4, $t3, 25			#$s4 = $t3 + 25
	j	End				#Jump to end
					



End:
	la $a0, bill1				#$a0 = address at bill1
	li $v0, 4
	syscall					#call print_string()

	add $a0, $s4, 0				#Moving $s4(bill) to $a0 to print
	li $v0, 1
	syscall
	
	la $a0, bill2				#$a0 = address at bill2
	li $v0, 4
	syscall					#call print_string()

	add $a0, $s3, 0				#Moving $s3(KWHforMonth) to $a0 to print
	li $v0, 1
	syscall
	
	la $a0, bill3				#$a0 = address at bill3
	li $v0, 4
	syscall					#call print_string()
	jr $ra


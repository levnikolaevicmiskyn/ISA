#################
# Basic VERSION	
# This program takes an array v and computes
# min{|v[i]|}, the minimum of the absolute value,
# where v[i] is the i-th element in the array
	.data
	.align	2
v:
	.word	10
m:
	.word	5

	.text
	.align	2
	.globl	__start
__start:
	la x4,v			# put in x4 the address of v
	la x5,m      		# put in x5 the address of m
	
	lw x8,0(x4)   		# load v in x8
	lw x9,0(x5)		# load m in x9
	
	add x9,x9,x8    	# x9 = x9 + x8
	
	sw x9,0(x5)  		# store the result	

endc:
	jal endc		# infinite loop
	nop
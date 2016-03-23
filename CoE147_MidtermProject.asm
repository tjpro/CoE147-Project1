#University of Pittsburgh
#COE-147 Project Euler 150
#Instructor: Samuel J. Dickerson
#Teaching Assistants: Shivam Swami (shs173) and Bonan Yan (boy12)
#-------------------------------------------------------------------------------------------------


#Submitted by: Tyler Protivnak, Zachary Adam, Signe Ruprecht



.include "Test1.asm"   #Change the name of the test_file to try different test cases

# In the test_file data is arranged as follows:
# 1) Data is at a location with label 'test'
# 2) The first word pointed by the 'test' variable is the depth of the triangle
# 3) The words following the 'depth' are the elements of the triangle
# 4) The array carries depth*(depth+1)*0.5 number of elements
# 5) Each element is stored as a word (refer Test1.asm).
# 6) Save your final answer in register $a0
# Good Luck!

.data
pass_msg: .asciiz "PASS"
fail_msg: .asciiz "FAIL"
#-------------------------------------------------------------------------------------------------
.data
rowSums: .word 0

.text
	la 	$s0,test #address of test data
	lw 	$s1,0($s0) #number of rows 
	addi 	$s0, $s0,4 #shifts test data to get rid of first val(# of rows)

	la 	$s2,rowSums #address of rowSums

	rSumsOuter: #loop for calculating row sums 

		#calculating(i*(i+1)/2)
		addi 	$t1,$t0,1 # $t1 gets count+1
		mul 	$t1,$t1,$t0 #multiply t1 by count
		sll 	$t1,$t1,1 #multiply t1 by 2

		add 	$t2,$s0,$t1 #gets address test[i*(i+1)/2)]
		add 	$t3,$s2,$t1 #gets address rowSums[i*(i+1)/2)]

		lw 	$t4,0($t2) #gets value in test
		sw 	$t4,0($t3) #stores it in rowSums
#=============================================================================================
		addi 	$t5,$t1,4 #initializes count to i*(i+1)/2)+1

		sll 	$t9,$t0,2
		add 	$t6,$t9,$t1 #base case is i*(i+1)/2)+i

		rSumsInner:

			subi 	$t7,$t5,4 #count - 1

			add 	$s3,$s0,$t5 #data[j] address
			add 	$s4,$s2,$t7 #rowSums[j-1] address
			add 	$s7,$s2,$t5 #rowSums[j] address

			lw 	$s5,0($s3)
			lw 	$s6,0($s4)

			add 	$t8,$s6,$s5 #add rowSums[j-1]+data[j] address

			sw 	$t8,0($s7)

			addi 	$t5,$t5,4 #iterate

			slt 	$t8,$t6,$t5
			beq 	$t8,1,iter

			j rSumsInner
#=============================================================================================
		iter:
		addi 	$t0,$t0,1 #add one to count
		li 	$t1,0 #resets i*(i+1)/2)
		li 	$t2,0 #resets address of test
		li 	$t3,0 #resets  address of rowSums
		li 	$t4,0 #resets value of test

		beq 	$s1,$t0,exit #exit loop if count is equal to row sums
		j rSumsOuter

	exit:


	addi 	$v0, $0, 0 #v0 = minSum 
	addi 	$t0, $0, 0
	addi 	$t1, $0, 0

	ApexLoop: #loop for calculating row sums 

		#calculating(i*(i+1)/2)
		addi	$t1,$t0,1 # $t1 gets count+1
		mul 	$t1,$t1,$t0 #multiply t1 by count
		sll 	$t1,$t1,1 #multiply t1 by 2

#=============================================================================================

		sll 	$t9,$t0,2
		add 	$t6,$t9,$t1 #base case is i*(i+1)/2)+i
		ApexInner:
			add 	$a0, $t0, $0 #Set curSum = 0
			add 	$a1, $t1, $0 #Set count2 = j
			add 	$a2, $t0, $0 #Set k = i

#=============================================================================================
			#Inner most loop 
			li 	$a0, 0 
			MostInnerFor:

				add 	$a3, $0, $0 #Reset array place value
				beq 	$s1, $a2, endInnerMost # for loop test condition ie (k<ROWS)

				#calculating(i*(i+1)/2)
				addi 	$t5,$t0,1 # $t1 gets count+1
				mul 	$t5,$t5,$t0 #multiply t1 by count
				sll 	$t5,$t5,1 #multiply t1 by 2

				beq 	$t1, $t5, ifBranch

				#This is the else statement of the code
				#Do rowSum[count]
				add 	$a3, $s2, $a1 #set proper address to get rowSum[count]
				lw 	$a3, ($a3)#get the value at rowSum[count]
				add 	$a0, $a0, $a3 #add the value from rowSum[count] to curSum

				add 	$a3, $0, $0 #Reset array place value

				#Do rowSum[count-(k-i+1)]
				sll 	$t0, $t0, 2
				sll 	$a2, $a2, 2
				sub 	$a3, $a2, $t0
				add 	$a3, $a3, 4
				sub 	$a3, $a1, $a3
				add 	$a3, $s2, $a3 #set proper address to get rowSum[count-(k-i+1)]
				lw 	$a3, ($a3)#get the value at rowSum[count-(k-i+1)]
				sub 	$a0, $a0, $a3 #sub the value from rowSum[count-(k-i+1)] from curSum
				srl 	$t0, $t0, 2
				srl 	$a2, $a2, 2

				ContinueLoop:
				slt 	$v1, $a0, $v0
				beq 	$v1, $0, NotLessThan
				add 	$v0, $a0, $0

				NotLessThan:
				sll 	$a2, $a2, 2
				addi 	$a2, $a2, 8
				add 	$a1, $a1, $a2
				subi 	$a2, $a2, 8
				srl 	$a2, $a2, 2
				addi 	$a2, $a2, 1

				j MostInnerFor
				
				ifBranch:
				add 	$a3, $s2, $a1 #set proper address to get rowSum[count]
				lw 	$a3, ($a3)#get the value at rowSum[count]
				add 	$a0, $a0, $a3 #add the value from rowSum[count] to curSum
				j ContinueLoop
			#End inner most loop
#=============================================================================================
			endInnerMost:
			addi 	$t1,$t1,4 #iterate
			slt 	$t8,$t6,$t1
			beq 	$t8,1,iter2

			j ApexInner
#=============================================================================================
		iter2:
		addi 	$t0,$t0,1 #add one to count
		li 	$t1,0 #resets i*(i+1)/2)
		li 	$t2,0 #resets address of test
		li 	$t3,0 #resets  address of rowSums
		li 	$t4,0 #resets value of test
		li 	$a0, 0
		li 	$a3, 0
		li 	$a1, 0
		li 	$a2, 0
		li 	$v1, 0

		addi 	$a3, $t0, -1
		beq 	$s1,$a3, exit2 #exit loop if count is equal to row sums
		j ApexLoop

	exit2:
	add 	$a0, $v0, $0 #Stored value in v0 by accident so this just puts v0 into a0.

#---------Do NOT modify anything below this line---------------
lw $s0, sol
beq $a0, $s0 pass
fail:
la $a0, fail_msg
li $v0, 4
syscall
j end
pass:
la $a0, pass_msg
li $v0, 4
syscall
end:
#-----END---------------------------------------------------------

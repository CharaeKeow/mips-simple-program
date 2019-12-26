    .data
groupName: .asciiz "Group Three"
groupMember: .asciiz "\nGroup Member: \n
                      1.Maheshwarman A/L Balakrishnan\n
                      2. Muhammad Tariq Ali bin Salamudeen Alin\n
                      3. Charae A/L Eh Sin\n"  
space: .asciiz " "
sortedNumber: .asciiz "\nThe sorted array are:\n"
promptInput: .asciiz "\nEnter 20 random positive number: "
input: .asciiz "num: "
sumOutput: .asciiz "\n\nSum: "
averageOutput: .asciiz "\nAverage: " 
listLessThanAverage: .asciiz "\nThe list of number less than average: \n"
listMoreThanAverage: .asciiz "\nThe list of number more than average: \n"
listEvenNumber: .asciiz "\nThe list of even number: \n"
listOddNumber: .asciiz "\nThe list of odd number: \n"
highestTimesLowest: .asciiz "\nThe multiplication of highest and lowest number: "
highestDivideByLowest: .asciiz "\nThe division of highest and lowest number: "
listOfProgrammingTechniqueUsed: .asciiz "\nThe list of programming technique used: \n
                                         1. Array\n
                                         2. Selection (if else)\n
                                         3. Repition (loop)\n
                                         4. Sequence\n"

    .text
    .globl main
main: 
    #display group name
    li      $v0, 4
    la      $a0, groupName
    syscall

    #display group member
    li      $v0, 4
    la      $a0, groupMember
    syscall

    ori     $s2, $0, 0 #sum of input
    ori     $s5, $0, 0 #loop counter

    #initiliaze address to store the input (1000000), which is 
    #kinda the first index of the array. This address 
    #will then be incremented in the loop. Well, I miss
    #my classic for...loop T_T
    lui     $s6, 0x1000
    ori     $s6, $s6, 0000

getInput:
    #$s5 == 0. Check if it is less than 6. If yes, assign $s1 = 6, else it will be 0
    slti    $s0, $s5, 20 #20 times #test, 3 times
    beq     $s0 $0, sort #if ($s1 == 0) { sum }

    #prompt user input asking to enter 20 positive numbers
    li      $v0, 4
    la      $a0, promptInput
    syscall

    li      $v0, 4
    la      $a0, input
    syscall

    #read the console input and move it to $8.
    li      $v0, 5
    syscall
    move    $t0, $v0

    sw      $t0, 0($s6)
    addu    $s2, $s2, $t0 #$s2 += $t0

    addi    $s5, $s5, 1 #increment counter
    addi    $s6, $s6, 4 #increment the memory location
    j       getInput #jump back to branch

#And here, ladies and gentlemen, is the most tricky part :(
sort: 

    ori     $s4, $s4, 0 #loop counter for outer loop
    #ori     $s5, $s5, 0 #loop counter for inner loop

    #reinitialize $s0 to 0 (just in case)
    ori     $s0, $s0, 0

outerLoop:

    #Note: the address will also need to be reinitialize again
    #as they will surely be tempered in the inner loop

    #reinitialize (reuse) $s6 to first index of the array
    #1000000
    lui     $s6 0x1000
    ori     $s6, $s6 0000

    ori     $s5, $0, 0 #loop counter for inner loop

    #for simplicity's sake, this is use to 
    #hold the next address of the array (for comparison)
    #lui     $s7 0x1000
    #ori     $s7, $7 0004

    #the outer loop
    #for (int i = 0; i < n -1; i++)
    slti    $s0, $s4, 19     
    beq     $s0 $0 printSortedNumber #if $s0 == 0 (end) -> goto sum

    j       innerLoop
    #ori     $t8, $t8, 0 #set this == 0, which is false    

innerLoop:

    #inner loop
    #for (int j = 0; j < n - i -1; i++)     
    
    ori     $t1, $0, 20 #int n = 3
    ori     $t6, $0, 1 #$t6 = 1

    sub     $t1, $t1, $s4 #n = n - i
    sub     $t1, $t1, $t6 #n - 1 (So, in total: n = n - i - 1)  

    #slt     $t0, $s5, $t1 #j < n - i - 1 
    #beq     $t0, $t6, loadWord 
    #beq     $t0 $0 incrementOuterLoop #if ($s0 == 0) go to outerloop   
    #j       loadWord
    
    #if j == n - i -1 , jump to incrementOuterLoop
    beq     $s5, $t1, incrementOuterLoop

loadWord:

    lw      $t2, 0($s6) #load this index into temp $t2
    lw      $t3, 4($s6) #load this index + 1 into temp $t3

    slt     $s0, $t3, $t2 #$t3 < $t2 ? 1 : 0
    #beq    $t5, $t6, swapTrue #if true, jump to swapTrue - ie swap the index 
    #beq    $t5, $0, incrementInnerLoop #else if false, go to increment

    bne     $s0, $0, swapTrue #if $s0 != 0
    beq     $s0, $0, incrementInnerLoop #if $s0 == 0

swapTrue:
    sw      $t3, 0($s6) 
    sw      $t2, 4($s6)

    j       incrementInnerLoop

incrementInnerLoop: 
    addi    $s5, $s5, 1 #j++
    addi    $s6, $s6, 4 #$s6 += 4 
    #addi    $s7, $s7, 4 #$s7 += 4

    j       innerLoop

incrementOuterLoop:
    addi    $s4, $s4, 1 #i++

    j       outerLoop

printSortedNumber:

    #inform user
    li      $v0, 4
    la      $a0, sortedNumber
    syscall 

    lui     $s7, 0x1000
    ori     $s7, $s7, 0000

    #average is stored in $s1, so
    #use for loop, again, lw number one by one
    #then compare with average
    #if less than, print immediately!

    ori     $s5, $0, 0 #loop counter 
    ori     $t0, $0, 1 #for if true

print:

    slti    $s0, $s5, 20
    beq     $s0, $0, sum

    lw      $t1, 0($s7)

    move    $a0, $t1
    li      $v0, 1
    syscall

    #print stupid space
    li      $v0, 4
    la      $a0, space 
    syscall

    addi    $s5, $s5, 1
    addi    $s7, $s7, 4

    j		print
    
sum: 
    #inform user
    li      $v0, 4
    la      $a0, sumOutput
    syscall

    #Move $s2 to be printed
    move    $a0, $s2
    li      $v0, 1
    syscall

    j       average #jump to average

average:

    #print info first
    li      $v0, 4
    la      $a0, averageOutput
    syscall

    ori $t0, $0, 20 #total num in array

    #total / num in array
    div     $s2, $t0
    mflo    $s1 #quotient
    #mfhi   $s1 #remainder (not used here)

    #print output
    move    $a0, $s1 #move results into $a0 to be printed
    li      $v0, 1
    syscall

    #print info first
    li      $v0, 4
    la      $a0, listLessThanAverage
    syscall

    lui     $s6, 0x1000
    ori     $s6, $s6, 0000

    #average is stored in $s1, so
    #use for loop, again, lw number one by one
    #then compare with average
    #if less than, print immediately!

    ori     $s5, $0, 0 #loop counter 
    ori     $t0, $0, 1 #for if true

checkLessThanAverage:

    slti    $s0, $s5, 20 # i < 3
    beq     $s0, $0, reinitialize #if no

    lw      $t1, 0($s6) #load from mem
    
    slt     $t2, $t1, $s1 #check if $t1 < average ? 1 : 0
    beq     $t2, $t0, printLessThanAverage

    addi    $s5, $s5, 1 #increment counter
    addi    $s6, $s6, 4 #increment address
    j       checkLessThanAverage

printLessThanAverage: 
    li      $v0, 1
    move    $a0, $t1
    syscall

    #print stupid space
    li      $v0, 4
    la      $a0, space 
    syscall

    addi    $s5, $s5, 1 #increment counter
    addi    $s6, $s6, 4 #increment address

    j       checkLessThanAverage


reinitialize:

    #print info first
    li      $v0, 4
    la      $a0, listMoreThanAverage
    syscall

    lui     $s6, 0x1000
    ori     $s6, $s6, 0000

    #average is stored in $s1, so
    #use for loop, again, lw number one by one
    #then compare with average
    #if less than, print immediately!

    ori     $s5, $0, 0 #loop counter 
    ori     $t0, $0, 1 #for if true

checkMoreThanAverage:

    slti    $s0, $s5, 20
    beq     $s0, $0, reinitializeCheckEven

    lw      $t1, 0($s6)

    slt     $t2, $s1, $t1 #is average < $t1?
    beq     $t2, $t0, printMoreThanAverage #if yes, duly print

    addi    $s5, $s5, 1 #increment counter
    addi    $s6, $s6, 4 #increment address
    j       checkMoreThanAverage

printMoreThanAverage: 
    li      $v0, 1
    move    $a0, $t1
    syscall

    #print stupid space
    li      $v0, 4
    la      $a0, space 
    syscall

    addi    $s5, $s5, 1 #increment counter
    addi    $s6, $s6, 4 #increment address

    j       checkMoreThanAverage

reinitializeCheckEven:

    #print info first
    li      $v0, 4
    la      $a0, listEvenNumber
    syscall

    #address in memory
    lui     $s6, 0x1000
    ori     $s6, $s6, 0000

    ori     $s5, $0, 0 #loop counter 
    ori     $t0, $0, 1 #for if true
    ori     $t2, $0, 2 #for check even and odd

checkEven:

    slti    $s0, $s5, 20
    beq     $s0, $0, reinitializeCheckOdd

    lw      $t1 0($s6) #load from memory

    div     $t1, $t2 #$t1 / 2
    mfhi    $s1 #we wants remainder, so

    beq     $s1, $0, printEven #if == 0, means even
    #else
    addi    $s5, $s5, 1 #increment counter
    addi    $s6, $s6, 4 #increment address

    j       checkEven

printEven:
    li      $v0, 1
    move    $a0, $t1
    syscall

    #print stupid space
    li      $v0, 4
    la      $a0, space 
    syscall

    addi    $s5, $s5, 1 #increment counter
    addi    $s6, $s6, 4 #increment address

    j       checkEven

reinitializeCheckOdd:

    #print info first
    li      $v0, 4
    la      $a0, listOddNumber
    syscall

    #address in memory
    lui     $s6, 0x1000
    ori     $s6, $s6, 0000

    ori     $s5, $0, 0 #loop counter 
    ori     $t0, $0, 1 #for if true
    ori     $t2, $0, 2 #for check even and odd

checkOdd:

    slti    $s0, $s5, 20
    beq     $s0, $0, divHiLo

    lw      $t1 0($s6) #load from memory

    div     $t1, $t2 #$t1 / 2
    mfhi    $s1 #we wants remainder, so

    bne     $s1, $0, printOdd #if != 0, means odd
    #else
    addi    $s5, $s5, 1 #increment counter
    addi    $s6, $s6, 4 #increment address

    j       checkOdd

printOdd:

    li      $v0, 1
    move    $a0, $t1
    syscall

    #print stupid space
    li      $v0, 4
    la      $a0, space 
    syscall

    addi    $s5, $s5, 1 #increment counter
    addi    $s6, $s6, 4 #increment address

    j       checkOdd

divHiLo:

    #first index -> the lowest number
    lui     $s6, 0x1000
    ori     $s6, $s6, 0000

    #last index -> the highest number == value at $s7 in mem
    #lui     $s7, 0x1000
    #ori     $s7, $s7, 0050 #will be change to 80  for our case later

    lw      $t1, 0($s6); #lowest 
    lw      $t2, 76($s6); #highest

    #NOTE: this is array, so the last index is 19 * 20 = 76,
    #not 20 * 20 = 80. I learn this the hard way.

multiHighestLowest:

    #print info first
    li      $v0, 4
    la      $a0, highestTimesLowest
    syscall

    mult    $t1, $t2 #multiply
    mflo    $s1 #get the results

    #print it
    li      $v0, 1
    move    $a0, $s1
    syscall

    #print info first
    li      $v0, 4
    la      $a0, highestDivideByLowest
    syscall

    div    $t2, $t1 #divide
    mflo    $s1 #get the results (remember: lo is results, hi is remainder)

    #print it, the result is in int, not float
    li      $v0, 1
    move    $a0, $s1
    syscall

printListOfProgrammingTechniqueUsed:

    #print info first
    li      $v0, 4
    la      $a0, listOfProgrammingTechniqueUsed
    syscall

exit:
    li      $v0, 10
    syscall

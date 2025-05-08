.data
.align 2

arr_int: .space 80

msg1: .asciiz "Enter a positive number between 1 and 999:\n"
msg2: .asciiz "Average value of all entered numbers = "
msg3: .asciiz "The count of numbers above the avg is = "
msg4: .asciiz "The count of numbers less than the avg is = "
msg5: .asciiz "Number of two digit Numbers = "
msg6: .asciiz "The count of numbers that are even = "
msg7: .asciiz "The count of numbers that are odd = "
msg8: .asciiz "The count of prime numbers is = "
msg9: .asciiz "Sorted array in ascending order\n"


dot: .asciiz "."
new_line: .asciiz "\n"
error_msg: .asciiz "Error! You entered a non-positive value.\n"

.text

.globl main

j main

is_prime1:
    li $v0, 1             # Assume prime by default

    li $s0, 2             # $s0 = 2
    blt $a0, $s0, not_prime1  # If n < 2 ? not prime

    move $s1, $s0         # $s1 = divisor i = 2

prime_loop1:

    beq $s1, $a0, end_prime1   # Reached number itself => prime

    div $a0, $s1
    mfhi $s2              # remainder in $s2
    beqz $s2, not_prime1   # if remainder == 0 ? not prime

    addi $s1, $s1, 1
    j prime_loop1

not_prime1:
    li $v0, 0             # Set return value to 0 (false)

end_prime1:
    jr $ra


sortting:
    li $t0, 0          # Outer loop i = 0

outer_loop:
    bge $t0, $s0, end_bubble_sort  # If i >= count, done

    li $t1, 0          # Inner loop j = 0

inner_loop:
    sub $t2, $s0, $t0
    addi $t2, $t2, -1       # t2 = n - i - 1

    bge $t1, $t2, next_pass

    # Load arr[j] into $t3
    mul $t4, $t1, 4
    add $t5, $s1, $t4
    lw $t3, 0($t5)

    # Load arr[j+1] into $t6
    addi $t6, $t5, 4
    lw $t7, 0($t6)

    ble $t3, $t7, skip_swap

    # Swap arr[j] and arr[j+1]
    sw $t7, 0($t5)
    sw $t3, 0($t6)

skip_swap:
    addi $t1, $t1, 1
    j inner_loop

next_pass:
    addi $t0, $t0, 1
    j outer_loop

end_bubble_sort:

li $v0, 4
    la $a0, msg9
    syscall

    li $t1, 0            

print_sorted_loop:

    beq $t1, $s0, exit

    mul $t2, $t1, 4
    add $t3, $s1, $t2
    lw $a0, 0($t3)

    li $v0, 1
    syscall

    li $v0, 4
    la $a0, new_line
    syscall

    addi $t1, $t1, 1
    j print_sorted_loop


    jr $ra


main:

    li $s0, 0            # Count of entered numbers
    la $s1, arr_int      # Base address of array

readint:


    li $v0, 4
    la $a0, msg1
    syscall

  #read input int
    li $v0, 5
    syscall
    move $t0, $v0

    beq $t0, -1, Result
    blez $t0, err_MSG_Print
    bgt $t0, 999, err_MSG_Print


    mul $t3, $s0, 4
    add $t4, $s1, $t3
    sw $t0, 0($t4)

    addi $s0, $s0, 1
    beq $s0, 20, Result
    j readint


 err_MSG_Print:
    li $v0, 4
    la $a0, error_msg
    syscall
    j readint

 Result:
 
    li $v0, 4
    la $a0, msg2
    syscall

    li $t1, 0
    li $t5, 0

 sum:
    mul $t3, $t1, 4
    add $t4, $s1, $t3
    lw $t0, 0($t4)
    
    add $t5, $t5, $t0
    addi $t1, $t1, 1
    beq $t1, $s0, print_avg

   
    
    j sum

print_avg:

    div $t5, $s0
    
     # Store average in $s2 for later comparison
    mflo $a0
    mflo $s2
     
    li $v0, 1
    syscall

    mfhi $s3
    li $t9, 10
    mul $s3, $s3, $t9
    div $s3, $s0
    mflo $a0

    
    li $v0, 4
    la $a0, new_line
    syscall


    li $t5, 0  # Above avg
    li $t1, 0

count_above_avg:
    mul $t3, $t1, 4
    add $t4, $s1, $t3
    lw $t0, 0($t4)

    bgt $t0, $s2, increment_above
    j next_avg_check

increment_above:
    addi $t5, $t5, 1

next_avg_check:
    addi $t1, $t1, 1
    beq $t1, $s0, print_above_below
    j count_above_avg

print_above_below:
    li $v0, 4
    la $a0, msg3
    syscall
    move $a0, $t5
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, new_line
    syscall

    sub $t6, $s0, $t5

    li $v0, 4
    la $a0, msg4
    syscall
    move $a0, $t6
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, new_line
    syscall

# Two-digit number count
two_digit:
    li $t1, 0
    li $t5, 0

    li $v0, 4
    la $a0, msg5
    syscall

check_digits:
    mul $t3, $t1, 4
    add $t4, $s1, $t3
    lw $t0, 0($t4)

    blt $t0, 10, skip_digit
    bgt $t0, 99, skip_digit
    addi $t5, $t5, 1

skip_digit:
    addi $t1, $t1, 1
    beq $t1, $s0, print_digits
    j check_digits

print_digits:
    move $a0, $t5
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, new_line
    syscall

# Even/Odd count
even_odd:
    li $t1, 0
    li $t5, 0    # even
    li $t6, 0    # odd

count_even_odd:
    mul $t3, $t1, 4
    add $t4, $s1, $t3
    lw $t0, 0($t4)

    li $t8, 2
    div $t0, $t8
    mfhi $t7
    beq $t7, 0, is_even
    addi $t6, $t6, 1
    j next_even_odd

is_even:
    addi $t5, $t5, 1

next_even_odd:
    addi $t1, $t1, 1
    beq $t1, $s0, print_even_odd
    j count_even_odd

print_even_odd:
    li $v0, 4
    la $a0, msg6
    syscall
    move $a0, $t5
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, new_line
    syscall

    li $v0, 4
    la $a0, msg7
    syscall
    move $a0, $t6
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, new_line
    syscall
    
   

    li $t1, 0          
    li $t5, 0          

# ========================
# Count Prime Numbers Inline (no procedure)
# ========================
count_primes_inline:
    li $t1, 0          # index = 0
    li $t5, 0          # prime_count = 0

check_next_prime:
    beq $t1, $s0, print_prime_count

    # Load arr_int[t1] into $t0
    mul $t3, $t1, 4
    add $t4, $s1, $t3
    lw $t0, 0($t4)

    # If number < 2 ? not prime
    li $t6, 2
    blt $t0, $t6, next_prime_check

    # Set divisor = 2
    li $t7, 2
    li $t8, 0          # is_not_prime = 0

prime_div_check:
    beq $t7, $t0, is_prime       # Reached end, still prime

    div $t0, $t7
    mfhi $t9                    # remainder
    beqz $t9, not_prime         # divisible ? not prime

    addi $t7, $t7, 1
    j prime_div_check

not_prime:
    li $t8, 1                   # mark as not prime
    j next_prime_check

is_prime:
    # $t8 still = 0 ? is prime
    addi $t5, $t5, 1

next_prime_check:
    addi $t1, $t1, 1
    j check_next_prime
    
    print_prime_count:
    li $v0, 4
    la $a0, msg8
    syscall

    move $a0, $t5
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, new_line
    syscall



   
    jal sortting

   

exit:
    li $v0, 10
    syscall

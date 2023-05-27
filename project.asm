# Data segment
.data
prompt_start: .asciiz "Has the prayer started? (1 for Yes, 0 for No): "
prompt_rakah: .asciiz "Enter the number of Rakah you want to pray: "
prompt_stand: .asciiz "Are you standing? (1 for Yes, 0 for No): "
prompt_motion: .asciiz "Has there been any motion change? (1 for Yes, 0 for No): "
prompt_salaam: .asciiz "Have you completed the Salaam position? (1 for Yes, 0 for No): "
position_message: .asciiz "Current position: "

rakahCount: .word 0
sujudCount: .word 0
position: .asciiz "Qiyam"
numRakah: .word 0

# Text segment
.text
.globl main

main:
    # Step 1: Start
    jal start_prayer
    
    # Step 23: Repeat step 21
    jal repeat_salaam_position
    
    # End program
    li $v0, 10
    syscall

# Procedure to start the prayer
start_prayer:
    # Step 2: Ask the user if the prayer has started
    jal ask_prayer_started
    
    # Step 3: If the prayer has started, proceed to the next step
    beqz $v0, start_prayer
    
    # Step 5: Input the number of Rakah the user wants to pray
    jal input_rakah
    
    # Step 6: Set rakahCount to 0
    sw $zero, rakahCount
    
    # Step 7: Set sujudCount to 0
    sw $zero, sujudCount
    
    # Step 8: Set position to "Qiyam"
    la $t0, position
    li $t1, 'Q'
    sb $t1, ($t0)
    
    # Step 9: Start the prayer loop
    jal prayer_loop

prayer_loop:
    # Step 10: Ask the user if they are standing
    jal ask_standing
    
    # Step 11: If standing, proceed to the next step
    beqz $v0, prayer_loop
    
    # Step 13: Ask the user if there has been any motion change
    jal ask_motion_change
    
    # Step 14: If motion has changed, update the position
    beqz $v0, prayer_loop
    
    # Update position based on the current position
    la $t0, position
    lb $t1, ($t0)
    
    # Print the updated position
    li $v0, 4
    la $a0, position_message
    syscall
    
    # Print the position character
    move $a0, $t1
    li $v0, 11
    syscall
    
    # Step 15: Increment sujudCount if position is "Sujud"
    li $t2, 'S'
    beq $t1, $t2, increment_sujudCount
    
    # Step 16: Check if sujudCount reaches 2
    lw $t3, sujudCount
    beqz $t3, prayer_loop
    
    # Reset sujudCount to 0 and increment rakahCount
    sw $zero, sujudCount
    lw $t4, rakahCount
    addi $t4, $t4, 1
    sw $t4, rakahCount
    
    # Step 17: Check if rakahCount equals numRakah
    lw $t5, numRakah
    beq $t4, $t5, end_prayer
    
    # Step 18: Go back to step 10
    j prayer_loop

increment_sujudCount:
    lw $t3, sujudCount
    addi $t3, $t3, 1
    sw $t3, sujudCount
    
    j prayer_loop

end_prayer:
    # Step 20: Set the position to "Salaam"
    la $t0, position
    li $t1, 'S'
    sb $t1, ($t0)
    
    # Step 21: Ask the user if they have completed the Salaam position
    jal ask_salaam_completed
    
    # Step 22: If completed, end the program
    beqz $v0, end_prayer
    
    # Otherwise, repeat step 21
    j end_prayer

# Procedure to ask if the prayer has started
ask_prayer_started:
    li $v0, 4
    la $a0, prompt_start
    syscall
    
    li $v0, 5
    syscall
    move $v0, $a0
    
    jr $ra

# Procedure to ask the number of Rakah
input_rakah:
    li $v0, 4
    la $a0, prompt_rakah
    syscall
    
    li $v0, 5
    syscall
    move $t7, $v0
    
    sw $t7, numRakah
    
    jr $ra

# Procedure to ask if the user is standing
ask_standing:
    li $v0, 4
    la $a0, prompt_stand
    syscall
    
    li $v0, 5
    syscall
    move $v0, $a0
    
    jr $ra

# Procedure to ask if there has been any motion change
ask_motion_change:
    li $v0, 4
    la $a0, prompt_motion
    syscall
    
    li $v0, 5
    syscall
    move $v0, $a0
    
    jr $ra

# Procedure to ask if the user has completed the Salaam position
ask_salaam_completed:
    li $v0, 4
    la $a0, prompt_salaam
    syscall
    
    li $v0, 5
    syscall
    move $v0, $a0
    
    jr $ra

# Procedure to repeat step 21
repeat_salaam_position:
    # Step 21: Ask the user if they have completed the Salaam position
    jal ask_salaam_completed
    
    # Step 22: If not completed, repeat step 21
    beqz $v0, repeat_salaam_position
    
    jr $ra

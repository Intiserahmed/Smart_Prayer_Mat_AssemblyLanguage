.data
    prompt1: .asciiz "Welcome to Smart Prayer System\n"
    prompt2: .asciiz "Has the prayer started? (1 for Yes, 0 for No): "
    prompt3: .asciiz "Enter the number of Rakah you want to pray: "
    prompt4: .asciiz "Change Position Detected? (Simulating Pressure Sensor Input) (1 for Yes, 0 for No): "
    prompt5: .asciiz "Has there been any motion change? (Simulating Motion Sensor Input)(1 for Yes, 0 for No): "
    prompt6: .asciiz "Invalid input. Please try again.\n"
    prompt7: .asciiz "Enter a valid number of Rakah greater than zero: "
    prompt8: .asciiz "Unexpected position change. Please correct your position.\n"
    prompt9: .asciiz "Have you completed the Salaam position? (1 for Yes, 0 for No): "

# Position messages
position_Takbir: .asciiz "Takbir\n"
position_Ruku: .asciiz "Ruku\n"
position_Sujud: .asciiz "Sujud\n"
position_Jalsa: .asciiz "Jalsa\n"
position_Sujud2: .asciiz "Sujud (second prostration)\n"
position_Jalsa2: .asciiz "Jalsa (between prostrations)\n"
position_Qaida: .asciiz "Qa'ida\n"
position_Tashahhud: .asciiz "Tashahhud\n"
.text
main:
    # Print welcome message
    li $v0, 4
    la $a0, prompt1
    syscall

    # Ask if the prayer has started
    jal askConfirmation

    # Input the number of Rakah
    jal inputRakah

    # Set initial variables
    li $t0, 0     # rakahCount
    li $t1, 0     # sujudCount
    li $t2, 0     # position

prayer_loop:
    # Ask if the user is standing
    jal askStanding

    # Ask if there has been any motion change
    jal askMotionChange

    # Check and update position
    beq $t2, 0, updatePosition_Qiyam
    beq $t2, 1, updatePosition_Takbir
    beq $t2, 2, updatePosition_Ruku
    beq $t2, 3, updatePosition_Sujud
    beq $t2, 4, updatePosition_Jalsa
    beq $t2, 5, updatePosition_Sujud2
    beq $t2, 6, updatePosition_Jalsa2
    beq $t2, 7, updatePosition_Qaida
    beq $t2, 8, updatePosition_Tashahhud
    j handleUnexpectedPosition

updatePosition_Qiyam:
    li $t2, 1     # position = "Takbir"
    li $v0, 4
    la $a0, position_Takbir
    syscall
    j incrementSujudCount

updatePosition_Takbir:
    li $t2, 2     # position = "Ruku"
    li $v0, 4
    la $a0, position_Ruku
    syscall
    j incrementSujudCount

updatePosition_Ruku:
    li $t2, 3     # position = "Sujud"
    li $v0, 4
    la $a0, position_Sujud
    syscall
    j incrementSujudCount

updatePosition_Sujud:
    li $t2, 4     # position = "Jalsa"
    li $v0, 4
    la $a0, position_Jalsa
    syscall
    j incrementSujudCount

updatePosition_Jalsa:
    li $t2, 5     # position = "Sujud2"
    li $v0, 4
    la $a0, position_Sujud2
    syscall
    j incrementSujudCount

updatePosition_Sujud2:
    li $t2, 6     # position = "Jalsa2"
    li $v0, 4
    la $a0, position_Jalsa2
    syscall
    j incrementSujudCount

updatePosition_Jalsa2:
    li $t2, 7     # position = "Qaida"
    li $v0, 4
    la $a0, position_Qaida
    syscall
    j incrementSujudCount

updatePosition_Qaida:
    li $t2, 8     # position = "Tashahhud"
    li $v0, 4
    la $a0, position_Tashahhud
    syscall
    j incrementSujudCount

updatePosition_Tashahhud:
    j prayer_loop

handleUnexpectedPosition:
    li $v0, 4
    la $a0, prompt8
    syscall
    j prayer_loop

incrementSujudCount:
    beq $t2, 4, incrementSujud
    j checkRakahCount

incrementSujud:
    addi $t1, $t1, 1     # sujudCount++
    bne $t1, 2, checkRakahCount
    li $t1, 0     # sujudCount = 0
    addi $t0, $t0, 1     # rakahCount++

checkRakahCount:
    beq $t0, $t3, endPrayer
    j prayer_loop

endPrayer:
    li $t2, 9     # position = "Salaam"

final_position_check:
    # Ask if the user has completed the Salaam position
    jal askSalaamCompletion

    # Check if the user completed the Salaam position
    beq $t4, 1, exitProgram
    beq $t4, 0, final_position_check
    j handleInvalidInput

askConfirmation:
    li $v0, 4
    la $a0, prompt2
    syscall

    li $v0, 5
    syscall

    beqz $v0, askConfirmation     # Repeat step 2 if input is 0
    beq $v0, 1, continueExecution     # Proceed to next step if input is 1
    j handleInvalidInput     # Handle invalid input and repeat step 2

continueExecution:
    jr $ra

inputRakah:
    li $v0, 4
    la $a0, prompt3
    syscall

    li $v0, 5
    syscall

    bgtz $v0, setRakahCount     # If input is positive, proceed to next step
    j handleInvalidRakahInput     # Handle negative input and repeat step 4

setRakahCount:
    move $t3, $v0     # rakahCount = input
    jr $ra

askStanding:
    li $v0, 4
    la $a0, prompt4
    syscall

    li $v0, 5
    syscall

    beq $v0, 1, continueStanding     # Continue to next step if input is 1
    beqz $v0, continueStanding     # Continue to next step if input is 0
    j handleInvalidInput     # Handle invalid input and repeat step 9

continueStanding:
    jr $ra

askMotionChange:
    li $v0, 4
    la $a0, prompt5
    syscall

    li $v0, 5
    syscall

    beq $v0, 1, continueMotionChange     # Continue to next step if input is 1
    beqz $v0, askStanding     # Go back to step 9 if input is 0
    j handleInvalidInput     # Handle invalid input and repeat step 10

continueMotionChange:
    bne $t2, 0, updatePosition_Takbir     # Check and update position based on the order
    bne $t2, 1, updatePosition_Ruku
    bne $t2, 2, updatePosition_Sujud
    bne $t2, 3, updatePosition_Jalsa
    bne $t2, 4, updatePosition_Sujud2
    bne $t2, 5, updatePosition_Jalsa2
    bne $t2, 6, updatePosition_Qaida
    bne $t2, 7, updatePosition_Tashahhud
    j handleUnexpectedPosition     # Handle unexpected position change

askSalaamCompletion:
    li $v0, 4
    la $a0, prompt9
    syscall

    li $v0, 5
    syscall

    beq $v0, 1, exitProgram     # End the program if input is 1
    beq $v0, 0, final_position_check     # Repeat step 18 if input is 0
    j handleInvalidInput     # Handle invalid input and repeat step 18

handleInvalidInput:
    li $v0, 4
    la $a0, prompt6
    syscall
    j prayer_loop

handleInvalidRakahInput:
    li $v0, 4
    la $a0, prompt7
    syscall
    j inputRakah

exitProgram:
    li $v0, 10
    syscall


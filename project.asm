.data
welcomeMsg: .asciiz "!!!!!!!!!!!!!!!! Welcome to the Smart Prayer System !!!!!!!!!!!!!!!!!!! \n"
promptStart: .asciiz "Has the prayer started? Press 1 for yes, 0 for no.\n"
promptRakah: .asciiz "How many Rakahs do you want to pray?\n"
promptStand: .asciiz "Are you Standing (Simulating Pressure Sensor Input) ? Press 1 for yes, 0 for no.\n"
promptMotion: .asciiz "Has there been any motion change? (Simulating Motion Sensor Input) Press 1 for yes, 0 for no.\n"
qiyam: .asciiz "Qiyam\n (Actuators/Display) Next Position is : Takbir\n"
takbir: .asciiz "Takbir\n (Actuators/Display) Next Position is : Ruku\n"
ruku: .asciiz "Ruku\n (Actuators/Display) Next Position is : Sujud\n"
sujud: .asciiz "Sujud\n (Actuators/Display) Next Position is : Jalsa\n"
jalsa: .asciiz "Jalsa\n (Actuators/Display) Next Position is : Qa'ida\n"
qaida: .asciiz "Qa'ida\n (Actuators/Display) Next Position is : Qiyam\n"
tashahhud: .asciiz "Tashahhud\n (Actuators/Display) Next Position is : Salam\n"
salam: .asciiz "Salam\n (Actuators/Display) You Succesfully Completed the Prayer!"
promptSalam: .asciiz "Have you completed the Salam position? Press 1 for yes, 0 for no.\n"
errorInvalidInput: .asciiz "Invalid input. Please try again.\n"

.text
main:
    # Print welcome message
    li $v0, 4
    la $a0, welcomeMsg
    syscall

    # Ask if prayer has started
askStart:
    li $v0, 4
    la $a0, promptStart
    syscall

    # Read user input
    li $v0, 5
    syscall
    move $t0, $v0

    # Check if input is 1 or 0
    beqz $t0, askStart
    bne $t0, 1, askStart

    # Input is 1, proceed to next step

    # Ask how many Rakahs to pray
askRakah:
    li $v0, 4
    la $a0, promptRakah
    syscall

    # Read user input
    li $v0, 5
    syscall
    move $t1, $v0

    # Check if input is positive and non-zero
    blez $t1, askRakah

    # Input is valid, proceed to next step

    # Initialize variables
    li $t2, 0 # rakahCount = 0
    li $t3, 0 # sujudCount = 0
    li $t4, 1 # position = Qiyam (represented by numbers from 1 to 7)

prayerLoop:
    # Check if rakahCount is equal to user input
    beq $t2, $t1, endLoop

    # Ask if user is standing
askStand:
    li $v0, 4
    la $a0, promptStand
    syscall

    # Read user input
    li $v0, 5
    syscall
    move $t5, $v0

    # Check if input is 1 or 0
    beq $t5, 1, prayerLoop
    beq $t5, 0, motionLoop

    # Invalid input, display error message and repeat askStand
    li $v0, 4
    la $a0, errorInvalidInput
    syscall
    j askStand

motionLoop:
    # Ask if there has been any motion change
askMotion:
    li $v0, 4
    la $a0, promptMotion
    syscall

    # Read user input
    li $v0, 5
    syscall
    move $t6, $v0

    # Check if input is 1 or 0
    beq $t6, 1, updatePosition
    beq $t6, 0, motionLoop

    # Invalid input, display error message and repeat motionLoop
    li $v0, 4
    la $a0, errorInvalidInput
    syscall
    j motionLoop

updatePosition:
    # Update position based on current position
    beq $t4, 1, qiyamToTakbir
    beq $t4, 2, takbirToRuku
    beq $t4, 3, rukuToSujud
    beq $t4, 4, sujudToJalsa
    beq $t4, 5, jalsaToSujud
    beq $t4, 6, jalsaToQaida

qiyamToTakbir:
    # Update position to Takbir (2) and print it
    li $t4, 2
    li $v0, 4
    la $a0, takbir
    syscall
    j motionLoop

takbirToRuku:
    # Update position to Ruku (3) and print it
    li $t4, 3
    li $v0, 4
    la $a0, ruku
    syscall
    j motionLoop

rukuToSujud:
    # Update position to Sujud (4) and print it
    li $t4, 4
    li $v0, 4
    la $a0, sujud
    syscall

    # Increment sujudCount by 1
    addi $t3, $t3, 1

    j motionLoop

sujudToJalsa:
    # Update position to Jalsa (5) and print it
    li $t4, 5
    li $v0, 4
    la $a0, jalsa
    syscall

    # Check if sujudCount is 2
    beq $t3, 2, jalsaToQaida

    j motionLoop

jalsaToSujud:
    # Update position to Sujud (4) and print it
    li $t4, 4
    li $v0, 4
    la $a0, sujud
    syscall

    # Increment sujudCount by 1
    addi $t3, $t3, 1

    j motionLoop

jalsaToQaida:
    # Update position to Qa'ida (7) and print it
    li $t4, 7
    li $v0, 4
    la $a0, qaida
    syscall

    # Increment rakahCount by 1
    addi $t2, $t2, 1

    # Reset sujudCount to 0
    li $t3, 0

    j prayerLoop

endLoop:
    # Ask if there has been any motion change
askMotionEnd:
    li $v0, 4
    la $a0, promptMotion
    syscall

    # Read user input
    li $v0, 5
    syscall
    move $t6, $v0

    # Check if input is 1 or 0
    beq $t6, 1, updatePositionEnd
    beq $t6, 0, endLoop

    # Invalid input, display error message and repeat endLoop
    li $v0, 4
    la $a0, errorInvalidInput
    syscall
    j endLoop

updatePositionEnd:
    # Update position based on current position
    beq $t4, 7, qaidaToTashahhud

qaidaToTashahhud:
    # Update position to Tashahhud (8) and print it
    li $t4, 8
    li $v0, 4
    la $a0, tashahhud
    syscall

    j salamLoop

salamLoop:
    # Ask if there has been any motion change
askMotionSalam:
    li $v0, 4
    la $a0, promptMotion
    syscall

    # Read user input
    li $v0, 5
    syscall
    move $t6, $v0

    # Check if input is 1 or 0
    beq $t6, 1, updatePositionSalam
    beq $t6, 0, salamLoop

    # Invalid input, display error message and repeat salamLoop
    li $v0, 4
    la $a0, errorInvalidInput
    syscall
    j salamLoop

updatePositionSalam:
    # Update position based on current position
    beq $t4, 8, tashahhudToSalam

tashahhudToSalam:
    # Update position to Salam (9) and print it
    li $t4, 9
    li $v0, 4
    la $a0, salam
    syscall

    # Ask if user has completed the Salaam position
askSalam:
    li $v0, 4
    la $a0, askSalam
    syscall

    # Read user input
    li $v0, 5
    syscall
    move $t7, $v0

    # Check if input is 1 or 0
    beq $t7, 1, endProgram
    beq $t7, 0, salamLoop

    # Invalid input, display error message and repeat salamLoop
    li $v0, 4
    la $a0, errorInvalidInput
    syscall
    j salamLoop

endProgram:
    # Exit the program
    li $v0, 10
    syscall

.data
welcomeMsg: .asciiz "!!!!!!!!!!!!!!!! Welcome to the Smart Prayer System !!!!!!!!!!!!!!!!!!! \n"
promptStart: .asciiz "Has the prayer started? Press 1 for yes, 0 for no.\n"
promptRakah: .asciiz "How many Rakahs do you want to pray?\n"
promptStand: .asciiz "\nAre you currently in the standing position (Simulating Pressure Sensor Input) ? Press 0 for yes, 1 for no.\n"
messageBluetooth: .asciiz " ........   Sending performed rakah count (Simulating Bluetooth Sensor) : "
promptMotion: .asciiz "Has there been any motion change? (Simulating Motion Sensor Input) Press 1 for yes, 0 for no.\n"
qiyam: .asciiz "Qiyam\n (Actuators/Display) Next Position is : Takbir"
takbir: .asciiz "Takbir\n (Actuators/Display) Next Position is : Ruku\n"
ruku: .asciiz "Ruku\n (Actuators/Display) Next Position is : Sujud\n"
sujud: .asciiz "Sujud\n (Actuators/Display) Next Position is : Jalsa\n"
jalsa: .asciiz "Jalsa\n (Actuators/Display) Next Position is : Qa'ida\n"
qaida: .asciiz "Qa'ida\n (Actuators/Display) Next Position is : Qiyam\n"
tashahhud: .asciiz "Tashahhud\n (Actuators/Display) Next Position is : Salam\n"
salam: .asciiz "Salam\n (Actuators/Display) You Succesfully Completed the Prayer! \n........   Sending performed Rakah (Simulating Bluetooth Sensor)"
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
    beqz $t0, askStart # if input is 0, go back to askStart
    bne $t0, 1, askStart # if input is not 1, go back to askStart

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
    blez $t1, askRakah # if input is less than or equal to zero, go back to askRakah

    # Input is valid, proceed to next step

    # Initialize variables
    li $t2, 0 # rakahCount = 0
    li $t3, 0 # sujudCount = 0
    li $t4, 1 # position = Qiyam (represented by numbers from 1 to 7)

prayerLoop:
    # Check if rakahCount is equal to user input
    beq $t2, $t1, endLoop # if rakahCount equals user input, go to endLoop

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
    beq $t5, 1, prayerLoop # if input is 1, go back to prayerLoop
    beq $t5, 0, motionLoop # if input is 0, go to motionLoop

    # Invalid input, display error message and repeat askStand
    li $v0, 4
    la $a0, errorInvalidInput
    syscall
    j askStand # jump to askStand

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
    beq $t6, 1, updatePosition # if input is 1, go to updatePosition
    beq $t6, 0, motionLoop # if input is 0, go back to motionLoop

    # Invalid input, display error message and repeat motionLoop
    li $v0, 4
    la $a0, errorInvalidInput
    syscall
    j motionLoop # jump to motionLoop

updatePosition:
    # Update position based on current position
    beq $t4, 1, qiyamToTakbir # if position is Qiyam (1), go to qiyamToTakbir
    beq $t4, 2, takbirToRuku # if position is Takbir (2), go to takbirToRuku
    beq $t4, 3, rukuToSujud # if position is Ruku (3), go to rukuToSujud
    beq $t4, 4, sujudToJalsa # if position is Sujud (4), go to sujudToJalsa
    beq $t4, 5, jalsaToSujud # if position is Jalsa (5), go to jalsaToSujud
    beq $t4, 6, jalsaToQaida # if position is Jalsa (6), go to jalsaToQaida

qiyamToTakbir:
    # Update position to Takbir (2) and print it
    li $t4, 2 # Load immediate value 2 into register $t4
    li $v0, 4 # Load immediate value 4 into register $v0 (system call code for printing a string)
    la $a0, takbir # Load the address of the string "takbir" into register $a0 (argument for printing)
    syscall # Make a system call to print the string
    j motionLoop # Jump to the motionLoop label

takbirToRuku:
    # Update position to Ruku (3) and print it
    li $t4, 3 # Load immediate value 3 into register $t4
    li $v0, 4 # Load immediate value 4 into register $v0 (system call code for printing a string)
    la $a0, ruku # Load the address of the string "ruku" into register $a0 (argument for printing)
    syscall # Make a system call to print the string
    j motionLoop # Jump to the motionLoop label

rukuToSujud:
    # Update position to Sujud (4) and print it
    li $t4, 4 # Load immediate value 4 into register $t4
    li $v0, 4 # Load immediate value 4 into register $v0 (system call code for printing a string)
    la $a0, sujud # Load the address of the string "sujud" into register $a0 (argument for printing)
    syscall # Make a system call to print the string

    # Increment sujudCount by 1
    addi $t3, $t3, 1 # Add immediate value 1 to register $t3 and store the result in register $t3

    j motionLoop # Jump to the motionLoop label

sujudToJalsa:
    # Update position to Jalsa (5) and print it
    li $t4, 5 # Load immediate value 5 into register $t4
    li $v0, 4 # Load immediate value 4 into register $v0 (system call code for printing a string)
    la $a0, jalsa # Load the address of the string "jalsa" into register $a0 (argument for printing)
    syscall # Make a system call to print the string

    # Check if sujudCount is 2
    beq $t3, 2, jalsaToQaida # Branch if equal: if register $t3 is equal to immediate value 2, jump to the jalsaToQaida label

    j motionLoop # Jump to the motionLoop label

jalsaToSujud:
    # Update position to Sujud (4) and print it
    li $t4, 4 # Load immediate value 4 into register $t4
    li $v0, 4 # Load immediate value 4 into register $v0 (system call code for printing a string)
    la $a0, sujud # Load the address of the string "sujud" into register $a0 (argument for printing)
    syscall # Make a system call to print the string

    # Increment sujudCount by 1
    addi $t3, $t3, 1 # Add immediate value 1 to register $t3 and store the result in register $t3

    j motionLoop # Jump to the motionLoop label

jalsaToQaida:
    # Update position to Qa'ida (7) and print it
    li $t4, 7 # Load immediate value 7 into register $t4
    li $v0, 4 # Load immediate value 4 into register $v0 (system call code for printing a string)
    la $a0, qaida # Load the address of the string "qaida" into register $a0 (argument for printing)
    syscall

    # Increment rakahCount by 1
    addi $t2, $t2, 1 # Add immediate value 1 to register $t2 and store the result in register $t2
    # Print the value of $t1

    # Print a message
    li $v0, 4       # Load immediate value 4 into register $v0 (system call code for printing a string)
    la $a0, messageBluetooth   # Load the address of the string "messageBluetooth" into register $a0 (argument for printing)
    syscall

    li $v0, 1       # Load immediate value 1 into register $v0 (system call code for printing an integer)
    move $a0, $t2   # Move the value of register $t1 to register $a0 (argument for printing)
    syscall
    # Reset sujudCount to 0
    li $t3, 0 # Load immediate value 0 into register $t3

    j prayerLoop # Jump to the prayerLoop label

endLoop:
    # Ask if there has been any motion change
askMotionEnd:
    li $v0, 4 # Load immediate value 4 into register $v0 (system call code for printing a string)
    la $a0, promptMotion # Load the address of the string "promptMotion" into register $a0 (argument for printing)
    syscall

    # Read user input
    li $v0, 5 # Load immediate value 5 into register $v0 (system call code for reading an integer)
    syscall
    move $t6, $v0 # Move the value of register $v0 to register $t6

    # Check if input is 1 or 0
    beq $t6, 1, updatePositionEnd # Branch if equal: if register $t6 is equal to immediate value 1, jump to the updatePositionEnd label
    beq $t6, 0, endLoop # Branch if equal: if register $t6 is equal to immediate value 0, jump to the endLoop label

    # Invalid input, display error message and repeat endLoop
    li $v0, 4 # Load immediate value 4 into register $v0 (system call code for printing a string)
    la $a0, errorInvalidInput # Load the address of the string "errorInvalidInput" into register $a0 (argument for printing)
    syscall
    j endLoop # Jump to the endLoop label

updatePositionEnd:
    # Update position based on current position
    beq $t4, 7, qaidaToTashahhud # Branch if equal: if register $t4 is equal to immediate value 7, jump to the qaidaToTashahhud label

qaidaToTashahhud:
    # Update position to Tashahhud (8) and print it
    li $t4, 8 # Load immediate value 8 into register $t4
    li $v0, 4 # Load immediate value 4 into register $v0 (system call code for printing a string)
    la $a0, tashahhud # Load the address of the string "tashahhud" into register $a0 (argument for printing)
    syscall

    j salamLoop # Jump to the salamLoop label

salamLoop:
    # Ask if there has been any motion change
askMotionSalam:
    li $v0, 4 # Load immediate value 4 into register $v0 (system call code for printing a string)
    la $a0, promptMotion # Load the address of the string "promptMotion" into register $a0 (argument for printing)
    syscall

    # Read user input
    li $v0, 5 # Load immediate value 5 into register $v0 (system call code for reading an integer)
    syscall
    move $t6, $v0 # Move the value of register $v0 to register $t6

    # Check if input is 1 or 0
    beq $t6, 1, updatePositionSalam # Branch if equal: if register $t6 is equal to immediate value 1, jump to the updatePositionSalam label
    beq $t6, 0, salamLoop # Branch if equal: if register $t6 is equal to immediate value 0, jump to the salamLoop label

    # Invalid input, display error message and repeat salamLoop
    li $v0, 4 # Load immediate value 4 into register $v0 (system call code for printing a string)
    la $a0, errorInvalidInput # Load the address of the string "errorInvalidInput" into register $a0 (argument for printing)
    syscall
    j salamLoop # Jump to the salamLoop label

updatePositionSalam:
    # Update position based on current position
    beq $t4, 8, tashahhudToSalam
    
tashahhudToSalam:
    # Update position to Salam (9) and print it
    li $t4, 9 # Load immediate value 9 into register $t4
    li $v0, 4 # Load immediate value 4 into register $v0 (system call code for printing a string)
    la $a0, salam # Load the address of the string "salam" into register $a0 (argument for printing)
    syscall

    # Ask if user has completed the Salaam position
askSalam:
    li $v0, 4 # Load immediate value 4 into register $v0 (system call code for printing a string)
    la $a0, askSalam # Load the address of the string "askSalam" into register $a0 (argument for printing)
    syscall

    # Read user input
    li $v0, 5 # Load immediate value 5 into register $v0 (system call code for reading an integer)
    syscall
    move $t7, $v0 # Move the value of register $v0 to register $t7

    # Check if input is 1 or 0
    beq $t7, 1, endProgram # Branch if equal: if register $t7 is equal to immediate value 1, jump to the endProgram label
    beq $t7, 0, salamLoop # Branch if equal: if register $t7 is equal to immediate value 0, jump to the salamLoop label

    # Invalid input, display error message and repeat salamLoop
    li $v0, 4 # Load immediate value 4 into register $v0 (system call code for printing a string)
    la $a0, errorInvalidInput # Load the address of the string "errorInvalidInput" into register $a0 (argument for printing)
    syscall
    j salamLoop # Jump to the salamLoop label

endProgram:
    # Exit the program
    li $v0, 10 # Load immediate value 10 into register $v0 (system call code for exiting the program)
    syscall

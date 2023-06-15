# MIPS assembly code for Smart Prayer System

.data
welcome: .asciiz "Welcome to Smart Prayer System\n"
askStart: .asciiz "Has the prayer started? Press 1 for yes, 0 for no.\n"
askRakah: .asciiz "How many Rakah do you want to pray?\n"
askStand: .asciiz "Are you standing? Press 1 for yes, 0 for no.\n"
askMotion: .asciiz "Has there been any motion change? Press 1 for yes, 0 for no.\n"
qiyam: .asciiz "Qiyam\n"
takbir: .asciiz "Takbir\n"
ruku: .asciiz "Ruku\n"
sujud: .asciiz "Sujud\n"å
jalsa: .asciiz "Jalsa\n"
qaida: .asciiz "Qa'ida\n"
tashahhud: .asciiz "Tashahhud\n"
salam: .asciiz "Salam\n"
askSalam: .asciiz "Have you completed the Salaam position? Press 1 for yes, 0 for no.\n"

.text
main:
    # Print welcome message
    li $v0, 4
    la $a0, welcome
    syscall

    # Ask if prayer has started
    li $v0, 4
    la $a0, askStart
    syscall

    # Read user input
    li $v0, 5
    syscall
    move $t0, $v0 # store input in $t0

    # Check if input is 1 or 0
    bne $t0, 1, main # if input is not 1, repeat main
    beq $t0, 0, main # if input is 0, repeat main

    # Input is 1, proceed to next step

    # Ask how many Rakah to pray
    li $v0, 4
    la $a0, askRakah
    syscall

    # Read user input
    li $v0, 5
    syscall
    move $t1, $v0 # store input in $t1

    # Check if input is positive and non-zero
    blez $t1, main # if input is less than or equal to zero, repeat main

    # Input is valid, proceed to next step

    # Initialize variables
    li $t2, 0 # rakahCount = 0
    li $t3, 0 # sujudCount = 0
    li $t4, 1 # position = Qiyam (represented by numbers from 1 to 7)

prayerLoop:
    # Check if rakahCount is equal to user input
    beq $t2, $t1, endLoop # if rakahCount == user input, go to endLoop

    # Ask if user is standing
    li $v0, 4
    la $a0, askStand
    syscall

    # Read user input
    li $v0, 5
    syscall
    move $t5, $v0 # store input in $t5

    # Check if input is 1 or 0
    beq $t5, 1, prayerLoop # if input is 1 (standing), repeat prayerLoop
    bne $t5, 0, prayerLoop # if input is not 0 (not standing), repeat prayerLoop

    # Input is 0 (not standing), proceed to next step

motionLoop:
        # Ask if there has been any motion change
    li $v0, 4
    la $a0, askMotion
    syscall

    # Read user input
    li $v0, 5
    syscall
    move $t6, $v0 # store input in $t6

    # Check if input is 1 or 0
    beq $t6, 0, motionLoop # if input is 0 (no motion change), repeat motionLoop
    bne $t6, 1, motionLoop # if input is not 1 (motion change), repeat motionLoop

    # Input is 1 (motion change), proceed to next step

    # Update position based on current position
    beq $t4, 1, qiyamToTakbir # if position is Qiyam (1), go to qiyamToTakbir
    beq $t4, 2, takbirToRuku # if position is Takbir (2), go to takbirToRuku
    beq $t4, 3, rukuToSujud # if position is Ruku (3), go to rukuToSujud
    beq $t4, 4, sujudToJalsa # if position is Sujud (4), go to sujudToJalsa
    beq $t4, 5, jalsaToSujud # if position is Jalsa (5), go to jalsaToSujud
    beq $t4, 6, jalsaToQaida # if position is Jalsa (6) between prostrations, go to jalsaToQa'ida

qiyamToTakbir:
    # Update position to Takbir (2) and print it
    li $t4, 2
    li $v0, 4
    la $a0, takbir
    syscall
    j motionLoop # go back to motionLoop

takbirToRuku:
    # Update position to Ruku (3) and print it
    li $t4, 3
    li $v0, 4
    la $a0, ruku
    syscall
    j motionLoop # go back to motionLoop

rukuToSujud:
    # Update position to Sujud (4) and print it
    li $t4, 4
    li $v0, 4
    la $a0, sujud
    syscall

    # Increment sujudCount by 1
    addi $t3, $t3, 1

    j motionLoop # go back to motionLoop

sujudToJalsa:
    # Update position to Jalsa (5) and print it
    li $t4, 5
    li $v0, 4
    la $a0, jalsa
    syscall

    # Check if sujudCount is 2
    beq $t3, 2, jalsaToQaida # if sujudCount == 2, go to jalsaToQa'ida

    j motionLoop # go back to motionLoop

jalsaToSujud:
    # Update position to Sujud (4) and print it
    li $t4, 4
    li $v0, 4
    la $a0, sujud
    syscall

    # Increment sujudCount by 1
    addi $t3, $t3, 1

    j motionLoop # go back to motionLoop

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

    j prayerLoop # go back to prayerLoop

endLoop:
    # Ask if there has been any motion change
    li $v0, 4
    la $a0, askMotion
    syscall

    # Read user input
    li $v0, 5
    syscall
    move $t6, $v0 # store input in $t6

    # Check if input is 1 or 0
    beq $t6, 0, endLoop # if input is 0 (no motion change), repeat endLoop
    bne $t6, 1, endLoop # if input is not 1 (motion change), repeat endLoop

    # Input is 1 (motion change), proceed to next step

    # Update position based on current position
    beq $t4, 7, qaidaToTashahhud # if position is Qa'ida (7), go to qa'idaToTashahhud

qaidaToTashahhud:
    # Update position to Tashahhud (8) and print it
    li $t4, 8
    li $v0, 4
    la $a0, tashahhud
    syscall

    j salamLoop # go to salamLoop

salamLoop:
    # Ask if there has been any motion change
    li $v0, 4
    la $a0, askMotion
    syscall

    # Read user input
    li $v0, 5
    syscall
    move $t6, $v0 # store input in $t6

    # Check if input is 1 or 0
    beq $t6, 0, salamLoop # if input is 0 (no motion change), repeat salamLoop
    bne $t6, 1, salamLoop # if input is not 1 (motion change), repeat salamLoop

    # Input is 1 (motion change), proceed to next step

    # Update position based on current position
    beq $t4, 8, tashahhudToSalam # if position is Tashahhud (8), go to tashahhudToSalam

tashahhudToSalam:
    # Update position to Salam (9) and print it
    li $t4, 9
    li $v0, 4
    la $a0, salam
    syscall

    # Ask if user has completed the Salaam position
    li $v0, 4
    la $a0, askSalam
    syscall

    # Read user input
    li $v0, 5
    syscall
    move $t7, $v0 # store input in $t7

    # Check if input is 1 or 0
    beq $t7, 1, endProgram # if input is 1 (completed Salaam), go to endProgram
    bne $t7, 0, salamLoop # if input is not 0 (not completed Salaam), repeat salamLoop

endProgram:
    # Exit the program
    li $v0, 10
    syscall
    

    

    

    


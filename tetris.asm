################ CSC258H1F Winter 2024 Assembly Final Project ##################
# This file contains our implementation of Tetris.
#
# Student 1: Erin Kim, 1008933950
# Student 2: Name, Student Number (if applicable)
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       2
# - Unit height in pixels:      2
# - Display width in pixels:    64
# - Display height in pixels:   64
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

    .data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000

##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
	.text
	.globl main

lw $t0, ADDR_DSPL  # $t0 = base address for display
li $t1, 0xffb6c1    # $t1 stores light pink color code
li $t2, 0x000000     #0xf2b8c6    # $t2 stores greyish pink color code
li $t3, 0xb8e2f2    #t3 stores light blue
	# Run the Tetris game.
main:
    # Initialize the game
    
    

game_loop:
	# 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (paddle, ball)
	# 3. Draw the screen
	jal draw_checkerboard
	lw $t0, ADDR_DSPL  # $t0 = base address for display
	#addi $t6, $zero, 0   # Set $t0 back to 0
	addi $t7, $zero, 0   # Set $t7 to 0
	jal draw_walls
	jal draw_tetromino
	
	draw_checkerboard:
	add $t7, $zero, $zero  # set $t7 to 0, increments every second checkerboard row is drawn
	addi $t8, $zero, 1  # set $t8 to 1, increments every row of walls are drawn
	addi $t6, $zero, 16    #set $t6 to 16
	
	
	draw_two_rows:
	add $t5, $zero, $zero  #set $t5 to zero
	
	paint:
	beq $t5, $t6, next_second_row     # branch to go to the next row if $t5 == 16
	sw $t1, 0($t0)         # paint the first (top-left) unit light pink
	addi $t0, $t0, 4       # move to the next pixel over in the bitmap
	sw $t2, 0($t0)         # paint the second unit on the first row black
	addi $t0, $t0, 124     # move to the next pixel over in the bitmap (next row)
	sw $t2, 0($t0)         # paint the first pixel of second row black
	addi $t0, $t0, 4       # move to the next pixel over in the bitmap
	sw $t1, 0($t0)         # paint the second unit light pink
	addi $t0, $t0, -124    # move up to the previous row, beside the greyish pink pixel
	addi $t5, $t5, 1       # increment $t5 by 1
	j paint
	
	next_second_row:
	beq $t7, $t6, finish_checkerboard     # when $t7 is 16, we know we filled the checkerboard grid, signal that checkerboard is done
	addi $t0, $t0, 128     # move back to where you were originally, don't jump back to prev row, then add 4 (i dont really get why it isnt 124)
	addi $t7, $t7, 1       # increment $t7 by 1
	j draw_two_rows
	
	finish_checkerboard:
	jr $ra 
	
	draw_walls:
	beq $t8, $t6, draw_bottom  # branch to go to the draw_bottom if $t8 == 16 
	sw $t3, 0($t0)         # paint the first (left) unit light blue
	add $t0, $t0, 124        # move horizontal offset down by 124
    sw $t3, 0($t0)         # paint the first (right) unit light blue
    add $t0, $t0, 4        # move vertical offset down by one line
    sw $t3, 0($t0)         #paint the second (left) unit light blue
    add $t0, $t0, 124        # move horizontal offset down by 124
    sw $t3, 0($t0)         # paint the second (right) unit light blue
    add $t0, $t0, 4        # move vertical offset down by one line (for the loop after)
	addi $t8, $t8, 1       # increment $t8 by 1
	
	j draw_walls
	
	draw_bottom:
	beq $t7, $t6, finish_walls # branch to go to the draw_bottom if $t6 == 32 (could also just draw a 4by4 box and keep t6 as 16)
	sw $t3, 0($t0)         # paint the first (left) unit light blue
	add $t0, $t0, 4        # move horizontal offset down by one column
	sw $t3, 0($t0)         # paint the second (left) unit light blue
	add $t0, $t0, 124        # move vertical offset down by one line
	sw $t3, 0($t0)         # paint the second (left) unit light blue
	add $t0, $t0, 4        # move horizontal offset down by one column
	sw $t3, 0($t0)         # paint the second (left) unit light blue
	add $t0, $t0, -124        # move up to previous row, but to the right column of current
	addi $t7, $t7, 1       # increment $t7 by 1
	j draw_bottom
	
	finish_walls:
	jr $ra
	
	draw_tetromino:
	
	Exit:
	li $v0, 10 #terminate the program gracefully
	syscall
	
	
	# 4. Sleep
    #5. Go back to 1
    b game_loop

###########################################################
########## UNIVERSITÉ DU QUÉBEC À MONTREAL   ##############
##########      EMB7020 - CODESIGN           ##############
########## LUIS FABIANO BATISTA - BATL240773 ##############
##########         HIVER 2013                ##############
########## PROJET: JEU "BULLE" ÉCRIT EN MIPS ##############
###########################################################

.data 
#sctructure of Blue circle
circleBlueRadius: .word 10 	#Blue circle radius
circleBlueX: .word 320 		# Blue circle X coordinate	
circleBlueY: .word 240		# Blue circle X coordinate
minBlue: .word -1		# For a given line, this is the minimum X occupied by the Blue circle (negative means empty)
maxBlue: .word -1 		# For a given line, this is the maximum X occupided by the Blue circle (negative means empty)
touchBlue: .word 0 		#to indicate if it was touched by mouse

#sctructure of Red circle
circleRedRadius: .word 10	# Red circle radius
circleRedX: .word 320		# Red circle X coordinate
circleRedY: .word 240		# Red circle X coordinate 
minRed: .word -1		# For a given line, this is the minimum X occupied by the Red circle (negative means empty)
maxRed: .word -1		# For a given line, this is the maximum X occupided by the Red circle (negative means empty)
touchRed: .word 0 		#to indicate if it was touched by mouse

#sctructure of Green circle
circleGreenRadius: .word 10	# Green circle radius
circleGreenX: .word 320		# Green circle X coordinate
circleGreenY: .word 240		# Green circle X coordinate 
minGreen: .word -1		# For a given line, this is the minimum X occupied by the Green circle (negative means empty)
maxGreen: .word -1		# For a given line, this is the maximum X occupided by the Green circle (negative means empty)
touchGreen: .word 0 		#to indicate if it was touched by mouse
#Screen
pixelRow: .word 0		# Pixel Row coordinate (Y)
pixelCol: .word 0		# Pixel Column coordinate (X)
stateBlue: .word 0 		#1 to indicate if the color blue is enabled, 0 otherwise
stateRed: .word 0 		#1 to indicate if the color red is enabled, 0 otherwise
stateGreen: .word 0 		#1 to indicate if the color green is enabled, 0 otherwise
#Mouse
mouseX:	.word 320		# Mouse X position
mouseY: .word 240 		# Mouse Y position
mouseLButton: .word 0		# Mouse L button state (0 = not pressed; 1 = pressed)	
#Game variables
score: .word 0			# Game score
gameState: .word 1		#Game state (to be evaluated just before the screen rendering; 1=run ; 0=stop)

.text
################# MAIN FUNCTION ##############################
# This part contains the initialization and coordination of game action

main:
	
#generating initial random circle positions
	la $a0, circleBlueRadius
	jal randomCirclePos
	la $a0, circleRedRadius
	jal randomCirclePos
	la $a0, circleGreenRadius
	jal randomCirclePos

action:
# Checking if the circles overlap with each other. The circles that overlap will be re-generated.
# Testing 2 circles at a time

	la $a0, circleBlueRadius #store the address of CircleBlueRadius into $a0
	la $a1, circleRedRadius #store the address of CircleRedRadius into $a0
	jal overlapTest
	
	la $a0, circleBlueRadius #store the address of CircleBlueRadius into $a0
	la $a1, circleGreenRadius #store the address of CircleRedRadius into $a0
	jal overlapTest
	
	la $a0, circleRedRadius #store the address of CircleBlueRadius into $a0
	la $a1, circleGreenRadius #store the address of CircleRedRadius into $a0
	jal overlapTest

# Calling the scanDisplay procedure to scan the screen lines to determine the X min and max of 
# all circles and to determine the color of each pixel in the display (acoording to display coordinates)
# Also it will set a flag for the circle that has been clicked by the mouse
#### THIS IS VERY SLOW, SINCE IT WILL EXECUTE A SERIES OF PROCEDURES/FUNCTIONS FOR EVERY
#### SCREEN PIXEL (480 X 640 = 307200 TIMES)
#### IF YOU WANT TO TEST THE OTHER FUNCTIONALITIES OF THIS GAME (LIKE CIRCLE GENERATION, 
#### CICLE INCREASE, CIRCLE RE-GENERATION AFTER TOUCHING EACH OTHER, ETC, IT IS SUGGESTED
#### TO LEAVE THE FOLLOWING LINE COMMENTED.
	jal scanDisplay
	
# Calling the checkCircles procedure to check (for all circles) if they hit the borders. Also, 
# it will re-generated those circles that have been clicked by the mouse.
# It will increment the size of the circles that have not been re-generated
	jal checkCircles
	

# checking if the game should continue or not
	lw $s0, gameState 
	beq $s0, 1, action
	j end
############### END OF MAIN FUNCTION ###############################################


############### PROCEDURE SCANDISPLAY ###########################################
# This procedure is used to perform the scan of the display coordinates, to obtain
# the X max e min of each circle and to check if mouse hits the circle
# Also it sets the pixelRow and pixelCol variables with the proper color, depending
# on the coordinates of the screen scan

scanDisplay:
	addi $sp, $sp, -4 #allocate space on stack
	sw $ra, 0($sp) 	#push $ra onto stack
	# start sweeping the lines and columns
	li $k0, 0 #initialize line index (i)
	# L1 is the loop that will sweep accros the lines
L1: 	bge $k0, 480, endL1 #execute the loop until i<=479 (from 0 to 479)  
	sw $k0, pixelRow #store the current line number in the pixelRow data memory variable
	
	#Calculating Mix and Max for all circles for the current line
	la $a0, circleBlueRadius #load Blue circle structure address into $a0
	addi $a1, $k0, 0 #load line number into $a1
	jal getMinMax
	jal checkMouseClickCircle
	
	la $a0, circleRedRadius #load Blue circle structure address into $a0
	#addi $a1, $k0, 0 #load line number into $a1
	jal getMinMax
	jal checkMouseClickCircle
	
	la $a0, circleGreenRadius #load Blue circle structure address into $a0
	#addi $a1, $k0, 0 #load line number into $a1
	jal getMinMax
	jal checkMouseClickCircle
	
	li $k1, 0 #initilize column index (j)
	
	# L2 is the loop that will sweep accros the screen columns (it is inside L1)
L2: 	bge $k1, 640, endL2
	sw $k1, pixelCol #store the current column number in the pixelCol data memory variable  
	li $s0, 0 #initializing variable. 1 to indicate is blue, 0 otherwise
	li $s1, 0 #initializing variable. 1 to indicate is red, 0 otherwise
	li $s2, 0 #initializing variable. 1 to indicate is green, 0 otherwise
	la $t0, circleBlueRadius #load Blue circle structure address into $a0
	lw $t1, 12($t0) #load X min into t1
	lw $t2, 16($t0) #load X max into t2
	blt $k1, $t1, checkRed #if column index is less than X min, test for other color
	bgt $k1, $t2, checkRed #if column index is greater than X max, test for other color
	li $s0, 1 #informing that it is blue
checkRed:
	la $t0, circleRedRadius #load Red circle structure address into $a0
	lw $t1, 12($t0) #load X min into t1
	lw $t2, 16($t0) #load X max into t2
	blt $k1, $t1, checkGreen #if column index is less than X min, test for other color
	bgt $k1, $t2, checkGreen #if column index is greater than X min, test for other color
	li $s1, 1 #informing that it is Red
checkGreen:
	la $t0, circleGreenRadius #load Red circle structure address into $a0
	lw $t1, 12($t0) #load X min into t1
	lw $t2, 16($t0) #load X max into t2
	blt $k1, $t1, checkMouseColor #if column index is less than X min, test for other color
	bgt $k1, $t2, checkMouseColor #if column index is less than X min, test for other color
	li $s2, 1 #informing that it is Green
checkMouseColor:
	la $t0, mouseX #load Red circle structure address into $a0
	lw $t1, 4($t0) #load mouseY into t1
	lw $t2, 0($t0) #load mouseX into t2
	bne $k0, $t1, endCheckColor #if line index is different from mouseY, go to endCheckColor
	bne $k1, $t2, endCheckColor #if column index is different from mouseX, go to endCheckColor
	li $s0, 1 #for mouse, all colors are ON
	li $s1, 1 #for mouse, all colors are ON
	li $s2, 1 #for mouse, all colors are ON
endCheckColor:
	sw $s0, stateBlue #store result into the proper memory address
	sw $s1, stateRed #store result into the proper memory address
	sw $s2, stateGreen #store result into the proper memory address
	
	addi $k1, $k1, 1 #j=j+1
	j L2
endL2: 	
	
	addi $k0, $k0, 1 # i = i+1
	j L1
endL1:
	lw $ra, 0($sp) #pop $ra off stack
	addi $sp, $sp, 4 #deallocate space on stack
	jr $ra
##################### END OF SCANDISPLAY PROCEDURE ##########################################


##################### PROCEDURE CHECKCIRCLES ################################################
# This procedure is used to coordinate the calling of checkHitBorder function
# In case a circle hits the border, it will set the gameStatus variable to 0 (so the game will end)
# Also, it will check tje touch<color name> variable (which tells if the circle was already hit by the mouse). 
# In this case, a new circle will be generated. 
# It will also increment the size of the circles that didn't have to be re-generated

checkCircles:
	addi $sp, $sp, -4 #allocate space on stack
	sw $ra, 0($sp) 	#push $ra onto stack
	la $a0, circleBlueRadius
	jal checkHitBorder
	lw $t0, 20($a0) # load touch<colorname> variable value
	beq $t0, $zero, incsz1
	jal randomCirclePos
	sw $zero, 20($a0) #reset load<colorname> flag to 0
	j chk2
incsz1:	jal updateCircleRadius
chk2:	la $a0, circleRedRadius
	jal checkHitBorder
	lw $t0, 20($a0) # load touch<colorname> variable value
	beq $t0, $zero, incsz2
	jal randomCirclePos
	sw $zero, 20($a0) #reset load<colorname> flag to 0
	j chk3
incsz2: jal updateCircleRadius
chk3: 	la $a0, circleGreenRadius
	jal checkHitBorder
	lw $t0, 20($a0) # load touch<colorname> variable value
	beq $t0, $zero, incsz3
	jal randomCirclePos
	sw $zero, 20($a0) #reset load<colorname> flag to 0
	j chkend
incsz3: jal updateCircleRadius	
chkend:
	lw $ra, 0($sp) #pop $ra off stack
	addi $sp, $sp, 4 #deallocate space on stack
	jr $ra	
############### END OF CHECKCIRCLES #################################################
	



############  PROCEDURE OVERLAPTEST ###################################################
#Calls the checkOverlap function for 2 circles and re-generate the circle that has overlaped with
# others (the one with bigger radius. If radius are the same size, the second one will be re-generated
# $a0 and #a1 are the 2 circle structure pointers

overlapTest:
	addi $sp, $sp, -12 #allocate space on stack
	sw $ra, 0($sp) 	#push $ra onto stack
	sw $a0, 4($sp) 	#push $a0 onto stack
	sw $t0, 8($sp) #push $t0 onto stack
	addi $t0, $a0, 0
overlapTest1:
	addi $a0, $t0, 0
	jal checkOverlap
	bne $v0, 1, overlapTestFinal #go to branch if there is no overlap
	addi $a0, $v1, 0 #load $v1 content (the address of the bigger circle) into $a0
	jal randomCirclePos
	j overlapTest1
overlapTestFinal: 
	lw $ra, 0($sp) #pop $ra off stack
	lw $a0, 4($sp) #pop $ra off stack
	lw $t0, 8($sp) #pop $ra off stack
	addi $sp, $sp, 12 #deallocate space on stack
	jr $ra
############### END OF OVERLAPTEST PROCEDURE ############################################


################ FUNCTION GENERATERANDOMNUMBER ###############################	
# Used to generate random position
# input is $a1 (upper limit)
# output is written to $v0

generateRandomNumber:
	addi $sp, $sp, -8 #allocate space on stack
	sw $ra, 0($sp) 	#push $ra onto stack
	sw $a0, 4($sp) 	#push $a0 onto stack
	li $v0, 30 #get system time ans store in $a0
	syscall

	#$a1 will be passed by caller
	li $v0, 42   #random function using $a0 as seed and $a1 as upper limt
	syscall 
		
	addi  $a0, $a0, 20 #20 is lower limit
	syscall
	
	addi $v0, $a0, 0 #sending #a0 to output $v0
	lw $ra, 0($sp) #pop $ra off stack
	lw $a0, 4($sp) #pop $ra off stack
	addi $sp, $sp, 8 #deallocate space on stack
	jr $ra
############ END OF GENERATERANDOMNUMBER FUNCTION ###############################


################ PROCEDURE RANDOMCIRCLEPOS ######################################
# Generate random (X, Y) directly in the circle structure via pointers
# a0 is the pointer of the circle structure (radius variable)
# It will also reset the circle radius to 10
randomCirclePos:
	addi $sp, $sp, -16 #allocate space on stack
	sw $ra, 0($sp) 	#push $ra onto stack
	sw $t0, 4($sp) #push $t0 onto stack
	sw $a0, 8($sp) #push $a0 onto stack
	sw $a1, 12($sp) #push $a1 onto stack
	#addi $t0, $a0, 0 #store $a0 into the temp variable $t0
	li $a1, 600 #ceiling to be passed to the generateRandomNumber function 
	jal generateRandomNumber
	sw $v0, 4($a0) # output corresponding to the X coordinate (from 20 to 620)
	li $a1, 440 #ceiling to be passed to the generateRandomNumber function
	jal generateRandomNumber
	sw $v0, 8($a0) #Output corresponding to Y coordinate (from 20 t0 620)
	
	li $t0, 10
	sw $t0, 0($a0) #reset radius to 10
	
	lw $ra, 0($sp) #pop $ra off stack
	lw  $t0, 4($sp) #pop $t0 off stack
	lw  $a0, 8($sp) #pop $a0 off stack
	lw  $a1, 12($sp) #pop $a1 off stack
	addi $sp, $sp, 16 #deallocate space on stack
	jr $ra
############## END OF RANDOMCIRCLEPOS ##########################################

############# PROCEDURE UPDATECIRCLERADIUS ######################################
####Procedure to update the Circle radius##########
# $a0 is the pointer of the circle radius variable
updateCircleRadius:
	addi $sp, $sp, -8 #allocate space on stack
	sw $ra, 0($sp) 	#push $ra onto stack
	sw $t0, 4($sp) #push $t0 onto stack
	lw $t0, 0($a0) #store in $t0 the value of the radius variable pointed by $a0
	addi $t0, $t0, 1 #add one to the radius value
	sw $t0, 0($a0) # write the result into the radius variable pointed by $a0
	lw $ra, 0($sp) #pop $ra off stack
	lw  $t0, 4($sp) #pop $t0 off stack
	addi $sp, $sp, 8 #deallocate space on stack
	jr $ra
###########END OF PROCEDURE UPDATECIRCLERADIUS #####################################



###################### PROCEDURE GETMINMAX ###########################################
####Procedure to calculate min and max of a circle limits in each line ###############
# $a0 is the pointer of circle structure
# $a1 is the line number
getMinMax:
	addi $sp, $sp, -32 #allocate space on stack
	sw $ra, 0($sp) #push $ra onto stack
	sw $t0, 4($sp) #push $t0 onto stack
	sw $t1, 8($sp) #push $t1 onto stack
	sw $t2, 12($sp) #push $t2 onto stack
	sw $t3, 16($sp) #push $t3 onto stack
	sw $t4, 20($sp) #push $t4 onto stack
	sw $t5, 24($sp) #push $t5 onto stack
	sw $a0, 28($sp) #push $t5 onto stack 
	lw $t0, 0($a0) #store in $t0 the Radius value pointed by $a0+offset
	lw $t1, 4($a0) #store in $t1 the X value pointed by $a0+offset
	lw $t2, 8($a0) #store in $t2 the Y value pointed by $a0+offset
	sub $t3, $a1, $t2 #$t3 = LineNumber - Y
	mulo $t0, $t0, $t0 #$t0 = R^2
	mulo $t3, $t3, $t3 #$t3 = (LineNumber - Y)^2
	sub $t4, $t0, $t3 #$t4 = R^2 - (LineNumber-Y)^2
	bgez $t4, getMinMax1
	li $t0, -1 #negative value to indicate that X min and max were not found
	sw $t0, 12($a0) #set Xmin = -1 if line does not cross the circle
	sw $t0, 16($a0) #set Max = -1 if line does not cross the circle
	j getMinMax2
getMinMax1:
	
	addi $a0, $t4, 0 #load $t4 in $a0
	jal sqrt #$v0 = sqrt($t4) call the sqrt function
	addi $t4, $v0, 0 #load $v0 in $t4
	lw  $a0, 28($sp) #recover $a0 original
	
	sub $t5, $t1, $t4 #Xmin = X - t4
	sw $t5, 12($a0) #store xmin in the circle structure
	add $t5, $t1, $t4 #Xmax = X + t4
	sw $t5, 16($a0) #store xmax in the circle structure
	
getMinMax2: 	
	
	lw $ra, 0($sp) #pop $ra off stack
	lw  $t0, 4($sp) #pop $t0 off stack
	lw  $t1, 8($sp) #pop $t1 off stack
	lw  $t2, 12($sp) #pop $t2 off stack
	lw  $t3, 16($sp) #pop $t3 off stack
	lw  $t4, 20($sp) #pop $t4 off stack
	lw  $t5, 24($sp) #pop $t5 off stack
	lw  $a0, 28($sp) #pop $t5 off stack
	addi $sp, $sp, 32 #deallocate space on stack
	jr $ra
############### END OF PROCEDURE GETMINMAX ###########################################

############## PROCEDURE CHECKMOUSECLICKCIRCLE #######################################
#Procedure to check if the mouse hits a given circle and to compute the score (if circle is hit by mouse)
# $a0 is the pointer of circle structure
# $a1 is the line number
# Writes 1 to touch<CircleColor> memory variable if mouse hits the circle
checkMouseClickCircle:
	addi $sp, $sp, -24 #allocate space on stack
	sw $ra, 0($sp) #push $ra onto stack
	sw $t0, 4($sp) #push $t0 onto stack
	sw $t1, 8($sp) #push $t1 onto stack
	sw $t2, 12($sp) #push $t2 onto stack
	sw $t3, 16($sp) #push $t3 onto stack
	sw $t4, 20($sp) #push $t4 onto stack
	lw $t0, mouseX #load mouse X coordinate into $t0
	lw $t1, mouseY #load mouse Y coordiante into $t1
	lw $t2, mouseLButton #load mouse left button state into $t2
	lw $t3, 12($a0) #load circle min into $t3
	lw $t4, 16($a0) #load circle max into $t4

	beq $t2, 0, checkMCC2 #go to final part if mouse button is not pressed
	bne $t1, $a1, checkMCC2 #go to final part if mouse Y is not in the $a1 line
	blt $t0, $t3, checkMCC2 #go to final part if mouse X is < circle min
	bgt $t0, $t4, checkMCC2 #go to final part if mouse X is > circle max
	li $t3, 1  #to indicate the mouse hits the circle in the specific line
	sw $t3, 20($a0)
	
	li $t0, 10000 #initial factor for score computation
	lw $t1, 0($a0) #load circle radius into $t1
	lw $t2, score #load current score into $t2
	div $t0, $t0, $t1 #initial factor / circle radius
	add $t2, $t2, $t0 #score = score + (init.factor/cir.radius)
	sw $t2, score #store score calculation result into data memory
checkMCC2:
	lw $ra, 0($sp) #pop $ra off stack
	lw  $t0, 4($sp) #pop $t0 off stack
	lw  $t1, 8($sp) #pop $t1 off stack
	lw  $t2, 12($sp) #pop $t2 off stack
	lw  $t3, 16($sp) #pop $t3 off stack
	lw  $t4, 20($sp) #pop $t4 off stack
	addi $sp, $sp, 24 #deallocate space on stack
	jr $ra
############## END OF PROCEDURE CHECKMOUSECLICKCIRCLE ####################################

######################## FUNCTION CHECKOVERLAP ##########################################
####Procedure to check if 2 circles are overlapped or touching each other
# $a0 is the pointer of circle 1 and $a1 is the pointer of circle 2
# $v0 is 1 if there is overlap, 0 otherwise; $v1 has the address of the circle with bigger radious;
checkOverlap:
	addi $sp, $sp, -40 #allocate space on stack
	sw $ra, 0($sp) #push $ra onto stack
	sw $t0, 4($sp) #push $t0 onto stack
	sw $t1, 8($sp) #push $t1 onto stack
	sw $t2, 12($sp) #push $t2 onto stack
	sw $t3, 16($sp) #push $t3 onto stack
	sw $t4, 20($sp) #push $t4 onto stack
	sw $t5, 24($sp) #push $t5 onto stack
	sw $t6, 28($sp) #push $t6 onto stack
	sw $t7, 32($sp) #push $t7 onto stack
	sw $a0, 36($sp) #push $a0 onto stack
	lw $t0, 0($a0) #radius of circle 1 -> R1
	lw $t1, 4($a0) #X coordinate of circle 1 -> X1
	lw $t2, 8($a0) #Y coordinate of circle 1 -> Y1
	lw $t3, 0($a1) #radius of circle 2 -> R2
	lw $t4, 4($a1) #X coordinate of circle 2 -> X2
	lw $t5, 8($a1) #Y coordinate of circle 2 -> Y2
	sub $t6, $t1, $t4 #X1-X2
	mulo $t6, $t6, $t6 #power of 2 (X1-X2)^2
	sub $t7, $t2, $t5#Y1-Y2
	mulo $t7, $t7, $t7 #power of 2 (Y1-Y2)^2
	add $t1, $t6, $t7 #$t1 = (X1-X2)^2 + (Y1-Y2)^2
	
	addi $a0, $t1, 0 #load #t1 into $a0 to calculate the sqrt
	jal sqrt  #$v0 = sqrt($t1)
	addi $t1, $v0, 0 #load #v0 into #t1
	lw $a0, 36($sp) #recover original $a0
	
	add $t4, $t0, $t3 #$t4 = R1+R2
	bge $t4, $t1, checkFirstIsBigger #go to brach if t4 is bigger or equal to t1
	li $v0, 0 #0 to confirm that there is no overlap
	j finally #go to branch to pop values from stack and return
checkFirstIsBigger:
	li $v0, 1 #1 to confirm that there is an overlap
	bge $t3, $t0, secondIsBigger #to to branch if second circle is bigger
	addi $v1, $a0, 0 #outputing the address of the first circle as being the bigger one
	j finally #go to branch to pop values from stack and return
secondIsBigger:
	addi $v1, $a1, 0 #outputing the address of the second circle as being the bigger one
finally:
	lw $ra, 0($sp) #pop $ra off stack
	lw $t0, 4($sp) #pop $t0 off stack
	lw $t1, 8($sp) #pop $t1 off stack
	lw $t2, 12($sp) #pop $t2 off stack
	lw $t3, 16($sp) #pop $t3 off stack
	lw $t4, 20($sp) #pop $t4 off stack
	lw $t5, 24($sp) #pop $t5 off stack
	lw $t6, 28($sp) #pop $t6 off stack
	lw $t7, 32($sp) #pop $t7 off stack
	lw $a0, 36($sp) #pop $a0 off stack
	addi $sp, $sp, 40 #deallocate space on stack
	jr $ra
######################## END OF FUNCTION CHECKOVERLAP ##########################################	


####################### PROCEDURE CHECKHITBORDER  ##############################################
# check of a circle hits the screen border
# $a0 is the pointer of the structure
# in case it hits the border, it set the gameState variable to 0
checkHitBorder:
	addi $sp, $sp, -24 #allocate space on stack
	sw $ra, 0($sp) #push $ra onto stack
	sw $t0, 4($sp) #push $t0 onto stack
	sw $t1, 8($sp) #push $t1 onto stack
	sw $t2, 12($sp) #push $t2 onto stack
	sw $t3, 16($sp) #push $t3 onto stack
	sw $t4, 20($sp) #push $t4 onto stack
	
	lw $t0, 0($a0) # circle radius
	lw $t1, 4($a0) #circle X center pos.
	lw $t2, 8($a0) #circle Y center pos.
	add $t3, $t1, $t0 #maxX = X + radius
	sub $t1, $t1, $t0 #minX = X - radius
	add $t4, $t2, $t0 #maxY = Y + radius
	sub $t2, $t2, $t0 #minY = Y - radius
	blez $t1, checkHitBorder1
	bge $t3, 639, checkHitBorder1
	blez $t2, checkHitBorder1
	bge $t4, 479, checkHitBorder1
	j checkHitBorderFinal
checkHitBorder1:
	sw $zero, gameState
checkHitBorderFinal:
	lw $ra, 0($sp) #pop $ra off stack
	lw  $t0, 4($sp) #pop $t0 off stack
	lw  $t1, 8($sp) #pop $t1 off stack
	lw  $t2, 12($sp) #pop $t2 off stack
	lw  $t3, 16($sp) #pop $t3 off stack
	lw  $t4, 20($sp) #pop $t4 off stack

	addi $sp, $sp, 24 #deallocate space on stack
	jr $ra
####################### END OF PROCEDURE CHECKHITBORDER  #######################################

########## SQUARE ROOT FUNCTION ##################################
# function to output the square root of an input
# $a0 is the input (x)
# $v0 is the output (root)
# this function uses the alghorithm presented in class
sqrt:
	addi $sp, $sp, -24 #allocate space on stack
	sw $ra, 0($sp) #push $ra onto stack
	sw $t0, 4($sp) #push $t0 onto stack
	sw $t1, 8($sp) #push $t1 onto stack
	sw $t2, 12($sp) #push $t2 onto stack
	sw $t3, 16($sp) #push $t3 onto stack
	sw $t4, 20($sp) #push $t4 onto stack
	li $t0, 0 #root
	li $t1, 0 #remHi
	addi $t2, $a0, 0 #remLo = x
	li $t3, 15 #count = width/2-1

sqrt1:
	sll $t1, $t1, 2 #remHi<<2
	srl $t4, $t2, 30 #remLo>>(width-2)
	or $t1, $t1, $t4 #remHI = remHi<<2 | remLo>>(width-2)
	sll $t2, $t2, 2 #remLo <<=2
	sll $t0, $t0, 1 #root<<=1
	sll $t4, $t0, 1 #root << 1)
	addi $t4, $t4, 1 #testdiv = (root <<1)+1
	blt $t1, $t4, sqrt2 #(if remHi < testDiv goto srqt2)
	sub $t1, $t1, $t4 #remHi -=testDiv
	addi $t0, $t0, 1 #root++
sqrt2:
	beqz $t3, sqrtend
	addi $t3, $t3, -1 #count--
	j sqrt1
sqrtend:
	addi $v0, $t0, 0 #output = root
	lw $ra, 0($sp) #pop $ra off stack
	lw  $t0, 4($sp) #pop $t0 off stack
	lw  $t1, 8($sp) #pop $t1 off stack
	lw  $t2, 12($sp) #pop $t2 off stack
	lw  $t3, 16($sp) #pop $t3 off stack
	lw  $t4, 20($sp) #pop $t4 off stack
	addi $sp, $sp, 24 #deallocate space on stack	
	jr $ra
####### END OF SQRT FUNCTION #########################################


	
end:
#end of program

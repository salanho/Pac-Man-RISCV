.data
intro1: .string "intro1.bin"
main1: .string "main1.bin"
main2: .string "main2.bin"
main3: .string "main3.bin"
main4: .string "main4.bin" 
instrucoes1: .string "instrucoes1.bin"
instrucoes2: .string "instrucoes2.bin" 
creditos1: .string "credito1.bin" 
gameover1: .string "gameover1.bin"
gameover2: .string "gameover2.bin"

aux.script: .space 673
####### JOGAR ########
score: .word 0,10000000 # score , limit
lives: .word 3 
counter: .half 0,0	# counter , limit
run.time: .half 0
#####################
# Transition scene
NEXT_STAGE_FILE: .string "nextstage.bin"
BACKGROUND_NEXT_STAGE1_FILE: .string "transicao_fase1.bin"
BACKGROUND_NEXT_STAGE2_FILE: .string "transicao_fase2.bin"
BACKGROUND_NEXT_STAGE3_FILE: .string "transicao_fase3.bin"
BACKGROUND_NEXT_STAGE4_FILE: .string "transicao_fase4.bin"
SCENE_TRANSITION: .space 7808
#####################
# Death scene
DEATH_MSPACMAN_FILE: .string "MsPacmanDeath.bin"
DEATH_MSPACMAN: .space 1024
#####################
# Background map
BACKGROUND_MAP: .string "background_map.bin"
#####################
# Mecanics
distance.blinky: .float 0
distance.pinky: .float 0
distance.inky: .float 0
distance.clyde: .float 0
distance.fruit: .float 0
.align 1
game.mode: .space 7	#  | half: chase | half scatter | half: counter |  0000 0001 = chase,0000 0010 = scattter
#####################
#####################
# Map slots
.align 2
map.image: .space 55552
map.char: .space 868
map.frame: .space 868
map.return: .word 0x00000000
house.coor: .half 108,88
blinky.corner: .half 0,0
pinky.corner: .half 0,0
inky.corner: .half 0,0
clyde.corner: .half 0,0
.align 2
#####################

#####################
# MAPA 1
map1.image_file: .string "Mapa1.bin"
map1.frame_file: .string "map1frame.bin"
cherry_file: .string "cherry.bin"
strawberry_file: .string "strawberry.bin"
map1fruit_path_file: .string "map1fruit_path.bin"
####################

#####################
# MAPA 2
map2.image_file: .string "Mapa2.bin"
map2.frame_file: .string "map2frame.bin"
orange_file:  .string "orange.bin" 
pretzel_file: .string "pretzel.bin"
map2fruit_path_file: .string "map2fruit_path.bin"
####################

#####################
# MAPA 3
map3.image_file: .string "Mapa3.bin"
map3.frame_file: .string "map3frame.bin"
apple_file:  .string "apple.bin" 
pear_file: .string "pear.bin"
map3fruit_path_file: .string "map3fruit_path.bin"
####################

#####################
# MAPA 4
map4.image_file: .string "Mapa4.bin"
map4.frame_file: .string "map4frame.bin"
banana_file:  .string "banana.bin" 
key_file: .string "key.bin"
map4fruit_path_file: .string "map4fruit_path.bin"
####################
# Animation algorythm
.macro PRINT_NEXT_STAGE(%BACKGROUND_NEXT_STAGE_FILE)
#{
	addi a7 zero 1024
	la a0, %BACKGROUND_NEXT_STAGE_FILE
	add a1 zero zero
	ecall

	addi t0,a0,0	#obs: t0 = file descriptor
	li a7,63
	lI a1,0xFF000000
	li a2,76800
	ecall

	addi a0,t0,0	#obs: t0 = file descriptor
	li a7,57
	ecall
	
	add t3 zero zero
	add t2 zero zero
	add t1 zero zero
	add s3 zero zero
		
	PRINT_SCENE_LOOP:
		addi t0 zero 68
		beq t3 t0 END_PRINT_SCENE_LOOP
		addi t0 zero 4
		rem t4 t3 t0
		beq t4 zero SET_VALUES_SCENE_MSPACMAN
		jal zero PRINT_SCENE_LOOP2 
		SET_VALUES_SCENE_MSPACMAN:
			la s0 SCENE_TRANSITION
			li s1 0xFF009650 
			addi s3 s3 4
			add s1 s1 s3
		PRINT_SCENE_LOOP2:
			addi t0 zero 16
			beq t2 t0 END_PRINT_SCENE_LOOP2
			PRINT_SCENE_LOOP3:
				addi t0 zero 122
				beq t1 t0 END_PRINT_SCENE_LOOP3
				
					
				lh t4 0(s0)	# Posição inicial da MsPacman para print
				sh t4 0(s1)
			
				addi s0 s0 2
				addi s1 s1 2
				addi t1 t1 2
				jal zero PRINT_SCENE_LOOP3
			END_PRINT_SCENE_LOOP3: 
			addi s1 s1 198		# Quebra de linha
			add t1 zero zero	# Zera o contador do loop 3
			addi t2 t2 1
			jal zero PRINT_SCENE_LOOP2
		END_PRINT_SCENE_LOOP2:
		li s1 0xFF009650
		addi s3 s3 4
		add s1 s1 s3
		add t2 zero zero
		add t1 zero zero
		addi a7 zero 32		# Sleep para a próxima imagem 
		addi a0 zero 40
		ecall
		addi t3 t3 1
		jal zero PRINT_SCENE_LOOP
	END_PRINT_SCENE_LOOP:
.end_macro
#}

#####################
########MSPAC########
#{
	mspac.speed: .byte 0,15		# k , speed
	.align 2
	mspac.coor: .half 104,184	# (x,y)
	mspac.grid.coor: .byte 13,23,0	# (x,y,grid)
	mspac.image.coor: .half 99,176	# (xi,yi) 
	mspac.direction: .word 0	# (h,v,dir,bit_dir)	dir 0,1,2,3 - Direita,Baixo,Esquerda,Cima
	mspac.pre_direction: .word 0	# (pre_h,pre_v,pre_dir,pre_bit_dir)
	mspac.image_adress: .word 0	# &Direcao selecionada
	mspac.animation: .half 0	# &Etapa selecionada
	mspac.image_file: .string "MsPacman.bin"
	# "MsPacman1.bin"
	mspac.image: .space 5184
#}
########GHOSTS########
# BLINKY
#{
	blinky.ia_state: .byte -1	# state,limit	state<0 = unused
	blinky.speed: .byte 0,30		# k , speed
	.align 2
	blinky.coor: .half 48,32	# (x,y)
	blinky.grid.coor: .byte 6,4,0	# (x,y,grid)
	blinky.image.coor: .half 43,24	# (xi,yi) 
	blinky.direction: .word 0	# (h,v,dir,bit_dir)	dir 0,1,2,3 - Direita,Baixo,Esquerda,Cima
	blinky.image_adress: .word 0	# &Direcao selecionada
	blinky.animation: .half 0	# &Etapa selecionada
	blinky.image_file: .string "Blinky.bin"
	blinky.image: .space 10368
	.align 1
	blinky.status: .space 3
	#  0000 0001 = chase, 0000 0010 = scatter, 0000 0100 = blue, 0000 1000 = white, 0001 0000 eye, 0010 0000 = exit, 0100 0000 = enter, 1000 0000 = slow
	blinky.enter_home_file: .string "blinky_enter.bin"
	.align 2
	blinky.enter_home: .space 48
	blinky.exit_home_file: .string "blinky_exit.bin"
	.align 2
	blinky.exit_home: .space 104
	blinky.script_counter: .half 0
#}

# PINKY
#{
	pinky.ia_state: .byte -1	# state,limit	state<0 = unused
	pinky.speed: .byte 1,20		# k , speed
	.align 2
	pinky.coor: .half 168,32	# (x,y)
	pinky.grid.coor: .byte 21,4,0	# (x,y,grid)
	pinky.image.coor: .half 163,24	# (xi,yi)
	pinky.direction: .word 0	# (h,v,dir,bit_dir)	dir 0,1,2,3 - Direita,Baixo,Esquerda,Cima
	pinky.image_adress: .word 0	# &Direcao selecionada
	pinky.animation: .half 0	# &Etapa selecionada
	pinky.image_file: .string "Pinky.bin"
	pinky.image: .space 10368
	.align 1
	pinky.status: .space 3
	# 0000 0001 = chase, 0000 0010 = scatter, 0000 0100 = blue, 0000 1000 = white,  0001 0000 = eye, 0010 0000 = exit, 0100 0000 = enter, 1000 0000 = slow (bordas do mapa) 
	pinky.enter_home_file: .string "pinky_enter.bin"
	.align 2
	pinky.enter_home: .space 48
	pinky.exit_home_file: .string "pinky_exit.bin"
	.align 2
	pinky.exit_home: .space 104
	pinky.script_counter: .half 0
#}

# INKY
#{
	inky.ia_state: .byte -1		# state,limit	state<0 = unused
	inky.speed: .byte 0,15		# k , speed
	.align 2
	inky.coor: .half 48,232		# (x,y)
	inky.grid.coor: .byte 6,29,0	# (x,y,grid)
	inky.image.coor: .half 43,224	# (xi,yi) 
	inky.direction: .word 4	# (h,v,dir,bit_dir)	dir 0,1,2,3 - Direita,Baixo,Esquerda,Cima
	inky.image_adress: .word 0	# &Direcao selecionada
	inky.animation: .half 0		# &Etapa selecionada
	inky.image_file: .string "Inky.bin"
	inky.image: .space 10368
	.align 1
	inky.status: .space 3
	# 0000 0001 = chase, 0000 0010 = scatter, 0000 0100 = blue, 0000 1000 = white,  0001 0000 = eye, 0010 0000 = exit, 0100 0000 = enter, 1000 0000 = slow (bordas do mapa) 
	inky.enter_home_file: .string "inky_enter.bin"
	.align 2
	inky.enter_home: .space 80
	inky.exit_home_file: .string "inky_exit.bin"
	.align 2
	inky.exit_home: .space 168
	inky.script_counter: .half 0
#}

# CLYDE
#{
	clyde.ia_state: .byte -1	# state,limit	state<0 = unused
	clyde.speed: .byte 1,15		# k , speed
	.align 2
	clyde.coor: .half 168,232	# (x,y)
	clyde.grid.coor: .byte 21,29,0	# (x,y,grid)
	clyde.image.coor: .half 163,224	# (xi,yi) 
	clyde.direction: .word 0	# (h,v,dir,bit_dir)	dir 0,1,2,3 - Direita,Baixo,Esquerda,Cima
	clyde.image_adress: .word 0	# &Direcao selecionada
	clyde.animation: .half 0	# &Etapa selecionada
	clyde.image_file: .string "Clyde.bin"
	clyde.image: .space 10368
	.align 1
	clyde.status: .space 3
	# 0000 0001 = chase, 0000 0010 = scatter, 0000 0100 = blue, 0000 1000 = white,  0001 0000 = eye, 0010 0000 = exit, 0100 0000 = enter, 1000 0000 = slow (bordas do mapa) 
	clyde.enter_home_file: .string "clyde_enter.bin"
	.align 2
	clyde.enter_home: .space 80
	clyde.exit_home_file: .string "clyde_exit.bin"
	.align 2
	clyde.exit_home: .space 168
	clyde.script_counter: .half 0
#}
### BLUE GHOST
blue.image_file: .string "blue_ghost.bin"
blue.image: .space 648
blue.image_pointer: .word 0
white.image_file: .string "almost_blue_ghost.bin"
white.image: .space 1296
white.image_pointer: .word 0
eye.image_file: .string "dead_ghost.bin"
eye.image: .space 1296
eye.image_pointer: .word 0

### FRUIT
fruit.image: .space 2736
fruit.path: .space 2692
fruit.direction: .word 0
fruit.image_pointer: .word 0
fruit.spawn: .half 0,0
fruit.image.coor: .half 0,0
fruit.coor: .half 0,0
fruit.animation: .half 0
fruit.path_counter: .half 0
fruit.clock: .half 400

.macro LARGURA (%x)
addi %x,zero,224	# Em pixels
.end_macro

.macro ALTURA (%x)
addi %x,zero,248	# Em pixels
.end_macro

.macro PONTO_INICIAL (%x)
li %x,0xff000060	# Deve estar alinhado à WORD. 0xff000000 está alinhado, logo, pular de 4 em 4 para escolher
addi %x,%x,0	#Quanto deve ser somado?
.end_macro

.macro SOUND(%pitch,%duration,%instrument,%volume)
	addi a0,zero,%pitch
	addi a1,zero,%duration
	addi a2,zero,%instrument
	addi a3,zero,%volume
	addi a7,zero,31
	ecall
.end_macro

.macro SOUND_SYNC(%pitch,%duration,%instrument,%volume)
	addi a0,zero,%pitch
	addi a1,zero,%duration
	addi a2,zero,%instrument
	addi a3,zero,%volume
	addi a7,zero,33
	ecall
.end_macro

.macro SLEEP (%x)
# SLEEP
li a7,32
li a0,%x
ecall
.end_macro

.macro SPEED (%k_adress,%speed,%y)
#{
	lb t0,0(%k_adress)	# k
	addi t2,t0,1		# k++
	rem t2,t2,%speed	# (k++)%speed
	sb t2,0(%k_adress)	# k = (k++)%speed
	beq t0,zero,%y		# k anterior é zero?		
#}
.end_macro

.macro INVERSAO (%direction)
#{
	la t2,%direction
	addi t3,zero,-1
	
	lb t0,0(t2)	# h
	mul t0,t0,t3	# -h
	sb t0,0(t2)	# h = -h

	lb t0,1(t2)	# v
	mul t0,t0,t3	# -v
	sb t0,1(t2)	# v = -v
	
	lb t0,2(t2)	# dir
	addi t0,t0,2	# dir+2
	addi t1,zero,4
	rem t0,t0,t1	# (dir+2)%4
	sb t0,2(t2)	# dir = (dir+2)%4

	addi t1,zero,1
	sll t0,t1,t0	# deslocar um bit = mul por 2
	sb t0,3(t2)
#}
.end_macro

.macro FILE_TO_BUFFER (%file,%buffer,%size)
#{
# Open file
	li a7,1024
	la a0,%file
	li a1,0
	ecall

	addi t0,a0,0	#obs: a0 = file descriptor
	# Read file
	li a7,63
	la a1,%buffer
	li a2,%size
	ecall

	# Close file
	addi a0,t0,0	#obs: t0 = file descriptor
	li a7,57
	ecall
#}
.end_macro

.macro SET_GAME (%chase,%scatter,%blinky.corner.x,%blinky.corner.y,%pinky.corner.x,%pinky.corner.y,%inky.corner.x,%inky.corner.y,%clyde.corner.x,%clyde.corner.y,%run.time,%fruit.spawn.y)
#{
	# FRUIT SPAWN
	la t0,fruit.spawn
	addi t1,zero,-21 # x = -16 - 5
	addi t2,zero,%fruit.spawn.y
	sh t1,0(t0)
	sh t2,2(t0)
	la t3,fruit.image.coor
	sh t1,0(t3)
	sh t2,2(t3)

	# RUN TIME
	la t0,run.time
	li t1,%run.time
	sh t1,0(t0)

	# SCATTER AND CHASE
	la t0,game.mode
	li t1,%chase
	li t2,%scatter
	sh zero,4(t0)
	sh t1,0(t0)
	sh t2,2(t0)
	li t3,2	# começar no scatter
	sb t3,6(t0)
	
	# GHOST CORNER
	la t0,blinky.corner
	li t1,%blinky.corner.x
	li t2,%blinky.corner.y
	sh t1,0(t0)
	sh t2,2(t0)
	la t0,pinky.corner
	li t1,%pinky.corner.x
	li t2,%pinky.corner.y
	sh t1,0(t0)
	sh t2,2(t0)
	la t0,inky.corner
	li t1,%inky.corner.x
	li t2,%inky.corner.y
	sh t1,0(t0)
	sh t2,2(t0)
	la t0,clyde.corner
	li t1,%clyde.corner.x
	li t2,%clyde.corner.y
	sh t1,0(t0)
	sh t2,2(t0)
#}
.end_macro

.macro RESPAWN	
	# SPAWN MSPAC
	la t0,mspac.image.coor	#mspac.image.coor: .half 99,176
	li t1,99	#x
	li t2,176	#y
	sh t1,0(t0)
	sh t2,2(t0)
	la t0,mspac.pre_direction
	li t1,0x00000000
	sw t1,0(t0)
	la t0,mspac.animation
	sh zero,0(t0)
	la t0,mspac.direction
	li t1,0x00000000
	sw t1,0(t0)
	# SPAWN BLINKY
	la t0,blinky.image.coor	#mspac.image.coor: .half 99,176
	li t1,103	#x
	li t2,80	#y
	sh t1,0(t0)
	sh t2,2(t0)
	la t0,blinky.direction
	li t1,0x080300FF
	sw t1,0(t0)
	la t0,blinky.status
	li t1,0x02	# 0000 0010
	sb t1,2(t0)
	# SPAWN PINKY
	la t0,pinky.image.coor	#mspac.image.coor: .half 99,176
	li t1,103	#x
	li t2,104	#y
	sh t1,0(t0)
	sh t2,2(t0)
	la t0,pinky.direction
	li t1,0x00000000
	sw t1,0(t0)
	la t0,pinky.status
	li t1,0x42	# 0100 0010
	sb t1,2(t0)
	# SPAWN INKY
	la t0,inky.image.coor	#mspac.image.coor: .half 99,176
	li t1,87	#x
	li t2,104	#y
	sh t1,0(t0)
	sh t2,2(t0)
	la t0,inky.direction
	li t1,0x00000000
	sw t1,0(t0)
	la t0,inky.status
	li t1,0x42	# 0100 0010
	sb t1,2(t0)
	# SPAWN CLYDE
	la t0,clyde.image.coor	#mspac.image.coor: .half 99,176
	li t1,119	#x
	li t2,104	#y
	sh t1,0(t0)
	sh t2,2(t0)
	la t0,clyde.direction
	li t1,0x00000000
	sw t1,0(t0)
	la t0,clyde.status
	li t1,0x42	# 0100 0010
	sb t1,2(t0)
	# SPAWN FRUIT
	la t0,fruit.image.coor	#mspac.image.coor: .half 99,176
	la t3,fruit.spawn
	lh t1,0(t3)	#x
	lh t2,2(t3)	#y
	sh t1,0(t0)
	sh t2,2(t0)
	la t0,fruit.direction
	li t1,0x00000000
	sw t1,0(t0)
	la t0,fruit.clock
	addi t1,zero,10
	sh t1,0(t0)
#}
.end_macro

.macro GET_SCRIPT (%aux,%script,%speed)
#{	
	la s0,%aux
	la s1,%script
	
	addi s2,zero,0	# aux counter (1)
	addi s3,zero,0	# script counter (4)
	
	addi s4,zero,'d'
	addi s5,zero,'s'
	addi s6,zero,'a'
	addi s7,zero,'w'
	
	addi s8,zero,%speed
	addi t0,zero,-1
	mul s9,s8,t0	# s9 = -%speed
	
	# -speed nao deve superar 8 bits!
	li t0,0x000000FF
	and s9,s9,t0
	
	HEAP_TO_SCRIPT$LOOP:
	#{
		add t0,s0,s2
		lb s11,0(t0)
			
		bne s11,s4,HEAP_TO_SCRIPT$NEXT1	# D - direita - h:+speed v:0 dir:0 bit_dir:0000 0001
		#{
			li t0,0x01000000	# dir e bit_dir
			or t0,t0,s8	# speed esta no byte correto
			add t1,s1,s3
			sw t0,0(t1)	# store
			addi s3,s3,4	# script counter ++ 4
			addi s2,s2,1	# aux counter ++ 1
			j HEAP_TO_SCRIPT$LOOP
		#}
		HEAP_TO_SCRIPT$NEXT1:
		bne s11,s5,HEAP_TO_SCRIPT$NEXT2 # S - baixo - h:0 v:+speed dir:1 bit_dir:0000 0010
		#{
			li t0,0x02010000	# dir e bit_dir
			slli t1,s8,8	# um byte deslocado -> v esta no segundo byte
			or t0,t0,t1	# speed esta no byte correto
			add t1,s1,s3
			sw t0,0(t1)	# store
			addi s3,s3,4	# script counter ++ 4
			addi s2,s2,1	# aux counter ++ 1
			j HEAP_TO_SCRIPT$LOOP
		#}
		HEAP_TO_SCRIPT$NEXT2:
		bne s11,s6,HEAP_TO_SCRIPT$NEXT3	# A - esquerda - h:-speed v:0 dir:2 bit_dir:0000 0100
		#{
			li t0,0x04020000	# dir e bit_dir
			or t0,t0,s9	# speed esta no byte correto
			add t1,s1,s3
			sw t0,0(t1)	# store
			addi s3,s3,4	# script counter ++ 4
			addi s2,s2,1	# aux counter ++ 1
			j HEAP_TO_SCRIPT$LOOP
		#}
		HEAP_TO_SCRIPT$NEXT3:
		bne s11,s7,HEAP_TO_SCRIPT$NEXT4	# W - cima - h:0 v:-speed dir:3 bit_dir:0000 1000
		#{
			li t0,0x08030000	# dir e bit_dir
			slli t1,s9,8	# um byte deslocado -> v esta no segundo byte
			or t0,t0,t1	# speed esta no byte correto
			add t1,s1,s3
			sw t0,0(t1)	# store
			addi s3,s3,4	# script counter ++ 4
			addi s2,s2,1	# aux counter ++ 1
			j HEAP_TO_SCRIPT$LOOP
		#}
		HEAP_TO_SCRIPT$NEXT4:		# \0 - fim - parado
		#{
			add t1,s1,s3
			sw zero,0(t1)	# store
			# FIM DA MACRO
		#}
	#}
#}
.end_macro

.macro PREPARE_LEVEL (%map.frame_file,%map.image_file,%fruit.image_file,%map.fruit_path_file)

FILE_TO_BUFFER(%map.frame_file,map.char,868)
FILE_TO_BUFFER (%map.image_file,map.image,53760)
FILE_TO_BUFFER (%fruit.image_file,fruit.image,2736)

#fruit path
#{
	la t0,fruit.image
	la t1,fruit.image_pointer
	sw t0,0(t1)
	FILE_TO_BUFFER (%map.fruit_path_file,aux.script,673)
	GET_SCRIPT (aux.script,fruit.path,1)
#}

# map frame + num de pastilhas
#{
	addi s10,zero,28
	
	la s6,map.frame
	la s0,map.char
	li s1,868
	add s1,s1,s0
	li s2,'.'
	li s3,'O'
	li s4,'#'
	li s5,'X'
	
	addi s11,zero,0
	
	FRAME_LOOP:
	#{
		addi s8,zero,0	# s8 0000 0000
		lb s7,0(s0)	# elemento do mapa
		
		### Colisao
		bne s7,s5,COLISION_NEXT1# X
		#{
			ori s8,s8,0x15	# ori 0001 0101
			j FRAME_LOOP$END
		#}
		COLISION_NEXT1:
		beq s7,s4,FRAME_LOOP$END # char -> #
		#{
			addi s9,zero,0	# s9 condição para se nó
		
			addi t0,s0,1	# Direita de s0
			lb t0,0(t0)
			beq t0,s4,COLISION_NEXT2
			#{
				ori s8,s8,0x01	# ori 0000 0001
				addi s9,s9,1
			#}	
			
			COLISION_NEXT2:
			add t0,s0,s10	# Abaixo de s0
			lb t0,0(t0)
			beq t0,s4,COLISION_NEXT3
			#{
				ori s8,s8,0x02	# ori 0000 0010
				addi s9,s9,1
			#}
				
			COLISION_NEXT3:
			li t0,-1
			add t0,s0,t0	# Esquerda de s0
			lb t0,0(t0)
			beq t0,s4,COLISION_NEXT4
			#{
				ori s8,s8,0x04	# ori 0000 0100
				addi s9,s9,1
			#}
				
			COLISION_NEXT4:
			sub t0,s0,s10	# Acima de s0
			lb t0,0(t0)
			beq t0,s4,COLISION_NEXT5
			#{
				ori s8,s8,0x08	# ori 0000 1000
				addi s9,s9,1
			#}
			COLISION_NEXT5:
			addi t0,zero,3
			blt s9,t0,PELLETS_NUM
				ori s8,s8,0x80	# ori 1000 0000	-> nó
		#}
		
		### Pastilhas
		PELLETS_NUM:
		bne s7,s2,PELLETS_NUM$NEXT
		#{
			addi s11,s11,1	# s4++
			ori s8,s8,0x40	# ori 0100 0000
			j FRAME_LOOP$END
		#}
		PELLETS_NUM$NEXT:
		bne s7,s3,FRAME_LOOP$END
		#{
			addi s11,s11,1	# s4++
			ori s8,s8,0x60	# ori 0110 0000
		#}
		FRAME_LOOP$END:
		
		sb s8,0(s6)
		
		addi s6,s6,1	# s6++
		addi s0,s0,1	# s0++
		blt s0,s1,FRAME_LOOP	# Acabou o frame?
	#}
	
	la s0,counter
	sh s11,2(s0)	# Limite = total
	sh zero,0(s0)	# Contador = 0
#}
.end_macro

#### ARGUMENTOS

.macro CHANGE_COOR.arg (%coor,%image.coor,%direction,%gridcoor)
#{
	la a0,%coor
	la a1,%image.coor
	la a2,%direction
	la a3,%gridcoor
#}
.end_macro

####### JOGAR ########
.text
# Intro do jogo: INICIO
printintro:			# Imprime a imagem de intro do jogo
	li a7 1024 
	la a0 intro1
	li a1 0
	ecall

	li a1 0xFF000000
	li a2 76800
	li a7 63
	ecall

	mv a0 t0
	li a7 57
	ecall
# Lê coisas do teclado sem ter que apertar enter
li s1 10				# Valor da tecla pressionada enter
KEY: 	
	li t1,0xFF200000		# carrega o endereço de controle do KDMMIO
LOOP: 	
	lw t0,0(t1)			# Le bit de Controle Teclado
   	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,LOOP		# não tem tecla pressionada então volta ao loop
   	lw t2,4(t1)			# le o valor da tecla
   	beq s1 t2 ENTERMUSIC		# Se o valor da tecla pressionada for enter(a) ele pula para a próxima parte	
   	jal zero LOOP
   	ENTERMUSIC:
   	addi a7 zero 31
   	addi a0 zero 62
   	addi a1 zero 250
   	addi a2 zero 16
   	addi a3 zero 100
   	ecall
   	addi a0 zero 65
   	ecall
   	jal zero setvalues_main_menu
# Intro do jogo: FIM



# Main menu : INICIO
main_menu:

# Lê coisas do teclado sem ter que apertar enter
KEY2: 	
	li t1,0xFF200000		# carrega o endereço de controle do KDMMIO
	li t2 0				# Reseta o valor de t2 que armazena o caractere do teclado para nova leitura
LOOP2: 	
	lw t0,0(t1)			# Le bit de Controle Teclado
   	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,LOOP2		# não tem tecla pressionada então volta ao loop
   	lw t2,4(t1)			# le o valor da tecla
   	beq t2, s7, subirprint		# Se a tecla lida for w(77) ele vai para a função subirprint
   	beq t2, s8, descerprint		# Se a tecla lida for s(73) ele vai para a função descerprint
   	beq t2, s1, executarfuncao	# Se t2 for enter(a), executa a função SAIR, JOGAR ou INSTRUCOES ou CREDITOS
	b LOOP2	

subirprint:
   	addi a7 zero 31
   	addi a0 zero 62
   	addi a1 zero 250
   	addi a2 zero 16
   	addi a3 zero 100
   	ecall
	addi s0 s0 -1			# Subtrair 1 do valor de s0 para subir um print
	slt t3 s0 s2			# Se s0 for menor que 1, t3=1, senao t3=0
	beq t3 s2 tornarvalor4		# Se t3 for igual a 1 então pula para a função tornarvalor4
	beq s0 s2 printmain1		# Se s0 for igual a 1 entao vai para a função printmain1
	beq s0 s3 printmain2		# Se s0 for igual a 2 entao vai para a função printmain2
	beq s0 s4 printmain3		# Se s0 for igual a 3 entao vai para a função printmain3
	beq s0 s5 printmain4		# Se s0 for igual a 4 entao vai para a função printmain4
	tornarvalor4:
		li s0 4	
		b printmain4

descerprint:
   	addi a7 zero 31
   	addi a0 zero 62
   	addi a1 zero 250
   	addi a2 zero 16
   	addi a3 zero 100
   	ecall
	addi s0 s0 1			# Soma 1 do valor de s0 para descer um print
	slt t3 s5 s0			# Se s0 for maior que 4, t0=1, senao t0=0
	beq t3 s2 tornarvalor1		# Se t3 for igual a 1 então pula para a função tornarvalor1
	beq s0 s2 printmain1		# Se s0 for igual a 1 entao vai para a função printmain1
	beq s0 s3 printmain2		# Se s0 for igual a 2 entao vai para a função printmain2
	beq s0 s4 printmain3		# Se s0 for igual a 3 entao vai para a função printmain3
	beq s0 s5 printmain4		# Se s0 for igual a 4 entao vai para a função printmain4
	tornarvalor1:
		li s0 1	
		b printmain1

executarfuncao:
#li s0 1				# Resetar o valor de s0 para utilização nas funções seguintes e no menu principal
   	addi a7 zero 31
   	addi a0 zero 62
   	addi a1 zero 250
   	addi a2 zero 16
   	addi a3 zero 100
   	ecall
   	addi a0 zero 65
   	ecall
	beq s0 s2 jogar
	beq s0 s3 setvalues_instrucoes 	# Leva direto ao print inicial da pagina de instrucoes e posteriormente ao de instrucoes
	beq s0 s4 creditos
	beq s0 s5 sair

setvalues_main_menu:
	li s0 1
	li s1 '\n'			# Valor da tecla enter(a)
	li s2 1				# s2, s3 e s4 e s5 são os valores para as condições de qual print ir
	li s3 2
	li s4 3
	li s5 4				
	li s6 5				# registrador que analisara a condição se s0 for maior que 5
	li s7 'w'			# Valor do caractere "w"
	li s8 's'			# Valor do caractere "s"

# Imprime funções das opções do menu principal : INICIO
printmain1:
	li a7 1024 
	la a0 main1
	li a1 0
	ecall

	mv t0 a0
	li a1 0xFF000000
	li a2 76800
	li a7 63
	ecall

	mv a0 t0
	li a7 57
	ecall
	j LOOP2

printmain2:
	li a7 1024
	la a0 main2
	li a1 0
	ecall

	mv t0 a0
	li a1 0xFF000000
	li a2 76800
	li a7 63
	ecall

	mv a0 t0
	li a7 57
	ecall
	j LOOP2

printmain3:
	li a7 1024
	la a0 main3
	li a1 0
	ecall

	mv t0 a0
	li a1 0xFF000000
	li a2 76800
	li a7 63
	ecall

	mv a0 t0
	li a7 57
	ecall
	j LOOP2

printmain4:
	li a7 1024 
	la a0 main4
	li a1 0
	ecall

	mv t0 a0
	li a1 0xFF000000
	li a2 76800
	li a7 63
	ecall

	mv a0 t0
	li a7 57
	ecall
	j LOOP2
# Imprime funções das opções do menu principal : FIM
# Main menu : FIM
	
# Funcoes a serem utilizadas pela main_menu: INICIO	


# Instrucoes: INICIO
instrucoes:
# Lê coisas do teclado sem ter que apertar enter
KEY3: 	
	li t1,0xFF200000		# carrega o endereço de controle do KDMMIO
	li t2 0				# Reseta o valor de t2 que armazena o caractere do teclado para nova leitura
LOOP3: 	
	lw t0,0(t1)			# Le bit de Controle Teclado
   	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,LOOP3		# não tem tecla pressionada então volta ao loop
   	lw t2,4(t1)			# le o valor da tecla
   	beq t2, s7, subirprint2		# Se a tecla lida for w(77) ele vai para a função subirprint
   	beq t2, s8, descerprint2	# Se a tecla lida for s(73) ele vai para a função descerprint
   	beq t2, s1, back_instrucoes 	# Se t2 for enter(a), executa a função main_menu novamente printando menu inicial antes
	b LOOP3	

subirprint2:
   	addi a7 zero 31
   	addi a0 zero 62
   	addi a1 zero 250
   	addi a2 zero 16
   	addi a3 zero 100
   	ecall
	addi s0 s0 -1					# Subtrair 1 do valor de s0 para subir um print
	slt t3 s0 s2					# Se s0 for menor que 1, t3=1, senao t3=0
	beq t3 s2 tornarvalor2_instrucoes		# Se t3 for igual a 1 então pula para a função tornarvalor2_instrucoes
	beq s0 s2 printinstrucoes1			# Se s0 for igual a 1 entao vai para a função printinstrucoes1
	beq s0 s3 printinstrucoes2			# Se s0 for igual a 2 entao vai para a função printinstrucoes2
	tornarvalor2_instrucoes:
		li s0 2	
		b printinstrucoes2

descerprint2:
   	addi a7 zero 31
   	addi a0 zero 62
   	addi a1 zero 250
   	addi a2 zero 16
   	addi a3 zero 100
   	ecall
	addi s0 s0 1					# Soma 1 do valor de s0 para descer um print
	slt t3 s0 s3					# Se s0 for maior que 2, t0=1, senao t0=0
	beq t3 s2 tornarvalor1_instrucoes		# Se t3 for igual a 1 então pula para a função tornarvalor1_instrucoes
	beq s0 s2 printinstrucoes1			# Se s0 for igual a 1 entao vai para a função printinstrucoes1
	beq s0 s3 printinstrucoes2			# Se s0 for igual a 2 entao vai para a função printinstrucoes2
	tornarvalor1_instrucoes:
		li s0 1	
		b printinstrucoes1

back_instrucoes:
   	addi a7 zero 31
   	addi a0 zero 65
   	addi a1 zero 250
   	addi a2 zero 16
   	addi a3 zero 100
   	ecall
   	addi a0 zero 62
   	ecall
	jal zero setvalues_main_menu
	
setvalues_instrucoes:
	li s0 1
	li s1 '\n'			# Valor da tecla enter(a)
	li s2 1				# s2, s3 são os valores para as condições de qual print ir
	li s3 2
	li s4 3
	li s7 'w'			# Valor do caractere "w"
	li s8 's'			# Valor do caractere "s"

printinstrucoes1:
	li a7 1024 
	la a0 instrucoes1
	li a1 0
	ecall

	mv t0 a0
	li a1 0xFF000000
	li a2 76800
	li a7 63
	ecall

	mv a0 t0
	li a7 57
	ecall
	j LOOP3

printinstrucoes2:
	li a7 1024 
	la a0 instrucoes2
	li a1 0
	ecall

	mv t0 a0
	li a1 0xFF000000
	li a2 76800
	li a7 63
	ecall

	mv a0 t0
	li a7 57
	ecall
	j LOOP3
# Instrucoes: FIM

# Créditos: INICIO
creditos:
	li a7 1024 
	la a0 creditos1
	li a1 0
	ecall

	mv t0 a0
	li a1 0xFF000000
	li a2 76800
	li a7 63
	ecall

	mv a0 t0
	li a7 57
	ecall
	
KEY4: 	
	li t1,0xFF200000		# carrega o endereço de controle do KDMMIO
	li t2 0				# Reseta o valor de t2 que armazena o caractere do teclado para nova leitura
LOOP4: 	
	lw t0,0(t1)			# Le bit de Controle Teclado
   	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,LOOP4		# não tem tecla pressionada então volta ao loop
   	lw t2,4(t1)			# le o valor da tecla
   	li s7 '\n'
   	beq t2, s7, back_creditos		# Se a tecla lida for w(77) ele vai para a função subirprint
	j LOOP4	
	
back_creditos:
	addi a7 zero 31
   	addi a0 zero 65
   	addi a1 zero 250
   	addi a2 zero 16
   	addi a3 zero 100
   	ecall
   	addi a0 zero 62
   	ecall
	jal zero setvalues_main_menu

# Créditos: FIM
jogar:

la t0,exceptionHandling		# carrega em t0 o endere?o base das rotinas do sistema ECALL
csrrw zero,5,t0 		# seta utvec (reg 5) para o endere?o t0
csrrsi zero,0,1 		# seta o bit de habilitaçãoo de interrupçãoo em ustatus (reg 0)
 
 #### LOAD MSPACMAN DEATH #### 
FILE_TO_BUFFER(DEATH_MSPACMAN_FILE,DEATH_MSPACMAN,1024)	
#### LOAD MSPACMAN ANIMATION #### 
FILE_TO_BUFFER (NEXT_STAGE_FILE,SCENE_TRANSITION,7808)

FILE_TO_BUFFER (mspac.image_file,mspac.image,5184)
# BLINKY
FILE_TO_BUFFER (blinky.image_file,blinky.image,10368)
FILE_TO_BUFFER (blinky.enter_home_file,aux.script,12)
GET_SCRIPT (aux.script,blinky.enter_home,2)
FILE_TO_BUFFER (blinky.exit_home_file,aux.script,26)
GET_SCRIPT (aux.script,blinky.exit_home,1)
# PINKY
FILE_TO_BUFFER (pinky.image_file,pinky.image,10368)
FILE_TO_BUFFER (pinky.enter_home_file,aux.script,12)
GET_SCRIPT (aux.script,pinky.enter_home,2)
FILE_TO_BUFFER (pinky.exit_home_file,aux.script,26)
GET_SCRIPT (aux.script,pinky.exit_home,1)
# INKY
FILE_TO_BUFFER (inky.image_file,inky.image,10368)
FILE_TO_BUFFER (inky.enter_home_file,aux.script,20)
GET_SCRIPT (aux.script,inky.enter_home,2)
FILE_TO_BUFFER (inky.exit_home_file,aux.script,42)
GET_SCRIPT (aux.script,inky.exit_home,1)
# CLYDE
FILE_TO_BUFFER (clyde.image_file,clyde.image,10368)
FILE_TO_BUFFER (clyde.enter_home_file,aux.script,20)
GET_SCRIPT (aux.script,clyde.enter_home,2)
FILE_TO_BUFFER (clyde.exit_home_file,aux.script,42)
GET_SCRIPT (aux.script,clyde.exit_home,1)
# BLUE
FILE_TO_BUFFER (blue.image_file,blue.image,648)
# WHITE
FILE_TO_BUFFER (white.image_file,white.image,1296)
# EYE
FILE_TO_BUFFER (eye.image_file,eye.image,1296)

# Load pointers

# blue pointer
 la t0,blue.image
 la t1,blue.image_pointer
 sw t0,0(t1)
 
# blue pointer
 la t0,white.image
 la t1,white.image_pointer
 sw t0,0(t1)
 
# blue pointer
 la t0,eye.image
 la t1,eye.image_pointer
 sw t0,0(t1)

la t0,GAME_START
jalr zero,t0,0

##################


# 0xff200000 -> KDMIO
GET_KEY:
#{
	li t0,0xff200000
	lw t0,0(t0)
	andi t0,t0,1
	addi t1,zero,1		# Ultimo bit eh 1?
	beq t0,t1,DEFINE_PRE_DIRECTION	# Se a tecla estiver pressionada, analise o valor!
	jalr zero,ra,0
#}

# 0xff200004 -> tecla
DEFINE_PRE_DIRECTION:
#{
	li t0,0xff200004
	lw s0,0(t0)	# s0 = char
	la s1,mspac.pre_direction
	la t0,mspac.direction
	
	addi t1,zero,4
	lb s2,2(t0)
	addi s2,s2,2
	rem s2,s2,t1
	
	addi t0,zero,'d' 
	beq t0,s0,DIRECTION_D	# char = d?
	addi t0,zero,'s' 
	beq t0,s0,DIRECTION_S	# char = s?
	addi t0,zero,'a' 
	beq t0,s0,DIRECTION_A	# char = a?
	addi t0,zero,'w' 
	beq t0,s0,DIRECTION_W	# char = w?
	addi t0,zero,'k'
	beq t0,s0,CHEAT
	
	jalr zero,ra,0	# return
	
	DIRECTION_D:	#Direita
	#{
		# h:+2  v:0  dir:0  bit_dir:0001 -> h:0000 0010 v:0000 0000 dir: 0000 0000 bit_dir: 0000 0001 
		li t0,0x01000002
		sw t0,0(s1) # store 0x02000001 -> 0x01 00 00 02
		  
		beq zero s2 CHANGE_MSPACMAN_DIRECTION 	# Se a tecla pressionada for oposta a direção da movimentação, pula colisão
		
		jalr zero,ra,0
	#}
	DIRECTION_S:	#Baixo
	#{
		# h:0  v:+2  dir:1  bit_dir:0010 -> h:0000 0000 v:0000 0010 dir: 0000 0001 bit_dir: 0000 0010
		li t0,0x02010200
		sw t0,0(s1) # store 0x00020102 -> 0x02 01 02 00
		
		addi s0,zero,1
		beq s0 s2 CHANGE_MSPACMAN_DIRECTION 	# Se a tecla pressionada for oposta a direção da movimentação, pula colisão
			
		jalr zero,ra,0
	#}
	DIRECTION_A:	#Esquerda
	#{
		# h:-2  v:0  dir:2  bit_dir:0100 -> h:1111 1110 v:0000 0000 dir: 0000 0010 bit_dir: 0000 0100
		li t0,0x040200FE
		sw t0,0(s1) # store 0xFE000204 -> 0x 04 02 00 FE
		
		addi s0,zero,2
		beq s0 s2 CHANGE_MSPACMAN_DIRECTION 	# Se a tecla pressionada for oposta a direção da movimentação, pula colisão
	
		jalr zero,ra,0
	#}
	DIRECTION_W:	#Cima
	#{
		# h:0  v:-2  dir:2  bit_dir:0100 -> h:0000 0000 v:1111 1110 dir: 0000 0011 bit_dir: 0000 1000
		li t0,0x0803FE00
		sw t0,0(s1) # store 0x00FE0308 -> 0x08 03 FE 00
		
		addi s0,zero,3
		beq s0 s2 CHANGE_MSPACMAN_DIRECTION 	# Se a tecla pressionada for oposta a direção da movimentação, pula colisão
	
		jalr zero,ra,0
	#}	
	
	CHEAT:
	# recover return
 	la t0,map.return
 	lw t0,0(t0)
	jalr zero,t0,0
#}

DEFINE_MSPAC_DIRECTION:
#{
	la s0,mspac.pre_direction
	la s1,mspac.direction
	la s7,mspac.grid.coor
	
	lb t0,2(s7)	# grid rem
	bne t0,zero,DEFINE_MSPAC_DIRECTION$JUMP2	# nao alinhado
	
	####COLISION####
	
	LARGURA (s6)
	lb s8,0(s7)	# grid x
	lb s9,1(s7)	# grid y
	
	addi s4,zero,8
	div t0,s6,s4	# largura/8
	mul t0,s9,t0	# (y/8)*(largura/8)
	add t0,t0,s8	# (y/8)*(largura/8)+(x/8)
	la s5,map.frame
	add s5,s5,t0
	lb s5,0(s5)	# s5 = byte data
	
	lb t0,3(s0)
	and t0,s5,t0	# Colisão?
	beq t0,zero,DEFINE_MSPAC_DIRECTION$JUMP1
	# direction = pre_direction
	#{
		lw t0,0(s0)
		sw t0,0(s1)
	#}
	DEFINE_MSPAC_DIRECTION$JUMP1:
	lb t0,3(s1)
	and t0,s5,t0	# Defined Colision?
	bne t0,zero,DEFINE_MSPAC_DIRECTION$JUMP2
		sh zero,0(s1)	# h e v = 0000 0000 0000 0000
		
	DEFINE_MSPAC_DIRECTION$JUMP2:
	jalr zero,ra,0
#}

CHANGE_MSPACMAN_DIRECTION:
#{
	la s0,mspac.pre_direction
	la s1,mspac.direction
	# direction = pre_direction
	#{
		lw t0,0(s0)
		sw t0,0(s1)
	#}
	jalr zero,ra,0
#}

CHANGE_COOR:	#a0 = K.coor | a1 = K.image.coor |a2 = K.direction | a3 = K.grid.coor
#{
	addi s4,zero,8

	# Novo x = ((x+h)+LARGURA) mod LARGURA
	LARGURA (s3)
	
	lh t0,0(a1)	# x - image
	lb t1,0(a2)	# h
	add t0,t0,t1	# x+h
	add t0,t0,s3	# (x+h)+LARGURA
	rem t0,t0,s3	# [(x+h)+LARGURA]%LARGURA
	sh t0,0(a1)	# x = [(x+h)+LARGURA]%LARGURA
	
	addi t0,t0,5	# x+5 - real
	rem s5,t0,s3	# [x+5]%LARGURA
	sh s5,0(a0)	# x = [x+5]%LARGURA
	
	div t0,s5,s4	# x/8
	sb t0,0(a3)
	
	# Novo y = ((y+v)+ALTURA) mod ALTURA
	ALTURA (s3)
	
	lh t0,2(a1)	# y				#
	lb t1,1(a2)	# v				#
	add t0,t0,t1	# y+v				#
	add t0,t0,s3	# (y+v) + ALTURA		#
	rem t0,t0,s3	# [(y+v) + ALTURA]%ALTURA	# OBS: MÒDULO DISPENSÀVEL COM COLISÃO
	sh t0,2(a1)	# y = [(y+v) + ALTURA]%ALTURA	#
	
	addi t0,t0,8	# y+8 - real			#
	rem s6,t0,s3	# [y+8]%ALTURA			#
	sh s6,2(a0)	# y = [y+8]%ALTURA		#
	
	div t0,s6,s4	# y/8
	sb t0,1(a3)
	
	add t0,s5,s6
	rem t0,t0,s4	# (x+y)%8
	sb t0,2(a3)
	
	jalr zero,ra,0
#}

CHANGE_FRUIT_COOR:	#a0 = K.coor | a1 = K.image.coor |a2 = K.direction
#{
	addi s4,zero,8

	
	lh t0,0(a1)	# x - image
	lb t1,0(a2)	# h
	add t0,t0,t1	# x+h
	sh t0,0(a1)	# x = x+h
	
	addi t0,t0,5	# x+5 - real
	sh t0,0(a0)	# x = x+5
	
	lh t0,2(a1)	# y				#
	lb t1,1(a2)	# v				#
	add t0,t0,t1	# y+v				#
	sh t0,2(a1)	# y = y+v			#
	
	addi t0,t0,8	# y+8 - real			#
	sh t0,2(a0)	# y = y+8			#
	
	jalr zero,ra,0
#}


CHANGE_I.DIRECTION: # a0 = K.direction | a1 = K.image | a2 = K.image_adress | a3 =salto
#{
	# DEFINIR DIRECAO DA IMAGEM SE FOR O CASO 		#
	# Exemplo: &image + 18*18*8 = &image + 2592*direcao	#
	lb t2 2(a0)	#t2=direcao				#
	mul a3,a3,t2	#2592*direcao				#
	add a3,a3,a1	#&image+2592*direcao			#
	sw a3,0(a2)	#Image adress <- &image+2048*direcao	#
	
	jalr zero,ra,0
#}

.macro PRINT.arg (%image_adress,%animation,%coor,%direction,%16steps)
#{
	la a0,%image_adress
	la a1,%animation
	la a2,%coor
	la a3,%direction
	li a4,%16steps
#}
.end_macro

ERASE:	
# a2 = K.coor
#{		
	################################################################################################################																				#
											
	addi s0,zero,0					
	addi s2,zero,324	# s2=endereço final+1										
																											#
	# x														
	lh s3,0(a2)													
															
	# Largura do mapa												
	LARGURA (s4)													
															
	# Quebra de linha												
	addi s8,zero,320												
															
	#Determinar a altura - sem mod											
	lh t0,2(a2)	# y												
	mul t0,s8,t0	# 320*y - Quebras de linhas									
															
	# Ponto inicial no bitmap - endereço										
	PONTO_INICIAL (t1)												
															
	# s5= Altura base = Ponto inicial no bitmap + Quebras de linhas							
	add s5,t1,t0													
															
	# Largura da imagem												
	addi s7,zero,18							
	
	# Imagem de referencial
	lh t0,2(a2)	# y
	mul t0,t0,s4	# y*largura
	la s9,map.image	# load adress
	add s9,s9,t0	# s9=&map.image+y*largura			
															
	# s0 = &mspac.image_adress + contador | s1 = &mspac.animation | s2 = endereço final (condicao de parada)	
	# s3 = x (coordenada) | s4 = Largura do mapa | s5 = Altura base atual						
	# s6 = x + n, n= 0,1,2...,s7  | s7 = Largura da imagem (condicao de parada) | s8 = Quebra de linha
	# s9 = Altura do endereço de disfarce atual
	ERASE$Y:													
	#{														
		addi s6,zero,0	# s6=0								
		ERASE$X:												
		#{													
			add t0,s6,s3	# Coordenada parcial								
			rem t2,t0,s4	# (s6+s3)%largura - coordenada real							
			add t0,s5,t2	# Onde colocar o pixel - em termos de endereço
			add t2,s9,t2
			lb t1,0(t2)
			sb t1,0(t0)	# Printar pixel no bitmap
						
			addi s0,s0,1	# contador++
						
			# Proximo x+n e s10											
			addi s6,s6,1	# s6 ++									
															
			# loop if x+n < 16										
			blt s6,s7,ERASE$X										
		#}													
		add s5,s5,s8	# Quebrar linha	
		add s9,s9,s4	# Pular linha de s9 - somar largura								
															
		# loop if s0<s2 <=> Se acabar a imagem									
		blt s0,s2,ERASE$Y											
	#}														
	jalr zero,ra,0 #return
	################################################################################################################
#}

PRINT:	
# a0 = K.image_adress |  a1 = K.animation | a2 = K.coor | a3 = K.direction | a4 = 16*steps
#{		
	################################################################################################################																				#
	lh t0,0(a1)	# etapa													
	lw s0,0(a0)	# imagem											
	add s0,s0,t0	# endereço da imagem = mspac.image_adress+contador						
	addi s2,s0,324	# s2=endereço final+1										
																											#
	# x														
	lh s3,0(a2)													
															
	# Largura do mapa												
	LARGURA (s4)													
															
	# Quebra de linha												
	addi s8,zero,320												
															
	#Determinar a altura - sem mod											
	lh t0,2(a2)	# y												
	mul t0,s8,t0	# 320*y - Quebras de linhas									
															
	# Ponto inicial no bitmap - endereço										
	PONTO_INICIAL (t1)												
															
	# s5= Altura base = Ponto inicial no bitmap + Quebras de linhas							
	add s5,t1,t0													
															
	# Largura da imagem												
	addi s7,zero,18							
	
	# Imagem de referencial
	lh t0,2(a2)	# y
	mul t0,t0,s4	# y*largura
	la s9,map.image	# load adress
	add s9,s9,t0	# s9=&map.image+y*largura			
															
	# s0 = &mspac.image_adress + contador | s1 = &mspac.animation | s2 = endereço final (condicao de parada)	
	# s3 = x (coordenada) | s4 = Largura do mapa | s5 = Altura base atual						
	# s6 = x + n, n= 0,1,2...,s7  | s7 = Largura da imagem (condicao de parada) | s8 = Quebra de linha
	# s9 = Altura do endereço de disfarce atual
	PRINT$Y:													
	#{														
		addi s6,zero,0	# s6=0								
		PRINT$X:												
		#{													
			add t0,s6,s3	# Coordenada parcial								
			rem t2,t0,s4	# (s6+s3)%largura - coordenada real							
			add t0,s5,t2	# Onde colocar o pixel - em termos de endereço					
			lb t1,0(s0)	# Carregar pixel da imagem em t1
			bne t1,zero,PRINT$IMAGE_PIXEL
			#PRINT$MAP_PIXEL
				add t2,s9,t2
				lb t1,0(t2)
			PRINT$IMAGE_PIXEL:
				sb t1,0(t0)	# Printar pixel no bitmap
																											
			# Proximo pixel na imagem									
			addi s0,s0,1	# s0 ++										
															
			# Proximo x+n e s10											
			addi s6,s6,1	# s6 ++									
															
			# loop if x+n < 16										
			blt s6,s7,PRINT$X										
		#}													
		add s5,s5,s8	# Quebrar linha	
		add s9,s9,s4	# Pular linha de s9 - somar largura								
															
		# loop if s0<s2 <=> Se acabar a imagem									
		blt s0,s2,PRINT$Y											
	#}														
	################################################################################################################
	
									
	lh t0,0(a3)	# h e v						
	bne t0,zero,PRINT$COUNTER	# Se h!=0 || v!=0		
	jalr zero,ra,0 #return						
									
	PRINT$COUNTER:							
	#{								
		# Somar contador em 324 com mod 18*steps		
		lh s6,0(a1)	# contador				
		addi s6,s6,324	# contador ++324			
		rem s6,s6,a4	# (contador ++324) % 18*steps		
		sh s6,0(a1)	# contador = (contador ++324) % 18*steps	
	#}								
	jalr zero,ra,0 #return
#}

PRINT_FRUIT:	
# a0 = K.image_adress |  a1 = K.animation | a2 = K.coor | a3 = K.direction | a4 = 16*steps
#{		
	################################################################################################################																				#
	lh t0,0(a1)	# etapa													
	lw s0,0(a0)	# imagem											
	add s0,s0,t0	# endereço da imagem = mspac.image_adress+contador						
	addi s2,s0,342	# s2=endereço final+1										
																											#
	# x														
	lh s3,0(a2)													
															
	# Largura do mapa												
	LARGURA (s4)													
															
	# Quebra de linha												
	addi s8,zero,320												
															
	#Determinar a altura - sem mod											
	lh t0,2(a2)	# y												
	mul t0,s8,t0	# 320*y - Quebras de linhas									
															
	# Ponto inicial no bitmap - endereço										
	PONTO_INICIAL (t1)												
															
	# s5= Altura base = Ponto inicial no bitmap + Quebras de linhas							
	add s5,t1,t0													
															
	# Largura da imagem												
	addi s7,zero,18							
	
	# Imagem de referencial
	lh t0,2(a2)	# y
	mul t0,t0,s4	# y*largura
	la s9,map.image	# load adress
	add s9,s9,t0	# s9=&map.image+y*largura			
															
	# s0 = &mspac.image_adress + contador | s1 = &mspac.animation | s2 = endereço final (condicao de parada)	
	# s3 = x (coordenada) | s4 = Largura do mapa | s5 = Altura base atual						
	# s6 = x + n, n= 0,1,2...,s7  | s7 = Largura da imagem (condicao de parada) | s8 = Quebra de linha
	# s9 = Altura do endereço de disfarce atual
	PRINT_FRUIT$Y:													
	#{														
		addi s6,zero,0	# s6=0								
		PRINT_FRUIT$X:												
		#{													
			add t2,s6,s3	# Coordenada parcial
			blt t2,zero,PRINT_FRUIT$JUMP
			bge t2,s4,PRINT_FRUIT$JUMP										
			add t0,s5,t2	# Onde colocar o pixel - em termos de endereço					
			lb t1,0(s0)	# Carregar pixel da imagem em t1
			bne t1,zero,PRINT_FRUIT$IMAGE_PIXEL
			#PRINT$MAP_PIXEL
				add t2,s9,t2
				lb t1,0(t2)
			PRINT_FRUIT$IMAGE_PIXEL:
				sb t1,0(t0)	# Printar pixel no bitmap
			
			PRINT_FRUIT$JUMP:																								
																																																																											
			# Proximo pixel na imagem									
			addi s0,s0,1	# s0 ++										
															
			# Proximo x+n e s10											
			addi s6,s6,1	# s6 ++									
															
			# loop if x+n < 16										
			blt s6,s7,PRINT_FRUIT$X										
		#}													
		add s5,s5,s8	# Quebrar linha	
		add s9,s9,s4	# Pular linha de s9 - somar largura								
															
		# loop if s0<s2 <=> Se acabar a imagem									
		blt s0,s2,PRINT_FRUIT$Y											
	#}														
	################################################################################################################
																		
		# Somar contador em 342 com mod 18*steps		
	lh s6,0(a1)	# contador				
	addi s6,s6,342	# contador ++342			
	rem s6,s6,a4	# (contador ++342) % 18*steps		
	sh s6,0(a1)	# contador = (contador ++342) % 18*steps
		
	jalr zero,ra,0 #return
#}

REVERSE_ANGLE_IA:	# a0 = ghost.coor | a4 = target.coor |a1 = ghost.direction | a3 = ghost.grid.coor
#{
	# s7 s8 s9 s10 -> possibilidades
	la s11,map.frame
	lb t0,0(a3)	# x
	lb t1,1(a3)	# y
	LARGURA (t2)
	addi t3,zero,8
	div t2,t2,t3	# Largura/8
	mul t2,t2,t1	# (y/8)*(Largura/8)
	add t6,t2,t0	# (y/8)*(Largura/8) + (x/8)	# OBS t6 - extra s
	add s11,s11,t6
	lb s11,0(s11)	# Data byte
	blt zero,s11,REVERSE_ANGLE_IA$END
	
	addi s5,zero,2	# s5 = 1
	fcvt.s.w fs5,s5	# fs5 = 1
	addi s6,zero,-2	# s6 = -1
	fcvt.s.w fs6,s6	# fs6 = -1
	
	lh t0,0(a4)
	lh t1,0(a0)
	sub s2,t0,t1	# s2 = pacx-blinkyx
	fcvt.s.w fs2,s2	# fs2=s2
	
	lh t0,2(a4)
	lh t1,2(a0)
	sub s3,t0,t1	# s3 = pacy-blinkyy
	fcvt.s.w fs3,s3 # fs3 = s3
	
	fcvt.s.w fs4,s3		# Se y/0, pegar sinal e valor de y
	beq s2,zero,REVERSE_POSITIVE$X
	fdiv.s fs4,fs3,fs2	# Senao, pegar valor de y/x
	
	REVERSE_POSITIVE$X:
	blt s2,zero,REVERSE_NEGATIVE$X
	#{		
		blt s3,zero,REVERSE_NEGATIVE$Y1
		#POSITIVE$Y1
		#{
			### Dx>=0, Dy>=0 diagonal direita inferior
			
			flt.s t0,fs4,fs5	# fs4 < 1 -> para direita
			bne t0,zero,REVERSE_AFTER$0
			# BEFORE$90
			#{
				li s7,0x0803FE00	# cima 08 03 FE 00 	bit_dir,dir,v,h - 1000,3,-2,0
				li s8,0x040200FE	# esquerda 04 02 00 FE 	bit_dir,dir,v,h - 0100,2,0,-2
				li s9,0x01000002	# direita 01 00 00 02 	bit_dir,dir,v,h - 0001,0,0,+2
				li s10,0x02010200 	# baixo 02 01 02 00 	bit_dir,dir,v,h - 0010,1,+2,0
				
				j REVERSE_ANGLE_IA$FIND_PATH
			#}
			REVERSE_AFTER$0:
			#{
				li s7,0x040200FE	# esquerda 04 02 00 FE 	bit_dir,dir,v,h - 0100,2,0,-2
				li s8,0x0803FE00	# cima 08 03 FE 00 	bit_dir,dir,v,h - 1000,3,-2,0
				li s9,0x02010200 	# baixo 02 01 02 00 	bit_dir,dir,v,h - 0010,1,+2,0
				li s10,0x01000002	# direita 01 00 00 02 	bit_dir,dir,v,h - 0001,0,0,+2
				
				j REVERSE_ANGLE_IA$FIND_PATH
			#}
		#}
		REVERSE_NEGATIVE$Y1:
		#{
			### Dx>=0, Dy<0 diagonal direita superior
			
			flt.s t0,fs4,fs6	# fs4<-1 -> para cima
			bne t0,zero,REVERSE_AFTER$270
			#BEFORE$0
			#{
				li s7,0x040200FE	# esquerda 04 02 00 FE 	bit_dir,dir,v,h - 0100,2,0,-2
				li s8,0x02010200 	# baixo 02 01 02 00 	bit_dir,dir,v,h - 0010,1,+2,0
				li s9,0x0803FE00	# cima 08 03 FE 00 	bit_dir,dir,v,h - 1000,3,-2,0
				li s10,0x01000002	# direita 01 00 00 02 	bit_dir,dir,v,h - 0001,0,0,+2
				
				j REVERSE_ANGLE_IA$FIND_PATH		
			#}
			REVERSE_AFTER$270:
			#{
				li s7,0x02010200 	# baixo 02 01 02 00 	bit_dir,dir,v,h - 0010,1,+2,0
				li s8,0x040200FE	# esquerda 04 02 00 FE 	bit_dir,dir,v,h - 0100,2,0,-2
				li s9,0x01000002	# direita 01 00 00 02 	bit_dir,dir,v,h - 0001,0,0,+2
				li s10,0x0803FE00	# cima 08 03 FE 00 	bit_dir,dir,v,h - 1000,3,-2,0
				
				j REVERSE_ANGLE_IA$FIND_PATH
			#}
		#}
	#}
	REVERSE_NEGATIVE$X:
	#{
		blt s3,zero,REVERSE_NEGATIVE$Y2
		#POSITIVE$Y2
		#{
			### Dx<0, Dy>=0 diagonal esquerda inferior
			
			flt.s t0,fs4,fs6	#fs4<-1 -> para baixo
			bne t0,zero,REVERSE_AFTER$90
			#BEFORE$180
			#{
				li s7,0x01000002	# direita 01 00 00 02 	bit_dir,dir,v,h - 0001,0,0,+2
				li s8,0x0803FE00	# cima 08 03 FE 00 	bit_dir,dir,v,h - 1000,3,-2,0
				li s9,0x02010200 	# baixo 02 01 02 00 	bit_dir,dir,v,h - 0010,1,+2,0
				li s10,0x040200FE	# esquerda 04 02 00 FE 	bit_dir,dir,v,h - 0100,2,0,-2
				
				j REVERSE_ANGLE_IA$FIND_PATH			
			#}
			REVERSE_AFTER$90:
			#{
				li s7,0x0803FE00	# cima 08 03 FE 00 	bit_dir,dir,v,h - 1000,3,-2,0
				li s8,0x01000002	# direita 01 00 00 02 	bit_dir,dir,v,h - 0001,0,0,+2
				li s9,0x040200FE	# esquerda 04 02 00 FE 	bit_dir,dir,v,h - 0100,2,0,-2
				li s10,0x02010200 	# baixo 02 01 02 00 	bit_dir,dir,v,h - 0010,1,+2,0
				
				j REVERSE_ANGLE_IA$FIND_PATH
			#}
		#}
		REVERSE_NEGATIVE$Y2:
		#{
			### Dx<0, Dy<0 diagonal esquerda superior
			
			flt.s t0,fs4,fs5	# fs4 < 1 -> para esquerda
			bne t0,zero,REVERSE_AFTER$180
			#BEFORE$270
			#{
				li s7,0x02010200 	# baixo 02 01 02 00 	bit_dir,dir,v,h - 0010,1,+2,0
				li s8,0x01000002	# direita 01 00 00 02 	bit_dir,dir,v,h - 0001,0,0,+2
				li s9,0x040200FE	# esquerda 04 02 00 FE 	bit_dir,dir,v,h - 0100,2,0,-2
				li s10,0x0803FE00	# cima 08 03 FE 00 	bit_dir,dir,v,h - 1000,3,-2,0
				
				j REVERSE_ANGLE_IA$FIND_PATH		
			#}
			REVERSE_AFTER$180:
			#{
				li s7,0x01000002	# direita 01 00 00 02 	bit_dir,dir,v,h - 0001,0,0,+2
				li s8,0x02010200 	# baixo 02 01 02 00 	bit_dir,dir,v,h - 0010,1,+2,0
				li s9,0x0803FE00	# cima 08 03 FE 00 	bit_dir,dir,v,h - 1000,3,-2,0
				li s10,0x040200FE	# esquerda 04 02 00 FE 	bit_dir,dir,v,h - 0100,2,0,-2
				
				j REVERSE_ANGLE_IA$FIND_PATH
			#}
		#}
	#}	
	
	REVERSE_ANGLE_IA$FIND_PATH:	# s7>s8>s9>s10 prioridade	# s11 = byte data
	#{	
		lb t0,2(a1)	# diretion
		addi t0,t0,2	# direction + 2
		addi t1,zero,4
		rem s0,t0,t1	# (direction + 2)%4 -> dir.oposta = s0
		
		slli s0,s0,16
		slli s11,s11,24
		# ANGLE_IA$s7
		#{
			li t0,0x00FF0000
			and t0,s7,t0		# s7 dir
			beq t0,s0,REVERSE_ANGLE_IA$s8	# direção oposta
			li t0,0xFF000000
			and t0,s7,t0	# s7 bit_dir
			and t0,t0,s11		# Colisão
			beq t0,zero,REVERSE_ANGLE_IA$s8
				sw s7,0(a1)
			jalr zero,ra,0	
		#}
		REVERSE_ANGLE_IA$s8:
		#{
			li t0,0x00FF0000
			and t0,s8,t0		# s8 dir
			beq t0,s0,REVERSE_ANGLE_IA$s9	# direção oposta
			li t0,0xFF000000
			and t0,s8,t0	# s8 bit_dir
			and t0,t0,s11		# Colisão
			beq t0,zero,REVERSE_ANGLE_IA$s9
				sw s8,0(a1)
			jalr zero,ra,0
		#}
		REVERSE_ANGLE_IA$s9:
		#{
			li t0,0x00FF0000
			and t0,s9,t0		# s9 dir
			beq t0,s0,REVERSE_ANGLE_IA$s10	# direção oposta
			li t0,0xFF000000
			and t0,s9,t0		# s9 bit_dir
			and t0,t0,s11		# Colisão
			beq t0,zero,REVERSE_ANGLE_IA$s10
				sw s9,0(a1)
			jalr zero,ra,0
		#}
		REVERSE_ANGLE_IA$s10:
		#{
		#	li t0,0x00FF0000
		#	and t0,s10,t0		# s10 dir
		#	beq t0,s0,ANGLE_IAEND	# direção oposta
		#	li t0,0xFF000000
		#	and t0,s7,t0		# s7 bit_dir
		#	and t0,t0,s11		# Colisão
		#	beq t0,zero,ANGLE_IA$s8
				sw s10,0(a1)
			jalr zero,ra,0
		#}
	#}
	REVERSE_ANGLE_IA$END:
	#{
		lb t0,2(a1)	# diretion
		addi t0,t0,2	# direction + 2
		addi t1,zero,4
		rem s0,t0,t1	# (direction + 2)%4 -> dir.oposta = s0
		
		la s1,map.char
		add s1,s1,t6	# obs:t6 -> extra s
		
		addi t0,zero,0	# 0001
		beq t0,s0,REVERSE_ANGLE_IA$END_NEXT1
		andi t0,s11,0x00000001
		beq t0,zero,REVERSE_ANGLE_IA$END_NEXT1
		#{
			li t0,0x01000002	# direita	
			sw t0,0(a1)
			
			jalr zero,ra,0
		#}
		
		REVERSE_ANGLE_IA$END_NEXT1:
		addi t0,zero,1	# 0010
		beq t0,s0,REVERSE_ANGLE_IA$END_NEXT2
		andi t0,s11,0x00000002
		beq t0,zero,REVERSE_ANGLE_IA$END_NEXT2
		#{
			li t0,0x02010200	# baixo
			sw t0,0(a1)
			
			jalr zero,ra,0
		#}
		
		REVERSE_ANGLE_IA$END_NEXT2:
		addi t0,zero,2	# 0100
		beq t0,s0,REVERSE_ANGLE_IA$END_NEXT3
		andi t0,s11,0x00000004
		beq t0,zero,REVERSE_ANGLE_IA$END_NEXT3
		#{
			li t0,0x040200FE	# esquerda
			sw t0,0(a1)
			
			jalr zero,ra,0
		#}
		
		REVERSE_ANGLE_IA$END_NEXT3:
		addi t0,zero,3	# 1000
		beq t0,s0,REVERSE_ANGLE_IA$END_NEXT4
		andi t0,s11,0x00000008
		beq t0,zero,REVERSE_ANGLE_IA$END_NEXT4
		#{
			li t0,0x0803FE00	# cima
			sw t0,0(a1)	
			
			jalr zero,ra,0
		#}
		
		REVERSE_ANGLE_IA$END_NEXT4:
	#}
	jalr zero,ra,0
#}

ANGLE_IA:	# a0 = ghost.coor | a4 = target.coor |a1 = ghost.direction | a3 = ghost.grid.coor
#{
	# s7 s8 s9 s10 -> possibilidades
	la s11,map.frame
	lb t0,0(a3)	# x
	lb t1,1(a3)	# y
	LARGURA (t2)
	addi t3,zero,8
	div t2,t2,t3	# Largura/8
	mul t2,t2,t1	# (y/8)*(Largura/8)
	add t6,t2,t0	# (y/8)*(Largura/8) + (x/8)	# OBS t6 - extra s
	add s11,s11,t6
	lb s11,0(s11)	# Data byte
	blt zero,s11,ANGLE_IA$END
	
	addi s5,zero,2	# s5 = 1
	fcvt.s.w fs5,s5	# fs5 = 1
	addi s6,zero,-2	# s6 = -1
	fcvt.s.w fs6,s6	# fs6 = -1
	
	lh t0,0(a4)
	lh t1,0(a0)
	sub s2,t0,t1	# s2 = pacx-blinkyx
	fcvt.s.w fs2,s2	# fs2=s2
	
	lh t0,2(a4)
	lh t1,2(a0)
	sub s3,t0,t1	# s3 = pacy-blinkyy
	fcvt.s.w fs3,s3 # fs3 = s3
	
	fcvt.s.w fs4,s3		# Se y/0, pegar sinal e valor de y
	beq s2,zero,POSITIVE$X
	fdiv.s fs4,fs3,fs2	# Senao, pegar valor de y/x
	
	POSITIVE$X:
	blt s2,zero,NEGATIVE$X
	#{		
		blt s3,zero,NEGATIVE$Y1
		#POSITIVE$Y1
		#{
			### Dx>=0, Dy>=0 diagonal direita inferior
			
			flt.s t0,fs4,fs5	# fs4 < 1 -> para direita
			bne t0,zero,AFTER$0
			# BEFORE$90
			#{
				li s7,0x02010200 	# baixo 02 01 02 00 	bit_dir,dir,v,h - 0010,1,+2,0
				li s8,0x01000002	# direita 01 00 00 02 	bit_dir,dir,v,h - 0001,0,0,+2
				li s9,0x040200FE	# esquerda 04 02 00 FE 	bit_dir,dir,v,h - 0100,2,0,-2
				li s10,0x0803FE00	# cima 08 03 FE 00 	bit_dir,dir,v,h - 1000,3,-2,0
				
				j ANGLE_IA$FIND_PATH
			#}
			AFTER$0:
			#{
				li s7,0x01000002	# direita 01 00 00 02 	bit_dir,dir,v,h - 0001,0,0,+2
				li s8,0x02010200 	# baixo 02 01 02 00 	bit_dir,dir,v,h - 0010,1,+2,0
				li s9,0x0803FE00	# cima 08 03 FE 00 	bit_dir,dir,v,h - 1000,3,-2,0
				li s10,0x040200FE	# esquerda 04 02 00 FE 	bit_dir,dir,v,h - 0100,2,0,-2
				
				j ANGLE_IA$FIND_PATH
			#}
		#}
		NEGATIVE$Y1:
		#{
			### Dx>=0, Dy<0 diagonal direita superior
			
			flt.s t0,fs4,fs6	# fs4<-1 -> para cima
			bne t0,zero,AFTER$270
			#BEFORE$0
			#{
				li s7,0x01000002	# direita 01 00 00 02 	bit_dir,dir,v,h - 0001,0,0,+2
				li s8,0x0803FE00	# cima 08 03 FE 00 	bit_dir,dir,v,h - 1000,3,-2,0
				li s9,0x02010200 	# baixo 02 01 02 00 	bit_dir,dir,v,h - 0010,1,+2,0
				li s10,0x040200FE	# esquerda 04 02 00 FE 	bit_dir,dir,v,h - 0100,2,0,-2
				
				j ANGLE_IA$FIND_PATH		
			#}
			AFTER$270:
			#{
				li s7,0x0803FE00	# cima 08 03 FE 00 	bit_dir,dir,v,h - 1000,3,-2,0
				li s8,0x01000002	# direita 01 00 00 02 	bit_dir,dir,v,h - 0001,0,0,+2
				li s9,0x040200FE	# esquerda 04 02 00 FE 	bit_dir,dir,v,h - 0100,2,0,-2
				li s10,0x02010200 	# baixo 02 01 02 00 	bit_dir,dir,v,h - 0010,1,+2,0
				
				j ANGLE_IA$FIND_PATH
			#}
		#}
	#}
	NEGATIVE$X:
	#{
		blt s3,zero,NEGATIVE$Y2
		#POSITIVE$Y2
		#{
			### Dx<0, Dy>=0 diagonal esquerda inferior
			
			flt.s t0,fs4,fs6	#fs4<-1 -> para baixo
			bne t0,zero,AFTER$90
			#BEFORE$180
			#{
				#sb s6,0(a1)	#h=-1
				#sb zero,1(a1)	#v=0
				#li t0,2
				#sb t0,2(a1)	#dir=esquerda
				
				li s7,0x040200FE	# esquerda 04 02 00 FE 	bit_dir,dir,v,h - 0100,2,0,-2
				li s8,0x02010200 	# baixo 02 01 02 00 	bit_dir,dir,v,h - 0010,1,+2,0
				li s9,0x0803FE00	# cima 08 03 FE 00 	bit_dir,dir,v,h - 1000,3,-2,0
				li s10,0x01000002	# direita 01 00 00 02 	bit_dir,dir,v,h - 0001,0,0,+2
				
				j ANGLE_IA$FIND_PATH			
			#}
			AFTER$90:
			#{
				#sb zero,0(a1)	#h=0
				#sb s5,1(a1)	#v=+1
				#li t0,1
				#sb t0,2(a1)	#dir=baixo
				
				li s7,0x02010200 	# baixo 02 01 02 00 	bit_dir,dir,v,h - 0010,1,+2,0
				li s8,0x040200FE	# esquerda 04 02 00 FE 	bit_dir,dir,v,h - 0100,2,0,-2
				li s9,0x01000002	# direita 01 00 00 02 	bit_dir,dir,v,h - 0001,0,0,+2
				li s10,0x0803FE00	# cima 08 03 FE 00 	bit_dir,dir,v,h - 1000,3,-2,0
				
				j ANGLE_IA$FIND_PATH
			#}
		#}
		NEGATIVE$Y2:
		#{
			### Dx<0, Dy<0 diagonal esquerda superior
			
			flt.s t0,fs4,fs5	# fs4 < 1 -> para esquerda
			bne t0,zero,AFTER$180
			#BEFORE$270
			#{
				#sb zero,0(a1)	#h=0
				#sb s6,1(a1)	#v=-1
				#li t0,3
				#sb t0,2(a1)	#dir=cima
				
				li s7,0x0803FE00	# cima 08 03 FE 00 	bit_dir,dir,v,h - 1000,3,-2,0
				li s8,0x040200FE	# esquerda 04 02 00 FE 	bit_dir,dir,v,h - 0100,2,0,-2
				li s9,0x01000002	# direita 01 00 00 02 	bit_dir,dir,v,h - 0001,0,0,+2
				li s10,0x02010200 	# baixo 02 01 02 00 	bit_dir,dir,v,h - 0010,1,+2,0
				
				j ANGLE_IA$FIND_PATH		
			#}
			AFTER$180:
			#{
				#sb s6,0(a1)	#h=-1
				#sb zero,1(a1)	#v=0
				#li t0,2
				#sb t0,2(a1)	#dir=esquerda
				
				li s7,0x040200FE	# esquerda 04 02 00 FE 	bit_dir,dir,v,h - 0100,2,0,-2
				li s8,0x0803FE00	# cima 08 03 FE 00 	bit_dir,dir,v,h - 1000,3,-2,0
				li s9,0x02010200 	# baixo 02 01 02 00 	bit_dir,dir,v,h - 0010,1,+2,0
				li s10,0x01000002	# direita 01 00 00 02 	bit_dir,dir,v,h - 0001,0,0,+2
				
				j ANGLE_IA$FIND_PATH
			#}
		#}
	#}	
	
	ANGLE_IA$FIND_PATH:	# s7>s8>s9>s10 prioridade	# s11 = byte data
	#{	
		lb t0,2(a1)	# diretion
		addi t0,t0,2	# direction + 2
		addi t1,zero,4
		rem s0,t0,t1	# (direction + 2)%4 -> dir.oposta = s0
		
		slli s0,s0,16
		slli s11,s11,24
		# ANGLE_IA$s7
		#{
			li t0,0x00FF0000
			and t0,s7,t0		# s7 dir
			beq t0,s0,ANGLE_IA$s8	# direção oposta
			li t0,0xFF000000
			and t0,s7,t0	# s7 bit_dir
			and t0,t0,s11		# Colisão
			beq t0,zero,ANGLE_IA$s8
				sw s7,0(a1)
			jalr zero,ra,0	
		#}
		ANGLE_IA$s8:
		#{
			li t0,0x00FF0000
			and t0,s8,t0		# s8 dir
			beq t0,s0,ANGLE_IA$s9	# direção oposta
			li t0,0xFF000000
			and t0,s8,t0	# s8 bit_dir
			and t0,t0,s11		# Colisão
			beq t0,zero,ANGLE_IA$s9
				sw s8,0(a1)
			jalr zero,ra,0
		#}
		ANGLE_IA$s9:
		#{
			li t0,0x00FF0000
			and t0,s9,t0		# s9 dir
			beq t0,s0,ANGLE_IA$s10	# direção oposta
			li t0,0xFF000000
			and t0,s9,t0		# s9 bit_dir
			and t0,t0,s11		# Colisão
			beq t0,zero,ANGLE_IA$s10
				sw s9,0(a1)
			jalr zero,ra,0
		#}
		ANGLE_IA$s10:
		#{
		#	li t0,0x00FF0000
		#	and t0,s10,t0		# s10 dir
		#	beq t0,s0,ANGLE_IAEND	# direção oposta
		#	li t0,0xFF000000
		#	and t0,s7,t0		# s7 bit_dir
		#	and t0,t0,s11		# Colisão
		#	beq t0,zero,ANGLE_IA$s8
				sw s10,0(a1)
			jalr zero,ra,0
		#}
	#}
	ANGLE_IA$END:
	#{
		lb t0,2(a1)	# diretion
		addi t0,t0,2	# direction + 2
		addi t1,zero,4
		rem s0,t0,t1	# (direction + 2)%4 -> dir.oposta = s0
		
		la s1,map.char
		add s1,s1,t6	# obs:t6 -> extra s
		
		addi t0,zero,0	# 0001
		beq t0,s0,ANGLE_IA$END_NEXT1
		andi t0,s11,0x00000001
		beq t0,zero,ANGLE_IA$END_NEXT1
		#{
			li t0,0x01000002	# direita	
			sw t0,0(a1)
			
			jalr zero,ra,0
		#}
		
		ANGLE_IA$END_NEXT1:
		addi t0,zero,1	# 0010
		beq t0,s0,ANGLE_IA$END_NEXT2
		andi t0,s11,0x00000002
		beq t0,zero,ANGLE_IA$END_NEXT2
		#{
			li t0,0x02010200	# baixo
			sw t0,0(a1)
			
			jalr zero,ra,0
		#}
		
		ANGLE_IA$END_NEXT2:
		addi t0,zero,2	# 0100
		beq t0,s0,ANGLE_IA$END_NEXT3
		andi t0,s11,0x00000004
		beq t0,zero,ANGLE_IA$END_NEXT3
		#{
			li t0,0x040200FE	# esquerda
			sw t0,0(a1)
			
			jalr zero,ra,0
		#}
		
		ANGLE_IA$END_NEXT3:
		addi t0,zero,3	# 1000
		beq t0,s0,ANGLE_IA$END_NEXT4
		andi t0,s11,0x00000008
		beq t0,zero,ANGLE_IA$END_NEXT4
		#{
			li t0,0x0803FE00	# cima
			sw t0,0(a1)	
			
			jalr zero,ra,0
		#}
		
		ANGLE_IA$END_NEXT4:
	#}
	jalr zero,ra,0
#}
###########################################################################################

EXECUTE_SCRIPT:	# a5 = script | a1 = ghost.direction | s0 = return_adress | a0 = retorno da função | a7 = script_counter
#{
	lh s1,0(a7)	# s1 = script counter
	add t1,s1,a5	# acess adress
	lw t0,0(t1)	# script word
	bne t0,zero,EXECUTE_SCRIPT$CONTINUE	# null
	#{
		sh zero,0(a7)	# zerar contador
		addi a0,zero,0
		jalr zero,s0,0	# return 0
	#}
	EXECUTE_SCRIPT$CONTINUE:
	#{
		sw t0,0(a1)	# store word
		addi s1,s1,4	# s1++4
		sh s1,0(a7)	# store counter
		addi a0,zero,1	 
		jalr zero,s0,0	# return 1
	#}
#}

CHOSE_IA: # a0=ghost.coor | a1=ghost.direction	| a2 = ghost.state | a3=ghost.grid.coor | a4=ghost.scatter.coor | a5 = enter_script | a6 exit_script | a7 script_counter
#{
	lb s11,2(a2)	# s11 = state
	
	andi t0,s11,0x20	# andi 0010 0000 	# enter home
	beq t0,zero,CHOSE_IA$NEXT1
	#{
		# a5 é o correto
		jal s0,EXECUTE_SCRIPT
		# verificar se o script acabou
		bne a0,zero,CHOSE_IA$NEXT0.1
		#{
			# set exit home - 0100 00xx
			ori s11,s11,0x40	# ori 0100 0000 
			andi s11,s11,0x43	# andi 0100 0011
			sb s11,2(a2)		# store new state
		#}
		CHOSE_IA$NEXT0.1:
		jalr zero,ra,0
	#}
	CHOSE_IA$NEXT1:
	andi t0,s11,0x40	# andi 0100 0000	# exit home
	beq t0,zero,CHOSE_IA$NEXT2
	#{
		addi a5,a6,0
		jal s0,EXECUTE_SCRIPT
		# verificar se o script acabou
		bne a0,zero,CHOSE_IA$NEXT1.1
		#{
			# set chase or scatter or run - 0000 xxxx
			andi s11,s11,0x0F	# andi 0000 1111
			sb s11,2(a2)		# store new state
		#}
		CHOSE_IA$NEXT1.1:
		jalr zero,ra,0
	#}
	CHOSE_IA$NEXT2:
	#Verificar se está em casa
	la t2,house.coor
	lw t0,0(a0)
	lw t1,0(t2)
	bne t0,t1,CHOSE_IA$NEXT3
	
	andi t0,s11,0x10	# andi 0001 0000	# go home
	beq t0,zero,CHOSE_IA$NEXT3
	#{
		la a4,house.coor
		lw t0,0(a0)
		lw t1,0(a4)
		bne t0,t1,CHOSE_IA$NEXT2.1
		#{
			# set enter_home 0011 00xx
			ori s11,s11,0x30	# ori 0011 0000 
			andi s11,s11,0x33	# andi 0011 0011
			sb s11,2(a2)		# store new state
			jalr zero,ra,0
		#}
		CHOSE_IA$NEXT2.1:
		j ANGLE_IA
	#}
	CHOSE_IA$NEXT3:
	lb t0,2(a3)	# on grid?
	bne t0,zero,CHOSE_IA$JUMP
	
	andi t0,s11,0x10	# andi 0001 0000	# go home
	beq t0,zero,CHOSE_IA$NEXT4
	#{
		la a4,house.coor
		lw t0,0(a0)
		lw t1,0(a4)
		bne t0,t1,CHOSE_IA$NEXT3.1
		#{
			# set enter_home 0011 00xx
			ori s11,s11,0x30	# ori 0011 0000 
			andi s11,s11,0x33	# andi 0011 0011
			sb s11,2(a2)		# store new state
			jalr zero,ra,0
		#}
		CHOSE_IA$NEXT3.1:
		j ANGLE_IA
	#}
	CHOSE_IA$NEXT4:
	andi t0,s11,0x0C	# andi 0000 1100	# run
	beq t0,zero,CHOSE_IA$NEXT5
	#{
		la a4,mspac.coor
		# contador:
		lh s0,0(a2)	# tempo

		bge s0,zero,CHOSE_IA$NEXT4.1
		# set xxxx 00xx
		#{
			andi s11,s11,0xF3	#andi xxxx 00xx - chase or scatter or exit or enter
			sb s11,2(a2)
			jalr zero,ra,0	
		#}
		CHOSE_IA$NEXT4.1:
		addi t0,zero,20
		bne s0,t0,CHOSE_IA$NEXT4.2	# piscar
		# set xxxx 10xx
		#{
			andi s11,s11,0xF3	# andi xxxx 00xx
			ori s11,s11,0x08	# ori xxxx 10xx
			sb s11,2(a2)
		#}
		CHOSE_IA$NEXT4.2:
		
		addi s0,s0,-1	# tempo --
		sh s0,0(a2)
		j REVERSE_ANGLE_IA
	#}
	CHOSE_IA$NEXT5:
	andi t0,s11,0x01	# andi 0000 0001	# chase
	beq t0,zero,CHOSE_IA$NEXT6
	#{
		la a4,mspac.coor
		j ANGLE_IA
	#}
	CHOSE_IA$NEXT6:
	andi t0,s11,0x02	# andi 0000 0010	# scatter
	beq t0,zero,CHOSE_IA$JUMP
	#{
		# já é o correto (a4)
		j ANGLE_IA
	#}
	
	CHOSE_IA$JUMP:
	
	jalr zero,ra,0
#}

.macro PRINT_LIVES()
	la t0,exceptionHandling		# carrega em t0 o endereÃ§o base das rotinas do sistema ECALL
 	csrrw zero,5,t0 		# seta utvec (reg 5) para o endereÃ§o t0
 	csrrsi zero,0,1 		# seta o bit de habilitaÃ§Ã£o de interrupÃ§Ã£o em ustatus (reg 0)
	la t0,lives
	lw t0,0(t0)
	
	addi a7 zero 101
	mv a0 t0
	addi a1 zero 48
	addi a2 zero 205
	addi a3 zero 0x0007
	ecall
.end_macro

.macro PRINT_SCORE()
	la t0,exceptionHandling		# carrega em t0 o endereÃ§o base das rotinas do sistema ECALL
 	csrrw zero,5,t0 		# seta utvec (reg 5) para o endereÃ§o t0
 	csrrsi zero,0,1 		# seta o bit de habilitaÃ§Ã£o de interrupÃ§Ã£o em ustatus (reg 0)
	la t0,score
	lw t0,0(t0)
	
	li t1 999999
	sub t2 t1 t0
	ble t2 zero NEGATIVE
	jal zero END_NEGATIVE
	NEGATIVE:
	mv t0 t1
	END_NEGATIVE:
	
	
	addi a7 zero 101
	mv a0 t0
	addi a1 zero 27
	addi a2 zero 69
	addi a3 zero 0x0007
	ecall	
.end_macro

MSPAC_EATING:
#{
	LARGURA (s0)
	addi s4,zero,8

	la s10,mspac.grid.coor
	
	lb t0,2(s10)
	bne t0,zero,MSPAC_EATING$NEXT2
	lb s1,0(s10)
	lb s2,1(s10)
	
	div t2,s0,s4
	mul t0,s2,t2	# (y/8)*(largura/8)
	add t0,t0,s1	# (y/8)*(largura/8)+(x/8)
	
	la s8,map.char
	add s8,s8,t0	# &adress + y*l+x
	lb s3,0(s8)	# char

	li t0,'.'
	bne s3,t0,MSPAC_EATING$NEXT1
	#{
		la t2,score
		lw t0,0(t2)
		addi t0,t0,10
		sw t0,0(t2)	# score++10
		
		j MSPAC_EATING$ERASE
	#}
	MSPAC_EATING$NEXT1:
	li t0,'O'
	bne s3,t0,MSPAC_EATING$NEXT2
	#{
		la t2,score
		lw t0,0(t2)
		addi t0,t0,50
		sw t0,0(t2)	# score++50
		
		#ativar modo azul:
		la s11,blinky.status
		lb t1,2(s11)
		andi t2,t1,0x30	#andi 0011 0000
		bne t2,zero,MSPAC_EATING$POWER_NEXT1
		#{
			# set xx00 01xx
			andi t1,t1,0xC3	# andi 1100 0011
			ori t1,t1,0x04	# ori 0000 0100 
			sb t1,2(s11)
			la t3,blinky.animation
			sh zero,0(t3)
			la t0,run.time
			lh t0,0(t0)
			sh t0,0(s11)
			INVERSAO(blinky.direction)
		#}
			
		MSPAC_EATING$POWER_NEXT1:
		
		la s11,pinky.status
		lb t1,2(s11)
		andi t2,t1,0x30	#andi 0011 0000
		bne t2,zero,MSPAC_EATING$POWER_NEXT2
		#{
			# set xx00 01xx
			andi t1,t1,0xC3	# andi 1100 0011
			ori t1,t1,0x04	# ori 0000 0100 
			sb t1,2(s11)
			la t3,pinky.animation
			sh zero,0(t3)
			la t0,run.time
			lh t0,0(t0)
			sh t0,0(s11)
			INVERSAO(pinky.direction)
		#}
		MSPAC_EATING$POWER_NEXT2:
		la s11,inky.status
		lb t1,2(s11)
		andi t2,t1,0x30	#andi 0011 0000
		bne t2,zero,MSPAC_EATING$POWER_NEXT3
		#{
			# set xx00 01xx
			andi t1,t1,0xC3	# andi 1100 0011
			ori t1,t1,0x04	# ori 0000 0100 
			sb t1,2(s11)
			la t3,inky.animation
			sh zero,0(t3)
			la t0,run.time
			lh t0,0(t0)
			sh t0,0(s11)
			INVERSAO(inky.direction)
		#}
		MSPAC_EATING$POWER_NEXT3:
		la s11,clyde.status
		lb t1,2(s11)
		andi t2,t1,0x30	#andi 0011 0000
		bne t2,zero,MSPAC_EATING$POWER_NEXT4
		#{
			# set xx00 01xx
			andi t1,t1,0xC3	# andi 1100 0011
			ori t1,t1,0x04	# ori 0000 0100 
			sb t1,2(s11)
			la t3,clyde.animation
			sh zero,0(t3)
			la t0,run.time
			lh t0,0(t0)
			sh t0,0(s11)
			INVERSAO(clyde.direction)
		#}
		MSPAC_EATING$POWER_NEXT4:
		
		j MSPAC_EATING$ERASE
	#}	
	
	MSPAC_EATING$NEXT2:	
	jalr zero,ra,0
	
	MSPAC_EATING$ERASE:
	#{	
		la t0,mspac.coor
		lh s1,0(t0)	# x
		lh s2,2(t0)	# y
		addi s2,s2,-3	# y-3
	
		# Contar a comida
		#{
			la t0,counter
			lh t1,0(t0)
			addi t1,t1,1
			sh t1,0(t0) 
		#}
	
		li t0,' '
		sb t0,0(s8)	# Apagar no map frame
	
		mul t0,s2,s0	# y*largura
		add t0,t0,s1	# y*largura + x
		la s5,map.image
		add s5,s5,t0	# $mapimage + y*largura + x
		
		# s4=8 = largura e altura a ser apagada
		
		mul t0,s4,s0
		add s7,s5,t0 	# condição de parada
		
		MSPAC_EATING$ERASE_LOOP1:
		#{
			addi s6,zero,0	#s6=0
			MSPAC_EATING$ERASE_LOOP2:
			#{
				add t0,s6,s5
				sb zero,0(t0)	# deixar preto = apagar
				
				addi s6,s6,1	# s6++
				blt s6,s4,MSPAC_EATING$ERASE_LOOP2	# s6<s4
			#}
			add s5,s5,s0	# prox linha
			blt s5,s7,MSPAC_EATING$ERASE_LOOP1
		#}
	#}
	PRINT_SCORE ()
	jalr zero,ra,0
#}

# a2 = K.coor

DIE_OR_REBORN:
#{
	add t3 zero zero
	add t2 zero zero
	add t1 zero zero
		
	PRINT_DEATH_LOOP:
		addi t0 zero 8
		beq t3 t0 END_PRINT_DEATH_LOOP
		addi t0 zero 4
		rem t4 t3 t0
		beq t4 zero SET_VALUES_DEATH_MSPACMAN
		jal zero PRINT_DEATH_LOOP2 
		SET_VALUES_DEATH_MSPACMAN:
			la s0 DEATH_MSPACMAN
			li s1 0xFF000060
			la t5 mspac.image.coor
			lh t6 0(t5)
			lh t5 2(t5)
			add s1 s1 t6
			addi s6 zero 320
			mul t5 t5 s6
			add s1 s1 t5
			addi s1 s1 1
		PRINT_DEATH_LOOP2:
			addi t0 zero 16
			beq t2 t0 END_PRINT_DEATH_LOOP2
			PRINT_DEATH_LOOP3:
				addi t0 zero 16
				beq t1 t0 END_PRINT_DEATH_LOOP3
				
					
				lb t4 0(s0)	# Posição inicial da MsPacman para print
				sb t4 0(s1)
				
				addi s0 s0 1
				addi s1 s1 1
				addi t1 t1 1
				jal zero PRINT_DEATH_LOOP3
			END_PRINT_DEATH_LOOP3: 
			addi s1 s1 304		# Quebra de linha
			add t1 zero zero	# Zera o contador do loop 3
			addi t2 t2 1
			jal zero PRINT_DEATH_LOOP2
		END_PRINT_DEATH_LOOP2:
		li s1 0xFF000060
		la t5 mspac.image.coor
		lh t6 0(t5)
		lh t5 2(t5)
		add s1 s1 t6
		addi s6 zero 320
		mul t5 t5 s6
		add s1 s1 t5
		addi s1 s1 1
			
		add t2 zero zero
		add t1 zero zero
		addi a7 zero 32		# Sleep para a próxima imagem 
		addi a0 zero 200
		ecall
		addi t3 t3 1
		jal zero PRINT_DEATH_LOOP
	END_PRINT_DEATH_LOOP:
	addi a7 zero 32		# Sleep para a próxima imagem 
	addi a0 zero 300
	ecall
	
	la s1 lives
	lb s0 0(s1)
	addi s0 s0 -1
	blt s0 zero GO_TO_GAMEOVER
	#{
		sb s0,0(s1)
	
		la a2,mspac.image.coor
		la t0,ERASE
		jalr ra,t0,0
		
		la a2,blinky.image.coor
		la t0,ERASE
		jalr ra,t0,0
		
		la a2,pinky.image.coor
		la t0,ERASE
		jalr ra,t0,0
		
		la a2,inky.image.coor
		la t0,ERASE
		jalr ra,t0,0
			
		la a2,clyde.image.coor
		la t0,ERASE
		jalr ra,t0,0
		
		la a2,fruit.image.coor
		la t0,ERASE
		jalr ra,t0,0
	#}
	RESPAWN
	PRINT_LIVES
	la t0 LEVEL_LOOP
	jalr zero t0 0
	
	GO_TO_GAMEOVER:
	la t0 GAMEOVER
	jalr zero t0 0
#}

CONTATO: # a0 = %ghost.coor,a1 = %ghost.status -> cuidado com a ecall de som
#{
	addi s1,a1,0
	addi s3,a0,0
	lbu s2,2(s1)	# ghost.status byte  xxxx xxxx
	andi t0,s2,0x70	# 0111 0000
	beq t0,zero,CONTATO$NEXT	# Fantasma neutro
		jalr zero,ra,0
	CONTATO$NEXT:
	
	la s0,mspac.coor
	
	lh t0,0(s0)
	lh t1,0(s3)
	sub t2,t0,t1	# Dx
	mul t2,t2,t2
	
	lh t0,2(s0)
	lh t1,2(s3)
	sub t3,t0,t1	# Dy
	mul t3,t3,t3
	
	add s0,t2,t3	# Dx²+Dy²
	
	fcvt.s.w fs0,s0
	fsqrt.s fs0,fs0	# sqrt (Dx²+Dy²) 
	#fsw fs0,0(a1)
	
	
	addi s0,zero,8
	fcvt.s.w fs1,s0
	
	flt.s t0,fs0,fs1
	beq t0,zero,CONTATO$END	# fora de alcance
	
	andi t0,s2,0x0C	# 0000 1100
	beq t0,zero,CONTATO$NEXT2	# Fantasma comestivel
	#{
		# set 0001 00xx
		SOUND_SYNC(50,300,123,100)
		andi t0,s2,0x03	# andi 0000 0011
		ori t0,t0,0x10	# ori 0001 0000
		sb t0,2(s1)
		
		la t0,score
		lw s3,0(t0)
		addi s3,s3,800
		sw s3,0(t0)
		PRINT_SCORE
		j CONTATO$END
	#}

	CONTATO$NEXT2:
	# Fantasma mortal
		la t0 DIE_OR_REBORN
		jalr zero t0 0
		
	CONTATO$END:
	jalr zero,ra,0
#}

CONTATO_FRUIT:
#{
	la s0,mspac.coor
	la s3,fruit.coor
	
	lh t0,0(s0)
	lh t1,0(s3)
	sub t2,t0,t1	# Dx
	mul t2,t2,t2
	
	lh t0,2(s0)
	lh t1,2(s3)
	sub t3,t0,t1	# Dy
	mul t3,t3,t3
	
	add s0,t2,t3	# Dx²+Dy²
	
	fcvt.s.w fs0,s0
	fsqrt.s fs0,fs0	# sqrt (Dx²+Dy²) 
	
	addi s0,zero,8
	fcvt.s.w fs1,s0
	
	flt.s t0,fs0,fs1
	beq t0,zero,CONTATO_FRUIT$END	# fora de alcance
	#{
		la t0,fruit.clock
		addi t1,zero,200
		sh t1,0(t0)
		
		la t0,fruit.spawn
		lw t0,0(t0)
		la t1,fruit.image.coor
		sw t0,0(t1)
		
		add a0,zero,t1
		
		
		addi s10,ra,0
		la t0,ERASE
		jalr ra,t0,0
		
		la t0,score
		lw t1,0(t0)
		addi t1,t1,1000
		sw t1,0(t0)
		
		PRINT_SCORE ()
		
		addi ra,s10,0
	#}
	CONTATO_FRUIT$END:
	jalr zero,ra,0
#}


# a4=ghost.scatter.coor | a5 = script
.macro CHOSE_IA_ARG (%ghost.coor,%ghost.direction,%ghost.status,%ghost.grid.coor,%ghost.enter_home,%ghost.exit_home,%ghost.corner,%ghost.script_counter)
#{
	la a0,%ghost.coor
	la a1,%ghost.direction
	la a2,%ghost.status
	la a3,%ghost.grid.coor
	la a4,%ghost.corner
	la a5,%ghost.enter_home
	la a6,%ghost.exit_home
	la a7,%ghost.script_counter
#}
.end_macro

.macro GHOST(%SLEEP,%ghost.speed,%ghost.coor,%ghost.direction,%ghost.grid.coor,%ghost.image.coor,%ghost.image,%ghost.image_adress,%ghost.animation,%ghost.status,%ghost.enter_home,%ghost.exit_home,%ghost.corner,%ghost.script_counter)
#{
	la s0,%ghost.status
	lb s0,2(s0)
	
	la a0,%ghost.speed
	andi t0,s0,0x30	# 0001 0000
	beq t0,zero,GHOST$NEXT0.1
	#{
		addi a1,zero,120
		SPEED (a0,a1,%SLEEP)
		j GHOST$NEXT0.3
	#}
	GHOST$NEXT0.1:
	andi t0,s0,0x0C	# 0000 1100
	beq t0,zero,GHOST$NEXT0.2
	#{
		addi a1,zero,2
		SPEED (a0,a1,%SLEEP)
		j GHOST$NEXT0.3
	#}
	GHOST$NEXT0.2:
		lb a1,1(a0)
	SPEED (a0,a1,%SLEEP)
	GHOST$NEXT0.3:
	
	CHOSE_IA_ARG (%ghost.coor,%ghost.direction,%ghost.status,%ghost.grid.coor,%ghost.enter_home,%ghost.exit_home,%ghost.corner,%ghost.script_counter)
	la t0,CHOSE_IA
	jalr ra,t0,0 	# Chose ia -> angle_ia -> Return
		
	CHANGE_COOR.arg (%ghost.coor,%ghost.image.coor,%ghost.direction,%ghost.grid.coor)
	la t0,CHANGE_COOR
	jalr ra,t0,0	# Deve ser usada para atualizar as coordenadas
	
	la s0,%ghost.status
	lb s0,2(s0)
	
	andi t0,s0,0x10	# andi 0001 0000
	beq t0,zero,GHOST$NEXT1
	#{
		la a0,%ghost.direction
		la a1,eye.image
		la a2,%ghost.image_adress
		li a3,324	
		la t0,CHANGE_I.DIRECTION
		jalr ra,t0,0
		PRINT.arg (%ghost.image_adress,%ghost.animation,%ghost.image.coor,%ghost.direction,1)
		j GHOST$NEXT4
	#{
	GHOST$NEXT1:
	andi t0,s0,0x04	# andi 0000 0100
	beq t0,zero,GHOST$NEXT2
	#{
		PRINT.arg (blue.image_pointer,%ghost.animation,%ghost.image.coor,%ghost.direction,648)
		j GHOST$NEXT4
	#}
	GHOST$NEXT2:
	andi t0,s0,0x08	# andi 0000 1000
	beq t0,zero,GHOST$NEXT3	
	#{
		PRINT.arg (white.image_pointer,%ghost.animation,%ghost.image.coor,%ghost.direction,1296)
		j GHOST$NEXT4
	#{
	GHOST$NEXT3:
	#andi t0,s0,0x63	# andi 0000 0011
	#beq t0,zero,GHOST$NEXT4
	#{
		la a0,%ghost.direction
		la a1,%ghost.image
		la a2,%ghost.image_adress
		li a3,2592	
		la t0,CHANGE_I.DIRECTION
		jalr ra,t0,0
		PRINT.arg (%ghost.image_adress,%ghost.animation,%ghost.image.coor,%ghost.direction,2592)
	#{
	GHOST$NEXT4:	
	
	la t0,PRINT
	jalr ra,t0,0	# PRINT -> Return
#}
.end_macro

GAME_MODE: 
#{
	#  | half: chase | half scatter | half: counter | 0000 0001 = chase,0000 0010 = scattter -> armazena o oposto
	la s0,game.mode
	lb s1,6(s0)
	addi t1,zero,1	# 0000 0001
	bne s1,t1,GAME_MODE$SCATTER
	# CHASE
	#{
		lh s2,4(s0)	# counter
		lh s3,0(s0)	# chase
		bne s2,s3,GAME_MODE$CHASE_PROCEED
		# get xxxx xx10
		#{
			sh zero,4(s0)	# zerar contador
			addi t0,zero,0x02	# 0000 0010
			sb t0,6(s0)	# guardar modo oposto
			
			la t0,blinky.status
			lb t1,2(t0)
			andi t1,t1,0xFC	# andi 1111 1100
			ori t1,t1,0x02	# ori xxxx xx10
			sb t1,2(t0)
			INVERSAO(blinky.direction)
			
			la t0,pinky.status
			lb t1,2(t0)
			andi t1,t1,0xFC	# andi 1111 1100
			ori t1,t1,0x02	# ori xxxx xx10
			sb t1,2(t0)
			INVERSAO(pinky.direction)
			
			la t0,inky.status
			lb t1,2(t0)
			andi t1,t1,0xFC	# andi 1111 1100
			ori t1,t1,0x02	# ori xxxx xx10
			sb t1,2(t0)
			INVERSAO(inky.direction)
			
			la t0,clyde.status
			lb t1,2(t0)
			andi t1,t1,0xFC	# andi 1111 1100
			ori t1,t1,0x02	# ori xxxx xx10
			sb t1,2(t0)
			INVERSAO(clyde.direction)
			
			jalr zero,ra,0
		#}
		GAME_MODE$CHASE_PROCEED:
		#{
			addi s2,s2,1	# contador++
			sh s2,4(s0)	# guardar contador
			
			jalr zero,ra,0
		#}
	#}
	GAME_MODE$SCATTER:
	#{
		lh s2,4(s0)	# counter
		lh s3,2(s0)	# scatter
		bne s2,s3,GAME_MODE$SCATTER_PROCEED
		# get xxxx xx01
		#{
			sh zero,4(s0)	# zerar contador
			addi t0,zero,0x01	# 0000 0001
			sb t0,6(s0)	# guardar modo oposto
			
			la t0,blinky.status
			lb t1,2(t0)
			andi t1,t1,0xFC	# andi 1111 1100
			ori t1,t1,0x01	# ori xxxx xx01
			sb t1,2(t0)
			INVERSAO(blinky.direction)
			
			la t0,pinky.status
			lb t1,2(t0)
			andi t1,t1,0xFC	# andi 1111 1100
			ori t1,t1,0x01	# ori xxxx xx01
			sb t1,2(t0)
			INVERSAO(pinky.direction)
			
			la t0,inky.status
			lb t1,2(t0)
			andi t1,t1,0xFC	# andi 1111 1100
			ori t1,t1,0x01	# ori xxxx xx01
			sb t1,2(t0)
			INVERSAO(inky.direction)
			
			la t0,clyde.status
			lb t1,2(t0)
			andi t1,t1,0xFC	# andi 1111 1100
			ori t1,t1,0x01	# ori xxxx xx01
			sb t1,2(t0)
			INVERSAO(clyde.direction)
			
			jalr zero,ra,0
		#}
		GAME_MODE$SCATTER_PROCEED:
		#{
			addi s2,s2,1	# contador++
			sh s2,4(s0)	# guardar contador
			
			jalr zero,ra,0
		#}
	
	#}
#}
########### LEVEL ########################################################################################
LEVEL:
 # store return
 la t0,map.return
 sw ra,0(t0)
 
LEVEL_LOOP:
#{
	# MSPAC ############################################################################
	la t0,GET_KEY
	jalr ra,t0,0	# GET_KEY -> DEFINE_PRE_DIRECTION DA MS.PACMAN -> Return
	
			la a0,mspac.speed
			lb a1,1(a0)
	SPEED (a0,a1,SLEEP_MSPAC)
	
	la t0,DEFINE_MSPAC_DIRECTION
	jalr ra,t0,0 	# DEFINE_MSPAC_DIRECTION -> Return
		
	CHANGE_COOR.arg (mspac.coor,mspac.image.coor,mspac.direction,mspac.grid.coor)
	la t0,CHANGE_COOR
	jalr ra,t0,0	# Deve ser usada para atualizar as coordenadas
	
			la a0,mspac.direction
			la a1,mspac.image
			la a2,mspac.image_adress
			li a3,1296
	la t0,CHANGE_I.DIRECTION
	jalr ra,t0,0
	
	PRINT.arg (mspac.image_adress,mspac.animation,mspac.image.coor,mspac.direction,1296)
	la t0,PRINT		
	jalr ra,t0,0	# PRINT -> Return
	
	SLEEP_MSPAC:
	
	# Blinky ############################################################################	
	GHOST (SLEEP_BLINKY,blinky.speed,blinky.coor,blinky.direction,blinky.grid.coor,blinky.image.coor,blinky.image,blinky.image_adress,blinky.animation,blinky.status,blinky.enter_home,blinky.exit_home,blinky.corner,blinky.script_counter)
	SLEEP_BLINKY:
	# Pinky ############################################################################	
	GHOST (SLEEP_PINKY,pinky.speed,pinky.coor,pinky.direction,pinky.grid.coor,pinky.image.coor,pinky.image,pinky.image_adress,pinky.animation,pinky.status,pinky.enter_home,pinky.exit_home,pinky.corner,pinky.script_counter)
	SLEEP_PINKY:
	
	# Inky ############################################################################	
	GHOST (SLEEP_INKY,inky.speed,inky.coor,inky.direction,inky.grid.coor,inky.image.coor,inky.image,inky.image_adress,inky.animation,inky.status,inky.enter_home,inky.exit_home,inky.corner,inky.script_counter)
	SLEEP_INKY:
	
	# Clyde ############################################################################	
	GHOST (SLEEP_CLYDE,clyde.speed,clyde.coor,clyde.direction,clyde.grid.coor,clyde.image.coor,clyde.image,clyde.image_adress,clyde.animation,clyde.status,clyde.enter_home,clyde.exit_home,clyde.corner,clyde.script_counter)
	
	SLEEP_CLYDE:
	###########################################################################
	# FRUIT ############################################################################
	la t0,fruit.clock
	lh t1,0(t0)
	beq t1,zero,FRUIT$NEXT1
	#{
		addi t1,t1,-1	# diminuir contador
		sh t1,0(t0)
		j FRUIT$NEXT3
	#}
	FRUIT$NEXT1:
	la a5,fruit.path
	la a1,fruit.direction
	la a7,fruit.path_counter
	la t0,EXECUTE_SCRIPT
	jalr s0,t0,0	# a0 = retorno da função
	bne a0,zero,FRUIT$NEXT2
	#{
		la t0,fruit.clock
		addi t1,zero,200
		sh t1,0(t0)
		
		la t0,fruit.spawn
		lw t0,0(t0)
		la t1,fruit.image.coor
		sw t0,0(t1)
		
		j FRUIT$NEXT3
	#}	
	FRUIT$NEXT2:
	
	CHANGE_COOR.arg (fruit.coor,fruit.image.coor,fruit.direction,aux.script)
	la t0,CHANGE_FRUIT_COOR
	jalr ra,t0,0	# Deve ser usada para atualizar as coordenadas
	
	PRINT.arg (fruit.image_pointer,fruit.animation,fruit.image.coor,fruit.direction,2736)
	la t0,PRINT_FRUIT		
	jalr ra,t0,0	# PRINT -> Return:
	
	la t0,CONTATO_FRUIT
	jalr ra,t0,0
	
	FRUIT$NEXT3:
	########################################################################################
	la t0,MSPAC_EATING
	jalr ra,t0,0
	
	la t0,GAME_MODE
	jalr ra,t0,0
	
	la a0,blinky.coor
	la a1,blinky.status
	la t0,CONTATO
	jalr ra,t0,0
	
	la a0,pinky.coor
	la a1,pinky.status
	la t0,CONTATO
	jalr ra,t0,0
	
	la a0,inky.coor
	la a1,inky.status
	la t0,CONTATO
	jalr ra,t0,0
	
	la a0,clyde.coor
	la a1,clyde.status
	la t0,CONTATO
	jalr ra,t0,0
	
	la t0,counter
	lh t1,2(t0)	# limite
	lh t0,0(t0)	# contador
	blt t0,t1,LEVEL_LOOP	# comeu tudo?
	
	PROXIMA_FASE:
	# recover return
 	la t0,map.return
 	lw t0,0(t0)
	jalr zero,t0,0
#}
###########################################################################
PRINT_MAP:	
#{		
	addi a7 zero 1024
	la a0, BACKGROUND_MAP
	add a1 zero zero
	ecall
	addi t0,a0,0	#obs: t0 = file descriptor
	
	li a7,63
	li a1,0xFF000000
	li a2,76800
	ecall

	addi a0,t0,0	#obs: t0 = file descriptor
	li a7,57
	ecall
	
	PRINT_LIVES()
	PRINT_SCORE ()
	PONTO_INICIAL (s0)																				#
	LARGURA (s1)
	ALTURA (s2)
	
	mul s4,s1,s2
	la s5,map.image	
	add s4,s4,s5	# fim da imagem
	
	PRINT_MAP$Y:													
	#{														
		addi s3,zero,0	# s3=0								
		PRINT_MAP$X:												
		#{													
			add t0,s3,s0	# Bitmap							
			lw t1,0(s5)	# Pixels
			
			sw t1,0(t0)	# Printar pixels no bitmap
																											
			# Proximo pixel na imagem									
			addi s5,s5,4	# s5 ++										
															
			# Proximo pixel da linha do bitmap											
			addi s3,s3,4	# s3 ++							
															
			# loop if s3 < largura										
			blt s3,s1,PRINT_MAP$X										
		#}													
		addi s0,s0,320	# Quebrar linha	- +largura							
															
		# loop if s0 < s4 <=> Se acabar a imagem									
		blt s5,s4,PRINT_MAP$Y											
	#}														
	jalr zero,ra,0 #return
#}
GAME_START:

# VIDAS
la t0,lives
addi t1,zero,3
sb t1,0(t0)

PREPARE_LEVEL (map1.frame_file,map1.image_file,cherry_file,map1fruit_path_file)
SET_GAME (1000,300,8,8,208,8,208,232,8,232,100,128)
RESPAWN
	PRINT_NEXT_STAGE(BACKGROUND_NEXT_STAGE1_FILE)
	la t0 PRINT_MAP
	jalr ra t0 0
	la t0 LEVEL
	jalr ra t0 0

PREPARE_LEVEL (map2.frame_file,map2.image_file,orange_file,map2fruit_path_file)
SET_GAME (1150,200,8,8,208,8,208,232,8,232,75,64)
RESPAWN
	PRINT_NEXT_STAGE(BACKGROUND_NEXT_STAGE2_FILE)
	la t0 PRINT_MAP
	jalr ra t0 0
	la t0 LEVEL
	jalr ra t0 0

PREPARE_LEVEL (map3.frame_file,map3.image_file,apple_file,map3fruit_path_file)
SET_GAME (1350,100,8,32,208,32,208,232,8,232,50,0)
RESPAWN
	PRINT_NEXT_STAGE(BACKGROUND_NEXT_STAGE3_FILE)
	la t0 PRINT_MAP
	jalr ra t0 0
	la t0 LEVEL
	jalr ra t0 0

PREPARE_LEVEL (map4.frame_file,map4.image_file,key_file,map4fruit_path_file)
SET_GAME (1500,50,8,8,208,8,208,232,8,232,25,96)
RESPAWN
	PRINT_NEXT_STAGE(BACKGROUND_NEXT_STAGE4_FILE)
	la t0 PRINT_MAP
	jalr ra t0 0
	la t0 LEVEL
	jalr ra t0 0
	
#### GAME OVER SCREEN ####
#{
GAMEOVER:
	la t0 score
	addi t1 zero 0
	sw t1 0(t0)
	la t0 lives
	addi t1 zero 3
	sw t1 0(t0)
	jal zero setvalues_gameover
KEY5: 	
	li t1,0xFF200000		# carrega o endereço de controle do KDMMIO
	li t2 0				# Reseta o valor de t2 que armazena o caractere do teclado para nova leitura
LOOP5: 	
	lw t0,0(t1)			# Le bit de Controle Teclado
   	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,LOOP5		# não tem tecla pressionada então volta ao loop
   	lw t2,4(t1)			# le o valor da tecla
   	beq t2, s7, subirprint4		# Se a tecla lida for w(77) ele vai para a função subirprint
   	beq t2, s8, descerprint4	# Se a tecla lida for s(73) ele vai para a função descerprint
   	beq t2, s1, back_gameover 	# Se t2 for enter(a), executa a função main_menu novamente printando menu inicial antes
	b LOOP5

subirprint4:
   	addi a7 zero 31
   	addi a0 zero 62
   	addi a1 zero 250
   	addi a2 zero 16
   	addi a3 zero 100
   	ecall
	addi s0 s0 -1					# Subtrair 1 do valor de s0 para subir um print
	slt t3 s0 s2					# Se s0 for menor que 1, t3=1, senao t3=0
	beq t3 s2 tornarvalor1_gameover		# Se t3 for igual a 1 então pula para a função tornarvalor2_instrucoes
	beq s0 s2 printgameover1			# Se s0 for igual a 1 entao vai para a função printinstrucoes1
	beq s0 s3 printgameover2			# Se s0 for igual a 2 entao vai para a função printinstrucoes2
	tornarvalor1_gameover:
		li s0 2	
		b printgameover2

descerprint4:
   	addi a7 zero 31
   	addi a0 zero 62
   	addi a1 zero 250
   	addi a2 zero 16
   	addi a3 zero 100
   	ecall
	addi s0 s0 1					# Soma 1 do valor de s0 para descer um print
	slt t3 s0 s3					# Se s0 for maior que 2, t0=1, senao t0=0
	beq t3 s2 tornarvalor2_gameover			# Se t3 for igual a 1 então pula para a função tornarvalor1_instrucoes
	beq s0 s2 printgameover1			# Se s0 for igual a 1 entao vai para a função printinstrucoes1
	beq s0 s3 printgameover2			# Se s0 for igual a 2 entao vai para a função printinstrucoes2
	tornarvalor2_gameover:
		li s0 1	
		b printgameover1

back_gameover:
   	addi a7 zero 31
   	addi a0 zero 65
   	addi a1 zero 250
   	addi a2 zero 16
   	addi a3 zero 100
   	ecall
   	addi a0 zero 62
   	ecall
   	
   	addi t0 zero 1
   	bne s0 t0 otheroption 
   	la t6 setvalues_main_menu
	jalr zero t6 0
	otheroption:
	la t6 jogar
	jalr zero t6 0
	
setvalues_gameover:
	li s0 1
	li s1 '\n'			# Valor da tecla enter(a)
	li s2 1				# s2, s3 são os valores para as condições de qual print ir
	li s3 2
	li s4 3
	li s7 'd'			# Valor do caractere "w"
	li s8 'a'			# Valor do caractere "s"

printgameover1:
	li a7 1024 
	la a0 gameover1
	li a1 0
	ecall

	mv t0 a0
	li a1 0xFF000000
	li a2 76800
	li a7 63
	ecall

	mv a0 t0
	li a7 57
	ecall
	j KEY5

printgameover2:
	li a7 1024 
	la a0 gameover2
	li a1 0
	ecall

	mv t0 a0
	li a1 0xFF000000
	li a2 76800
	li a7 63
	ecall

	mv a0 t0
	li a7 57
	ecall
	j KEY5
#}
#### GAME OVER SCREEN ####


sair:
addi a7,zero,10
ecall

# Funcoes a serem utilizadas pela main_menu: FIM
.include "SYSTEMv11.s"			# carrega as rotinas do sistema

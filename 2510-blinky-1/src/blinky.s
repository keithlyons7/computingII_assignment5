.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

.global Main

.include "./src/definitions.s"

.section .text
Main:
    @ Enable GPIOE and GPIOA clocks
    LDR R0, =RCC_AHBENR
    LDR R1, [R0]
    ORR R1, R1, #(1 << RCC_AHBENR_GPIOEEN)  @ Enable GPIOE clock
    ORR R1, R1, #(1 << RCC_AHBENR_GPIOAEN)  @ Enable GPIOA clock
    STR R1, [R0]

    @ Configure GPIOE pins for output (for LEDs)
    LDR R0, =GPIOE_MODER
    MOV R1, #0x55555555  @ Set all pins as output, adjust the mask as needed
    STR R1, [R0]

    B game_loop

game_loop:
    @ Turn on all LEDs
    LDR R0, =GPIOE_ODR
    MOV R1, #ALL_LEDS_MASK  @ Set all LEDs, define ALL_LEDS_MASK as needed
    STR R1, [R0]

    @ Delay loop to keep all LEDs on for a second
    LDR R5, =100000  @ Approximately one second; adjust this value based on clock speed
delay_loop:
    SUBS R5, R5, #1
    BNE delay_loop

    @ Turn off all LEDs
    MOV R1, #0
    STR R1, [R0]

    @ Check button press
    LDR R0, =GPIOA_IDR
    LDR R1, [R0]
    TST R1, #1
    BNE button_pressed

    @ Decide what to do next or end game
    B game_over  @ Assuming we want to end game here; adjust as needed

button_pressed:
    @ If button is pressed, flash specific LEDs (example: 5 and 35)
    LDR R0, =GPIOE_ODR
    MOV R2, #(1 << 5) | (1 << 35)  @ Set the specific LEDs, adjust mask as needed
    STR R2, [R0]
    BL delay  @ Show for a short period
    B reset_game

game_over:
    @ End game actions
    LDR R0, =GPIOE_ODR
    MOV R2, #ALL_LEDS_MASK  @ Flash all LEDs to signal game over
    STR R2, [R0]
    BL delay  @ Flash delay
    MOV R2, #0
    STR R2, [R0]
    B reset_game

reset_game:
    @ Reset the game logic and restart
    LDR R0, =GPIOE_ODR
    MOV R1, #0
    STR R1, [R0]  @ Turn all LEDs off
    B Main  @ Restart the game

delay:
    LDR R5, =100000  @ Some delay; adjust according to system clock
short_delay_loop:
    SUBS R5, R5, #1
    BNE short_delay_loop
    BX LR

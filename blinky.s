.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

.global Main

.include "./src/definitions.s"

.section .text
Main:
    MOV R6, #1 @ ; Initialize round counter

    @; Enable GPIOE and GPIOA clocks
    LDR R0, =RCC_AHBENR
    LDR R1, [R0]
    ORR R1, R1, #(1 << RCC_AHBENR_GPIOEEN) @; Enable GPIOE clock
    ORR R1, R1, #(1 << RCC_AHBENR_GPIOAEN) @; Enable GPIOA clock
    STR R1, [R0]

    @; Configure GPIOE pins for output (for LEDs)
    LDR R0, =GPIOE_MODER
    MOV R1, #0x55555555@ ; Set pins 8-15 as output
    STR R1, [R0]

    B game_loop

game_loop:
    MOV R3, #1  @; Start with the first LED
    MOV R7, #10000
    MUL R5, R6, R7
    LDR R4, =DELAY_VALUE
    SUB R4, R4, R5

sequence_loop:
    LSL R2, R3, #8
    LDR R0, =GPIOE_ODR
    STR R2, [R0]  @; Light up the current LED

   @ ; Delay loop
    MOV R5, R4
delay_loop:
    SUBS R5, R5, #1
    BNE delay_loop

   @ ; Check button press
    LDR R0, =GPIOA_IDR
    LDR R1, [R0]
    TST R1, #1
    BNE button_pressed

   @ ; Check if reached LD10
    CMP R3, #25 @ ; Adjust according to your configuration
    BEQ game_over

    @; Move to next LED
    ADD R3, R3, #1
    B sequence_loop

button_pressed:
    ADD R6, R6, #1
    CMP R6, #4
    BEQ final_win
    MOV R3, #1 @ ; Reset to first LED
    B sequence_loop

final_win:
    @; All LEDs turn on with green light if available
    MOV R2, #0x00FF0000  @; Adjust mask for green LEDs
    STR R2, [R0]
    BL long_delay
    B reset_game

game_over:
    MOV R5, #5  @; Flash five times
flash_all_leds:
    LDR R0, =GPIOE_ODR
    MOV R2, #ALL_LEDS_MASK
    STR R2, [R0]  @; Turn all LEDs on
    BL delay
    MOV R2, #0
    STR R2, [R0] @ ; Turn all LEDs off
    BL delay
    SUBS R5, R5, #1
    BNE flash_all_leds

    B reset_game

reset_game:
    LDR R0, =GPIOE_ODR
    MOV R1, #0
    STR R1, [R0]  @; All LEDs off
    MOV R6, #1  @; Reset round counter
    B Main  @; Restart the game

delay:
    LDR R5, =DELAY_VALUE
short_delay_loop:
    SUBS R5, R5, #1
    BNE short_delay_loop
    BX LR

long_delay:
    LDR R5, =300000 @ ; Longer delay value
long_delay_loop:
    SUBS R5, R5, #1
    BNE long_delay_loop
    BX LR

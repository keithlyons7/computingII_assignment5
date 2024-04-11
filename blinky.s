.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

.global Main

@; Include constants and definitions
.include "./src/definitions.s"

.section .text

Main:
    @; Enable GPIOE and GPIOA clocks
    LDR R0, =RCC_AHBENR
    LDR R1, [R0]
    ORR R1, R1, (1 << RCC_AHBENR_GPIOEEN) @; Enable GPIOE clock
    ORR R1, R1, (1 << RCC_AHBENR_GPIOAEN) @; Enable GPIOA clock
    STR R1, [R0]

    @; Configure GPIOE pins for output (for LEDs)
    LDR R0, =GPIOE_MODER
    MOV R1, #0x55555555 @; Set pins 8-15 as output (01 for each pin)
    STR R1, [R0]

    @; Configure GPIOA pin 0 (button) as input, assume it's already input by default

@; Game loop
game_loop:
    MOV R3, #1 @; Starting with the first LED
    MOV R4, #0 @; Reset game won flag

sequence_loop:
    @; Light up the current LED
    LSL R2, R3, #LED_START_PIN @; Calculate LED position
    LDR R0, =GPIOE_ODR
    STR R2, [R0] @; Light up the LED

    @; Delay
    LDR R5, =DELAY_VALUE
delay_loop:
    SUBS R5, R5, #1
    BNE delay_loop

    @; Check if button is pressed
    LDR R0, =GPIOA_IDR
    LDR R1, [R0]
    TST R1, #1 @; Test if button (PA0) is pressed
    BNE button_pressed

    @; Check if we reached the middle LED
    CMP R3, #MIDDLE_LED_VALUE
    BEQ game_over

    @; Move to next LED or loop around
    LSL R3, R3, #1 @; Move to the next LED
    CMP R3, #MAX_LED_VALUE
    BLE sequence_loop

game_over:
    @; Flash all LEDs to indicate loss
    LDR R0, =GPIOE_ODR
    MOV R2, #ALL_LEDS_MASK
    STR R2, [R0] @; Light all LEDs
    @; Add a delay here (not shown for brevity)
    B game_loop

button_pressed:
    @; Logic to handle button press before reaching the middle LED
    MOV R4, #1 @; Set game won flag
    @; Could add logic here for win state
    B game_loop

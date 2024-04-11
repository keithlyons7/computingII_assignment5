@; Constants for game logic
.equ DELAY_VALUE, 100000         @ ; Adjust for suitable speed of LED sequence
.equ ALL_LEDS_MASK, 0xFF00        @; Assuming LEDs are connected to pins 8-15 of GPIOE
.equ MIDDLE_LED_VALUE, 0x0800    @ ; Assuming middle LED is at GPIOE pin 11 (modify as needed)
.equ MAX_LED_VALUE, 0x8000       @ ; Assuming the last LED is on GPIOE pin 15
.equ GPIOE_BASE, 0x48001000      @ ; Base address for GPIOE
.equ GPIOA_BASE, 0x48000000      @ ; Base address for GPIOA
.equ RCC_AHBENR, 0x40021014      @ ; RCC AHB peripheral clock enable register
.equ GPIOE_MODER, GPIOE_BASE + 0x00@ ; GPIOE mode register
.equ GPIOE_ODR, GPIOE_BASE + 0x14 @; GPIOE output data register
.equ GPIOA_IDR, GPIOA_BASE + 0x10 @@; GPIOA input data register

@; Bit positions for enabling GPIOE and GPIOA clock in RCC_AHBENR register
.equ RCC_AHBENR_GPIOEEN, 21
.equ RCC_AHBENR_GPIOAEN, 17

@; Adjust the following values as per your board's specific configuration
.equ BUTTON_PIN, 0               @ ; Assuming the button is connected to GPIOA pin 0
.equ LED_START_PIN, 8            @ ; Assuming LEDs start from GPIOE pin 8
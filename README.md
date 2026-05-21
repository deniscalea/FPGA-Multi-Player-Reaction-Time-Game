Project Overview
This project is a multi-player hardware game implemented on an FPGA development board using VHDL. The core objective of the system is to accurately measure, record, and compare the human reaction times of up to four different players. The game features a randomized stimulus delay, strict fault detection (to prevent cheating by pressing early), and a comprehensive records memory system that tracks each user's best performance across multiple rounds to determine an ultimate winner.

Key Features

Multi-Player Support: Accommodates up to 4 distinct users (U1 through U4).

Multi-Round System: Each player goes through a set of 5 rounds to establish their best reaction time.

True Randomization: Utilizes an LFSR (Linear-Feedback Shift Register) to generate an unpredictable wait time before the stimulus LED turns on, ensuring players cannot anticipate the exact moment.

Fault Detection: Automatically detects and penalizes "false starts" if a player presses the reaction button before the LED lights up.

Smart Memory Management: Independently saves the best (minimum) reaction time for each user.

Dynamic User Management: Players can be skipped or dynamically deleted from the current game session using long-press button mechanics.

Automated Winner Evaluation: Once all active players complete their rounds, the system automatically compares the best scores and displays the overall winner.

Hardware Interface & Controls
The system interacts with the user through the board's push buttons, LEDs, and the 7-segment display.

Displays (7-Segment): Multiplexed display that shows the current user ID, the current round, the live reaction time in milliseconds, and the final winner statistics.

Stimulus LED (LED_SEMNAL): The visual cue that prompts the user to react.

Fault LED (LED_FAULT): Lights up to indicate a false start.

START Button: Initiates the randomized waiting phase for the current round.

REACT Button: The main action button the player must press as quickly as possible once the Stimulus LED turns on.

SKIP Button: Allows bypassing the current user, resetting their round counter, and moving directly to the next available player.

RST Button (Dual-Action): * Short Press: Resets the current user's progress (brings them back to Round 1).

Long Press (> 1 second): Global reset; completely clears the memory and restarts the entire game logic.

BTNL Button (Dual-Action): * Short Press: Cycles through the active users in the post-game records menu.

Long Press (> 1 second): Deletes the currently selected user from the game's memory and automatically jumps to the next available player.

Technical Architecture
The VHDL design is highly modular, governed by a central Execution and Control Unit (UEC_GAME) acting as a Finite State Machine (FSM). Major sub-components include:

Custom Button Controllers: Advanced debouncers combined with timers to distinguish between short presses and long holds.

Frequency Dividers: Downscales the 100MHz system clock to a 1ms tick rate for accurate human-scale timekeeping.

Data Path Modules: Subtractors and comparators to calculate the exact delta between the randomized delay and the user's input.

Records Memory: A register-based memory unit that handles synchronous score saving, user deletion, and asynchronous best-time reading.

Display Controller: Uses the Double Dabble algorithm to convert binary timings into BCD (Binary-Coded Decimal) format, smoothly multiplexing data across 8 seven-segment digits.

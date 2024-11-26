#include <Arduino.h>
//Notes:
//MS1:L, MS2:L, MS3:H 
//RESET->SLEEP (Disable sleep function on driver)


//Driver Selection
#define A4988
//#define TMC2209

//Pinout
#define dirPin 1
#define stepPin 2
#define zeroPin 4 //home switch


#define LEFT 0 // left direction move away from the motor
#define RIGHT 1 // right direction move towards the motor
#define mm *1
#define cm *10
#define inch *25.4

//Config
#define DEFAULT_SPEED 20 //default speed
#define MAX_POSITION 69 mm //maximum position 
//#define STEP_PER_MM 200 mm // const value 200 steps per mm for 1/8 microstep
#define STEP_PER_MM 200 * 8 mm// const value 200 steps per rev for 1/128 microstep

#define FIRST_BIN 0 cm //First Bin's Position 
#define SECOND_BIN 3.8 cm //sec Bin's Position 
#define THIRD_BIN 6.9 cm //third Bin's Position 

//MACRO
#define is_Home analogRead(zeroPin) > 2000


////////////////////////////
// stepper_init
// Initialize the stepper motor, must be called before using the stepper motor
// Author: KH
////////////////////////////
void stepper_init();

////////////////////////////
// stepper_move
// A function to move the stepper motor a certain distance in cm,
// it will use delay function, cannot interrupt.
// Parameters: dir: direction, dis: distance, delay_us: speed (70-1000) smaller is faster
// Author: KH
////////////////////////////
void stepper_move(bool dir, uint32_t dis, uint32_t delay_us);

////////////////////////////
// stepper_move_to (Not tested)
// A function to move to any position,
// it will use delay function, cannot interrupt.
// Parameters: pos: position, delay_us: speed (70-1000) smaller is faster
// Author: KH
////////////////////////////
void stepper_move_to( uint32_t pos, uint32_t delay_us);

////////////////////////////
// STEPPER_ROTATE
// Internal function to rotate the stepper motor a certain steps in a certain direction
// Do not use this function directly.
// Parameters: dir: direction, steps: steps, delay_us: speed 
// Author: KH
////////////////////////////
void STEPPER_ROTATE(bool dir, uint32_t steps, uint32_t delay_us);

////////////////////////////
// STEPPER_HOME (Not tested)
// Internal function to Home the stepper motor. Go back to the zero position.
// Do not use this function directly.
// Return: true if success, false if failed
// Author: KH
////////////////////////////
bool STEPPER_HOME();




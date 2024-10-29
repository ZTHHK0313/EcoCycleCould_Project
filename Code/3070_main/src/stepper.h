#include <Arduino.h>
//Notes:
//MS1:H, MS2:H, MS3:L (1/8 microstep)
//RESET->SLEEP (Disable sleep function on driver)


//Driver Selection
#define A4988
//#define TMC2209

//Pinout
#define dirPin 1
#define stepPin 2
#define zeroPin 42 //home switch

#define LEFT 0 // left direction move away from the motor
#define RIGHT 1 // right direction move towards the motor
#define mm *1
#define cm *10
#define inch *25.4

//Config
#define DEFAULT_SPEED 70 // fastest speed
#define MAX_POSITION 23 cm //maximum position (Not tested)
#define STEP_PER_MM 200 mm // const value 200 steps per mm for 1/8 microstep
#define FIRST_BIN 0 cm //First Bin's Position (Not tested)
#define SECOND_BIN 10 cm //First Bin's Position (Not tested)
#define THIRD_BIN 20 cm //First Bin's Position (Not tested)



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
void stepper_move(bool dir, uint8_t dis, uint8_t delay_us);

////////////////////////////
// stepper_move_to (Not tested)
// A function to move to any position,
// it will use delay function, cannot interrupt.
// Parameters: dir: direction, pos: position, delay_us: speed (70-1000) smaller is faster
// Author: KH
////////////////////////////
void stepper_move_to(bool dir, uint8_t pos, uint8_t delay_us);

////////////////////////////
// STEPPER_ROTATE
// Internal function to rotate the stepper motor a certain steps in a certain direction
// Do not use this function directly.
// Parameters: dir: direction, steps: steps, delay_us: speed 
// Author: KH
////////////////////////////
void STEPPER_ROTATE(bool dir, uint8_t steps, uint8_t delay_us);

////////////////////////////
// STEPPER_HOME (Not tested)
// Internal function to Home the stepper motor. Go back to the zero position.
// Do not use this function directly.
// Author: KH
////////////////////////////
void STEPPER_HOME();




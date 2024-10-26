#include <Arduino.h>

#define dirPin 1
#define stepPin 2
#define zeroPin 42//home switch

#define DEFAULT_SPEED 70 // fastest speed
#define LEFT 0 // left direction move away from the motor
#define RIGHT 1 // right direction move towards the motor
//default is 1/8 microstep
void stepper_init();
void stepper_move_cm(int dir, int cm, int delay_us);


void STEPPER_ROTATE(int dir, int steps, int delay_us);
void STEPPER_HOME();




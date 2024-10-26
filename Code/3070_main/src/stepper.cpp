#include "stepper.h"

void stepper_init() {
    pinMode(stepPin, OUTPUT);
    pinMode(dirPin, OUTPUT);
    pinMode(zeroPin, INPUT);
    STEPPER_HOME();//home 
}

void STEPPER_HOME() {
    //LOW active
    bool ok = false;
    while(!ok){
        if (digitalRead(zeroPin) == LOW){
        STEPPER_ROTATE(LEFT, 500, DEFAULT_SPEED); // move away from the switch first
        }

        while (digitalRead(zeroPin) == LOW) {
            STEPPER_ROTATE(RIGHT, 1, DEFAULT_SPEED);
        }

        STEPPER_ROTATE(LEFT, 50, DEFAULT_SPEED);
        STEPPER_ROTATE(RIGHT, 50, DEFAULT_SPEED);
        if (digitalRead(zeroPin) == LOW) {
            ok = true;
        }
    }
    Serial.println("Homing done");
    
}



void STEPPER_ROTATE(int dir, int steps, int delay_us) {
  digitalWrite(dirPin, dir);
  for (int x = 0; x < steps; x++) {
    digitalWrite(stepPin, HIGH);
    delayMicroseconds(delay_us);
    digitalWrite(stepPin, LOW);
    delayMicroseconds(delay_us);
  }
}

void stepper_move_cm(int dir, int cm, int delay_us) {
  int steps = cm * 2000;
  STEPPER_ROTATE(dir, steps, delay_us);
}


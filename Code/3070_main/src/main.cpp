//Use Control A4988 stepper motor
#include "stepper.h"
#include <Arduino.h>
 
 
void setup() {
  Serial.begin(9600);
  stepper_init();
}
void loop() {
//get serial input
  if (Serial.available() > 0) {
    int dir = Serial.parseInt();
    int dis = Serial.parseInt();
    int delay_us = Serial.parseInt();
    stepper_move(dir, dis, delay_us);
  }
}
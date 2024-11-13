//Use Control A4988 stepper motor
#include "stepper.h"
#include "capacity.h"
#include "smokedetcet.h"
#include "APIServer.h"
#include <Arduino.h>
#include "OLED.h"
#ifndef DATA_H
#define DATA_H
#include "data.h"
#endif

 
void setup() {
  Serial.begin(115200);
//<<<<<<< Updated upstream
card_init();
  // stepper_init();

  // data_init();
  
  // while(!API_Server_init()){
  //   Serial.println("Server failed to start, retrying...");
  // }
  // stepper_init(); //set the stepper to init pos.

}

//=======

void loop() {
test();


//get serial input
  // if (Serial.available() > 0) {
  //   //int dir = Serial.parseInt();
  //   int dis = Serial.parseInt();
  //   int delay_us = Serial.parseInt();
  //   stepper_move_to( dis, delay_us);
  // }
  // gaswarning();
  // DisplayMessage("Welcome!", 1000);
  // DisplayCapacity();
  
  // if (Serial.available() > 0) {
  //   int dir = Serial.parseInt();
  //   int dis = Serial.parseInt();
  //   int delay_us = Serial.parseInt();
  //   stepper_move(dir, dis, delay_us);
  // }
  //gaswarning();s
}
//>>>>>>> Stashed changes

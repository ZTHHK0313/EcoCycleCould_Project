//Use Control A4988 stepper motor
#include "stepper.h"
#include "capacity.h"
#include "smokedetcet.h"
#include "APIServer.h"
#include "servo.h"
#include "OLED.h"
#include <Arduino.h>

#ifndef DATA_H
#define DATA_H
#include "data.h"
#endif


void setup() {
  Serial.begin(115200);
  
//<<<<<<< Updated upstream
//card_init();
  // stepper_init();

  // data_init();
  
  // while(!API_Server_init()){
  //   Serial.println("Server failed to start, retrying...");
  // }
  // stepper_init(); //set the stepper to init pos.

}

//=======


void loop() {
  //Serial.println(RFID_READ());
  if (!myServo.attached()) {
		myServo.setPeriodHertz(50); // standard 50 hz servo
		myServo.attach(8, 1000, 2000); // Attach the servo after it has been detatched
	}

  if (Serial.available() > 0) {
    //int dir = Serial.parseInt();
    int dis = Serial.parseInt();
    myServo.write(dis);
    //myServo.writeTicks(dis);
  }


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

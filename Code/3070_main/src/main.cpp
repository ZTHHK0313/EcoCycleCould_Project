//Use Control A4988 stepper motor
#include "stepper.h"
#include "capacity.h"
#include "smokedetcet.h"
#include "APIServer.h"
#include <Arduino.h>
#ifndef DATA_H
#define DATA_H
#include "data.h"
#endif

 
void setup() {
  Serial.begin(115200);
<<<<<<< Updated upstream
  //stepper_init();

  data_init();
  while(!API_Server_init()){
    Serial.println("Server failed to start, retrying...");
  }
}
void loop() {
  // if (Serial.available() > 0) {
  //   int dir = Serial.parseInt();
  //   int dis = Serial.parseInt();
  //   int delay_us = Serial.parseInt();
  //   stepper_move(dir, dis, delay_us);
  // }
  //gaswarning();s


}



=======
  stepper_init();

}
void loop() {
//get serial input
  if (Serial.available() > 0) {
    //int dir = Serial.parseInt();
    int dis = Serial.parseInt();
    int delay_us = Serial.parseInt();
    stepper_move_to( dis, delay_us);
  }
}
>>>>>>> Stashed changes

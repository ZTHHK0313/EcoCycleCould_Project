//Use Control A4988 stepper motor
#include "stepper.h"
#include "smokedetcet.h"
#include "APIServer.h"
#include "OLED.h"
#include <ESP32Servo.h>
#include <Arduino.h>


#ifndef DATA_H
#define DATA_H
#include "data.h"
#endif

#define SERVO_1_PIN 9
#define SERVO_2_PIN 8
#define LEFT 0
#define RIGHT 1

Servo servo1;
Servo servo2;
int card_id = -1;
User* user = nullptr;

TaskHandle_t Task1Handle = NULL;


int Classify_Bin = 0;
void servo_init() {
    ESP32PWM::allocateTimer(0);
    ESP32PWM::allocateTimer(1);
    ESP32PWM::allocateTimer(2);
    ESP32PWM::allocateTimer(3);
    servo1.setPeriodHertz(50); // standard 50 hz servo
    servo2.setPeriodHertz(50); // standard 50 hz servo
    servo1.attach(SERVO_1_PIN,1000,2000);
    servo2.attach(SERVO_2_PIN,1000,2000);

    
}
void servo_move_ms(Servo& servo, int speed, bool direction,int delay_ms) {
    int angle = direction ? 1 : -1;
    servo.write(90+angle*speed);
    delay(delay_ms);
    servo.write(90);
}



void setup() {
  pinMode(12,INPUT);
  Serial.begin(115200);
  Serial.println("Start");
  data_init();

  while(!API_Server_init()){
    Serial.println("Server failed to start, retrying...");
  }
  card_init();
  servo_init();
  stepper_init();
  //initOLED();

  showMessageMiddle("Welcome!");

  
  xTaskCreatePinnedToCore(
      gaswarning,            // Task function
      "Task1",          // 任务名称
      4096,             // 堆栈大小（字节）
      NULL,             // 参数传递
      1,                // 优先级
      &Task1Handle,     // 任务句柄
      1                 // 运行在 Core 0
  );
  Serial.println("Task1 created");



//<<<<<<< Updated upstream
  // stepper_init(); //set the stepper to init pos.

}

//=======

void step1(){
  //get the card id
  Serial.println("waiting for card");
  showMessageMiddle("Scan your card");
  card_id = RFID_READ();

  //find the user
  user = find_user_by_id(card_id);


  //if the user is not found ,new one
  if(user == nullptr){
    Serial.println("new user");
    users.push_back(User(to_string(users.size()+1),card_id,100));
    user = &users[users.size()-1];
  }

  //display the user info
  showMessageMiddle(user->name.c_str());
}

void step2(){
  //move to the first bin
  stepper_move_to(MAX_POSITION, DEFAULT_SPEED);
  delay(3000);
  //open first servo door
  servo_move_ms(servo1, 80, RIGHT, 1100);
  //wait the second card
  showMessageMiddle("Scan the card to close");
  RFID_READ();
  //close the first servo door
  servo_move_ms(servo1, 80, LEFT, 1100);
  //move to the camera
  stepper_move_to(0, DEFAULT_SPEED);
}

void step3(){
  //wait Classify
  delay(5000);
  Classify_Bin = 0;
  while(Classify_Bin == 0){
    Serial.println("waiting for classify");
    showMessageMiddle("waiting for classify");
    delay(100);
  }

  switch (Classify_Bin)
  {
  case 1: 
    stepper_move_to(FIRST_BIN, DEFAULT_SPEED);
    user->interactions.push_back({User::Paper, 10});
    showMessageMiddle("Paper");
    break;
  case 2:
    stepper_move_to(SECOND_BIN, DEFAULT_SPEED);
    user->interactions.push_back({User::Plastic, 10});
    showMessageMiddle("Plastic");
    break;
  case 3:
    stepper_move_to(THIRD_BIN, DEFAULT_SPEED);
    user->interactions.push_back({User::Metal, 10});
    showMessageMiddle("Metal");
    break;
  }
  delay(3000);
  //open the second servo door
  servo_move_ms(servo2, 80, LEFT, 1600);
  delay(3000);
  //close the second servo door
  servo_move_ms(servo2, 80, RIGHT, 1600);
  card_id = -1;
}



void loop() {
  
  //test();
  step1();
  step2();
  step3();




  //Serial.println(RFID_READ());
  // if (Serial.available() > 0) {
  //   //int dir = Serial.parseInt();
  //   //servo 1      open: speed 80, delay 1100
  //   //servo 2      open: speed 80, delay 1600 
  //   int delay = Serial.parseInt();
  //   servo_move_ms(servo1, 80, LEFT, delay);
  // }



//get serial input
  // if (Serial.available() > 0) {
  //   //int dir = Serial.parseInt();
  //   int dis = Serial.parseInt();
  //   int delay_us = DEFAULT_SPEED;
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

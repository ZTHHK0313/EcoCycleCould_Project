#include <ESP32Servo.h>

#define SERVO_1_PIN 9
#define SERVO_2_PIN 8

 Servo servo1;
Servo servo2;

void servo_init() {
    ESP32PWM::allocateTimer(0);
    ESP32PWM::allocateTimer(1);
    ESP32PWM::allocateTimer(2);
    ESP32PWM::allocateTimer(3);
    servo1.attach(SERVO_1_PIN);
    servo2.attach(SERVO_2_PIN);
}
#define LEFT 0
#define RIGHT 1

void servo_move_ms(Servo& servo, int speed, bool direction,int delay_ms);
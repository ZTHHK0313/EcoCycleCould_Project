#include "servo.h"

void servo_move_ms(Servo& servo, int speed, bool direction,int delay_ms) {
    int angle = direction ? 1 : -1;
    servo.write(90+angle*speed);
    delay(delay_ms);
    servo.write(90);
}
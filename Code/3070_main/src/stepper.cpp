#include "stepper.h"
#include <Arduino.h>

int Current_Postion = 0 mm;


void stepper_init() {
    pinMode(stepPin, OUTPUT);
    pinMode(dirPin, OUTPUT);
    pinMode(zeroPin, INPUT);
    if(!STEPPER_HOME()){
        while(1){
            Serial.println("ERROR_1");
        }
    } 
}

bool STEPPER_HOME() {
    //HIGH active
    if(is_Home){
        STEPPER_ROTATE(RIGHT, 15000, DEFAULT_SPEED);
        if(is_Home){
            return false;
        }
    }

    while(1){
        STEPPER_ROTATE(LEFT, 1, DEFAULT_SPEED);
        if (is_Home) {
            break;
        }
    }
    Serial.println("Homing done");
    return true;
}

void stepper_move_to(uint32_t pos, uint32_t delay_us){
    int temp = Current_Postion - (int)pos;
    if(temp > 0){
        temp = abs(temp);
        stepper_move(LEFT, temp, delay_us);
    }else{
        temp = abs(temp);
        stepper_move(RIGHT, temp, delay_us);
    }
}



void STEPPER_ROTATE(bool dir, uint32_t steps, uint32_t delay_us) {

    digitalWrite(dirPin, dir);
    for (uint32_t _ = 0; _ < steps; _++) {
        digitalWrite(stepPin, HIGH);
        delayMicroseconds(delay_us);
        digitalWrite(stepPin, LOW);
        delayMicroseconds(delay_us);
    }
}

void stepper_move(bool dir, uint32_t dis, uint32_t delay_us) {
    if(Current_Postion + dir * dis > MAX_POSITION){
        Serial.println("Movement out of range");
        return;
    }
    if (dir == false && (Current_Postion - (int)dis < 0)){
        
        Serial.println("Movement out of range");
        return;
    }
    

    uint32_t steps = dis * STEP_PER_MM;
    STEPPER_ROTATE(dir, steps, delay_us);// Move
    Current_Postion += dir == LEFT ? -dis : dis;//update Pos
    Serial.print("Current Position: "); Serial.println(Current_Postion);

}


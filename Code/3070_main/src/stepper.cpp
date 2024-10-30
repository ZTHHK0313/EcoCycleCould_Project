#include "stepper.h"

int8_t Current_Postion = 0 mm;
bool is_Home = true;


void stepper_init() {
    pinMode(stepPin, OUTPUT);
    pinMode(dirPin, OUTPUT);
    pinMode(zeroPin, INPUT);
    //STEPPER_HOME();//home 
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
    is_Home = true;
    Serial.println("Homing done");
    
    
}

void stepper_move_to(bool dir, uint32_t pos, uint32_t delay_us){
    int8_t temp = Current_Postion - pos;
    if(temp > 0){
        stepper_move(LEFT, temp, delay_us);
    }else{
        stepper_move(RIGHT, temp, delay_us);
    }
}



void STEPPER_ROTATE(bool dir, uint32_t steps, uint32_t delay_us) {
    if(!is_Home){
        Serial.println("Must Home First");
        return;
    }
    
    digitalWrite(dirPin, dir);
    for (uint32_t _ = 0; _ < steps; _++) {
        //Serial.println(_);
        digitalWrite(stepPin, HIGH);
        delayMicroseconds(delay_us);
        digitalWrite(stepPin, LOW);
        delayMicroseconds(delay_us);
    }
}

void stepper_move(bool dir, uint32_t dis, uint32_t delay_us) {

    // if(Current_Postion + dir * dis < 0 || Current_Postion + dir * dis > MAX_POSITION){
    //     Serial.println("Movement out of range");
    //     return;
    // }

    uint32_t steps = dis * STEP_PER_MM;
    STEPPER_ROTATE(dir, steps, delay_us);// Move
    Current_Postion += dir == LEFT ? dis : -dis;//update Pos

}


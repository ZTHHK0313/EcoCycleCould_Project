#include "smokedetcet.h"
#include <Arduino.h>
#include "OLED.h"

int gaspresent = 0;
bool warningsignal = 0; 


void gaswarning(void *pvParameters) {
    while (1) {
        UBaseType_t stackHighWaterMark = uxTaskGetStackHighWaterMark(NULL);
        Serial.print("Remaining Stack: ");
        Serial.println(stackHighWaterMark);

        gaspresent = map(gasvalue, 0, 4095, 0, 100);
        
        Serial.println(gaspresent);

        if (gaspresent >= 5) {
            warningsignal = 1;
            showMessageMiddle("Gas Detected");
        } else {
            warningsignal = 0;
        }

        vTaskDelay(1000 / portTICK_PERIOD_MS);
    }
}

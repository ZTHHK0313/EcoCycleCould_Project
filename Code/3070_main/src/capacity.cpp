#include <Arduino.h>
#include "capacity.h"
int scaledValue = 0;

void dectectcap() {
    // Read the analog value from the photoresistor
    int sensorValue = analogRead(photoResistorPin);

    // Map the sensor value to a scale of 0 to 100
    scaledValue = map(sensorValue, 0, adcMaxValue, 0, 100);

    // Invert the value so 0 is lightest and 100 is darkest
    scaledValue = 100 - scaledValue;


    delay(1000);  // Wait for a second before the next reading
}
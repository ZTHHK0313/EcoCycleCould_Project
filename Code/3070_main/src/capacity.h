#include <SPI.h> 
#include <Wire.h> 
#include <Adafruit_GFX.h> 
#include <Adafruit_SSD1306.h>

#define FULL_CAP 100 // Full capacity of the bin
const int ldrPins[] = {A0, A1, A2};
float getLDRPercentage(int pin); //Display LDR light storng from 0 to 100

#include <SPI.h> 
#include <Wire.h> 
#include <Adafruit_GFX.h> 
#include <Adafruit_SSD1306.h>

#define SS_PIN 53
#define RST_PIN 5
#define SCREEN_WIDTH 128  
#define SCREEN_HEIGHT 64  
#define OLED_RESET -1 
const int ldrPins[] = {A0, A1, A2};
float getLDRPercentage(int pin);
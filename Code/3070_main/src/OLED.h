#include <SPI.h>
#include <MFRC522.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Wire.h>

#ifndef CARD_DEF
    #include "card_and_servo_setting.h"
    #define CARD_DEF
#endif


#define SCREEN_WIDTH 128  
#define SCREEN_HEIGHT 64  
#define OLED_RESET -1     
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);
void displayCardInfo(int index,Card cards);// display Card Info to OLED
void DisplayMessage(const char *message, int duration); //just display message with duration ms.
void classifyResult(int wcase); //input 1,2,3 ,output type with no1,2,3 to OLED
void DisplayCapacity();// display LDRcapacity 到OLED
void Display_GasWarning(); //Diaply GasWarning text to LED

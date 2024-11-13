#include <SPI.h>
#include <MFRC522.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Wire.h>


#define SCREEN_WIDTH 128  
#define SCREEN_HEIGHT 64  
#define OLED_RESET -1     

void displayCardInfo(int index,void* cards);// display Card Info to OLED
void DisplayMessage(const char *message, int duration); //just display message with duration ms.
void classifyResult(int wcase); //input 1,2,3 ,output type with no1,2,3 to OLED
void DisplayCapacity();// display LDRcapacity 到OLED
void Display_GasWarning(); //Diaply GasWarning text to LED
void Testing_display();

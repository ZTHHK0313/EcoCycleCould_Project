#include <SPI.h>
#include <MFRC522.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Wire.h>
const float fullCapacity = 90.0; // testing

#define SS_PIN 53 //RFID PIN
#define RST_PIN 5 //RFID PIN


#define MAX_CARDS 10
#define SERVO_PIN 9 
struct Card {
  int id;
  byte uid[4];
  int count;
};


void printUID(byte *uid); //print UID到監控台
void DisplayCapacity(); // display capacity 到OLED
int searchCardByUID(byte uid[4]); //在database尋找UID有沒有對應的card
bool addCard(int id, byte uid[4]); //
int wasteClassify(); // testing
void displayCardInfo(int index);
void classifyResult(int wcase);
void DisplayMessage(const char *message, int duration);



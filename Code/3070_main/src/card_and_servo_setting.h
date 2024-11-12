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
int searchCardByUID(byte uid[4]); //在database尋找UID有沒有對應的card
bool addCard(int id, byte uid[4]); //加card ID
int wasteClassify(); // testing, just inculde classifyResult() and hold the process of wasteClassify.
void moveCoverServo(); // **missing code of this function!** 
void updateBinCapacity(int wcase); // **missing code of this function!** 


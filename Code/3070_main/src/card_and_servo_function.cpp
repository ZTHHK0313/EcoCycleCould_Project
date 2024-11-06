#include <SPI.h>
#include <MFRC522.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Wire.h>
#include <Servo.h>
#include "card_and_servo_setting.h"

Servo coverServo;  // Create a servo object

struct Card {
  int id;
  byte uid[4];
  int count;
};

int curr_cards = 0;  
Card cards[MAX_CARDS];  

byte scannedUID[4];  
MFRC522 rfid(SS_PIN, RST_PIN);

void printUID(byte *uid);
void DisplayCapacity();
int searchCardByUID(byte uid[4]);
bool addCard(int id, byte uid[4]);
int wasteClassify();
void moveCoverServo();
void updateBinCapacity(int wcase);
void displayCardInfo(int index);
void classifyResult(int wcase);
void DisplayMessage(const char *message, int duration);

void setup() {
  Serial.begin(9600);
  SPI.begin();
  rfid.PCD_Init();  

  if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
    Serial.println(F("SSD1306 allocation failed"));
    for (;;);
  }
  display.clearDisplay();
  display.display();

  coverServo.attach(SERVO_PIN);  // Attach the servo to the defined pin
  coverServo.write(0);  // Set initial servo position to 0 degrees

  DisplayCapacity();
}

void loop() {
  if (!rfid.PICC_IsNewCardPresent() || !rfid.PICC_ReadCardSerial()) {
    return;
  }

  memcpy(scannedUID, rfid.uid.uidByte, 4);
  printUID(scannedUID);  

  moveCoverServo();  // Always open the cover when a card is detected

  int cardIndex = searchCardByUID(scannedUID);
  if (cardIndex == -1) {
    addCard(curr_cards + 1, scannedUID);
  } else {
    int result = wasteClassify(); // Capture the classification result

    if (result != 0) {
      cards[cardIndex].count++;
      updateBinCapacity(result);
      displayCardInfo(cardIndex);
    }
  }

  rfid.PICC_HaltA();
  rfid.PCD_StopCrypto1();
  DisplayCapacity();
}

void printUID(byte *uid) {
  for (byte i = 0; i < 4; i++) {
    Serial.print(uid[i], DEC);
    if (i != 3) Serial.print(", ");
  }
  Serial.println();
}

bool addCard(int id, byte uid[4]) {
  if (curr_cards >= MAX_CARDS) {  
    DisplayMessage("Error: Card DB Full", 2000);
    return false;
  }

  memcpy(cards[curr_cards].uid, uid, 4);  
  cards[curr_cards].id = id;
  cards[curr_cards].count = 1;  
  
  int result = wasteClassify();
  if (result != 0){
    updateBinCapacity(result);
    displayCardInfo(curr_cards);
    curr_cards++;
    return true;
  }
  return false;
}

int searchCardByUID(byte uid[4]) {
  for (int i = 0; i < curr_cards; i++) {
    if (memcmp(uid, cards[i].uid, 4) == 0) return i;
  }
  return -1;  
}

float canPercentage = 0;   // testing
float plasticPercentage = 0;  // testing
float paperPercentage = 100;  // testing

void updateBinCapacity(int wcase) {
  float increase = 5.0;

  if (wcase == 1) {
    canPercentage += increase;
  } else if (wcase == 2) {
    plasticPercentage += increase;
  } else if (wcase == 3) {
    paperPercentage += increase;
  }
}

const float fullCapacity = 90.0;

void moveCoverServo() {
  coverServo.write(90);  // Move the servo to 90 degrees
  DisplayMessage("Cover is opened", 3000);  
  delay(1000);
  coverServo.write(0);   // Return the servo to 0 degrees
}

int wcase = 3; // testing
int wasteClassify() { // testing
  DisplayMessage("Analyzing...", 2000);

  classifyResult(wcase);

  if (wcase == 1 || wcase == 2 || wcase == 3) {
    return wcase;
  } else {
    return 0;
  }
}
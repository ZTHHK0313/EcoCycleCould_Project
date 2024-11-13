#ifndef CARD_DEF
    #include "card_and_servo_setting.h"
    #define CARD_DEF
#endif



int curr_cards = 0;  
Card cards[MAX_CARDS];  

byte scannedUID[4];  
MFRC522 rfid(SS_PIN, RST_PIN);

void printUID(byte *uid);
int searchCardByUID(byte uid[4]);
bool addCard(int id, byte uid[4]);
int wasteClassify();
void moveCoverServo();
void updateBinCapacity(int wcase);
void displayCardInfo(int index);
void classifyResult(int wcase);
void DisplayMessage(const char *message, int duration);
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


int wcase = 3; // testing
int wasteClassify() { // testing
  DisplayMessage("Analyzing...", 2000);

  classifyResult(wcase); //suggest to replace the wcase with AI classify function. 

  if (wcase == 1 || wcase == 2 || wcase == 3) {
    return wcase;
  } else {
    return 0;
  }
}
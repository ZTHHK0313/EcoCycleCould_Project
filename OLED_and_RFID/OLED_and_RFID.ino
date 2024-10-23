// #include <SPI.h>
// #include <MFRC522.h>
// #include <Adafruit_GFX.h>
// #include <Adafruit_SSD1306.h>
// #include <Wire.h>
// #include <Servo.h>  // Include the Servo library

// #define SS_PIN 53
// #define RST_PIN 5
// #define SCREEN_WIDTH 128  
// #define SCREEN_HEIGHT 64  
// #define OLED_RESET -1     
// Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

// #define MAX_CARDS 10
// #define SERVO_PIN 9   // Define the pin where the servo is connected

// Servo coverServo;  // Create a servo object

// struct Card {
//   int id;
//   byte uid[4];
//   int count;
// };

// int curr_cards = 0;  
// Card cards[MAX_CARDS];  

// byte validUIDs[][4] = {
//   {99, 178, 2, 49},
//   {4, 80, 57, 162},
//   {77, 11, 239, 176},
// };

// const int numValidUIDs = sizeof(validUIDs) / sizeof(validUIDs[0]);  
// byte scannedUID[4];  
// MFRC522 rfid(SS_PIN, RST_PIN);

// void setup() {
//   Serial.begin(9600);
//   SPI.begin();
//   rfid.PCD_Init();  

//   if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
//     Serial.println(F("SSD1306 allocation failed"));
//     for (;;);
//   }
//   display.clearDisplay();
//   display.display();

//   coverServo.attach(SERVO_PIN);  // Attach the servo to the defined pin
//   coverServo.write(0);  // Set initial servo position to 0 degrees

//   DisplayCapacity();
// }

// void loop() {
//   if (!rfid.PICC_IsNewCardPresent() || !rfid.PICC_ReadCardSerial()) {
//     return;
//   }

//   memcpy(scannedUID, rfid.uid.uidByte, 4);
//   printUID(scannedUID);  

//   if (isValidUID(scannedUID)) {
//     int cardIndex = searchCardByUID(scannedUID);
//     if (cardIndex == -1) {
//       addCard(curr_cards + 1, scannedUID);
//     } else {
//       moveCoverServo();
//       int result = wasteClassify(); // Capture the classification result

//       // Only increment the count and display info if waste is recognized
//       if (result != 0) {
//         cards[cardIndex].count++;
//         updateBinCapacity(result); // Update the bin capacity based on the classification result
//         displayCardInfo(cardIndex);
//       }
//     }
//   } else {
//     DisplayMessage("Invalid Card", 2000);  
//   }

//   rfid.PICC_HaltA();
//   rfid.PCD_StopCrypto1();
//   DisplayCapacity();
// }


// void printUID(byte *uid) {
//   for (byte i = 0; i < 4; i++) {
//     Serial.print(uid[i], DEC);
//     if (i != 3) Serial.print(", ");
//   }
//   Serial.println();
// }

// bool addCard(int id, byte uid[4]) {
//   if (curr_cards >= MAX_CARDS) {  // Changed to >=
//     DisplayMessage("Error: Card DB Full", 2000);
//     return false;
//   }

//   memcpy(cards[curr_cards].uid, uid, 4);  
//   cards[curr_cards].id = id;
//   cards[curr_cards].count = 1;  
  
//   moveCoverServo();
//   int result = wasteClassify();
//   if (result != 0){
//     updateBinCapacity(result); // Update the bin capacity based on the classification result
//     displayCardInfo(curr_cards);
//     curr_cards++;
//     return true;
//   }
//   // wasteClassify();


//   // displayCardInfo(curr_cards);  // Moved this below to show the correct card info
//   // curr_cards++;  
//   // return true;
// }

// bool isValidUID(byte *uid) {
//   for (int i = 0; i < numValidUIDs; i++) {
//     if (memcmp(uid, validUIDs[i], 4) == 0) return true;  // Simplified
//   }
//   return false;
// }

// int searchCardByUID(byte uid[4]) {
//   for (int i = 0; i < curr_cards; i++) {
//     if (memcmp(uid, cards[i].uid, 4) == 0) return i;  // Using memcmp
//   }
//   return -1;  
// }

// void displayCardInfo(int index) {
//   display.clearDisplay();
//   display.setTextSize(1);
//   display.setTextColor(SSD1306_WHITE);
//   display.setCursor(0, 10);
//   display.print("Registered ID: ");
//   display.println(cards[index].id);
//   display.print("Points: ");
//   display.println(cards[index].count);
//   display.display();
//   delay(1000);
// }

// void DisplayMessage(const char *message, int duration) {
//   display.clearDisplay();
//   display.setTextSize(1);
//   display.setTextColor(SSD1306_WHITE);
//   display.setCursor(0, 10);
//   display.println(message);
//   display.display();
//   delay(duration);
// }

// void moveCoverServo() {
//   coverServo.write(90);  // Move the servo to 90 degrees
//   DisplayMessage("Cover is opened", 3000);  
//   delay(1000);
//   coverServo.write(0);   // Return the servo to 0 degrees
// }

// int wcase = 4; // testing
// int wasteClassify() {
//   DisplayMessage("Analyzing...", 2000);

//   // Simulate classification (replace with actual logic later)
//   classifyResult(wcase);

//   // Return 0 for unrecognized waste, or the corresponding bin number
//   if (wcase == 1 || wcase == 2 || wcase == 3) {
//     return wcase;
//   } else {
//     return 0; // Indicating unrecognized waste
//   }
// }




// void classifyResult(int wcase) {
//   display.clearDisplay();
//   display.setTextSize(1);
//   display.setTextColor(SSD1306_WHITE);
//   display.setCursor(0, 10);

//   if (wcase == 1) {
//     display.println("Waste has entered:");
//     display.println("Can recycling bin");
//   } else if (wcase == 2) {
//     display.println("Waste has entered:");
//     display.println("Plastic recycling bin");
//   } else if (wcase == 3) {
//     display.println("Waste has entered:");
//     display.println("Paper recycling bin");
//   } else {
//     display.println("Unrecognized Waste");
//     display.println("Please take back the waste");
//   }
//   display.display();
//   delay(2000);

//   // Only move the servo for unrecognized waste
//   if (wcase != 1 && wcase != 2 && wcase != 3) {
//     moveCoverServo();
//   }
// }

// float canPercentage = 0;   // testing
// float plasticPercentage = 0;  // testing
// float paperPercentage = 0;  // testing

// void updateBinCapacity(int wcase) {
//   // Assuming each addition reduces available capacity by a fixed percentage
//   float increase = 5.0;  // For example, every time a bin is used, it decreases by 5%

//   if (wcase == 1 && canPercentage > 0) {
//     canPercentage += increase;

//   } else if (wcase == 2 && plasticPercentage > 0) {
//     plasticPercentage += increase;

//   } else if (wcase == 3 && paperPercentage > 0) {
//     paperPercentage += increase;

//   }
// }


// const float fullCapacity = 90.0;
// void DisplayCapacity() {
//   display.clearDisplay();
//   display.setTextSize(1);
//   display.setTextColor(SSD1306_WHITE);
//   display.setCursor(0, 10);

//   display.println("Occupied Capacity:");
//   display.print("Can: ");
//   display.println(canPercentage < fullCapacity ? String(canPercentage) + "%" : "FULL");

//   display.print("Plastic: ");
//   display.println(plasticPercentage < fullCapacity ? String(plasticPercentage) + "%" : "FULL");

//   display.print("Paper: ");
//   display.println(paperPercentage < fullCapacity ? String(paperPercentage) + "%" : "FULL");

//   display.display();
// }

#include <SPI.h>
#include <MFRC522.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Wire.h>
#include <Servo.h>  // Include the Servo library

#define SS_PIN 53
#define RST_PIN 5
#define SCREEN_WIDTH 128  
#define SCREEN_HEIGHT 64  
#define OLED_RESET -1     
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

#define MAX_CARDS 10
#define SERVO_PIN 9   // Define the pin where the servo is connected

Servo coverServo;  // Create a servo object

struct Card {
  int id;
  byte uid[4];
  int count;
};

int curr_cards = 0;  
Card cards[MAX_CARDS];  

byte validUIDs[][4] = {
  {99, 178, 2, 49},
  {4, 80, 57, 162},
  {77, 11, 239, 176},
};

const int numValidUIDs = sizeof(validUIDs) / sizeof(validUIDs[0]);  
byte scannedUID[4];  
MFRC522 rfid(SS_PIN, RST_PIN);

float canPercentage = 60.0;   // Starting at 60% full
float plasticPercentage = 30.0;  // Starting at 30% full
float paperPercentage = 50.0;  // Starting at 50% full

const float fullCapacity = 90.0;  // Threshold for FULL bin

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

  if (isValidUID(scannedUID)) {
    int cardIndex = searchCardByUID(scannedUID);
    if (cardIndex == -1) {
      addCard(curr_cards + 1, scannedUID);
    } else {
      int result = wasteClassify(); // Capture the classification result

      // Only increment the count and display info if waste is recognized
      if (result != 0) {
        moveCoverServo();  // Move servo here based on valid card and result
        cards[cardIndex].count++;
        updateBinCapacity(result); // Update the bin capacity based on the classification result
        displayCardInfo(cardIndex);
      }
    }
  } else {
    DisplayMessage("Invalid Card", 2000);  
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
  if (curr_cards >= MAX_CARDS) {  // Changed to >=
    DisplayMessage("Error: Card DB Full", 2000);
    return false;
  }

  memcpy(cards[curr_cards].uid, uid, 4);  
  cards[curr_cards].id = id;
  cards[curr_cards].count = 1;  
  
  int result = wasteClassify();
  if (result != 0){
    moveCoverServo(); // Move servo here based on valid card and result
    updateBinCapacity(result); // Update the bin capacity based on the classification result
    displayCardInfo(curr_cards);
    curr_cards++;
    return true;
  }
  return false;
}

bool isValidUID(byte *uid) {
  for (int i = 0; i < numValidUIDs; i++) {
    if (memcmp(uid, validUIDs[i], 4) == 0) return true;  // Simplified
  }
  return false;
}

int searchCardByUID(byte uid[4]) {
  for (int i = 0; i < curr_cards; i++) {
    if (memcmp(uid, cards[i].uid, 4) == 0) return i;  // Using memcmp
  }
  return -1;  
}

void displayCardInfo(int index) {
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(SSD1306_WHITE);
  display.setCursor(0, 10);
  display.print("Registered ID: ");
  display.println(cards[index].id);
  display.print("Points: ");
  display.println(cards[index].count);
  display.display();
  delay(1000);
}

void DisplayMessage(const char *message, int duration) {
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(SSD1306_WHITE);
  display.setCursor(0, 10);
  display.println(message);
  display.display();
  delay(duration);
}

void moveCoverServo() {
  coverServo.write(90);  // Move the servo to 90 degrees
  DisplayMessage("Cover is opened", 3000);  
  delay(1000);
  coverServo.write(0);   // Return the servo to 0 degrees
}

int wcase = 3; // testing
int wasteClassify() {
  DisplayMessage("Analyzing...", 2000);

  // Simulate classification (replace with actual logic later)
  classifyResult(wcase);

  // Return 0 for unrecognized waste, or the corresponding bin number
  if (wcase == 1 || wcase == 2 || wcase == 3) {
    return wcase;
  } else {
    return 0; // Indicating unrecognized waste
  }
}

void classifyResult(int wcase) {
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(SSD1306_WHITE);
  display.setCursor(0, 10);

  if (wcase == 1) {
    display.println("Waste has entered:");
    display.println("Can recycling bin");
  } else if (wcase == 2) {
    display.println("Waste has entered:");
    display.println("Plastic recycling bin");
  } else if (wcase == 3) {
    display.println("Waste has entered:");
    display.println("Paper recycling bin");
  } else {
    display.println("Unrecognized Waste");
    display.println("Please take back the waste");
  }
  display.display();
  delay(2000);

  // Only move the servo for unrecognized waste
  if (wcase != 1 && wcase != 2 && wcase != 3) {
    moveCoverServo();
  }
}

void updateBinCapacity(int wcase) {
  // Assuming each addition increases capacity by a fixed percentage
  float increase = 5.0;  // For example, every time a bin is used, capacity increases by 5%

  if (wcase == 1) {
    if (canPercentage >= fullCapacity) {
      DisplayMessage("Can Bin Full! Cannot accept waste", 2000);  // Show message if full
      return;  // Do not accept waste if bin is full
    }
    canPercentage += increase;
    if (canPercentage > 100) canPercentage = 100;  // Cap at 100%
  } else if (wcase == 2) {
    if (plasticPercentage >= fullCapacity) {
      DisplayMessage("Plastic Bin Full! Cannot accept waste", 2000);  // Show message if full
      return;  // Do not accept waste if bin is full
    }
    plasticPercentage += increase;
    if (plasticPercentage > 100) plasticPercentage = 100;  // Cap at 100%
  } else if (wcase == 3) {
    if (paperPercentage >= fullCapacity) {
      DisplayMessage("Paper Bin Full! Cannot accept waste", 2000);  // Show message if full
      return;  // Do not accept waste if bin is full
    }
    paperPercentage += increase;
    if (paperPercentage > 100) paperPercentage = 100;  // Cap at 100%
  }
}

void DisplayCapacity() {
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(SSD1306_WHITE);
  display.setCursor(0, 10);

  display.println("Occupied Capacity:");
  display.print("Can: ");
  display.println(canPercentage < fullCapacity ? String(canPercentage) + "%" : "FULL");

  display.print("Plastic: ");
  display.println(plasticPercentage < fullCapacity ? String(plasticPercentage) + "%" : "FULL");

  display.print("Paper: ");
  display.println(paperPercentage < fullCapacity ? String(paperPercentage) + "%" : "FULL");

  display.display();
}

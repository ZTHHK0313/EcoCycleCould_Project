#include "capacity.h"

float getLDRPercentage(int pin) {
  int ldrValue = analogRead(pin);
  // Assuming the range is 0 to 1023, map it to a percentage (0 to 100%)
  float percentage = (ldrValue / 1023.0) * 100;
  return percentage;
}


void DisplayCapacity() {
  
  bool isFull[] = {false, false, false};

  // Read values from all LDRs and calculate percentages
  float canPercentage = getLDRPercentage(ldrPins[0]);
  float plasticPercentage = getLDRPercentage(ldrPins[1]);
  float paperPercentage = getLDRPercentage(ldrPins[2]);

  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(SSD1306_WHITE);
  display.setCursor(0, 10);

  display.println("Occupied Capacity:");

  if (canPercentage < fullCapacity) {
    display.println("Can: FULL");
  } else {
    display.println("Can: Available");
  }

  if (plasticPercentage < fullCapacity) {
    display.println("Plastic: FULL");
  } else {
    display.println("Plastic: Available");
  }

  if (paperPercentage < fullCapacity) {
    display.println("Paper: FULL");
  } else {
    display.println("Paper: Available");
  }

  display.display();
}

// testing
// float getLDRPercentage(int pin) {
//   int ldrValue = analogRead(pin);
//   // Assuming the range is 0 to 1023, map it to a percentage (0 to 100%)
//   float percentage = ldrValue;
//   return percentage;
// }
// void DisplayCapacity() {
  
//   bool isFull[] = {false, false, false};

//   // Read values from all LDRs and calculate percentages
//   float canPercentage = getLDRPercentage(ldrPins[0]);
//   float plasticPercentage = getLDRPercentage(ldrPins[1]);
//   float paperPercentage = getLDRPercentage(ldrPins[2]);

//   display.clearDisplay();
//   display.setTextSize(1);
//   display.setTextColor(SSD1306_WHITE);
//   display.setCursor(0, 10);

//   display.println("Occupied Capacity:");

//   display.print("Can: ");
//   display.println(String(canPercentage) + "%");

//       display.print("Plastic: ");
//     display.println(String(plasticPercentage) + "%");

//     display.print("Paper: ");
//     display.println(String(paperPercentage) + "%");

  
//   display.display();
// }

// void setup() {
//   Serial.begin(9600);
//   SPI.begin();  

//   if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
//     Serial.println(F("SSD1306 allocation failed"));
//     for (;;);
//   }
//   display.clearDisplay();
//   display.display(); 
//   DisplayCapacity();
// }

// void loop() {
//   DisplayCapacity();
// }


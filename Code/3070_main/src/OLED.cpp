#include <SPI.h>
#include <MFRC522.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Wire.h>
#include <Servo.h>

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
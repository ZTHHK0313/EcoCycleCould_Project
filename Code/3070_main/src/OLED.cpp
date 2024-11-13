#include "OLED.h"
#include "capacity.h"
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);


void displayCardInfo(int index,void* cards) {
  // display.clearDisplay();
  // display.setTextSize(1);
  // display.setTextColor(SSD1306_WHITE);
  // display.setCursor(0, 10);
  // display.print("Registered ID: ");
  // display.println(cards[index].id);
  // display.print("Points: ");
  // display.println(cards[index].count);
  // display.display();
  // delay(1000);
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

  if (canPercentage < FULL_CAP) {
    display.println("Can: FULL");
  } else {
    display.println("Can: Available");
  }

  if (plasticPercentage < FULL_CAP) {
    display.println("Plastic: FULL");
  } else {
    display.println("Plastic: Available");
  }

  if (paperPercentage < FULL_CAP) {
    display.println("Paper: FULL");
  } else {
    display.println("Paper: Available");
  }

  display.display();
}

void Display_GasWarning() {
 display.println("Warning: Flammable Gas");
 delay(1000);
}


void Testing_display(){
  if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
    Serial.println(F("SSD1306 allocation failed"));
    for (;;);
  }
  display.clearDisplay();
  display.display();
}
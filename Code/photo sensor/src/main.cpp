#include <SPI.h> 
#include <Wire.h> 
#include <Adafruit_GFX.h> 
#include <Adafruit_SSD1306.h>

#define SS_PIN 53
#define RST_PIN 5
#define SCREEN_WIDTH 128  
#define SCREEN_HEIGHT 64  
#define OLED_RESET -1 
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

const int ldrPins[] = {A0, A1, A2};

float getLDRPercentage(int pin) {
  int ldrValue = analogRead(pin);
  // Assuming the range is 0 to 1023, map it to a percentage (0 to 100%)
  float percentage = (ldrValue / 1023.0) * 100;
  return percentage;
}

const float fullCapacity = 90.0;
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

  if (canPercentage > fullCapacity) {
    display.println("Can: FULL");
  } else {
    display.print("Can: ");
    display.println(String(canPercentage) + "%");
  }

  if (plasticPercentage > fullCapacity) {
    display.println("Plastic: FULL");
  } else {
    display.print("Plastic: ");
    display.println(String(plasticPercentage) + "%");
  }

  if (paperPercentage > fullCapacity) {
    display.println("Paper: FULL");
  } else {
    display.print("Paper: ");
    display.println(String(paperPercentage) + "%");
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

void setup() {
  Serial.begin(9600);
  SPI.begin();  

  if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
    Serial.println(F("SSD1306 allocation failed"));
    for (;;);
  }
  display.clearDisplay();
  display.display(); 
  DisplayCapacity();
}

void loop() {
  DisplayCapacity();
}


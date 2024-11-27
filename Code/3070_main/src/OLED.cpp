#include "OLED.h"
#include "capacity.h"

//sda 42 scl 41

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

void initOLED() {
  Wire.begin(47, 48);
  if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
    Serial.println(F("SSD1306 allocation failed"));
    for (;;);
  }
  Serial.println("OLED Init done");
  display.clearDisplay();
  display.display();
}

void showMessageMiddle(const char *message) {
  displayContent = message;
}
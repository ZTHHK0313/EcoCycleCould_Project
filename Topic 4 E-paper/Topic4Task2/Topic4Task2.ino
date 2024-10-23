#include <GxEPD2_BW.h>
#include <GxEPD2_3C.h>
#include <Fonts/FreeMonoBold9pt7b.h>
#define MAX_DISPLAY_BUFFER_SIZE 800
#define MAX_HEIGHT(EPD) (EPD::HEIGHT <= MAX_DISPLAY_BUFFER_SIZE / (EPD::WIDTH / 8) ? EPD::HEIGHT : MAX_DISPLAY_BUFFER_SIZE / (EPD::WIDTH / 8))
GxEPD2_BW<GxEPD2_154_D67, MAX_HEIGHT(GxEPD2_154_D67)> display(GxEPD2_154_D67(/*CS=10*/ 10, /*DC=*/ 9, /*RST=*/ 8, /*BUSY=*/ 7)); // GDEH0154D67 200x200


void setup() {
  // Initialize the display
  display.init();
  display.setRotation(0); 

  display.firstPage();
  do {
    display.fillScreen(GxEPD_WHITE);
    // Define the rectangle dimensions
    int rectWidth = 100;
    int rectHeight = 50;

    int rectX = (display.width() - rectWidth) / 2;
    int rectY = (display.height() - rectHeight) / 2;

    // Draw a rectangle
    display.drawRect(rectX, rectY, rectWidth, rectHeight, GxEPD_BLACK);

    // Set the font and text alignment
    display.setFont(&FreeMonoBold9pt7b);
    display.setTextColor(GxEPD_BLACK);
    display.setCursor(rectX + 15, rectY + rectHeight / 2 + 5); // Adjust cursor for centering text

    // Print the name inside the rectangle
    display.print("Tsz Hin");

    // Refresh the display to show the changes
    display.display();
  } while (display.nextPage());
}

void loop() {
  // Nothing to do here
}
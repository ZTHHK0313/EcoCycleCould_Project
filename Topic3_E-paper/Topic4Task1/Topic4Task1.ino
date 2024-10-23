#include <GxEPD2_BW.h>
#define ENABLE_GxEPD2_GFX 0
#define MAX_DISPLAY_BUFFER_SIZE 800
#define MAX_HEIGHT(EPD) (EPD::HEIGHT <= MAX_DISPLAY_BUFFER_SIZE / (EPD::WIDTH / 8) ? EPD::HEIGHT : MAX_DISPLAY_BUFFER_SIZE / (EPD::WIDTH / 8))
GxEPD2_BW<GxEPD2_154_D67, MAX_HEIGHT(GxEPD2_154_D67)> display(GxEPD2_154_D67(/*CS=10*/ 10, /*DC=*/ 9, /*RST=*/ 8, /*BUSY=*/ 7)); // GDEH0154D67 200x200
//
void setup()
{
display.init();
delay(1000);
display.firstPage();
do {
// this part of code is executed multiple times, as many as needed, in case of full buffer it is executed once
// set the background to white (fill the buffer with value for white)
display.fillScreen(GxEPD_WHITE);
delay(500);
display.fillCircle(20,60, 10, GxEPD_BLACK); // draw a circle
delay(500);
} while (display.nextPage());
// tell the graphics class to transfer the buffer content (page) to the controller buffer the graphics class will
//command the controller to refresh to the screen when the last page has been transferred
// returns true if more pages need be drawn and transferred; returns false if the last page has been transferred and the
//screen refreshed for panels without fast partial update
display.powerOff();
}
void loop()
{}
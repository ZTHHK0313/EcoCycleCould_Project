#include "smokedetcet.h"
#include <Arduino.h>
#include "OLED.h"

int gaspresent = 0;
bool warningsignal = 0; 

void gaswarning(){
gaspresent = map(gasvalue,0,4095,0,100);
Serial.println(gaspresent);
if(gaspresent>= 50)
{
    warningsignal = 1;
    Display_GasWarning();
}
else
{
    warningsignal = 0;
}
}
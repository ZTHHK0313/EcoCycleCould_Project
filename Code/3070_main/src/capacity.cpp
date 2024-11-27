#include "capacity.h"

float getLDRPercentage() {
  int ldrValue = analogRead(13);
  // Assuming the range is 0 to 1023, map it to a percentage (0 to 100%)
  float percentage = map(ldrValue-3900, 0, 4095-3900, 0, 100);
  if(percentage < 0) {
    percentage = 0;
  }
  return percentage;
}

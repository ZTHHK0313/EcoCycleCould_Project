#define MQ4_PIN 12
#define gasvalue analogRead(MQ4_PIN)
void gaswarning(void *pvParameters);
extern bool warningsignal;

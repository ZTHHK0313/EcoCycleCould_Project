#include <WiFi.h>
#include <ESPAsyncWebServer.h>
#include <ArduinoJson.h>
#ifndef DATA_H
#define DATA_H
#include "data.h"
#endif


#define ssid2  "ECCRouter"
#define password2  "12345678"

#define ssid  "HK-XiaoMi"
#define password  "54815984"





////////////////////////////
// API_Server_init
// Initialize the API server on the ESP32.
// Author: KH
// Return: true if the server is started successfully, false otherwise.
////////////////////////////
bool API_Server_init();
////////////////////////////
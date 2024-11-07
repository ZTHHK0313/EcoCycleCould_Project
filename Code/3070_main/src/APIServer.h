#include <WiFi.h>
#include <ESPAsyncWebServer.h>
#include <ArduinoJson.h>
#ifndef DATA_H
#define DATA_H
#include "data.h"
#endif


#define ssid  "ESP32-AP"
#define password  "12345678"





////////////////////////////
// API_Server_init
// Initialize the API server on the ESP32.
// Author: KH
// Return: true if the server is started successfully, false otherwise.
////////////////////////////
bool API_Server_init();
////////////////////////////
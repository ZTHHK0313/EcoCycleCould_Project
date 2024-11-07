#include "APIServer.h"



AsyncWebServer server(80);


bool API_Server_init() {
    
    // Set ESP32 to AP mode
    WiFi.softAP(ssid, password);

    // Set a static IP address
    IPAddress IP(192, 168, 1, 1);
    IPAddress gateway(192, 168, 1, 1);
    IPAddress subnet(255, 255, 255, 0);
    WiFi.softAPConfig(IP, gateway, subnet);

    Serial.println("Access Point Started");
    Serial.print("IP Address: ");
    Serial.println(WiFi.softAPIP());

    

    // format the user data into a JSON string using ArduinoJson
    string response = "{\"df\" : [";
    //{"id" : 0,"name":"test","pts":0,"Interactions":[{"waste_type":0,"pts":10,"time":100000}]}]}
    for(int i=0;i<users.size();i++){
        response += "{\"id\":";
        response += to_string(users[i].user_id);
        response += ",\"name\":\"";
        response += users[i].name;
        response += "\",\"pts\":";
        response += to_string(users[i].points);
        response += ",\"Interactions\":[";
        for(int j=0;j<users[i].interactions.size();j++){
            response += "{\"waste_type\":";
            response += to_string(users[i].interactions[j].waste_type);
            response += ",\"pts\":";
            response += to_string(users[i].interactions[j].points);
            response += ",\"time\":";
            response += to_string(users[i].interactions[j].time);
            response += "}";
            if(j!=users[i].interactions.size()-1){
                response += ",";
            }
        }
        response += "]}";

    }

    server.on("/api/user_data", HTTP_GET, [response](AsyncWebServerRequest *request){
        request->send(200, "application/json", response.c_str());
    });


    // Start the server
    server.begin();
    return true;
}



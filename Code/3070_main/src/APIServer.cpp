#include "APIServer.h"



AsyncWebServer server(80);
extern int Classify_Bin;

bool API_Server_init() {
    
    // Set ESP32 to AP mode (Not Used
    //WiFi.softAP(ssid, password);
    // // Set a static IP address
    // IPAddress IP(192, 168, 1, 1);
    // IPAddress gateway(192, 168, 1, 1);
    // IPAddress subnet(255, 255, 255, 0);
    // WiFi.softAPConfig(IP, gateway, subnet);


    WiFi.begin(ssid, password);

    int timeout = 0;
    while (WiFi.status() != WL_CONNECTED) {
        
        delay(500);
        Serial.println("Connecting to WiFi..");
        if(timeout++ > 20){
            WiFi.begin(ssid2, password2);
            timeout = 0;
        }
    }
    Serial.print("IP Address: ");
    Serial.println(WiFi.localIP());

    

    // format the user data into a JSON string using ArduinoJson
    /*
    {"df":
        [{  id":0,
            "name":"Alice",
            "pts":100,
            "Interactions":[{
                                "waste_type":0,
                                "pts":10,
                                "time":0
                            },
                            {   "waste_type":2,
                                "pts":15,
                                "time":0
                            }]},
         {  "id":1,
            "name":"Bob",
            "pts":200,
            "Interactions":[{   "waste_type":0,
                                "pts":100,
                                "time":0
                            },
                            {   "waste_type":0,
                                "pts":30,
                                "time":0
                            }]}
    */
    

    
    server.on("/api/user_data", HTTP_GET, [](AsyncWebServerRequest *request){
        string response = "{\"df\":[";
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
                if(j!=users[i].interactions.size()-1)
                    response += ",";
            }
            response += "]}";

            if(i!=users.size()-1)
                response += ",";

        }

        response += "]}";
        request->send(200, "application/json", response.c_str());
    });
    /*{
        "capacity": {
            "plastic": 45,
            "metal": 75,
            "paper": 90
        }
    }
    */
    server.on("/api/capacity", HTTP_GET, [](AsyncWebServerRequest *request){
        string response2 = "{\"df\" : [";
        for(int userid = 0;userid<5;userid++){
            if(userid==0){
                response2 += "{\"id\":";
                response2 += to_string(userid);
                response2 += ",\"capacity\":{\"plastic\":";
                response2 += to_string(capacity.plastic);
                response2 += ",\"metal\":";
                response2 += to_string(capacity.metal);
                response2 += ",\"paper\":";
                response2 += to_string(capacity.paper);
                response2 += "}}";
            }else{
                response2 += "{\"id\":";
                response2 += to_string(userid);
                response2 += ",\"capacity\":{\"plastic\":";
                response2 += to_string(rand() % 101);
                response2 += ",\"metal\":";
                response2 += to_string(rand() % 101);
                response2 += ",\"paper\":";
                response2 += to_string(rand() % 101);
                response2 += "}}";
            }

            if(userid!=4)
                response2 += ",";

        }
        response2 += "]}";
        request->send(200, "application/json", response2.c_str());
    });
    
    server.on("/api/1", HTTP_GET, [](AsyncWebServerRequest *request){
        //paper
        Classify_Bin = 1;
    });

    server.on("/api/2", HTTP_GET, [](AsyncWebServerRequest *request){
        //plastic
        Classify_Bin = 2;

    });
    server.on("/api/3", HTTP_GET, [](AsyncWebServerRequest *request){
        //metal
        Classify_Bin = 3;

    });



    // Start the server
    server.begin();
    return true;
}



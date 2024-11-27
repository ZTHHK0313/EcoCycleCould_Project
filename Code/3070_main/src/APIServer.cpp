#include "APIServer.h"
#include "capacity.h"



AsyncWebServer server(80);
extern int Classify_Bin;    // 1: Paper, 2: Plastic, 3: Metal       
const char webpage[] PROGMEM = R"rawliteral(
<!DOCTYPE html>
<html>
<head>
  <title>ECO Cycle Cloud</title>
  <style>
    body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
    #content { font-size: 24px; color: #333; }
    .info-container { margin-top: 20px; }
    .progress-bar { 
      width: 20px; 
      height: 100px; 
      background-color: #ccc; 
      margin: 0 10px; 
      display: inline-block; 
      position: relative; 
    }
    .progress-bar div { 
      width: 100%; 
      position: absolute; 
      bottom: 0; 
      background-color: #4CAF50; 
      transition: height 0.4s ease; 
    }
    .label { font-size: 16px; margin-top: 10px; }
  </style>
  <script>
    function fetchData() {
      fetch("/getContent")
        .then(response => response.json())
        .then(data => {
          document.getElementById("content").textContent = data.message;
          document.getElementById("uservar").textContent = "User: " + data.user;
          document.getElementById("capacity").textContent = "Capacity";

          // Update progress bars
          const capacities = data.capacityValues; // Expecting [value1, value2, value3]
          document.getElementById("progress1").style.height = capacities[0] + "%";
          document.getElementById("progress2").style.height = capacities[1] + "%";
          document.getElementById("progress3").style.height = capacities[2] + "%";
        });
    }
    setInterval(fetchData, 400);
  </script>
</head>
<body>
  <h1>ECO Cycle Cloud</h1>
  <div id="content">Loading...</div>
  <div class="info-container">
    <div id="uservar" class="label">User: Loading...</div>
    <div id="capacity" class="label">Capacity: Loading...</div>
    <div style="margin-top: 20px;">
      <div class="progress-bar"><div id="progress1"></div></div>
      <div class="progress-bar"><div id="progress2"></div></div>
      <div class="progress-bar"><div id="progress3"></div></div>
    </div>
  </div>
</body>
</html>
)rawliteral";

String displayContent = " ";
extern User* user;

bool API_Server_init() {
    
    // Set ESP32 to AP mode (Not Used
    //WiFi.softAP(ssid, password);
    // // Set a static IP address
    // IPAddress IP(192, 168, 1, 1);
    // IPAddress gateway(192, 168, 1, 1);
    // IPAddress subnet(255, 255, 255, 0);
    // WiFi.softAPConfig(IP, gateway, subnet);


    WiFi.begin(ssid2, password2);

    int timeout = 0;
    while (WiFi.status() != WL_CONNECTED) {
        
        delay(500);
        Serial.println("Connecting to WiFi..");
        if(timeout++ > 20){
            WiFi.begin(ssid, password);
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
    


    server.on("/", HTTP_GET, [](AsyncWebServerRequest* request) {
        request->send_P(200, "text/html", webpage);
    });

    // 获取动态内容的路由
    server.on("/getContent", HTTP_GET, [](AsyncWebServerRequest* request) {
        //request->send(200, "text/plain", displayContent);
        String jsonResponse = "{";
        jsonResponse += "\"message\":\"" + displayContent + "\",";
        String name = user==nullptr ? " " : String(user->name.c_str());
        jsonResponse += "\"user\":\"" + name + "\",";
        jsonResponse += "\"capacityValues\":[" + String(87) + "," + getLDRPercentage() + "," + String(97) + "]";
        jsonResponse += "}";
        request->send(200, "application/json", jsonResponse);
    });
    
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
                int i = getLDRPercentage();
                response2 += to_string(i);
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



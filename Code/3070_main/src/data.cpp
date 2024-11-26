#include "data.h"


vector<User> users;

Capacity capacity = {0,0,0};
MFRC522 mfrc522(SS_PIN, RST_PIN);

void card_init(){
    Serial.println("RFID Init");
    SPI.begin(SPI_SCK, SPI_MISO, SPI_MOSI);
    mfrc522.PCD_Init();
    Serial.println("RFID Init done");
}

void test(){
//卡片 UID: 28502
//卡片 UID: 51079
    if (mfrc522.PICC_IsNewCardPresent() && mfrc522.PICC_ReadCardSerial()) {
        Serial.print("卡片 UID: ");
        
        // 打印卡片 UID
        for (byte i = 0; i < mfrc522.uid.size; i++) {
            Serial.print(mfrc522.uid.uidByte[i]);
        }
        Serial.println();
        
        // 停止读卡
        mfrc522.PICC_HaltA();
    }
}

int RFID_READ(){
    int result = 0;
    while(1){
        if (mfrc522.PICC_IsNewCardPresent() && mfrc522.PICC_ReadCardSerial()) {

            for (byte i = 0; i < mfrc522.uid.size; i++) {
                result += mfrc522.uid.uidByte[i]*pow(10,i);
            }

            mfrc522.PICC_HaltA();

            return result;
        }
    }

}

User* find_user_by_id(int id){
    for(auto &user: users){
        if(user.user_id == id){
            return &user;
        }
    }
    return nullptr;
}


void fake_user_init() {
    users.push_back(User("Alice",28502,100));
    users.push_back(User("Bob",51079,200));
    //add some interactions
    users[0].interactions.push_back({User::Metal, 10});
    users[0].interactions.push_back({User::Plastic, 15});
    users[0].interactions.push_back({User::Paper, 20});
    users[0].interactions.push_back({User::Metal, 30});
    users[0].interactions.push_back({User::Plastic, 8});
    users[0].interactions.push_back({User::Paper, 40});
    users[1].interactions.push_back({User::Metal, 100});
    users[1].interactions.push_back({User::Metal, 30});
    users[1].interactions.push_back({User::Paper, 20});
    users[1].interactions.push_back({User::Plastic, 8});
    users[1].interactions.push_back({User::Plastic, 15});
    users[1].interactions.push_back({User::Paper, 40});
}


void data_init() {
    fake_user_init();
}





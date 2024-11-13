#include <iostream>
#include <string>
#include <vector>
#include <MFRC522.h>
using namespace std;



#define RST_PIN 5 //RFID PIN
#define SPI_MOSI 35 //RFID PIN
#define SPI_MISO 37 //RFID PIN
#define SPI_SCK 36 //RFID PIN
#define SS_PIN 6 //RFID PIN

#define MAX_CARDS 10
#define SERVO_PIN 9 

struct Card {
  int id;
  byte uid[4];
  int count;
};

class User{
public:
    //Types of garbage (metal, paper, plastic)
    enum WASTE_TYPE{
        Metal = 0,
        Paper = 1,
        Plastic = 2,
    };

    struct Interaction {
        WASTE_TYPE waste_type;
        int points;              // 获得的积分数
        int time;                // 交互时间
    };
    // Constructor, initialize user name and ID
    User(string name, int user_id, int p) : name(name), user_id(user_id), points(p) {}
    string name;                   // User name
    int user_id;                        //User ID
    int points;                         //User points
    vector<Interaction> interactions; // User interaction record
    Card user_card;                     // User card
};

struct Capacity
{
    int plastic;
    int metal;
    int paper;
};






extern vector<User> users;
extern Capacity capacity;
void card_init();
void fake_user_init();
void data_init();
void test();
int RFID_READ();
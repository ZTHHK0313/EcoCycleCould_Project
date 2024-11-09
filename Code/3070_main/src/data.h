#include <iostream>
#include <string>
#include <vector>
using namespace std;

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
};

struct Capacity
{
    int plastic;
    int metal;
    int paper;
};






extern vector<User> users;
extern Capacity capacity;
void fake_user_init();
void data_init();
#include "data.h"


vector<User> users;
Capacity capacity = {0,0,0};

void fake_user_init() {
    users.push_back(User("Alice",0,100));
    users.push_back(User("Bob",1,200));
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





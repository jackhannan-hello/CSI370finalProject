//main.cpp
#include <iostream>
#include <immintrin.h>
#include <random>
#include <algorithm>
#include <ctime>
#include <cstdlib>
#include <vector>
#include <chrono>
#include <string>
using namespace std;

extern "C" void _asmMain();

extern "C" void _shuffleDeck(int64_t* array, int size) {
    vector<int> vec(array, array + size);
    random_device rd;
    mt19937 g(rd());
    shuffle(vec.begin(), vec.end(), g);
    copy(vec.begin(), vec.end(), array);
}

extern "C" void _createTablePlayer(int64_t* player, int playerSize, int64_t* dealer, int dealerSize) {
    cout << "Dealer: ";
    for (int i = 0; i < dealerSize; i++) {
        if (i == 0) { cout << "D "; }
        else {
            if (dealer[i] <= 10) {
                cout << dealer[i] << " ";
            }
            else {
                char temp = char(dealer[i]);
                cout << temp << " ";
            }
            
        }
    }
    cout << "\n\n\nPlayer: ";
    for (int i = 0; i < playerSize; i++) {
        if (player[i] <= 10) {
            cout << player[i] << " ";
        }
        else {
            char temp = char(player[i]);
            cout << temp << " ";
        }
    }
    cout << endl;
}

extern "C" void _createTableDealer(int64_t* player, int playerSize, int64_t* dealer, int dealerSize) {
    cout << "Dealer: ";
    for (int i = 0; i < dealerSize; i++) {
        if (dealer[i] <= 10) {
            cout << dealer[i] << " ";
        }
        else {
            char temp = char(dealer[i]);
            cout << temp << " ";
        }
    }
    cout << "\n\n\nPlayer: ";
    for (int i = 0; i < playerSize; i++) {
        if (player[i] <= 10) {
            cout << player[i] << " ";
        }
        else {
            char temp = char(player[i]);
            cout << temp << " ";
        }
    }
    cout << endl;
}

extern "C" int _getInt() {
    int d;
    std::cin >> d;
    return d; 
}

extern "C" void _printString(char* s) {
    std::cout << s;
    return;
}

extern "C" void _printResult(char* s, int winnings) {
    std::cout << s << winnings;
    return;
}

extern "C" void _getPlayerDecission(int wager, int totalMoney) {
    string message = "You are betting $" + to_string(wager) + " and have $" + to_string(totalMoney)
        + "\nDo you want to Stand enter 0, to Hit enter 1, or Double enter 2"
        + "\nCAN ONLY DOUBLE ON FIRST HIT AND ONCE PER GAME";
    cout << message << endl;
}

extern "C" void _getGameDecission(int totalMoney) {
    cout << "Do you want to play again? Yes 1, No 0\n";
    cout << "You have $" << totalMoney << "left\n";
}

// main stub driver
int main() {
    _asmMain();
    return 0;
}
#include <iostream>
#include <fstream>
#include <string>
using namespace std;

int intValueOfItem(int c) {
    if (c > 96) return c - 96;
    return c - 38;
}

int part1(string line) {
    int compartmentLength = line.length() / 2;
    string leftCompartment = line.substr(0, compartmentLength);
    string rightCompartment = line.substr(compartmentLength);

    for (char c : leftCompartment) {
        if (rightCompartment.find(c) != std::string::npos) {
            return intValueOfItem(c);
        }
    }
    throw 1;
}

int part2(string l1, string l2, string l3) {
    string smallestString = l1;
    if (smallestString.length() > l2.length()) { smallestString = l2; }
    if (smallestString.length() > l3.length()) { smallestString = l3; }

    for (char c : smallestString) {
        if (l1.find(c) != std::string::npos &&
            l2.find(c) != std::string::npos &&
            l3.find(c) != std::string::npos) {
            return intValueOfItem(c);
        }
    }
    throw 1;
}

int main() {
    cout << "Advent Of Code 2022 Day 3!" << endl;
    // g++ AdventOfCode_day3.cpp -o AdventOfCode_day3 -std=c++11
    // AdventOfCode_day3.exe

    string l1, l2, l3;
    ifstream puzzle("day3.txt");

    int sum = 0;

    while (!puzzle.eof()) {
        getline (puzzle, l1);
        getline (puzzle, l2);
        getline (puzzle, l3);
        sum += part2(l1, l2, l3);
    }

    cout << sum;

    puzzle.close();
    return 0;
}

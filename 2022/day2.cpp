#include <iostream>
#include <fstream>
using namespace std;

int part1(string line) {
    int them = line[0] - 64;
    int us = line[2] - 87; //1=rock, 2=paper, 3=scissors

    if (them == us) { return us + 3; }
    if (them == 1 && us == 2) { return us + 6; }
    if (them == 2 && us == 3) { return us + 6; }
    if (them == 3 && us == 1) { return us + 6; }
    return us;
}

int part2(string line) {
    int them = line[0] - 64;
    int outcome = line[2] - 89; // -1=lose, 0=draw, 1=win

    if (!outcome) { return them + 3; }
    int us = 0;

    if (outcome > 0) {
        us = (them + 1) % 4;
        if (!us) { us += 1; } // 4 should become 1, not 0
        return us + 6;
    }
    
    us = them - 1;
    if (!us) { us = 3; } // 0 should become 3
    return us;
}

int main() {
    cout << "Advent Of Code 2022 Day 2!" << endl;

    string line;
    ifstream puzzle("day2.txt");

    int sum = 0;

    while (getline (puzzle, line)) {
        sum += part2(line);
    }

    cout << sum << endl;

    puzzle.close();
    return 0;
}

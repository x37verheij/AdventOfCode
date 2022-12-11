#include <iostream>
#include <fstream>
#include <queue>
#include <set>
using namespace std;

bool checkQueueUniqueCharCount(queue<char> Q, int n) {
    set<char> S;
    for (int i = 0; i < n; i++)
    {
        S.insert(Q.front());
        Q.pop();
    }

    return (S.size() == n);
}

int main()
{
    cout << "Advent Of Code 2022 Day 6!" << endl;
    ifstream puzzle("day6.txt");
    string line;
    queue<char> Q;
    int index = 0;

    // Part 1: Start of packet marker, first 4 distinct characters in a sequence
    // Part 2: Start of message marker, first 14 distinct characters in a sequence
    int n = 14;

    getline(puzzle, line);
    for (char c : line)
    {
        index++;
        Q.push(c);
        if (Q.size() > n) { Q.pop(); }
        if (Q.size() == n && checkQueueUniqueCharCount(Q, n))
        {
            cout << index << endl;
            break;
        }
    }

    puzzle.close();
    return 0;
}

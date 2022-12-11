#include <iostream>
#include <fstream>
#include <stack>
using namespace std;

void part1(stack<char> *stacks, ifstream &puzzle)
{
    while (!puzzle.eof())
    {
        string line;
        getline(puzzle, line);

        int times, fromStack, toStack;
        sscanf(line.c_str(), "move %d from %d to %d", &times, &fromStack, &toStack);
        fromStack--;
        toStack--;

        for (int i = 0; i < times; i++)
        {
            char c = stacks[fromStack].top();
            stacks[fromStack].pop();
            stacks[toStack].push(c);
        }
    }
}

void part2(stack<char> *stacks, ifstream &puzzle)
{
    stack<char> tempStack;
    while (!puzzle.eof())
    {
        string line;
        getline(puzzle, line);

        int times, fromStack, toStack;
        sscanf(line.c_str(), "move %d from %d to %d", &times, &fromStack, &toStack);
        fromStack--;
        toStack--;

        // To tempStack
        for (int i = 0; i < times; i++)
        {
            char c = stacks[fromStack].top();
            stacks[fromStack].pop();
            tempStack.push(c);
        }

        // to toStack
        for (int i = 0; i < times; i++)
        {
            char c = tempStack.top();
            tempStack.pop();
            stacks[toStack].push(c);
        }
    }
}

void printLettersOnTop(stack<char> *stacks, int width)
{
    cout << "Letters on top: [";
    for (int i = 0; i < width; i++)
    {
        stack<char> *stack = &stacks[i];
        if (!(*stack).empty())
        {
            cout << (*stack).top();
        }
        else
        {
            cout << ' ';
        }
    }
    cout << ']' << endl;
}

int main()
{
    cout << "Advent Of Code 2022 Day 5!" << endl;
    ifstream puzzle("day5.txt");
    string line;

    // Cannot create init function here, because stacks is of stack<char>[] type,
    // which is an array of elements that are variable in size. That means that
    // all of the created stacks & chars need to be created in the current scope.
    // Not sure how garbage collection works when memory is allocated in the init.

    size_t initialSize = 20;
    string prephase[initialSize];
    int prephaseIndex = 0;

    do
    {
        getline(puzzle, line);
        prephase[prephaseIndex++] = line;

        if (prephaseIndex == initialSize)
        {
            cerr << "First command cannot be found in the first "
                 << initialSize << " rows!" << endl
                 << flush;
            exit(1);
        }
    } while (line != "\r");

    // Height = the amount of input rows, excluding the line with the column numbers.
    // Width  = the rightmost number on the line with the column numbers.
    int height = prephaseIndex - 2;
    string columnNumbersLine = prephase[height];
    int width = stoi(columnNumbersLine.substr(columnNumbersLine.size() - 4));
    stack<char> stacks[width];

    // Initialize the stacks
    for (int x = 0; x < width; x++)
    {
        for (int y = height - 1; y >= 0; y--)
        {
            char c = prephase[y][4 * x + 1];
            if (c == ' ')
                break;
            stacks[x].push(c);
        }
    }

    // part1(stacks, puzzle); // VWLCWGSDQ
    part2(stacks, puzzle); // TCGLQSLPW
    printLettersOnTop(stacks, width);

    puzzle.close();
    return 0;
}

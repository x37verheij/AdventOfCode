#include <iostream>
#include <fstream>
#include <list>
#include <map>
using namespace std;

class Dir
{
    std::map<string, Dir *> *pointerToMap;
    int64_t fileSizeOnDisk = 0;    // Total fileSize of only directly listed files, not in any subdir.
    list<string> subDirs;          // List of all subdirs.
    int64_t dirSizeOnDisk = 0;     // Total dirSize of all subdirs.
    int64_t totalSize = 0;         // Cached total size, set when calculated.
    bool fullyInitialized = false; // When dirSizeOnDisk and totalSize are set.
public:
    Dir(std::map<string, Dir *> *allDirectories) { pointerToMap = allDirectories; }
    void addFile(int64_t fileSize) { fileSizeOnDisk += fileSize; }
    void addSubDirectory(string subDirName) { subDirs.push_back(subDirName); }
    int64_t getTotalSize()
    {
        if (fullyInitialized)
        {
            cout << "FI!" << endl << flush;
            return totalSize;
        }
        for (string subDir : subDirs)
        {
            cout << "Find subdir " << subDir << endl << flush;
            int64_t delta = (*pointerToMap).find(subDir)->second->getTotalSize();
            dirSizeOnDisk += delta;
        }
        totalSize = fileSizeOnDisk + dirSizeOnDisk;
        cout << "TotalSize!" << totalSize << endl << flush;
        fullyInitialized = true;
        return totalSize;
    }
    void printToString()
    {
        cout << "  fileSize=" << fileSizeOnDisk << endl
             << "  dirSize=" << dirSizeOnDisk << endl
             << "  totalSize=" << getTotalSize() << endl;
    }
};

int main()
{
    cout << "Advent Of Code 2022 Day 7!" << endl;
    ifstream puzzle("day7.txt");
    string keyword;
    string currentDir;

    // Assume that every directory name is unique, so that key = dirname and not dirpath.
    // And here is where we get our infinite loop...
    std::map<string, Dir *> allDirectories;

    while (!puzzle.eof())
    {
        /*
        $ cd /          set currentDir and create dir in map
        $ cd ..         set currentDir
        $ cd d          set currentDir and create dir in map
        $ ls            ignore
        dir a           add as subDir to currentDir
        14848514 b.txt  add as file to currentDir
        29116 f         add as file to currentDir
        */
        puzzle >> keyword;
        if ("$" == keyword)
        {
            puzzle >> keyword;
            if ("cd" == keyword)
            {
                puzzle >> currentDir;
                if (".." != currentDir)
                {
                    allDirectories.insert({currentDir, new Dir(&allDirectories)});
                }
            }
        }
        else if ("dir" == keyword)
        {
            puzzle >> keyword;
            allDirectories.find(currentDir)->second->addSubDirectory(keyword); // dir [aaa]
        }
        else
        {
            allDirectories.find(currentDir)->second->addFile(stol(keyword)); // [29116] bbb.txt
            puzzle >> keyword;
        }
    }

    puzzle.close();
    cout << "<1><1>" << endl;

    // Part 1: Find the sum of all directories with a total size of at most 100000.
    int64_t sum = 0;
    for (auto dir : allDirectories)
    {
        cout << "<2><2>" << endl;
        int64_t totalSize = dir.second->getTotalSize();
        cout << "dir " << dir.first << " has size " << totalSize << endl;
        if (totalSize <= 100000)
        {
            sum += totalSize;
        }
    }

    cout << endl << "Sum dirs < 100000: " << sum << endl;

    return 0;
}

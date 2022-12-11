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
            return totalSize;
        }
        for (string subDir : subDirs)
        {
            int64_t delta = (*pointerToMap).find(subDir)->second->getTotalSize();
            dirSizeOnDisk += delta;
        }
        totalSize = fileSizeOnDisk + dirSizeOnDisk;
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

class FilePath
{
    string filePath;

public:
    void alterPath(string cd)
    {
        if (".." == cd)
        {
            filePath = filePath.substr(0, filePath.find_last_of("/"));
            if ("" == filePath)
            {
                filePath = "/";
            }
        }
        else if ("/" == cd)
        {
            filePath = cd;
        }
        else if ("/" == filePath)
        {
            filePath += cd;
        }
        else
        {
            filePath += "/" + cd;
        }
    }
    string getPath() { return filePath; }
    string getSubPath(string subPath)
    {
        if ("/" == filePath)
        {
            return filePath + subPath;
        }
        return filePath + "/" + subPath;
    }
};

int main()
{
    cout << "Advent Of Code 2022 Day 7!" << endl;
    ifstream puzzle("day7.txt");
    string keyword;
    std::map<string, Dir *> allDirectories;
    FilePath fp;

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
                puzzle >> keyword;
                fp.alterPath(keyword);
                if (".." != keyword)
                {
                    allDirectories.insert({fp.getPath(), new Dir(&allDirectories)});
                }
            }
        }
        else if ("dir" == keyword)
        {
            puzzle >> keyword;
            allDirectories.find(fp.getPath())->second->addSubDirectory(fp.getSubPath(keyword)); // dir [aaa]
        }
        else
        {
            allDirectories.find(fp.getPath())->second->addFile(stol(keyword)); // [29116] bbb.txt
            puzzle >> keyword;
        }
    }

    puzzle.close();
    cout << endl;

    // Part 1: Find the sum of all directories with a total size of at most 100000. // 1844187
    int64_t sum = 0;

    for (auto dir : allDirectories)
    {
        int64_t dirSize = dir.second->getTotalSize();
        if (dirSize <= 100000)
        {
            sum += dirSize;
        }
    }
    cout << "Sum dirs < 100 kB: " << sum << " B" << endl;

    // Part 2: Calculate the needed space and find closest match above that amount.
    int64_t totalSize = allDirectories.find("/")->second->getTotalSize();
    int64_t neededSpace = totalSize - 4e7;
    int64_t bestMatch = 7e7;

    for (auto dir : allDirectories)
    {
        int64_t dirSize = dir.second->getTotalSize();
        if (dirSize >= neededSpace && dirSize < bestMatch)
        {
            bestMatch = dirSize;
        }
    }
    cout << "Total size in use: " << totalSize / 1e6 << " MB" << endl;
    cout << "Total free space: " << (7e7 - totalSize) / 1e6 << " MB" << endl;
    cout << "For 30 MB free space, we need: " << neededSpace / 1e6 << " MB" << endl;
    cout << "Closest above " << neededSpace / 1e6 << " MB: " << bestMatch << " B" << endl;

    return 0;
}

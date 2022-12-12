// See https://aka.ms/new-console-template for more information

using static System.Runtime.InteropServices.JavaScript.JSType;

internal class Day4
{
	private string[] puzzle;

	public Day4()
	{
		Console.WriteLine("Advent Of Code 2022 Day 4");
		string inputPath = "C:\\Users\\lverheij\\source\\repos\\AdventOfCode2022\\AdventOfCode2022\\Day4.txt";

		puzzle = System.IO.File.ReadAllText(inputPath).Split("\r\n");
	}

	public void Solve()
	{
		int fullycontains = 0;
		int overlap = 0;

		foreach (string line in puzzle)
		{
			string[] strNums = line.Split('-', ',');

			int start0 = Int32.Parse(strNums[0]);
			int end0 = Int32.Parse(strNums[1]);
			int start1 = Int32.Parse(strNums[2]);
			int end1 = Int32.Parse(strNums[3]);

            // if range 0 is fully included by range 1, or if range 1 is fully included by range 0
            if (start0 >= start1 && end0 <= end1 ||
				start1 >= start0 && end1 <= end0)
			{
				fullycontains++;
				overlap++;
				Console.WriteLine("> " + line + " fullycontains & overlap");
			}

			// if partial overlap
			else if (end0 >= start1 && end1 >= start0)
			{
				overlap++;
				Console.WriteLine("+ " + line + " overlap");
			}

			else
			{
				Console.WriteLine("  " + line + " --");
			}
        }
		
		Console.WriteLine("fullycontains = " + fullycontains);
		Console.WriteLine("overlap = " + overlap);
	}
}

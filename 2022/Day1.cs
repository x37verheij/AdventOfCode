// See https://aka.ms/new-console-template for more information

internal class Day1
{
	private string[] puzzle;

	public Day1()
	{
		Console.WriteLine("Advent Of Code 2022 Day 1");
		string inputPath = "C:\\Users\\lverheij\\source\\repos\\AdventOfCode2022\\AdventOfCode2022\\Day1.txt";

		puzzle = System.IO.File.ReadAllText(inputPath).Split("\r\n");
	}

	public void Solve()
	{
		// puzzle is crlf separated values, grouped by values separated by empty lines.

		int[] sortedCalories = new Int32[1000];
		int index = 0;
		int sumCurrentCalories = 0;

		foreach (string value in puzzle)
		{
			if ("" == value)
			{
				sortedCalories[index] = (sumCurrentCalories);
				index++;
				sumCurrentCalories = 0;
			}
			else
			{
				sumCurrentCalories += Int32.Parse(value.Trim());
			}
		}

		Array.Sort(sortedCalories);

		Console.WriteLine(sortedCalories[sortedCalories.GetLength(0) - 1]);
		Console.WriteLine(sortedCalories[sortedCalories.GetLength(0) - 2]);
		Console.WriteLine(sortedCalories[sortedCalories.GetLength(0) - 3]);
	}
}

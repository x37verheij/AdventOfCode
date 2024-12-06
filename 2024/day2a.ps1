#2024 day2a
Set-StrictMode -Version Latest
$file = Get-Content 'day2a.txt'
$safeReports = 0

foreach ($line in $file)
{
    $numbers = $line.Split(' ')
    $i = 0
    $increasing = [bool]($numbers[0] -lt $numbers[1])

    while ($i -lt $numbers.Count - 1)
    {
        if ($increasing)
        {
            $dif = $numbers[$i + 1] - $numbers[$i]
            if ($dif -gt 3 -or $dif -lt 1)
            {
                $safeReports -= 1
                break
            }
        }
        else
        {
            $dif = $numbers[$i] - $numbers[$i + 1]
            if ($dif -gt 3 -or $dif -lt 1)
            {
                $safeReports -= 1
                break
            }
        }
        $i += 1
    }
    $safeReports += 1
}

$safeReports
#answeres 241, but the real answer is 242????

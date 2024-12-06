#2024 day3a
Set-StrictMode -Version Latest
$file = Get-Content 'day3a.txt'

$sum = 0

foreach ($line in $file)
{
    $res = Select-String 'mul\((\d{1,3}),(\d{1,3})\)' -InputObject $line -AllMatches
    foreach ($r in $res.Matches)
    {
        $a = [int]$r.Groups[1].Value
        $b = [int]$r.Groups[2].Value
        # write-host "$a * $b = $($a * $b)"
        $sum += $a * $b
    }
}

$sum

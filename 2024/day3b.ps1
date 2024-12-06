#2024 day3b
Set-StrictMode -Version Latest
$file = Get-Content 'day3b.txt'

$enabled = $true
$sum = 0

foreach ($line in $file)
{
    $res = Select-String "do\(\)|don't\(\)|mul\((\d{1,3}),(\d{1,3})\)" -InputObject $line -AllMatches
    foreach ($r in $res.Matches)
    {
        if ($r.Groups[0].Value -like 'mul*')
        {
            if ($enabled)
            {
                $a = [int]$r.Groups[1].Value
                $b = [int]$r.Groups[2].Value
                # write-host "$a * $b = $($a * $b)"
                $sum += $a * $b
            }
        }
        elseif ($r.Groups[0].Value -eq "don't()")
        {
            $enabled = $false
        }
        else
        {
            $enabled = $true
        }
    }
}

$sum

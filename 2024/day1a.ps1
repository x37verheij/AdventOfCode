# 2024 day 1a
$file = Get-Content 'day1a.txt'
[int[]]$list1 = @()
[int[]]$list2 = @()

foreach ($line in $file)
{
    $m = $line -match '(\d+)\s+(\d+)'
    $list1 += [int]$Matches[1]
    $list2 += [int]$Matches[2]
}

$list1 = $list1 | Sort-Object
$list2 = $list2 | Sort-Object

$count = $list1.Count
$totaldist = 0

while ($count)
{
    $count -= 1
    $dist = $list1[$count] - $list2[$count]
    if ($dist -lt 0) {
        $dist = -$dist
    }
    $totaldist += $dist
}

$totaldist

# 2024 day 1b
$file = Get-Content 'day1b.txt'
[int[]]$list1 = @()
[int[]]$list2 = @()

foreach ($line in $file)
{
    $m = $line -match '(\d+)\s+(\d+)'
    $list1 += [int]$Matches[1]
    $list2 += [int]$Matches[2]
}

# $list1 = $list1 | Sort-Object
# $list2 = $list2 | Sort-Object

$totalsimilarity = 0

foreach ($a in $list1)
{
    $b = $list2 | Where-Object { $_ -eq $a }
    $b = if ($b) { $b.Count } else { 0 }
    $totalsimilarity += $a * $b
}

$totalsimilarity

#2024 day5a
Set-StrictMode -Version Latest
$file1 = Get-Content 'day5a1.txt'
$file2 = Get-Content 'day5a2.txt'

$dict = @{}

foreach ($line in $file1)
{
    [int]$a, [int]$b = $line.Split('|')
    if ($dict[$a])
    {
        $dict[$a] += $b
    }
    else
    {
        $dict[$a] = @($b)
    }
}

function isNumberOK
{
    param ($num, $listWithoutNum)
    $len = $listWithoutNum.Count
    foreach ($mayNotExistBeforePageNumber in $dict[$num])
    {
        if ($mayNotExistBeforePageNumber -in $listWithoutNum)
        {
            return $false
        }
    }
    if ($len -gt 1)
    {
        return isNumberOK $listWithoutNum[-1] $listWithoutNum[0..($len-2)]
    }
    return $true
}

$sum = 0
# $i = 0

foreach ($line in $file2)
{
    # Write-Host "$i"
    $list = [int[]]$line.Split(',')
    $len = $list.Count
    if (isNumberOK $list[-1] $list[0..($len-2)])
    {
        # $list[$len/2-0.5]
        $sum += $list[$len/2-0.5]
    }
    # $i += 1
}

$sum

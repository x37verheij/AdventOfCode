#2024 day7a
Set-StrictMode -Version Latest
$file = Get-Content 'day7a.txt'
#725034240000: 5 6 4 3 12 81 40 14 37 100

$sum = 0
$equations = @()

# parse file
foreach ($line in $file)
{
    $total, $remaining = $line.Split(':')
    $equations += [PSCustomObject]@{
        Total = [int64]$total
        Nums = [int[]]$remaining.Substring(1).Split(' ')
    }
}

# get all possible results for equation
function getPossibleResults
{
    param ([int[]]$nums, [int]$lastNum)
    if (1 -eq $nums.Length)
    {
        return @() + @([int64]$nums[0] * $lastNum) + @([int64]$nums[0] + $lastNum)
    }
    $subtotals = getPossibleResults ($nums[0..($nums.Count-2)]) $nums[-1]
    $subtotals = $subtotals | Sort-Object -Unique # because * then + equals + then *
    [int64[]]$totals = @()

    foreach ($subtotal in $subtotals)
    {
        $totals += $subtotal * $lastNum
        $totals += $subtotal + $lastNum
    }
    return $totals
}

$i = 0
# solve all equations
foreach ($equation in $equations)
{
    $i += 1
    $possibleResults = `
    getPossibleResults ($equation.Nums[0..($equation.Nums.Count-2)]) $equation.Nums[-1]

    if ($equation.Total -in $possibleResults)
    {
        $sum += $equation.Total
    }
    if ($i % 10 -eq 0)
    {
        Write-Host "$($i / 8.5)%"
    }
}

$sum

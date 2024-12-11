#2024 day7b
Set-StrictMode -Version Latest
$file = Get-Content 'day7b.txt'
#725034240000: 5 6 4 3 12 81 40 14 37 100
#2898: 2 3 4 5 6 7 8 9 10 11 12

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

function recursiveResultTester # use operators and check answer and only then change an operator
{
    param ([int64]$subtotal, [int[]]$nums, [int64]$answer)
    if ($subtotal -gt $answer) { return $false }
    if (1 -eq $nums.Length)
    {
        if (($subtotal * $nums[0]) -eq $answer) { return $true }
        if (($subtotal + $nums[0]) -eq $answer) { return $true }
        if ([int64]("$subtotal$($nums[0])") -eq $answer) { return $true }
        return $false
    }
    if (recursiveResultTester ($subtotal * $nums[0]) ($nums[1..($nums.Count-1)]) $answer) { return $true }
    if (recursiveResultTester ($subtotal + $nums[0]) ($nums[1..($nums.Count-1)]) $answer) { return $true }
    if (recursiveResultTester ("$subtotal$($nums[0])") ($nums[1..($nums.Count-1)]) $answer) { return $true }
    return $false
}

$i = 0
# solve all equations
foreach ($equation in $equations)
{
    $i += 1
    if (recursiveResultTester ($equation.Nums[0]) ($equation.Nums[1..($equation.Nums.Count-1)]) $equation.Total)
    {
        $sum += $equation.Total
    }
    Write-Host "$($i / 8.5)%"
}

$sum

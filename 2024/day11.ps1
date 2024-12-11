#2024 day11
Set-StrictMode -Version Latest
$file = Get-Content 'day11.txt'

## custom variables
$totalBlinks = 25

## other variables
$map = @{} # hasthtable with stone numbers as keys. Values are @{} with k=#blinks v=#stones

## function
function calcStone([int64]$number, [int]$blinks)
{
    # base case
    if ($blinks -lt 1) { return 1 } # 1 stone
    # known branch, return answer
    if ($map[$number] -and $map[$number][$blinks]) { return $map[$number][$blinks] }

    # case 1 when $number is zero
    if ($number -eq 0)
    {
        $subresult = calcStone 1 ($blinks - 1) # 0 -> 1
        $map[$number] += @{ $blinks = $subresult } # save in map
        return $subresult
    }

    # case 2 when $number has an even number of digits
    $s = "$number"
    if ($s.Length % 2 -eq 0)
    {
        $subresult = calcStone $s.substring(0, $s.Length / 2) ($blinks - 1) # left half
        $subresult += calcStone $s.substring($s.Length / 2) ($blinks - 1) # right half
        $map[$number] += @{ $blinks = $subresult } # save in map
        return $subresult
    }

    # case 3 default
    $subresult = calcStone ([int64]$number * 2024) ($blinks - 1) # mult by 2024
    $map[$number] += @{ $blinks = $subresult } # save in map
    return $subresult
}

$amountOfStones = 0
foreach ($number in $file.Split(' '))
{
    $amountOfStones += calcStone $number $totalBlinks
}

return $amountOfStones

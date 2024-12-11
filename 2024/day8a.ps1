#2024 day8a
Set-StrictMode -Version Latest
$file = Get-Content 'day8a.txt'

## custom variables
$width = 50
$height= 50

## other variables
$minX, $minY = 0, 0 
$maxX, $maxY = ($width-1), ($height-1)

# Case sensitive hashtable
$antennas = New-Object System.Collections.Hashtable # k=letter/number; v=array of coords
$antinodes = New-Object System.Collections.Generic.HashSet[string] 1500 # set uses add()

$y = 0
foreach ($line in $file)
{
    $x = 0
    foreach ($char in $line.ToCharArray())
    {
        if ($char -ne [char]'.')
        {
            $antennas[$char] += @([PSCustomObject]@{ x = $x; y = $y })
        }
        $x += 1
    }
    $y += 1
}

# find and store antinode locations per frequency
foreach ($frequency in $antennas.Keys)
{
    $i = 0
    while ($i -lt $antennas[$frequency].Count)
    {
        $j = $i + 1
        while ($j -lt $antennas[$frequency].Count)
        {
            $a = $antennas[$frequency][$i]
            $b = $antennas[$frequency][$j]

            $x0 = $a.x * 2 - $b.x
            $y0 = $a.y * 2 - $b.y
            $x1 = $b.x * 2 - $a.x
            $y1 = $b.y * 2 - $a.y

            if ($x0 -ge $minX -and $x0 -le $maxX -and $y0 -ge $minY -and $y0 -le $maxY) `
                { $antinodes.Add("$x0,$y0") | Out-Null }
            if ($x1 -ge $minX -and $x1 -le $maxX -and $y1 -ge $minY -and $y1 -le $maxY) `
                { $antinodes.Add("$x1,$y1") | Out-Null }

            $j += 1
        }
        $i += 1
    }
}

return $antinodes.Count

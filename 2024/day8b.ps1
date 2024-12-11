#2024 day8b
Set-StrictMode -Version Latest
$file = Get-Content 'day8b.txt'

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

            # search behind $a
            $dx = $a.x - $b.x
            $dy = $a.y - $b.y
            $k = 0 # include self
            while ($true)
            {
                $x = $a.x + $k * $dx
                $y = $a.y + $k * $dy
                if ($x -ge $minX -and $x -le $maxX -and $y -ge $minY -and $y -le $maxY) `
                    { $antinodes.Add("$x,$y") | Out-Null }
                else { break }
                $k += 1
            }

            # search behind $b
            $dx = -$dx
            $dy = -$dy
            $k = 0 # include self
            while ($true)
            {
                $x = $b.x + $k * $dx
                $y = $b.y + $k * $dy
                if ($x -ge $minX -and $x -le $maxX -and $y -ge $minY -and $y -le $maxY) `
                    { $antinodes.Add("$x,$y") | Out-Null }
                else { break }
                $k += 1
            }
            $j += 1
        }
        $i += 1
    }
}

return $antinodes.Count

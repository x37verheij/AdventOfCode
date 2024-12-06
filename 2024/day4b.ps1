#2024 day4b
Set-StrictMode -Version Latest
$file = Get-Content 'day4b.txt'

## custom variables
$input_width = 140
$input_height= 140

## auto variables
$occurences = 0
$width = $input_width + 2
$height = $input_height + 2

# Create Grid
$grid = @($null) * $height
$grid[0] = ('.' * $width).ToCharArray()
$i = 1

foreach ($line in $file)
{
    $grid[$i] = ".$line.".ToCharArray()
    $i += 1
}
$grid[$i] = ('.' * $width).ToCharArray()
# $grid[2][3] || $grid[y][x] where first&last rows&columns are dots

function printGrid
{
    foreach ($line in $grid)
    {
        Write-Host "$($line -join '')"
    }
}

$y = 1
while ($y -lt $height - 1) # dont check the dots on y=0 and y=height-1
{
    $x = 1
    while ($x -lt $width - 1) # dont check the dots on x=0 and x=width-1
    {
        if ($grid[$y][$x] -eq 'A')
        {
            $leftup    = $grid[$y - 1][$x - 1]
            $leftdown  = $grid[$y + 1][$x - 1]
            $rightup   = $grid[$y - 1][$x + 1]
            $rightdown = $grid[$y + 1][$x + 1]

            if ("$leftup$leftdown$rightup$rightdown" -like "[MS][MS][MS][MS]" `
                -and $leftup -ne $rightdown -and $leftdown -ne $rightup)
            {
                $occurences += 1
            }
        }
        $x += 1
    }
    $y += 1
}

$occurences

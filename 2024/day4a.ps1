#2024 day4a
Set-StrictMode -Version Latest
$file = Get-Content 'day4a.txt'

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

# Create directions
$dirs = @(
    @(1, 1),
    @(1, 0),
    @(1, -1),
    @(0, -1),
    @(-1, -1),
    @(-1, 0),
    @(-1, 1),
    @(0, 1)
)

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
        if ($grid[$y][$x] -eq 'X')
        {
            foreach ($dir in $dirs)
            {
                $m = $grid[$y + $dir[0]][$x + $dir[1]]
                if ($m -eq 'M')
                {
                    $a = $grid[$y + 2*$dir[0]][$x + 2*$dir[1]]
                    if ($a -eq 'A')
                    {
                        $s = $grid[$y + 3*$dir[0]][$x + 3*$dir[1]]
                        if ($s -eq 'S')
                        {
                            $occurences += 1
                        }
                    }
                }
            }
        }
        $x += 1
    }
    $y += 1
}

$occurences

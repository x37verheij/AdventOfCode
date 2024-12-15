#2024 day15a
Set-StrictMode -Version Latest
$fileMaze   = Get-Content 'day15a1.txt'
$fileInputs = Get-Content 'day15a2.txt'

## custom variables
$height = 50

# Enum
enum SpotType
{
    Wall = 0
    Empty = 1
    Box = 2
    Robot = 9
}

# Class
class Spot
{
    [byte]     $X
    [byte]     $Y
    [SpotType] $SpotType
    [Spot]     $AboveSpot
    [Spot]     $BelowSpot
    [Spot]     $LeftSpot
    [Spot]     $RightSpot

    Spot([byte]$x, [byte]$y, [char]$c)
    {
        $this.X = $x
        $this.Y = $y
        switch ($c)
        {
            '#' { $this.SpotType = [SpotType]::Wall; break }
            '.' { $this.SpotType = [SpotType]::Empty; break }
            'O' { $this.SpotType = [SpotType]::Box; break }
        default { $this.SpotType = [SpotType]::Robot; $Script:robot = $this }
        }
    }

    [char] ToString()
    {
        if ([SpotType]::Wall  -eq $this.SpotType) { return '#' }
        if ([SpotType]::Empty -eq $this.SpotType) { return '.' }
        if ([SpotType]::Box   -eq $this.SpotType) { return 'O' }
        return '@'
    }

    [bool] MoveUp([SpotType]$becomeSpotType)
    {
        if ([SpotType]::Wall  -eq $this.SpotType) { return $false }
        if ([SpotType]::Empty -eq $this.SpotType -or `
            $this.AboveSpot.MoveUp($this.SpotType))
        {
            $this.SpotType = $becomeSpotType
            if ([SpotType]::Robot -eq $becomeSpotType) { $Script:robot = $this }
            return $true
        }
        return $false
    }

    [bool] MoveDown([SpotType]$becomeSpotType)
    {
        if ([SpotType]::Wall  -eq $this.SpotType) { return $false }
        if ([SpotType]::Empty -eq $this.SpotType -or `
            $this.BelowSpot.MoveDown($this.SpotType))
        {
            $this.SpotType = $becomeSpotType
            if ([SpotType]::Robot -eq $becomeSpotType) { $Script:robot = $this }
            return $true
        }
        return $false
    }

    [bool] MoveLeft([SpotType]$becomeSpotType)
    {
        if ([SpotType]::Wall  -eq $this.SpotType) { return $false }
        if ([SpotType]::Empty -eq $this.SpotType -or `
            $this.LeftSpot.MoveLeft($this.SpotType))
        {
            $this.SpotType = $becomeSpotType
            if ([SpotType]::Robot -eq $becomeSpotType) { $Script:robot = $this }
            return $true
        }
        return $false
    }

    [bool] MoveRight([SpotType]$becomeSpotType)
    {
        if ([SpotType]::Wall  -eq $this.SpotType) { return $false }
        if ([SpotType]::Empty -eq $this.SpotType -or `
            $this.RightSpot.MoveRight($this.SpotType))
        {
            $this.SpotType = $becomeSpotType
            if ([SpotType]::Robot -eq $becomeSpotType) { $Script:robot = $this }
            return $true
        }
        return $false
    }

    [int] GPS()
    {
        if ([SpotType]::Box -eq $this.SpotType)
        {
            return (100 * $this.Y + $this.X)
        }
        return 0
    }

    [void] DiscoverNeighbors()
    {
        if ([SpotType]::Wall -ne $this.SpotType)
        {
            $this.AboveSpot = $Script:grid[$this.Y - 1][$this.X]
            $this.BelowSpot = $Script:grid[$this.Y + 1][$this.X]
            $this.LeftSpot  = $Script:grid[$this.Y][$this.X - 1]
            $this.RightSpot = $Script:grid[$this.Y][$this.X + 1]
        }
    }
}

[Spot]$robot = $null

# Create Grid
$grid = @($null) * $height

# Read fileMaze
$y = 0
foreach ($line in $fileMaze)
{
    $x = 0
    $grid[$y] = @()
    foreach ($char in $line.ToCharArray())
    {
        $grid[$y] += [Spot]::new($x, $y, $char)
        $x += 1
    }
    $y += 1
}

# Assign neighbors
foreach ($row in $grid)
{
    foreach ($spot in $row)
    {
        $spot.DiscoverNeighbors()
    }
}

function printGrid()
{
    foreach ($row in $grid)
    {
        Write-Host "$(($row | ForEach-Object { $_.ToString() }) -join '')"
    }
}

# Traverse inputs
foreach ($line in $fileInputs)
{
    foreach ($char in $line.ToCharArray())
    {
        switch ($char)
        {
            '^' { $null = $robot.MoveUp([SpotType]::Empty); break }
            'v' { $null = $robot.MoveDown([SpotType]::Empty); break }
            '<' { $null = $robot.MoveLeft([SpotType]::Empty); break }
        default { $null = $robot.MoveRight([SpotType]::Empty) }
        }
    }
}

# Get the sum of all GPS coordinates
printGrid
$sum = 0
foreach ($row in $grid)
{
    foreach ($spot in $row)
    {
        $sum += $spot.GPS()
    }
}

$sum

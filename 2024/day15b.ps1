#2024 day15b
Set-StrictMode -Version Latest
$fileMaze   = Get-Content 'day15b1.txt'
$fileInputs = Get-Content 'day15b2.txt'

## custom variables
$height = 50

# Enum
enum SpotType
{
    Wall = 0
    Empty = 1
    BoxLeftPart = 2
    BoxRightPart = 3
    Robot = 9
}

enum MoveAction
{
    Stay = 0
    Move = 1
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
            '[' { $this.SpotType = [SpotType]::BoxLeftPart; break }
            ']' { $this.SpotType = [SpotType]::BoxRightPart; break }
        default { $this.SpotType = [SpotType]::Robot; $Script:robot = $this }
        }
    }

    [char] ToString()
    {
        if ([SpotType]::Wall         -eq $this.SpotType) { return '#' }
        if ([SpotType]::Empty        -eq $this.SpotType) { return '.' }
        if ([SpotType]::BoxLeftPart  -eq $this.SpotType) { return '[' }
        if ([SpotType]::BoxRightPart -eq $this.SpotType) { return ']' }
        return '@'
    }

    [Spot] GetPartnerSpot()
    {
        if ([SpotType]::BoxLeftPart -eq $this.SpotType)
        {
            return $this.RightSpot
        }
        if ([SpotType]::BoxRightPart -eq $this.SpotType)
        {
            return $this.LeftSpot
        }
        throw 'This Spot has no partner spot!'
    }

    [bool] IsBox()
    {
        return [SpotType]::BoxLeftPart -eq $this.SpotType -or `
               [SpotType]::BoxRightPart -eq $this.SpotType
    }

    [void] MakeMove([SpotType]$becomeSpotType, [MoveAction]$moveAction)
    {
        if ([MoveAction]::Move -eq $moveAction)
        {
            $this.SpotType = $becomeSpotType
            if ([SpotType]::Robot -eq $becomeSpotType) { $Script:robot = $this }
        }
    }

    [bool] MoveUp([SpotType]$becomeSpotType, [MoveAction]$moveAction, [bool]$askedByPartner)
    {
        if ([SpotType]::Wall  -eq $this.SpotType) { return $false }
        if ([SpotType]::Empty -eq $this.SpotType -or `
            ($this.IsBox() -and (-not $askedByPartner) -and `
                $this.AboveSpot.MoveUp($this.SpotType, $moveAction, $false) -and `
                $this.GetPartnerSpot().MoveUp([SpotType]::Empty, $moveAction, $true)) -or `
            ((-not $this.IsBox() -or $askedByPartner) -and `
                $this.AboveSpot.MoveUp($this.SpotType, $moveAction, $false)))
        {
            $this.MakeMove($becomeSpotType, $moveAction)
            return $true
        }
        return $false
    }

    [bool] MoveDown([SpotType]$becomeSpotType, [MoveAction]$moveAction, [bool]$askedByPartner)
    {
        if ([SpotType]::Wall  -eq $this.SpotType) { return $false }
        if ([SpotType]::Empty -eq $this.SpotType -or `
            ($this.IsBox() -and (-not $askedByPartner) -and `
                $this.BelowSpot.MoveDown($this.SpotType, $moveAction, $false) -and `
                $this.GetPartnerSpot().MoveDown([SpotType]::Empty, $moveAction, $true)) -or `
            ((-not $this.IsBox() -or $askedByPartner) -and `
                $this.BelowSpot.MoveDown($this.SpotType, $moveAction, $false)))
        {
            $this.MakeMove($becomeSpotType, $moveAction)
            return $true
        }
        return $false
    }

    [bool] MoveLeft([SpotType]$becomeSpotType, [MoveAction]$moveAction)
    {
        if ([SpotType]::Wall  -eq $this.SpotType) { return $false }
        if ([SpotType]::Empty -eq $this.SpotType -or `
            $this.LeftSpot.MoveLeft($this.SpotType, $moveAction))
        {
            $this.MakeMove($becomeSpotType, $moveAction)
            return $true
        }
        return $false
    }

    [bool] MoveRight([SpotType]$becomeSpotType, [MoveAction]$moveAction)
    {
        if ([SpotType]::Wall  -eq $this.SpotType) { return $false }
        if ([SpotType]::Empty -eq $this.SpotType -or `
            $this.RightSpot.MoveRight($this.SpotType, $moveAction))
        {
            $this.MakeMove($becomeSpotType, $moveAction)
            return $true
        }
        return $false
    }

    [int] GPS()
    {
        if ([SpotType]::BoxLeftPart -eq $this.SpotType)
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
        if ([char]'O' -eq $char) { $char = '[' }
        $grid[$y] += [Spot]::new($x, $y, $char)
        $x += 1

        if ([char]'[' -eq $char) { $char = ']' }
        elseif ([char]'@' -eq $char) { $char = '.' }
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
            '^' {   if ($robot.MoveUp([SpotType]::Empty, [MoveAction]::Stay, $false))
                    { $null = $robot.MoveUp([SpotType]::Empty, [MoveAction]::Move, $false) }
                    break 
                }
            'v' {   if ($robot.MoveDown([SpotType]::Empty, [MoveAction]::Stay, $false))
                    { $null = $robot.MoveDown([SpotType]::Empty, [MoveAction]::Move, $false) }
                    break 
                }
            '<' {   if ($robot.MoveLeft([SpotType]::Empty, [MoveAction]::Stay))
                    { $null = $robot.MoveLeft([SpotType]::Empty, [MoveAction]::Move) }
                    break 
                }
        default {   if ($robot.MoveRight([SpotType]::Empty, [MoveAction]::Stay))
                    { $null = $robot.MoveRight([SpotType]::Empty, [MoveAction]::Move) }
                    break 
                }
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

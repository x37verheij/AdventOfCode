#2024 day21b
Set-StrictMode -Version Latest
$file = Get-Content 'day21b.txt'

## General
$levelsDeep = 25

enum Action {
    Up = 0
    Left = 1
    Down = 2
    Right = 3
    Press = 4
}

function getKey([byte]$a, [byte]$b) {
    return ($a -shl 4) + $b
}

function getBlockKey([byte[]]$block) {
    [int32]$res = 0 # Longest path is from A to 7 with 6 actions. (6 * 4) bits fit in 32 bit int
    foreach ($i in 0..($block.Count - 1)) {
        $res += [int32]$block[$i] -shl (4 * $i) # Last byte is always 4 (Press), must be MSB
    }
    return $res
}

function calcActions($dx, $dy, [switch]$swapPriorities) {
    $actions = @()

    if ($swapPriorities) {
        if ($dx -gt 0) { $actions += (@([Action]::Right) * $dx) }
        if ($dy -gt 0) { $actions += (@([Action]::Down) * $dy) }
        if ($dy -lt 0) { $actions += (@([Action]::Up) * -$dy) }
        if ($dx -lt 0) { $actions += (@([Action]::Left) * -$dx) }
    } else { # See day 21a for how to find these priorities.
        if ($dx -lt 0) { $actions += (@([Action]::Left) * -$dx) }
        if ($dy -lt 0) { $actions += (@([Action]::Up) * -$dy) }
        if ($dy -gt 0) { $actions += (@([Action]::Down) * $dy) }
        if ($dx -gt 0) { $actions += (@([Action]::Right) * $dx) }
    }
    return $actions + @([Action]::Press)
}

## Prepare numpads
$numericNumpad     = [System.Collections.Generic.Dictionary[byte, Action[]]]::new() # 0x0..0xA
$directionalNumpad = [System.Collections.Generic.Dictionary[byte, Action[]]]::new() # [Action]

foreach ($from in [byte[]](0x0..0xA)) { # Numeric
    foreach ($to in [byte[]](0x0..0xA)) {
        $colfrom = ($from + 1 + [bool]($from % 10)) % 3
        $colto   = ($to   + 1 + [bool]($to   % 10)) % 3
        $rowfrom = 3 - [System.Math]::Ceiling(($from % 10) / 3)
        $rowto   = 3 - [System.Math]::Ceiling(($to   % 10) / 3)
        $dx      = $colto - $colfrom
        $dy      = $rowto - $rowfrom

        # Algorithm prioritizes left over up and down over right. Avoid passing non-button space!
        if ((0 -eq $colFrom -and 3 -eq $rowTo) -or (3 -eq $rowFrom -and 0 -eq $colTo)) {
            $numericNumpad.Add((GetKey $from $to), (calcActions $dx $dy -swapPriorities))
        } else {
            $numericNumpad.Add((GetKey $from $to), (calcActions $dx $dy))
        }
    }
}

foreach ($from in [Action].GetEnumValues()) { # Directional
    foreach ($to in [Action].GetEnumValues()) {
        $colfrom = ($from + 1 + [bool]($from % 4)) % 3
        $colto   = ($to   + 1 + [bool]($to   % 4)) % 3
        $rowfrom = [bool]($from % 4)
        $rowto   = [bool]($to   % 4)
        $dx      = $colto - $colfrom
        $dy      = $rowto - $rowfrom

        # Algorithm prioritizes left over down and up over right. Avoid passing non-button space!
        if ((0 -eq $colFrom -and 0 -eq $rowTo) -or (0 -eq $rowFrom -and 0 -eq $colTo)) {
            $directionalNumpad.Add((GetKey $from $to), (calcActions $dx $dy -swapPriorities))
        } else {
            $directionalNumpad.Add((GetKey $from $to), (calcActions $dx $dy))
        }
    }
}

## Define cache and recursive function
$cache = [System.Collections.Generic.Dictionary[byte,
          System.Collections.Generic.Dictionary[int32,int64]]]::new() # [levelsdeep]=dict
foreach ($i in 1..$levelsDeep) {
    $cache[$i] = [System.Collections.Generic.Dictionary[int32,int64]]::new() # [blockKey]=length
}

function processBlock([byte[]]$block, [byte]$levelsDeep) {
    if ($levelsDeep -lt 1) { return $block.Count }
    $blockKey = getBlockKey $block
    if ($cache[$levelsDeep][$blockKey]) { return $cache[$levelsDeep][$blockKey] }

    [int64]$res = 0
    [byte]$prevAction = [Action]::Press
    foreach ($action in $block) {
        $res += processBlock ($directionalNumpad[(Getkey $prevAction $action)]) ($levelsDeep - 1)
        [byte]$prevAction = $action
    }

    $cache[$levelsDeep][$blockKey] = $res
    return $res
}

## Execute: process all blocks
$sum = 0
foreach ($line in $file) {
    $prevNum = [byte]0xA
    $subsum = 0
    foreach ($char in $line.ToCharArray()) {
        [byte]$num = "0x$char"
        $subsum += processBlock ($numericNumpad[(Getkey $prevNum $num)]) -levelsDeep $levelsDeep
        $prevNum = $num
    }
    $factor = [int]$line.Substring(0, 3)
    $product = $subsum * $factor
    $sum += $product
    "$line = $factor * $subsum = $product"
}

$sum

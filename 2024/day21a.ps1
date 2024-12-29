#2024 day21a
Set-StrictMode -Version Latest
$file = Get-Content 'day21a.txt'

enum Action
{
    Up = 0
    Left = 1
    Down = 2
    Right = 3
    Press = 4
}

class MyQueue
{
    $q = [System.Collections.Generic.Queue[Action]]::new(100)
    MyQueue() {}
    [void] EnqueueAll([Action[]]$collection) {
        foreach ($action in $collection) {
            $this.q.Enqueue($action)
        }
    }
    [string] ToString() {
        return "Length=$($this.q.Count), Actions=$(($this.q.GetEnumerator() | ForEach-Object {
            if ([Action]::Up -eq $_) {'^'}
            elseif ([Action]::Down -eq $_) {'v'}
            elseif ([Action]::Left -eq $_) {'<'}
            elseif ([Action]::Right -eq $_) {'>'}
            else { 'A' }
        }) -join '')"
    }
}

function getKey([byte]$a, [byte]$b)
{
    return ($a -shl 4) + $b
}

<# Cost check
$h = @{}
$h["ADownLeft"]       = [MyQueue]::new(); $h.ADownLeft.EnqueueAll(      @([Action]::Down, [Action]::Left, [Action]::Press))
$h["ALeftDown"]       = [MyQueue]::new(); $h.ALeftDown.EnqueueAll(      @([Action]::Left, [Action]::Down, [Action]::Press))
$h["BDownRight"]      = [MyQueue]::new(); $h.BDownRight.EnqueueAll(     @([Action]::Down, [Action]::Right,[Action]::Press))
$h["BRightDown"]      = [MyQueue]::new(); $h.BRightDown.EnqueueAll(     @([Action]::Right,[Action]::Down, [Action]::Press))
$h["CUpLeft"]         = [MyQueue]::new(); $h.CUpLeft.EnqueueAll(        @([Action]::Up,   [Action]::Left, [Action]::Press))
$h["CLeftUp"]         = [MyQueue]::new(); $h.CLeftUp.EnqueueAll(        @([Action]::Left, [Action]::Up,   [Action]::Press))
$h["DUpRight"]        = [MyQueue]::new(); $h.DUpRight.EnqueueAll(       @([Action]::Up,   [Action]::Right,[Action]::Press))
$h["DRightUp"]        = [MyQueue]::new(); $h.DRightUp.EnqueueAll(       @([Action]::Right,[Action]::Up,   [Action]::Press))
$h["EDownDownLeft"]   = [MyQueue]::new(); $h.EDownDownLeft.EnqueueAll(  @([Action]::Down, [Action]::Down, [Action]::Left, [Action]::Press))
$h["ELeftDownDown"]   = [MyQueue]::new(); $h.ELeftDownDown.EnqueueAll(  @([Action]::Left, [Action]::Down, [Action]::Down, [Action]::Press))
$h["FDownDownRight"]  = [MyQueue]::new(); $h.FDownDownRight.EnqueueAll( @([Action]::Down, [Action]::Down, [Action]::Right,[Action]::Press))
$h["FRightDownDown"]  = [MyQueue]::new(); $h.FRightDownDown.EnqueueAll( @([Action]::Right,[Action]::Down, [Action]::Down, [Action]::Press))
$h["GLeftLeftDown"]   = [MyQueue]::new(); $h.GLeftLeftDown.EnqueueAll(  @([Action]::Left, [Action]::Left, [Action]::Down, [Action]::Press))
$h["GDownLeftLeft"]   = [MyQueue]::new(); $h.GDownLeftLeft.EnqueueAll(  @([Action]::Down, [Action]::Left, [Action]::Left, [Action]::Press))
$h["HLeftLeftUp"]     = [MyQueue]::new(); $h.HLeftLeftUp.EnqueueAll(    @([Action]::Left, [Action]::Left, [Action]::Up,   [Action]::Press))
$h["HUpLeftLeft"]     = [MyQueue]::new(); $h.HUpLeftLeft.EnqueueAll(    @([Action]::Up,   [Action]::Left, [Action]::Left, [Action]::Press))
$h["IUpUpLeft"]       = [MyQueue]::new(); $h.IUpUpLeft.EnqueueAll(      @([Action]::Up,   [Action]::Up,   [Action]::Left, [Action]::Press))
$h["ILeftUpUp"]       = [MyQueue]::new(); $h.ILeftUpUp.EnqueueAll(      @([Action]::Left, [Action]::Up,   [Action]::Up,   [Action]::Press))
$h["JUpUpRight"]      = [MyQueue]::new(); $h.JUpUpRight.EnqueueAll(     @([Action]::Up,   [Action]::Up,   [Action]::Right,[Action]::Press))
$h["JRightUpUp"]      = [MyQueue]::new(); $h.JRightUpUp.EnqueueAll(     @([Action]::Right,[Action]::Up,   [Action]::Up,   [Action]::Press))
$h["KRightRightUp"]   = [MyQueue]::new(); $h.KRightRightUp.EnqueueAll(  @([Action]::Right,[Action]::Right,[Action]::Up,   [Action]::Press))
$h["KUpRightRight"]   = [MyQueue]::new(); $h.KUpRightRight.EnqueueAll(  @([Action]::Up,   [Action]::Right,[Action]::Right,[Action]::Press))
$h["LRightRightDown"] = [MyQueue]::new(); $h.LRightRightDown.EnqueueAll(@([Action]::Right,[Action]::Right,[Action]::Down, [Action]::Press))
$h["LDownRightRight"] = [MyQueue]::new(); $h.LDownRightRight.EnqueueAll(@([Action]::Down, [Action]::Right,[Action]::Right,[Action]::Press))

foreach ($q in ($h.Keys | Sort-Object)) {
    $script:queue = $h[$q]
    foreach ($_ in 1..5) { robotLoop }
    "Length=$($queue.q.Count) for $q"
}
# first conclusion: w/o A-Presses, always start with  Up  and end with Down.
# Conclusion: Including A-Presses, always start with Left and end with Right.
#>
function calcActions($dx, $dy, [switch]$swapPriorities) {
    $actions = @()

    if ($swapPriorities) {
        if ($dx -gt 0) { $actions += (@([Action]::Right) * $dx) }
        if ($dy -gt 0) { $actions += (@([Action]::Down) * $dy) }
        if ($dy -lt 0) { $actions += (@([Action]::Up) * -$dy) }
        if ($dx -lt 0) { $actions += (@([Action]::Left) * -$dx) }
    } else {
        if ($dx -lt 0) { $actions += (@([Action]::Left) * -$dx) }
        if ($dy -lt 0) { $actions += (@([Action]::Up) * -$dy) }
        if ($dy -gt 0) { $actions += (@([Action]::Down) * $dy) }
        if ($dx -gt 0) { $actions += (@([Action]::Right) * $dx) }
    }
    return $actions + @([Action]::Press)
}

function robotLoop() {
    $prevQueue = $queue
    $script:queue = [MyQueue]::new()
    [byte]$prevNum = [Action]::Press
    foreach ($action in $prevQueue.q.GetEnumerator()) {
        $queue.EnqueueAll($directionalNumpad[(Getkey $prevNum $action)])
        $prevNum = $action
    }
    $queue.ToString()
}

<# The Dictionary<TKey,TValue> class has the same functionality as the Hashtable class.
A Dictionary<TKey,TValue> of a specific type (other than Object) provides better performance
than a Hashtable for value types. This is because the elements of Hashtable are of type Object;
therefore, boxing and unboxing typically occur when you store or retrieve a value type.
Bron: https://learn.microsoft.com/en-us/dotnet/standard/collections/hashtable-
and-dictionary-collection-types
#>
$numericNumpad     = [System.Collections.Generic.Dictionary[byte, Action[]]]::new() # 0x0..0xA
$directionalNumpad = [System.Collections.Generic.Dictionary[byte, Action[]]]::new() # [Action]

<# define all combinations for numeric numpad: 
| 7 | 8 | 9 |
| 4 | 5 | 6 |
| 1 | 2 | 3 |
    | 0 | A |  -- 0xA = 10
Key is [(4bit from << 4) plus (4bit to)]; Value is @(bytes to press)#>
foreach ($from in [byte[]](0x0..0xA)) {
    foreach ($to in [byte[]](0x0..0xA)) {
        $colfrom = ($from + 1 + [bool]($from % 10)) % 3
        $colto   = ($to   + 1 + [bool]($to   % 10)) % 3
        $rowfrom = 3 - [System.Math]::Ceiling(($from % 10) / 3)
        $rowto   = 3 - [System.Math]::Ceiling(($to   % 10) / 3)
        $dx      = $colto - $colfrom
        $dy      = $rowto - $rowfrom

        # Algorithm prioritizes left over up and down over right. Avoid passing non-button space!!
        if ((0 -eq $colFrom -and 3 -eq $rowTo) -or (3 -eq $rowFrom -and 0 -eq $colTo)) {
            $numericNumpad.Add((GetKey $from $to), (calcActions $dx $dy -swapPriorities))
        } else {
            $numericNumpad.Add((GetKey $from $to), (calcActions $dx $dy))
        }
    }
}

<# define all combinations for directional numpad: 
        | ^ = 0 | A = 4 |
| < = 1 | v = 2 | > = 3 |
Key is [(4bit from << 4) plus (4bit to)]; Value is @(bytes to press)#>
foreach ($from in [Action].GetEnumValues()) {
    foreach ($to in [Action].GetEnumValues()) {
        $colfrom = ($from + 1 + [bool]($from % 4)) % 3
        $colto   = ($to   + 1 + [bool]($to   % 4)) % 3
        $rowfrom = [bool]($from % 4)
        $rowto   = [bool]($to   % 4)
        $dx      = $colto - $colfrom
        $dy      = $rowto - $rowfrom

        # Algorithm prioritizes left over down and up over right. Avoid passing non-button space!!
        if ((0 -eq $colFrom -and 0 -eq $rowTo) -or (0 -eq $rowFrom -and 0 -eq $colTo)) {
            $directionalNumpad.Add((GetKey $from $to), (calcActions $dx $dy -swapPriorities))
        } else {
            $directionalNumpad.Add((GetKey $from $to), (calcActions $dx $dy))
        }
    }
}

# $numericNumpad[(GetKey 0xA 9)]
$sum = 0

foreach ($line in $file) {
    $queue = [MyQueue]::new()
    [byte]$prevNum = 0xA
    $line
    
    # Robot 1
    foreach ($char in $line.ToCharArray()) {
        [byte]$num = "0x$char"
        $queue.EnqueueAll($numericNumpad[(Getkey $prevNum $num)])
        $prevNum = $num
    }
    $queue.ToString()
    
    # 2 more robots
    foreach ($i in 1..2) {
        robotLoop
    }
    $subsum = ($queue.q.Count * ([int]$line.Substring(0, 3)))
    $subsum
    $sum += $subsum
    "--------"
}

$sum

#2024 day25a
Set-StrictMode -Version Latest

# Create new line before first line in file!
$file = Get-Content 'day25a.txt'

$MAX_PIN_HEIGHT = 5 # Height of the key/lock
$PINS = 5           # Length of the key/Depth of the lock
$ITEM_INTERVAL = 8  # Lines to next item
$SOLID = [char]'#'  # Character used to define keys/locks in file

class Key {
    [byte[]]$pinHeights
    Key($pinHeights) { $this.pinHeights = $pinHeights }
}

class Lock {
    [byte[]]$pinHeights
    Lock($pinHeights) { $this.pinHeights = $pinHeights }
    [bool]fitsKey([Key]$key) {
        foreach ($i in 0..($Script:PINS - 1)) {
            if ($this.pinHeights[$i] + $key.pinHeights[$i] -gt $Script:MAX_PIN_HEIGHT) {
                return $false
            }
        }
        return $true
    }
}

$keys = [System.Collections.Generic.Queue[Key]]::new(250)
$locks = [System.Collections.Generic.Queue[Lock]]::new(250)
$lineNumber = 0
while ($lineNumber -lt $file.Count)
{
    $firstLine, $lines = $file[($lineNumber + 1)..($lineNumber + $ITEM_INTERVAL - 2)]
    $pinHeights = @(0) * $PINS
    foreach ($line in $lines) {
        foreach ($i in 0..($PINS - 1)) {
            if ($line[$i] -eq $SOLID) { $pinHeights[$i] += 1 }
        }
    }
    if ($firstLine[0] -eq $SOLID) { # lock
        $locks.Enqueue([Lock]::new($pinHeights))
    } else { # key
        $keys.Enqueue([Key]::new($pinHeights))
    }
    $lineNumber += $ITEM_INTERVAL
}

$sum = 0
foreach ($lock in $locks) {
    foreach ($key in $keys) {
        if ($lock.fitsKey($key)) { $sum += 1 }
    }
}

$sum

#2024 day17b
Set-StrictMode -Version Latest
$file = Get-Content 'day17b.txt'

function conv([int64]$number) { [System.Convert]::ToString($number, 2) -replace '(\d)(?=(\d{3})+$)', '$1 ' }

# Parse input
$_A, $_B, $_C, $_, $_P = $file
[int64]$RA = 0 # every combination seems to exists back to front, except the 4 digit variant. 12691 produces the last 5 digits.
[int64]$RB = ($_B.split(' ')[2])
[int64]$RC = ($_C.split(' ')[2])
[byte[]]$P = ($_P.Substring(9).split(',')) # program

$resultString = $_P.Substring(9).replace(',', '')
$instrP = 0 # instruction pointer of program
$prevRA = $RA

function restart() {
    $Script:instrP = 0
    $Script:prevRA += 1
    $Script:RA = $prevRA
}

# Define operations
function operate([byte]$opcode, [byte]$operand) {
    switch ($operand) {
        4 { $comboOperand = $RA; break }
        5 { $comboOperand = $RB; break }
        6 { $comboOperand = $RC; break }
        default { $comboOperand = $operand }
    }
    switch ($opcode) {
        0 { $Script:RA = [int64][Math]::Truncate($RA / [Math]::Pow(2, $comboOperand)); break }
        1 { $Script:RB = $RB -bxor $operand; break }
        2 { $Script:RB = $comboOperand % 8; break }
        3 { if ($RA) { $Script:instrP = $operand; return }; break }
        4 { $Script:RB = $RB -bxor $RC; break }
        5 { $Script:instrP += 2; return ($comboOperand % 8); }
        6 { $Script:RB = [int64][Math]::Truncate($RA / [Math]::Pow(2, $comboOperand)); break }
        default { $Script:RC = [int64][Math]::Truncate($RA / [Math]::Pow(2, $comboOperand)) }
    }
    $Script:instrP += 2
}

# Operate
while ($true) {
    $output = ""
    while ($instrP -lt $resultString.Length - 1) {
        $resp = operate -opcode $P[$instrP] -operand $P[$instrP + 1]
        if ($null -ne $resp) {
           $output += "$resp"
        }
    }
    if ($output -eq $resultString.Substring($resultString.Length - $output.Length)) {
        Write-Host "$($output -join ',') was produced with RA = $prevRA"
        if ($output.Length -ge $resultString.Length) { break }
        $Script:prevRA *= 8
        $Script:prevRA -= 1 # Due to following restart
    }
    restart
}

$prevRA

<#
Update: 1-7 in RA produces 1 output, 8-63 in RA produces 2, etc..
        For output of length 16, you hence need an RA between 8^15 and 8^16...
        If X marks a change in output, then the following bits influence that output number:
for input RA of 10 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0001   (8^15 + 1)     =  X,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
for input RA of 10 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0010   (8^15 + 2)     =  X,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
for input RA of 10 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0100   (8^15 + 4)     =  X,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
for input RA of 10 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 1000   (8^15 + 8)     =  X,X,_,_,_,_,_,_,_,_,_,_,_,_,_,_
for input RA of 10 0000 0000 0000 0000 0000 0000 0000 0000 0000 0001 0000   (8^15 + 16)    =  X,X,_,_,_,_,_,_,_,_,_,_,_,_,_,_
for input RA of 10 0000 0000 0000 0000 0000 0000 0000 0000 0000 0010 0000   (8^15 + 32)    =  X,X,_,_,_,_,_,_,_,_,_,_,_,_,_,_
for input RA of 10 0000 0000 0000 0000 0000 0000 0000 0000 0000 0100 0000   (8^15 + 64)    =  X,X,X,_,_,_,_,_,_,_,_,_,_,_,_,_
for input RA of 10 0000 0000 0000 0000 0000 0000 0000 0000 0000 1000 0000   (8^15 + 128)   =  X,X,X,_,_,_,_,_,_,_,_,_,_,_,_,_
for input RA of 10 0000 0000 0000 0000 0000 0000 0000 0000 0001 0000 0000   (8^15 + 256)   =  X,X,X,_,_,_,_,_,_,_,_,_,_,_,_,_
for input RA of 10 0000 0000 0000 0000 0000 0000 0000 0000 0010 0000 0000   (8^15 + 512)   =  _,X,X,X,_,_,_,_,_,_,_,_,_,_,_,_
for input RA of 10 0000 0000 0000 0000 0000 0000 0000 0000 0100 0000 0000   (8^15 + 1024)  =  _,X,X,X,_,_,_,_,_,_,_,_,_,_,_,_
for input RA of 10 0000 0000 0000 0000 0000 0000 0000 0000 1000 0000 0000   (8^15 + 2048)  =  _,X,X,X,_,_,_,_,_,_,_,_,_,_,_,_
for input RA of 10 0000 0000 0000 0000 0000 0000 0000 0001 0000 0000 0000   (8^15 + 4096)  =  _,_,X,X,X,_,_,_,_,_,_,_,_,_,_,_
for input RA of 10 0000 0000 0000 0000 0000 0000 0000 0010 0000 0000 0000   (8^15 + 8192)  =  _,_,X,X,X,_,_,_,_,_,_,_,_,_,_,_
for input RA of 10 0000 0000 0000 0000 0000 0000 0000 0100 0000 0000 0000   (8^15 + 16384) =  _,_,X,X,X,_,_,_,_,_,_,_,_,_,_,_
for input RA of 10 0000 0000 0000 0000 0000 0000 0000 1000 0000 0000 0000   (8^15 + 32768) =  _,_,_,X,X,X,_,_,_,_,_,_,_,_,_,_
etc...
        So, for a random number between 8^15 and 8^16, if you only change the 10th, 11th and 12th bits (512, 1024, 2048),
        You'll only change the 2nd, 3rd and 4th output numbers.
        This way, if you have found the value between 64 and 511 that produces the correct first three output numbers,
        Then start incrementing RA with 512 (8^3), untill you find the correct 2nd, 3rd and 4th output numbers.
        When that's the case, start incrementing with 4096 (8^4) and so on.
Update: Does not work. The first occurrence of the first 3 output numbers is found at RA = 777, which has a 4 digit output already.
        Why would it work differently when traversing back to front? It does, but... why?
Update: It appears to be, because I would stop at the first digit and then increment by factor 8. (So, 1, 9, 17, etc.)
        Although there are 7 values of RA that produce an output of 1 digit, they don't all produce different ones.
        Although there is one value in [1-7] that produces an output starting with 2 (it's 1), it is not the case with greater inputs.
        The first output digit is influenced by the first 9 bits and there are actually 41 inputs with a 3 digit output starting with 2.
        Only 6 of the 41 have a 0b001 in the lowest three bits (meaning multiples of 2^3, + 1), of which the lowest is 129.
        The lowest possible starting value that produces an output starting with a 2, is actually 126 (0b0111 1110)...
        Since I locked my search on the 1, it will always be higher than the actual output.
#>

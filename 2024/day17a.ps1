#2024 day17a
Set-StrictMode -Version Latest
$file = Get-Content 'day17a.txt'

# Parse input
$_A, $_B, $_C, $_, $_P = $file
[int64]$RA = ($_A.split(' ')[2])
[int64]$RB = ($_B.split(' ')[2])
[int64]$RC = ($_C.split(' ')[2])
[byte[]]$P = ($_P.Substring(9).split(','))

$instr = 0
$halt = $P.Count # halt program if $instr passes last instruction/eof

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
        3 { if ($RA) { $Script:instr = $operand; return }; break }
        4 { $Script:RB = $RB -bxor $RC; break }
        5 { Write-Host "$($comboOperand % 8)," -ForegroundColor Red -NoNewline; break }
        6 { $Script:RB = [int64][Math]::Truncate($RA / [Math]::Pow(2, $comboOperand)); break }
        default { $Script:RC = [int64][Math]::Truncate($RA / [Math]::Pow(2, $comboOperand)) }
    }
    $Script:instr += 2
}

# Operate
while ($instr -lt $halt) {
    operate -opcode $P[$instr] -operand $P[$instr + 1]
}

Write-Host "`nRemove trailing comma!" -ForegroundColor Green

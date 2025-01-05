#2024 day23a
Set-StrictMode -Version Latest
$file = Get-Content 'day23a.txt'

$map = @{}
$groupsFound = New-Object System.Collections.Generic.HashSet[string] 1500

# Read input
foreach ($line in $file) {
    $pc1, $pc2 = $line.Split('-')
    if (-not $map[$pc1]) { $map[$pc1] = @() } # create entry
    if (-not $map[$pc2]) { $map[$pc2] = @() } # create entry
    $map[$pc1] += $pc2
    $map[$pc2] += $pc1
}

# Find groups of three, start searching at computers with a t
foreach ($pc1 in ($map.Keys | Where-Object { $_ -like 't*' })) {
    foreach ($pc2 in ($map[$pc1])) {
        foreach ($pc3 in ($map[$pc2])) {
            if ($pc1 -in $map[$pc3]) {
                $groupsFound.Add((@($pc1, $pc2, $pc3) | Sort-Object) -join '') | Out-Null
            }
        }
    }
}

$groupsFound
$groupsFound.Count

#2024 day23b
Set-StrictMode -Version Latest
$file = Get-Content 'day23b.txt'

$map = @{}
$groupsFound = [System.Collections.Generic.Dictionary[byte, System.Collections.Generic.HashSet[string]]]::new()

# Read input
foreach ($line in $file) {
    $pc1, $pc2 = $line.Split('-')
    if (-not $map[$pc1]) { $map[$pc1] = @() } # create entry
    if (-not $map[$pc2]) { $map[$pc2] = @() } # create entry
    $map[$pc1] += $pc2
    $map[$pc2] += $pc1
}

# Find groups of three, start searching at computers with a t
$groupSize = 3
$groupsFound[$groupSize] = New-Object System.Collections.Generic.HashSet[string] 1500
foreach ($pc1 in ($map.Keys | Where-Object { $_ -like 't*' })) {
    foreach ($pc2 in ($map[$pc1])) {
        foreach ($pc3 in ($map[$pc2])) {
            if ($pc1 -in $map[$pc3]) {
                $key = (@($pc1, $pc2, $pc3) | Sort-Object) -join ','
                if ($groupsFound[$groupSize].Add($key)) {
                    # Write-Host $key
                }
            }
        }
    }
}

# As long as we find new groups, try to find bigger groups
do {
    Write-Host "$($groupsFound[$groupSize].Count) groups found with size $groupSize"
    $groupSize += 1
    $groupsFound[$groupSize] = New-Object System.Collections.Generic.HashSet[string]

    foreach ($group in $groupsFound[$groupSize - 1]) {
        $pc1, $list = $group.Split(',')
        foreach ($pc2 in ($map[$pc1])) {
            if ($pc2 -notin $list) {
                $newGroupFound = $true
                foreach ($grouppc in $list) {
                    if ($pc2 -notin $map[$grouppc]) {
                        $newGroupFound = $false
                        break
                    }
                }
                if ($newGroupFound) {
                    $key = ((@($pc1, $pc2) + $list) | Sort-Object) -join ','
                    if ($groupsFound[$groupSize].Add($key)) {
                        # Write-Host $key
                    }
                }
            }
        }
    }
} while ($groupsFound[$groupSize].Count)

$groupsFound[$groupSize - 1]

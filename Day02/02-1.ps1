$data = Get-Content -Path "$PSScriptRoot\input.txt"

$MaxCubes = @(
    @{ Color = "red"; Amount = 12 }, 
    @{ Color = "green"; Amount = 13 }, 
    @{ Color = "blue"; Amount = 14 }
)
$total = 0
foreach ($line in $data) {
    
    $null = $line -match 'Game (\d+)'
    $gameNumber = $matches[1]
    
    $line = $line -replace 'Game $($gameNumber): '
    $line = $line -replace ";", ","
    $cubes = $line -split ","

    $addToTotal = $true
    foreach ($cube in $cubes) {
        $null = $cube -match '(\d+?) (\w+)'
        [int]$amount = $matches[1]
        $color = $matches[2]
        if ($amount -gt ($MaxCubes | Where-Object { $_.Color -eq $color }).Amount) {
            Write-Host "Game $gameNumber has too many $color cubes ($amount); max is $($maxCube.Amount)"
            $addToTotal = $false
            break
        }
    }

    if ($addToTotal) {
        $total += $gameNumber
    }
}
$total
$data = Get-Content -Path "$PSScriptRoot\input.txt"

$total = 0
foreach ($line in $data) {
    
    $null = $line -match 'Game (\d+)'
    $gameNumber = $matches[1]
    
    $line = $line -replace 'Game $($gameNumber): '
    $line = $line -replace ";", ","
    $cubes = $line -split ","

    $structuredCubes = @()
    foreach ($cube in $cubes) {
        $null = $cube -match '(\d+?) (\w+)'
        $structuredCubes += @{ Color = $matches[2]; Amount = [int]$matches[1] }
    }

    $maxAmounts = $structuredCubes | Group-Object -Property Color | ForEach-Object { $_.Group | Sort-Object -Property Amount -Descending | Select-Object -First 1 }
    $maxAmount = ($maxAmounts | ForEach-Object { $_.Amount }) -join "*"
    $maxAmount = Invoke-Expression $maxAmount
    $total += $maxAmount
}
$total
$data = Get-Content -Path "$PSScriptRoot\sampleinput.txt"

$MaxCubes = @(
    @{ Color = "red"; Amount = 12 }, 
    @{ Color = "green"; Amount = 13 }, 
    @{ Color = "blue"; Amount = 14 }
)
$total = 0
foreach ($line in $data) {
    $addToTotal = $true
    $null = $line -match 'Game (\d+?)'
    $gameNumber = $matches[1]
    
    $line = $line -replace 'Game $($gameNumber): '
    $line = $line -replace ";", ","
    $rawcubes = $line -split ","
    # The cubes array contains strings where the number is the amount of cubes
    # and the string is the color of the cubes. We need to split them up and put them into a variable that we can query
    $cubes = @()
    $rawcubes | ForEach-Object {
        $null = $_ -match '(\d+?) (\w+)'
        $amount = $matches[1]
        $color = $matches[2]
        $cubes += [PSCustomObject]@{
            Amount = $amount
            Color = $color
        }
    }
    
    # Check if there is an amount of cubes that exceeds the maximum amount of cubes
    foreach ($cube in $cubes) {
        # Get max cube for color of current cube
        $maxCube = $MaxCubes | Where-Object { $_.Color -eq $cube.Color }

        # if cube amount is greater than max cube amount, don't add to total
        if ($cube.Amount -gt $maxCube.Amount) {
            Write-Host "Game $gameNumber has too many $($cube.Color) cubes ($($cube.Amount)); max is $($maxCube.Amount)"
            $addToTotal = $false
            break
        }
    }

    if ($addToTotal) {
        $total += $gameNumber
    }
}
$total
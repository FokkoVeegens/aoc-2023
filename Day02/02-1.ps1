$data = Get-Content -Path "$PSScriptRoot\sampleinput.txt"

foreach ($line in $data) {
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
    Write-Host "Game number $gameNumber : $cubes"
}
# Sample input:
$data = Get-Content -Path "$PSScriptRoot\sampleinput.txt"

# Match all numbers that consist of 1 or more digits and put them in an array with their coordinates
$lineNo = 0
foreach ($line in $data) {
    $result = [regex]::Matches($line, '\d+')
    $numbers = foreach ($match in $result) {
        [PSCustomObject]@{
            Number = $match.Value
            X = $match.Index
            Y = $lineNo
        }
    }
    $lineNo++
}

# Match all characters except the . and put them in an array with their coordinates
$lineNo = 0
foreach ($line in $data) {
    $result = [regex]::Matches($line, '[\d\#]')
    $characters = foreach ($match in $result) {
        if ([string]::IsNullOrWhiteSpace($match.Value)) {
            continue
        }
        [PSCustomObject]@{   
            Value = $match.Value
            X = $match.Index
            Y = $lineNo
        }
    }
    $lineNo++
}
$characters
exit
# Loop the numbers and add them up, only if there is a character around it in all directions
$sum = 0
foreach ($number in $numbers) {
    # Check row above the number along the length of the number
    $rowAbove = $characters | Where-Object { `
        $_.Y -eq $number.Y - 1 `
        -and $_.X -ge $number.X - 1 `
        -and $_.X -lt $number.X + $number.Number.Length + 1 }
    
    # Check row below the number along the length of the number
    $rowBelow = $characters | Where-Object { `
        $_.Y -eq $number.Y + 1 `
        -and $_.X -ge $number.X - 1 `
        -and $_.X -lt $number.X + $number.Number.Length + 1 }

    # Check if there is a character left or right of the number
    $leftright = $characters | Where-Object { `
        $_.Y -eq $number.Y `
        -and ($_.X -eq $number.X - 1 -or $_.X -eq $number.X + $number.Number.Length)
    }
    Write-Host "$number.Number: $rowAbove $rowBelow $leftright"
    if ($rowAbove -or $rowBelow -or $leftright) {
        $sum += $number.Number
        continue
    }
}
$sum
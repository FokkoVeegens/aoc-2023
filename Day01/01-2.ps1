$data = Get-Content -Path "$PSScriptRoot\input.txt"

$numberMap = @{
    'one' = '1'
    'two' = '2'
    'three' = '3'
    'four' = '4'
    'five' = '5'
    'six' = '6'
    'seven' = '7'
    'eight' = '8'
    'nine' = '9'
}

$sum = 0
foreach ($line in $data) {
    [string]$firstDigit = $null
    if ($line -match "^\d.*") {
        # nothing to do because first character is a digit
        $firstDigit = $line[0]
    }
    else {
        # Search for the first number word or numeric character in the line (wichever comes first)
        $firstDigit = $line -replace ".*?(\d|one|two|three|four|five|six|seven|eight|nine).*", '$1'

        # If the first digit is a word, convert it to a number
        if ($firstDigit -in $numberMap.Keys) {
            $firstDigit = $numberMap[$firstDigit]
        }
    }

    [string]$lastDigit = $null
    if ($line -match ".*\d$") {
        # nothing to do because last character is a digit
        $lastDigit = $line[-1]
    }
    else {
        for ($i = $line.Length - 1; $i -ge 0; $i--) {
            $lastDigit = $line.Substring($i)
            if ($lastDigit -match '(\d|one|two|three|four|five|six|seven|eight|nine)') {
                $lastDigit = $Matches[0]
                break
            }
        }

        # If the last digit is a word, convert it to a number
        if ($lastDigit -in $numberMap.Keys) {
            $lastDigit = $numberMap[$lastDigit]
        }
    }
    $calibrationValue = [int]("$firstDigit$lastDigit")
    $sum += $calibrationValue
}
$sum

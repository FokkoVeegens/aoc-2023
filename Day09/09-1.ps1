$data = Get-Content -Path "$PSScriptRoot\input.txt"

function Get-ExtrapolatedNumber ($line) {
    # Split the line into an array of int numbers by using the space as separator
    $numbers = [int[]]($line -split " ")

    # Determine the differences between the numbers and put them in the next array
    # Keep all arrays in a list
    # loop this until the entire array only inlcudes zeroes and no non-zero numbers
    $differences = @(,$numbers)
    while (($differences[-1] | Measure-Object -Sum).Sum -ne 0) {
        $differences += ,@()
        for ($i = 0; $i -lt $numbers.Length - 1; $i++) {
            $differences[-1] += $numbers[$i + 1] - $numbers[$i]
        }
        $numbers = $differences[-1]
    }
    
    # Extrapolate the next number in the sequence from the last number in the sequence
    # starting with the last array in the list
    $extrapolatedNumber = $differences[-1][-1]
    for ($i = $differences.Count - 2; $i -ge 0; $i--) {
        $extrapolatedNumber += $differences[$i][-1]
    }
    # Return the extrapolated number from the first array in the list
    return $extrapolatedNumber
}

[int]$result = -1
foreach ($line in $data) {
    $result += Get-ExtrapolatedNumber -line $line
}
$result
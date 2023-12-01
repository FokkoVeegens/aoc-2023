$data = Get-Content -Path "$PSScriptRoot\input.txt"

$sum = 0
foreach ($line in $data) {
    $digits = [char[]]$line -match '\d'
    if ($digits) {
        $firstDigit = $digits[0]
        $lastDigit = $digits[-1]
        $calibrationValue = [int]("$firstDigit$lastDigit")
        $sum += $calibrationValue
    }
}
$sum
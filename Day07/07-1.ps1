$data = Get-Content -Path "$PSScriptRoot\input.txt"

# Replace alphanumeric characters with an orderable character
$data = $data -replace "A", "Z"
$data = $data -replace "K", "Y"
$data = $data -replace "Q", "X"
$data = $data -replace "J", "W"
$data = $data -replace "T", "V"

$results = @()
foreach ($line in $data) {
    $handDetails = $line -split " "
    $hand = $handDetails[0] -split "" | Sort-Object | Join-String
    $originalHand = $handDetails[0]

    # Determine type of score
    # Five of a kind
    [int]$scoreType = 0
    if ($hand -match "(\w)\1{4}") {
        $scoreType = 7
    }
    # Four of a kind
    elseif ($hand -match "(\w)\1{3}") {
        $scoreType = 6
    }
    # Full house
    elseif ($hand -match "(\w)\1{2}(\w)\2" -or $hand -match "(\w)\1(\w)\2{2}") {
        $scoreType = 5
    }
    # Three of a kind
    elseif ($hand -match "(\w)\1{2}") {
        $scoreType = 4
    }
    # Two pairs
    elseif ($hand -match "(\w)\1.*(\w)\2") {
        $scoreType = 3
    }
    # One pair
    elseif ($hand -match "(\w)\1") {
        $scoreType = 2
    }
    # High card
    else {
        $scoreType = 1
    }

    $results += [PSCustomObject]@{
        Score = $handDetails[1]
        ScoreType = $scoreType
        Hand = $originalHand
    }
}

# Sort the results by score type, then by score
$results = $results | Sort-Object -Property ScoreType, Hand
$finalScore = 0
$currentHand = 1
foreach ($result in $results) {
    $finalScore += [int]($result.Score) * [int]$currentHand
    $currentHand++
}
Write-Host "Final score: $finalScore"
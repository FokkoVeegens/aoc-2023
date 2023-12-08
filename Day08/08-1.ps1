$data = Get-Content -Path "$PSScriptRoot\input.txt"

$elements = @()
foreach ($line in $data) {
    if ($line -notmatch "=") {
        continue
    }
    # match all three character words in the string and put them into an array
    $elements += [PSCustomObject]@{
        loc = $line.Substring(0, 3)
        left = $line.Substring(7, 3)
        right = $line.Substring(12, 3)
    }
}

# Create a dictionary to map each location to its corresponding line
$elementDict = @{}
foreach ($element in $elements) {
    $elementDict[$element.loc] = $element
}

# split the string into an array of characters
$navInstructions = $data[0].ToCharArray()
#$goal = $elements[-1].loc
$line = $elementDict["AAA"]
$navInstructionIndex = 0
$stepsCounted = 0
while ($line.loc -ne "ZZZ") {
    
    $stepsCounted++
    $nav = $navInstructions[$navInstructionIndex]
    #Write-Host "$nav $line"
    $navInstructionIndex++
    if ($navInstructionIndex -eq $navInstructions.Length) {
        #Write-Host $nav
        $navInstructionIndex = 0
    }
    if ($nav -eq "L") {
        $line = $elementDict[$line.left]
    }
    elseif ($nav -eq "R") {
        $line = $elementDict[$line.right]
    }
}
$stepsCounted

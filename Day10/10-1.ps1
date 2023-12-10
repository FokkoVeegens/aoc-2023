$data = Get-Content -Path "$PSScriptRoot\input.txt"

$nodes = @()

<#
| is a vertical pipe connecting north and south.
- is a horizontal pipe connecting east and west.
L is a 90-degree bend connecting north and east.
J is a 90-degree bend connecting north and west.
7 is a 90-degree bend connecting south and west.
F is a 90-degree bend connecting south and east.
. is ground; there is no pipe in this tile.
S is the starting position of the animal; there is a pipe on this
#>

$x = 0
$y = 0

foreach ($line in $data) {
    foreach ($character in $line.ToCharArray()) {
        if ($character -eq ".") {
            $x++
            continue
        }
        $nodes += ,@{ 
            X = $x
            Y = $y
            ConnectorTop = $character -match "[|LJS]"
            ConnectorLeft = $character -match "[-J7S]"
            ConnectorBottom = $character -match "[|F7S]"
            ConnectorRight = $character -match "[-LFS]"
            NodeChar = $character
        }
        $x++
    }
    $x = 0
    $y++
}

$nodeDict = @{}
foreach ($node in $nodes) {
    $nodeDict["$($node.X),$($node.Y)"] = $node
}

foreach ($node in $nodes) {
    $node.Neighbours = @()
    if ($node.ConnectorLeft) {
        $neighborLeft = $nodeDict["$($node.X - 1),$($node.Y)"]
        if ($null -ne $neighborLeft -and $neighborLeft.ConnectorRight) {
            $node.Neighbours += $neighborLeft
        }
    }

    if ($node.ConnectorRight) {
        $neighborRight = $nodeDict["$($node.X + 1),$($node.Y)"]
        if ($null -ne $neighborRight -and $neighborRight.ConnectorLeft) {
            $node.Neighbours += $neighborRight
        }
    }

    if ($node.ConnectorTop) {
        $neighborTop = $nodeDict["$($node.X),$($node.Y - 1)"]
        if ($null -ne $neighborTop -and $neighborTop.ConnectorBottom) {
            $node.Neighbours += $neighborTop
        }
    }

    if ($node.ConnectorBottom) {
        $neighborBottom = $nodeDict["$($node.X),$($node.Y + 1)"]
        if ($null -ne $neighborBottom -and $neighborBottom.ConnectorTop) {
            $node.Neighbours += $neighborBottom
        }
    }
}

# The only possible route starts at the node with the value S and ends there as well
# Determine the length of the route by counting the number of nodes in the loop. Every node can only be visited once.
# All nodes only have 2 neighbors


$node = $nodes | Where-Object { $_.NodeChar -eq "S" }
$length = 0
$visitedNodesDict = @{}
$visitedNodesDict["$($node.X),$($node.Y)"] = $node
$keyOfSNode = "$($node.X),$($node.Y)"
while ($length -eq 0 -or $node.NodeChar -ne "S") {
    $length++
    if ($length -eq 3) {
        # Remove S from visitedNeighbors, so it can reoccur again
        $visitedNodesDict.Remove($keyOfSNode)
    }
    $foundneighbors = $node.Neighbours | Where-Object { $_.X, $_.Y -ne $node.X, $node.Y }
    if ($node.NodeChar -ne "S") {
        foreach ($neighbor in $foundneighbors) {
            if ($visitedNodesDict.ContainsKey("$($neighbor.X),$($neighbor.Y)")) {
                continue
            }
            $node = $neighbor
            break
        }
    }
    else {
        $node = $foundneighbors[0]
    }
    $visitedNodesDict["$($node.X),$($node.Y)"] = $node

}
$length/2


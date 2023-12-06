[long]$time = 62649190
[long]$distance = 553101014731074

for ($charging = 0; $charging -le $time; $charging++) {
    $distanceTraveled = $charging * ($time - $charging)
    if ($distanceTraveled -gt $distance) {
        break
    }
}

"Started exceeding at $charging charging time units"
$startTime = $charging - 1

for ($charging = $time; $charging -ge 0; $charging--) {
    $distanceTraveled = $charging * ($time - $charging)
    if ($distanceTraveled -gt $distance) {
        break
    }
}

"Stopped exceeding at $charging charging time units"
$stopTime = $charging
$result = $stopTime - $startTime
"Result: $result"
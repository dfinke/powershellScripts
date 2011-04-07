<#
	See this blog post

	http://www.dougfinke.com/blog/index.php/2011/01/16/make-your-powershell-for-loops-4x-faster/
#>
Function Test-WithoutCache ($data) {


    $sum = 0
    # antipattern
    # access the array count on each iteration
    for($idx = 0 ; $idx -lt $data.count; $idx++) {
        $sum+=$data[$idx]
    }
    $sum
}

Function Test-WithCache ($data) {
    # capture the count; cache it
    $count = $data.count
    $sum = 0
    # use the $count variable in the
    # for loop and improve performance 4x
    for($idx = 0 ; $idx -lt $count; $idx++) {
        $sum+=$data[$idx]
    }
    $sum
}

function ql {$args}

$tests  = ql Test-WithoutCache Test-WithCache
$ranges = ql 10 100 1000 10000 100000 1000000

$(ForEach($range in $ranges) {
    ForEach($test in $tests) {
        $msg = ("[{0}] Running {1} with {2} items" -f  (Get-Date), $test, $range)
        Write-Host -ForegroundColor Green $msg
        New-Object PSObject -Property @{
            TotalSeconds = [Double]("{0:#0.#####0}" -f (Measure-Command { & $test (1..$range) }).TotalSeconds)
            Range  = $range
            Test   = $test
        } | Select Test, Range, TotalSeconds
    }
}) | Format-Table -AutoSize
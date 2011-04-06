# Calling Excel Math Functions From PowerShell

$xl        = New-Object -ComObject Excel.Application
$xlprocess = ps excel

$x    = $xl.WorksheetFunction
$data = 1,2,3,4
$m    = ((1,2,3),(4,5,6),(7,8,9))

$x.Median($data)
$x.StDev($data)
$x.Var($data)
$x.MInverse($m)

$xl.quit()
$xlprocess | kill
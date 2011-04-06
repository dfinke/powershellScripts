# Calling Excel Math Functions From PowerShell

$xl        = New-Object -ComObject Excel.Application
$xlprocess = Get-Process excel

$wf   = $xl.WorksheetFunction
$data = 1,2,3,4
$m    = ((1,2,3),(4,5,6),(7,8,9))

Write-Host -ForegroundColor green Median
$wf.Median($data)

Write-Host -ForegroundColor green StDev
$wf.StDev($data)

Write-Host -ForegroundColor green Var
$wf.Var($data)

Write-Host -ForegroundColor green MInverse
$wf.MInverse($m)

$xl.quit()
$xlprocess | kill
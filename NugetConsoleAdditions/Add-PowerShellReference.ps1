
function Add-Reference ([string[]]$ReferenceName, [string]$ProjectName) {
	Get-Project -All |
		Where {
			$_.Name -match $ProjectName
		} |
		ForEach {
			ForEach($name in @($ReferenceName)) {
				$_.Object.References.Add($name) | Out-Null
			}
		}
}

function Add-PowerShellReference([string]$ProjectName) {
	Add-Reference "System.Management.Automation" $ProjectName
}
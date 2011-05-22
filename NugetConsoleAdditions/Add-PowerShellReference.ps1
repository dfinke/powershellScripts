function Add-PowerShellReference([string]$ProjectName) {
	Add-Reference "System.Management.Automation" $ProjectName
}

set-alias addPS Add-PowerShellReference
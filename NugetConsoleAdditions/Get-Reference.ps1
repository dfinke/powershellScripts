function Get-Reference {
	param (
		[string]$ProjectName,
		[string]$ReferenceName,
		[switch]$IncludeAll
	)

	$result = Get-Project -All |
		Where { $_.Name -match $ProjectName} |
		ForEach { $_.object.references | Where { $_.Name -match $ReferenceName } |
		ForEach {
			New-Object PSObject -Property @{
				ProjectName    = $_.ContainingProject.ProjectName
				ReferenceName  = $_.Name
				RunTimeVersion = $_.RunTimeVersion
				AutoReferenced = $_.AutoReferenced
			} | Select ProjectName, ReferenceName, RunTimeVersion, AutoReferenced
		}
	}

	if($IncludeAll) {
		$result
	} else {
		$result | Where {!$_.AutoReferenced}
	}
}
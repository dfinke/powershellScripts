function Remove-Reference {
	param (
		[Parameter(Position=0,ValueFromPipelineByPropertyName=$true)]
		[string]$ProjectName,
		[Parameter(Position=1,ValueFromPipelineByPropertyName=$true)]
		[string]$ReferenceName
	)

	Process {
		Get-Project -All |
			? { $_.Name -match $ProjectName } |
			% { $_.object.references } |
			? { $_.name -match $ReferenceName -And !$_.AutoReferenced } |
			% { $_.remove() }
	}
}

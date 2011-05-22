function mutate {
    param (
        $src = "sut",
        $dest = "mutate"
    )

    Add-VSItem $dest
    $dte.Documents | %{ $_.Close() }

    (Get-ProjectItem $src) |
    	Get-Content |
    	Set-Content (Get-ProjectItem $dest).FullPath

    $dte.ExecuteCommand("Build.BuildSolution")
}
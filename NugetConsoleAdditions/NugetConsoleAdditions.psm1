function ql {$args}

function Get-ProjectItem ($fileName) {
    <#
    .Synopsis
        A Quick Description of what the command does
    #>
    $dte.Solution | 
        ForEach {$_.ProjectItems} | 
        ForEach {$_.properties | 
        ForEach {$h=@{}}{$h.($_.name)=$_.value} {new-object psobject -Property $h}} |	
        Add-Member -PassThru ScriptProperty LiteralPath {$this.FullPath} |
	Where {$_.FileName -match $fileName} |
}

function Get-InterfaceTemplate { 
    <#
    .Synopsis
        A Quick Description of what the command does
    #>

    $dte.Solution.GetProjectItemTemplate("Interface", "CSharp") 
}

function Get-ClassTemplate { 
    <#
    .Synopsis
        A Quick Description of what the command does
    #>
    
    $dte.Solution.GetProjectItemTemplate("Class", "CSharp") 
}

function Add-VSItemByTemplate {
    <#
    .Synopsis
        A Quick Description of what the command does
    #>

    param($template, $name)

    # TODO: Make it work with any name project
    # This supports only the start up project
    $prj = Get-Project    
    $prj.ProjectItems.AddFromTemplate($template, $name)
}

function Add-Class {
    <#
    .Synopsis
        A Quick Description of what the command does
    #>
    param ($name)    
    
    Add-VSItemByTemplate (Get-ClassTemplate) (Get-FixedFileName $name)
}

function Add-Interface {
    <#
    .Synopsis
        A Quick Description of what the command does
    #>
    param ($name)
    
    Add-VSItemByTemplate (Get-InterfaceTemplate) (Get-FixedFileName $name)
}

function Get-FixedFileName {
    <#
    .Synopsis
        If the name does not end with .cs, it adds it.
    .Example
        Get-FixedFileName test
        test.cs
    #>
    param ($name)
    
    if(!$name.EndsWith(".cs")) {
    	$name += ".cs"
    }
    
    $name
}

function Add-VSItem {
    <#
    .Synopsis
        Adds eihter a class or interface. If specify ITest, it will add the interface ITest.
        If specify Test, it will add the class Test.
    .Example
        ql ITest Test | Add-VSItem        
    #>
    param (
        [Parameter(ValueFromPipeline=$true)]
        $name
    )
    
    Process {
    	if($name[0] -eq"i") {
    	    Add-Interface $name 
    	} else {
    	    Add-Class $name 
    	}
    }
}
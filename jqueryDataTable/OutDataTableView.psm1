
Function Get-DataTableHtml {
	function ql {$args}

	$imports = ql demo_page.css demo_table.css demo_table_jui.css jquery-ui-1.8.4.custom.css | % {
		$fileName = (Join-Path $PSScriptRoot $_).Replace("\", "/")
		"@import '$fileName';"
	}

@"
<html>
	<head>
		<style type="text/css" title="currentStyle">
			$($imports)
		</style>

		<script type="text/javascript" language="javascript" src="$(Join-Path $PSScriptRoot jquery.js)"></script>
		<script type="text/javascript" language="javascript" src="$(Join-Path $PSScriptRoot jquery.dataTables.js)"></script>

        <script type="text/javascript" charset="utf-8">
			`$( function() {
				`$('#example').dataTable({
                    "bJQueryUI": true,
                    "sPaginationType": "full_numbers"
                });
			} );
		</script>

	</head>
<body>
"@
}

Function Out-DataTableView {
    param(
        [string[]]$Properties,
        [switch]$view
    )

    begin {
        $result = @()
    }

    process {
        if(!$Global:HeadingsExported) {
            if(!$Properties) {
                $Properties = $_ |Get-Member -MemberType *Property | Select -ExpandProperty Name
            }

            $r += Get-DataTableHtml

            $r += '<table cellpadding="0" cellspacing="0" border="0" id="example" class="display">'
            $r += "`r`n<thead><tr>"
            ForEach($property in $Properties) {
                $r += "`r`n<th>$property</th>"
            }
            $r += "</tr></thead><tbody>"

            $Global:HeadingsExported = "finished"
        }

        $r += "<tr>"
        ForEach($property in $Properties) {
            $r += "<td>$($_.$Property)</td>"
        }
        $r += "</tr>"
    }

    end {

        $r += "</tbody></table></body></html>"

        $fileName = Split-Path -Leaf ([io.path]::GetTempFileName() -replace ".tmp",".htm")
        $fileName = Join-Path $PSScriptRoot $fileName
        $r | Set-Content -Encoding ascii $fileName

        Invoke-Item $fileName
        Remove-Item Variable:HeadingsExported
    }
}

dir $psscriptroot *.htm | rm
Set-Alias odv Out-DataTableView
Export-ModuleMember -Alias odv -Function Out-DataTableView
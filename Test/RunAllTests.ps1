$testScripts = Get-ChildItem -Path $PSScriptRoot -Filter *.ps1 -Recurse | 
    Where-Object { $_.FullName -ne $MyInvocation.ScriptName }

$testScripts | ForEach-Object { 
        $testscript = $_.FullName
        Write-Host @"
------------------------------------------------
Test: ${testscript}
------------------------------------------------
"@
        . $_.FullName
    }

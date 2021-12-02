
Describe "コマンド実行" {
    BeforeAll{
        Push-Location $PSScriptRoot 
    }
    AfterAll{
        Pop-Location
    }
    It "異常ケース ファイル存在なし" {
        $src = $env:TEMP | Join-Path -ChildPath "INPUT_$([Guid]::NewGuid()).csv"
        . ..\Src\GenerateTableDefinitionFromCsv.ps1 -FilePath $src
        $actual = "$($src).table.csv"
        Test-Path $actual | Should Be $false
    }
    It "正常ケース" {
        $src = $env:TEMP | Join-Path -ChildPath "INPUT_$([Guid]::NewGuid()).csv"
        Set-Content -Path $src -Encoding Default -Value @"
col1,col2,col3,col4
`"A`",1,1234.,1
B,23,.5678,0
CD,456,1.1,1
"@
        . ..\Src\GenerateTableDefinitionFromCsv.ps1 -FilePath $src
        $actual = "$($src).table.csv"
        Test-Path $actual | Should Be $true
        Get-Content -Path $actual -Raw -Encoding Default | Should Be (
"Column,Index,Text,Integer,Decimal,Boolean`n"+
"col1,0,[col1] [VARCHAR](2) NOT NULL,,,`n"+
"col2,1,[col2] [VARCHAR](3) NOT NULL,[col2] [SMALLINT] NOT NULL,,`n"+
"col3,2,[col3] [VARCHAR](5) NOT NULL,,[col3] [DECIMAL](8,4) NOT NULL,`n"+
"col4,3,[col4] [CHAR](1) NOT NULL,[col4] [TINYINT] NOT NULL,,[col4] [BIT] NOT NULL"
)
        Remove-Item -Path $src -Force
        Remove-Item -Path $actual -Force
    }
}

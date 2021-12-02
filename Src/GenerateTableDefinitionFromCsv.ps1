using namespace System.Text
using module .\lib\TableDefinitionGenerator.psm1


<#
    .SYNOPSIS
    CSVからSQL Server用のスキーマ候補を出力します。

    .DESCRIPTION
    CSVファイルのパスを渡して下さい。その各列がとり得る長さや文字列・数値型を判別して
    候補を出力します。

    .PARAMETER FilePath
    対象のCSVファイルのパスです。

    .PARAMETER Delimiter
    CSVファイルの区切り文字です。デフォルトはカンマです。

    .PARAMETER TextEncodingName
    CSVファイルの文字コードです。デフォルトはSJISです。

    .PARAMETER ExportPath
    結果のCSVファイルの出力先です。指定しない場合はCSVと同ディレクトリに出力されます。

    .PARAMETER Top
    先頭から読み込む件数です。指定しない場合は全行読み込んで解析します。
    
    .INPUTS
    ファイルパスを渡せます。

    .EXAMPLE
    PS> AnalyzeCsvScheme.ps1 -FilePath sample.csv -Export result.csv
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]
    $FilePath,
    [Parameter()]
    [string]
    $Delimiter = ",",
    [Parameter()]
    [string]
    $TextEncodingName,
    [Parameter()]
    [string]
    $ExportPath,
    [Parameter()]
    [uint32]
    $Top = [uint32]::MaxValue
)

if (-not (Test-Path $FilePath)) {
    Write-Host "対象のファイルが存在しません:${$FilePath}"
    exit 
}
$File = Get-ChildItem -Path $FilePath
if (-not $ExportPath) {
    $ExportPath = $File.FullName + ".table.csv"
}

$Encoding = if($TextEncodingName) {
    [Encoding]::GetEncoding($TextEncodingName)
}else{
    [Encoding]::Default
}
$Content = [System.IO.File]::ReadAllLines($File.FullName, $Encoding)
$CountToRead = [Math]::Min([uint32]$Content.Count - 1, $Top)

# 各行の各フィールドを読み取る
Write-Host @"
CSVを解析します。
ファイル　　　: $($File.FullName)
行数　　　　　: $($Content.Count)
解析行数　　　: $($CountToRead)
区切り文字　　: $($Delimiter)
文字エンコード: $($TextEncodingName)
出力先　　　　: $($ExportPath)
"@

$reader = [TableDefinitionGenerator]::New($File.FullName, $Delimiter, $Encoding, $CountToRead)

Write-Host @"
結果のファイルを出力します。
ファイル　　　: $ExportPath
"@

$reader.Generate($ExportPath)

Write-Host @"
解析終了
"@

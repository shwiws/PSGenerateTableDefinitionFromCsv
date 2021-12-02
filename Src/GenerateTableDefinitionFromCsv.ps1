using namespace System.Text
using module .\lib\TableDefinitionGenerator.psm1


<#
    .SYNOPSIS
    CSV����SQL Server�p�̃X�L�[�}�����o�͂��܂��B

    .DESCRIPTION
    CSV�t�@�C���̃p�X��n���ĉ������B���̊e�񂪂Ƃ蓾�钷���╶����E���l�^�𔻕ʂ���
    �����o�͂��܂��B

    .PARAMETER FilePath
    �Ώۂ�CSV�t�@�C���̃p�X�ł��B

    .PARAMETER Delimiter
    CSV�t�@�C���̋�؂蕶���ł��B�f�t�H���g�̓J���}�ł��B

    .PARAMETER TextEncodingName
    CSV�t�@�C���̕����R�[�h�ł��B�f�t�H���g��SJIS�ł��B

    .PARAMETER ExportPath
    ���ʂ�CSV�t�@�C���̏o�͐�ł��B�w�肵�Ȃ��ꍇ��CSV�Ɠ��f�B���N�g���ɏo�͂���܂��B

    .PARAMETER Top
    �擪����ǂݍ��ތ����ł��B�w�肵�Ȃ��ꍇ�͑S�s�ǂݍ���ŉ�͂��܂��B
    
    .INPUTS
    �t�@�C���p�X��n���܂��B

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
    Write-Host "�Ώۂ̃t�@�C�������݂��܂���:${$FilePath}"
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

# �e�s�̊e�t�B�[���h��ǂݎ��
Write-Host @"
CSV����͂��܂��B
�t�@�C���@�@�@: $($File.FullName)
�s���@�@�@�@�@: $($Content.Count)
��͍s���@�@�@: $($CountToRead)
��؂蕶���@�@: $($Delimiter)
�����G���R�[�h: $($TextEncodingName)
�o�͐�@�@�@�@: $($ExportPath)
"@

$reader = [TableDefinitionGenerator]::New($File.FullName, $Delimiter, $Encoding, $CountToRead)

Write-Host @"
���ʂ̃t�@�C�����o�͂��܂��B
�t�@�C���@�@�@: $ExportPath
"@

$reader.Generate($ExportPath)

Write-Host @"
��͏I��
"@

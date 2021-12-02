using namespace System.Text
using module "..\..\Src\lib\TableDefinitionGenerator.psm1"

Describe "TableDefinitionGenerator �R���X�g���N�^" {
    Context "�ُ�P�[�X" {
        It "�w��p�X�Ƀt�@�C�����Ȃ�" {
            { [TableDefinitionGenerator]::New($null, ",", [Encoding]::Default, 1) } | Should throw
        }
        It "��؂蕶����null" {
            $temp = $env:TEMP | Join-Path -ChildPath "test.csv"
            Set-Content -Path $temp -Value "col1,col2,col3`n4,5,6" -Encoding Default
            { [TableDefinitionGenerator]::New($temp, $null, [Encoding]::Default, 1) } | Should throw
            Remove-Item -Path $temp -Force
        }
        It "�G���R�[�f�B���O��null" {
            $temp = $env:TEMP | Join-Path -ChildPath "test.csv"
            Set-Content -Path $temp -Value "col1,col2,col3`n4,5,6" -Encoding Default
            { [TableDefinitionGenerator]::New($temp, ",", $null, 1) } | Should throw
            Remove-Item -Path $temp -Force
        }
        It "�ǂݍ��݌�����0" {
            $temp = $env:TEMP | Join-Path -ChildPath "test.csv"
            Set-Content -Path $temp -Value "col1,col2,col3`n4,5,6" -Encoding Default
            { 
                [TableDefinitionGenerator]::New($temp, ",", [Encoding]::Default, 0)
            } | Should throw
            Remove-Item -Path $temp -Force
        }
    }
    Context "����P�[�X" {
        It "CSV�t�@�C���ǂݍ���" {
            $temp = $env:TEMP | Join-Path -ChildPath "$([Guid]::NewGuid()).csv"
            Set-Content -Path $temp -Value "first,second,third`n,,`n4,5,6" -Encoding Default
            $reader = [TableDefinitionGenerator]::new($temp, ",", [Encoding]::Default, 1)
            $reader.Columns.Count | Should Be 3
            $reader.Columns[0].ColumnName | Should Be "first"
            $reader.Columns[1].ColumnName | Should Be "second"
            $reader.Columns[2].ColumnName | Should Be "third"
            Remove-Item -Path $temp -Force
        }
    }
}

Describe "TableDefinitionGenerator Generate" {
    Context "�ُ�P�[�X" {
        It "���łɏo�͐�t�@�C�������݂���B" {
            $temp = $env:TEMP | Join-Path -ChildPath "$([Guid]::NewGuid()).csv"
            Set-Content -Path $temp -Value "first,second,third`n7,8,9`n4,5,6" -Encoding Default
            $reader = [TableDefinitionGenerator]::new($temp, ",", [Encoding]::Default, 1)
            { $reader.Generate($temp) } | Should throw
            Remove-Item -Path $temp -Force
        }
    }

    Context "����P�[�X" {
        It "�S��ʏo�͂����CSV(NOT NULL)" {
            $src = $env:TEMP | Join-Path -ChildPath "INPUT_$([Guid]::NewGuid()).csv"
            Set-Content -Path $src -Encoding Default -Value @"
col1,col2,col3,col4
`"A`",1,1234.,1
B,23,.5678,1
CD,456,1.1,1
"@
            $reader = [TableDefinitionGenerator]::new($src, ",", [Encoding]::Default, 10000)
            $actual = $env:TEMP | Join-Path -ChildPath "ACTUAL_$([Guid]::NewGuid()).csv"
            $reader.Generate($actual)
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
}

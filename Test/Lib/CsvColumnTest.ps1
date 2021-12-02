using module "..\..\Src\lib\CsvColumn.psm1"
using module "..\..\Src\lib\CsvField.psm1"
using module "..\..\Src\lib\IntegerType.psm1"

Describe "CsvColumn �R���X�g���N�^" {
    Context "�ُ�P�[�X" {
        It "�����Ȃ�" {
            { [CsvColumn]::new() } | Should Throw
        }
        It "���O��NULL" {
            { [CsvColumn]::new($null, 1) } | Should Throw
        }
        It "���O���󕶎�" {
            { [CsvColumn]::new('', 1) } | Should Throw
        }
        It "��ԍ����͈͊O" {
            { [CsvColumn]::new('', -1) } | Should Throw
        }
    }
}
Describe "CsvColumn ReadField" {
    Context "NULL�̂�" {
        It "���p���Ȃ�" {
            [CsvColumn]$c = [CsvColumn]::New("column", 0)
            @(
                [CsvField]::new(""),
                [CsvField]::new(" ")
            ) | ForEach-Object { $c.ReadField($_) }
            $c.ColumnIndex          | Should Be 0
            $c.IsFixedLength        | Should Be $false
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 1
            $c.TrimmedDataLength    | Should Be 0
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $false
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $true
        }
        It "���p������" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new('""'),
                [CsvField]::new('" "')
            ) | ForEach-Object { $c.ReadField($_) }
            $c.ColumnIndex          | Should Be 1
            $c.IsFixedLength        | Should Be $false
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 1
            $c.TrimmedDataLength    | Should Be 0
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $false
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $true
        }
    }
    Context "������݂̂ɔF������� ���p���Ȃ�" {
        It "���p������J����" {
            [CsvColumn]$c = [CsvColumn]::New("column", 2)
            @(
                [CsvField]::new("a")
            ) | ForEach-Object { $c.ReadField($_) }
            $c.ColumnIndex          | Should Be 2
            $c.IsFixedLength        | Should Be $true
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 1
            $c.TrimmedDataLength    | Should Be 1
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $false
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "���p������J���� NULL" {
            [CsvColumn]$c = [CsvColumn]::New("column", 2)
            @(
                [CsvField]::new("a123"),
                [CsvField]::new(""),
                [CsvField]::new("BCD")
            ) | ForEach-Object { $c.ReadField($_) }
            $c.ColumnIndex          | Should Be 2
            $c.IsFixedLength        | Should Be $false
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 4
            $c.TrimmedDataLength    | Should Be 4
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $false
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $true
        }
        It "�S�p���p����������J���� NULL" {
            [CsvColumn]$c = [CsvColumn]::New("column", 3)
            @(
                [CsvField]::new("a123"),
                [CsvField]::new(""),
                [CsvField]::new("BC������D ")
            ) | ForEach-Object { $c.ReadField($_) }
            $c.ColumnIndex          | Should Be 3
            $c.IsFixedLength        | Should Be $false
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 7
            $c.TrimmedDataLength    | Should Be 6
            $c.IsMultiByte          | Should Be $true
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $false
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $true
        }
        It "���l���������Ǖ�����F��" {
            [CsvColumn]$c = [CsvColumn]::New("column", 4)
            @(
                [CsvField]::new("123"),
                [CsvField]::new(""),
                [CsvField]::new("1.0"),
                [CsvField]::new("BC������D ")
            ) | ForEach-Object { $c.ReadField($_) }
            $c.ColumnIndex          | Should Be 4
            $c.IsFixedLength        | Should Be $false
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 7
            $c.TrimmedDataLength    | Should Be 6
            $c.IsMultiByte          | Should Be $true
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $false
            $c.IntegerType          | Should Be ([IntegerType]::SmallInt)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $true
        }
    }
    Context "������݂̂ɔF������� ���p������" {
        It "���p������J����" {
            [CsvColumn]$c = [CsvColumn]::New("column", 5)
            @(
                [CsvField]::new('"a"')
            ) | ForEach-Object { $c.ReadField($_) }
            $c.ColumnIndex          | Should Be 5
            $c.IsFixedLength        | Should Be $true
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 1
            $c.TrimmedDataLength    | Should Be 1
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $false
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "���p������J���� NULL" {
            [CsvColumn]$c = [CsvColumn]::New("column", [int]::MaxValue)
            @(
                [CsvField]::new('"a123"'),
                [CsvField]::new('""'),
                [CsvField]::new('"BCD"')
            ) | ForEach-Object { $c.ReadField($_) }
            $c.ColumnIndex          | Should Be ([int]::MaxValue)
            $c.IsFixedLength        | Should Be $false
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 4
            $c.TrimmedDataLength    | Should Be 4
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $false
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $true
        }
        It "�S�p���p����������J���� NULL" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new('"a123"'),
                [CsvField]::new('""'),
                [CsvField]::new('"BC������D "')
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 7
            $c.TrimmedDataLength    | Should Be 6
            $c.IsMultiByte          | Should Be $true
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $false
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $true
        }
        It "���l���������Ǖ�����F��" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new('"123"'),
                [CsvField]::new('""'),
                [CsvField]::new('"1.0"'),
                [CsvField]::new('"BC������D "')
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 7
            $c.TrimmedDataLength    | Should Be 6
            $c.IsMultiByte          | Should Be $true
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $false
            $c.IntegerType          | Should Be ([IntegerType]::SmallInt)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $true
        }
    }
    Context "�����^�ɔF������� ���p���Ȃ�" {
        It "TinyInt" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new("1"),
                [CsvField]::new("99")
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 2
            $c.TrimmedDataLength    | Should Be 2
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::TinyInt)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "SmallInt" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new("1"),
                [CsvField]::new("100"),
                [CsvField]::new("9999")
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 4
            $c.TrimmedDataLength    | Should Be 4
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::SmallInt)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "Int" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new("10000"),
                [CsvField]::new("100"),
                [CsvField]::new("999999999")
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 9
            $c.TrimmedDataLength    | Should Be 9
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::Int)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "BigInt" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new("999999999999999999"),
                [CsvField]::new("100"),
                [CsvField]::new("1000000000")
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 18
            $c.TrimmedDataLength    | Should Be 18
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::BigInt)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "TinyInt �X�y�[�X����" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new("1"),
                [CsvField]::new("99  ")
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 4
            $c.TrimmedDataLength    | Should Be 2
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::TinyInt)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "SmallInt �X�y�[�X����" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new("1"),
                [CsvField]::new("100"),
                [CsvField]::new(" 9999")
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 5
            $c.TrimmedDataLength    | Should Be 4
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::SmallInt)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "Int �X�y�[�X����" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new("10000"),
                [CsvField]::new(" 100"),
                [CsvField]::new("999999999")
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 9
            $c.TrimmedDataLength    | Should Be 9
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::Int)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "BigInt �X�y�[�X����" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new("999999999999999999 "),
                [CsvField]::new("100"),
                [CsvField]::new("1000000000")
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 19
            $c.TrimmedDataLength    | Should Be 18
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::BigInt)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "BigInt NULL����" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new("999999999999999999 "),
                [CsvField]::new(""),
                [CsvField]::new("1000000000")
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 19
            $c.TrimmedDataLength    | Should Be 18
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::BigInt)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $true
        }
    }
    Context "�����^�ɔF������� ���p������" {
        It "TinyInt" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new('"1"'),
                [CsvField]::new('"99"')
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 2
            $c.TrimmedDataLength    | Should Be 2
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::TinyInt)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "SmallInt" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new('"1"'),
                [CsvField]::new('"100"'),
                [CsvField]::new('"9999"')
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 4
            $c.TrimmedDataLength    | Should Be 4
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::SmallInt)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "Int" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new('"10000"'),
                [CsvField]::new('"100"'),
                [CsvField]::new('"999999999"')
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 9
            $c.TrimmedDataLength    | Should Be 9
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::Int)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "BigInt" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new('"999999999999999999"'),
                [CsvField]::new('"100"'),
                [CsvField]::new('"1000000000"')
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 18
            $c.TrimmedDataLength    | Should Be 18
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::BigInt)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "TinyInt �X�y�[�X����" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new('"1"'),
                [CsvField]::new('"99  "')
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 4
            $c.TrimmedDataLength    | Should Be 2
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::TinyInt)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "SmallInt �X�y�[�X����" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new('"1"'),
                [CsvField]::new('"100"'),
                [CsvField]::new('" 9999"')
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 5
            $c.TrimmedDataLength    | Should Be 4
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::SmallInt)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "Int �X�y�[�X����" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new('"10000"'),
                [CsvField]::new('" 100"'),
                [CsvField]::new('"999999999"')
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 9
            $c.TrimmedDataLength    | Should Be 9
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::Int)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "BigInt �X�y�[�X����" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new('"999999999999999999 "'),
                [CsvField]::new('"100"'),
                [CsvField]::new('"1000000000"')
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 19
            $c.TrimmedDataLength    | Should Be 18
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::BigInt)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "BigInt NULL����" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new('"999999999999999999 "'),
                [CsvField]::new('""'),
                [CsvField]::new('"1000000000"')
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 19
            $c.TrimmedDataLength    | Should Be 18
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsInteger            | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::BigInt)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $true
        }
    }
    Context "�ʏ핂�������_�^�ɔF������� ���p���Ȃ�" {
        It "�ʏ�̒l" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new("1.0"),
                [CsvField]::new("10.01")
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 5
            $c.TrimmedDataLength    | Should Be 5
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $true
            $c.Unit                 | Should Be 2
            $c.Significand          | Should Be 2
            $c.IsInteger            | Should Be $false
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "�������Ȃ� �Œ蒷" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new(".50"),
                [CsvField]::new(".01")
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $true
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 3
            $c.TrimmedDataLength    | Should Be 3
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $true
            $c.Unit                 | Should Be 1
            $c.Significand          | Should Be 2
            $c.IsInteger            | Should Be $false
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "�������Ȃ� �Œ蒷" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new("100. "),
                [CsvField]::new("10."),
                [CsvField]::new(" ")
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 5
            $c.TrimmedDataLength    | Should Be 4
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $true
            $c.Unit                 | Should Be 3
            $c.Significand          | Should Be 1
            $c.IsInteger            | Should Be $false
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $true
        }
    }
    Context "�ʏ핂�������_�^�ɔF������� ���p������" {
        It "�ʏ�̒l" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new('"1.0"'),
                [CsvField]::new('"10.01"')
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 5
            $c.TrimmedDataLength    | Should Be 5
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $true
            $c.Unit                 | Should Be 2
            $c.Significand          | Should Be 2
            $c.IsInteger            | Should Be $false
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "�������Ȃ� �Œ蒷" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new('".50"'),
                [CsvField]::new('".01"')
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $true
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 3
            $c.TrimmedDataLength    | Should Be 3
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $true
            $c.Unit                 | Should Be 1
            $c.Significand          | Should Be 2
            $c.IsInteger            | Should Be $false
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $false
        }
        It "�������Ȃ� �Œ蒷" {
            [CsvColumn]$c = [CsvColumn]::New("column", 1)
            @(
                [CsvField]::new('"100. "'),
                [CsvField]::new('"10."'),
                [CsvField]::new('" "')
            ) | ForEach-Object { $c.ReadField($_) }
            $c.IsFixedLength        | Should Be $false
            $c.ColumnIndex          | Should Be 1
            $c.ColumnName           | Should Be "column"
            $c.DataLength           | Should Be 5
            $c.TrimmedDataLength    | Should Be 4
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $true
            $c.Unit                 | Should Be 3
            $c.Significand          | Should Be 1
            $c.IsInteger            | Should Be $false
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
            $c.IsBoolean            | Should Be $false
            $c.IsNull               | Should Be $true
        }
    }
}

# ���p�L���e�X�g�p
$QuoteFuncs = @(
    { param($t) return $t },
    { param($t) return "`"$t`"" }
)

Describe "CsvColumn CreateDbTypeSuggests" {
    Context "���݂Ȃ��p�^�[��" {
        It "���p�ϒ������� NULL�Ȃ� �i���p������^�Ȃ��j" {
            function AssertDict([hashtable]$Dict) {
                $Dict.Text    | Should Be "[column] [VARCHAR](15) NOT NULL"
                $Dict.Integer | Should Be $null
                $Dict.Decimal | Should Be $null
                $Dict.Boolean | Should Be $null
            }
            $QuoteFuncs | ForEach-Object {
                $c = [CsvColumn]::New("column", 1)
                @(
                    [CsvField]::new($_.Invoke("sample")),
                    [CsvField]::new($_.Invoke("this is sample.")),
                    [CsvField]::new($_.Invoke("  trimmed  "))
                ) | ForEach-Object { $c.ReadField($_) }
                AssertDict -Dict $c.CreateDbTypeDict()
            }
        }
        It "���p�ϒ������� NULL���� �i���p������^�Ȃ��j" {
            function AssertDict([hashtable]$Dict) {
                $Dict.Text    | Should Be "[column] [VARCHAR](15) NULL"
                $Dict.Integer | Should Be $null
                $Dict.Decimal | Should Be $null
                $Dict.Boolean | Should Be $null
            }
            $QuoteFuncs | ForEach-Object {
                $c = [CsvColumn]::New("column", 1)
                @(
                    [CsvField]::new($_.Invoke("sample")),
                    [CsvField]::new($_.Invoke("this is sample.")),
                    [CsvField]::new($_.Invoke("    "))
                ) | ForEach-Object { $c.ReadField($_) }
                AssertDict -Dict $c.CreateDbTypeDict()
            }
        }
        It "���p�Œ蒷������ NULL�Ȃ� �i���p������^�Ȃ��j" {
            function AssertDict([hashtable]$Dict) {
                $Dict.Text    | Should Be "[column] [CHAR](16) NOT NULL"
                $Dict.Integer | Should Be $null
                $Dict.Decimal | Should Be $null
                $Dict.Boolean | Should Be $null
            }
            $QuoteFuncs | ForEach-Object {
                $c = [CsvColumn]::New("column", 1)
                @(
                    [CsvField]::new($_.Invoke("That was sample.")),
                    [CsvField]::new($_.Invoke("This was sample.")),
                    [CsvField]::new($_.Invoke("There is sample."))
                ) | ForEach-Object { $c.ReadField($_) }
                AssertDict -Dict $c.CreateDbTypeDict()
            }
        }
        It "���p�Œ蒷������ NULL���� �i���p������^�Ȃ��j" {
            function AssertDict([hashtable]$Dict) {
                $Dict.Text    | Should Be "[column] [CHAR](16) NULL"
                $Dict.Integer | Should Be $null
                $Dict.Decimal | Should Be $null
                $Dict.Boolean | Should Be $null
            }
            $QuoteFuncs | ForEach-Object {
                $c = [CsvColumn]::New("column", 1)
                @(
                    [CsvField]::new($_.Invoke("That was sample.")),
                    [CsvField]::new($_.Invoke("")),
                    [CsvField]::new($_.Invoke("There is sample."))
                ) | ForEach-Object { $c.ReadField($_) }
                AssertDict -Dict $c.CreateDbTypeDict()
            }
        }
        
        It "�S�p�ϒ������� NULL�Ȃ� �i���p������^�Ȃ��j" {
            function AssertDict([hashtable]$Dict) {
                $Dict.Text    | Should Be "[column] [NVARCHAR](9) NOT NULL"
                $Dict.Integer | Should Be $null
                $Dict.Decimal | Should Be $null
                $Dict.Boolean | Should Be $null
            }
            $QuoteFuncs | ForEach-Object {
                $c = [CsvColumn]::New("column", 1)
                @(
                    [CsvField]::new($_.Invoke("�T���v��")),
                    [CsvField]::new($_.Invoke("����̓T���v���ł�")),
                    [CsvField]::new($_.Invoke("  �g����  "))
                ) | ForEach-Object { $c.ReadField($_) }
                AssertDict -Dict $c.CreateDbTypeDict()
            }
        }
        It "�S�p�ϒ������� NULL���� �i���p������^�Ȃ��j" {
            function AssertDict([hashtable]$Dict) {
                $Dict.Text    | Should Be "[column] [NVARCHAR](9) NULL"
                $Dict.Integer | Should Be $null
                $Dict.Decimal | Should Be $null
                $Dict.Boolean | Should Be $null
            }
            $QuoteFuncs | ForEach-Object {
                $c = [CsvColumn]::New("column", 1)
                @(
                    [CsvField]::new($_.Invoke("�T���v��")),
                    [CsvField]::new($_.Invoke("����̓T���v���ł�")),
                    [CsvField]::new($_.Invoke("    "))
                ) | ForEach-Object { $c.ReadField($_) }
                AssertDict -Dict $c.CreateDbTypeDict()
            }
        }
        It "�S�p�Œ蒷������ NULL�Ȃ� �i���p������^�Ȃ��j" {
            function AssertDict([hashtable]$Dict) {
                $Dict.Text    | Should Be "[column] [NCHAR](9) NOT NULL"
                $Dict.Integer | Should Be $null
                $Dict.Decimal | Should Be $null
                $Dict.Boolean | Should Be $null
            }
            $QuoteFuncs | ForEach-Object {
                $c = [CsvColumn]::New("column", 1)
                @(
                    [CsvField]::new($_.Invoke("����̓T���v���ł�")),
                    [CsvField]::new($_.Invoke("����̓T���v���ł�")),
                    [CsvField]::new($_.Invoke("����̓T���v���ł�"))
                ) | ForEach-Object { $c.ReadField($_) }
                AssertDict -Dict $c.CreateDbTypeDict()
            }
        }
        It "�S�p�Œ蒷������ NULL���� �i���p������^�Ȃ��j" {
            function AssertDict([hashtable]$Dict) {
                $Dict.Text    | Should Be "[column] [NCHAR](9) NULL"
                $Dict.Integer | Should Be $null
                $Dict.Decimal | Should Be $null
                $Dict.Boolean | Should Be $null
            }
            $QuoteFuncs | ForEach-Object {
                $c = [CsvColumn]::New("column", 1)
                @(
                    [CsvField]::new($_.Invoke("����̓T���v���ł�")),
                    [CsvField]::new($_.Invoke("  ")),
                    [CsvField]::new($_.Invoke("����̓T���v���ł�"))
                ) | ForEach-Object { $c.ReadField($_) }
                AssertDict -Dict $c.CreateDbTypeDict()
            }
        }
        It "���l�^�ϒ������� NULL�Ȃ� �i���p������^�Ȃ��j" {
            function AssertDict([hashtable]$Dict) {
                $Dict.Text    | Should Be "[column] [VARCHAR](5) NOT NULL"
                $Dict.Integer | Should Be "[column] [INT] NOT NULL"
                $Dict.Decimal | Should Be $null
                $Dict.Boolean | Should Be $null
            }
            $QuoteFuncs | ForEach-Object {
                $c = [CsvColumn]::New("column", 1)
                @(
                    [CsvField]::new($_.Invoke("1")),
                    [CsvField]::new($_.Invoke("123")),
                    [CsvField]::new($_.Invoke("12345"))
                ) | ForEach-Object { $c.ReadField($_) }
                AssertDict -Dict $c.CreateDbTypeDict()
            }
        }
        It "���l�^�ϒ������� NULL���� �i���p������^�Ȃ��j" {
            function AssertDict([hashtable]$Dict) {
                $Dict.Text    | Should Be "[column] [VARCHAR](4) NULL"
                $Dict.Integer | Should Be "[column] [TINYINT] NULL"
                $Dict.Decimal | Should Be $null
                $Dict.Boolean | Should Be $null
            }
            $QuoteFuncs | ForEach-Object {
                $c = [CsvColumn]::New("column", 1)
                @(
                    [CsvField]::new($_.Invoke("1")),
                    [CsvField]::new($_.Invoke("12")),
                    [CsvField]::new($_.Invoke("    "))
                ) | ForEach-Object { $c.ReadField($_) }
                AssertDict -Dict $c.CreateDbTypeDict()
            }
        }
        It "���l�^�Œ蒷������ NULL�Ȃ� �i���p������^�Ȃ��j" {
            function AssertDict([hashtable]$Dict) {
                $Dict.Text    | Should Be "[column] [CHAR](7) NOT NULL"
                $Dict.Integer | Should Be "[column] [INT] NOT NULL"
                $Dict.Decimal | Should Be $null
                $Dict.Boolean | Should Be $null
            }
            $QuoteFuncs | ForEach-Object {
                $c = [CsvColumn]::New("column", 1)
                @(
                    [CsvField]::new($_.Invoke("1234567")),
                    [CsvField]::new($_.Invoke("1234567")),
                    [CsvField]::new($_.Invoke("1234567"))
                ) | ForEach-Object { $c.ReadField($_) }
                AssertDict -Dict $c.CreateDbTypeDict()
            }
        }
        It "���l�^�Œ蒷������ NULL���� �i���p������^�Ȃ��j" {
            function AssertDict([hashtable]$Dict) {
                $Dict.Text    | Should Be "[column] [CHAR](10) NULL"
                $Dict.Integer | Should Be "[column] [BIGINT] NULL"
                $Dict.Decimal | Should Be $null
                $Dict.Boolean | Should Be $null
            }
            $QuoteFuncs | ForEach-Object {
                $c = [CsvColumn]::New("column", 1)
                @(
                    [CsvField]::new($_.Invoke("1234567890")),
                    [CsvField]::new($_.Invoke("1234567890")),
                    [CsvField]::new($_.Invoke(""))
                ) | ForEach-Object { $c.ReadField($_) }
                AssertDict -Dict $c.CreateDbTypeDict()
            }
        }

        # Decimal�^
        
        It "���������_�^�ϒ������� NULL�Ȃ� �i���p������^�Ȃ��j" {
            function AssertDict([hashtable]$Dict) {
                $Dict.Text    | Should Be "[column] [VARCHAR](6) NOT NULL"
                $Dict.Integer | Should Be $null
                $Dict.Decimal | Should Be "[column] [DECIMAL](7,2) NOT NULL"
                $Dict.Boolean | Should Be $null
            }
            $QuoteFuncs | ForEach-Object {
                $c = [CsvColumn]::New("column", 1)
                @(
                    [CsvField]::new($_.Invoke(".1")),
                    [CsvField]::new($_.Invoke("123.20")),
                    [CsvField]::new($_.Invoke("12345."))
                ) | ForEach-Object { $c.ReadField($_) }
                AssertDict -Dict $c.CreateDbTypeDict()
            }
        }
        It "���������_�^�ϒ������� NULL���� �i���p������^�Ȃ��j" {
            function AssertDict([hashtable]$Dict) {
                $Dict.Text    | Should Be "[column] [VARCHAR](5) NULL"
                $Dict.Integer | Should Be $null
                $Dict.Decimal | Should Be "[column] [DECIMAL](3,1) NULL"
                $Dict.Boolean | Should Be $null
            }
            $QuoteFuncs | ForEach-Object {
                $c = [CsvColumn]::New("column", 1)
                @(
                    [CsvField]::new($_.Invoke("1.0")),
                    [CsvField]::new($_.Invoke("12.1")),
                    [CsvField]::new($_.Invoke("     "))
                ) | ForEach-Object { $c.ReadField($_) }
                AssertDict -Dict $c.CreateDbTypeDict()
            }
        }
        It "���������_�^�Œ蒷������ NULL�Ȃ� �i���p������^�Ȃ��j" {
            function AssertDict([hashtable]$Dict) {
                $Dict.Text    | Should Be "[column] [CHAR](8) NOT NULL"
                $Dict.Integer | Should Be $null
                $Dict.Decimal | Should Be "[column] [DECIMAL](7,3) NOT NULL"
                $Dict.Boolean | Should Be $null
            }
            $QuoteFuncs | ForEach-Object {
                $c = [CsvColumn]::New("column", 1)
                @(
                    [CsvField]::new($_.Invoke("1234.567")),
                    [CsvField]::new($_.Invoke("1234.567")),
                    [CsvField]::new($_.Invoke("1234.567"))
                ) | ForEach-Object { $c.ReadField($_) }
                AssertDict -Dict $c.CreateDbTypeDict()
            }
        }
        It "���������_�^�Œ蒷������ NULL���� �i���p������^�Ȃ��j" {
            function AssertDict([hashtable]$Dict) {
                $Dict.Text    | Should Be "[column] [CHAR](11) NULL"
                $Dict.Integer | Should Be $null
                $Dict.Decimal | Should Be "[column] [DECIMAL](10,6) NULL"
                $Dict.Boolean | Should Be $null
            }
            $QuoteFuncs | ForEach-Object {
                $c = [CsvColumn]::New("column", 1)
                @(
                    [CsvField]::new($_.Invoke("1234.567890")),
                    [CsvField]::new($_.Invoke("1234.567890")),
                    [CsvField]::new($_.Invoke(""))
                ) | ForEach-Object { $c.ReadField($_) }
                AssertDict -Dict $c.CreateDbTypeDict()
            }
        }

        # Boolean�^

        It "Boolean NULL�Ȃ� �i���p������^�Ȃ��j" {
            function AssertDict([hashtable]$Dict) {
                $Dict.Text    | Should Be "[column] [CHAR](1) NOT NULL"
                $Dict.Integer | Should Be "[column] [TINYINT] NOT NULL"
                $Dict.Decimal | Should Be $null
                $Dict.Boolean | Should Be "[column] [BIT] NOT NULL"
            }
            $QuoteFuncs | ForEach-Object {
                $c = [CsvColumn]::New("column", 1)
                @(
                    [CsvField]::new($_.Invoke("1")),
                    [CsvField]::new($_.Invoke("0")),
                    [CsvField]::new($_.Invoke("1"))
                ) | ForEach-Object { $c.ReadField($_) }
                AssertDict -Dict $c.CreateDbTypeDict()
            }
        }
        It "Boolean NULL���� �i���p������^�Ȃ��j" {
            function AssertDict([hashtable]$Dict) {
                $Dict.Text    | Should Be "[column] [CHAR](1) NULL"
                $Dict.Integer | Should Be "[column] [TINYINT] NULL"
                $Dict.Decimal | Should Be $null
                $Dict.Boolean | Should Be "[column] [BIT] NULL"
            }
            $QuoteFuncs | ForEach-Object {
                $c = [CsvColumn]::New("column", 1)
                @(
                    [CsvField]::new($_.Invoke("")),
                    [CsvField]::new($_.Invoke("0")),
                    [CsvField]::new($_.Invoke("1"))
                ) | ForEach-Object { $c.ReadField($_) }
                AssertDict -Dict $c.CreateDbTypeDict()
            }
        }

        # True or False�^

        It "TrueOrFalse NULL�Ȃ� �i���p������^�Ȃ��j" {
            function AssertDict([hashtable]$Dict) {
                $Dict.Text    | Should Be "[column] [VARCHAR](5) NOT NULL"
                $Dict.Integer | Should Be $null
                $Dict.Decimal | Should Be $null
                $Dict.Boolean | Should Be "[column] [BIT] NOT NULL"
            }
            $QuoteFuncs | ForEach-Object {
                $c = [CsvColumn]::New("column", 1)
                @(
                    [CsvField]::new($_.Invoke("true")),
                    [CsvField]::new($_.Invoke("false")),
                    [CsvField]::new($_.Invoke("TRue"))
                ) | ForEach-Object { $c.ReadField($_) }
                AssertDict -Dict $c.CreateDbTypeDict()
            }
        }
        It "TrueOrFalse NULL���� �i���p������^�Ȃ��j" {
            function AssertDict([hashtable]$Dict) {
                $Dict.Text    | Should Be "[column] [VARCHAR](5) NULL"
                $Dict.Integer | Should Be $null
                $Dict.Decimal | Should Be $null
                $Dict.Boolean | Should Be "[column] [BIT] NULL"
            }
            $QuoteFuncs | ForEach-Object {
                $c = [CsvColumn]::New("column", 1)
                @(
                    [CsvField]::new($_.Invoke("FAlse")),
                    [CsvField]::new($_.Invoke("")),
                    [CsvField]::new($_.Invoke("trUE"))
                ) | ForEach-Object { $c.ReadField($_) }
                AssertDict -Dict $c.CreateDbTypeDict()
            }
        }
    }
}
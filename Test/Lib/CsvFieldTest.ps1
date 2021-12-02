using module "..\..\Src\lib\CsvField.psm1"
using module "..\..\Src\lib\IntegerType.psm1"

function CheckIntegerFieldFlag {
    param (
        [CsvField]$c
    )
    $c.IsMultiByte          | Should Be $false
    $c.IsDecimal            | Should Be $false
    $c.IsInteger            | Should Be $true
    $c.IsNull               | Should Be $false
    $c.Unit                 | Should Be 0
    $c.Significand          | Should Be 0
}

function CheckTFFieldFlag {
    param (
        [CsvField]$c
    )
    $c.IsMultiByte          | Should Be $false
    $c.IsDecimal            | Should Be $false
    $c.IsInteger            | Should Be $false
    $c.IsNull               | Should Be $false
    $c.Unit                 | Should Be 0
    $c.Significand          | Should Be 0
}

function CheckNallowTextFieldFlag([CsvField]$c) {
    $c.Unit                 | Should Be 0
    $c.Significand          | Should Be 0
    $c.IsBoolean            | Should Be $false
    $c.IsMultiByte          | Should Be $false
    $c.IsDecimal            | Should Be $false
    $c.IsInteger            | Should Be $false
    $c.IsNull               | Should Be $false
    $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
}
function CheckNallowTextQuotedFieldFlag([CsvField]$c) {
    $c.Unit                 | Should Be 0
    $c.Significand          | Should Be 0
    $c.IsBoolean            | Should Be $false
    $c.IsMultiByte          | Should Be $false
    $c.IsDecimal            | Should Be $false
    $c.IsInteger            | Should Be $false
    $c.IsNull               | Should Be $false
    $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
}
function CheckWideTextFieldFlag([CsvField]$c) {
    $c.Unit                 | Should Be 0
    $c.Significand          | Should Be 0
    $c.IsBoolean            | Should Be $false
    $c.IsMultiByte          | Should Be $true
    $c.IsDecimal            | Should Be $false
    $c.IsInteger            | Should Be $false
    $c.IsNull               | Should Be $false
    $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
}
function CheckWideTextQuotedFieldFlag([CsvField]$c) {
    $c.Unit                 | Should Be 0
    $c.Significand          | Should Be 0
    $c.IsBoolean            | Should Be $false
    $c.IsMultiByte          | Should Be $true
    $c.IsDecimal            | Should Be $false
    $c.IsInteger            | Should Be $false
    $c.IsNull               | Should Be $false
    $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
}

function CheckDecimalFieldFlag([CsvField]$c) {
    $c.IsBoolean            | Should Be $false
    $c.IsMultiByte          | Should Be $false
    $c.IsDecimal            | Should Be $true
    $c.IsInteger            | Should Be $false
    $c.IsNull               | Should Be $false
    $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
}

function CheckDecimalQuotedFieldFlag([CsvField]$c) {
    $c.IsBoolean            | Should Be $false
    $c.IsMultiByte          | Should Be $false
    $c.IsDecimal            | Should Be $true
    $c.IsInteger            | Should Be $false
    $c.IsNull               | Should Be $false
    $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
}

Describe "CsvField SetEncoding" {
    Context "正常系" {
        It "初期値" {
            [CsvField]::Encoding | Should Be ([System.Text.Encoding]::Default)
        } 
        It "初期値" {
            [CsvField]::SetEncoding([System.Text.Encoding]::Unicode)
            [CsvField]::Encoding | Should Be ([System.Text.Encoding]::Unicode)
        } 
    }
}
Describe "CsvField コンストラクタ" {
    BeforeAll {
        [CsvField]::SetEncoding([System.Text.Encoding]::Default)
    }
    Context "文字列 引用なし" {
        It "半角英" {
            $arg = "a"
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 1
            $c.TrimmedDataLength    | Should Be 1
            CheckNallowTextFieldFlag($c)
        }
        It "全角ひらがな" {
            $arg = "あ"
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 1
            $c.TrimmedDataLength    | Should Be 1
            CheckWideTextFieldFlag($c)
        }
        It "全角数字" {
            $arg = "１"
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 1
            $c.TrimmedDataLength    | Should Be 1
            CheckWideTextFieldFlag($c)
        }
        It "全角漢字" {
            $arg = "機"
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 1
            $c.TrimmedDataLength    | Should Be 1
            CheckWideTextFieldFlag($c)
        }
        It "全角記号" {
            $arg = "、"
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 1
            $c.TrimmedDataLength    | Should Be 1
            CheckWideTextFieldFlag($c)
        }
    }

    Context "整数型 引用符なし" {
        It "bool-1" {
            [string]$arg = "1"
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 1
            $c.TrimmedDataLength    | Should Be 1
            $c.IntegerType          | Should Be ([IntegerType]::TinyInt)
            $c.IsBoolean            | Should Be $true
            CheckIntegerFieldFlag($c)
        }

        It "bool-0" {
            [string]$arg = "0"
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 1
            $c.TrimmedDataLength    | Should Be 1
            $c.IntegerType          | Should Be ([IntegerType]::TinyInt)
            $c.IsBoolean            | Should Be $true
            CheckIntegerFieldFlag($c)
        }

        It "bool-true" {
            [string]$arg = "true"
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 4
            $c.TrimmedDataLength    | Should Be 4
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
            $c.IsBoolean            | Should Be $false
            $c.IsTrueOrFalse        | Should Be $true
            CheckTFFieldFlag($c)
        }
        It "bool-TRUE" {
            [string]$arg = "TRUE"
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 4
            $c.TrimmedDataLength    | Should Be 4
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
            $c.IsBoolean            | Should Be $false
            $c.IsTrueOrFalse        | Should Be $true
            CheckTFFieldFlag($c)
        }
        It "bool-false" {
            [string]$arg = "false"
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 5
            $c.TrimmedDataLength    | Should Be 5
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
            $c.IsBoolean            | Should Be $false
            $c.IsTrueOrFalse        | Should Be $true
            CheckTFFieldFlag($c)
        }
        It "bool-FALSE" {
            [string]$arg = "FALSE"
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 5
            $c.TrimmedDataLength    | Should Be 5
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
            $c.IsBoolean            | Should Be $false
            $c.IsTrueOrFalse        | Should Be $true
            CheckTFFieldFlag($c)
        }

        It "TinyInt" {
            [string]$arg = "99"
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 2
            $c.TrimmedDataLength    | Should Be 2
            $c.IntegerType          | Should Be ([IntegerType]::TinyInt)
            $c.IsBoolean            | Should Be $false
            CheckIntegerFieldFlag($c)
        }

        It "SmallInt最小" {
            [string]$arg = "100"
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 3
            $c.TrimmedDataLength    | Should Be 3
            $c.IntegerType          | Should Be ([IntegerType]::SmallInt)
            $c.IsBoolean            | Should Be $false
            CheckIntegerFieldFlag($c)
        }
    
        It "SmallInt最大" {
            [string]$arg = "9999"
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 4
            $c.TrimmedDataLength    | Should Be 4
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IntegerType          | Should Be ([IntegerType]::SmallInt)
            $c.IsBoolean            | Should Be $false
            CheckIntegerFieldFlag($c)
        }
        It "Int最小" {
            [string]$arg = "10000"
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 5
            $c.TrimmedDataLength    | Should Be 5
            $c.IntegerType          | Should Be ([IntegerType]::Int)
            $c.IsBoolean            | Should Be $false
            CheckIntegerFieldFlag($c)
        }
        It "Int最大" {
            [string]$arg = "999999999"
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 9
            $c.TrimmedDataLength    | Should Be 9
            $c.IntegerType          | Should Be ([IntegerType]::Int)
            $c.IsBoolean            | Should Be $false
            CheckIntegerFieldFlag($c)
        }
        It "BigInt最小" {
            [string]$arg = "1000000000"
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 10
            $c.TrimmedDataLength    | Should Be 10
            $c.IntegerType          | Should Be ([IntegerType]::BigInt)
            $c.IsBoolean            | Should Be $false
            CheckIntegerFieldFlag($c)
        }
        It "BigInt最大" {
            [string]$arg = "999999999999999999"
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 18
            $c.TrimmedDataLength    | Should Be 18
            $c.IntegerType          | Should Be ([IntegerType]::BigInt)
            $c.IsBoolean            | Should Be $false
            CheckIntegerFieldFlag($c)
        }
        It "整数型範囲外" {
            [string]$arg = "1000000000000000000"
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 19
            $c.TrimmedDataLength    | Should Be 19
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
            $c.IsBoolean            | Should Be $false
            CheckIntegerFieldFlag($c)
        }
    }

    Context "文字列 引用符あり" {
        It "半角英" {
            $arg = '"a"'
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 1
            $c.TrimmedDataLength    | Should Be 1
            CheckNallowTextQuotedFieldFlag($c)
        }
        It "全角ひらがな" {
            $arg = '"あ"'
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 1
            $c.TrimmedDataLength    | Should Be 1
            CheckWideTextQuotedFieldFlag($c)
        }
        It "全角英" {
            $arg = '"ｗ"'
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 1
            $c.TrimmedDataLength    | Should Be 1
            CheckWideTextQuotedFieldFlag($c)
        }
        It "全角数字" {
            $arg = '"１"'
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 1
            $c.TrimmedDataLength    | Should Be 1
            CheckWideTextQuotedFieldFlag($c)
        }
        It "全角記号" {
            $arg = '"、"'
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 1
            $c.TrimmedDataLength    | Should Be 1
            CheckWideTextQuotedFieldFlag($c)
        }
    }

    Context "NULL" {
        It "空文字" {
            $arg = ''
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 0
            $c.TrimmedDataLength    | Should Be 0
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsBoolean            | Should Be $false
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.IsInteger            | Should Be $false
            $c.IsNull               | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
        }
        It "空文字 引用符あり" {
            $arg = '""'
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 0
            $c.TrimmedDataLength    | Should Be 0
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsBoolean            | Should Be $false
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.IsInteger            | Should Be $false
            $c.IsNull               | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
        }
        It "スペース 引用符なし" {
            $arg = ' '
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 1
            $c.TrimmedDataLength    | Should Be 0
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsBoolean            | Should Be $false
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.IsInteger            | Should Be $false
            $c.IsNull               | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
        }
        It "スペース 引用符あり" {
            $arg = '" "'
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 1
            $c.TrimmedDataLength    | Should Be 0
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsBoolean            | Should Be $false
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.IsInteger            | Should Be $false
            $c.IsNull               | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
        }
        It "NULL記号 引用符あり" {
            $arg = '\N'
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 2
            $c.TrimmedDataLength    | Should Be 2
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsBoolean            | Should Be $false
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.IsInteger            | Should Be $false
            $c.IsNull               | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
        }
        It "NULL記号 引用符あり" {
            $arg = '"\N"'
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 2
            $c.TrimmedDataLength    | Should Be 2
            $c.Unit                 | Should Be 0
            $c.Significand          | Should Be 0
            $c.IsBoolean            | Should Be $false
            $c.IsMultiByte          | Should Be $false
            $c.IsDecimal            | Should Be $false
            $c.IsInteger            | Should Be $false
            $c.IsNull               | Should Be $true
            $c.IntegerType          | Should Be ([IntegerType]::OutOfRange)
        }
    }
    Context "浮動小数点型 引用符なし" {
        It "小数点型" {
            $arg = '1.0'
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 3
            $c.TrimmedDataLength    | Should Be 3
            $c.Unit                 | Should Be 1
            $c.Significand          | Should Be 1
            CheckDecimalFieldFlag($c)
        }
        It "頭ゼロ埋め" {
            $arg = '01.0'
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 4
            $c.TrimmedDataLength    | Should Be 4
            $c.Unit                 | Should Be 2
            $c.Significand          | Should Be 1
            CheckDecimalFieldFlag($c)
        }
        It "少数部なし" {
            $arg = '01.'
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 3
            $c.TrimmedDataLength    | Should Be 3
            $c.Unit                 | Should Be 2
            $c.Significand          | Should Be 1
            CheckDecimalFieldFlag($c)
        }
        It "整数部なし" {
            $arg = '.05'
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 3
            $c.TrimmedDataLength    | Should Be 3
            $c.Unit                 | Should Be 1
            $c.Significand          | Should Be 2
            CheckDecimalFieldFlag($c)
        }
    }
    Context "浮動小数点型 引用符あり" {
        It "小数点型" {
            $arg = '"1.0"'
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 3
            $c.TrimmedDataLength    | Should Be 3
            $c.Unit                 | Should Be 1
            $c.Significand          | Should Be 1
            CheckDecimalQuotedFieldFlag($c)
        }
        It "頭ゼロ埋め" {
            $arg = '"01.0"'
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 4
            $c.TrimmedDataLength    | Should Be 4
            $c.Unit                 | Should Be 2
            $c.Significand          | Should Be 1
            CheckDecimalQuotedFieldFlag($c)
        }
        It "少数部なし" {
            $arg = '"01."'
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 3
            $c.TrimmedDataLength    | Should Be 3
            $c.Unit                 | Should Be 2
            $c.Significand          | Should Be 1
            CheckDecimalQuotedFieldFlag($c)
        }
        It "整数部なし" {
            $arg = '".05"'
            $c = [CsvField]::new($arg)
            $c.DataLength           | Should Be 3
            $c.TrimmedDataLength    | Should Be 3
            $c.Unit                 | Should Be 1
            $c.Significand          | Should Be 2
            CheckDecimalQuotedFieldFlag($c)
        }
    }
}
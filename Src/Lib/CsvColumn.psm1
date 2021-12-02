using namespace System.Collections.Generic
using module ".\CsvField.psm1"
using module ".\IntegerType.psm1"

class CsvColumn :CsvField {

    [string]$ColumnName
    [int]$ColumnIndex
    hidden [bool]$IsFixedLength
    hidden [bool]$IsFirstAddNotNullField
    hidden [HashSet[int]]$DataLengthSet

    CsvColumn([string]$Name, [int]$ColumnIndex):Base() {
        if (-not $Name) {
            throw "名前が指定されていません。"
        }
        if ($ColumnIndex -lt 0) {
            throw "列番号が範囲外です。"
        }
        $this.ColumnName = $Name
        $this.ColumnIndex = $ColumnIndex
        $this.IntegerType = [IntegerType]::OutOfRange
        $this.IsFirstAddNotNullField = $true
        $this.DataLengthSet = [HashSet[int]]::New()
    }

    [void]ReadField([CsvField]$Field){
        if (-not $Field) {
            throw "引数がNullです。"
        }
        if (-not $Field.IsNull) {
            # 下記のフラグはNULLでないすべての要素がTrueの場合にTrueになる
            if ($this.IsFirstAddNotNullField) {
                $this.IsDecimal = $Field.IsDecimal
                $this.IsInteger = $Field.IsInteger
                $this.IsBoolean = $Field.IsBoolean
                $this.IsTrueOrFalse = $Field.IsTrueOrFalse
                $this.IsFirstAddNotNullField = $false
            }
            # NULL以外のすべての文字列が小数に変換できれば小数とする。
            $this.IsDecimal = $this.IsDecimal -and $Field.IsDecimal
            if ($this.IsDecimal) {
                $this.Unit = [Math]::Max($this.Unit, $Field.Unit)
                $this.Significand = [Math]::Max($this.Significand, $Field.Significand)
            }
            # NULL以外のすべての文字列が整数に変換できれば整数とする。
            $this.IsInteger = $this.IsInteger -and $Field.IsInteger
            if ($this.IsInteger) {
                if ([int]$this.IntegerType -lt [int]$Field.IntegerType) {
                    $this.IntegerType = $Field.IntegerType
                }
            }
            # NULL以外のすべての文字列がブール値に変換できればブール値とする。
            $this.IsBoolean = $this.IsBoolean -and $Field.IsBoolean
            $this.IsTrueOrFalse = $this.IsTrueOrFalse -and $Field.IsTrueOrFalse
        }
        else {
            # 1つでもNULLがあればNULLABLEとする。
            $this.IsNull = $true
        }
        # いずれかtrueの時にtrueとする。
        $this.IsMultibyte = $this.IsMultibyte -or $Field.IsMultibyte
        # データ長は最大を取る。
        $this.DataLength = [System.Math]::Max($this.DataLength, $Field.DataLength )
        $this.TrimmedDataLength = [System.Math]::Max($this.TrimmedDataLength, $Field.TrimmedDataLength)
        # すべてのデータ列の長さを確認して、ゼロ以外すべて同じ長さの場合、固定長と判断する。
        # 例えば 長さ 10 と 0 であれば、固定長のNULLABLEとして扱う
        $this.DataLengthSet.Add($Field.TrimmedDataLength)
        $this.IsFixedLength = ($this.DataLengthSet | Where-Object { $_ -ne 0 }).Count -eq 1
    }

    [hashtable] CreateDbTypeDict() {
        # NULL許容
        $nullable = "NOT NULL"
        if ($this.IsNull) { $nullable = "NULL" }

        # 文字列型判定 
        $textDefinition = "CHAR"
        if (-not $this.IsFixedLength) {
            $textDefinition = "VAR$textDefinition"
        }
        if ($this.IsMultiByte) {
            $textDefinition = "N$textDefinition"
        }
        return @{
            Text    = "[$($this.ColumnName)] [$textDefinition]($($this.DataLength)) $nullable";
            Integer = if ($this.IsInteger) {"[$($this.ColumnName)] [$($this.IntegerType.ToString().ToUpper())] $nullable"};
            Decimal = if ($this.IsDecimal) {"[$($this.ColumnName)] [DECIMAL]($($this.Significand + $this.Unit),$($this.Significand)) $nullable"};
            Boolean = if ($this.IsBoolean -or $this.IsTrueOrFalse) {"[$($this.ColumnName)] [BIT] $nullable"};
        }
    }

}
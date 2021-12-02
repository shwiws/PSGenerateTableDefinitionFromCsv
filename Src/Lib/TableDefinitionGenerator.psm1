using namespace System.Collections.Generic
using module ".\CsvField.psm1"
using module ".\CsvColumn.psm1"

class TableDefinitionGenerator {
    [CsvColumn[]]$Columns = @()
    [System.Text.Encoding]$Encoding = [System.Text.Encoding]::Default

    TableDefinitionGenerator([string]$Path, [string]$Delimiter, [System.Text.Encoding]$Encoding, [int]$CountToRead) {
        if (-not (Test-Path $Path)) { throw "ファイルが存在しません。" }
        if (-not $Delimiter) { throw "区切り文字が不正です。" }
        if (-not $Encoding) { throw "エンコーディングが指定されていません。" }
        if ($CountToRead -le 0) { throw "エンコーディングが指定されていません。" }
        # エンコーディングを設定
        [CsvField]::SetEncoding($Encoding)
        $csvLines = [System.IO.File]::ReadAllLines($Path, $Encoding)
        if ($csvLines.Count -lt 2) {
            throw "データが足りません";
        }

        # ヘッダーに合わせて
        $headers = $csvLines[0].Split($Delimiter) | ForEach-Object { $_ -replace '^"|"$', '' }
        for ($col = 0; $col -lt $headers.Count; $col++) {
            $this.Columns += [CsvColumn]::New($headers[$col], $col)
        }

        # 各行のフィールドを読み込む
        $count = [Math]::Min($CountToRead + 1, $csvLines.Count)
        for ($row = 1; $row -lt $count; $row++) {
            $fields = $csvLines[$row] -split $Delimiter
            for ($col = 0; $col -lt $Headers.Count; $col++) {
                $this.Columns[$col].ReadField([CsvField]::New($fields[$col]))
            }
        }
    }

    [void]Generate([string]$path) {
        if (Test-Path -Path $path) {
            throw "すでにファイルが存在します。上書きはしません。"
        }
        # ジャグ配列のために、カンマを使う。
        $data = @(,@("Column", "Index", "Text", "Integer", "Decimal", "Boolean"))
        for ($col = 0; $col -lt $this.Columns.Count; $col++) {
            [CsvColumn]$csv = $this.Columns[$col]
            $dict = $csv.CreateDbTypeDict()
            $data += ,@(
                $csv.ColumnName,
                $csv.ColumnIndex,
                $dict["Text"],
                $dict["Integer"],
                $dict["Decimal"],
                $dict["Boolean"]
            )
        }
        $text = (($data | ForEach-Object { $_ -join "," }) -join "`n")
        [System.IO.File]::WriteAllText($path,$text,[System.Text.Encoding]::UTF8)
    }
    
}
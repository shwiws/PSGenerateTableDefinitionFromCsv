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
            throw "���O���w�肳��Ă��܂���B"
        }
        if ($ColumnIndex -lt 0) {
            throw "��ԍ����͈͊O�ł��B"
        }
        $this.ColumnName = $Name
        $this.ColumnIndex = $ColumnIndex
        $this.IntegerType = [IntegerType]::OutOfRange
        $this.IsFirstAddNotNullField = $true
        $this.DataLengthSet = [HashSet[int]]::New()
    }

    [void]ReadField([CsvField]$Field){
        if (-not $Field) {
            throw "������Null�ł��B"
        }
        if (-not $Field.IsNull) {
            # ���L�̃t���O��NULL�łȂ����ׂĂ̗v�f��True�̏ꍇ��True�ɂȂ�
            if ($this.IsFirstAddNotNullField) {
                $this.IsDecimal = $Field.IsDecimal
                $this.IsInteger = $Field.IsInteger
                $this.IsBoolean = $Field.IsBoolean
                $this.IsTrueOrFalse = $Field.IsTrueOrFalse
                $this.IsFirstAddNotNullField = $false
            }
            # NULL�ȊO�̂��ׂĂ̕����񂪏����ɕϊ��ł���Ώ����Ƃ���B
            $this.IsDecimal = $this.IsDecimal -and $Field.IsDecimal
            if ($this.IsDecimal) {
                $this.Unit = [Math]::Max($this.Unit, $Field.Unit)
                $this.Significand = [Math]::Max($this.Significand, $Field.Significand)
            }
            # NULL�ȊO�̂��ׂĂ̕����񂪐����ɕϊ��ł���ΐ����Ƃ���B
            $this.IsInteger = $this.IsInteger -and $Field.IsInteger
            if ($this.IsInteger) {
                if ([int]$this.IntegerType -lt [int]$Field.IntegerType) {
                    $this.IntegerType = $Field.IntegerType
                }
            }
            # NULL�ȊO�̂��ׂĂ̕����񂪃u�[���l�ɕϊ��ł���΃u�[���l�Ƃ���B
            $this.IsBoolean = $this.IsBoolean -and $Field.IsBoolean
            $this.IsTrueOrFalse = $this.IsTrueOrFalse -and $Field.IsTrueOrFalse
        }
        else {
            # 1�ł�NULL�������NULLABLE�Ƃ���B
            $this.IsNull = $true
        }
        # �����ꂩtrue�̎���true�Ƃ���B
        $this.IsMultibyte = $this.IsMultibyte -or $Field.IsMultibyte
        # �f�[�^���͍ő�����B
        $this.DataLength = [System.Math]::Max($this.DataLength, $Field.DataLength )
        $this.TrimmedDataLength = [System.Math]::Max($this.TrimmedDataLength, $Field.TrimmedDataLength)
        # ���ׂẴf�[�^��̒������m�F���āA�[���ȊO���ׂē��������̏ꍇ�A�Œ蒷�Ɣ��f����B
        # �Ⴆ�� ���� 10 �� 0 �ł���΁A�Œ蒷��NULLABLE�Ƃ��Ĉ���
        $this.DataLengthSet.Add($Field.TrimmedDataLength)
        $this.IsFixedLength = ($this.DataLengthSet | Where-Object { $_ -ne 0 }).Count -eq 1
    }

    [hashtable] CreateDbTypeDict() {
        # NULL���e
        $nullable = "NOT NULL"
        if ($this.IsNull) { $nullable = "NULL" }

        # ������^���� 
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
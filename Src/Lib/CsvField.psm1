using namespace System.Text
using module .\IntegerType.psm1
using module .\IntegerTypeChecker.psm1

class CsvField {

    hidden static [Encoding]$Encoding
    hidden static [string[]]$BooleanTexts = @("0", "1")
    hidden static [string[]]$TrueOrFalseTexts = @("true", "false")

    [int]$DataLength
    [int]$TrimmedDataLength
    [bool]$IsMultiByte
    [bool]$IsInteger
    [bool]$IsDecimal
    [bool]$IsBoolean
    [bool]$IsTrueOrFalse
    [bool]$IsNull
    [int]$Unit #������
    [int]$Significand #�����_�ȉ�
    [IntegerType]$IntegerType

    static CsvField() {
        [CsvField]::Encoding = [Encoding]::Default
    }

    static [void] SetEncoding([Encoding]$Encoding) {
        [CsvField]::Encoding = $Encoding
    }
    CsvField() {
        # �����Ȃ�
    }
    CsvField([string]$Value) {
        if ($null -eq $Value) {
            throw "Argument Invalid"
        }
        $this.IntegerType = [IntegerType]::OutOfRange
        $this.Read($Value)
    }

    [void]Read([string]$Text) {
        if ($Text -match '^"(.*)"$') {
            $Text = $Matches.Item(1)
        }
        $trimmedText = $Text.Trim()
        $this.DataLength = $Text.Length
        $this.TrimmedDataLength = $trimmedText.Length
        # NULL����� ���p���̖����󕶎���\N�Ƃ���B
        # �Q�l: https://nagix.hatenablog.com/entry/2015/12/14/235900
        $this.IsNull = $this.TrimmedDataLength -eq 0 -or $Text -eq "\N"
        if (-not $this.IsNull) {
            $this.IsMultiByte = $this.DataLength -ne [Encoding]::UTF8.GetByteCount($Text)
            # �����I�ɏ���������ꍇ�̂�
            $temp = 0
            $this.IsDecimal = [decimal]::TryParse($trimmedText, [ref]$temp) -and $trimmedText.Contains(".")
            # �L�������Ə����_�ȉ����擾����
            if ($this.IsDecimal) {
                $pands = $trimmedText -split "\."
                $uni = $pands[0].Length
                $sig = $pands[1].Length
                # �����_�̉E�̐������ȗ����ꂽ��A�擪�̐������ȗ����ꂽ�P�[�X�͌���1�⊮����B
                $this.Unit = if ($uni) { $uni }else { 1 }
                $this.Significand = if ($sig) { $sig }else { 1 }
            }
            $this.IsInteger = [Int64]::TryParse($trimmedText, [ref]$temp)
            if ($this.IsInteger) {
                $maxIntByTextLength = [Math]::Pow(10, $this.TrimmedDataLength) - 1
                $this.IntegerType = [IntegerTypeChecker]::GetIntegerType($maxIntByTextLength)
            }
            if ($this.DataLength -eq 1) {
                $this.IsBoolean = [CsvField]::BooleanTexts.Contains($Text)
            }
            $this.IsTrueOrFalse = [CsvField]::TrueOrFalseTexts.Contains($Text.ToLower())
        }
    }
}
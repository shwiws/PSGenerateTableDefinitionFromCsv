using module ".\Range.psm1"
using module ".\IntegerType.psm1"

class IntegerTypeChecker {
    hidden static [Range[]] $IntegerTypeRanges
    hidden static [IntegerType[]] $IntegerTypes
    static IntegerTypeChecker() {
        [IntegerTypeChecker]::IntegerTypes = @(
            [IntegerType]::BigInt,
            [IntegerType]::Int,
            [IntegerType]::SmallInt,
            [IntegerType]::TinyInt
        )
        [IntegerTypeChecker]::IntegerTypeRanges = @(
            [Range]::New([Int64]::MinValue, [Int64]::MaxValue),
            [Range]::New([Int32]::MinValue, [Int32]::MaxValue),
            [Range]::New([Int16]::MinValue, [Int16]::MaxValue),
            [Range]::New([byte]::MinValue, [byte]::MaxValue)
        )
    }
    static [IntegerType] GetIntegerType([decimal]$Value) {
        # ‘å‚«‚¢”ÍˆÍ‚©‚çŽn‚ß‚é
        [IntegerType]$type = [IntegerType]::OutOfRange
        [Range]$r = $null
        for ($i = 0; $i -lt [IntegerTypeChecker]::IntegerTypeRanges.Count; $i++) {
            $r = [IntegerTypeChecker]::IntegerTypeRanges[$i]
            if ($r.Contains($Value)) {
                $type = [IntegerTypeChecker]::IntegerTypes[$i]
            }
            else {
                break
            }
        }
        return $type
    }
}
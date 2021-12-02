using module ..\..\Src\lib\IntegerTypeChecker.psm1
using module ..\..\Src\lib\IntegerType.psm1

Describe "IntegerTypeChecker" {
    It "GetIntegerType - TinyInt" {
        [IntegerTypeChecker]::GetIntegerType(0) | Should Be ([IntegerType]::TinyInt)
        [IntegerTypeChecker]::GetIntegerType(1) | Should Be ([IntegerType]::TinyInt)
        [IntegerTypeChecker]::GetIntegerType([byte]::MaxValue) | Should Be ([IntegerType]::TinyInt)
        [IntegerTypeChecker]::GetIntegerType([byte]::MaxValue-1) | Should Be ([IntegerType]::TinyInt)
    }
    It "GetIntegerType - SmallInt" {
        [IntegerTypeChecker]::GetIntegerType([Int16]::MinValue) | Should Be ([IntegerType]::SmallInt)
        [IntegerTypeChecker]::GetIntegerType(-1) | Should Be ([IntegerType]::SmallInt)
        [IntegerTypeChecker]::GetIntegerType([byte]::MaxValue+1) | Should Be ([IntegerType]::SmallInt)
        [IntegerTypeChecker]::GetIntegerType([Int16]::MaxValue) | Should Be ([IntegerType]::SmallInt)
    }
    It "GetIntegerType - Int" {
        [IntegerTypeChecker]::GetIntegerType([Int32]::MinValue) | Should Be ([IntegerType]::Int)
        [IntegerTypeChecker]::GetIntegerType([Int16]::MinValue-1) | Should Be ([IntegerType]::Int)
        [IntegerTypeChecker]::GetIntegerType([Int16]::MaxValue+1) | Should Be ([IntegerType]::Int)
        [IntegerTypeChecker]::GetIntegerType([Int32]::MaxValue) | Should Be ([IntegerType]::Int)
    }
    It "GetIntegerType - BigInt" {
        [IntegerTypeChecker]::GetIntegerType([Int64]::MinValue) | Should Be ([IntegerType]::BigInt)
        [IntegerTypeChecker]::GetIntegerType([Int32]::MinValue-1) | Should Be ([IntegerType]::BigInt)
        [IntegerTypeChecker]::GetIntegerType([Int32]::MaxValue+1) | Should Be ([IntegerType]::BigInt)
        [IntegerTypeChecker]::GetIntegerType([Int64]::MaxValue) | Should Be ([IntegerType]::BigInt)
    }
    It "GetIntegerType - OutOfRange" {
        [IntegerTypeChecker]::GetIntegerType([decimal]::MinValue) | Should Be ([IntegerType]::OutOfRange)
        [IntegerTypeChecker]::GetIntegerType([decimal]::MaxValue) | Should Be ([IntegerType]::OutOfRange)
    }
}

using module "..\..\Src\lib\Range.psm1"

Describe "Range" {
    It "[new]àŸèÌån" {
        {[Range]::new(1,0)} | Should Throw
    }
    It "[new]ê≥èÌån(êÆêî)" {
        $r = [Range]::new(0,0)
        $r.Min | Should Be 0
        $r.Max | Should Be 0

        $r = [Range]::new(0,1)
        $r.Min | Should Be 0
        $r.Max | Should Be 1
    }
    It "[new]ê≥èÌån(Min/Max)" {
        $r = [Range]::new([byte]::MinValue,[byte]::MaxValue)
        $r.Min | Should Be ([decimal]([byte]::MinValue))
        $r.Max | Should Be ([decimal]([byte]::MaxValue))

        $r = [Range]::new([Int16]::MinValue,[Int16]::MaxValue)
        $r.Min | Should Be ([decimal]([Int16]::MinValue))
        $r.Max | Should Be ([decimal]([Int16]::MaxValue))

        $r = [Range]::new([Int32]::MinValue,[Int32]::MaxValue)
        $r.Min | Should Be ([decimal]([Int32]::MinValue))
        $r.Max | Should Be ([decimal]([Int32]::MaxValue))

        $r = [Range]::new([Int64]::MinValue,[Int64]::MaxValue)
        $r.Min | Should Be ([decimal]([Int64]::MinValue))
        $r.Max | Should Be ([decimal]([Int64]::MaxValue))

        $r = [Range]::new([decimal]::MinValue,[decimal]::MaxValue)
        $r.Min | Should Be ([decimal]([decimal]::MinValue))
        $r.Max | Should Be ([decimal]([decimal]::MaxValue))
    }
    It "[Contains]" {
        $r = [Range]::new(0,1)
        $r.Contains(-0.0000000001) | Should Be $false
        $r.Contains(0) | Should Be $true
        $r.Contains(1) | Should Be $true
        $r.Contains(2) | Should Be $false
    }
}

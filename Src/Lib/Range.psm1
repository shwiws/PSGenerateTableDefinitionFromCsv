class Range {
    [decimal]$Min
    [decimal]$Max
    Range([decimal]$Min, [decimal]$Max) {
        if($Max -lt $Min){
            throw "Argument invalid `$Max:$Max `$Min:$Min"
        }
        $this.Min = $Min
        $this.Max = $Max
    }
    [bool] Contains([decimal]$Value) {
        return $this.Min -ile $Value -and $Value -ile $this.Max 
    }
}

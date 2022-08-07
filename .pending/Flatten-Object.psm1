function Flatten-Object {
    [cmdletbinding()]
    param(
        [parameter(ValueFromPipeline)]
        [pscustomobject[]]$Inputobject,
        [string]$Prefix,
        $Depth=1,
        [hashtable]$NewObject=@{},
        [hashtable]$SubstitutionScriptBlockTable=@{}
    )
    begin {
        $NOC = $NewObject.Clone()
    }
    process {
        $Depth--
        foreach ($InputobjectItem in ($Inputobject|%{$_}|?{$null -ne $_}))
        {
            foreach ($Property in ($InputobjectItem.psobject.properties|?{$_.name -ne 'syncroot|parent|(inner|outer)(xml|html)'}))
            {
                $NewPrefix = ($prefix,$property.name|?{$_ -match '\w'}) -join ' '
                if ($NewPrefix|?{$_ -match '\w'}|?{$SubstitutionScriptBlockTable.contains($_)}) {
                    $NewObject[$NewPrefix]= . $SubstitutionScriptBlockTable[$NewPrefix]
                }
                elseif ($null -ne ($Property.value).Name) {$NewObject[$NewPrefix]=$Property.value.name}
                elseif ($NewPrefix -notin 'Root','Parent','PSProvider Drives','PSParentPath') {
                    switch -Regex ($Property.TypeNameOfValue) 
                    {
                        '^system.(u|)int'      {
                            $NewObject[$NewPrefix]=$Property.value -join ', '
                    
                        }

                        '^system.string'       {
                            $NewObject[$NewPrefix]=$Property.value -join "`n"
                    
                        }
                        '^system.(date|time)'  {$NewObject[$NewPrefix]=$Property.value.tostring() -join "`n"}
                        default    {
                            if ($depth -eq 0)
                            {
                                $NewObject[$NewPrefix]=($Property.value|fl|out-string) -replace '\s*(\n)','$1' -replace '\n\s*$'
                            }
                            else {
                                Flatten-Object -NewObject $NewObject -Inputobject $property.value -Prefix $NewPrefix -Depth $Depth
                            }
                        }
                    }
                }
            }
        }
        if ($NOC.count -eq 0) {
            if ($Prefix -notmatch '\s') {
                [pscustomobject]$NewObject
            }
        }
    }
}

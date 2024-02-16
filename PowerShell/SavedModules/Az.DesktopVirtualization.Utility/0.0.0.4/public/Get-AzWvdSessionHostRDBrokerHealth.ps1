Function Get-AzWvdSessionHostRDBrokerHealth {

    [CmdletBinding(
        SupportsShouldProcess = $True,
        ConfirmImpact = "High")]

    Param (

        [ValidateSet(
            "BrokerURI"
            , "BrokerURIGlobal"
            , "DiagnosticsURI"
        )]
        [ArgumentCompleter({ "BrokerURI" , "BrokerURIGlobal" , "DiagnosticsURI" })]
        [Parameter(
            Mandatory = $False
            , ValueFromPipeline = $True
            , ValueFromPipelineByPropertyName = $True
            , ParameterSetName = "HealthCheck"
        )]
        [Alias("C")]
        [string]
        $Check,

        [Parameter(
            Mandatory = $False
            , ValueFromPipeline = $True
            , ValueFromPipelineByPropertyName = $True
            , ParameterSetName = "HealthCheck"
        )]
        [Alias("R", "Report")]
        [switch]
        $HealthReport,

        [Parameter(
            Mandatory = $False
            , ValueFromPipeline = $True
            , ValueFromPipelineByPropertyName = $True
        )]
        [switch]
        $Raw
    )

    Begin {}

    Process {

        if ($PSBoundParameters.ContainsKey("Check")) {

            if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\RDInfraAgent" -PathType "Container") {

                $Response = Invoke-WebRequest `
                    -Uri "$(Get-ItemPropertyValue `
                        -Path "HKLM:\SOFTWARE\Microsoft\RDInfraAgent" `
                        -Name $Check)/api/health" `
                    -UseBasicParsing | Select-Object `
                    -ExpandProperty "Content"
            }
        }
        else {

            if (!(Test-Path -Path "HKLM:\SOFTWARE\Microsoft\RDInfraAgent" -PathType "Container")) {

                $Uri = "https://rdbroker.wvdselfhost.microsoft.com"

                $Response = Invoke-WebRequest `
                    -Uri "$Uri/api/health" `
                    -UseBasicParsing | Select-Object `
                    -ExpandProperty "Content"

            }
            else {

                $Response = @("BrokerURI", "BrokerURIGlobal", "DiagnosticsURI") | ForEach-Object -Process {

                    Invoke-WebRequest `
                        -Uri "$(Get-ItemPropertyValue `
                        -Path "HKLM:\SOFTWARE\Microsoft\RDInfraAgent" `
                        -Name $_)/api/health" `
                        -UseBasicParsing | Select-Object `
                        -ExpandProperty "Content"
                }
                
            }
        }

        if ($PSBoundParameters.ContainsKey("HealthReport")) {

            $HealthReportsObject = @()
            
            if ([string]::IsNullOrEmpty($Check)) {

                $HealthCheck = @("BrokerURI", "BrokerURIGlobal", "DiagnosticsURI")
            }
            else {

                $HealthCheck = @($Check)
            }

            $ArrayIndex = 0

            $Response | ConvertFrom-Json | ForEach-Object -Process {

                ($_.HealthCheckStatus.HealthReport.Entries).PSObject.Properties | ForEach-Object -Process {

                    $HealthReportObject = [PSCustomObject]@{
                        HealthReport =  "$($HealthCheck[$ArrayIndex]) - $($_.Name)"
                    }
            
                    ($_.Value).PSObject.Properties | ForEach-Object -Process {
            
                        $HealthReportObject | Add-Member `
                            -MemberType NoteProperty `
                            -Name $_.Name `
                            -Value $_.Value
                    }

                    $HealthReportsObject += $HealthReportObject
                }
                    
                $ArrayIndex++
            }

            $Response = $HealthReportsObject | ConvertTo-Json
        }

    }

    End {

        if ($PSBoundParameters.ContainsKey("Raw")) {
            $Response | Write-Output
        }
        else {
            $Response | ConvertFrom-Json | Write-Output
        }
    }

} 

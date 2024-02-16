Function Test-AzWvdRDBrokerLatency {

    [CmdletBinding(
        ConfirmImpact = "High")]

    Param (
        [Parameter(
            Mandatory = $False
            , ValueFromPipeline = $True
            , ValueFromPipelineByPropertyName = $True
        )]
        [uri]
        $Uri,

        [ValidateRange(0, 65535)]
        [Parameter(
            Mandatory = $False
            , ValueFromPipeline = $True
            , ValueFromPipelineByPropertyName = $True
        )]
        [int16]
        $Port,

        [ValidateRange(0, 5)]
        [ArgumentCompleter({ 0, 1, 2, 3, 4, 5 })]
        [Parameter(
            Mandatory = $False
            , ValueFromPipeline = $True
            , ValueFromPipelineByPropertyName = $True
        )]
        [int16]
        $NumberOfWarmUpPing = 1,

        [Parameter(
            Mandatory = $False
            , ValueFromPipeline = $True
            , ValueFromPipelineByPropertyName = $True
        )]
        [int16]
        $NumberOfPing = 4
    )

    Begin {

        $ConnectionThreadWaitTime = 100

        if ($Uri.IsAbsoluteUri) {

            $DnsHostName = $Uri.DnsSafeHost
        }
        else {

            $DnsHostName = $Uri
        }

        $IPAddress = [System.Net.Dns]::GetHostAddresses($DnsHostName)

        if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {

            Write-Verbose `
                -Message $("TCP connect to {0} ({1}):{2}:" -f `
                    $IPAddress[0].ToString() `
                    , $DnsHostName `
                    , $Port)

            Write-Verbose `
                -Message $("{0} iterations (warmup {1}) ping test:" -f `
                ($NumberOfWarmUpPing + $NumberOfPing) `
                    , $NumberOfWarmUpPing)
        }

        for ($c = 0; $c -lt $NumberOfWarmUpPing; $c++) {

            $TcpClient = New-Object `
                -TypeName "System.Net.Sockets.TcpClient"

            $Start = (Get-Date)
            
            $Connection = $TCPClient.BeginConnect($IPAddress[0], $Port, $(Out-Null), $(Out-Null))
            
            $Success = $Connection.AsyncWaitHandle.WaitOne($ConnectionThreadWaitTime)
            
            if ($Success) {

                $Stop = (Get-Date)

                $Latency = (New-TimeSpan -Start $Start -End $Stop).TotalMilliseconds

                $ClientIPAddress = $TCPClient.Client.LocalEndPoint.Address

                $ClientPort = $TCPClient.Client.LocalEndPoint.Port

                if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
                    Write-Verbose `
                        -Message $("Connecting to ({0}) {1}:{2} (warmup): from {3}:{4}: {5}ms" -f `
                            $DnsHostName `
                            , $IPAddress[0].ToString() `
                            , $Port `
                            , $ClientIPAddress `
                            , $ClientPort `
                            , $Latency)
                }
                    
                $TCPClient.Close()

                $TCPClient.Dispose()
            }
        }
    }

    Process {

        $ConnectionSent = 0

        $ConnectionReceived = 0

        $ConnectionEntries = @()

        for ($c = 0; $c -lt $NumberOfPing; $c++) {
            
            $TcpClient = New-Object `
                -TypeName "System.Net.Sockets.TcpClient"

            $Start = (Get-Date)
            
            $Connection = $TCPClient.BeginConnect($IPAddress[0], $Port, $(Out-Null), $(Out-Null))
            
            $ConnectionSent++
            
            $Success = $Connection.AsyncWaitHandle.WaitOne($ConnectionThreadWaitTime)

            if ($Success) {

                $Stop = (Get-Date)

                $Latency = (New-TimeSpan -Start $Start -End $Stop).TotalMilliseconds

                $ConnectionReceived++

                $ConnectionStatus = $True
                
                $ClientIPAddress = $TCPClient.Client.LocalEndPoint.Address

                $ClientPort = $TCPClient.Client.LocalEndPoint.Port

                if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {

                    Write-Verbose `
                        -Message $("Connecting to ({0}) {1}:{2}: from {3}:{4}: {5}ms" -f `
                            $DnsHostName `
                            , $IPAddress[0].ToString() `
                            , $Port `
                            , $ClientIPAddress `
                            , $ClientPort `
                            , $Latency)
                }
                    
                $TCPClient.Close()

                $TCPClient.Dispose()
            }

            $ConnectionEntry = [PSCustomObject]@{

                "Index"                  = $c
                "DestinationUri"         = $Uri
                "DestinationDnsHostName" = $DnsHostName
                "DestinationIPAddress"   = $IPAddress[0].ToString()
                "DestinationPort"        = $Port
                "SourceIPAddress"        = $ClientIPAddress
                "SourcePort"             = $ClientPort
                "Status"                 = if ($ConnectionStatus) { "Reachable" } else { "Unreachable" }
                "Latency(ms)"            = $Latency
            }

            $ConnectionEntries += $ConnectionEntry

        }

        $LatencyStatistic = $ConnectionEntries | Measure-Object `
            -Property "Latency(ms)" `
            -Minimum `
            -Maximum `
            -Average `
            -Sum

        if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
            Write-Verbose `
                -Message $("TCP connect statistics for ({0}) {1}:{2}:" -f `
                    $Uri `
                    , $IPAddress[0].ToString() `
                    , $Port
            )

            Write-Verbose `
                -Message $("Sent = {0}, Received = {1}, Lost = {2} ({3}% loss)," -f `
                    $ConnectionSent `
                    , $ConnectionReceived `
                    , $($ConnectionSent - $ConnectionReceived) `
                    , $(1 - $ConnectionReceived / $ConnectionSent).ToString("P")
            )
            
            Write-Verbose `
                -Message $("Minimum = {0}ms, Maximum = {1}ms, Average = {2}ms, Sum = {3}ms" -f `
                    $LatencyStatistic.Minimum `
                    , $LatencyStatistic.Maximum `
                    , $LatencyStatistic.Average `
                    , $LatencyStatistic.Sum
            )
        }

        $Result = [PSCustomObject]@{
            
            "DestinationUri"         = $Uri
            "DestinationDnsHostName" = $DnsHostName
            "DestinationIPAddress"   = $IPAddress[0].ToString()
            "DestinationPort"        = $Port
            "Entries"                = $ConnectionEntries
            "Sent"                   = $ConnectionSent
            "Received"               = $ConnectionReceived
            "Lost"                   = $($ConnectionSent - $ConnectionReceived)
            "LossPercentage%"        = $(1 - $ConnectionReceived / $ConnectionSent).ToString("P")
            "MinimumLatency(ms)"     = $LatencyStatistic.Minimum
            "MaximumLatency(ms)"     = $LatencyStatistic.Maximum
            "AverageLatency(ms)"     = $LatencyStatistic.Average
            "SumLatency(ms)"         = $LatencyStatistic.Sum
        }
    }

    End {
        $Result | Write-Output
    }
}

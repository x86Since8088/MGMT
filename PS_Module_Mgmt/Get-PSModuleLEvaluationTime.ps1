$Global:ModuleLoadTime = @{}
$modules = Get-Module -ListAvailable | Select Name,Path,Version,ExportedFormatFiles,Guid,RootModule,PowerShellVersion
foreach ($module in $modules) {
    Write-Host "Evaluating module $($module.Name)..."
    $startTime = Get-Date
    $commands = Get-Command -Module $module.Name
    $endTime = Get-Date
    $timeTaken = $endTime - $startTime
    Write-Host "Time taken to evaluate module $($module.Name): $($timeTaken.TotalMilliseconds)ms"
    $FileLastWriteTimes = (gci (split-path $module.Path) -Recurse).LastWriteTime | sort | select -First 1 -Last 1
    $Global:ModuleLoadTime[$module.Name]=[pscustomobject]@{
        EvaluationTime = $timeTaken.TotalMilliseconds
        ModuleName=$module.Name
        Commands = $commands
        Path = $module.Path
        Version = $module.Version
        LeastRecentWrite=$FileLastWriteTimes[0]
        MostRecentWrite=$FileLastWriteTimes[-1]
        Guid=$module.Guid
    }
}
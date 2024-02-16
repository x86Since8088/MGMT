# ----------------------------------------------------------------------------------
#
# Copyright Microsoft Corporation
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.internal
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------------
using namespace System
using namespace System.Collections.Generic
using namespace System.IO
using namespace System.IO.Compression
using namespace System.Linq
using namespace System.Management.Automation
using namespace System.Net

using namespace System.Net.Http
using namespace System.Threading
using namespace System.Threading.Tasks

Microsoft.PowerShell.Core\Set-StrictMode -Version 3

$script:AzTempRepoName = 'AzTempRepo'
$script:FixProgressBarId = 1
$script:ParallelDownloaderClassCode = @"
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;

public class ParallelDownloader
{
    private readonly HttpClientHandler httpClientHandler = new HttpClientHandler();
    private readonly HttpClient client = null;
    private readonly string urlRepository = null;
    private readonly CancellationTokenSource CancellationTokenSource = new CancellationTokenSource();

    private readonly IList<Task> tasks;
    private readonly IList<string> modules;

    private string lastModuleName = null;
    private string lastModuleVersion = null;

    public string LastModuleName
    {
        get
        {
            return lastModuleName;
        }
    }

    public string LastModuleVersion
    {
        get
        {
            return lastModuleVersion;
        }
    }

    public ParallelDownloader(string url)
    {
        client = new HttpClient(httpClientHandler);
        this.urlRepository = url;
        tasks = new List<Task>();
        modules = new List<string>();
    }

    public ParallelDownloader()
    {
        client = new HttpClient(httpClientHandler);
        tasks = new List<Task>();
        modules = new List<string>();
    }

    private async Task DownloadToFile(string uri, string filePath)
    {
        using (var httpResponseMessage = await client.GetAsync(uri, CancellationTokenSource.Token))
        using (var stream = await httpResponseMessage.EnsureSuccessStatusCode().Content.ReadAsStreamAsync())
        using (var fileStream = new FileStream(filePath, FileMode.Create))
        {
            await stream.CopyToAsync(fileStream, 81920, CancellationTokenSource.Token);
        }
    }

    private void Copy(string src, string dest)
    {
        File.Copy(src, dest);
    }

    bool ParseFile(string fileName, out string moduleName, out Version moduleVersion, out Boolean preview)
    {
        try
        {
            Regex pattern = new Regex(@"(?<moduleName>[a-zA-Z.]+)\.(?<moduleVersion>[0-9.]+(\-preview)?)\.nupkg");
            Match matches = pattern.Match(fileName);
            if (matches.Groups["moduleName"].Success && matches.Groups["moduleVersion"].Success)
            {
                moduleName = matches.Groups["moduleName"].Value;
                var versionString = matches.Groups["moduleVersion"].Value;
                if (versionString.Contains('-'))
                {
                    var parts = versionString.Split('-');
                    moduleVersion = Version.Parse(parts[0]);
                    preview = string.Compare(parts[1], "preview", true) == 0;
                }
                else
                {
                    moduleVersion = Version.Parse(versionString);
                    preview = false;
                }
                return true;
            }
        }
        catch
        {
        }
        moduleName = null;
        moduleVersion = null;
        preview = false;
        return false;
    }

    public string Download(string sourceUri, string targetPath)
    {
        try
        {
            Uri uri = new Uri(sourceUri);
            var fileName = Path.GetFileName(uri.AbsoluteUri);
            string module = null;
            Version version = null;
            Boolean preview = false;
            if (!ParseFile(fileName, out module, out version, out preview))
            {
                throw new ArgumentException(string.Format("{0} is not a valid Az module nuget package name for installation.", fileName));
            }
            var nupkgFile = preview ? "{0}.{1}-preview.nupkg": "{0}.{1}.nupkg";
            nupkgFile = Path.Combine(targetPath, String.Format(nupkgFile, module, version));
            if (uri.IsFile)
            {
                Copy(uri.AbsolutePath, nupkgFile);
            }
            else if(String.Compare(uri.Scheme, "http", true) == 0 || String.Compare(uri.Scheme, "https", true) == 0)
            {
                Task task = DownloadToFile(uri.AbsoluteUri, nupkgFile);
                tasks.Add(task);
                modules.Add(module);
            }
            else
            {
                throw new ArgumentException(string.Format("{0} scheme is not supported.", sourceUri));
            }
            lastModuleName = module;
            lastModuleVersion = string.Format(preview ? "{0}-preview" : "{0}", version);
            return nupkgFile;
        }
        catch (UriFormatException)
        {
            throw new ArgumentException(string.Format("{0} is not a valid uri.", sourceUri));
        }
    }

    public string Download(string module, Version version, string path, Boolean preview = false)
    {
        var nupkgFile = preview ? "{0}.{1}-preview.nupkg" : "{0}.{1}.nupkg";
        nupkgFile = Path.Combine(path, String.Format(nupkgFile, module, version));
        Task task = DownloadToFile(String.Format("{0}/package/{1}/{2}", urlRepository, module, version), nupkgFile);
        tasks.Add(task);
        modules.Add(module);
        lastModuleName = module;
        lastModuleVersion = string.Format(preview ? "{0}-preview" : "{0}", version);
        return nupkgFile;
    }

    public void WaitForAllTasks()
    {
        while (tasks.Count() > 0)
        {
            int taskIndex = Task.WaitAny(tasks.ToArray());
            var task = tasks[taskIndex];
            tasks.Remove(task);
            modules.Remove(modules[taskIndex]);
            if (!task.IsCompleted)
            {
                throw new Exception(String.Format("Error downloading {0} {1}", modules[taskIndex], task.Exception));
            }
        }
    }

    public void Dispose()
    {
        if (tasks.Count() > 0)
        {
            CancellationTokenSource.Cancel();
            try
            {
                Task.WaitAll(tasks.ToArray());
            }
            catch
            {

            }
        }

        if (client != null)
        {
            client.Dispose();
        }

        if (httpClientHandler != null)
        {
            httpClientHandler.Dispose();
        }
    }
}
"@

Add-Type -AssemblyName System.Net.Http -ErrorAction Stop
Add-Type $script:ParallelDownloaderClassCode -ReferencedAssemblies System.Net.Http,System.Threading.Tasks,System.Linq,System.Collections,System.Runtime.Extensions,System.Text.RegularExpressions,System.IO.FileSystem

$getModule = Get-Module -Name "PowerShellGet"
if ($null -ne $getModule -and $getModule.Version -lt [System.Version]"2.1.3") {
    Write-Error "This module requires PowerShellGet version 2.1.3. An earlier version of PowerShellGet is imported in the current PowerShell session. Please open a new session before importing this module." -ErrorAction Stop
}
elseif ($null -eq $getModule -or $getModule.Version -ge [System.Version]"3.0") {
    try {
        Import-Module PowerShellGet -MinimumVersion 2.1.3 -MaximumVersion 3.0 -Scope Global -Force -ErrorAction Stop
    }
    catch {
        Write-Error "This module requires PowerShellGet version no earlier than 2.1.3 and no later than 3.0. Please install the required PowerShellGet firstly."
    }
}

function Get-AllAzModule {
    param (
        [Parameter()]
        [Switch]
        ${PrereleaseOnly}
    )

    process {
        $allmodules = Microsoft.PowerShell.Core\Get-Module -ListAvailable -Name Az*, Az `
         | Where-Object {$_.Name -match "Az(\.[a-zA-Z0-9]+)?$"} `
         | Where-Object {
            !$PrereleaseOnly -or ($_.PrivateData -and $_.PrivateData.ContainsKey('PSData') -and $_.PrivateData.PSData.ContainsKey('PreRelease') -and $_.PrivateData.PSData.Prerelease -eq 'preview') -or ($_.Version -lt [Version] "1.0")
        }
        $allmodules
    }
}

function Normalize-ModuleName {
    param (
        [Parameter()]
        [string[]]
        ${Name}
    )

    process {
        $normalName = $Name | ForEach-Object {
            if ($_) {
                if ($_ -notlike "Az.*") {
                    "Az.$_"
                }
                else {
                    $_
                }
            }
        } | Sort-Object -Unique

        if ($normalName -and $normalName -notmatch "Az(\.[a-zA-Z0-9.]+)?$") {
            $normalName = $null
            Throw "The Name parameter must only contain Az modules."
        }

        if ($normalName -eq 'Az.Az') {
            $normalName = $normalName | Where-Object { $_ -ne 'Az.Az'}
            Write-Warning "Az.Tools.Installer cannot be used to install Az. Will discard Az in the Name parameter."
        }

        $normalName
    }
}

function Get-AzModuleFromRemote {
    [OutputType([PSCustomObject[]])]
    param (
        [Parameter()]
        [string[]]
        ${Name},

        [Parameter()]
        [string]
        ${Repository},

        [Parameter()]
        [Switch]
        ${AllowPrerelease},

        [Parameter()]
        [Version]
        ${RequiredVersion},

        [Parameter()]
        [Switch]
        ${UseExactAccountVersion},

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        ${Invoker}
    )

    process {
        $azModule = "Az"
        if ($AllowPrerelease) {
            if ($RequiredVersion -and $RequiredVersion -lt [Version] "6.0") {
                Throw "[$Invoker] Prerelease version cannot be lower than 6.0. Please install GA modules only or specify Az version above 6.0."
            }
            else {
                $azModule = "AzPreview"
            }
        }
        $findModuleParams = @{
            Name =  $azModule
            RequiredVersion = $RequiredVersion
            ErrorAction = 'Stop'
        }
        if ($Repository) {
            $findModuleParams.Add('Repository', $Repository);
        }

        $modules = [Array] (PowerShellGet\Find-Module @findModuleParams)
        if ($modules.Count -gt 1) {
            Throw "[$Invoker] You have multiple modules matched 'Az' in the registered reposistory $($modules.Repository). Please specify a single -Repository."
        }
        $Repository = $modules.Repository

        $accountVersion = 0
        if (!$UseExactAccountVersion) {
            $findModuleParams = @{
                Name = 'Az.Accounts'
                Repository = $Repository
            }
            $module = PowerShellGet\Find-Module @findModuleParams
            $accountVersion = [Version] $module.Version
        }

        $modulesWithVersion = @()
        $containValidModule = if ($Name) {$Name -Contains 'Az.Accounts'} else {$false}
        $module = $null
        foreach ($module in $modules.Dependencies) {
            if ($module.Name -eq 'Az.Accounts') {
                if ($UseExactAccountVersion) {
                    $version = $accountVersion
                    if ($module.Keys -Contains 'MinimumVersion') {
                        $version = $module.MinimumVersion
                    }
                    elseif ($module.Keys -Contains 'RequiredVersion') {
                        $version = $module.RequiredVersion
                    }
                    $modulesWithVersion += [PSCustomObject]@{Name = $module.Name; Version = $version; Repository = $Repository}
                }
                else {
                    $modulesWithVersion += [PSCustomObject]@{Name = $module.Name; Version = $accountVersion; Repository = $Repository}
                }
            }
            elseif (!$Name -or $Name -Contains $module.Name)
            {
                if ($module.RequiredVersion) {
                    $modulesWithVersion += [PSCustomObject]@{Name = $module.Name; Version = $module.RequiredVersion; Repository = $Repository}
                    $containValidModule = $true
                }
            }
        }

        if (!$containValidModule) {
            $modulesWithVersion = $modulesWithVersion | Where-Object {$_.Name -ne "Az.Accounts"}
        }
        $count = if ($modulesWithVersion) {$modulesWithVersion.Count} else {0}
        Write-Debug "[$Invoker] $count module(s) are found."
        $modulesWithVersion
    }
}

class ModuleInfo
{
    [string] $Name = $null
    [Version[]] $Version = @()
}

function Remove-AzureRM {
    process {
        try {
            $azureModuleNames = (Microsoft.PowerShell.Core\Get-Module -ListAvailable -Name Azure* -ErrorAction Stop).Name | Where-Object {$_ -match "(Azure|AzureRM)(\.[a-zA-Z0-9]+)*$"}
            foreach ($moduleName in $azureModuleNames) {
                PowerShellGet\Uninstall-Module -Name $moduleName -AllVersion -AllowPrerelease -ErrorAction Continue
            }
        }
        catch {
            Write-Warning $_
        }
    }
}

function Get-RepositoryUrl {
    param (
        [Parameter()]
        [string]
        ${Repository}
    )

    process {
        $url = (Get-PSRepository -Name $repository).SourceLocation
        $url
    }
}

function Update-ModuleInstallationRepository {
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        ${ModuleName},

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Version]
        ${InstalledVersion},

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        ${Repository}
    )

    process {
        try {
            $moduleBase = (Microsoft.PowerShell.Core\Get-Module -ListAvailable -Name $ModuleName | Where-Object {$_.Version -eq $InstalledVersion}).ModuleBase
            $moduleInfoFile = Join-Path -Path $moduleBase -ChildPath 'PSGetModuleInfo.xml'
            Write-Debug "Checking file: $moduleInfoFile"
            $xmlText = Get-Content $moduleInfoFile
            $xmlText = $xmlText -Replace $script:AzTempRepoName, $Repository
            $repositoryUrl = Get-RepositoryUrl $Repository
            $destString = '"RepositorySourceLocation">' + $repositoryUrl + '<'
            $xmlText = $xmlText -Replace
    '"RepositorySourceLocation">.*<', $destString
            Write-Debug "Write new xml to $moduleInfoFile"
            Microsoft.PowerShell.Management\Set-Content -Path $moduleInfoFile -Value $xmlText -Force
        }
        catch {
            Write-Error $PSItem.ToString() -ErrorVariable +errorRecords
            throw $PSItem
        }
    }
}

$exportedFunctions = @( Get-ChildItem -Path $PSScriptRoot/exports/*.ps1 -Recurse -ErrorAction 'SilentlyContinue' )
$internalFunctions = @( Get-ChildItem -Path $PSScriptRoot/internal/*.ps1 -ErrorAction 'SilentlyContinue' )

$allFunctions = $internalFunctions + $exportedFunctions
foreach ($function in $allFunctions) {
    try {
        . $function.Fullname
    }
    catch {
        Write-Error "Failed to import function $($function.fullname): $_"
    }
}

Export-ModuleMember -Function $exportedFunctions.Basename

$commandsWithRepositoryParameter = @(
    "Install-AzModule",
    "Update-AzModule"
)

Add-RepositoryArgumentCompleter -Cmdlets $commandsWithRepositoryParameter -ParameterName "Repository"
# SIG # Begin signature block
# MIIoPAYJKoZIhvcNAQcCoIIoLTCCKCkCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBMwwALJhGM4tEf
# 7B6dxncnI7yHSOIocX86RzxMsv/8WaCCDYUwggYDMIID66ADAgECAhMzAAADTU6R
# phoosHiPAAAAAANNMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMwMzE2MTg0MzI4WhcNMjQwMzE0MTg0MzI4WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDUKPcKGVa6cboGQU03ONbUKyl4WpH6Q2Xo9cP3RhXTOa6C6THltd2RfnjlUQG+
# Mwoy93iGmGKEMF/jyO2XdiwMP427j90C/PMY/d5vY31sx+udtbif7GCJ7jJ1vLzd
# j28zV4r0FGG6yEv+tUNelTIsFmmSb0FUiJtU4r5sfCThvg8dI/F9Hh6xMZoVti+k
# bVla+hlG8bf4s00VTw4uAZhjGTFCYFRytKJ3/mteg2qnwvHDOgV7QSdV5dWdd0+x
# zcuG0qgd3oCCAjH8ZmjmowkHUe4dUmbcZfXsgWlOfc6DG7JS+DeJak1DvabamYqH
# g1AUeZ0+skpkwrKwXTFwBRltAgMBAAGjggGCMIIBfjAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUId2Img2Sp05U6XI04jli2KohL+8w
# VAYDVR0RBE0wS6RJMEcxLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJh
# dGlvbnMgTGltaXRlZDEWMBQGA1UEBRMNMjMwMDEyKzUwMDUxNzAfBgNVHSMEGDAW
# gBRIbmTlUAXTgqoXNzcitW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIw
# MTEtMDctMDguY3JsMGEGCCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDEx
# XzIwMTEtMDctMDguY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIB
# ACMET8WuzLrDwexuTUZe9v2xrW8WGUPRQVmyJ1b/BzKYBZ5aU4Qvh5LzZe9jOExD
# YUlKb/Y73lqIIfUcEO/6W3b+7t1P9m9M1xPrZv5cfnSCguooPDq4rQe/iCdNDwHT
# 6XYW6yetxTJMOo4tUDbSS0YiZr7Mab2wkjgNFa0jRFheS9daTS1oJ/z5bNlGinxq
# 2v8azSP/GcH/t8eTrHQfcax3WbPELoGHIbryrSUaOCphsnCNUqUN5FbEMlat5MuY
# 94rGMJnq1IEd6S8ngK6C8E9SWpGEO3NDa0NlAViorpGfI0NYIbdynyOB846aWAjN
# fgThIcdzdWFvAl/6ktWXLETn8u/lYQyWGmul3yz+w06puIPD9p4KPiWBkCesKDHv
# XLrT3BbLZ8dKqSOV8DtzLFAfc9qAsNiG8EoathluJBsbyFbpebadKlErFidAX8KE
# usk8htHqiSkNxydamL/tKfx3V/vDAoQE59ysv4r3pE+zdyfMairvkFNNw7cPn1kH
# Gcww9dFSY2QwAxhMzmoM0G+M+YvBnBu5wjfxNrMRilRbxM6Cj9hKFh0YTwba6M7z
# ntHHpX3d+nabjFm/TnMRROOgIXJzYbzKKaO2g1kWeyG2QtvIR147zlrbQD4X10Ab
# rRg9CpwW7xYxywezj+iNAc+QmFzR94dzJkEPUSCJPsTFMIIHejCCBWKgAwIBAgIK
# YQ6Q0gAAAAAAAzANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlm
# aWNhdGUgQXV0aG9yaXR5IDIwMTEwHhcNMTEwNzA4MjA1OTA5WhcNMjYwNzA4MjEw
# OTA5WjB+MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYD
# VQQDEx9NaWNyb3NvZnQgQ29kZSBTaWduaW5nIFBDQSAyMDExMIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAq/D6chAcLq3YbqqCEE00uvK2WCGfQhsqa+la
# UKq4BjgaBEm6f8MMHt03a8YS2AvwOMKZBrDIOdUBFDFC04kNeWSHfpRgJGyvnkmc
# 6Whe0t+bU7IKLMOv2akrrnoJr9eWWcpgGgXpZnboMlImEi/nqwhQz7NEt13YxC4D
# dato88tt8zpcoRb0RrrgOGSsbmQ1eKagYw8t00CT+OPeBw3VXHmlSSnnDb6gE3e+
# lD3v++MrWhAfTVYoonpy4BI6t0le2O3tQ5GD2Xuye4Yb2T6xjF3oiU+EGvKhL1nk
# kDstrjNYxbc+/jLTswM9sbKvkjh+0p2ALPVOVpEhNSXDOW5kf1O6nA+tGSOEy/S6
# A4aN91/w0FK/jJSHvMAhdCVfGCi2zCcoOCWYOUo2z3yxkq4cI6epZuxhH2rhKEmd
# X4jiJV3TIUs+UsS1Vz8kA/DRelsv1SPjcF0PUUZ3s/gA4bysAoJf28AVs70b1FVL
# 5zmhD+kjSbwYuER8ReTBw3J64HLnJN+/RpnF78IcV9uDjexNSTCnq47f7Fufr/zd
# sGbiwZeBe+3W7UvnSSmnEyimp31ngOaKYnhfsi+E11ecXL93KCjx7W3DKI8sj0A3
# T8HhhUSJxAlMxdSlQy90lfdu+HggWCwTXWCVmj5PM4TasIgX3p5O9JawvEagbJjS
# 4NaIjAsCAwEAAaOCAe0wggHpMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRI
# bmTlUAXTgqoXNzcitW2oynUClTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTAL
# BgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRyLToCMZBD
# uRQFTuHqp8cx0SOJNDBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLm1pY3Jv
# c29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFf
# MDNfMjIuY3JsMF4GCCsGAQUFBwEBBFIwUDBOBggrBgEFBQcwAoZCaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFf
# MDNfMjIuY3J0MIGfBgNVHSAEgZcwgZQwgZEGCSsGAQQBgjcuAzCBgzA/BggrBgEF
# BQcCARYzaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9kb2NzL3ByaW1h
# cnljcHMuaHRtMEAGCCsGAQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAHAAbwBsAGkA
# YwB5AF8AcwB0AGEAdABlAG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQBn
# 8oalmOBUeRou09h0ZyKbC5YR4WOSmUKWfdJ5DJDBZV8uLD74w3LRbYP+vj/oCso7
# v0epo/Np22O/IjWll11lhJB9i0ZQVdgMknzSGksc8zxCi1LQsP1r4z4HLimb5j0b
# pdS1HXeUOeLpZMlEPXh6I/MTfaaQdION9MsmAkYqwooQu6SpBQyb7Wj6aC6VoCo/
# KmtYSWMfCWluWpiW5IP0wI/zRive/DvQvTXvbiWu5a8n7dDd8w6vmSiXmE0OPQvy
# CInWH8MyGOLwxS3OW560STkKxgrCxq2u5bLZ2xWIUUVYODJxJxp/sfQn+N4sOiBp
# mLJZiWhub6e3dMNABQamASooPoI/E01mC8CzTfXhj38cbxV9Rad25UAqZaPDXVJi
# hsMdYzaXht/a8/jyFqGaJ+HNpZfQ7l1jQeNbB5yHPgZ3BtEGsXUfFL5hYbXw3MYb
# BL7fQccOKO7eZS/sl/ahXJbYANahRr1Z85elCUtIEJmAH9AAKcWxm6U/RXceNcbS
# oqKfenoi+kiVH6v7RyOA9Z74v2u3S5fi63V4GuzqN5l5GEv/1rMjaHXmr/r8i+sL
# gOppO6/8MO0ETI7f33VtY5E90Z1WTk+/gFcioXgRMiF670EKsT/7qMykXcGhiJtX
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGg0wghoJAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAANNTpGmGiiweI8AAAAA
# A00wDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIEXA
# 3hcu9hHSFz8BY26nGKqf6Rtn2T7ftCSQ2ULH1Q8wMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEATmrN900qOcYiZjGxt2ACcRRzvMZuvkUQDMB7
# 5ISBBo+6oiqoGBHFkQRMTeXEi3NKw9sBq6UYvOsvn26cJaEpcBfRlXQGAhypK6sW
# 3b5tg5KnT8TP3hf3tbp4UU0U31TgTraFq6QjaR22JZO+MkgEcbTZBgmwIDkx2zwr
# 0Rvbwgeqo8ZV2Lk1LWf9m7KlMeFM7dXgCFPfNqb10KaWzc+QCVAHvaSqzpb73Q32
# +H01a0qwm/fPAVB49Oky0qBrcDHNtH8bJXI/59eUpXQLTwRhfXVUWARHses1iNV3
# RxsxyfRRwCGDGvyKI1lD2TC0Ah5WHHKVQH+H+DJJkT6gAlswt6GCF5cwgheTBgor
# BgEEAYI3AwMBMYIXgzCCF38GCSqGSIb3DQEHAqCCF3AwghdsAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFSBgsqhkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCCNJOp9/d8taOK9Aily28Q3D5RKY8YtoiUN
# 67SrgGVCLwIGZShw8rUbGBMyMDIzMTExNDA5MTA0OS45MDZaMASAAgH0oIHRpIHO
# MIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQL
# ExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxk
# IFRTUyBFU046QTAwMC0wNUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1l
# LVN0YW1wIFNlcnZpY2WgghHtMIIHIDCCBQigAwIBAgITMwAAAdB3CKrvoxfG3QAB
# AAAB0DANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
# MDAeFw0yMzA1MjUxOTEyMTRaFw0yNDAyMDExOTEyMTRaMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046QTAwMC0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Uw
# ggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDfMlfn35fvM0XAUSmI5qiG
# 0UxPi25HkSyBgzk3zpYO311d1OEEFz0QpAK23s1dJFrjB5gD+SMw5z6EwxC4CrXU
# 9KaQ4WNHqHrhWftpgo3MkJex9frmO9MldUfjUG56sIW6YVF6YjX+9rT1JDdCDHbo
# 5nZiasMigGKawGb2HqD7/kjRR67RvVh7Q4natAVu46Zf5MLviR0xN5cNG20xwBwg
# ttaYEk5XlULaBH5OnXz2eWoIx+SjDO7Bt5BuABWY8SvmRQfByT2cppEzTjt/fs0x
# p4B1cAHVDwlGwZuv9Rfc3nddxgFrKA8MWHbJF0+aWUUYIBR8Fy2guFVHoHeOze7I
# sbyvRrax//83gYqo8c5Z/1/u7kjLcTgipiyZ8XERsLEECJ5ox1BBLY6AjmbgAzDd
# Nl2Leej+qIbdBr/SUvKEC+Xw4xjFMOTUVWKWemt2khwndUfBNR7Nzu1z9L0Wv7TA
# Y/v+v6pNhAeohPMCFJc+ak6uMD8TKSzWFjw5aADkmD9mGuC86yvSKkII4MayzoUd
# seT0nfk8Y0fPjtdw2Wnejl6zLHuYXwcDau2O1DMuoiedNVjTF37UEmYT+oxC/OFX
# UGPDEQt9tzgbR9g8HLtUfEeWOsOED5xgb5rwyfvIss7H/cdHFcIiIczzQgYnsLyE
# GepoZDkKhSMR5eCB6Kcv/QIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFDPhAYWS0oA+
# lOtITfjJtyl0knRRMB8GA1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8G
# A1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMv
# Y3JsL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBs
# BggrBgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0
# LmNvbS9wa2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUy
# MDIwMTAoMSkuY3J0MAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUH
# AwgwDgYDVR0PAQH/BAQDAgeAMA0GCSqGSIb3DQEBCwUAA4ICAQCXh+ckCkZaA06S
# NW+qxtS9gHQp4x7G+gdikngKItEr8otkXIrmWPYrarRWBlY91lqGiilHyIlZ3iNB
# UbaNEmaKAGMZ5YcS7IZUKPaq1jU0msyl+8og0t9C/Z26+atx3vshHrFQuSgwTHZV
# pzv7k8CYnBYoxdhI1uGhqH595mqLvtMsxEN/1so7U+b3U6LCry5uwwcz5+j8Oj0G
# UX3b+iZg+As0xTN6T0Qa8BNec/LwcyqYNEaMkW2VAKrmhvWH8OCDTcXgONnnABQH
# BfXK/fLAbHFGS1XNOtr62/iaHBGAkrCGl6Bi8Pfws6fs+w+sE9r3hX9Vg0gsRMoH
# RuMaiXsrGmGsuYnLn3AwTguMatw9R8U5vJtWSlu1CFO5P0LEvQQiMZ12sQSsQAkN
# DTs9rTjVNjjIUgoZ6XPMxlcPIDcjxw8bfeb4y4wAxM2RRoWcxpkx+6IIf2L+b7gL
# HtBxXCWJ5bMW7WwUC2LltburUwBv0SgjpDtbEqw/uDgWBerCT+Zty3Nc967iGaQj
# yYQH6H/h9Xc8smm2n6VjySRx2swnW3hr6Qx63U/xY9HL6FNhrGiFED7ZRKrnwvvX
# vMVQUIEkB7GUEeN6heY8gHLt0jLV3yzDiQA8R8p5YGgGAVt9MEwgAJNY1iHvH/8v
# zhJSZFNkH8svRztO/i3TvKrjb8ZxwjCCB3EwggVZoAMCAQICEzMAAAAVxedrngKb
# SZkAAAAAABUwDQYJKoZIhvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQI
# EwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
# ZnQgQ29ycG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRpZmlj
# YXRlIEF1dGhvcml0eSAyMDEwMB4XDTIxMDkzMDE4MjIyNVoXDTMwMDkzMDE4MzIy
# NVowfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
# B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UE
# AxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQDk4aZM57RyIQt5osvXJHm9DtWC0/3unAcH0qlsTnXI
# yjVX9gF/bErg4r25PhdgM/9cT8dm95VTcVrifkpa/rg2Z4VGIwy1jRPPdzLAEBjo
# YH1qUoNEt6aORmsHFPPFdvWGUNzBRMhxXFExN6AKOG6N7dcP2CZTfDlhAnrEqv1y
# aa8dq6z2Nr41JmTamDu6GnszrYBbfowQHJ1S/rboYiXcag/PXfT+jlPP1uyFVk3v
# 3byNpOORj7I5LFGc6XBpDco2LXCOMcg1KL3jtIckw+DJj361VI/c+gVVmG1oO5pG
# ve2krnopN6zL64NF50ZuyjLVwIYwXE8s4mKyzbnijYjklqwBSru+cakXW2dg3viS
# kR4dPf0gz3N9QZpGdc3EXzTdEonW/aUgfX782Z5F37ZyL9t9X4C626p+Nuw2TPYr
# bqgSUei/BQOj0XOmTTd0lBw0gg/wEPK3Rxjtp+iZfD9M269ewvPV2HM9Q07BMzlM
# jgK8QmguEOqEUUbi0b1qGFphAXPKZ6Je1yh2AuIzGHLXpyDwwvoSCtdjbwzJNmSL
# W6CmgyFdXzB0kZSU2LlQ+QuJYfM2BjUYhEfb3BvR/bLUHMVr9lxSUV0S2yW6r1AF
# emzFER1y7435UsSFF5PAPBXbGjfHCBUYP3irRbb1Hode2o+eFnJpxq57t7c+auIu
# rQIDAQABo4IB3TCCAdkwEgYJKwYBBAGCNxUBBAUCAwEAATAjBgkrBgEEAYI3FQIE
# FgQUKqdS/mTEmr6CkTxGNSnPEP8vBO4wHQYDVR0OBBYEFJ+nFV0AXmJdg/Tl0mWn
# G1M1GelyMFwGA1UdIARVMFMwUQYMKwYBBAGCN0yDfQEBMEEwPwYIKwYBBQUHAgEW
# M2h0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvRG9jcy9SZXBvc2l0b3J5
# Lmh0bTATBgNVHSUEDDAKBggrBgEFBQcDCDAZBgkrBgEEAYI3FAIEDB4KAFMAdQBi
# AEMAQTALBgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV
# 9lbLj+iiXGJo0T2UkFvXzpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3Js
# Lm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAx
# MC0wNi0yMy5jcmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2
# LTIzLmNydDANBgkqhkiG9w0BAQsFAAOCAgEAnVV9/Cqt4SwfZwExJFvhnnJL/Klv
# 6lwUtj5OR2R4sQaTlz0xM7U518JxNj/aZGx80HU5bbsPMeTCj/ts0aGUGCLu6WZn
# OlNN3Zi6th542DYunKmCVgADsAW+iehp4LoJ7nvfam++Kctu2D9IdQHZGN5tggz1
# bSNU5HhTdSRXud2f8449xvNo32X2pFaq95W2KFUn0CS9QKC/GbYSEhFdPSfgQJY4
# rPf5KYnDvBewVIVCs/wMnosZiefwC2qBwoEZQhlSdYo2wh3DYXMuLGt7bj8sCXgU
# 6ZGyqVvfSaN0DLzskYDSPeZKPmY7T7uG+jIa2Zb0j/aRAfbOxnT99kxybxCrdTDF
# NLB62FD+CljdQDzHVG2dY3RILLFORy3BFARxv2T5JL5zbcqOCb2zAVdJVGTZc9d/
# HltEAY5aGZFrDZ+kKNxnGSgkujhLmm77IVRrakURR6nxt67I6IleT53S0Ex2tVdU
# CbFpAUR+fKFhbHP+CrvsQWY9af3LwUFJfn6Tvsv4O+S3Fb+0zj6lMVGEvL8CwYKi
# excdFYmNcP7ntdAoGokLjzbaukz5m/8K6TT4JDVnK+ANuOaMmdbhIurwJ0I9JZTm
# dHRbatGePu1+oDEzfbzL6Xu/OHBE0ZDxyKs6ijoIYn/ZcGNTTY3ugm2lBRDBcQZq
# ELQdVTNYs6FwZvKhggNQMIICOAIBATCB+aGB0aSBzjCByzELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJp
# Y2EgT3BlcmF0aW9uczEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOkEwMDAtMDVF
# MC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMK
# AQEwBwYFKw4DAhoDFQC8t8hT8KKUX91lU5FqRP9Cfu9MiaCBgzCBgKR+MHwxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jv
# c29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6P0dYTAi
# GA8yMDIzMTExMzIyMTA0MVoYDzIwMjMxMTE0MjIxMDQxWjB3MD0GCisGAQQBhFkK
# BAExLzAtMAoCBQDo/R1hAgEAMAoCAQACAhV3AgH/MAcCAQACAhLEMAoCBQDo/m7h
# AgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSCh
# CjAIAgEAAgMBhqAwDQYJKoZIhvcNAQELBQADggEBAJiuhun0CnexZeo295brhGAm
# NXDrqymDR63IjMDR/vITPVTU46Ia4l6mV3H0y6xyjdIuZTE7E4YdlPwfNEgZVSWs
# w0F2QiMn7prRbuG8x4BgJlHHlkRIZGNCTDCh/XM+H01KnkdT4h68cGyDEUxj6q12
# uwxegSUiiK/gIiSKv/+s8Nwx3flAb5j2knPsW+Bj7qAaTZIIOiIqmmKTFjikn1m4
# njlIaRfZr3XrS0DKFkRhI2BhcxFKRTC12ji9EVfZ6LG3m1sg67/W1Fc1L5aiGd/E
# Bn+nJH25sJ6P1NwJJHOHRqFYMC9MlBze6LvjnAJ1/jTbADUuoaBPAqQKzQ6Kkpcx
# ggQNMIIECQIBATCBkzB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3Rv
# bjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0
# aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAA
# AdB3CKrvoxfG3QABAAAB0DANBglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkD
# MQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEiBCArcYIk3a3mE9oNjCdMWc05
# cmtS59/jwGl/0RraNZmqhDCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EIAiV
# QAZftNP/Md1E2Yw+fBXa9w6fjmTZ5WAerrTSPwnXMIGYMIGApH4wfDELMAkGA1UE
# BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
# BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAHQdwiq76MXxt0AAQAAAdAwIgQgFUe0
# cfcXOFPApSjiszMaap+pyARpiAJTN0r9sqCYy6QwDQYJKoZIhvcNAQELBQAEggIA
# Uve7G4vSzX+/bfLc+9+yuqZaze+pSAyFx+OKcpYZnJvBCdpYlPr/OPRvmQrCU3Kh
# 3OGWyeC8JmKQtw+pQMdirpCzm1+pibvgwu6G22UmS8ira7Gd9CLZmxIDr9dVupdO
# mJtQKgKv+tnYVZwlvaXNFYBZ9kWhQXpDdQLOA8UI4cQdo7tZCK7D8MeVHfpJ2gqK
# V76rJqeZDDinBVDlMtiHFLFNQALUBcPbJXEkGCwdivGYZBh9VhsH1aRuVHqALTOZ
# hgx7Zbc9JwFn7TFfXSdVYmv0yFBppied8lcENJ2Qf6m0YA6ew9u//BDcVNc88Dns
# Cl/dqUl5R9kb1v+IWIp+iQ8Zpnm/d0MtNeiczEAhLAuSQ/m6kyvKuX5+Q3GPzZGy
# mdcC43itfAOVBpsFmczwcu12NDlP7qCgmBqEWXVmS0CV5KnHALMZTbcBdSUJ7K7c
# bBYThVlY+4TT13Ecm5k4YVEcRWsGwddQ1eU+QaMGyLeKDLow5COFfySm46FE/Sme
# SoJJ8FyupqEQolBKMBqX57GvsY5OTFVHogglLP00QufR+FlSGV/v9haXy5Ii+95B
# vYt4cdN9ikk5dMEEDcI6eG12SmLfJop50mv2pUEfOBvjjPVQtAyz1Mqog4496tbS
# pB1EPeGeNgMEUdXk/ujBljisGzVWEL+rZIZfBNfRNvQ=
# SIG # End signature block

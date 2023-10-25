function Clone-GitRepo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
            
            $jsonPath = Join-Path $env:APPDATA 'PSGitSupport\recent.json'
            if (Test-Path $jsonPath) {
                $json = Get-Content $jsonPath | ConvertFrom-Json
                if ($json.RepoUrls) {
                    return $json.RepoUrls | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
                        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
                    }
                }
            }
        })]
        [string]$repoUrl,

        [Parameter(Mandatory=$true)]
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
            
            $jsonPath = Join-Path $env:APPDATA 'PSGitSupport\recent.json'
            if ($null -eq $fakeBoundParameter.repoUrl) {
                "'Autocomplete for branchName requires -repoURL.'" | 
                ForEach-Object{
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
                }
            }
            elseif (Test-Path $jsonPath) {
                $json = Get-Content $jsonPath | ConvertFrom-Json
                if ($json[$fakeBoundParameter.repoUrl].BranchNames) {
                    return $json.BranchNames | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
                        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
                    }
                }
            }
        })]
        [string]$branchName,

        [Parameter(Mandatory=$true)]
        [string]$localFolder,

        [string]$apiKey = $null
    )

    # Ensure git pagers won't output to stderr
    $env:GIT_PAGER = 'cat'

    # Check if git is installed
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Error "Git is not installed. Please install Git first."
        return
    }

    # Display and run the git command
    function RunGitCommand {
        param (
            [string]$command
        )
        Write-Warning "Executing: git $command"
        Invoke-Expression -Command "git $command"
    }

    if (Test-Path "$localFolder\*") {return Write-Error -Message "LocalFolder must be empty or not exist. '$localFolder'"}

    # Check for credentials or API token
    if (-not $apiKey) {
        # Check if git credentials are set up
        try {
            RunGitCommand "ls-remote $repoUrl"
        } catch {
            Write-Error "Git credentials are not set up and no API token provided. Please set up one of them."
            return
        }
    } else {
        # Use the API token for authentication
        $repoUrl = $repoUrl -replace "https://", "https://$apiKey:x-oauth-basic@"
    }

    # Clone the specific branch
    try {
        RunGitCommand "clone -b $branchName $repoUrl $localFolder"
        Write-Output "Repository branch $branchName cloned successfully to $localFolder."
        
        # Save the successful values to JSON
        $jsonPath = Join-Path $env:APPDATA 'PSGitSupport\recent.json'
        $json                     = if (Test-Path $jsonPath)                { Get-Content $jsonPath | ConvertFrom-Json -AsHashtable } else { @{} }
        $json.RepoUrls            = if ($null -ne $json.RepoUrls)           {[hashtable]$json.RepoUrls}           else {@{}}
        $json.RepoUrls[$repoUrl]  = if ($null -ne $json.RepoUrls[$repoUrl]) {[hashtable]$json.RepoUrls[$repoUrl]} else {@{}}
        $json.RepoUrls[$repoUrl].BranchNames = 
                                    if ($null -ne $json.RepoUrls[$repoUrl].BranchNames) 
                                        {[string[]]$json.RepoUrls[$repoUrl].BranchNames + $branchName | Sort-Object -Unique} 
                                    else {$branchName}
        
        # Ensure the PSGitSupport folder exists
        $folderPath = Join-Path $env:APPDATA 'PSGitSupport'
        if (-not (Test-Path $folderPath)) {
            New-Item -Type Directory -Path $folderPath | Out-Null
        }

        # Write the data to JSON
        $json | ConvertTo-Json | Set-Content -Path $jsonPath

    } catch {
        Write-Error "Failed to clone the repository. Error: $($_)`n$($_.InvocationInfo.line)"
    }
}


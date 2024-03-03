function Find-MGMTCodeEditors {
    param (
        [string]$OperatingSystem = $env:OS
    )

    if ($OperatingSystem -eq "Windows_NT") {
        # Windows text editors (check if they exist in the PATH)
        $editors = @(
            "code"
            "notepad++"
            "sublime_text"
            "atom"
            "powershell_ise"  # Add PowerShell ISE
            "notepad"
        )
    }
    else {
        # Linux text editors (check if they exist in the PATH)
        $editors = @(
            "code"
            "gedit"
            "nano"
            "emacs"
            "subl"
            "vim"
            "vi"
        )
    }

    # Find the first installed editor
    [string]$Command = $editors|
        ForEach-Object{
            Get-Command -Name $_ -CommandType Application -ErrorAction Ignore
        }|
        Select-Object -First 1 -ExpandProperty Source
    $File = Get-Item $Command
    if ($OperatingSystem -eq "Windows_NT") {
        if (($file.Extension -match '^.(|bat|cmd)$')) {
            [string]$Command = .{
                where.exe $File.BaseName | 
                    Where-Object{$_ -match '\\|/'} | 
                    split-path |
                    ForEach-Object{$_;split-path $_}|
                    Get-ChildItem -filter "$($File.BaseName).exe" -Recurse -ErrorAction Ignore
            } | Where-Object {$_ -ne $null} | Select-Object -First 1 -ExpandProperty FullName
        }
    }
    if ('' -eq $Command) {
        return "No installed text editor found."
    }
    return $Command
}
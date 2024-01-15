# Download-OpenSSH.psm1

function Download-OpenSSH {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [String]$Path
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
        Write-Verbose ("{0,-27}{1,-51}{2}" -f "[$($MyInvocation.MyCommand.Name)]", 'Downloading Powershell OpenSSH-Portable', '[START]')
        switch ($env:PROCESSOR_ARCHITECTURE) {
            "x86"   { $Include = 'OpenSSH-Win32.zip' }
            "ARM"   { $Include = 'OpenSSH-ARM.zip'   }
            "ARM64" { $Include = 'OpenSSH-ARM64.zip' }
            "AMD64" { $Include = 'OpenSSH-Win64.zip' }
            default { $Include = 'OpenSSH-Win64.zip' }
        }
        $URI = Get-GitHubRelease -Owner PowerShell -Name Win32-OpenSSH | Where-Object { $_ -like "*$Include*" }
        $File = Split-Path -Path $URI -Leaf
    }
    process {
        if (-not $Path) {$Path = New-TemporaryDirectory}
        try {
            Download-File -Path $Path -URI $URI -Force
            $FullPath = Join-Path -Path $Path -ChildPath $File
            Write-Output $FullPath 
        } catch {
            Write-Error "[$($MyInvocation.MyCommand.Name)] Error occured while downloading OpenSSH: $_"
        }
    }
    end {
        Write-Verbose ("{0,-27}{1,-51}{2}" -f "[$($MyInvocation.MyCommand.Name)]", 'Downloading Powershell OpenSSH-Portable', '[COMPLETE]')
    }
}

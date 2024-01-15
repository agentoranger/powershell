#
# rSync Installation Module (Install-RSync.psm1)
#
# This module automates the installation, reinstallation, and update of rSync client and server.
# Installation is completed using resources from Microsoft's OpenSSH GitHub Repository.
#
# For documentation about Win32-OpenSSH visit here:
# https://github.com/PowerShell/Win32-OpenSSH
# https://github.com/PowerShell/Win32-OpenSSH/releases
#

function Install-RSync {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Path
    )
    begin {
        $Start = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
        $Job = "[$($MyInvocation.MyCommand.Name)]"
        Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'Installing Powershell OpenSSH-Portable', "[START: $Start]")
    }
    process {
        if (-not $Path)     {$Path     = Join-Path  -Path $ENV:ProgramFiles -ChildPath 'OpenSSH'}
        if (-not $Data)     {$Data     = Join-Path  -Path $ENV:ProgramData  -ChildPath 'ssh'}
        if (-not $Config)   {$Config   = Split-Path -Path (Get-ScriptPath) -Parent}
        if (-not $Services) {$Services = Get-Service -Name ssh-agent,sshd -ErrorAction SilentlyContinue}
        if (-not $Firewall) {$Firewall = Get-NetFirewallRule -Name sshd -ErrorAction SilentlyContinue}
    }
    end {
        $null = Remove-Item -Path (Split-Path -Path $Archive -Parent) -Force -Recurse     
        $End  = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
        $Time = (New-TimeSpan -Start $Start -End $End)
        Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'Installing Powershell OpenSSH-Portable', "[COMPLETE: $Time]")
    }
}

function Uninstall-RSync {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Path
    )
    begin {
        $Start = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
        $Job = "[$($MyInvocation.MyCommand.Name)]"
        Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'Uninstalling Powershell OpenSSH-Portable', '[START]')
    }
    process {
        if (-not $Path)      {$Path      = Join-Path  -Path $ENV:ProgramFiles -ChildPath 'OpenSSH'}
        if (-not $Data)      {$Data      = Join-Path  -Path $ENV:ProgramData  -ChildPath 'ssh'}
        if (-not $Config)    {$Config    = Split-Path -Path (Get-ScriptPath) -Parent}
        if (-not $Services)  {$Services  = Get-Service -Name ssh-agent,sshd -ErrorAction SilentlyContinue}
        if (-not $Uninstall) {$Uninstall = Get-ChildItem -Path (Join-Path -Path $Path -ChildPath 'uninstall-sshd.ps1') -File -ErrorAction SilentlyContinue}
        
        if (Test-Path -Path $Path -PathType Container) {
            if (-not $Uninstall) {
                Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'OpenSSH uninstallation script does not exist', "[$($Uninstall)]")
                $Archive = Download-OpenSSH
                $Package = Unzip-Archive -Path $Archive -Force
                $Install = Get-ChildItem -Path $Package -Directory -Filter 'OpenSSH*' | Select-Object -ExpandProperty FullName
                $null = Copy-Item -Path (Join-Path -Path $Install -ChildPath 'uninstall-sshd.ps1') -Destination $Path -Force -Recurse
            }
            $null = Set-Location -Path $Path
            $null = ./uninstall-sshd.ps1
            $null = Set-Location -Path $Config
        } else {
            Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'OpenSSH installation was not found, nothing to do', "[$($Path)]")
        }

        if (Test-Path -Path $Path -PathType Container) {
            Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'OpenSSH program file was found, directory removed', "[$($Path)]")
            $null = Remove-Item -Path $Path -Force -Recurse
        }

        if (Test-Path -Path $Data -PathType Container) {
            Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'OpenSSH program data was found, directory removed', "[$($Data)]")
            $null = Remove-Item -Path $Data -Force -Recurse
        }
    }
    end {
        $End  = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
        $Time = (New-TimeSpan -Start $Start -End $End)
        Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'Uninstalling Powershell OpenSSH-Portable', "[COMPLETE: $Time]")
    }
}
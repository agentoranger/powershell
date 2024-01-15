#
# OpenSSH Installation Module (Install-OpenSSH.psm1)
#
# This module automates the installation, reinstallation, and update of OpenSSH client and server.
# Installation is completed using resources from Microsoft's OpenSSH GitHub Repository.
#
# For documentation about Win32-OpenSSH visit here:
# https://github.com/PowerShell/Win32-OpenSSH
# https://github.com/PowerShell/Win32-OpenSSH/releases
#

function Install-OpenSSH {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Path
    )
    begin {
        $Start = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
        $Job = "[$($MyInvocation.MyCommand.Name)]"
        $PathRules = @(
            [System.Security.AccessControl.FileSystemAccessRule]::new('BUILTIN\Administrators', 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow'),
            [System.Security.AccessControl.FileSystemAccessRule]::new('NT AUTHORITY\SYSTEM', 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow'),
            [System.Security.AccessControl.FileSystemAccessRule]::new('NT AUTHORITY\SYSTEM', 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow'),
            [System.Security.AccessControl.FileSystemAccessRule]::new('NT AUTHORITY\Authenticated Users', 'ReadAndExecute', 'ContainerInherit,ObjectInherit', 'None', 'Allow')
        )
        $DataRules = @(
            [System.Security.AccessControl.FileSystemAccessRule]::new('BUILTIN\Administrators', 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow'),
            [System.Security.AccessControl.FileSystemAccessRule]::new('NT AUTHORITY\SYSTEM', 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow')
        )
        Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'Installing Powershell OpenSSH-Portable', "[START: $Start]")
    }
    process {
        if (-not $Path)     {$Path     = Join-Path  -Path $ENV:ProgramFiles -ChildPath 'OpenSSH'}
        if (-not $Data)     {$Data     = Join-Path  -Path $ENV:ProgramData  -ChildPath 'ssh'}
        if (-not $Config)   {$Config   = Split-Path -Path (Get-ScriptPath) -Parent}
        if (-not $Services) {$Services = Get-Service -Name ssh-agent,sshd -ErrorAction SilentlyContinue}
        if (-not $Firewall) {$Firewall = Get-NetFirewallRule -Name sshd -ErrorAction SilentlyContinue}

        foreach ($Service in $Services) {
            if ($Service.Status -eq 'Running') {
                $null = Stop-Service -InputObject $Service -Force -NoWait
                Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'OpenSSH services detected, stopping service', "[$($Service.DisplayName)]")
            }
        }

        if (Test-Path -Path $Path -PathType Container) {
             Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'OpenSSH installation directory already exists', "[$($Path)]")
        } else {
            try {
                $null = New-Item -Path $Path -ItemType Directory -Force
                Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'OpenSSH installation directory created', "[$($Path)]")
            } catch {
                Write-Error "$Job Error occured while creating directory: $_"
            }
        }

        if (Test-Path -Path $Data -PathType Container) {
             Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'OpenSSH configuration directory already exists', "[$($Data)]")
        } else {
            try {
                $null = New-Item -Path $Data -ItemType Directory -Force
                Write-Verbose ("{0,-27}{1,-51}{2}" -f $JOB, 'OpenSSH configuration directory created', "[$($Data)]")
            } catch {
                Write-Error "$Job Error occured while creating directory: $_"
            }
        }
        $null = Set-FileSystemACL -Path $Path -Rules $PathRules -Force
        $null = Set-FileSystemACL -Path $Data -Rules $DataRules -Force
        $Archive = Download-OpenSSH
        $Package = Unzip-Archive -Path $Archive -Force
        $Install = Get-ChildItem -Path $Package -Directory -Filter 'OpenSSH*' | Select-Object -ExpandProperty FullName
        $null = Copy-Item -Path (Join-Path -Path $Install -ChildPath '*')           -Destination $Path -Force -Recurse
        $null = Copy-Item -Path (Join-Path -Path $Config  -ChildPath 'sshd_config') -Destination (Join-Path -Path $Data -ChildPath 'sshd_config') -Force -Recurse
        $null = Copy-Item -Path (Join-Path -Path $Config  -ChildPath 'banner.txt')  -Destination (Join-Path -Path $Data -ChildPath 'banner.txt')  -Force -Recurse
        $null = Set-Location -Path $Path
        $null = & $Path\ssh-keygen.exe -A
        $null = & $Path\install-sshd.ps1
        $null = Set-Location -Path $Config
        $null = Add-EnvPath -Path $Path
        $null = if (-not $Firewall) {New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22}
        $null = Get-Service -Name ssh-agent,sshd | Set-Service -StartupType Automatic | Start-Service
        $null = Get-Service -Name ssh-agent,sshd | Start-Service
    }
    end {
        $null = Remove-Item -Path (Split-Path -Path $Archive -Parent) -Force -Recurse     
        $End  = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
        $Time = (New-TimeSpan -Start $Start -End $End)
        Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'Installing Powershell OpenSSH-Portable', "[COMPLETE: $Time]")
    }
}

function Uninstall-OpenSSH {
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
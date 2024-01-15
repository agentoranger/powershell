# Uninstall-OpenSSH.psm1
#function Uninstall-OpenSSH {
#    [CmdletBinding()]
#    param (
#        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
#        [String]$Path
#
#    )
#    begin {
#        Write-Verbose ("{0,-27}{1,-51}{2}" -f "[$($MyInvocation.MyCommand.Name)]", 'Uninstalling Powershell OpenSSH-Portable', '[START]')
#        if (-not $Path)        {$Path        = "$env:ProgramFiles\OpenSSH"}
#        if (-not $regServices) {$Services    = "HKLM:\SYSTEM\CurrentControlSet\Services"}
#
#        if (-not $sshServer)   {$sshServer   = Get-Service -Name 'sshd*'      -ErrorAction SilentlyContinue}
#        if (-not $sshAgent)    {$sshAgent    = Get-Service -Name 'ssh-agent*' -ErrorAction SilentlyContinue}
#
#    }
#    process {
#        try {
#            if(Test-Path -Path $regServices\sshd -PathType Container) {                                                # Test registry path if OpenSSH Server Service exists
#                Write-Host -ForegroundColor Yellow 'Removing OpenSSH Server Service'                                   # Write output to console
#                Set-Service  -Name $sshServer -StartupType Disabled                                                    # Disable OpenSSH Server Service
#                Stop-Service -Name $sshServer -Force -NoWait                                                           # Stop OpenSSH Server Service
#                Get-Item $regServices\sshd | Remove-Item -Recurse -Force                                               # Remove OpenSSH Server Service
#                Get-Item $regServices\ssh-agent | Remove-Item -Recurse -Force                                          # Remove OpenSSH Authentication Agent Service
#            }
#            if(Test-Path -Path $regServices\ssh-agent -PathType Container) {                                           # Test registry path if OpenSSH Authentication Agent Service exists
#                Write-Host -ForegroundColor Yellow 'Removing OpenSSH Authentication Agent Service'                     # Write output to console
#                Get-Service 'ssh-agent*' | Stop-Service -Force -NoWait                                                 # Stop OpenSSH Authentication Agent Service
#                Get-Service 'ssh-agent*' | Set-Service -StartupType Disabled                                           # Disable OpenSSH Authentication Agent Service
#                Get-Item $regServices\ssh-agent | Remove-Item -Recurse -Force                                          # Remove OpenSSH Authentication Agent Service
#            } 
#            Write-Host -ForegroundColor Yellow 'Removing OpenSSH Firewall Rules'                                       # Write output to console
#            Get-NetFirewallRule -Name sshd* | Remove-NetFirewallRule                                                   # Remove OpenSSH firewall rule
#
#            Write-Host -ForegroundColor Yellow 'Removing OpenSSH Installation'                                         # Write output to console
#            If (Test-Path $Path) {                                                                                     # Test file path if OpenSSH installation exists
#                Remove-Item $Path -Recurse                                                                             # Remove OpenSSH installation
#            }                                              
#
#            Write-Host -ForegroundColor Yellow 'Removing OpenSSH from system path'                                     # Write output to console
#            Remove-EnvPath -Path $Path -Container Machine                                                              # Remove OpenSSH installation directory from system path
#
#        } catch {
#            Write-Error "[$($MyInvocation.MyCommand.Name)] Error occured while downloading OpenSSH: $_"
#        }
#    }
#}

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
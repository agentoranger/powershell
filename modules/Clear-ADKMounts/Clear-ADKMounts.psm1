#Clear-ADKMounts.psm1

function Get-ISOMounts {
    [CmdletBinding()]
    param (
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
        $Volumes = Get-Volume -ErrorAction SilentlyContinue
        $Drives = $Volumes | Where-Object { $_.DriveType -eq 'CD-ROM' } -ErrorAction SilentlyContinue
        $ISOMounts = $Drives | Get-DiskImage -StorageType ISO -ErrorAction SilentlyContinue
    }
    process {
        try {
            if ($ISOMounts) {
                $ISOMounts
            }
        } catch {
            Write-Error "$Job Error occurred while getting mounted ISO imagefiles $_"
        }
    }
}

# needs to accept path to filter
function Clear-ISOMounts {
    [CmdletBinding()]
    param (
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
    }
    process {
        $ISOMounts = Get-ISOMounts
        try {
            if ($ISOMounts) {
                ForEach ($ISO in $ISOMounts) {
                    Dismount-DiskImage -ImagePath $ISO.ImagePath -StorageType ISO
                    Write-Host ('{0,-27}{1,-51}{2}' -f $Job, 'ISO imagefile dismounted successfully', "[$($ISO.ImagePath)]")
                }
            } else {
                Write-Host ('{0,-27}{1,-51}' -f $Job, 'ISO imagefile is not currently mounted')
            }
        } catch {
            Write-Error "$Job Error occurred while dismounting ISO imagefile $_"
        }
    }
}

function Get-VHDMounts {
    [CmdletBinding()]
    param(
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
    }
    process {
        if (-not (Get-Command 'Get-VHD' -ErrorAction SilentlyContinue)) {
            return
        }
        $VHDMounts = Get-VHD -ErrorAction SilentlyContinue | Where-Object { $_.Attached -eq $true }
        try {
            If ($VHDMounts) {
                $VHDMounts
            }
        } catch {
            Write-Error "$Job Error occurred while getting mounted VHD imagefiles $_"
        }
    }
}

# needs to accept path to filter
function Clear-VHDMounts {
    [CmdletBinding()]
    param (
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
    }
    process {
        if (-not (Get-Command 'Get-VHD' -ErrorAction SilentlyContinue) ) {
            return
        }
        $VHDMounts = Get-VHDMounts
        try {
            if ($VHDMounts) {
                ForEach ($VHD in $VHDMounts) {
                    Dismount-DiskImage -ImagePath $VHD.ImagePath -StorageType VHDX
                    Write-Host ('{0,-27}{1,-51}{2}' -f $Job, 'VHD imagefile dismounted successfully', "[$($ISO.ImagePath)]")
                }
            } else {
                Write-Host ('{0,-27}{1,-51}' -f $Job, 'VHD imagefile is not currently mounted')
            }
        } catch {
            Write-Error "$Job Error occurred while dismounting VHD imagefile $_"
        }
    }
}

function Clear-REGMounts {
    [CmdletBinding()]
    param (
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
        $RegHives = @(
            @{Mount='xSOFTWARE'; Key='HKEY_LOCAL_MACHINE\xSOFTWARE'},
            @{Mount='xDEFAULT';  Key='HKEY_USERS\xDEFAULT'} |
                ForEach-Object {New-Object System.Object | Add-Member -NotePropertyMembers $_ -PassThru}
        )
    }
    process {
        try {
            ForEach ($RegHive in $RegHives) {
                $RegPath = Join-Path -Path 'Microsoft.PowerShell.Core\Registry::' -ChildPath $RegHive.Key
                If (Test-Path -Path $RegPath) {
                    Remove-RegistryHive -Mount $RegHive.Mount -Key $RegHive.Key
                   #Remove-RegistryHive -Mount 'xSOFTWARE' -Key 'HKEY_LOCAL_MACHINE\xSOFTWARE' -Verbose
                   #Remove-RegistryHive -Mount 'xDEFAULT'  -Key 'HKEY_USERS\xDEFAULT'          -Verbose
                    Write-Host ('{0,-27}{1,-51}{2}' -f $Job, 'Registry hive dismounted successfully', "[$($RegHive.Key)]")
                } else {
                    Write-Host ('{0,-27}{1,-51}{2}' -f $Job, 'Registry hive is not currently mounted', "[$($RegHive.Key)]")
                }
            }

        } catch {
            Write-Error "$Job Registry hive could not be dismounted $_"
        }
    }
}

function Clear-WIMMounts {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [switch]$Save,

        [Parameter(Mandatory=$false, Position=1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [switch]$Discard
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
        $WIMMounts = Get-WindowsImage -Mounted -ErrorAction SilentlyContinue
    }
    process {
        try {
            if ($WIMMounts) {
                ForEach ($WIM in $WIMMounts) {
                    if ($Save) {
                        $null = Dismount-WindowsImage -Path $WIM.Path -Save
                    } else {
                        $null = Dismount-WindowsImage -Path $WIM.Path -Discard
                    }
                    Write-Host ('{0,-27}{1,-51}{2}' -f $Job, 'Windows image has been dismounted successfully', "[$($WIM.ImagePath)]")
                }
            } else {
                Write-Host ('{0,-27}{1,-51}' -f $Job, 'Windows image is not currently mounted')

            }
        } catch {
            Write-Error "$Job Error occurred while dismounting Windows image $_"
        }
    }
}


function Clear-ADKMounts {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [switch]$Save,

        [Parameter(Mandatory=$false, Position=1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [switch]$Discard
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
        Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Clearing mounted images and registry hives', '[START]')
    }
    process {
    if (-not $LogLevel) {$LogLevel=1}
        try {
            $null = Clear-REGMounts
            $null = Clear-WindowsCorruptMountPoint
            $null = Clear-ISOMounts
            $null = Clear-VHDMounts
          
            if ($Save) {
                $null = Clear-WIMMounts -Save
            } else {
                $null = Clear-WIMMounts -Discard
            }

            Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Clearing mounted images and registry hives', '[SUCCESS]')
        } catch {
            Write-Error "$Job Error occurred while dismounting ADK Resources $_"
        }
    }
}

function Clear-ADKCache {
    [CmdletBinding()]
    param(

        [Parameter(Mandatory=$true, Position=1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Sources,

        [Parameter(Mandatory=$true, Position=2, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Edition,

        [Parameter(Mandatory=$true, Position=3, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Preset,

        [Parameter(Mandatory=$true, Position=4, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Deploy,

        [Parameter(Mandatory=$true, Position=5, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Mount,

        [Parameter(Mandatory=$true, Position=6, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$LogPath
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
        Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Clearing cached images, scratch directory, and logs', '[START]')
    }
    process {
        $ImageVHD = Join-Path -Path $SOURCES -ChildPath $EDITION-$PRESET-$DEPLOY.VHDX
        $ImageADK = Join-Path -Path $SOURCES -ChildPath $EDITION

        try {
            if (Test-Path $VHDXPath) {
                #$null = Remove-Item -Path $VHDXPath -Force -Confirm:$false
                Remove-Item -Path $VHDXPath -Force -Confirm:$false
            }

            if (Test-Path $EditionPath) {
                #$null = Remove-Item -Path $EditionPath\* -Recurse -Force -Confirm:$false
                Remove-Item -Path $EditionPath\* -Recurse -Force -Confirm:$false
            }

            foreach ($path in $SCRATCH, $MOUNT, $LOGPATH) {
                if (Test-Path $path) {
                    #$null = Remove-Item -Path $path -Recurse -Force -Confirm:$false
                    Remove-Item -Path $path -Recurse -Force -Confirm:$false
                }
            }

            foreach ($path in $SCRATCH, $MOUNT) {
                if (-not (Test-Path $path)) {
                    #$null = New-Item -Path $path -ItemType Directory -Force -Confirm:$false
                    New-Item -Path $path -ItemType Directory -Force -Confirm:$false
                }
            }
            Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Clearing cached images, scratch directory, and logs', '[SUCCESS]')
        } catch {
            Write-Error "$Job Error occurred while dismounting ADK Resources $_"
        }
    }
}

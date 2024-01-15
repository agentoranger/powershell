function Get-UserRegistryPaths {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Path = "Microsoft.PowerShell.Core\Registry::HKEY_USERS",

        [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true,  ValueFromPipelineByPropertyName = $true)]
        [switch]$System,

        [Parameter(Mandatory = $false, Position = 2, ValueFromPipeline = $true,  ValueFromPipelineByPropertyName = $true)]
        [switch]$Default,

        [Parameter(Mandatory = $false, Position = 3, ValueFromPipeline = $true,  ValueFromPipelineByPropertyName = $true)]
        [switch]$Internal,

        [Parameter(Mandatory = $false, Position = 4, ValueFromPipeline = $true,  ValueFromPipelineByPropertyName = $true)]
        [switch]$External
    )
    begin {
        if (-not $Path) {
            Write-Warning "[$($MyInvocation.MyCommand.Name)]`tUser registry path is null"
            return
        }
        try {
            $userHives = Get-ChildItem $Path | ForEach-Object {
                if ($_.PSPath -notmatch 'Classes') {
                    $_.PSPath
                }
            }
        } catch {
            Write-Error "[$($MyInvocation.MyCommand.Name)]`tError occured while getting user registry paths: $_"
        }
    }
    process {
        ForEach ($userHive in $userHives) {
            try {
                $SID = ($userHive -split '\\')[-1]
                $Profiles = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$SID"
                if ($Default -and $SID -eq '.DEFAULT') {
                    Write-Output $userHive
                    Write-Verbose "[$($MyInvocation.MyCommand.Name)]`tProfile with [$($SID)] corresponds to default user"
                } elseif ($System   -and $SID -match '^S-1-5-(18|19|20)') {
                    Write-Output $userHive
                    Write-Verbose "[$($MyInvocation.MyCommand.Name)]`tProfile with [$($SID)] corresponds to system user"                   
                } elseif ($Internal -and $SID -notmatch '^S-1-5-(18|19|20)' -and (Test-Path -Path $Profiles)) {
                    Write-Output $userHive
                    Write-Verbose "[$($MyInvocation.MyCommand.Name)]`tProfile with [$($SID)] corresponds to internal user"
                } elseif ($External -and $SID -ne '.DEFAULT' -and -not (Test-Path -Path $Profiles)) {
                    Write-Output $userHive
                    Write-Verbose "[$($MyInvocation.MyCommand.Name)]`tProfile with [$($SID)] corresponds to external user"
                }
            } catch {
                Write-Error "[$($MyInvocation.MyCommand.Name)]`tError occured while processing user registry paths: $_"
            }
        }
    }
}

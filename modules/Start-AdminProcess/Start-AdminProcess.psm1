# Start-AdminProcess.psm1

function Test-Admin {
    [CmdletBinding()]
    $isAdmin = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    return $isAdmin
}

function Start-AdminProcess {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]$FilePath         = $([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName),

        [Parameter(Position = 1)]
        [string]$WorkingDirectory = $((Get-ScriptPath).PWD),

        [Parameter(Position = 2)]
        [AllowNull()]
        [AllowEmptyString()]
        [array]$ArgumentList = $null
    )
    try {
        $modules = @('Get-ScriptPath' )
        $modulesLoaded = Get-Module -Name $modules -ListAvailable -ErrorAction SilentlyContinue

        # Import the module if not already loaded
        if (-not $modulesLoaded) {
            Import-Module -Name $modules -Verbose
        }

        $processStartInfo    = @{
            FilePath         = $FilePath
            WorkingDirectory = $WorkingDirectory
            Verb             = 'runas'
        }

        if ($ArgumentList -ne $null) {
            $processStartInfo.Add('ArgumentList', $ArgumentList)
        }

        Import-Module -Name Get-ScriptPath

        Write-Verbose "[$($FilePath | Split-Path -Leaf)] Starting process as administrator with [$(0 + $($ArgumentList.Count))] arguments"
        Start-Process @processStartInfo -ErrorAction Stop

    } catch {
        Write-Error "Error: $_"
    }
}
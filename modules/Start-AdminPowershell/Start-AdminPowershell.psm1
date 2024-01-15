# Start-Start-AdminPowershell.psm1

function Test-Admin {
    [CmdletBinding()]
    $isAdmin = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    return $isAdmin
}

function Start-AdminPowershell {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true,  ValueFromPipelineByPropertyName = $true)]
        [string]$ScriptFile,

        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true,  ValueFromPipelineByPropertyName = $true)]
        [string]$ScriptPath
    )
    begin {
        $FilePath = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName  
        Switch (($PSVersionTable.PSVersion).Major) {
            {$_ -ge 6} {$FilePath = 'pwsh.exe'}
            {$_ -le 5} {$FilePath = 'powershell.exe'}
             default   {$FilePath = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName}
        }
        $startParameters = @{
            FilePath = $FilePath
            Verb     = 'runas'  
        }
    }
    process {
        try {
            if ($ScriptFile) {$startParameters['ArgumentList'] = "-file $ScriptFile"}
            if ($ScriptPath) {$startParameters['WorkingDirectory'] = $ScriptPath}
            Write-Verbose "[$($MyInvocation.MyCommand.Name)]`tStarting powershell as administrator with [$(0 + $($startParameters.Count))] arguments"
            Start-Process @startParameters -WindowStyle Hidden -NoNewWindow
        } catch {
            Write-Error "Error: $_"
        }
    }
}

function Invoke-AdminPowershell {
    If (Test-Admin) {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)]`tPowershell is running as administrator`t[$($Host.Name)]"
    } else {
        Start-AdminPowershell -ScriptFile $ScriptFile -ScriptPath $ScriptPath
        exit
    }
}
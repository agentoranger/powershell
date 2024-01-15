# Get-ScriptPath.psm1
#$VerbosePreference = "Continue"

function Get-ScriptPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [switch]$SetLocation 
    )
    begin {
        try {
            $ScriptInfo = @(
                if ($MyInvocation.ScriptName)    {$MyInvocation.ScriptName}
                if ($MyInvocation.PSCommandPath) {$MyInvocation.PSCommandPath}
                if ($PSISE.CurrentFile.FullPath) {$PSISE.CurrentFile.FullPath}
                if ($PSEditor)                   {$PSEditor.GetEditorContext().CurrentFile.Path}
                if ($PWD)                        {$PWD.Path}
                if ($PSScriptRoot)               {$PSScriptRoot}
            )
            $ScriptFile = ($ScriptInfo | Select-Object -First 1).ToString()
            $ScriptPath = ($ScriptFile | Split-Path -Parent)
        } catch [System.Management.Automation.ItemNotFoundException] {
            Write-Error "[$($MyInvocation.MyCommand.Name)]`tResolved script path to a path that cannot be found: $_"
        } catch {
            Write-Error "[$($MyInvocation.MyCommand.Name)]`tError occured while getting the script path: $_"
        }
    }
    process {
        try {
            $ScriptFile
            if ($SetLocation -and $ScriptPath) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)]`t`t`tSetting the current directory to path`t[$($ScriptPath)]"
                Set-Location  -Path $ScriptPath
            }
        } catch [System.Management.Automation.ItemNotFoundException] {
            Write-Error "[$($MyInvocation.MyCommand.Name)]`tResolved current directory to a path that cannot be found: $_"
        } catch {
            Write-Error "[$($MyInvocation.MyCommand.Name)]`tError occured while setting the current directory: $_"
        }
    }
}
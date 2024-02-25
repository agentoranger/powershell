#Invoke-Script.psm1

function Invoke-Script {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [object]$Path
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
    }
    process {
        switch ($Path.Extension) {
            '.ps1' {
                Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Invoking PowerShell Script file', "[$($Path.FullName)]")
                & $Path.FullName
            }'.cmd' {
                Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Invoking Command Script file', "[$($Path.FullName)]")
                & $Path.FullName
            }'.py' {
                Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Invoking Python Script file', "[$($Path.FullName)]")
                & $Path.FullName
            }'.sh' {
                Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Invoking BASH Script file', "[$($Path.FullName)]")
                & $Path.FullName
            } default {
                Write-Warning ("{0,-27}{1,-51}{2}" -f $Job, 'Invoking unsupported script type', "[$($Path.FullName)]")
            }
        }
    }
}

function Invoke-Scripts {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,  Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [object]$Path,

        [Parameter(Mandatory=$false, Position=1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('Parallel')]
        [switch]$Asynchronous
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
        workflow Invoke-Scripts {
            param($ScriptFiles)
            Foreach -Parallel ($ScriptFile in $ScriptFiles) {
                Invoke-Script -Path $ScriptFile
            }
        }
    }
    process {
        $ScriptFiles = Get-ChildItem -Path $Path -Include *.ps1, *.cmd, *.py, *.sh -File -ErrorAction SilentlyContinue
        Try {
            if ($Asynchronous) {
                Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Invoking scripts asynchronously', '[START]')
                Invoke-Scripts $ScriptFiles
            } else {
                Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Invoking scripts synchronously', '[START]')
                Foreach ($ScriptFile in $ScriptFiles) {
                    Invoke-Script -Path $ScriptFile
                }
            }
        }
        catch {
            $ScriptError = $true
            Write-Error "$Job Error during script execution $($ScriptFile.FullName): $_"
        }
        finally {
            if ($ScriptError) {
                Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Script execution failed', '[FAILED]')
            } else {
                Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Script execution suceeded', '[SUCCESS]')
            }
        }
    }
}
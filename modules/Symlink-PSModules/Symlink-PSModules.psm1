#Symlink-PSModules.psm1

function Symlink-PSModules {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [object]$Path
    )
    begin {
        Invoke-AdminPowershell
        $Job = "[$($MyInvocation.MyCommand.Name)]"
        $destinationPath = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\Modules"
    }
    process {
        Get-ChildItem -Path $Path -Directory | ForEach-Object {
            $ModuleName = $_.Name
            $ModuleSource = Join-Path -Path $Path -ChildPath $moduleName
            $ModuleDestination = Join-Path -Path $destinationPath -ChildPath $moduleName

            if (Test-Path -Path $ModuleDestination -PathType Container) {
                Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Symbolic link already exists for powershell module', "[$($moduleName)]")
            } else {             
                New-Item -Path $ModuleDestination -ItemType SymbolicLink -Value $ModuleSource -Force
                Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Symbolic link created for powershell module', "[$($moduleName)]")
            }
        }
    }
}
#Remove-RegistryHive.psm1
function Remove-RegistryHive {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidatePattern('^(HKLM\\|HKCU\\|HKEY[a-zA-Z0-9- _\\]+)[a-zA-Z0-9- _\\]+$')]
        [string]$Key,

        [Parameter(Mandatory=$true, Position=1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidatePattern('^[^;~/\\\.\:]+$')]
        [string]$Mount
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
    }
    process {
        $Drive = Get-PSDrive -Name $Mount -PSProvider Registry -Scope Global -ErrorAction SilentlyContinue
        $HivePath = Join-Path -Path 'Microsoft.PowerShell.Core\Registry::' -ChildPath $Key
        $Hive     = Get-Item  -Path $HivePath -ErrorAction SilentlyContinue

        try {
            if ($Drive) {
                $Drive | Remove-PSDrive
                Write-Debug ("{0,-27}{1,-51}{2}" -f $Job,'Registry hive unloaded from powershell',"[$($Mount)]")
            } else {
                Write-Warning ("{0,-27}{1,-51}{2}" -f $Job,'Registry hive not currently loaded into powershell',"[$($Mount)]")
            }
        } catch {
            Write-Error "$Job Registry hive could not be unloaded from powershell [$($Mount)] $_"
        }

        try {
            if ($Hive) {
                Remove-Object -Object $Hive
                $System32 = Join-Path -Path $env:SystemRoot -ChildPath 'System32' -Resolve
                $FilePath = Join-Path -Path $System32       -ChildPath 'reg.exe'  -Resolve
                $ArgumentList = ('unload',$Key)
                $Process = Start-Process -FilePath $FilePath -ArgumentList $ArgumentList -WindowStyle Hidden -Wait

                if ($Process.ExitCode) {
                    Write-Error "$Job Registry hive could not be unloaded from registry [$($Path)] [$($Mount)] $_"
                } else {
                    Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job,'Registry hive unloaded successfully',"[$($Mount)]")
                }

            } else {
                Write-Warning ("{0,-27}{1,-51}{2}" -f $Job,'Registry hive not currently loaded into registry',"[$($Mount)]")
                return
            }
        } catch {
            Write-Error "$Job Registry hive could not be unloaded from registry [$($Mount)] $_"
        }
       
    }
}

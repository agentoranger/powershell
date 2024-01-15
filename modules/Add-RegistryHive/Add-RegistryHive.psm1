#Add-RegistryHive.psm1

function Add-RegistryHive {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(Mandatory=$true, Position=1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidatePattern('^(HKLM\\|HKCU\\|HKEY[a-zA-Z0-9- _\\]+)[a-zA-Z0-9- _\\]+$')]
        [string]$Key,

        [Parameter(Mandatory=$true, Position=2, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidatePattern('^[^;~/\\\.\:]+$')]
        [string]$Mount
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
    }
    process {
        if (-not $Drive) {
            $Drive = Get-PSDrive -Name $Mount -PSProvider Registry -Scope Global -ErrorAction SilentlyContinue
        }

        if ($Drive) {
            Write-Warning ("{0,-27}{1,-51}{2}" -f $Job,'Registry hive has already been loaded',"[$($Mount)]")
            return
        }

        try {
            if (Test-Path -Path $Path) {
                $System32 = Join-Path -Path $env:SystemRoot -ChildPath 'System32' -Resolve
                $FilePath = Join-Path -Path $System32       -ChildPath 'reg.exe'  -Resolve
                $ArgumentList = @('load',$Key,$Path)
                $Process = Start-Process -FilePath $FilePath -ArgumentList $ArgumentList -WindowStyle Hidden -Wait

                if ($Process.ExitCode) {
                    Write-Error "$Job Registry hive could not be loaded [$($Mount)] $_"
                } else {
                    $null = New-PSDrive -Name $Mount -PSProvider Registry -Root $Key -Scope Global
                    Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job,'Registry hive loaded successfully',"[$($Mount)]")
                }

            } else {
                Write-Warning ("{0,-27}{1,-51}{2}" -f $Job,'Registry hive could not be found',"[$($Mount)]")
                return
            }
        } catch {
            Write-Error "$Job Registry hive could not be loaded [$($Mount)] $_"
        }
    }
}
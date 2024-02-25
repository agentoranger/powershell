#Test-RegistryPath.psm1

function Test-RegistryPath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
       #[ValidatePattern('^(HKLM\\|HKCU\\|HKEY[a-zA-Z0-9- _\\]+)[a-zA-Z0-9- _\\]+$')]
        [string]$Path,

        [Parameter(Mandatory = $false, Position=1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Name,

        [Parameter(Mandatory = $false, Position=2, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Type,
        
        [Parameter(Mandatory = $false, Position=3, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Value,
        
        [Parameter(Mandatory = $false, Position=4, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [switch]$CreateKey       
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
    }
    process {
        If ($Path -notlike "Microsoft.PowerShell.Core\Registry::*") {
            $Path = Join-Path -Path "Microsoft.PowerShell.Core\Registry::" -ChildPath $Path 
        }
        try {
            if (-not (Test-Path -Path $Path)) {
                if ($CreateKey) {
                    $null = New-Item -Path $Path -ItemType Directory
                    Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Registry key path created successfully',"[$($Path.Split('::',2)[1].TrimStart(':\'))]")
                    Write-Output $true
                } else {
                    Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Registry key path does not exist',"[$($Path.Split('::',2)[1].TrimStart(':\'))]")
                    Write-Output $false
                }
            } else {
                Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'Registry key path found successfully',"[$($Path.Split('::',2)[1].TrimStart(':\'))]")
                Write-Output $true
            }
        } catch {
            Write-Error "$Job Error occurred while testing the regustry path $_"
        }
    }
}

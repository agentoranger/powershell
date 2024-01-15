#Test-RegistryValue.psm1

function Test-RegistryValue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,  Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(Mandatory = $true,  Position=1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $false, Position=2, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Type,

        [Parameter(Mandatory = $false, Position=3, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Value

    )
    process {
        try {
            $regValue = Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue
            if ($regValue) {
                Write-Debug "[$($MyInvocation.MyCommand.Name)]`tRegistry value found successfully`t`t[$($Path | Split-Path -Leaf)] [$($Name)]"
                return $true
            } else {
                Write-Debug "[$($MyInvocation.MyCommand.Name)]`tRegistry value does not exist`t`t`t[$($Path | Split-Path -Leaf)] [$($Name)]"
                return $false
            }
        } catch {
            Write-Error "[$($MyInvocation.MyCommand.Name)] $_"
            break
        }
    }
}
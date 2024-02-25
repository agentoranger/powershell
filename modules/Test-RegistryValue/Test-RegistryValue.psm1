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
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
    }
    process {
        try {
            $regValue = Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue
            if ($regValue) {
                Write-Debug ("{0,-27}{1,-51}{2}" -f $Job, 'Registry value found successfully',"[$($Path.Split('::',2)[1].TrimStart(':'))]")
                return $true
            } else {
                Write-Debug ("{0,-27}{1,-51}{2}" -f $Job, 'Registry value does not exist',"[$($Path.Split('::',2)[1].TrimStart(':'))]")
                return $false
            }
        } catch {
            Write-Error "[$($MyInvocation.MyCommand.Name)] $_"
            break
        }
    }
}
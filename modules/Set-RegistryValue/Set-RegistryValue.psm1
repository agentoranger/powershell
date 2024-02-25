function Set-RegistryValue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(Mandatory = $true, Position=1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $true, Position=2, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Type,

        [Parameter(Mandatory = $true, Position=3, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Value
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
    }
    process {
        try {
            $regKey   = Test-RegistryPath  @PSBoundParameters -CreateKey
            $regValue = Test-RegistryValue @PSBoundParameters -ErrorAction SilentlyContinue
            if (-not $regKey) {
                Write-Warning ("{0,-27}{1,-51}{2}" -f $Job, 'Registry key path is currently null',"[$($Path.Split('::',2)[1].TrimStart(':'))]")
                return
            }
            if ($regValue) {
                $null = Set-ItemProperty @PSBoundParameters -Force
                Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Registry value written successfully',"[$($Path.Split('::',2)[1].TrimStart(':'))] [$($Name)] [$($Type):$($Value)]")
            } else {
                $null = New-ItemProperty @PSBoundParameters -Force
                Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Registry value created successfully',"[$($Path.Split('::',2)[1].TrimStart(':'))] [$($Name)] [$($Type):$($Value)]")
            }
        } catch {
            Write-Error "$Job Registry value failed to be written $_"
        }
    }
}
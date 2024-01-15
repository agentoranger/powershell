# Set-FileSystemACL.psm1

function Set-FileSystemACL {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,  Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true,  Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [System.Security.AccessControl.FileSystemAccessRule[]]$Rules,

        [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [switch]$Force
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]";
    }
    process {
        try {
            if ($Force) {
                Reset-FileSystemACL -Path $Path
            }
            $ACL = Get-Acl -Path $Path          
            foreach ($Rule in $Rules) {
                $ACL.AddAccessRule($Rule)
            }
            $null = Set-Acl -Path $Path -AclObject $ACL
            Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'Filesystem permissions configured successfully', "[$Path]")
        }
        catch {
            Write-Error "$Job Error occurred while setting filesystem permissions: $_"
        }
    }
}
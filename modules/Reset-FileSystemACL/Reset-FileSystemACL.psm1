# Reset-FileSystemACL.psm1

function Reset-FileSystemACL {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Path
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]";
    }
    process {
        try {
            $ACL = Get-Acl -Path $Path
            $ACL.SetAccessRuleProtection($true, $false)
            $null = Set-Acl -Path $Path -AclObject $ACL

            if ($PSCmdlet.ShouldProcess("Reset ACL for $Path")) {
                Write-Verbose ("{0,-27}{1,-51}{2}" -f $JOB, 'Filesystem permissions reset successfully', "[$($Path)]")
            }
        }
        catch {
            Write-Error "$Job Error occured while resetting filesystem permissions: $_"
        }
    }
}

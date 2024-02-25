#Clear-Symlinks.psm1

function Clear-Symlinks {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [object]$Path
    )
    begin {
        Invoke-AdminPowershell
        $Job = "[$($MyInvocation.MyCommand.Name)]"
    }
    process {
        Try {
            Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Clearing symlinks found in path', "[$($Path)]")
            Get-ChildItem -Path $Path -Force -Recurse -ErrorAction STOP | Where-Object { if($_.Attributes -match "ReparsePoint"){$_.Delete()}}
        }
        catch {
            Write-Error "$Job Error while clearing symlinks: $_"
        }
    }
}
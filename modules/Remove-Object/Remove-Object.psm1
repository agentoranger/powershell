#Remove-Object.psm1
function Remove-Object {
    param (
        [Parameter(Mandatory=$false, Position=1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias("InputObject")]
        [System.Object]$Object
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
        # Check if the object is not null
        if (-not $Object) {
            Write-Warning "$Job The specified object is null. No disposal or variable removal performed. [$($Object.PSChildName)]"
            break
        }
    }
    process {
        try {
            # Check if the object has a Close method and dispose of it
            if ($Object -is [System.IDisposable]) {
                $Object.Close()
                $Object.Dispose()
            }

            # Check if the variable exists before attempting to remove it
            if (Get-Variable -Name $Object.PSChildName -Scope Global -ErrorAction SilentlyContinue) {
                Remove-Variable -Name $Object.PSChildName -Scope Global -Force
            }

            # Manually trigger garbage collection and wait for pending finalizers to complete
            [System.GC]::Collect()
            [System.GC]::WaitForPendingFinalizers()

            Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'Disposed of object and released reference', "[$($Object.PSChildName)]")
        }
        catch {
            Write-Error "$Job Error disposing the specified object [$($Object.PSChildName)] $_"
        }
    }
}
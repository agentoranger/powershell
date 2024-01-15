# Add-EnvPath.psm1
# https://gist.github.com/mkropat

function Add-EnvPath {
    param(
        [Parameter(Mandatory = $true,  Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string] $Path,

        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('Machine', 'User', 'Session')]
        [string] $Container
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]";
    }
    process {
        try {
            if (-not $Container) {$Container = 'Session'}
                if ($Container -ne 'Session') {
                    $containerMapping = @{
                        Machine = [EnvironmentVariableTarget]::Machine
                        User = [EnvironmentVariableTarget]::User
                    }
                    $containerType = $containerMapping[$Container]
                    $persistedPaths = [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';'
                    if ($persistedPaths -notcontains $Path) {
                        $persistedPaths = $persistedPaths + $Path | where { $_ }
                        [Environment]::SetEnvironmentVariable('Path', $persistedPaths -join ';', $containerType)
                    }
                }
            $envPaths = $env:Path -split ';'
            if ($envPaths -notcontains $Path) {
                $envPaths = $envPaths + $Path | where { $_ }
                $env:Path = $envPaths -join ';'
                Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'Added path to environment variables', "[$($Path)]")
            } else {
                Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'Environment variable for path already exists', "[$($Path)]")
            }
        } catch {
            Write-Error "$Job Error occured while adding to environment variables: $_"
        }
    }
}
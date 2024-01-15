# Download-OpenSSH.psm1
# https://gist.github.com/mkropat

function Get-EnvPath {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('Machine', 'User')]
        [string] $Container
    )

    $containerMapping = @{
        Machine = [EnvironmentVariableTarget]::Machine
        User = [EnvironmentVariableTarget]::User
    }
    $containerType = $containerMapping[$Container]

    [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';' |
        where { $_ }
}

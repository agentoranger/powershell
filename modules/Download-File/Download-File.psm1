# Download-File.psm1

function Download-File {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,  Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [String]$URI,

        [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [String]$Path,

        [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Switch]$Force
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
    }
    process {
        if (-not $Path) {$Path = New-TemporaryDirectory}
        $File = Split-Path -Path $URI -Leaf
        $FullPath = Join-Path -Path $Path -ChildPath $File
        try {
            if (-not (Test-Path $Path -PathType Container)) {
                $null = New-Item -ItemType Directory -Path $Path -Force
                Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'Created download directory', "$($Path)")
            }
            if (Test-Path $FullPath -PathType Leaf) {
                if ($Force) {
                    Remove-Item $FullPath -Force
                    Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'Destination file already exists, file removed', "[$($FullPath)]")
                } else {
                    Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'Destination file already exists, file skipped', "[$($FullPath)]")
                    return
                }
            }
            $ProgressPreference = 'SilentlyContinue'
            $null = Invoke-WebRequest -Uri $URI -OutFile $FullPath -UseBasicParsing
            $ProgressPreference = 'Continue'
            Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'File downloaded to destination path successfully', "[$($URI)] ⎯⎯▶ [$($FullPath)]")
        } catch {
            Write-Error "[$($MyInvocation.MyCommand.Name)] Error occurred while downloading file: $_"
        }
    }
}

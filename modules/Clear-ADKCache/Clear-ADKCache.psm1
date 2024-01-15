# Clear-ADKCache.psm1

function Clear-ADKCache {
    [CmdletBinding()]
    param(

        [Parameter(Mandatory=$true, Position=1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Sources,

        [Parameter(Mandatory=$true, Position=2, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Edition,

        [Parameter(Mandatory=$true, Position=3, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Preset,

        [Parameter(Mandatory=$true, Position=4, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Deploy,

        [Parameter(Mandatory=$true, Position=5, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Mount,

        [Parameter(Mandatory=$true, Position=5, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Scratch,

        [Parameter(Mandatory=$true, Position=6, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$LogPath
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
        Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Clearing cached images, scratch, and logs', '[START]')
    }
    process {
        $ImageVHD = Join-Path -Path $Sources -ChildPath $Edition-$Preset-$Deploy.vhdx
        $ImageADK = Join-Path -Path $Sources -ChildPath $Edition

        try {
            if (Test-Path -Path $ImageVHD -PathType Container) {
                $null = Remove-Item -Path $ImageVHD -Force -Confirm:$false
                Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Clearing cached virtual disk image file', "[$($ImageVHD)]")
            }

            if (Test-Path -Path $ImageADK -PathType Container) {
                $null = Remove-Item -Path $ImageADK\* -Recurse -Force -Confirm:$false
                Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Clearing cached system image directory', "[$($ImageADK)]")
            }

            foreach ($Path in $Scratch, $Mount, $LogPath) {
                if (Test-Path -Path $Path -PathType Container) {
                    $null = Remove-Item -Path $Path -Recurse -Force -Confirm:$false
                    Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Clearing cached system image data', "[$($Path)]")
                }
            }

            foreach ($Path in $Scratch, $Mount) {
                if (-not  (Test-Path -Path $Path -PathType Container)) {
                    $null = New-Item -Path $Path -ItemType Directory -Force -Confirm:$false
                }
            }
            Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Clearing cached images, scratch, and logs', '[SUCCESS]')
        } catch {
            Write-Error "$Job Error occurred while clearing cached resources $_"
        }
    }
}

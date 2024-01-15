# Unzip-Archive.psm1

function Unzip-Archive {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,  Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [String]$Path = 'C:\Users\xAdmin\AppData\Local\Temp\04c12aba-756a-487c-b971-d45fefe5bf89\OpenSSH-Win64.zip',

        [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [String]$DestinationPath,

        [Parameter(Mandatory = $false, Position = 2, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Switch]$Force
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
        $ScriptPath = (Split-Path -Path (Get-ScriptPath) -Parent)
        $ScriptName = (Split-Path -Path (Get-ScriptPath) -Leaf) -replace '\.[^.]*$'
        $Extensions = '*.zip','*.rar','*.7z','*.cab'
    }
    process {
        if ($Path) {
            $Path = (Get-Item -Path $Path -Include $Extensions).FullName
        } else {
            $Path = (Get-ChildItem -Path $ScriptPath\$ScriptName* -Include $Extensions -File).FullName
        }
        if (-not $DestinationPath) {$DestinationPath = ($Path -replace '\.[^.]*$')}
        try {
            if (Test-Path -Path $DestinationPath -PathType Container) {
                if ($Force) {
                    $null = Remove-Item -Path $DestinationPath -Recurse -Force
                        Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'Destination path already exists, directory removed', "[$($DestinationPath)]")
                    } else {
                        Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'Destination path already exists, directory skipped', "[$($DestinationPath)]")
                    }
                } else {
                New-Item -Path $DestinationPath -ItemType Directory
                Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'Destination path does not exist, directory created', "[$($DestinationPath)]")
            }
            $null = Expand-Archive -Path $Path -DestinationPath $DestinationPath -Force
            Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'Archive file extracted to destination path', "[$($Path)] ⎯⎯▶ [$($DestinationPath)]")
            Write-Output $DestinationPath
        } catch {
            Write-Error "$Job Error occurred while extracting archive file: $_"
        } finally {
            if ($Archive) {
                $null = $Archive.Dispose()
            }
        }
    }
}

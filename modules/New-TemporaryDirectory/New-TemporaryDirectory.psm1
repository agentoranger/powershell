# New-TemporaryDirectory.psm1

function New-TemporaryDirectory {
    [CmdletBinding()]
    param ()
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
		$Parent = [System.IO.Path]::GetTempPath()
		$Child = [System.Guid]::NewGuid().ToString()
        $Path = (Join-Path -Path $Parent -ChildPath $Child)
    }
    process {
		$TempDir = New-Item -ItemType Directory -Path $Path -Force -Confirm:$false
        Write-Verbose ("{0,-27}{1,-51}{2}" -f $Job, 'Installing Powershell OpenSSH-Portable', "[$($TempDir)]")
        Write-Output $TempDir.FullName
    }
}
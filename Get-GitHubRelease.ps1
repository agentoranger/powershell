function Get-GitHubRelease {
    param(
        [string]$Owner,
        [string]$Name
    )

    process {
        try {
            $URI = "https://api.github.com/repos/$Owner/$Name/releases/latest"
            $Response = Invoke-RestMethod -Uri $URI

            $latestRelease = @{
                Name = $Response.name
                TagName = $Response.tag_name
                PublishedAt = $Response.published_at
                Assets = @()
            }

            foreach ($Asset in $Response.assets) {
                $latestRelease.Assets += @{
                    Name = $Asset.name
                    Size = $Asset.size
                    DownloadUrl = $Asset.browser_download_url
                }
            }

            ForEach ($Release in $latestRelease.Assets) {
                Write-Output $Release.DownloadUrl
            }
        } catch {
            Write-Error "[$($MyInvocation.MyCommand.Name)]`tError occured while getting GitHub info: $_"
        }
    }
}

# Example usage
Get-GitHubRelease -Owner PowerShell -Name Win32-OpenSSH
Get-GitHubRelease -Owner PowerShell -Name LibreSSL

# Example output
https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.4.0.0p1-Beta/OpenSSH-ARM.zip
https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.4.0.0p1-Beta/OpenSSH-ARM64-v9.4.0.0.msi
https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.4.0.0p1-Beta/OpenSSH-ARM64.zip
https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.4.0.0p1-Beta/OpenSSH-ARM64_Symbols.zip
https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.4.0.0p1-Beta/OpenSSH-ARM_Symbols.zip
https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.4.0.0p1-Beta/OpenSSH-Win32-v9.4.0.0.msi
https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.4.0.0p1-Beta/OpenSSH-Win32.zip
https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.4.0.0p1-Beta/OpenSSH-Win32_Symbols.zip
https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.4.0.0p1-Beta/OpenSSH-Win64-v9.4.0.0.msi
https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.4.0.0p1-Beta/OpenSSH-Win64.zip
https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.4.0.0p1-Beta/OpenSSH-Win64_Symbols.zip
https://github.com/PowerShell/LibreSSL/releases/download/V3.7.3.0/LibreSSL.zip

# Example usage, filtering with fuzzy strings
  $Filter = '*Win64*'
$Releases = Get-GitHubRelease -Owner PowerShell -Name Win32-OpenSSH
$Filtered = $Releases | Where-Object { $_ -like $filter }
$Filtered

# Example output
https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.4.0.0p1-Beta/OpenSSH-Win64-v9.4.0.0.msi
https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.4.0.0p1-Beta/OpenSSH-Win64.zip
https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.4.0.0p1-Beta/OpenSSH-Win64_Symbols.zip

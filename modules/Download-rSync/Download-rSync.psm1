# Download-rSync.psm1

function Filter-DownloadUrls {
    param (
        [string[]]$URIs,
        [switch]$FilterLanguage,
        [switch]$FilterArchitecture,
        [switch]$FilterLatestVersion
    )

    # Function to extract version from a string
    function Get-VersionString {
        param (
            [string]$String
        )

        # Define an array of version regex patterns
        $versionPatterns = @(
            '(\d+\.\d+\.\d+_\w+)',                                                 # Pattern: Major.Minor.Patch_Build                         (1.2.3_alpha)
            '(\d+\.\d+.\d+\.\d+)',                                                 # Pattern: Major.Minor.Patch_Build                         (1.2.3_4)
            '(\d+\.\d+.\d+\.\d+)',                                                 # Pattern: Major.Minor.Patch.Build                         (1.2.3.4)
            '(\d+\.\d+(\.\d+)?)',                                                  # Pattern: Major.Minor[.Patch]                             (1.2 or 1.2.3)
            'v(\d+\.\d+(\.\d+)?)',                                                 # Pattern: vMajor.Minor[.Patch]                            (v1.2 or v1.2.3)
            '(\d+\.\d{1,2}\.\d{1,2}\.\d+)',                                        # Pattern: Major.Minor.Patch.Build                         (1.2.3 or 1.2.3.4)
            'v(\d+\.\d{1,2}\.\d{1,2}\.\d+)',                                       # Pattern: vMajor.Minor.Patch.Build                        (v1.2.3 or v1.2.3.4)
            'v(\d{1,4}(\.\d{1,4}){2,4})',                                          # Pattern: Numeric sequences with variable length          (v1.23.3456 or v1.2.3.4 or v1000.2.3.4.5000)
            '(\d{1,4}(\.\d{1,4}){2,4})',                                           # Pattern: Numeric sequences with variable length          (1.23.3456 or 1.2.3.4 or 1000.2.3.4.5000)
            '(\d{1,4}(\-\d{1,4}){2,4})',                                           # Pattern: Numeric sequences with variable length          (1-23-3456 or 1-2-3-4 or 1000-2-3-4-5000)
            '(\d{1,2}\.\d{1,2}\.\d{2,4}\.\d{1,2}\.\d{1,2}\.\d{1,2})',              # Pattern: Numeric sequences with variable length          (1.2.2022.3.4.5)
            '(\d{1,2}\.\d{1,2}\.\d{2,4}\.\d{1,2}\.\d{1,2})',                       # Pattern: Numeric sequences with variable length          (1.2.2022.3.4)
            '(\d{2,4}-\d{1,2}-\d{1,2}T\d{1,2}:\d{1,2}:\d{1,2}\.\d+Z)',             # Pattern: ISO 8601 date and time format with milliseconds (2022-12-31T12:34:56.789Z)
            '(\d{2,4}-\d{1,2}-\d{1,2}T\d{1,2}:\d{1,2}:\d{1,2}\.\d+)',              # Pattern: ISO 8601 date and time format with milliseconds (2022-12-31T12:34:56.789)
            '(\d{2,4}-\d{1,2}-\d{1,2}T\d{1,2}:\d{1,2}:\d{1,2})',                   # Pattern: ISO 8601 date and time format                   (2022-12-31T12:34:56)
            '(\d{2,4}\.\d{1,2}\.\d{1,2}\.\d{1,2}\.\d{1,2})',                       # Pattern: YYYY.MM.DD.HH.MM.SS date and time format        (2022.12.31.23.45.56)
            '(\d{2,4}-\d{1,2}-\d{1,2}\s+\d{1,2}:\d{1,2}:\d{1,2}\s+[APMapm]{2})',   # Pattern: YYYY-MM-DD HH:MM:SS AM/PM date and time format  (2022-12-31 12:34:56 AM)
            '(\d{1,2}/\d{1,2}/\d{2,4}\s+\d{1,2}:\d{1,2}:\d{1,2}\s+[APMapm]{2})',   # Pattern: MM/DD/YYYY HH:MM:SS AM/PM date and time format  (12/31/2022 12:34:56 AM)
            '(\d{2,4}-\d{1,2}-\d{1,2}\s+\d{1,2}:\d{1,2}:\d{1,2})',                 # Pattern: YYYY-MM-DD HH:MM:SS date and time format        (2022-12-31 12:34:56)
            '(\d{2,4}.\d{1,2}.\d{1,2}\s+\d{1,2}:\d{1,2}:\d{1,2})',                 # Pattern: YYYY-MM-DD HH:MM:SS date and time format        (2022.12.31 12:34:56)
            '(\d{2,4}(\.\d{1,2}){2,4})',                                           # Pattern: YYYY.MM.DD date format with variable length     (2022.12.31 or 2022.12.31.23)
            '(\d{2,4}(\-\d{1,2}){2,4})',                                           # Pattern: YYYY/MM/DD date format with variable length     (2022-12-31 or 2022-12-31-23)
            '(\d{1,2}(\/\d{1,2}){2,4})',                                           # Pattern: MM/DD/YYYY date format with variable length     (12/31/2022 or 31/12/2022)
            '(\d{3,14})'                                                           # Pattern: Date or timestamp                               (12345678901234)
            # Add more patterns as needed
        )

        foreach ($pattern in $versionPatterns) {
            $matches = [regex]::Matches($URI, $pattern)
            if ($matches.Success) {
                return $matches[0].Value
            }
        }
        return $null
    }

    # Analyze the provided URLs
    $filteredUrls = @()

    foreach ($URI in $URIs) {
        $language = "en"       # Default language
        $architecture = "x64"  # Default architecture

        # Try to extract version from the URL
        $version = Get-VersionString -String $URI

        # Assuming a generic pattern for latest version
        $latestVersion = ($URIs | ForEach-Object { Get-VersionString -String $_ } | Sort-Object -Descending | Select-Object -First 1)

        # Filter by language
        if ($FilterLanguage) {
            $languageMatch = [regex]::Match($URI, '/([a-z]{2})-([a-z]+)/i')
            if ($languageMatch.Success) {
                $language = $languageMatch.Groups[1].Value
            }
        }

        # Filter by architecture
        if ($FilterArchitecture) {
            $architectureMatch = [regex]::Match($URI, '/(amd64|64|x64|arm)/i')
            if ($architectureMatch.Success) {
                $architecture = $architectureMatch.Groups[1].Value
            }
        }

        # Filter by latest version
        if ($FilterLatestVersion) {
            $versionFilter = $version -eq $latestVersion
        } else {
            $versionFilter = $true  # No version filtering
        }

        # Check if the URL matches the criteria
        if ($versionFilter) {
            $URIObject = [PSCustomObject]@{
                Url = $URI
                Language = $language
                Architecture = $architecture
                Version = $version
                IsLatestVersion = $version -eq $latestVersion
            }

            $filteredUrls += $URIObject
        }
    }

    return $filteredUrls
}


function Get-AllDownloadUrls {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,  Position = 0, ValueFromPipeline = $true,  ValueFromPipelineByPropertyName = $true)]
        [string]$URI,

        [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $false)]
        [string]$UserAgent
    )
    begin {
        if (-not $UserAgent)     {$userAgent    = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"}
        if (-not $regexFileExt)  {$regexFileExt = '\.zip$|\.exe$'}
    }
    process {
        try {
            $webpageContent = Invoke-WebRequest -URI $URI -UseBasicParsing -Headers @{ "User-Agent" = $UserAgent }
        } catch {
            Write-Error "Failed to retrieve webpage content for URI: $URI. $_"
        }

        $baseURI = $webpageContent.BaseResponse.ResponseUri
        
        $filteredLinks = $webpageContent.Links | Where-Object { $_.href -cmatch $regexFileExt }

        $filteredLinks | ForEach-Object {
            $fileURI = [System.Uri]::new($_.href, [System.UriKind]::RelativeOrAbsolute)

            if (-not $fileURI.IsAbsoluteUri) {
                $fileURI = [System.Uri]::new($baseUri, $fileURI)
            }

            if ($fileURI.IsAbsoluteUri) {
                $fileURI.AbsoluteUri
            } else {
                throw "Invalid URL: $($_.href)"
            }
        }
    }

    end {
    }
}

# Example usage:
$webpageUrls = @(
    "https://www.7-zip.org/download.html",
    "https://itefix.net/cwrsync"
    "https://filezilla-project.org/download.php?show_all=1"
    "https://dbeaver.io/download/"
    "https://www.cpuid.com/softwares/cpu-z.html"
)

$webpageUrls | ForEach-Object {
    $URIs = Get-AllDownloadUrls -URI $_
    Filter-DownloadUrls -DownloadUrls $URIs -FilterLatestVersion
    } 


Filter-DownloadUrls -DownloadUrls $URIs -FilterLanguage
Filter-DownloadUrls -DownloadUrls $URIs -FilterArchitecture
Filter-DownloadUrls -DownloadUrls $URIs -FilterLatestVersion









function Download-rSync {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [String]$Path
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
        Write-Verbose ("{0,-27}{1,-51}{2}" -f "[$($MyInvocation.MyCommand.Name)]", 'Downloading Powershell OpenSSH-Portable', '[START]')
        switch ($env:PROCESSOR_ARCHITECTURE) {
            "x86"   { $Include = 'OpenSSH-Win32.zip' }
            "ARM"   { $Include = 'OpenSSH-ARM.zip'   }
            "ARM64" { $Include = 'OpenSSH-ARM64.zip' }
            "AMD64" { $Include = 'OpenSSH-Win64.zip' }
            default { $Include = 'OpenSSH-Win64.zip' }
        }
        $URI = Get-GitHubRelease -Owner PowerShell -Name Win32-OpenSSH | Where-Object { $_ -like "*$Include*" }
        $File = Split-Path -Path $URI -Leaf
    }
    process {
        if (-not $Path) {$Path = New-TemporaryDirectory}
        try {
            Download-File -Path $Path -URI $URI -Force
            $FullPath = Join-Path -Path $Path -ChildPath $File
            Write-Output $FullPath 
        } catch {
            Write-Error "[$($MyInvocation.MyCommand.Name)] Error occured while downloading OpenSSH: $_"
        }
    }
    end {
        Write-Verbose ("{0,-27}{1,-51}{2}" -f "[$($MyInvocation.MyCommand.Name)]", 'Downloading Powershell OpenSSH-Portable', '[COMPLETE]')
    }
}

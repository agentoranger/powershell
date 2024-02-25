# Get-GitHubRelease.psm1
function Get-GitHubRelease {
    param(
        [Parameter(Mandatory = $true,  Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Owner,

        [Parameter(Mandatory = $true,  Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Name,

        [Parameter(Mandatory = $false, Position = 2, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$URI,

        [Parameter(Mandatory = $false, Position = 3, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$AccessToken
    )
    process {
        try {
            If (-not $URI)         {$URI = "https://api.github.com/repos/$Owner/$Name/releases/latest"}
            If (-not $AccessToken) {$AccessToken='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'}
            If (-not $Headers)     {$Headers = @{'Authorization' = "Bearer $AccessToken"}}

            $ProgressPreference = 'SilentlyContinue'
            $Response = Invoke-RestMethod -Uri $URI -Headers $Headers
            $ProgressPreference = 'Continue'
            $latestRelease = @{
                Name = $Response.name
                TagName = $Response.tag_name
                PublishedAt = $Response.published_at
                Assets = @()
            }
            foreach ($Asset in $Response.Assets) {
                $latestRelease.Assets += @{
                    Name = $Asset.name
                    Size = $Asset.size
                    DownloadUrl = $Asset.browser_download_url
                }
            }
            Write-Verbose ("{0,-27}{1,-16}{2}" -f "[$($MyInvocation.MyCommand.Name)]",'Release Owner:', "$($Owner)")
            Write-Verbose ("{0,-27}{1,-16}{2}" -f "[$($MyInvocation.MyCommand.Name)]",'Release Repo:',  "$($Name)")
            Write-Verbose ("{0,-27}{1,-16}{2}" -f "[$($MyInvocation.MyCommand.Name)]",'Release Name:',  "$($latestRelease.Name)")
            Write-Verbose ("{0,-27}{1,-16}{2}" -f "[$($MyInvocation.MyCommand.Name)]",'Tag Name:',      "$($latestRelease.TagName)")
            Write-Verbose ("{0,-27}{1,-16}{2}" -f "[$($MyInvocation.MyCommand.Name)]",'Publish Date:',  "$($latestRelease.PublishedAt)")
            Write-Verbose ("{0,-27}{1,-16}"    -f "[$($MyInvocation.MyCommand.Name)]",'Release Assets:')
            foreach ($asset in $latestRelease.Assets) {
                Write-Verbose ("{0,-29}- {1}"  -f "[$($MyInvocation.MyCommand.Name)]","$($asset.Name)")
            }   
            ForEach ($Release in $latestRelease.Assets) { 
                Write-Output $Release.DownloadUrl
            }
        } catch {
            Write-Error "[$($MyInvocation.MyCommand.Name)] Error occurred while getting GitHub info: $_"
        }
    }
}
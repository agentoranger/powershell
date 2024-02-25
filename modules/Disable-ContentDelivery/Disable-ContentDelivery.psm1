#Disable-ContentDelivery.psm1
#$VerbosePreference = 'Continue'

function Disable-ContentDelivery {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true,  ValueFromPipelineByPropertyName = $true)]
        [switch]$System,

        [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true,  ValueFromPipelineByPropertyName = $true)]
        [switch]$Default,

        [Parameter(Mandatory = $false, Position = 2, ValueFromPipeline = $true,  ValueFromPipelineByPropertyName = $true)]
        [switch]$Internal,

        [Parameter(Mandatory = $false, Position = 3, ValueFromPipeline = $true,  ValueFromPipelineByPropertyName = $true)]
        [switch]$External
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
        Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Deprovisioning Content Delivery Manager', '[START]')
    }
    process {
        try {
            $userHives = switch ($PsCmdlet.MyInvocation.BoundParameters.Keys) {
                'Default'  { Get-UserRegistryPaths -Default  }
                'System'   { Get-UserRegistryPaths -System   }
                'Internal' { Get-UserRegistryPaths -Internal }
                'External' { Get-UserRegistryPaths -External }
            }
            $CDMPaths = ForEach ($userHive in $userHives) {
                #"$($userHive)\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
                Join-Path -Path $userHive -ChildPath 'Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
            }
            ForEach ($CDMPath in $CDMPaths) {
                $CDMValues = @(
                    @{Path=$CDMPath; Name='ContentDeliveryAllowed';            Type='DWORD'; Value='0'}, # Content Delivery
                    @{Path=$CDMPath; Name='FeatureManagementEnabled';          Type='DWORD'; Value='0'}, # Feature Management
                    @{Path=$CDMPath; Name='OemPreInstalledAppsEnabled';        Type='DWORD'; Value='0'}, # OEM Preinstalled Apps
                    @{Path=$CDMPath; Name='PreInstalledAppsEnabled';           Type='DWORD'; Value='0'}, # Preinstalled Apps
                    @{Path=$CDMPath; Name='PreInstalledAppsEverEnabled';       Type='DWORD'; Value='0'}, # Preinstalled Apps Flag
                    @{Path=$CDMPath; Name='RotatingLockScreenEnabled';         Type='DWORD'; Value='0'}, # Lock Screen Ads
                    @{Path=$CDMPath; Name='RotatingLockScreenOverlayEnabled';  Type='DWORD'; Value='0'}, # Lock Screen Tips
                    @{Path=$CDMPath; Name='SilentInstalledAppsEnabled';        Type='DWORD'; Value='0'}, # Suggested Apps
                    @{Path=$CDMPath; Name='SoftLandingEnabled';                Type='DWORD'; Value='0'}, # Tips about Windows
                    @{Path=$CDMPath; Name='SubscribedContentEnabled';          Type='DWORD'; Value='0'}, # Suggested Apps
                    @{Path=$CDMPath; Name='SystemPaneSuggestionsEnabled';      Type='DWORD'; Value='0'}, # Settings Suggestions
                    @{Path=$CDMPath; Name='SubscribedContent-202913Enabled';   Type='DWORD'; Value='0'}, # SilentInstalledApps
                    @{Path=$CDMPath; Name='SubscribedContent-202914Enabled';   Type='DWORD'; Value='0'}, # SilentInstalledApps
                    @{Path=$CDMPath; Name='SubscribedContent-280797Enabled';   Type='DWORD'; Value='0'}, # SyncProviders OneDriveLocal
                    @{Path=$CDMPath; Name='SubscribedContent-280810Enabled';   Type='DWORD'; Value='0'}, # OneDriveSync
                    @{Path=$CDMPath; Name='SubscribedContent-280811Enabled';   Type='DWORD'; Value='0'}, # SyncProviders OneDriveLocal
                    @{Path=$CDMPath; Name='SubscribedContent-280812Enabled';   Type='DWORD'; Value='0'}, # ApiTest
                    @{Path=$CDMPath; Name='SubscribedContent-280813Enabled';   Type='DWORD'; Value='0'}, # Windows Ink - StokedOnIt
                    @{Path=$CDMPath; Name='SubscribedContent-280814Enabled';   Type='DWORD'; Value='0'}, # Share Facebook Instagram
                    @{Path=$CDMPath; Name='SubscribedContent-280815Enabled';   Type='DWORD'; Value='0'}, # Share Facebook Instagram
                    @{Path=$CDMPath; Name='SubscribedContent-280817Enabled';   Type='DWORD'; Value='0'}, # OneDriveSync
                    @{Path=$CDMPath; Name='SubscribedContent-310091Enabled';   Type='DWORD'; Value='0'}, # ActionCenter
                    @{Path=$CDMPath; Name='SubscribedContent-310092Enabled';   Type='DWORD'; Value='0'}, # ActionCenter
                    @{Path=$CDMPath; Name='SubscribedContent-310093Enabled';   Type='DWORD'; Value='0'}, # MinuteZeroOffers
                    @{Path=$CDMPath; Name='SubscribedContent-310094Enabled';   Type='DWORD'; Value='0'}, # MinuteZeroOffers
                    @{Path=$CDMPath; Name='SubscribedContent-314558Enabled';   Type='DWORD'; Value='0'}, # DynamicLayouts Candy Crush
                    @{Path=$CDMPath; Name='SubscribedContent-314559Enabled';   Type='DWORD'; Value='0'}, # DynamicLayouts Candy Crush
                    @{Path=$CDMPath; Name='SubscribedContent-314562Enabled';   Type='DWORD'; Value='0'}, # PeopleAppSuggestions
                    @{Path=$CDMPath; Name='SubscribedContent-314563Enabled';   Type='DWORD'; Value='0'}, # PeopleAppSuggestions
                    @{Path=$CDMPath; Name='SubscribedContent-314566Enabled';   Type='DWORD'; Value='0'}, # OobeOffers
                    @{Path=$CDMPath; Name='SubscribedContent-314567Enabled';   Type='DWORD'; Value='0'}, # OobeOffers
                    @{Path=$CDMPath; Name='SubscribedContent-338380Enabled';   Type='DWORD'; Value='0'}, # LockScreen Hotspot
                    @{Path=$CDMPath; Name='SubscribedContent-338381Enabled';   Type='DWORD'; Value='0'}, # StartSuggestions
                    @{Path=$CDMPath; Name='SubscribedContent-338382Enabled';   Type='DWORD'; Value='0'}, # WindowsTip
                    @{Path=$CDMPath; Name='SubscribedContent-338386Enabled';   Type='DWORD'; Value='0'}, # Settings
                    @{Path=$CDMPath; Name='SubscribedContent-338387Enabled';   Type='DWORD'; Value='0'}, # LockScreen Hotspot
                    @{Path=$CDMPath; Name='SubscribedContent-338388Enabled';   Type='DWORD'; Value='0'}, # StartSuggestions
                    @{Path=$CDMPath; Name='SubscribedContent-338389Enabled';   Type='DWORD'; Value='0'}, # WindowsTip
                    @{Path=$CDMPath; Name='SubscribedContent-338393Enabled';   Type='DWORD'; Value='0'}, # Settings
                    @{Path=$CDMPath; Name='SubscribedContent-346480Enabled';   Type='DWORD'; Value='0'}, # Signals
                    @{Path=$CDMPath; Name='SubscribedContent-346481Enabled';   Type='DWORD'; Value='0'}, # Signals
                    @{Path=$CDMPath; Name='SubscribedContent-353694Enabled';   Type='DWORD'; Value='0'}, # SettingsAccountsYourInfo
                    @{Path=$CDMPath; Name='SubscribedContent-353695Enabled';   Type='DWORD'; Value='0'}, # SettingsAccountsYourInfo
                    @{Path=$CDMPath; Name='SubscribedContent-353696Enabled';   Type='DWORD'; Value='0'}, # SettingsHome
                    @{Path=$CDMPath; Name='SubscribedContent-353697Enabled';   Type='DWORD'; Value='0'}, # SettingsHome
                    @{Path=$CDMPath; Name='SubscribedContent-353698Enabled';   Type='DWORD'; Value='0'}, # Timeline
                    @{Path=$CDMPath; Name='SubscribedContent-353699Enabled';   Type='DWORD'; Value='0'}, # Timeline
                    @{Path=$CDMPath; Name='SubscribedContent-88000044Enabled'; Type='DWORD'; Value='0'}, # AppDefaultsEdgeEnlightenment
                    @{Path=$CDMPath; Name='SubscribedContent-88000045Enabled'; Type='DWORD'; Value='0'}, # AppDefaultsEdgeEnlightenment
                    @{Path=$CDMPath; Name='SubscribedContent-88000105Enabled'; Type='DWORD'; Value='0'}, # SettingsValueBanner
                    @{Path=$CDMPath; Name='SubscribedContent-88000106Enabled'; Type='DWORD'; Value='0'}, # SettingsValueBanner
                    @{Path=$CDMPath; Name='SubscribedContent-88000161Enabled'; Type='DWORD'; Value='0'}, # OneDriveDocuments
                    @{Path=$CDMPath; Name='SubscribedContent-88000162Enabled'; Type='DWORD'; Value='0'}, # OneDriveDocuments
                    @{Path=$CDMPath; Name='SubscribedContent-88000163Enabled'; Type='DWORD'; Value='0'}, # OneDriveDesktop
                    @{Path=$CDMPath; Name='SubscribedContent-88000164Enabled'; Type='DWORD'; Value='0'}, # OneDriveDesktop
                    @{Path=$CDMPath; Name='SubscribedContent-88000165Enabled'; Type='DWORD'; Value='0'}, # OneDrivePictures
                    @{Path=$CDMPath; Name='SubscribedContent-88000166Enabled'; Type='DWORD'; Value='0'}| # OneDrivePictures
                      ForEach-Object {New-Object System.Object | Add-Member -NotePropertyMembers $_ -PassThru}
                )
                Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Deprovisioning Content Delivery for User with SID', "[$(($CDMPath -split '\\')[2])]")
                $null = $CDMValues | Set-RegistryValue
                $CDMApps = ('CreativeEvents','Health','Subscriptions','SuggestedApps')
                ForEach ($CDMApp in $CDMApps) {
                $CDMAppPath = Join-Path -Path $CDMPath -ChildPath $CDMApp
                if (Test-Path -Path $CDMAppPath){
                    Remove-Item -Path $CDMAppPath -Force -Recurse}
                }
            }
            Write-Host ("{0,-27}{1,-51}{2}" -f $Job, 'Deprovisioning Content Delivery Manager', '[SUCCESS]')
        } catch {
            Write-Error "$Job Error occured while disabling content delivery: $_"
        }
    }
}
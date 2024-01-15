# Get-GitHubRelease.psd1
@{
            RootModule = 'Get-GitHubRelease.psm1'
         ModuleVersion = '1.0.0'
                  GUID = 'eaf1721f-0d9c-4731-8875-599493cdd698'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function returns urls of all releases from a github repository.'
     FunctionsToExport = @('Get-GitHubRelease')
       AliasesToExport = @('gitrelease')
       CmdletsToExport = @('Get-GitHubRelease')
       RequiredModules = @('New-TemporaryDirectory','Download-File')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR') 
}
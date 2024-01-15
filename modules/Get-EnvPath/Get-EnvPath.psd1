#Get-EnvPath.psd1

@{
            RootModule = 'Get-EnvPath.psm1'
         ModuleVersion = '1.0.0'
                  GUID = '2f9718fc-dde5-4975-8aa6-8d62671c0915'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function gets a path from the systems environment variables.'
     FunctionsToExport = @('Get-EnvPath')
       AliasesToExport = @('getenv')
       CmdletsToExport = @('Get-EnvPath')
       RequiredModules = @('Get-GitHubRelease')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR')
}
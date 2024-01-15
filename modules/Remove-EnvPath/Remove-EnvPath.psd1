#Remove-EnvPath.psd1

@{
            RootModule = 'Remove-EnvPath.psm1'
         ModuleVersion = '1.0.0'
                  GUID = 'cc17cbd4-eca2-4c0d-ad4d-5f33742c08e2'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function removes a path from the systems environment variables.'
     FunctionsToExport = @('Remove-EnvPath')
       AliasesToExport = @('removeenv')
       CmdletsToExport = @('Remove-EnvPath')
       RequiredModules = @('Get-GitHubRelease')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR')
}
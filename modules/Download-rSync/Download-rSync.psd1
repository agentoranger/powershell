# Download-rSync.psd1
@{
            RootModule = 'Download-rSync.psm1'
         ModuleVersion = '1.0.0'
                  GUID = 'cbe69c3e-563a-492b-b268-f7edc47de5f4'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function downloads rsync.'
     FunctionsToExport = @('Download-rSync')
       AliasesToExport = @('downloadssh')
       CmdletsToExport = @('Download-rSync')
       RequiredModules = @('Get-GitHubRelease','New-TemporaryDirectory','Download-File')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR')
}
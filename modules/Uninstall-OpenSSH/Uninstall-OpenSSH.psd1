#Uninstall-OpenSSH.psd1

@{
            RootModule = 'Uninstall-OpenSSH.psm1'
         ModuleVersion = '1.0.0'
                  GUID = '2f9718fc-dde5-4975-8aa6-8d62671c0915'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function uninstalls OpenSSH from a windows system.'
     FunctionsToExport = @('Uninstall-OpenSSH')
       AliasesToExport = @('downloadssh')
       CmdletsToExport = @('Uninstall-OpenSSH')
       RequiredModules = @('Get-GitHubRelease')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR')
}
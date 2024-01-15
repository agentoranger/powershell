#Download-OpenSSH.psd1

@{
            RootModule = 'Download-OpenSSH.psm1'
         ModuleVersion = '1.0.0'
                  GUID = '85c11f12-6f49-4484-a19a-1b4116b843ff'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function writes a registry value so you dont have to.'
     FunctionsToExport = @('Download-OpenSSH')
       AliasesToExport = @('downloadssh')
       CmdletsToExport = @('Download-OpenSSH')
       RequiredModules = @('Get-GitHubRelease','New-TemporaryDirectory','Download-File')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR')
}
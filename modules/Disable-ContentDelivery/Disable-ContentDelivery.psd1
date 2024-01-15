#Disable-ContentDelivery.psd1
@{
            RootModule = 'Disable-ContentDelivery.psm1'
         ModuleVersion = '1.0.0'
                  GUID = '6dd485d9-c783-43c5-a2ae-3a3a203709ce'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function disables unsolicited content delivery by setting registry configurations.'
     FunctionsToExport = @('Disable-ContentDelivery')
       AliasesToExport = @('disablecdm')
       CmdletsToExport = @('Disable-ContentDelivery')
       RequiredModules = @('Get-UserRegistryPaths','Set-RegistryValue')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR')
}
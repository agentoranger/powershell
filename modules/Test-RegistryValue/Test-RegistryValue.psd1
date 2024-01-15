#Test-RegistryValue.psd1
@{
            RootModule = 'Test-RegistryValue.psm1'
         ModuleVersion = '1.0.0'
                  GUID = 'e3b1fa75-064e-4aa8-962b-5cf6ccd6d363'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function tests for the presense of a registry value.'
     FunctionsToExport = @('Test-RegistryValue')
       AliasesToExport = @('trv')
       CmdletsToExport = @('Test-RegistryValue')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR')       
}
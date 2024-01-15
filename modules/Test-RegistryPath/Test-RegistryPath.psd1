#Test-RegistryPath.psd1
@{
            RootModule = 'Test-RegistryPath.psm1'
         ModuleVersion = '1.0.0'
                  GUID = 'fe378297-26f2-4819-97b0-f036074c5eb6'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function tests for the presense of a registry path, can create if not exists.'
     FunctionsToExport = @('Test-RegistryPath')
       AliasesToExport = @('trp')
       CmdletsToExport = @('Test-RegistryPath')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR')       
}
#Set-RegistryValue.psd1
@{
            RootModule = 'Set-RegistryValue.psm1'
         ModuleVersion = '1.0.0'
                  GUID = '74592b33-9eee-4ef9-856c-afa103c0e101'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function writes a registry value so you dont have to.'
     FunctionsToExport = @('Set-RegistryValue')
       AliasesToExport = @('setreg')
       CmdletsToExport = @('Set-RegistryValue')
       RequiredModules = @('Test-RegistryPath','Test-RegistryValue')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR')
}
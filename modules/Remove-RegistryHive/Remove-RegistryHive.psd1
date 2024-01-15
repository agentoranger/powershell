#Remove-RegistryHive.psd1
@{
            RootModule = 'Remove-RegistryHive.psm1'
         ModuleVersion = '1.0.0'
                  GUID = '80225f23-6265-493c-88e4-a5889a1de300'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function unloads a registry hive and remove the related $PSDrive.'
     FunctionsToExport = @('Remove-RegistryHive')
       CmdletsToExport = @('Remove-RegistryHive')
       AliasesToExport = @('removehive')
       RequiredModules = @('Remove-Object')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR')       
}
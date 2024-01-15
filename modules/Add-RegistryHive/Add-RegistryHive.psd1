#Add-RegistryHive.psd1
@{
            RootModule = 'Add-RegistryHive.psm1'
         ModuleVersion = '1.0.0'
                  GUID = 'aef57b59-4d11-4709-809f-e6e404f7b914'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function loads an external registry hive and create a $PSDrive.'
     FunctionsToExport = @('Add-RegistryHive')
       AliasesToExport = @('addhive')
       CmdletsToExport = @('Add-RegistryHive')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR') 
}
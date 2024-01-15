#Get-UserRegistryPath.psd1
@{
            RootModule = 'Get-UserRegistryPaths.psm1'
         ModuleVersion = '1.0.0'
                  GUID = 'a8b937ab-4b62-4f60-bfa0-11dc38ab2f31'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function gets the registry paths for all present user hives.'
     FunctionsToExport = @('Get-UserRegistryPaths')
       AliasesToExport = @('getuserhives')
       CmdletsToExport = @('Get-UserRegistryPaths')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR') 
}
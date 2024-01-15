# Unzip-Archive.psd1
@{
            RootModule = 'Unzip-Archive.psm1'
         ModuleVersion = '1.0.0'
                  GUID = 'b8460fc5-ffed-4e93-8056-3ec0e3c825ad'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function unzips and archive and trys to eliminate duplicate leaves in the paths.'
     FunctionsToExport = @('Unzip-Archive')
       AliasesToExport = @('unzip')
       CmdletsToExport = @('Unzip-Archive')
       RequiredModules = @('Get-ScriptPath')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR')
}
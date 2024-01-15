# Import-ADK.psd1
@{
            RootModule = 'Import-ADK.psm1'
         ModuleVersion = '1.0.0'
                  GUID = '2aaf156d-5e2c-49c5-9fd8-eb1558628e37'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function imports the Microsoft ADK PowerShell Modules from either the ADK or the host.'
     FunctionsToExport = @('Import-ADK')
       CmdletsToExport = @('Import-ADK')
       AliasesToExport = @('importadk')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR') 
}
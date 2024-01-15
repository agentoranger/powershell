# Get-ScriptPath.psd1
@{
            RootModule = 'Get-ScriptPath.psm1'
         ModuleVersion = '1.0.0'
                  GUID = 'f7976d16-23ef-4498-8051-27b521149f8f'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function retrieves the current script directory based on the PowerShell environment.'
     FunctionsToExport = @('Get-ScriptPath')
     VariablesToExport = @('ScriptInfo')
       AliasesToExport = @('gsp')
       CmdletsToExport = @('Get-ScriptPath')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR') 
}
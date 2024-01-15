# Get-ScriptPath.psd1

@{
            RootModule = 'Get-ScriptPath.psm1'
         ModuleVersion = '1.0.0'
                  GUID = 'f7976d16-23ef-4498-8051-27b521149f8f'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function retrieves the current script directory based on the PowerShell environment.'
     PowerShellVersion = '5.1'
DotNetFrameworkVersion = '4.5.2'
            ClrVersion = '4.0'
      FormatsToProcess = @('YourModuleName.format.ps1xml')
        TypesToProcess = @('YourModuleName.types.ps1xml')
       RequiredModules = @('RequiredModule1', 'RequiredModule2')
    RequiredAssemblies = @('System.Web')
      ScriptsToProcess = @('Script1.ps1', 'Script2.ps1')
     FunctionsToExport = @('Get-ScriptPath')
     VariablesToExport = @('ScriptPath')
       AliasesToExport = @('gsp')
       CmdletsToExport = @('Get-ScriptPath')
}
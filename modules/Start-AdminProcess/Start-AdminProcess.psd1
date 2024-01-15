# Start-AdminProcess.psd1
@{
            RootModule = 'Start-AdminProcess.psm1'
         ModuleVersion = '1.0.0'
                  GUID = 'b6a8c424-a86c-4d77-803d-c714dffff4af'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function will start a process as administrator.'
     FunctionsToExport = @('Test-Admin','Start-AdminProcess')
     VariablesToExport = @('isAdmin')
       AliasesToExport = @('sudo')
       CmdletsToExport = @('Test-Admin','Start-AdminProcess')
       RequiredModules = @('Get-ScriptPath')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR')
}
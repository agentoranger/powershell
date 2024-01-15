# Start-AdminPowershell.psd1
@{
            RootModule = 'Start-AdminPowershell.psm1'
         ModuleVersion = '1.0.0'
                  GUID = '2a069d62-5466-4940-ae0d-4a4a831ccd47'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function will start PowerShell as administrator and relauch the current script.'
     FunctionsToExport = @('Test-Admin','Start-AdminPowershell','Invoke-AdminPowershell')
       AliasesToExport = @('sudopwsh')
       CmdletsToExport = @('Test-Admin','Start-AdminPowershell','Invoke-AdminPowershell')
       RequiredModules = @('Get-ScriptPath')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR')
}
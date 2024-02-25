#Clear-Symlinks.psd1
@{
            RootModule = 'Clear-Symlinks.psm1'
         ModuleVersion = '1.0.0'
                  GUID = '0b017c7f-adf0-49d2-87c8-58a845528b8d'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function recursively removes symlinks from a given directory.'
     FunctionsToExport = @('Clear-Symlinks')
       AliasesToExport = @('')
       CmdletsToExport = @('Clear-Symlinks')
       RequiredModules = @('Start-AdminPowershell')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR')
}
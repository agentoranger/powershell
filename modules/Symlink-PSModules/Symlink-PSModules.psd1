#Symlink-PSModules.psd1
@{
            RootModule = 'Symlink-PSModules.psm1'
         ModuleVersion = '1.0.0'
                  GUID = '78f6085f-ab62-4569-9357-8d1a35cbb114'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function symlinks powershell modules found at $path into system32.'
     FunctionsToExport = @('Symlink-PSModules')
       AliasesToExport = @('')
       CmdletsToExport = @('Symlink-PSModules')
       RequiredModules = @('Start-AdminPowershell','Invoke-Script')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR')
}
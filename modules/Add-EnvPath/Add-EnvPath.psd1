#Uninstall-OpenSSH.psd1

@{
            RootModule = 'Add-EnvPath.psm1'
         ModuleVersion = '1.0.0'
                  GUID = '2f9718fc-dde5-4975-8aa6-8d62671c0915'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function adds a path to the systems environment variables.'
     FunctionsToExport = @('Add-EnvPath')
       AliasesToExport = @('addenv')
       CmdletsToExport = @('Add-EnvPath')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR')
}
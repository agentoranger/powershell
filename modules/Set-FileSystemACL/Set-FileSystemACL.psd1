# Set-FileSystemACL.psd1
@{
            RootModule = 'Set-FileSystemACL.psm1'
         ModuleVersion = '1.0.0'
                  GUID = 'a5f64c01-3fd6-4295-b042-7300985d1c58'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function resets the ACL on filesystem objects to an empty state.'
     FunctionsToExport = @('Set-FileSystemACL')
       AliasesToExport = @('resetacl')
       CmdletsToExport = @('Set-FileSystemACL')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR') 
}
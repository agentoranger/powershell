#Invoke-Script.psd1
@{
            RootModule = 'Invoke-Script.psm1'
         ModuleVersion = '1.0.0'
                  GUID = '2f5980fb-f4a9-4dc3-904e-bbbf8322b14e'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function invokes scripts of many languages asynchronously'
     FunctionsToExport = @('Invoke-Script','Invoke-Scripts')
       AliasesToExport = @('call')
       CmdletsToExport = @('Invoke-Script','Invoke-Scripts')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR')
}
#Clear-ADKCache.psd1
@{
            RootModule = 'Clear-ADKCache.psm1'
         ModuleVersion = '1.0.0'
                  GUID = '0ac15f99-8ca0-475a-bd27-a1e73fbf8213'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This function clears and disposes of cached ADK resources.'
     FunctionsToExport = @('Clear-ADKCache')
       AliasesToExport = @('clearadkcache')
       CmdletsToExport = @('Clear-ADKCache')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR')
}
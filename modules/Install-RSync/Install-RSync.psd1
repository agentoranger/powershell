# Install-rSync.psd1
@{
            RootModule = 'Install-rSync.psm1'
         ModuleVersion = '1.0.0'
                  GUID = 'a24e7c40-0ae1-4659-adb0-7fbc00baa364'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This module automates the installation, reinstallation, and update of rsync client and server.'
     FunctionsToExport = @('Install-rSync')
       CmdletsToExport = @('Install-rSync')
       RequiredModules = @('Get-ScriptPath','Set-FileSystemACL','Download-OpenSSH','Unzip-Archive','Add-EnvPath')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR') 
}
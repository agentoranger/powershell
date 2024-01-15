# Install-OpenSSH.psd1
@{
            RootModule = 'Install-OpenSSH.psm1'
         ModuleVersion = '1.0.0'
                  GUID = '2aaf156d-5e2c-49c5-9fd8-eb1558628e37'
                Author = 'Brian Orange'
           CompanyName = 'Orange Guru'
             Copyright = 'Copyright (GPL) This program is free software'
           Description = 'This module automates the installation, reinstallation, and update of OpenSSH client and server.'
     FunctionsToExport = @('Install-OpenSSH')
       CmdletsToExport = @('Install-OpenSSH')
       RequiredModules = @('Get-ScriptPath','Set-FileSystemACL','Download-OpenSSH','Unzip-Archive','Add-EnvPath')
  CompatiblePSEditions = @('Desktop', 'Core', 'FullCLR') 
}
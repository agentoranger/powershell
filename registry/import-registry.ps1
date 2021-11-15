Write-Host Escalating Powershell to run as Administrator
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {Start-Process -FilePath powershell.exe -ArgumentList " -NoLogo -MTA -File `"$PSCommandPath `"" -Verb RunAs ; EXIT}

Write-Host Setting Path
$PATH = $global:PSScriptRoot
Set-Location -Path $PATH

Write-Host Getting Registry Files
$REGS = Get-ChildItem -Path $PATH -Include *.REG -Recurse

Write-Host Applying Registry Files
ForEach ($REG in $REGS.FullName) {
  Write-Host Importing Registry File $REG
  Start-Process -FilePath $ENV:windir\system32\reg.exe -ArgumentList IMPORT,$REG -NoNewWindow
}

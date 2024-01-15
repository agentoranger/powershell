# Import-ADK.psm1

function Import-ADK {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [switch]$Force 
    )
    begin {
        $Job = "[$($MyInvocation.MyCommand.Name)]"
        $ADK = "${ENV:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\$env:PROCESSOR_ARCHITECTURE\DISM"
        $DISM = Get-Module -Name DISM -ErrorAction SilentlyContinue
    }
    process {
        try {

            if ($DISM.Path -and $ADK -eq (Split-Path -Path $DISM.Path)) {
                Write-Host ("{0,-27}{1,-51}{2}" -f $Job,'Microsoft ADK Servicing Module is already loaded','[DISM-HOST]')
            } else {
                Write-Host ("{0,-27}{1,-51}{2}" -f $Job,'Importing PowerShell Servicing Modules',"[$($ADK)]")
                If (Test-Path $ADK) {
                    If ($DISM) {
                        Write-Host ("{0,-27}{1,-51}{2}" -f $Job,'Unloading PowerShell Servicing Modules','[DISM-HOST]')
                        Remove-Module -Name DISM -Force
                    }
                    Write-Host ("{0,-27}{1,-51}{2}" -f $Job,'Importing Microsoft ADK Servicing Module','[DISM-MSADK]')
                    Import-Module -Name $ADK -Global -DisableNameChecking -Force
                } Else {
                    If ($DISM) { 
                        Write-Host ("{0,-27}{1,-51}{2}" -f $Job,'Microsoft Windows Servicing Module is already loaded','[DISM-HOST]')
                    } else {
                        Write-Host ("{0,-27}{1,-51}{2}" -f $Job,'Importing Microsoft Windows Servicing Module','[DISM-HOST]')
                        Import-Module -Name DISM -Global -DisableNameChecking -Force
                    }
                }

            }
        } catch {
            Write-Error "[$($MyInvocation.MyCommand.Name)]`tError occured while importing powershell modules: $_"
        }
    }
}

 
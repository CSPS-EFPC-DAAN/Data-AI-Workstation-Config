#requires -version 4
#Requires -RunAsAdministrator

<#
.SYNOPSIS
  Configure Anaconda

.DESCRIPTION
  Updates: pip (python), installs PyHamcrest (python), Anaconda, Anaconda Navigator, pip (Anaconda)
  Adds new channels to Anaconda
  Creates a new environment named Ferret with python 3.7 and R
  Installs: RStudio,vnew python and R packages into Ferret environment
  
.PARAMETER InstallFiles
  Folder where installation files are

.INPUTS
  None

.OUTPUTS Log File
  The script log file stored in $InstallFiles\DigitalAcademy-ConfigAnaconda.log

.NOTES
  Version:        1.0
  Author:         Cory Dignard
  Creation Date:  December 18, 2018
  Purpose/Change: Initial script development

  Version:        2.0
  Author:         Cory Dignard
  Creation Date:  January 13, 2018
  Purpose/Change: Refined code

.EXAMPLE
  C:\DigitalAcademy\InstallFiles\DigitalAcademy-ConfigAnaconda.ps1 -InstallFiles "C:\DigitalAcademy\InstallFiles"
  
#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

Param (
  [Parameter(Mandatory=$true)][string]$InstallFiles
)

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = 'SilentlyContinue'

#Import Modules & Snap-ins
Import-Module PSLogging

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Script Version
$sScriptVersion = '2.0'

#Log File Info
$sLogPath = $InstallFiles
$sLogName = 'DigitalAcademy-ConfigAnaconda.log'
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#-----------------------------------------------------------[Functions]------------------------------------------------------------

Function Write-Message ($message) {
    write-host "`n$message" -ForegroundColor Green;write-host ""
    Write-LogInfo -LogPath $sLogFile -Message "`n$message"

}

Function InstallSoftware ($Msg,$InstallCommands,$Arguments) {

  Begin {
    Write-Message "$Msg"
  }

  Process {
    Try {
      Start-Process "$InstallCommands" -ArgumentList "$Arguments" -Wait -NoNewWindow
    }

    Catch {
      Write-LogError -LogPath $sLogFile -Message $_.Exception -ExitGracefully
      Break
    }
  }

  End {
    If ($?) {
      write-Message "Completed."
    }
  }
}


#-----------------------------------------------------------[Execution]------------------------------------------------------------

Start-Log -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion | Out-Null
Write-Host "";"Log file: $sLogFile";Write-Host ""

InstallSoftware "Updating pip (python)" "python" "-m pip install --upgrade pip"
InstallSoftware "Installing PyHamcrest (python)" "pip" "install PyHamcrest"
InstallSoftware "Updating Anaconda" "conda" "update conda -y"
InstallSoftware "Updating Anaconda Navigator" "conda" "update anaconda-navigator -y"
InstallSoftware "Updating pip (Anaconda)" "conda" "update pip -y"
foreach($_ in Get-Content $InstallFiles\Anaconda-Channels.txt) {
    InstallSoftware "Adding channel $_" "conda" "config --append channels $_"
}

InstallSoftware "Creating environment named Ferret, this will take a while" "conda" "create -n Ferret python=3.7 r-base r-essentials -y"

InstallSoftware "Installing RStudio, this will take a while" "conda" "install -n Ferret -c r rstudio -y"

InstallSoftware "Downloading and installing new packages, this will take a while" "conda" "install -n Ferret --file $InstallFiles\NewPackages.txt -y"

Write-Message "All tasks completed."

Stop-Log -LogPath $sLogFile
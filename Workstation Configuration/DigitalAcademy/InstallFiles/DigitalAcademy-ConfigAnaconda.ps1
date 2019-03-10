#requires -version 4

<#
.SYNOPSIS
  Configure Anaconda

.DESCRIPTION
  Updates: conda-build, pip (python), installs PyHamcrest (python)
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
  Creation Date:  December 18, 2019
  Purpose/Change: Initial script development

  Version:        2.0
  Author:         Cory Dignard
  Creation Date:  January 13, 2019
  Purpose/Change: Refined code

  Version:        3.0
  Author:         Cory Dignard
  Creation Date:  March 10, 2019
  Purpose/Change: Changes based on Anaconda version 2018.12


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
$sScriptVersion = '3.0'

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

InstallSoftware "Updating conda-build" "conda" "update conda-build -y"

InstallSoftware "Updating pip (python)" "python" "-m pip install --upgrade pip"

InstallSoftware "Installing PyHamcrest (python)" "pip" "install PyHamcrest"

foreach($_ in Get-Content $InstallFiles\Anaconda-Channels.txt) {
    InstallSoftware "Adding channel $_" "conda" "config --append channels $_"
}

InstallSoftware "Creating environment named Ferret, this will take a while" "conda" "create -n Ferret python=3.7 r-base r-essentials -y"

InstallSoftware "Installing RStudio, this will take a while" "conda" "install -n Ferret -c r rstudio -y"

InstallSoftware "Downloading and installing new packages, this will take a while" "conda" "install -n Ferret --file $InstallFiles\NewPackages.txt -y"

Write-Message "All tasks completed."

Stop-Log -LogPath $sLogFile
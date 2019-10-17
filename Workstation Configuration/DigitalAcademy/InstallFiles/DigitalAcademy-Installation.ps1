#requires -version 4
#Requires -RunAsAdministrator

<#
.SYNOPSIS
  Installs and configures everything needed for Digital Academy Premium Data & AI courses

.DESCRIPTION
  Sets: Power Plan, Time Zone, Desktop Wallpaper 
  Installs: R, RStudio, sqlite, SQLite Studio, Power BI Desktop, Chrome, Slack Desktop, Github Desktop, Desktop shortcuts 
  Adds Path Environment variables
  Disables Power BI Registration Sceeen

.PARAMETER InstallFiles
  Folder where installation files are
 
.INPUTS
  None

.OUTPUTS Log File
  The script log file stored in $InstallFiles\DigitalAcademy-Installation.log

.NOTES
  Version:        1.0
  Author:         Cory Dignard
  Creation Date:  December 18, 2018
  Purpose/Change: Initial script development

  Version:        2.0
  Author:         Cory Dignard
  Creation Date:  January 13, 2019
  Purpose/Change: Added new requirements and refined code

  Version:        2.1
  Author:         Cory Dignard
  Creation Date:  January 15, 2019
  Purpose/Change: Changed "Disable Slack Updater" to remove reg key instead of change

  Version:        2.2
  Author:         Cory Dignard
  Creation Date:  January 30, 2019
  Purpose/Change: Changed desktop wallpaper image used

  Version:        3.0
  Author:         Cory Dignard
  Creation Date:  March 10, 2019
  Purpose/Change: Changes based on Anaconda version 2018.12

  Version:        3.1
  Author:         Cory Dignard
  Creation Date:  September 17, 2019
  Purpose/Change: Updates for Cohort 2

  Version:        3.2
  Author:         Cory Dignard
  Creation Date:  September 17, 2019
  Purpose/Change: Updated $newPath to fix conda update issue

  Version:        4.0
  Author:         Cory Dignard
  Creation Date:  September 17, 2019
  Purpose/Change: Removed everything related to Anaconda


.EXAMPLE
  C:\DigitalAcademy\InstallFiles\DigitalAcademy-Installation.ps1 -InstallFiles "C:\DigitalAcademy\InstallFiles"
  
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
$sScriptVersion = '4.0'

#Log File Info
$sLogPath = $InstallFiles
$sLogName = 'DigitalAcademy-Installation.log'
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#-----------------------------------------------------------[Functions]------------------------------------------------------------

Function Write-Message ($message) {
    write-host "`n$message" -ForegroundColor Green;write-host ""
    Write-LogInfo -LogPath $sLogFile -Message "`n$message"

}

Function InstallSoftware ($Software,$InstallCommands,$Arguments) {

  Begin {
    Write-Message "Installing $Software"
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

Write-Message "Setting up Power Plan"
powercfg /import "$InstallFiles\PowerPlan.pow"
$HighPerf = powercfg -l | %{if($_.contains("POWER")) {$_.split()[3]}}
powercfg -setactive $HighPerf
Write-Message "Completed"

Write-Message "Set Time Zone"
Set-TimeZone -Id "Eastern Standard Time"
Write-Message "Completed"

Write-Message "Installing Applications"
InstallSoftware "R" "$InstallFiles\R-3.6.1-win.exe" "/VERYSILENT"
InstallSoftware "RStudio" "$InstallFiles\RStudio-1.2.5001.exe" "/S"
InstallSoftware "sqlite" "xcopy" "$InstallFiles\sqlite-tools-win32-x86-3300100 C:\ProgramData\sqlite /I /S /Y /Q"
InstallSoftware "SQLite Studio" "xcopy" "$InstallFiles\SQLiteStudio C:\ProgramData\SQLiteStudio /I /S /Y /Q"
InstallSoftware "PowerBI Desktop" "msiexec.exe" "/i $InstallFiles\PBIDesktopSetup_x64.exe ACCEPT_EULA=1 /q"
InstallSoftware "Chrome" "msiexec" "/i $InstallFiles\GoogleChromeStandaloneEnterprise64.msi /q"
InstallSoftware "Slack" "$InstallFiles\SlackSetup.exe" "/silent"
InstallSoftware "Github" "$InstallFiles\GitHubDesktopSetup" "/silent"
InstallSoftware "Desktop Shortcuts" "xcopy" "$InstallFiles\*.lnk C:\Users\Public\Desktop /Y /Q"
Write-Message "Completed"

Write-Message "Set Desktop Wallpaper"
Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value "$InstallFiles\wallpaper1920x1080.png"
Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name WallpaperStyle -value "6"
rundll32.exe user32.dll, UpdatePerUserSystemParameters
Write-Message "Completed"

Write-Message "Adding paths"
$oldPath = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
$newPath = $oldPath + ";C:\ProgramData\sqlite;C:\ProgramData\SQLiteStudio"
[System.Environment]::SetEnvironmentVariable('Path', $newPath, [System.EnvironmentVariableTarget]::Machine)
Write-Message "Completed"

Write-Message "Disable Power BI Registration Screen"
Set-ItemProperty 'HKCU:\Software\Microsoft\Microsoft Power BI Desktop' -Name ShowLeadGenDialog -Value "0"
rundll32.exe user32.dll, UpdatePerUserSystemParameters
Write-Message "Completed"

Write-Message "All tasks completed."

Stop-Log -LogPath $sLogFile
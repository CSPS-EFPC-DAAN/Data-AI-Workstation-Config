#requires -version 4
#Requires -RunAsAdministrator

<#
.SYNOPSIS
  Installs and configures everything needed for Digital Academy Premium Data & AI courses

.DESCRIPTION
  Sets: Power Plan, Time Zone, Desktop Wallpaper 
  Installs: Anaconda, R, RStudio, sqlite, SQLite Studio, Power BI Desktop, Chrome, Slack Desktop,
  Github Desktop, Desktop shortcuts 
  Adds Path Environment variables 
  Disables Power BI Registration Sceeen, Slack Updater

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
  Creation Date:  January 13, 2018
  Purpose/Change: Added new requirements and refined code

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
$sScriptVersion = '2.0'

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
InstallSoftware "Anaconda" "$InstallFiles\Anaconda3-5.3.1-Windows-x86_64.exe" "/InstallationType=AllUsers /RegisterPython=1 /S"
InstallSoftware "R" "$InstallFiles\R-3.5.1-win.exe" "/VERYSILENT"
InstallSoftware "RStudio" "$InstallFiles\RStudio-1.1.463" "/S"
InstallSoftware "sqlite" "xcopy" "$InstallFiles\sqlite C:\ProgramData\sqlite /I /S /Y /Q"
InstallSoftware "SQLite Studio" "xcopy" "$InstallFiles\SQLiteStudio C:\ProgramData\SQLiteStudio /I /S /Y /Q"
InstallSoftware "PowerBI Desktop" "msiexec.exe" "/i $InstallFiles\PBIDesktop_x64.msi ACCEPT_EULA=1 /q"
InstallSoftware "Chrome" "msiexec" "/i $InstallFiles\GoogleChromeStandaloneEnterprise64.msi /q"
InstallSoftware "Slack" "$InstallFiles\SlackSetup.exe" "/silent"
InstallSoftware "Github" "$InstallFiles\GitHubDesktopSetup" "/silent"
InstallSoftware "Desktop Shortcuts" "xcopy" "$InstallFiles\*.lnk C:\Users\Public\Desktop /Y /Q"
Write-Message "Completed"

Write-Message "Set Desktop Wallpaper"
Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value "$InstallFiles\shutterstock_100185233.jpg"
Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name WallpaperStyle -value "6"
rundll32.exe user32.dll, UpdatePerUserSystemParameters
Write-Message "Completed"

Write-Message "Adding paths"
$oldPath = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
$newPath = $oldPath + ";C:\ProgramData\sqlite;C:\ProgramData\SQLiteStudio;C:\ProgramData\Anaconda3;C:\ProgramData\Anaconda3\Scripts"
[System.Environment]::SetEnvironmentVariable('Path', $newPath, [System.EnvironmentVariableTarget]::Machine)
Write-Message "Completed"

Write-Message "Disable Power BI Registration Screen"
Set-ItemProperty 'HKCU:\Software\Microsoft\Microsoft Power BI Desktop' -Name ShowLeadGenDialog -Value "0"
rundll32.exe user32.dll, UpdatePerUserSystemParameters
Write-Message "Completed"

Write-Message "Disable Slack Updater"
Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run -Name com.squirrel.slack.slack -Value ([byte[]](0x03,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00))
rundll32.exe user32.dll, UpdatePerUserSystemParameters
Write-Message "Completed"

Write-Message "All tasks completed."

Stop-Log -LogPath $sLogFile
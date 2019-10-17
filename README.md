# Workstation Configuration for Data and AI/ML Learning

These configuration files are in support of the Data and AI/ML training courses the **Canada School of Public Service (CSPS) Digital Academy (DA) / École de la fonction publique du Canada (EFPC) Académie du numérique (AN)**, are hosting starting January 31, 2019.

**These instructions and scripts have been updated for Cohort 2 starting November 2019.**

**Acknowledgements**

Script template from [9to5IT/PS_Script_Template_V2_Logs.ps1].
This README.md was created using [dillinger.io]

# Files
* **DigitalAcademy-Installation.ps1**
  * Sets: Power Plan, Time Zone, Desktop Wallpaper 
  * Installs: R, RStudio, sqlite, SQLite Studio, Power BI Desktop, Chrome, Slack Desktop, Github Desktop, Desktop shortcuts 
   * Adds Path Environment variables 
   * Disables Power BI Registration Sceeen
* **Commands.txt** : List of commands I used to do the installs
* **PowerPlan.pow** : Windows Power Plan applied as part of the configuration
* **background.png** : Desktop wallpaper
* ***.lnk** : Desktop shortcuts added

# How to use the scripts
The Powershell scripts were designed on laptops running Windows 10 build 1903.

* Download the following installations files
  * R 3.6.1 - https://cran.rstudio.com/bin/windows/base/
  * RStudio Desktop 1.2.5001 - https://www.rstudio.com/products/rstudio/download/#download\
  * Power BI Desktop 2.74.5619.621 - https://www.microsoft.com/en-us/download/details.aspx?id=58494 or (Microsoft Store) https://powerbi.microsoft.com/en-us/get-started/
  * SQLite 3.30.1, Documentation and Tools - https://www.sqlite.org/index.html
  * SQLite Studio (portable) 3.2.1 - https://sqlitestudio.pl/index.rvt?act=download
  * Chrome Enterprise Bundle - https://cloud.google.com/chrome-enterprise/browser/download/?h1=en
  * Slack Desktop - https://slack.com/downloads/windows
  * Github Desktop - https://desktop.github.com/
* Download and copy files to C:\DigitalAcademy\InstallFiles
  * Extract SQLiteStudio-3.2.1.zip and copy folder SQLiteStudio to C:\DigitalAcademy\InstallFiles
  * Extract sqlite-tools-win32-x86-3300100.zip and copy folder sqlite-tools-win32-x86-3300100 to C:\DigitalAcademy\InstallFiles
  * Extract GoogleChromeEnterpriseBundle64.zip and copy GoogleChromeEnterpriseBundle64\Installers\GoogleChromeStandaloneEnterprise64.msi to C:\DigitalAcademy\InstallFiles
* Open Powershell prompt as administrator
* Set Powershell execution policy to Unrestricted
```sh
Set-ExecutionPolicy Unrestricted
select [A] Yes to All 
```
* Install PSLogging
```sh
Install-Module PSLogging
select [Y] Yes
select [A] Yes to All
```
* Launch installation script
```sh
C:\DigitalAcademy\InstallFiles\DigitalAcademy-Installation.ps1 -InstallFiles "c:\DigitalAcademy\InstallFiles"
```
* Restart workstation once complete
* DONE!

[dillinger.io]: <https://dillinger.io/>
[9to5IT/PS_Script_Template_V2_Logs.ps1]: <https://gist.github.com/9to5IT/d81802b28cfd10ab5d89>

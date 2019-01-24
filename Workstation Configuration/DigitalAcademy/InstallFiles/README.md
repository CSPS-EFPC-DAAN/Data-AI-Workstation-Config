# Workstation Configuration for Data and AI/ML Learning

These configuration files are in support of the Data and AI/ML training courses the **Canada School of Public Service (CSPS) Digital Academy (DA) / École de la fonction publique du Canada (EFPC) Académie du numérique (AN)**, are hosting starting January 31, 2019.

**Acknowledgements**

Script template from [9to5IT/PS_Script_Template_V2_Logs.ps1].
This README.md was created using [dillinger.io]

# Files
* **DigitalAcademy-Installation.ps1**
  * Sets: Power Plan, Time Zone, Desktop Wallpaper 
  * Installs: Anaconda, R, RStudio, sqlite, SQLite Studio, Power BI Desktop, Chrome, Slack Desktop,
   * Github Desktop, Desktop shortcuts 
   * Adds Path Environment variables 
   * Disables Power BI Registration Sceeen, Slack Updater
* **DigitalAcademy-ConfigAnaconda.ps1**
   * Updates: pip (python), installs PyHamcrest (python), Anaconda, Anaconda Navigator, pip (Anaconda)
    * Adds new channels to Anaconda
    * Creates a new environment named Ferret with python 3.7 and R
    * Installs: RStudio,vnew python and R packages into Ferret environment
* **Commands.txt** : List of commands I used to do the installs
* **Anaconda-Channels.txt** : List of Anaconda channels that are addeed as part of the configuration
* **NewPackages.txt** : List of Python/R packages that are installed into a new environment
* **PowerPlan.pow** : Windows Power Plan applied as part of the configuration
* **shutterstock_100185233.jpg** and AI_BigDataScience.jpg (not used) : Desktop wallpapers
* ***.lnk** : Desktop shortcuts added

# How to use the scripts
The Powershell scripts were designed on Surface Pro's running Windows 10 build 1803.

* Download the following installations files
  * Anaconda 5.3.1 Python 3.7 version - https://www.anaconda.com/download/
  * R 3.5.1 - https://cran.rstudio.com/bin/windows/base/
  * RStudio Desktop 1.1.463 - https://www.rstudio.com/products/rstudio/download/#download\
  * Power BI Desktop - (Microsoft Store) https://powerbi.microsoft.com/en-us/get-started/
  * SQLite 3.26.0, Documentation and Tools - https://www.sqlite.org/index.html
  * SQLite Studio (installer) 3.2.1 - https://sqlitestudio.pl/index.rvt?act=download
  * Chrome - https://www.google.com/chrome/
  * Slack Desktop - https://slack.com/downloads/windows
  * Github Desktop - https://desktop.github.com/
* Download and copy files to C:\DigitalAcademy\InstallFiles
* Open Powershell prompt as administrator
* Set Powershell execution policy to Unrestricted
```sh
Set-ExecutionPolicy Unrestricted
select [A] Yes to All 
```
* Install PSLogging
```sh
Install-Module PSLogging
select [A] Yes to All
```
* Launch installation script
```sh
C:\DigitalAcademy\InstallFiles\DigitalAcademy-Installation.ps1 -InstallFiles "c:\DigitalAcademy\InstallFiles"
```
* Restart workstation once complete
* Open Powershell prompt as administrator
* Configure Anaconda
```sh
C:\DigitalAcademy\InstallFiles\DigitalAcademy-ConfigAnaconda.ps1 -InstallFiles"c:\DigitalAcademy\InstallFiles"
```
* Restart workstation once complete
* DONE!

[dillinger.io]: <https://dillinger.io/>
[9to5IT/PS_Script_Template_V2_Logs.ps1]: <https://gist.github.com/9to5IT/d81802b28cfd10ab5d89>

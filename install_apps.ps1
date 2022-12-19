### INSTALL PYTHON 3.11  ### 

### Define variables for Python   ###
$url_python = "https://www.python.org/ftp/python/3.11.1/python-3.11.1-amd64.exe"
$output_python = "C:/temp/python-3.11.1-amd64.exe"
$install_python_log = "C:/temp/Python3.11.1-Install.log"

### Create a local directory called temp  ###
New-Item -ItemType Directory -Force -Path C:/temp

### Force Powershell to use TLS 1.2   ###
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

### Download Python executable ###
Invoke-WebRequest -Uri $url_python -OutFile $output_python

### Install Python application in a quiet mode ###
& $output_python /quiet InstallAllUsers=1 PrependPath=1 Include_test=0 /log "$install_python_log"

#################################################################################################

### INSTALL GIT 2.39 ###

### Define variables   ###
$url_git = "https://github.com/git-for-windows/git/releases/download/v2.39.0.windows.1/Git-2.39.0-64-bit.exe"
$output_git = "C:/temp/Git-2.39.0-64-bit.exe"
$install_git_log = "C:/temp/Git2.39-Install.log"

### Create a local directory called temp  ###
New-Item -ItemType Directory -Force -Path C:/temp

### Force Powershell to use TLS 1.2   ###
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

### Download Git executable ###
Invoke-WebRequest -Uri $url_git -OutFile $output_git

### Install Git application in a quiet mode ###
& $output_git /VERYSILENT /NORESTART /COMPONENTS=icons,icons\desktop,ext,ext\shellhere,ext\guihere,gitlfs,assoc,assoc_sh /LOG="$install_git_log" 



##################################################################################################

### INSTALL OpenSSH Server  ###
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Set Powershell as a default shell for OpenSSH server
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

# Start the sshd service
Start-Service sshd

# Set the startup mode for the OpenSSH to Automatic
Set-Service -Name sshd -StartupType 'Automatic'

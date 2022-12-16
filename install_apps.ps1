### INSTALL OpenSSH Server  ###
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Set Powershell as a default shell for OpenSSH server
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

# Start the sshd service
Start-Service sshd

# Set the startup mode for the OpenSSH to Automatic
Set-Service -Name sshd -StartupType 'Automatic'

################################################################################################

### INSTALL PYTHON 3.11  ### 

### Define variables for Python   ###
$url_python = "https://www.python.org/ftp/python/3.11.1/python-3.11.1-amd64.exe"
$output_python = "C:/temp/python-3.11.1-amd64.exe"

### Create a local directory called temp  ###
New-Item -ItemType Directory -Force -Path C:/temp

### Force Powershell to use TLS 1.2   ###
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

### Download Python executable ###
Invoke-WebRequest -Uri $url_python -OutFile $output_python

### Install Python application in a quiet mode ###
& $output_python /quiet InstallAllUsers=1 PrependPath=1 Include_test=0 

#################################################################################################

### INSTALL VIM 9.0 ###

### Define variables for VIM   ###
$url_vim = "https://github.com/vim/vim-win32-installer/releases/download/v9.0.1047/gvim_9.0.1047_x64_signed.exe"
$output_vim = "C:/temp/gvim_9.0.1047_x64_signed.exe"


### Force Powershell to use TLS 1.2   ###
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

### Download Vim executable ###
Invoke-WebRequest -Uri $url_vim -OutFile $output_vim

### Install Vim application in a quiet mode ###
& $output_vim /S



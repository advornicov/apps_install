# Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Set Powershell as a default shell for OpenSSH server
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

# Start the sshd service
Start-Service sshd

# Set the startup mode for the OpenSSH to Automatic
Set-Service -Name sshd -StartupType 'Automatic'

################################################################################################

### INSTALL PYTHON 3.11  ### 

### Define variables   ###
$url = "https://www.python.org/ftp/python/3.11.1/python-3.11.1-amd64.exe"
$output = "C:/temp/python-3.11.1-amd64.exe"

### Create a local directory called temp  ###
New-Item -ItemType Directory -Force -Path C:/temp

### Force Powershell to use TLS 1.2   ###
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

### Download Python executable ###
Invoke-WebRequest -Uri $url -OutFile $output

### Install Python application in a quiet mode ###
& $output /quiet InstallAllUsers=1 PrependPath=1 Include_test=0 
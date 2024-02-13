###  Create a DATA disk  ### 

# Get the first raw disk
$disk = Get-Disk | Where partitionstyle -eq 'raw' | Select -First 2

# Initialize the disk
Initialize-Disk -Number $disk.Number -PartitionStyle GPT

# Create a new partition
$partition = New-Partition -DiskNumber $disk.Number -UseMaximumSize -AssignDriveLetter

# Format the partition
Format-Volume -Partition $partition -FileSystem NTFS -NewFileSystemLabel "Data" -Confirm:$false


######################################################################################################

### Create a c:\temp directory if it doesn't exist ###

$folderpath = "C:\\temp"

# Check if the directory exists
if (!(Test-Path -Path $folderpath)) {
    # Create the directory
    New-Item -ItemType Directory -Force -Path $folderpath
    Write-Host "Directory $folderpath created." -ForegroundColor Green
} else {
    Write-Host "Directory $folderpath already exists, re-using it." -ForegroundColor Yellow
}

####################################################################################################
### Install SMSS ###

$URL = "https://aka.ms/ssmsfullsetup"
$filepath = "$folderpath\\SSMS-Setup-ENU.exe"

# Download the installer if it doesn't exist
if (!(Test-Path $filepath)) {
    Write-Host "Downloading SQL Server Management Studio..."
    $clnt = New-Object System.Net.WebClient
    $clnt.DownloadFile($url, $filepath)
    Write-Host "SSMS installer download complete" -ForegroundColor Green
} else {
    Write-Host "Located the SQL SSMS Installer binaries, moving on to install..."
}

# Start the SSMS installer
Write-Host "Beginning SSMS installation..." -nonewline
$Parms = " /Install /Quiet /Norestart /Logs $folderpath\\ssms_log.txt"
$Prms = $Parms.Split(" ")
& "$filepath" $Prms | Out-Null

# Check the exit status and redirect output to a file
if ($?) {
    Write-Host "SSMS installation successful" -ForegroundColor Green
    Set-Content -Path "$folderpath\\SSMS_install.log" -Value "SSMS installation successful"
} else {
    Write-Host "SSMS installation failed" -ForegroundColor Red
    Set-Content -Path "$folderpath\\SSMS_install.log" -Value "SSMS installation failed"
}


#######################################################################################################

### Install Sqlpackage  ###

$URL = "https://go.microsoft.com/fwlink/?linkid=2257374"
$filepath = "$folderpath\\sqlpackage.zip"

# Download the installer if it doesn't exist
if (!(Test-Path $filepath)) {
    Write-Host "Downloading Sqlpackage..."
    Invoke-WebRequest -Uri $URL -OutFile $filepath
    Write-Host "Sqlpackage installer download complete" -ForegroundColor Green
} else {
    Write-Host "Located the Sqlpackage Installer binaries, moving on to install..."
}

# Extract the Sqlpackage installer
$extractedFolderPath = "$folderpath\\sqlpackage"
Expand-Archive -Path $filepath -DestinationPath $extractedFolderPath -Force

# Specify the path where Sqlpackage is installed
$sqlpackagePath = "$folderpath\\sqlpackage"  # Adjust this path as needed

# Add the Sqlpackage path to the system-wide environment variable
$existingPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
$updatedPath = "$existingPath;$sqlpackagePath"
[Environment]::SetEnvironmentVariable("Path", $updatedPath, [EnvironmentVariableTarget]::Machine)

# Check the exit status and redirect output to a file
if ($?) {
    Write-Host "Sqlpackage installation successful" -ForegroundColor Green
    Set-Content -Path "$folderpath\\Sqlpackage_install.log" -Value "Sqlpackage installation successful"
} else {
    Write-Host "Sqlpackage installation failed" -ForegroundColor Red
    Set-Content -Path "$folderpath\\Sqlpackage_install.log" -Value "Sqlpackage installation failed"
}



#########################################################################################################

### Install Azcopy ###

$URL = "https://aka.ms/downloadazcopy-v10-windows"
$filepath = "$folderpath\\azcopy.zip"

# Download the installer if it doesn't exist
if (!(Test-Path $filepath)) {
    Write-Host "Downloading AzCopy..."
    Invoke-WebRequest -Uri $URL -OutFile $filepath
    Write-Host "AzCopy installer download complete" -ForegroundColor Green
} else {
    Write-Host "Located the AzCopy Installer binaries, moving on to install..."
}

# Extract the AzCopy installer
$extractedFolderPath = "$folderpath\\azcopy"
Expand-Archive -Path $filepath -DestinationPath $extractedFolderPath -Force

# Get the subfolder name
$subfolder = Get-ChildItem -Path $extractedFolderPath | Where-Object { $_.PSIsContainer } | Select-Object -First 1

# Move the contents of the subfolder to the azcopy directory
Get-ChildItem -Path $subfolder.FullName | Move-Item -Destination $extractedFolderPath

# Remove the subfolder
Remove-Item -Path $subfolder.FullName

# Specify the path where Azcopy is installed
$azcopypackagePath = "$folderpath\\azcopy"  # Adjust this path as needed

# Add the Azcopy path to the system-wide environment variable
$existingPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
$updatedPath = "$existingPath;$azcopypackagePath"
[Environment]::SetEnvironmentVariable("Path", $updatedPath, [EnvironmentVariableTarget]::Machine)

# Check the exit status and redirect output to a file
if ($?) {
    Write-Host "Azcopy installation successful" -ForegroundColor Green
    Set-Content -Path "$folderpath\\Azcopy_install.log" -Value "Azcopy installation successful"
} else {
    Write-Host "Azcopy installation failed" -ForegroundColor Red
    Set-Content -Path "$folderpath\\Azcopy_install.log" -Value "Azcopy installation failed"
}

############################################################################################################

### Install Notepad ++ ###

# Define the download URL and the destination
$notepadppUrl = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.6.2/npp.8.6.2.Installer.x64.exe"
$filepath = "$folderpath\\npp.8.6.2.Installer.x64.exe"

# Download the installer if it doesn't exist
if (!(Test-Path $filepath)) {
    Write-Host "Downloading Notepad++..."
    Invoke-WebRequest -Uri $notepadppUrl -OutFile $filepath
    Write-Host "Notepad++ installer download complete" -ForegroundColor Green
} else {
    Write-Host "Located the Notepad++ Installer binaries, moving on to install..."
}

#Install Notepad++ silently
Start-Process -FilePath "$filepath" -ArgumentList "/S"

# Check the exit status and redirect output to a file
if ($?) {
    Write-Host "Notepad++ installation successful" -ForegroundColor Green
    Set-Content -Path "$folderpath\\notepad_plus_install.log" -Value "Notepad++ installation successful"
} else {
    Write-Host "Notepad++ installation failed" -ForegroundColor Red
    Set-Content -Path "$folderpath\\notepad_plus_install.log" -Value "Notepad++ installation failed"
}





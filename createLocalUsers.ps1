# Ensure the script runs with elevated privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "You do not have Administrator rights to run this script! Please run it as an Administrator."
    exit
}

# Path to the text file containing usernames and passwords
$textFilePath = "./users.txt"

# Read the file line by line
Get-Content $textFilePath | ForEach-Object {
    # Split each line by tab or space to get username and password
    $userParts = $_ -split '\s+'
    $fullUsername = $userParts[0]
    $password = $userParts[1]

    # Check if the username part contains an '@' symbol
    if ($fullUsername -like '*@*') {
        # Extract the part of the username before '@' and remove non-alphanumeric characters
        $username = ($fullUsername -split '@')[0] -replace '[^a-zA-Z0-9]', ''
    } else {
        # If no '@' symbol, assume it's already a plain username and remove non-alphanumeric characters
        $username = $fullUsername -replace '[^a-zA-Z0-9]', ''
    }

    # Log the variables to see what is being processed
    Write-Host "Cleaned Username: $username, Password: *******"

    # Convert plain password to secure string
    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force

    # Define source and destination paths
    $source = "C:\Users\rolan\Variables\SetStartSearchToIcon.ps1"
    $destination = "D:\System\Users\$username\Desktop"

    # Ensure the directory exists before copying
    if (-not (Test-Path -Path $destination)) {
        try {
            New-Item -ItemType Directory -Force -Path $destination -ErrorAction Stop
        } catch {
            Write-Error "Access to the path '$destination' is denied. Error: $_"
            return
        }
    }

    # Use robocopy to copy the file. The /r:0 and /w:0 parameters handle retries immediately
    robocopy $(Split-Path -Parent $source) $destination $(Split-Path -Leaf $source) /r:0 /w:0

    # Check if the command was successful
    if ($LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq 1) {
        Write-Host "File copied successfully to $username"
    } else {
        Write-Host "An error occurred during file copy."
    }

    # Create the local user account
    try {
        New-LocalUser -Name "$username" -Password $securePassword -PasswordNeverExpires -AccountNeverExpires -ErrorAction Stop
        Write-Host "Successfully created user: $username"
        
        net localgroup "Remote Desktop Users" "$username" /add
        Write-Host "Remote Desktop Users added to allow list: $username"

    } catch {
        Write-Error "Failed to create user $username. Error: $_"
    }    
}

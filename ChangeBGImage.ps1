# Define the new background image path
$newBackgroundImagePath = "C:\Users\Public\Pictures\NAILS-cosmetics-4k.jpg"

# Step 1: Change the background for all current users
# Get all user profiles
$userProfiles = Get-WmiObject -Class Win32_UserProfile | Where-Object { $_.Special -eq $false }

# Registry path for the default user profile
# $regPath = "HKU\.DEFAULT\Control Panel\Desktop"

# Use PowerShell to load the registry hive if not already available
if (-not (Test-Path $regPath)) {
    # New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS
}



foreach ($user in $userProfiles) {
    $sid = $user.SID
    $regPath = "HKU:\$sid\Control Panel\Desktop"
    # Set-ItemProperty -Path $regPath -Name "Wallpaper" -Value $newBackgroundImagePath
    # Set the wallpaper for the default user profile
    Set-ItemProperty -Path $regPath -Name "Wallpaper" -Value $newBackgroundImagePath
    # Optional: Force the update without a logoff or restart (may not work in all cases)
    # Invoke-Expression -Command "RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters"
}

# Step 2: Replace the default background image used by the system for new users
# Note: This requires administrative privileges and modifying system files, proceed with caution

# Default Windows 10/11 background location (adjust if necessary for your version)
# $defaultBackgroundPath = "C:\Windows\Web\Wallpaper\Windows\img0.jpg"

# Backup the original background image
# Copy-Item -Path $defaultBackgroundPath -Destination "${defaultBackgroundPath}.bak" -Force

# Replace the default background image
# Copy-Item -Path $newBackgroundImagePath -Destination $defaultBackgroundPath -Force

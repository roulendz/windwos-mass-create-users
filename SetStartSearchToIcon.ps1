# Script to set taskbar search to "Search icon only"
$currentUsername = $env:USERNAME
Write-Host "The current username is: $currentUsername"

# Registry path for the current user's taskbar settings
$regPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"

# Set apps to dark theme
# Switch to light theme and back to dark to force refresh
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 1
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 1
Start-Sleep -Seconds 2 # Wait for 2 seconds
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 0


Write-Host "Dark Theme SET!"

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

# Define constants
$SPI_SETDESKWALLPAPER = 20
$SPIF_UPDATEINIFILE = 0x01
$SPIF_SENDCHANGE = 0x02

# The path to the wallpaper image file
$wallpaperPath = "C:\Users\Public\Pictures\NAILS-cosmetics-4k.jpg"

# Set the wallpaper
[Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $wallpaperPath, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)

# Check if the registry path exists
if (Test-Path $regPath) {
    # Set the taskbar search to show search icon only
    Set-ItemProperty -Path $regPath -Name "SearchboxTaskbarMode" -Value 1
    Write-Host "Search bar updated!"
} else {
    Write-Host "Registry path does not exist for the current user."
}
# Determine if the script is running on a 32-bit or 64-bit system
if ([Environment]::Is64BitProcess) {
    $oneDriveSetupPath = "D:\System\Users\$currentUsername\AppData\Local\Microsoft\OneDrive\Update\OneDriveSetup.exe"
} else {
    $oneDriveSetupPath = "D:\System\Users\$currentUsername\AppData\Local\Microsoft\OneDrive\Update\OneDriveSetup.exe"
}

# Check if the OneDrive setup executable exists
if (Test-Path $oneDriveSetupPath) {
    # Uninstall OneDrive for the current user
    Start-Process -FilePath $oneDriveSetupPath -ArgumentList "/uninstall" -NoNewWindow -Wait
    Write-Host "OneDrive has been uninstalled for the current user."
} else {
    Write-Host "OneDrive setup executable not found."
}

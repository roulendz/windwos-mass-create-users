# Disable Location Services
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny"

# Disable Inking & Typing Personalization
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Value 1 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Value 1 -Type DWord

# Disable Tailored Experiences with Diagnostic Data
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 0 -Type DWord

# Disable apps from using the advertising ID for all users
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0 -Type DWord

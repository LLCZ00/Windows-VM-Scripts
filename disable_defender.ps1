<############################################################# 
# Disable Windows Defender and Firewall, for the purposes
# of malware analysis.
# 
# "If do right, no can defense."
#      - Mr. Miyagi
# (Must run as administrator)
#
# Version: 1.0
# Author: LLCZ00
##############################################################
#>

# Ensure script is running as admin 
# (I stole this from: https://superuser.com/questions/108207/how-to-run-a-powershell-script-as-administrator)
param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

# Function for printing new status of firewall/antivirus settings (upon success)
function success_msg 
{
    param (
        $SETTING,
        $STATUS
    )
    Write-Host "[OK] " -NoNewline -ForegroundColor Green
    Write-Host "$($SETTING): " -NoNewline

    if ($STATUS) { Write-Host "enabled" -ForegroundColor Cyan }
    else { Write-Host "disabled" -ForegroundColor Yellow }   
}


<#
# Enable/Disable all Windows Firewall Profiles
# - Powershell spits out a fat error if it fails, so I'm not doing anything extra to handle it
#>
Get-NetFirewallProfile | ForEach-Object {

    if ($_.Enabled) # Disable if enabled, and vice versa
    {
        Set-NetFirewallProfile -Profile $_.Name -Enabled False
        if ($?) { success_msg "$($_.Name) firewall" $false }
    }
    else
    {
        Set-NetFirewallProfile -Profile $_.Name -Enabled True
        if ($?) { success_msg "$($_.Name) firewall" $true }
    }
}


<#
# Enable/Disable Windows Defender
# - If it's on, turn it off (and vice versa)
#>
$DEFENDER = Get-MpPreference # MSFT_MpPrefence class

Set-MpPreference -DisableRealtimeMonitoring ([System.Convert]::ToBoolean(!$DEFENDER.DisableRealtimeMonitoring))
if ($?) { success_msg "Realtime Monitoring" $DEFENDER.DisableRealtimeMonitoring }

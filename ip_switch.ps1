<############################################################# 
# Switch between Bridged Adapter and Internal Network settings
# for Windows 10 virtual machines
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

# Adapter Index (identifier)
$INDEX = (Get-NetAdapter).ifIndex
# Internal network variables (change as needed)
$IP = "10.10.10.100"
$PREFIX = 24
$GATEWAY = "10.10.10.1"
$DNS = "10.10.10.1"


if ((Get-NetIPInterface -InterfaceIndex $index -AddressFamily IPv4).Dhcp -eq "Enabled")
{
    New-NetIPAddress -InterfaceIndex $INDEX -AddressFamily IPv4 -IPAddress $IP -PrefixLength $PREFIX -DefaultGateway $GATEWAY
    Set-DnsClientServerAddress -InterfaceIndex $INDEX -ServerAddresses $DNS

    Write-Host "DHCP Disabled."
    Write-Host "IP Address: $IP/$PREFIX"
    Write-Host "Default Gateway:"$GATEWAY
    Write-Host "Preffered DNS:"$DNS
    Write-Host "(Switch VM Settings to 'Internal' for changes to take effect)"

}
else
{
    Remove-NetIPAddress -InterfaceIndex $INDEX -AddressFamily IPv4 -IPAddress $IP -DefaultGateway $GATEWAY
    Set-DnsClientServerAddress -InterfaceIndex $INDEX -ResetServerAddresses
    Set-NetIPInterface -InterfaceIndex $INDEX -Dhcp Enabled

    Write-Host "DHCP Enabled.`n(Switch VM settings to 'Bridged Adapter' for changes to take effect)"
}

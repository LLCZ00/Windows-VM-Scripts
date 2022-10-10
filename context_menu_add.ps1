<############################################################# 
# Add shortcuts to Windows context menu (right click) 
# Version: 1.0
# Author: LLCZ00
#############################################################
- Open powershell in currect directory
- Open cmd.exe in current directory

WIP, may add to other script
#>

# Ensure script is running as admin
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

# "Registry::Path\Desired Shortcut Name" = "Program.exe -cmd -args"
$menu_shortcuts = @{
    "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\Open Powershell here..." = "powershell.exe -noexit -command Set-Location -literalPath '%V'"
    "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\Open cmd.exe here..." = 'cmd.exe /s /k pushd "%V"'
}

foreach($shortcut in $menu_shortcuts.keys)
{
    $cmdpath = "$shortcut\command"
    New-Item -Path $shortcut
    New-Item -Path $cmdpath
    New-ItemProperty -Path $cmdpath -Name "(Default)" -Value $menu_shortcuts[$shortcut]
}

<# Successful exit #>
Write-Host "`n[DONE] " -NoNewline -ForegroundColor Green
Write-Host "Context menu items added."

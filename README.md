# Setup/QoL Scripts for Windows Virutal Machines
Powershell scripts for facilitating the quick start up of malware analysis environments on Windows 10 virtual machines.<br/>
WIP
## get_tools.ps1
Downloads and installs typical malware analysis tools:<br/>
- 7-Zip
- PEStudio
- ExplorerSuite (CFF Explorer)
- Sysinternals
- IDA Pro (Free)
- Python 3.10
- Notepad++
Setup executables are run (Wizard takes over), and archive files are unzipped to the desktop for easy access. <br/>
Tools are downloaded to *C:\Users\Username\Desktop\ToolDownloads*, by default.
### Issues & TODO
- Tools to add:
  - x64DBG
  - DIE Engine (Detect-it-easy)
  - Wireshark
  - Ghidra (maybe, I'll have to install java too)
- The biggest issue, currently, is downloading tools from sources/URLs that change with updates. Hence, the previous list of tools to add.
- Keeping tools up to date without hardcoding links (see: previous bullet)
- Download tools concurrently, to speed things up
## disable_defender.ps1
Disables Windows Defender and Firewall, security settings that often get in the way of malware analysis. It just switches them on or off, so running the script again will reenable them.<br/>
*(Requires admin privliges)*
### Issues & TODO
- I only disabled *RealtimeMonitoring* from, because I'm unsure if anything else is required. Time will tell if this needs to be fixed.
- Disable/enable firewall and Defender independantly
- Settings may revert upon restart of the VM
## ip_switch.ps1
Switches the IP configuration between "bridged adapter" and "internal" modes. Its purpose is for isolating the environment for dynamic analysis, and being able to quickly switch back to regular internet connectivity as needed.<br/>
*(Requires admin privliges)*
### Issues & TODO
- A way to change the defaults besides just going in the script and changing them (maybe)
- Currently no error handling

<############################################################# 
# Download and install malware analysis tools for windows 10 
# Version: 1.0
# Author: LLCZ00
##############################################################
Includes:
- 7zip
- pestudio
- idapro (free)
- sysinternals
- ExplorerSuite (CFF Explorer)
- Python 3.10
- Notepad++
- Resource Hacker
- dnSpy (64-bit)

Tools I use, but have to be installed manually:
- Ghidra
	- Whatever JDK it requires
- Detect It Easy
- CAPA (Mandiant)
- FLOSS (Mandiant)
- Visual Studio
- de4dot
- Firefox
- Wireshark
#>

# Tool URLs 
$URLS =
'https://www.7-zip.org/a/7z2201-x64.exe',
'https://www.winitor.com/tools/pestudio/current/pestudio.zip',
'https://out7.hex-rays.com/files/idafree82_windows.exe',
'https://download.sysinternals.com/files/SysinternalsSuite.zip',
'https://ntcore.com/files/ExplorerSuite.exe',
'https://www.python.org/ftp/python/3.11.1/python-3.11.1-amd64.exe',
'https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.4.8/npp.8.4.8.Installer.x64.exe',
'http://www.angusj.com/resourcehacker/reshacker_setup.exe',
'https://github.com/dnSpy/dnSpy/releases/download/v6.1.8/dnSpy-net-win64.zip'

$TOOLPATH = "$([System.Environment]::GetFolderPath('Desktop'))\ToolDownloads" # Tool directory
$7ZIP = "$env:ProgramFiles\7-Zip\7z.exe" # Path to 7-Zip (REQUIRED)

<# Create Tools directory (if nonexistant) #>
if (-Not (Test-Path $TOOLPATH -PathType Container))
{
    New-Item -Path $TOOLPATH -ItemType Directory
    Write-Host "`n[OK] " -NoNewline -ForegroundColor Green
    Write-Host "Tool directory created: "$TOOLPATH"`n"
}
Set-Location -Path $TOOLPATH # change working directory to Tools folder


Write-Host "~ Downloading Tools ~" -ForegroundColor Cyan
foreach ($LINK in $URLS) 
{
    $NAME = ($LINK -split "/")[-1]
    Write-Host "[*] " -NoNewline -ForegroundColor Yellow
    Write-Host "Downloading"$NAME"... " -NoNewline
    if (-Not (Test-Path $NAME)) 
    {        
        try {Invoke-WebRequest -Uri $LINK -OutFile $NAME}
        catch
        {
            Write-Host "failure`n" -ForegroundColor Red
            Continue 
        }
        Write-Host "success" -ForegroundColor Green     
    }
    else {Write-Host "no download required" -ForegroundColor Green}
}


Write-Host "`n~ Running Setup Executables ~" -ForegroundColor Cyan
foreach ($EXE in Get-ChildItem -Path $TOOLPATH\* -Name -Include *.exe)
{
    Write-Host "[*] " -NoNewline -ForegroundColor Yellow
    Write-Host "Installing"$EXE"..." -NoNewline

    try {Start-Process -FilePath $EXE -Wait}
    catch
    {
        Write-Host "failure" -ForegroundColor Red 
        Continue
    }
    Write-Host "success" -ForegroundColor Green
}


Write-Host "`n~ Unzipping Archives ~" -ForegroundColor Cyan # (7-Zip required)
foreach ($ARCHIVE in Get-ChildItem -Path $TOOLPATH\* -Name -Include ('*.zip', '*.7z'))
{
    $NAME = ($ARCHIVE -split "\.")[0]
    Write-Host "[*] " -NoNewline -ForegroundColor Yellow
    Write-Host "Unzipping"$ARCHIVE"..." -NoNewline
    
    try {Start-Process -FilePath $7ZIP -ArgumentList "x",$ARCHIVE,"-o$TOOLPATH\..\$NAME","*" -Wait} 
    catch
    {
        Write-Host "failure" -ForegroundColor Red
        Continue
    }
    Write-Host "success" -ForegroundColor Green    
}

<# Successful exit #>
Write-Host "`n[DONE] " -NoNewline -ForegroundColor Green
Write-Host "Tool installation complete."

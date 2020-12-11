#profile.ps1
#nov-02-2020
#AlanKJOhn



#PowerLine setup

#fonts supporting poerline have to be specified in the emulator

Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Avit
#Write-Host "Get-Member"
#####################################################################

function fortune() {
    [System.IO.File]::ReadAllText((Split-Path $profile)+'.\strings\fortune.txt') -replace "`r`n", "`n" -split "`n%`n" | Get-Random
}

Function Unicode {
    Begin {
        $output=[System.Text.StringBuilder]::new()
    }
    Process {
        $output.Append($(
            if ($_ -is [int]) { [char]::ConvertFromUtf32($_) }
            else { [string]$_ }
        )) | Out-Null
    }
    End { $output.ToString() }
}

Clear-Host
#Ⓜ〽
# 303d
# 24c2

#$emojiText = 'M',[char]::ConvertFromUtf32(0x1F4B2),' PowerShell ',[char]::ConvertFromUtf32(0x23f0),' [',$(Get-Date).Hour,':',$(Get-Date).Minute,"-",$(Get-Date).Second,"] "
#$emojiText = [char]::ConvertFromUtf32(0x303d),[char]::ConvertFromUtf32(0x1F4B2),"PowerShell ",[char]::ConvertFromUtf32(0x1f4c6),$(Get-Date)
$emojiText = "M$","PowerShell ",[char]::ConvertFromUtf32(0x1f4c6),$(Get-Date)
Write-Host $emojiText -ForegroundColor DarkYellow

Write-Host ""
Write-Host (fortune) -ForegroundColor DarkGray
#####################################################################

# CPU temperature taken from MSACPI (run command as admin)
# Thanks https://gist.github.com/jeffa00/9577816
function Get-Temperature() {
    $currentTemp = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi"
    $returnTemp = @()
    foreach ($temp in $currentTemp.CurrentTemperature) {
        $currentTempCelsius = [convert]::ToInt32($temp / 10 - 273.15)
        $returnTemp += $currentTempCelsius.toString() + "C"
    }
    return $returnTemp
}
#####################################################################

# Determine if PowerShell launched with admin priveleges
# Thanks https://stackoverflow.com/questions/9999963/powershell-test-admin-rights-within-powershell-script#10000292
function Test-IsAdmin() {
    try {
        $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal -ArgumentList $identity
        return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    } catch {
        throw "Failed to determine if the current user has elevated privileges. The error was: '{0}'." -f $_
    }
}
#####################################################################

# Ovverides default `prompt` function which is called
# every time you see PowerShell command line invitation
#function prompt() {
#    Write-Host -NoNewLine -ForegroundColor Cyan (Get-Location)
#    foreach ($entry in (Get-Location -Stack)) {
#        Write-Host -NoNewLine -ForegroundColor Green '+'
#    }
#    if (Test-IsAdmin) {
#        Write-Host -NoNewLine -ForegroundColor Red  '$#'; ' '
#    }
#    else {
#        Write-Host -NoNewLine -ForegroundColor Cyan '$>'; ' '
#    }
#}
#####################################################################

# Custom PowerShell greeting and window title
#$ui = (Get-Host).UI.RawUI
#If (Test-IsAdmin) {
#    $ui.WindowTitle = "Administrator: MS PowerShell"
#} else {
#    $ui.WindowTitle = "MS PowerShell"
#}
#Write-Host 'PowerShell' $PsVersionTable.PSVersion '-' (Get-Date)
#Write-Host ''
#Write-Host (fortune)
#Write-Host ''
#Write-Host ''


# Remove beep
Set-PSReadlineOption -BellStyle None

# Close terminal on EOF
Set-PSReadlineKeyHandler -Chord 'Ctrl+D' -ScriptBlock { Stop-Process -Id $PID }
#####################################################################
#####################################################################
#####################################################################
#####################################################################

#set random powerline theme
<#
    $themes = Get-ChildItem -Path "C:\Users\alanj\Documents\WindowsPowerShell\Modules\oh-my-posh\2.0.487\Themes\" -Filter *.psm1
    $randumNumber = Get-Random -Maximum $themes.Length
    #Set-Theme $themes[$(Get-Random -Maximum $($themes.Length))].BaseName
    Set-Theme $themes[$randumNumber].BaseName
    Write-Host ""
    Write-Host "Theme - " -NoNewline
    Write-Host $themes[$randumNumber].BaseName -NoNewline
    Write-Host ""
    Write-Host ""
#>

#####################################################################

#setting starting location

#set-location g:\work\temp\work\
#####################################################################

#Setting shell window title

#$Shell.WindowTitle="spaceBoo"
#####################################################################

#Change the window size and scrollback with the following:

#$Shell = $Host.UI.RawUI
#$size = $Shell.WindowSize
#$size.width=70
#$size.height=25
#$Shell.WindowSize = $size
#$size = $Shell.BufferSize
#$size.width=70
#$size.height=5000
#$Shell.BufferSize = $size
#$shell.BackgroundColor = "Gray"
#$shell.ForegroundColor = "Black"
#####################################################################

# dracula prompt config
# Dracula readline configuration. Requires version 2.0, if you have 1.2 convert to `Set-PSReadlineOption -TokenType`
#Set-PSReadlineOption -Color @{
#    "Command" = [ConsoleColor]::Green
#    "Parameter" = [ConsoleColor]::Gray
#    "Operator" = [ConsoleColor]::Magenta
#    "Variable" = [ConsoleColor]::White
#    "String" = [ConsoleColor]::Yellow
#    "Number" = [ConsoleColor]::Blue
#    "Type" = [ConsoleColor]::Cyan
#    "Comment" = [ConsoleColor]::DarkCyan
#}
## Dracula Prompt Configuration
#Import-Module posh-git
#$GitPromptSettings.DefaultPromptPrefix.Text = "$([char]0x2192) " # arrow unicode symbol
#$GitPromptSettings.DefaultPromptPrefix.ForegroundColor = [ConsoleColor]::Green
#$GitPromptSettings.DefaultPromptPath.ForegroundColor =[ConsoleColor]::Cyan
#$GitPromptSettings.DefaultPromptSuffix.Text = "$([char]0x203A) " # chevron unicode symbol
#$GitPromptSettings.DefaultPromptSuffix.ForegroundColor = [ConsoleColor]::Magenta
## Dracula Git Status Configuration
#$GitPromptSettings.BeforeStatus.ForegroundColor = [ConsoleColor]::Blue
#$GitPromptSettings.BranchColor.ForegroundColor = [ConsoleColor]::Blue
#$GitPromptSettings.AfterStatus.ForegroundColor = [ConsoleColor]::Blue
#####################################################################

#Clear Screen

#Clear-Host
#####################################################################

# functions
function gitStatus () {
    git status
}
function gitAddAll () {
    git add -A
}

function gitPushRemoteOriginTAG () {
    git push remote origin --tags
}

function gitCommit ([string]$message) {
    git commit -m "$message"
}

function makeAndChange ([Parameter(Mandatory = $true)][string]$path) {
    New-Item -ItemType "directory" -Path ".\$path"
    Set-Location -Path ".\$path"
}

function moveUpDir () {
    set-location -Path "..\"
}

function openVSCode () {
    code .
}

function unzipAll () {
    #extract all subfolders into an output folder
    $dirs = Get-ChildItem *.zip
    Write-Host "extracting $($dirs.length) items"
    New-Item -ItemType "directory" -Path ".\outputs"
    foreach ($dir in $dirs) {
        Expand-Archive $dir -DestinationPath ".\outputs"
    }
    Set-Location ".\outputs"
    Get-ChildItem
}

function changToCust {
    set-location g:\work\temp\work\customer_app\
}
function changToBuild {
    set-location .\build\app\outputs\flutter-apk\
}
function changToReleaase {
    set-location .\build\app\outputs\bundle\release\
}

function scriptsFolder () {
    Set-Location "C:\Users\alanj\Documents\WindowsPowerShell\"
}

function randomtheme {
    $themes = Get-ChildItem -Path "C:\Users\alanj\Documents\WindowsPowerShell\Modules\oh-my-posh\2.0.487\Themes\" -Filter *.psm1
    $randumNumber = Get-Random -Maximum $themes.Length
    #Set-Theme $themes[$(Get-Random -Maximum $($themes.Length))].BaseName
    Set-Theme $themes[$randumNumber].BaseName
    Write-Host ""
    Write-Host "Theme - " -NoNewline
    Write-Host $themes[$randumNumber].BaseName -NoNewline
    Write-Host ""
}

function flutterBuildAPK {
    Write-Host "FBA - SPA"
    flutter build apk --split-per-abi
}
function flutterBundleRelease {
    Write-Host "FBA - SPA"
    flutter build appbundle
}
#####################################################################

#git aliases
Set-Alias gs gitStatus
Set-Alias ga gitAddAll
Set-Alias gitp gitPushRemoteOriginTAG
Set-Alias cm gitCommit
Set-Alias msc scriptsFolder
Set-Alias unzipa unzipAll
Set-Alias mkcdir makeAndChange
Set-Alias c openVSCode
Set-Alias cdd moveUpDir
Set-Alias cdc changToCust
Set-Alias cdb changToBuild
Set-Alias cdr changToReleaase
Set-Alias randomtheme randomtheme
Set-Alias fbaspa flutterBuildAPK
Set-Alias fbundle flutterBundleRelease
Set-Alias pax C:\Users\alanj\Documents\WindowsPowerShell\myscripts\pushBuildExit.ps1

#####################################################################


<#
#download files with link
# Download the file
$zipFile = "https://drive.google.com/uc?export=download&id=1cwwPzYjIzzzzzzzzzzzzzzzzzzzzzzzz"
Invoke-WebRequest -Uri $zipFile -OutFile "$($env:TEMP)\myFile.doc"
#>


<#
(Get-Content -Path .\LineNumbers.txt -TotalCount 25)[-1]
#>



#####################################################################
#####################################################################
#####################################################################
#####################################################################
#####################################################################
#####################################################################
#####################################################################
#####################################################################
#####################################################################



#EXAMPLES


# Chocolatey profile
#$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
#if (Test-Path($ChocolateyProfile)) {
#  Import-Module "$ChocolateyProfile"
#}

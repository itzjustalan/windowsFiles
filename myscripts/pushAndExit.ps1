# todo
# read version number from the main release note and prepare version numbers and minor release notes

# root folder
$projDir = "G:\work\temp\work\"

#folder to store the build apks
$apksDir = "apks\"

# folders to run the script in
$projectApps = 
    [string]"customer_app",
    [string]"sales_app",
    [string]"delivery_app"

$version = ""

#running the script in all folders one by one
foreach ($appDir in $projectApps) {

    # goin into the folder
    Set-Location $projDir$appDir

    Write-Host "$projDir$appDir"

    # getting the version number
    $lines = Get-Content -Path .\pubspec.yaml
    $version = $lines[17].Remove(0,9);

    Write-Host "version number found - $version"
    
    # change version to match in the login module
    # File to change
    $file = "$projDir$appDir\lib\core\authentication.dart"
    
    # Get file content and store it into $content variable
    $content = Get-Content -Path $file
    
    # preparing it for the dart file
    $content[8] = "  String version = '$version';//MUST BE ON LINE 9"
    
    # change the line containing the version code
    $content | Set-Content -Path $file

    Write-Host "version number modified for authentication"

    # updating version control
    Write-Host "updating version control.." -ForegroundColor Green
    
    git status
    git add -A;
    git commit -m "auto test $version"
    #git status
    Write-Host "pushing latest updates to remote repository.." -ForegroundColor Green
    git push --all origin

    # building apks
    #Set-Location $projDir$appDir
    Write-Host "building apk (--split-per-abi).."
    #Write-Host $projDir$appDir
    flutter build apk --split-per-abi
    New-Item -ItemType "directory" -Path "$projDir$apksDir$version" -Force
    Copy-Item -Path ".\build\app\outputs\flutter-apk\app-armeabi-v7a-release.apk" -Destination "$projDir$apksDir$version\" -Force | Out-Null
    Set-Location "$projDir$apksDir$version"
    Move-Item -Path ".\app-armeabi-v7a-release.apk" -Destination ".\$appDir-v$version.apk" -Force | Out-Null
    Write-Host "$appDir-$version.apk is ready for deployment at $apksDir$version\" -ForegroundColor Green
    Write-Host ""
    
}

# gh release create v1.2.3 '/path/to/asset.zip#My display label'

#send folder contents(apks) to mailing list
Set-Location "$projDir$apksDir$version"
[array]$list = Get-ChildItem *.apk
#Write-Host $list
#Write-Host $list.Length

# upload to github
#must have github cli installed and authenticated for this to work
$releaseLink = gh release create $version -t "Apk release v$version" $list.Name

# send mail
$subject = "Latest Apps Update v$version"
$body = "get your copy at $releaseLink"
$attachment = Get-ChildItem releaseNotes.txt

#prepare credentials for sending mail
$mailList = "email1@gmail.com", "email2@gmail.com", "email13@gmail.com"

# THIS METHOD IS NOT SECURE AND ONLY DONE SO YOU CAN KNOW
# PREFERABLE YOU KEEP YOUR USERID AND PASSWORD IN A SEPERATE
# FILE AND READ FROM IT LINE ON LINE 27 DO NOT IMPLEMENT THIS.
# ALTERNATIVELY YOU CAN JUST SEND THE MAIL WITH -Credential AS
# -Credential (Get-Credential -Credential "emailid@gmail.com")
# AND POWERSHELL WILL PROMPT YOU TO ENTER THE PASSWORD BUT THAT WOULD
# REQUIRE YOU TO BE PRESENT WHILE THE SCRIPT RUNS BUT ITS WAY SECURE!
#$creds = Get-Content -Path ""
#$userName = $creds[0]
#$userPassword = $creds[1]
[string]$userName = 'userid'
[string]$userPassword = 'password'

# Convert to SecureString
[securestring]$secureStringPassword = ConvertTo-SecureString $userPassword -AsPlainText -Force

#create a credential object for smtp client (powershell)
[pscredential]$credObject = New-Object System.Management.Automation.PSCredential ($userName, $secureStringPassword)

# COMPRESS APKS - IF YOU ARE PLANNING TO SEND APKS VIA GMAIL GMAIL DOES NOT SUPPORT
# MANY EXTENSIONS AND TOTAL ATTACHMENTS MUST ALL ADD UP TO LESS THAN 25MEGS
#Compress-Archive -LiteralPath <PathToFolder> -DestinationPath <PathToDestination>

#send the mail
Write-Host "sending mail.."
Send-MailMessage -From $userName -To $mailList -Subject $subject -Body $body -Attachments $attachment -Credential $credObject -SmtpServer "smtp.gmail.com" -UseSsl -Port 587

Get-ChildItem | Write-Host $_ -ForegroundColor Green
set-location "..\"
Write-Host "automated task completed.."
#shutdown windows
Stop-Computer
Write-Host "Windows shutting down.."

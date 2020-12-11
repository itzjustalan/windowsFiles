# THIS METHOD IS NOT SECURE AND ONLY DONE SO YOU CAN KNOW
# PREFERABLE YOU KEEP YOUR USERID AND PASSWORD IN A SEPERATE
# FILE AND READ FROM IT LIKE SHOWN BELOW DO NOT IMPLEMENT THIS.
# ALTERNATIVELY YOU CAN JUST SEND THE MAIL WITH -Credential AS
# -Credential (Get-Credential -Credential "emailid@gmail.com")
# AND POWERSHELL WILL PROMPT YOU TO ENTER THE PASSWORD BUT THAT WOULD
# REQUIRE YOU TO BE PRESENT WHILE THE SCRIPT RUNS BUT ITS WAY SECURE!
#$creds = Get-Content -Path ""
#$userName = $creds[0]
#$userPassword = $creds[1]
[string]$userName = 'userid'
[string]$userPassword = 'password'

$mailList = "some1@gmail.com", "other2@yahoo.ni"
$subject = "test mail"
$body = "long body or just load one from a file"

# attach all textfiles from the folder
$attachment = Get-ChildItem *.txt

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
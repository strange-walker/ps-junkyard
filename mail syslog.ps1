function Set-Credential {
param( [string]$username, [string]$password )
#set credentials for non-interactive input
    $pass = convertto-securestring $password -asplaintext -force
    $credential = new-object -typename System.Management.Automation.PSCredential `
         -argumentlist $username, $pass
    $credential
}

$body = Get-EventLog -LogName System -EntryType Error | Out-String
$time = get-date

#!!!input maillist, username and pass
$maillist = "someone@example.com", "someoneelse@example.com"
$cred = Set-Credential -username "someone@example.com" -password 'Pa$$w0rd'

#send report. Input -From, -Subject and -SMTP
Send-MailMessage -To $maillist -From "someone@example.com" -Subject "null" -SmtpServer "null" -Credential $cred -Body $time$body -Encoding UTF8 -UseSsl

#alternative view:

$report = @{
    -SmtpServer "null"
    -Credential $cred
    -From "someone@example.com"
    -To $maillist
    -Subject "null"
    -Body $time$body
    -Encoding UTF8
    -UseSsl
}

#send report. Input -From, -Subject and -SMTP
Send-MailMessage @report


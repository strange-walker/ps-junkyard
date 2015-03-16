function Set-Credential {
param( [string]$username, [string]$password )
#set credentials for non-interactive input
    $pass = convertto-securestring $password -asplaintext -force
    $credential = new-object -typename System.Management.Automation.PSCredential `
         -argumentlist $username, $pass
    $credential
}

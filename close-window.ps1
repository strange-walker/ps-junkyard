add-type -AssemblyName microsoft.VisualBasic
add-type -AssemblyName System.Windows.Forms

#for test. remove this 2 lines
calc
start-sleep -Milliseconds 5000

#replace "calc" with actual process
$a = Get-Process | Where-Object {$_.Name -eq "calc"}
[Microsoft.VisualBasic.Interaction]::AppActivate($a.ID)
[System.Windows.Forms.SendKeys]::SendWait("%{F4}")
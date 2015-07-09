add-type -AssemblyName microsoft.VisualBasic
add-type -AssemblyName System.Windows.Forms

#for test. remove this 2 lines
calc
start-sleep -Milliseconds 500

#replace "Калькулятор" with actual WINDOW TITLE
[Microsoft.VisualBasic.Interaction]::AppActivate("Калькулятор")
[System.Windows.Forms.SendKeys]::SendWait("%{F4}")
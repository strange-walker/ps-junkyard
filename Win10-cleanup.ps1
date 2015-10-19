#remove junk apps

Get-AppxPackage -Name Microsoft.3DBuilder | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.BingSports | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.MicrosoftSolitaireCollection | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.People | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.BingWeather | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.BingFinance | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.SkypeApp | Remove-AppxPackage



#onedrive extermination

Stop-Process -Name OneDrive
C:\Windows\SysWOW64\OneDriveSetup.exe /uninstall
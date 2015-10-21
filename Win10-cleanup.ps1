#remove junk apps
$JunkAppsList = @(
                "Microsoft.3DBuilder"
                "Microsoft.BingSports"
                "Microsoft.BingNews"
                "Microsoft.BingWeather"
                "Microsoft.BingFinance"
                "Microsoft.WindowsCamera"
                "Microsoft.Getstarted"
                "Microsoft.MicrosoftSolitaireCollection"
                "Microsoft.People"
                "Microsoft.SkypeApp"
                "Microsoft.ZuneMusic"
                "Microsoft.ZuneVideo"
                "Microsoft.XboxApp"
                "Microsoft.XboxGameCallableUI"
                "Microsoft.XboxIdentityProvider"
                "microsoft.windowscommunicationsapps"
                "Windows.MiracastView"
                "Windows.PurchaseDialog"
                
            )
$OtherApps = @(
                "Microsoft.AAD.BrokerPlugin"
                "Microsoft.Windows.CloudExperienceHost"
                "Microsoft.Windows.ShellExperienceHost"
                "windows.immersivecontrolpanel"
                "Microsoft.Windows.Cortana"
                "Microsoft.AccountsControl"
                "Microsoft.BioEnrollment"
                "Microsoft.LockApp"
                "Microsoft.MicrosoftEdge"
                "Microsoft.Windows.AssignedAccessLockApp"
                "Microsoft.Windows.ContentDeliveryManager"
                "Microsoft.Windows.ParentalControls"
                "Microsoft.WindowsFeedback"
                "Windows.ContactSupport"
                "Windows.PrintDialog"
                "Microsoft.Windows.Photos"
                "Microsoft.WindowsStore"
                "windows.devicesflow"
                "Microsoft.WindowsAlarms"
                "Microsoft.WindowsSoundRecorder"
                "Microsoft.WindowsPhone"
                "Microsoft.WindowsMaps"
                "Microsoft.WindowsDVDPlayer"
                "Microsoft.Office.OneNote"
                "Microsoft.MicrosoftOfficeHub"
                "Microsoft.Appconnector"
            )
foreach ($app in $JunkAppsList) {
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage
    }


#onedrive extermination
Stop-Process -Name OneDrive
C:\Windows\SysWOW64\OneDriveSetup.exe /uninstall
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
Remove-Item -Path "hkcr:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse
Remove-Item -Path "hkcr:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse
Remove-PSDrive "HKCR"

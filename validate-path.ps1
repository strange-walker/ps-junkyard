<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Validate-Path
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]$Path
    )

    Begin
        {
        $verdict = $false
        $drive = $false
        $folder = $false

        $driveletter = $path.Substring(0,2)
        
        $folders = $Path.Substring(3)
        }
    Process
        {
        #verify disk type (hdd, removable or network) and connectivity
        $driveobject = Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DeviceID -eq $drive -and $_.DriveType -match '[234]'}
        if ($driveobject.freespace -ne $null)
        {
            
        }
        
        }
    End
        {
        $verdict
        }
}


Get-WmiObject -Class Win32_LogicalDisk

$path = 'D:\test\150806'
$drive = $path.Substring(0,2)
$folders = $Path.Substring(3)
$drive
$folders

flash = 2
hdd = 3
network = 4

Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DeviceID -eq $drive -and $_.DriveType -match '[234]'}

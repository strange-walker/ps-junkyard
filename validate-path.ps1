<#
.Synopsis
   Test NTFS filesystem path validity
.DESCRIPTION
   Validate-Path tests if provided string may be used as a filesystem path in windows system for logical, network attached or removable storage
   It doesn't test if [-Path] actually exists.
.EXAMPLE
   PS C:\> Validate-Path -Path C:\WINDOWS\system32

   True

.EXAMPLE
   PS C:\> Validate-Path -Path D:\Somefolder\coN1\more\folders\to\come

   False

.ToDo List
    * [-ShortNames] switch for 8.3 naming
    * UNC (\\server\folder) support
#>
function Validate-Path
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # String belived to be filesystem path
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]$Path
    )

    Begin
        {
        $verdict = $false
        $folders = $Path.Substring(3)
        }
    Process
        {
        #verify disk type (hdd, removable or network) and connectivity. drive types: flash = 2, hdd = 3, network disk = 4
        $driveletter = $path.Substring(0,2)
        $driveobject = Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DeviceID -eq $driveletter -and $_.DriveType -match '[234]'}
        $drive = ($driveobject.freespace -ne $null)
        
        # list of forbidden symbols and objects https://msdn.microsoft.com/en-us/library/windows/desktop/aa365247%28v=vs.85%29.aspx#win32_file_namespaces
        $folder = !(($folders -match '\\com[1-9]\\') -or 
                    ($folders -match '\\lpt[1-9]\\') -or 
                    ($folders -match '\\con\\') -or 
                    ($folders -match '\\prn\\') -or
                    ($folders -match '\\aux\\') -or 
                    ($folders -match '\\nul\\') -or 
                    ($folders -match '\*') -or 
                    ($folders -match '\<') -or 
                    ($folders -match '\>') -or 
                    ($folders -match '\:') -or 
                    ($folders -match '\/') -or 
                    ($folders -match '\\\\') -or 
                    ($folders -match '\|') -or 
                    ($folders -match '\?') -or 
                    ($folders -match '\"') -or
                    ($folders.Length -ge 260) ) #MAX_PATH check

        }
    End
        {
        $verdict = $drive -and $folder
        $verdict
        }
}
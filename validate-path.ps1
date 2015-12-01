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

        $folders = $Path.Substring(3)
        }
    Process
        {
        #verify disk type (hdd, removable or network) and connectivity
        $driveletter = $path.Substring(0,2)
        #drive types: flash = 2, hdd = 3, network disk = 4
        $driveobject = Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DeviceID -eq $driveletter -and $_.DriveType -match '[234]'}
        if ($driveobject.freespace -ne $null)
            {
            $drive = $true
            }
        
        # list of forbidden symbols https://msdn.microsoft.com/en-us/library/windows/desktop/aa365247%28v=vs.85%29.aspx#win32_file_namespaces
        $bannedobjects = ("CON","PRN","AUX","NUL","COM1","COM2","COM3","COM4","COM5","COM6","COM7","COM8","COM9","LPT1","LPT2","LPT3","LPT4","LPT5","LPT6","LPT7","LPT8","LPT9")
        $bannedsymbols = ("<",">",":","/","\\","|","?","*",'"')

        }
    End
        {
        $drive
        $folder
        $verdict = $drive -and $folder
        $verdict
        }
}

NUL.txt is not recommended. For more information, see Namespaces.

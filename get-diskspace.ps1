<#
.Synopsis
   Gets diskspace info
.DESCRIPTION
   Gets disk size and free space from specified logical disks on selceted computer
.EXAMPLE
   Get-DiskSpace 
.EXAMPLE
   Еще один пример использования этого командлета
#>
function Get-DiskSpace
{
    [CmdletBinding()]
    Param
    (
        # NetBios name of computer
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]$ComputerName,
        # Drive letter of logical disk in format X:
        [string]$DriveLetter
    )

    Begin
    {
    }
    Process
    {
    Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceId='$DriveLetter'" -ComputerName $ComputerName | 
    Select PSComputername, DeviceID, 
        @{n='Size'; e={$_.size / 1gb -as [int]}},
        @{n='Free'; e={$_.freespace / 1gb -as [int]}}
    }
    End
    {
    }
}
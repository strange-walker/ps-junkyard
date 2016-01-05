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
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]
        [string]$ComputerName = 'localhost'

    )

    Begin
    {
    $report = @()
    }
    Process
    {
    $disk = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" -ComputerName $ComputerName | 
    Select DeviceID, 
        @{n='Size'; e={$_.size / 1gb -as [int]}},
        @{n='Free'; e={$_.freespace / 1gb -as [int]}}



    foreach ($item in $disk.deviceid) {
        $i=[array]::IndexOf($disk.deviceid, $item)
        $letter = "Disk $item"
        $value = $disk.size[$i]
        $disk2 = New-Object PSObject
        $disk2 | Add-Member -type NoteProperty -Name 'Name' -Value $item
        $disk2 | Add-Member -type NoteProperty -Name 'Capacity' -Value $disk.size[$i]
        $disk2 | Add-Member -type NoteProperty -Name 'Freespace' -Value $disk.Free[$i]
        $report += $disk2
        }

    }
    End
    {
    $report
    }
}
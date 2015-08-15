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


$rdata = New-Object -TypeName psobject
$disk = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" -ComputerName $ComputerName | 
Select DeviceID, 
        @{n='Size'; e={$_.size / 1gb -as [int]}},
        @{n='Free'; e={$_.freespace / 1gb -as [int]}}
foreach ($item in $disk.deviceid) {
    $i=[array]::IndexOf($disk.deviceid, $item)
    $letter = "Disk $item"
    $value = $disk.size[$i]
    Add-Member -InputObject $rdata -MemberType NoteProperty -Name "Disk $item capacity" -Value $disk.size[$i]
    Add-Member -InputObject $rdata -MemberType NoteProperty -Name "Disk $item freespace" -Value $disk.Free[$i]

}

$rdata
    }
    End
    {
    }
}
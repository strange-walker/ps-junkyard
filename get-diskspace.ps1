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
function Verb-Noun
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Справочное описание параметра 1
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Param1,

        # Справочное описание параметра 2
        [int]
        $Param2
    )

    Begin
    {
    }
    Process
    {
    Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceId='C:'" -ComputerName $name | 
    Select PSComputername, DeviceID, 
        @{n='Size'; e={$_.size / 1gb -as [int]}},
        @{n='Free'; e={$_.freespace / 1gb -as [int]}}
    }
    End
    {
    }
}
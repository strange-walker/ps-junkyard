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
function Get-DirInfo
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Path = (pwd).Path,
        [int]$Depth = 1

    )

    Begin
    {
    $result = $null
    }
    Process
    {
        if ($Depth -gt 0)
            {
            $result += Get-DirInfo ($Path, ($Depth - 1))
            }
        else
            {
            $size = (Get-ChildItem $Path -Recurse | Measure-Object -Property length -Sum).Sum/1mb 
            $folder = New-Object PSObject
            $folder | Add-Member -type NoteProperty -Name 'Folder' -Value $Path
            $folder | Add-Member -type NoteProperty -Name 'Size' -Value $size
            $result += $folder
            }
        
    }
    End
    {
    $result
    }
}



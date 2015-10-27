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
        [int]$Depth = 2

    )

    Begin
    {
    $result = @()
    if ($path[-1] -ne '\')
        {
        $Path += '\'
        }
    }
    Process
    {
        if ($Depth -gt 0)
            {
            #$depth
            $size = (Get-ChildItem $Path -Recurse | Measure-Object -Property length -Sum).Sum/1mb -as [int]
            $folder = New-Object PSObject
            $folder | Add-Member -type NoteProperty -Name 'Folder' -Value $Path
            $folder | Add-Member -type NoteProperty -Name '     Size (MB)' -Value $size
            $result += $folder
            $subfolders = (Get-ChildItem $Path | Where-Object {$_.Mode -like 'd*'}).Name
            foreach ($item in $subfolders)
                {
                $result += Get-DirInfo -Path ($path + $item + '\') -Depth ($depth - 1)    
                }

            
            }
        else
            {

            
            }
        
    }
    End
    {
    $result
    }
}


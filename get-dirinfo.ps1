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
        # Defines directory being studied. Default is current directory.
        [Parameter(ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Path = (pwd).Path,
        # Defines number of subfolders scanned. 1 is for currnet folder only.
        [int]$Depth = 2,
        # Param3 help description
        [ValidateSet ('gb', 'mb')]
        [string]
        $Measure = 'mb'
    )

    Begin
    {
    $result = @()
    $FSO = New-Object -ComObject Scripting.FileSystemObject


    if ($path[-1] -ne '\')
        {
        $Path += '\'
        }
        
    }
    Process
    {
        if ($Depth -gt 0)
            {
            #I'm using FSObject instead of simple get-childitem\measure-object because of conflict with square brackets. BTW it's much faster :)
            if ($Measure -eq 'mb') {$size = $FSO.GetFolder($Path).Size/1mb -as [int]}
            if ($Measure -eq 'gb') {$size = $FSO.GetFolder($Path).Size/1gb -as [int]}
            $folder = New-Object PSObject
            $folder | Add-Member -type NoteProperty -Name 'Folder' -Value $Path
            $folder | Add-Member -type NoteProperty -Name '     Size ()' -Value $size
            $result += $folder
            $subfolders = (Get-ChildItem -LiteralPath $Path -Directory -Force).Name
            foreach ($item in $subfolders)
                {
                $result += Get-DirInfo -Path ($path + $item) -Depth ($depth - 1) -Measure $Measure   
                }
            }
    }
    End
    {
    $result
    }
}


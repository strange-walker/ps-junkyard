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
function Backup-RouteTable
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        $Path = "C:\routetable.csv"

    )

    Begin
    {
    }
    Process
    {
    Get-NetRoute | Where-Object {$_.RouteMetric -eq 1} | Export-Csv -Path $Path
    }
    End
    {
    }
}



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
function Restore-RouteTable
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   Position=0)]
        $Path,

        # Param2 help description
        [int]
        $Param2
    )

    Begin
    {
    $routes = Import-Csv $Path
    $CurrentTable = Get-NetRoute | Where-Object {$_.RouteMetric -eq 1}
    $reps = @()
    }
    Process
    {
    foreach ($item in $routes)
        {
        if ($CurrentTable.DestinationPrefix -contains $item.DestinationPrefix)
            {
            $reps += "Route to " + $item.DestinationPrefix + " already exists."
            }
        else
            {
            New-NetRoute -DestinationPrefix $item.DestinationPrefix -InterfaceIndex $item.ifindex -NextHop $item.nexthop -RouteMetric 1
            #Write-Host "Route to " $item.DestinationPrefix " added to routing table."
            }

        
        }
    }
    End
    {
    Write-Host
    $reps
    }
}
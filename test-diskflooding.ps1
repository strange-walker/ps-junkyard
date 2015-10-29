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
function Test-DiskFlooding
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
        $Scope='localhost',

        # Param2 help description
        [int]
        $Param2
    )

    Begin
    {
    $report = $null
    $alerts = @()
    if ($Scope -eq 'domain') 
            {
            $Scope = (Get-ADComputer -Filter *).name
            } 
    }
    Process
    {
    foreach ($item in $scope)
        {
        $item
        $storage = Get-DiskSpace -ComputerName $item
        foreach ($x in $storage)
            {
            if ($x.Capacity -in 1..20)
                {
                if ($x.Freespace -lt 5) { $alerts += ("$item Disk " +$x.name + " running low. " + $x.Freespace + " GB out of " + $x.Capacity + " left.")}
                }
            elseif ($x.Capacity -in 21..80)
                {
            if ($x.Freespace -lt 10) { $alerts += ("$item Disk " +$x.name + " running low. " + $x.Freespace + " GB out of " + $x.Capacity + " left.")}
                }
            elseif ($x.Capacity -in 81..200)
                {
                if ($x.Freespace -lt 20) { $alerts += ("$item Disk " +$x.name + " running low. " + $x.Freespace + " GB out of " + $x.Capacity + " left.")}
                }
            elseif ($x.Capacity -in 201..500)
                {
                if ($x.Freespace -lt 30) { $alerts += ("$item Disk " +$x.name + " running low. " + $x.Freespace + " GB out of " + $x.Capacity + " left.")} 
                }
            elseif ($x.Capacity -in 501..1000)
                {
                if ($x.Freespace -lt 50) { $alerts += ("$item Disk " +$x.name + " running low. " + $x.Freespace + " GB out of " + $x.Capacity + " left.")}  
                }
            elseif ($x.Capacity -gt 1000)
                {
                if ($x.Freespace -lt 100) { $alerts += ("$item Disk " +$x.name + " running low. " + $x.Freespace + " GB out of " + $x.Capacity + " left.")}
                }
            }
        }

    }
    End
    {
    $alerts
    }
}
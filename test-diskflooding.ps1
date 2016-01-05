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
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]
        $ComputerName='localhost',

        # Param2 help description
        [int]
        $Param2
    )

    Begin
    {
    $alerts = @()
    }
    Process
    {
        $storage = Get-DiskSpace -ComputerName $ComputerName
        foreach ($x in $storage)
            {
            switch ($x)
                {
                {$_.Capacity -in 1..20} {if ($_.Freespace -lt 5) { $alerts += ("$ComputerName Disk " +$_.name + " running low. " + $_.Freespace + " GB out of " + $_.Capacity + " left.")}}
                {$_.Capacity -in 21..80} {if ($_.Freespace -lt 10) { $alerts += ("$ComputerName Disk " +$_.name + " running low. " + $_.Freespace + " GB out of " + $_.Capacity + " left.")}}
                {$_.Capacity -in 81..200} {if ($_.Freespace -lt 20) { $alerts += ("$ComputerName Disk " +$_.name + " running low. " + $_.Freespace + " GB out of " + $_.Capacity + " left.")}}
                {$_.Capacity -in 201..500} {if ($_.Freespace -lt 30) { $alerts += ("$ComputerName Disk " +$_.name + " running low. " + $_.Freespace + " GB out of " + $_.Capacity + " left.")}}
                {$_.Capacity -in 501..1000} {if ($_.Freespace -lt 50) { $alerts += ("$ComputerName Disk " +$_.name + " running low. " + $_.Freespace + " GB out of " + $_.Capacity + " left.")}}
                {$_.Capacity -gt 1000} {if ($_.Freespace -lt 100) { $alerts += ("$ComputerName Disk " +$_.name + " running low. " + $_.Freespace + " GB out of " + $_.Capacity + " left.")}}
                Default {Write-Host 'oops'}
                }
            }
        

    }
    End
    {
    $alerts
    }
}
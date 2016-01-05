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
            switch ($x)
                {
                {$_.Capacity -in 1..20} {if ($_.Freespace -lt 5) { $alerts += ("$item Disk " +$_.name + " running low. " + $_.Freespace + " GB out of " + $_.Capacity + " left.")}}
                {$_.Capacity -in 21..80} {if ($_.Freespace -lt 10) { $alerts += ("$item Disk " +$_.name + " running low. " + $_.Freespace + " GB out of " + $_.Capacity + " left.")}}
                {$_.Capacity -in 81..200} {if ($_.Freespace -lt 20) { $alerts += ("$item Disk " +$_.name + " running low. " + $_.Freespace + " GB out of " + $_.Capacity + " left.")}}
                {$_.Capacity -in 201..500} {if ($_.Freespace -lt 30) { $alerts += ("$item Disk " +$_.name + " running low. " + $_.Freespace + " GB out of " + $_.Capacity + " left.")}}
                {$_.Capacity -in 501..1000} {if ($_.Freespace -lt 50) { $alerts += ("$item Disk " +$_.name + " running low. " + $_.Freespace + " GB out of " + $_.Capacity + " left.")}}
                {$_.Capacity -gt 1000} {if ($_.Freespace -lt 100) { $alerts += ("$item Disk " +$_.name + " running low. " + $_.Freespace + " GB out of " + $_.Capacity + " left.")}}
                Default {Write-Host 'oops'}
                }
            }
        }

    }
    End
    {
    $alerts
    }
}
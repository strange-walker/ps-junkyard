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
    $alerts = $null
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
                $x.name
                Write-Host 'Tiny'
                }
            elseif ($x.Capacity -in 21..80)
                {
                $x.name
                Write-Host 'Small'   
                }
            elseif ($x.Capacity -in 81..200)
                {
                $x.name
                Write-Host 'Medium'   
                }
            elseif ($x.Capacity -in 201..500)
                {
                $x.name
                Write-Host 'Big'   
                }
            elseif ($x.Capacity -in 501..1000)
                {
                $x.name
                Write-Host 'Huge'   
                }
            elseif ($x.Capacity -gt 1000)
                {
                $x.name
                Write-Host 'SAN'   
                }
            }
        }

    }
    End
    {
    }
}
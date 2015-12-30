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
function Get-ADComputersList
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true)]
        [validateset("All", "Servers", "Workstations")]$Scope,

        # Specifies
        [int][ValidateRange(1,60)] $Active = $null
    )

    Begin
    {
    $SpecialProperties = @('LastLogonDate', 'OperatingSystem', 'Name')
    switch ($Scope)
        {
        "All"              {$filter = "*"}
        "Workstations"     {$filter = "OperatingSystem -like '* XP *' -or 
                                       OperatingSystem -like '* 7 *' -or 
                                       OperatingSystem -like '* 8.1 *' -or
                                       OperatingSystem -like '* 10 *'"}
        "Servers"          {$filter = "OperatingSystem -like '*Server*'"}
        Default            {Throw "If you're seeing this, something has gone terribly wrong. Run, you fool." }
        }
    $result = Get-ADComputer  -Properties $SpecialProperties -Filter $filter

    if ($Active -ne 0)
    {
        $result = $result | Where-Object -Property LastLogonDate -gt (get-date).adddays(-$Active)
    }
    }
    Process
    {
   
    }
    End
    {
    $result
    }
}


#single pc object

$full = Get-ADComputer  -Properties * -Filter {Name -eq 'algernon'}
#$full
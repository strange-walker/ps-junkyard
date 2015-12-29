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
        [validateset("All", "Desktops", "Notebooks", "Servers", "Workstations")]$Scope,

        # Param2 help description
        [switch]
        $Active
    )

    Begin
    {
    $SpecialProperties = @('LastLogonDate', 'OperatingSystem', 'Name')
    switch ($Scope)
        {
        "All"          {$filter = '*'}
        "Desktops"     {$filter = "*"}
        "Notebooks"    {$filter = "*"}
        "Servers"      {$filter = "OperatingSystem -like '*Server*'"}
        "Workstations" {$filter = "OperatingSystem -like '* XP *' -or 
                                   OperatingSystem -like '* 7 *' -or 
                                   OperatingSystem -like '* 8.1 *' -or
                                   OperatingSystem -like '* 10 *'"}
        Default        {}
        }
    }
    Process
    {
    #$filter
    $test = Get-ADComputer  -Properties $SpecialProperties -Filter $filter
    }
    End
    {
    $test
    }
}


#single pc object

$full = Get-ADComputer  -Properties * -Filter {Name -eq 'algernon'}
$full
# 10.10.10.0,10.10.10.10,Computer1,1a-1b-1c-1d-1e-1f,Reserved for Computer1
# Add-DhcpServerv4Reservation -ComputerName dhcpserver.contoso.com -ScopeId 10.10.10.0 -IPAddress $freeip -ClientId F0-DE-F1-7A-00-5E -Description "Reservation for Printer"

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
function Convert-DHCPDReservations
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
        $File#,

        # Param2 help description
        #[string]
        #$Scope
    )

    Begin
    {
    $dhcpd = Get-Content -Path $File

    $dhcp = @()
    $hostobj = New-Object -TypeName psobject
    Add-Member -InputObject $hostobj -MemberType NoteProperty -Name IPAddress -Value ''
    Add-Member -InputObject $hostobj -MemberType NoteProperty -Name ClientId -Value ''
    Add-Member -InputObject $hostobj -MemberType NoteProperty -Name Description -Value ''
    }
    Process
    {
    foreach ($item in $dhcpd)
        {
         if ($item -match 'host')
         {
            
            $host_entry = $hostobj.psobject.copy()


            $item
             #$dhcp += $host_entry
         }   
        }
    }
    End
    {
    $dhcp
    }
}


Convert-DHCPDReservations -File D:\scripts\dhcpd.conf


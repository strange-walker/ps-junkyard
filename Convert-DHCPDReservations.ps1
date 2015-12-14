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
    $h = @()
    $i = 0
    $line = $dhcpd[0]
    while ($i -lt $dhcpd.Count)
                                                                                            {
     #$i
     if ($line.StartsWith('#'))
     {
         $i++
         $line = $dhcpd[$i]

     }
     else
     {
     #$stroka = $d[$i]
             if ($line.EndsWith(';') -or $line.EndsWith('{'))
             {
             $line = $line + $dhcpd[$i+1]
             #$i++
             }
         else
             {
             $h += $line
             $line = $dhcpd[$i+1]     
             }
      $i++     
     }

      
    }
    $dhcpd = $h




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
            
            $ip = $item.Substring($item.IndexOf('fixed-address'))
            $ip2 = $ip.Substring(0,$ip.IndexOf(';'))
            $ip3 = $ip2.Substring(14)
            $host_entry.IPAddress = $ip3

            $mac = $item.Substring($item.IndexOf('ethernet'))
            $mac = $mac.Substring(9, $mac.IndexOf(';'))
            $mac2 = $mac.Substring(0,$mac.IndexOf(';'))
            $mac2 = $mac2 -replace (':', '-')
            $host_entry.clientid = $mac2

            $name = $item.Substring($item.IndexOf('host'))
            $name2 = $name.Substring(5)
            $name3 = $name2.Substring(0,$name2.IndexOf(' '))
            $name4 = $name3.Substring(0,$name3.IndexOf("`t"))
            $host_entry.Description = $name4

            

            $dhcp += $host_entry
         }   
        }
    }
    End
    {
    $dhcp
    }
}


# Convert-DHCPDReservations -File D:\scripts\dhcpd.conf


$test = Convert-DHCPDReservations -File D:\scripts\dhcpd.conf
foreach ($item in $test)
{
if ($item.ipaddress -match '192.168.1.')
{
$item.ipaddress
Add-DhcpServerv4Reservation -ClientId $item.ClientId -IPAddress $item.IPAddress -ScopeId 192.168.1.0 -ComputerName dc1 -Name $item.Description    
}
    
}


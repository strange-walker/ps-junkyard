<#
.Synopsis
   Function collects hardware info.
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet

.todo
    Status param for objects - online\offline - done
    ram type broken. need another solution
    monitor info
    -worst switch - output pc with worst param
    -file switch - also fetches cached data from file
#>
function Get-HardWareInfo
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Defines set of computres from which info will be collected. Default is localhost, 'domain' for collecting from all AD computers.
        [Parameter(ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Scope='localhost',

        # Param2 help description
        [int]
        $Param2,

        [switch]$Detailed
    )

    Begin
    {
        if ($Scope -eq 'domain') 
        {
            $Scope = (Get-ADComputer -Filter *).name
        } 

        $memorytype = "Unknown", "Other", "DRAM", "Synchronous DRAM", "Cache DRAM", "EDO", "EDRAM", "VRAM", "SRAM", "RAM", "ROM", "Flash", "EEPROM", "FEPROM", "EPROM", "CDRAM", "3DRAM", "SDRAM", "SGRAM", "RDRAM", "DDR", "DDR-2", "DDR2 FB-DIMM", "unknown", "DDR3", "FBD2"


        $R_template = New-Object -TypeName psobject
        Add-Member -InputObject $R_template -MemberType NoteProperty -Name Computername -Value uno
        Add-Member -InputObject $R_template -MemberType NoteProperty -Name Status -Value 'Offline'
        Add-Member -InputObject $R_template -MemberType NoteProperty -Name Total_RAM_mb -Value 'n\a'
        Add-Member -InputObject $R_template -MemberType NoteProperty -Name Memory_slots -Value 'n\a'
        Add-Member -InputObject $R_template -MemberType NoteProperty -Name Memory_installed -Value 'n\a'
        Add-Member -InputObject $R_template -MemberType NoteProperty -Name MB_Vendor -Value 'n\a'
        Add-Member -InputObject $R_template -MemberType NoteProperty -Name MB_Model -Value 'n\a'
        Add-Member -InputObject $R_template -MemberType NoteProperty -Name Processor -Value 'n\a'
        Add-Member -InputObject $R_template -MemberType NoteProperty -Name VideoAdapter -Value 'n\a'
    }
    Process
    {
        $R_report = @()

        foreach ($item in $Scope)
        {
            #initialize object 
            $R_entry = $R_template.psobject.copy()
            $R_entry.computername = $item

            if ((Test-Connection -ComputerName $item -Count 2 -Quiet) -eq $false)
                {
                $R_entry.status = 'Offline'
                }
            #elseif (((Get-WmiObject -ComputerName $item win32_computersystem).name) -ne $item )
            #    {
            #    $R_entry.status = 'WinRM connection error'    
            #    }
            else
                {
                $R_entry.status = 'Online'
                $R_entry.Total_RAM_mb = ((Get-WmiObject  win32_computersystem -ComputerName $item).totalphysicalmemory / 1mb -as [int])
#                $R_entry.Memory_slots
#                $R_entry.Memory_installed
                $R_entry.MB_Vendor = (Get-WmiObject Win32_BaseBoard -ComputerName $item).manufacturer
                $R_entry.MB_Model = (Get-WmiObject Win32_BaseBoard -ComputerName $item).product
                $R_entry.Processor = (Get-WmiObject win32_processor -ComputerName $item).name
                $R_entry.VideoAdapter = (Get-WmiObject Win32_VideoController -ComputerName $item).name

                }
            $R_entry
            $R_report += $R_entry
        }
        
    $R_report
    
    }
    End
    {
    $R_report | Select Computername,Total_RAM_mb,processor | Format-Table -AutoSize
    foreach ($item in $R_report)
        {
        Export-Csv -Path D:\scripts\hadwarereport.csv -InputObject $item -UseCulture -NoTypeInformation -Append
        }
    }
}




                    #here we count number of memory slots and their types. I'm putting 'foreach' here for the sake of mb's with hybrid memory slots (ddr2 and ddr3 mixed)
                    
                    
                    
                    $memslots = $memorytype[(Get-WmiObject Win32_PhysicalMemory).memorytype ] | Group-Object
                    [string]$memrep = $null
                    foreach ($item in $memslots)
                        {
                        $memrep += [string]$item.count + " x " + [string]$item.Name + '   '
                        }
                    Add-Member -InputObject $rdata -MemberType NoteProperty -Name Memory_slots -Value $memrep
                    $memspace = (Get-WmiObject Win32_PhysicalMemory).capacity | Group-Object
                    $memcount = $null
                    foreach ($item in $memspace)
                        {
                        $memcount += [string]$item.count + " x " + [string]($item.Name/ 1mb -as [int]) + ' MB  '
                        }
                    Add-Member -InputObject $rdata -MemberType NoteProperty -Name Memory_installed -Value $memcount



                    #count the number of hdd's installed and report their models and capacity
                    $storage = Get-WmiObject win32_diskdrive | Where-Object {$_.model -like '*ATA Device*'}
                    foreach ($item in $storage.model)
                    {
                        $i=[array]::IndexOf($storage.model, $item)
                        #$i
                        #$item
                        Add-Member -InputObject $rdata -MemberType NoteProperty -Name "ATA HDD $i model" -Value $storage.model[$i] 
                        Add-Member -InputObject $rdata -MemberType NoteProperty -Name "ATA HDD $i capacity" -Value ( $storage.size[$i] / 1gb -as [int] )
                        }
                    $rdata
                    } -ComputerName $item )
                $data

         
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
    disk info: max, free. red highligh if low
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
        # index stolen from PowerShell.com
        $memorytype = "Unknown", "Other", "DRAM", "Synchronous DRAM", "Cache DRAM", "EDO", "EDRAM", "VRAM", "SRAM", "RAM", "ROM", "Flash", "EEPROM", "FEPROM", "EPROM", "CDRAM", "3DRAM", "SDRAM", "SGRAM", "RDRAM", "DDR", "DDR-2"

    }
    Process
{
        $report = @()
        foreach ($item in $Scope)
        {
            if (Test-Connection -ComputerName $item -Count 2 -Quiet)
            {
                $data = (Invoke-Command -ScriptBlock {
                    $rdata = New-Object -TypeName psobject
                    #simple wmi queries
                    Add-Member -InputObject $rdata -MemberType NoteProperty -Name Computername -Value (Get-WmiObject  win32_computersystem).name
                    Add-Member -InputObject $rdata -MemberType NoteProperty -Name Status -Value 'Online'
                    Add-Member -InputObject $rdata -MemberType NoteProperty -Name 'Total RAM (mb)' -Value ((Get-WmiObject  win32_computersystem).totalphysicalmemory / 1mb -as [int])

                    #here we count number of memory slots and their types. I'm putting 'foreach' here for the sake of mb's with hybrid memory slots (ddr2 and ddr3 mixed)
                    $memslots = $memorytype[(Get-WmiObject Win32_PhysicalMemory).memorytype ] | Group-Object
                    [string]$memrep = $null
                    foreach ($item in $memslots)
                        {
                        $memrep += [string]$item.count + " x " + [string]$item.Name + '   '
                        }
                    Add-Member -InputObject $rdata -MemberType NoteProperty -Name 'Memory slots' -Value $memrep
                    $memspace = (Get-WmiObject Win32_PhysicalMemory).capacity | Group-Object
                    $memcount = $null
                    foreach ($item in $memspace)
                        {
                        $memcount += [string]$item.count + " x " + [string]($item.Name/ 1mb -as [int]) + ' MB  '
                        }
                    Add-Member -InputObject $rdata -MemberType NoteProperty -Name 'Memory installed' -Value $memcount


                    #more simple wmi queries
                    Add-Member -InputObject $rdata -MemberType NoteProperty -Name 'MB Vendor' -Value (Get-WmiObject Win32_BaseBoard).manufacturer
                    Add-Member -InputObject $rdata -MemberType NoteProperty -Name 'MB Model' -Value (Get-WmiObject Win32_BaseBoard).product
                    Add-Member -InputObject $rdata -MemberType NoteProperty -Name Processor -Value (Get-WmiObject win32_processor).name
                    Add-Member -InputObject $rdata -MemberType NoteProperty -Name VideoAdapter -Value(Get-WmiObject Win32_VideoController).name

                    #count the number of hdd's installed and report their models and capacity
                    $storage = Get-WmiObject win32_diskdrive | Where-Object {$_.model -like '*ATA Device*'}
                    foreach ($item in $storage.model)
                    {
                        $i=[array]::IndexOf($storage.model, $item)
                        #$i
                        #$item
                        Add-Member -InputObject $rdata -MemberType NoteProperty -Name "HDD $i model" -Value $storage.model[$i] 
                        Add-Member -InputObject $rdata -MemberType NoteProperty -Name "HDD $i capacity" -Value ( $storage.size[$i] / 1gb -as [int] )
                        }
                    $rdata
                    } -ComputerName $item )
                $data
            }
            else
            {
                $data = New-Object -TypeName psobject
                Add-Member -InputObject $data -MemberType NoteProperty -Name Computername -Value $item
                Add-Member -InputObject $data -MemberType NoteProperty -Name 'Total RAM (mb)' -Value 'Offline'
                Add-Member -InputObject $data -MemberType NoteProperty -Name 'MB Vendor' -Value 'n\a'
                Add-Member -InputObject $data -MemberType NoteProperty -Name 'MB Model' -Value 'n\a'
                Add-Member -InputObject $data -MemberType NoteProperty -Name Processor -Value 'n\a'
                $data
            }


            $report += $data
        }
        
    
    
    }
    End
    {
    $report | Select Computername,'Total RAM (gb)',processor | Format-Table -AutoSize
    }
}


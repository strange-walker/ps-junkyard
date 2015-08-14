# Список классов
# https://msdn.microsoft.com/en-us/library/aa389273%28v=vs.85%29.aspx

get-hwinfo -computer 'localhost' -detailed


Get-WmiObject Win32_BaseBoard
Get-WmiObject win32_processor
Get-WmiObject  win32_computersystem
Get-WmiObject Win32_DiskDrive

Get-WmiObject Win32_PhysicalMemory
Get-WmiObject Win32_PhysicalMemoryArray
Get-WmiObject Win32_DesktopMonitor
Get-WmiObject Win32_VideoController
Get-WmiObject Win32_DisplayConfiguration


$test = (Get-WmiObject  win32_computersystem).totalphysicalmemory / 1gb -as [int]
$test


$report = New-Object -TypeName psobject
Add-Member -InputObject $report -MemberType NoteProperty -Name Computername -Value (Get-WmiObject  win32_computersystem).name
Add-Member -InputObject $report -MemberType NoteProperty -Name 'Total RAM (gb)' -Value ((Get-WmiObject  win32_computersystem).totalphysicalmemory / 1gb -as [int])
Add-Member -InputObject $report -MemberType NoteProperty -Name 'MB Vendor' -Value (Get-WmiObject Win32_BaseBoard).manufacturer
Add-Member -InputObject $report -MemberType NoteProperty -Name 'MB Model' -Value (Get-WmiObject Win32_BaseBoard).product
Add-Member -InputObject $report -MemberType NoteProperty -Name Processor -Value (Get-WmiObject win32_processor).name
$report


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
function Get-Report
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
       
           )

    Begin
    {
    }
    Process
    {
    $report = New-Object -TypeName psobject
    Add-Member -InputObject $report -MemberType NoteProperty -Name Computername -Value (Get-WmiObject  win32_computersystem).name
    Add-Member -InputObject $report -MemberType NoteProperty -Name 'Total RAM (gb)' -Value ((Get-WmiObject  win32_computersystem).totalphysicalmemory / 1gb -as [int])
    Add-Member -InputObject $report -MemberType NoteProperty -Name 'MB Vendor' -Value (Get-WmiObject Win32_BaseBoard).manufacturer
    Add-Member -InputObject $report -MemberType NoteProperty -Name 'MB Model' -Value (Get-WmiObject Win32_BaseBoard).product
    Add-Member -InputObject $report -MemberType NoteProperty -Name Processor -Value (Get-WmiObject win32_processor).name
$report
    }
    End
    {
    }
}


Invoke-Command -ScriptBlock {

    $report = New-Object -TypeName psobject
    Add-Member -InputObject $report -MemberType NoteProperty -Name Computername -Value (Get-WmiObject  win32_computersystem).name
    Add-Member -InputObject $report -MemberType NoteProperty -Name 'Total RAM (gb)' -Value ((Get-WmiObject  win32_computersystem).totalphysicalmemory / 1gb -as [int])
    Add-Member -InputObject $report -MemberType NoteProperty -Name 'MB Vendor' -Value (Get-WmiObject Win32_BaseBoard).manufacturer
    Add-Member -InputObject $report -MemberType NoteProperty -Name 'MB Model' -Value (Get-WmiObject Win32_BaseBoard).product
    Add-Member -InputObject $report -MemberType NoteProperty -Name Processor -Value (Get-WmiObject win32_processor).name
    $report


} -ComputerName area51,blackmesa,eth-upc-026 | Select Computername,'Total RAM (gb)',processor | Format-Table -AutoSize
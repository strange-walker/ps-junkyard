<#
.Synopsis
   Function collects hardware info.
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Get-HardWareInfo
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Defines set of computres from which info will be collected. Default is localhost
        [Parameter(ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Scope='localhost',

        # Param2 help description
        [int]
        $Param2
    )

    Begin
    {
    }
    Process
    {
    Invoke-Command -ScriptBlock {

    $report = New-Object -TypeName psobject
    Add-Member -InputObject $report -MemberType NoteProperty -Name Computername -Value (Get-WmiObject  win32_computersystem).name
    Add-Member -InputObject $report -MemberType NoteProperty -Name 'Total RAM (gb)' -Value ((Get-WmiObject  win32_computersystem).totalphysicalmemory / 1gb -as [int])
    Add-Member -InputObject $report -MemberType NoteProperty -Name 'MB Vendor' -Value (Get-WmiObject Win32_BaseBoard).manufacturer
    Add-Member -InputObject $report -MemberType NoteProperty -Name 'MB Model' -Value (Get-WmiObject Win32_BaseBoard).product
    Add-Member -InputObject $report -MemberType NoteProperty -Name Processor -Value (Get-WmiObject win32_processor).name
    $report


} -ComputerName $Scope | Select Computername,'Total RAM (gb)',processor | Format-Table -AutoSize
    }
    End
    {
    }
}
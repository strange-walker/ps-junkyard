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
    # $report | Select Computername,'Total RAM (gb)',processor | Format-Table -AutoSize
    }
}


function Get-HardWareInfo2
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
    }
    Process
{
        $report = @()
        foreach ($item in $Scope)
        {

            $data = (Invoke-Command -ScriptBlock {
                $rdata = New-Object -TypeName psobject
                Add-Member -InputObject $rdata -MemberType NoteProperty -Name Computername -Value (Get-WmiObject  win32_computersystem).name
                Add-Member -InputObject $rdata -MemberType NoteProperty -Name 'Total RAM (gb)' -Value ((Get-WmiObject  win32_computersystem).totalphysicalmemory / 1gb -as [int])
                Add-Member -InputObject $rdata -MemberType NoteProperty -Name 'MB Vendor' -Value (Get-WmiObject Win32_BaseBoard).manufacturer
                Add-Member -InputObject $rdata -MemberType NoteProperty -Name 'MB Model' -Value (Get-WmiObject Win32_BaseBoard).product
                Add-Member -InputObject $rdata -MemberType NoteProperty -Name Processor -Value (Get-WmiObject win32_processor).name
                $rdata
                } -ComputerName $item )
            $data
            
            
            

            $report += $data
        }
        
    
    
    }
    End
    {
    $report | Select Computername,'Total RAM (gb)',processor | Format-Table -AutoSize
    }
}


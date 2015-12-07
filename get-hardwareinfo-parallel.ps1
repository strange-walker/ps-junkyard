<#
.Synopsis
   Краткое описание
.DESCRIPTION
   Длинное описание
.EXAMPLE
   Пример использования этого командлета
.EXAMPLE
   Еще один пример использования этого командлета
#>
function Get-HardwareInfo
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Справочное описание параметра 1
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Scope='localhost'
    )

    Begin
    {

    }
    Process {
        if ($Scope.count -gt 1) {
            $result = $Scope | Get-HardwareInfo
            }
        else {
            #actual queries here
            }

        }
    End
    {
    }
}
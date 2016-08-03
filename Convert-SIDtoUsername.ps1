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
 function Convert-SIDtoUsername {
     [CmdletBinding()]
     [Alias()]
     [OutputType([int])]
     Param (
         # Справочное описание параметра 1
         [Parameter(Mandatory=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0)]
         $SID
         )
     Begin {     }
     Process {
        $objSID = New-Object System.Security.Principal.SecurityIdentifier($SID)
        $objUser = $objSID.Translate( [System.Security.Principal.NTAccount] )
        $objUser.Value 
        }
     End {     }
 }
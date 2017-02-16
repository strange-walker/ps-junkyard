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
function Get-LocalGroupMembers {
    [CmdletBinding()]
    Param (
        # Справочное описание параметра 1
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]]$GroupName
        )
    Begin {
        }
    Process {
        foreach ($item in $GroupName) {
            try {
                $wmi = Get-WmiObject -Class win32_group -Filter "name='$item'" -ErrorAction Stop
                $currentGroup = [ordered]@{
                    GroupName = $item
                    SID = $wmi.sid
                    Domain = $wmi.domain
                    MemberUsers = ''
                    MemberGroups = ''
                    }
                }
            catch {
                $currentGroup = [ordered]@{
                    GroupName = $item
                    SID = "Group Not Found"
                    }
            
                }
            finally {
                New-Object -Property $currentGroup -TypeName psobject
                }
            }
        }
    End {
        }
    }


Get-LocalGroupMembers -GroupName Администраторы
Get-LocalGroupMembers -GroupName Администрато


<#
$name = 'Администраторы'
$t1 = Get-WmiObject -Class win32_group -Filter "name='$name'"

foreach ($item in $t2)
{
    Write-Host "============================"
    $item | gm
}

#>
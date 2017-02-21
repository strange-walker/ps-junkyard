<#
.Synopsis
   Returns info on local security group
.DESCRIPTION
   Based on group name, returns its SID and members
.EXAMPLE

PS C:\WINDOWS\system32> Get-LocalGroupMembers -GroupName Admins

GroupName   : Admins
GroupStatus : NotFound
SID         : 
Domain      : 
Members     : 

.EXAMPLE

PS C:\WINDOWS\system32> Get-LocalGroupMembers -GroupName Administrators


GroupName   : Administrators
GroupStatus : Found
SID         : S-1-5-32-544
Domain      : DEMO
Members     : {DEMO\Administrator, DEMO\strage}

#>
function Get-LocalGroupMembers {
    [CmdletBinding()]
    Param (
        # Names of groups to be queried.
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
                $members = $wmi.GetRelated() | where {($_.Caption -ne $null) -and ($_.sid -ne $null)}
                $currentGroup = [ordered]@{
                    GroupName = $item
                    GroupStatus = 'Found'
                    SID = $wmi.sid
                    Domain = $wmi.domain
                    Members = $members.caption
                    }
                }
            catch {
                $currentGroup = [ordered]@{
                    GroupName = $item
                    GroupStatus = 'NotFound'
                    SID = $null
                    Domain = $null
                    Members = $null
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
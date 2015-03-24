function Get-FSMORoles {
#get list of forest fsmo servers
    $domain = Get-ADDomain
    $forest = Get-ADForest
    $fsmo = @{InfrastructureMaster = $domain.InfrastructureMaster 
              PDCEmulator = $domain.PDCEmulator 
              RIDMaster = $domain.RIDMaster 
              DomainNamingMaster = $forest.DomainNamingMaster 
              SchemaMaster = $forest.SchemaMaster
              }
    #$fsmo
    $object = New-Object -TypeName PSObject -Property $fsmo
    $object
}

#herecy grows here

$fsmo1 = Get-FSMORoles
$fsmo2 = Get-ADDomain | select RIDMaster, InfrastructureMaster, PDCEmulator
Get-Member -InputObject $fsmo1
Get-Member -InputObject $fsmo2
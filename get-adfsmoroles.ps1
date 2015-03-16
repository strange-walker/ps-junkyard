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
    $fsmo
}

#herecy grows here

$fsmo = Get-ADDomain | select RIDMaster, InfrastructureMaster, PDCEmulator
$fsmoS
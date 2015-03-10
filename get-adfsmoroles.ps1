function Get-FSMORoles {
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
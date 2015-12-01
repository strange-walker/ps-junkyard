$NetRaw = net view
$netbios = @()

#extract netbios names from raw data
foreach ($item in $NetRaw)
{
     if ($item[1] -eq "\" ) 
        { 
        $netbios += $item.Substring(2, $item.IndexOf(" "))
        }

}


#query each machine and test if it is master browser
foreach ($item in $netbios)
{

    if ((select-string -pattern "MSBROWSE" -InputObject (nbtstat -a $item)) -ne $null)
    {
        $result = $item
    }

}


$result
$NetRaw = net view
$netbios = @()

#extract netbios names from raw data
foreach ($item in $NetRaw)
{
     if ($item[1] -eq "\" ) 
        { 
        $temp = $item.Trim("\"," ")
        $temp = $temp.split(' ')[0] 
        $netbios += $temp
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
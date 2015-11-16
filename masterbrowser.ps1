$NetRaw = net view
$netbios = @()

#extract netbios names from raw data
foreach ($item in $NewRat)
{
     if ($item[1] -eq "\" ) 
        { 
        $temp = $item.Trim("\"," ")
        $temp = $temp.split(' ')[0] 
        $netbios += $temp
        }

}


foreach ($item in $netbios)
{

    if ((select-string -pattern "MSBROWSE" -InputObject (nbtstat -a $item)) -ne $null)
    {
        $result = $item
    }

}


$result
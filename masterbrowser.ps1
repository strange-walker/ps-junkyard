$test = net view

$netbios = @()
foreach ($item in $test)
{
#$item[1]
     if ($item[1] -eq "\" ) 
        { 
        $temp = $item.Trim("\"," ")
        #$temp = $temp.Substring(0, $temp.IndexOf(' '))
        $temp = $temp.split(' ')[0] 
        $netbios += $temp
        }

}

$netbios



$out = @()

foreach ($item in $netbios)
{
    $out += (nbtstat -a $item)
}


$out > D:\scripts\mb.txt


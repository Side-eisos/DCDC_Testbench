function Remove-CRLF ($str)
{
    return ($str -replace "`t|`n|`r","")
}

$ports=[System.IO.Ports.SerialPort]::getportnames()

$available_instruments = @("KORAD-KEL103 V1.00 SN:07937623", "GWInstek,GDM8341,GEU830188,1.04" ,"ITECH Ltd., IT6724C, 802136083737810069,  1.11-1.04")


#List Instrument available
$x=''
if($ports -in $x)
{
    Write-host "No instrument detected"
}
else
{
    foreach ($port_name in $ports)
    {
        if($port_name -eq "COM24")
        {
            $port_tmp = new-Object System.IO.Ports.SerialPort $port_name, 460800, None, 8, one
            $port_tmp.ReadTimeout = 300;
            $port_tmp.WriteTimeout = 300;
            $port_tmp.open() 
        }
        else
        {
            $port_tmp = new-Object System.IO.Ports.SerialPort $port_name, 9600, None, 8, one
            $port_tmp.ReadTimeout = 300;
            $port_tmp.WriteTimeout = 300;
            $port_tmp.open() 
        }
        try 
        {
            $port_tmp.WriteLine(“*IDN?”)
            $a=$port_tmp.ReadLine()
            $id=(Remove-CRLF ($a))
            if ($available_instruments -eq $id)
            {
                Write-host "`nIntrument :"$id "connected on port"$port_name 
                if($id -eq $available_instruments[2])
                {
                Write-Host "Ok for ITECH"
                    $port_tmp.WriteLine("SYST:REM")
                    $port_tmp.WriteLine("OUTP OFF")
                    
                }
                elseif($id -eq $available_instruments[1])
                {
                    $port_tmp.WriteLine("SYST:REM")
                    Write-Host "Ok for GWInstek"
                }
                elseif($id -eq $available_instruments[0])
                {
                    $port_tmp.WriteLine(“:FUNC CC”)
                    $port_tmp.WriteLine(“:INP OFF”)
                    Write-Host "Ok for TENMA"
                }
            }
            else
            {
                Write-host "The instrument("$id ")is not used in the DC-DC testbench"
            }
        }
        catch 
        { 
            Write-host "Délai d'attente expiré pour IDN du port $port_name"
        }

        finally 
        {
            $port_tmp.close()
        }
    }
}


pause



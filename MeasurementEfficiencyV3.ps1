#Function to remove \n \r in a string
function Remove-CRLF ($str)
{
    return ($str -replace "`t|`n|`r","")
}
#Get Path
$files=Get-ChildItem $MyInvocation.MyCommand.source
$element=$files.fullname.split("\")

$outputname=""

#Split the path into several folder(string)
for ($i=0; $i -lt ($element.Length)-2; $i++)
{
    $outputname=$outputname+$element[$i]+"\"
}
$outputname=$outputname+"data"

#Get port COM
$ports=[System.IO.Ports.SerialPort]::getportnames()

#Creation Object Instrument, Not used yet
$Instrument =[pscustomobject]@{Name='';Id='';COM='';Baud=9600}

#Instruments used in the testbench
$available_instruments = @("KORAD-KEL103 V1.00 SN:07937623", "GWInstek,GDM8341,GEU830188,1.04" ,"ITECH Ltd., IT6724C, 802136083737810069,  1.11-1.04")

$check=0 #Counter of instrument

#List Instrument available
$x=''
if($ports -in $x)
{
    Write-host "No instrument detected"
    pause
}
else
{
    foreach ($port_name in $ports) #Creation of temporary port in order to get the IDN to compare with the instruments used
    {
       
        $port_tmp = new-Object System.IO.Ports.SerialPort $port_name, 9600, None, 8, one
        $port_tmp.ReadTimeout = 300;
        $port_tmp.WriteTimeout = 300;
        $port_tmp.open() 

        try 
        { 
            $port_tmp.WriteLine(“*IDN?”)
            $a=$port_tmp.ReadLine()
            $id=(Remove-CRLF ($a)) #Always remove the last CR or LF to compare
            if ($available_instruments -eq $id)
            {
                $check=$check+1
                Write-host "Intrument :"$id "connected on port"$port_name #Confirmation of detection
                if($id -eq $available_instruments[2])
                {
                    Write-Host "Itech detected"
                    $itech=[pscustomobject]$Instrument
                    $itech.Name='Itech'
                    $itech.id=$id
                    $itech.COM=$port_name
                    $port_ITECH = new-Object System.IO.Ports.SerialPort $port_name, $Instrument.Baud, None, 8, one #Creation the real port we'll use later
                }
                elseif($id -eq $available_instruments[1])
                {
                    Write-Host "Gwinstek detected"
                    $gwinstek=[pscustomobject]$Instrument
                    $gwinstek.Name='Gwinstek'
                    $gwinstek.id=$id
                    $gwinstek.COM=$port_name
                    $port_GWINSTEK = new-Object System.IO.Ports.SerialPort $port_name, $Instrument.Baud, None, 8, one
                }
                else
                {
                    Write-Host "Tenma detected"
                    $tenma=[pscustomobject]$Instrument
                    $tenma.Name='Tenma'
                    $tenma.id=$id
                    $tenma.COM=$port_name
                    $port_TENMA = new-Object System.IO.Ports.SerialPort $port_name, $Instrument.Baud, None, 8, one
                }
                
            }
            else
            {
                Write-host "The instrument("$id ")is not used in the DC-DC testbench or new, copy the id in table of instrument to add an instrument"
                pause
            }
        }
        catch 
        { 
            Write-output "Délai d'attente expiré pour IDN du port $port_name"
            pause
        }

        finally 
        {
            
        }
        $port_tmp.close()
    }
    if($check -eq 3) #Condition to start the measurement
    {
	#Argument used via Scilab
        $maxcurrent=$args[0]
        $step=$args[1]
        $voltage=$args[2]
        $delay=$args[3]
        $mincurrent=$args[4]
        $file=$args[5]
        $currentcaliber=$args[6]
        if($currentcaliber -eq "0.5") #Check if the current is below 0.5A to have more precision with the Gwinstek
        {
            Write-host "`n WARNING !! Please plug to the 0.5A port of the gwinstek`n"
            pause
        }
        else
        {
            Write-host "`n WARNING !! Please plug to the 12A port of the gwinstek`n"
            pause
        }
        #Create the path of the output file
        $filename = $file + ".csv"
        $path = $outputname
        $output_file = $path + "\" + $filename

        # Create the file
        New-Item -path $path -Name $filename -Value '' -ItemType file -force

        #Open every port and shut down input and output
        $port_ITECH.open() 
        $port_ITECH.WriteLine(“*IDN?”)
        $port_ITECH.ReadLine()
        $port_ITECH.WriteLine("SYST:REM")  # Required to tell the ITECH power supply it'll be remotely controlled
        $port_ITECH.WriteLine("OUTP OFF")

        $port_GWINSTEK.open() 
        $port_GWINSTEK.WriteLine(“*IDN?”)
        $port_GWINSTEK.ReadLine()

        $port_TENMA.open() 
        $port_TENMA.WriteLine(“*IDN?”)
        $port_TENMA.ReadLine()
        $port_TENMA.WriteLine("SYST:REM")
        $port_TENMA.WriteLine(“:FUNC CC”)
        $port_TENMA.WriteLine(“:INP OFF”)

        #$row = "In_V (meas);In_I (meas);Out_V (meas);Out_I (choosen);Out_P (meas)"
        #$row > $output_file

        #Start of the measurement
        $port_ITECH.WriteLine(“:VOLT $voltage”)
        $port_ITECH.WriteLine(":OUTP ON")
        Start-Sleep -Milliseconds 1000
        $port_TENMA.WriteLine(":INP ON")

        for ($i = $mincurrent ; $i -lt $maxcurrent; $i+=$step) #Loop to increase the current
        {
            echo ("Measure with out_I = " + $i)

            $port_TENMA.WriteLine(“:CURR ” + $i + "A")
    
            # We wait during hundreds of ms for the measure to stabilize
            Start-Sleep -Milliseconds $delay
    
            $port_ITECH.WriteLine(":MEAS:VOLT?")
            $a = $port_ITECH.ReadLine()
            $meas_In_V = Remove-CRLF ($a)
   
            $port_GWINSTEK.WriteLine(":MEAS:CURR:DC? "+ $currentcaliber);
            $a = $port_GWINSTEK.ReadLine()
            $meas_In_I = Remove-CRLF ($a)

            #$Pin=([double]($meas_In_V)*[double]($meas_In_I))

            $port_TENMA.WriteLine(":MEAS:VOLT?")
            $a = $port_TENMA.ReadLine()
            $meas_Out_V = (Remove-CRLF ($a)) -replace "V",""  # Remove the "V" outputed by the TENMA programmable load
     
            $port_TENMA.WriteLine(":MEAS:CURR?");
            $a = $port_TENMA.ReadLine()
            $meas_Out_I = (Remove-CRLF ($a)) -replace "A",""
        
            #$port_TENMA.WriteLine(":MEAS:POW?");
            #$a = $port_TENMA.ReadLine()
            #$meas_Out_P = (Remove-CRLF ($a)) -replace "W",""

            #$meas_Out_P = (([double]($meas_Out_I)+0.0008)*[double]($meas_Out_V))
    
            #$rend=([double]($meas_Out_P)/[double]($Pin))

            #Put data in the output file
            $row = "$meas_In_I,$meas_In_V,$meas_Out_I,$meas_Out_V"
    
            $row >> $output_file 
        }
        (Get-Content $output_file) | Set-Content $output_file -Encoding UTF8 #Change of the encoding
    
        $port_ITECH.WriteLine("OUTP OFF")
        $port_TENMA.WriteLine("INP OFF")

        #Close everything
        $port_ITECH.Close()
        $port_TENMA.Close()
        $port_GWINSTEK.Close()
    }
    else
    {
        #Print number of instrument detected
        Write-Host $check.ToString() "instrument detected, 3 needed, Itech/Tenma/Gwinstek `n"
        pause
    }
    
}
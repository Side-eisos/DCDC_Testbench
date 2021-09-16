#Get Path
$files=Get-ChildItem $MyInvocation.MyCommand.source
$element=$files.fullname.split("\")

$outputname=""

for ($i=0; $i -lt ($element.Length)-3; $i++)
{
    $outputname=$outputname+$element[$i]+"\"
}
$interface=$outputname+ "Efficiency0.3\file\InterfaceDC-DCcomparison.sce"
$interface="("+[char]034+$interface+[char]034+")"

$outputnamesci=($outputname+"scilab-6.1.0\bin\scilab -f "+$interface)

Write $outputnamesci


#C:\Software\scilab-6.1.0\bin\scilab -f ("C:\Software\efficiency0.3\powershell\InterfaceDC-DCcomparison.sce")
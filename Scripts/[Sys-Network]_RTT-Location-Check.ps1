<#
	.DESCRIPTION
		Extract & collect the members' name belonged in AD group defined as specific naming rules. 
	
	.PARAMETER
	.NOTES
		===========================================================================
		Created on:   	26th Jan., 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[Sys-Network]_RTT-Location-Check.ps1
		===========================================================================		
    .Configuration Mnagement
    2023.01.26
        : Script creation
    2023.01.26
        : UAT done
    2023.01.27
        : Upload in Git
#>

#$SG_GW = "apac-alpha.sra.corpshared.net"
$Test = "8.8.8.8"

$Result = Test-NetConnection -ComputerName $test -InformationLevel "Detailed"
$Result
$Result.PingReplyDetails.RoundtripTime;
#RTT(msec) = 2 * Distance / Speed(m/sec)
#RTT(sec)*1000*Speed(m/sec) = 2 * Distance
#Distance = RTT(sec)*1000*Speed(m/s)/2

#https://www.meter.net/tools/world-ping-test/

#https://www.powershellgallery.com/packages/ImportExcel/7.4.1
#Install-Module -Name ImportExcel -RequiredVersion 7.4.1
$c = @{};
$excel = "$env:userprofile\Desktop\rtt_country.xlsx"
$c = Import-Excel $excel -WorksheetName "Sheet1" -ImportColumns @(1, 3, 5) -startrow 1 -endrow 118
$c_avg = $c | Select-Object -ExpandProperty avg
[int32[]]$d = 1..$c_avg.Count;
$min = @();
$min_location = @();
for(($i=0),($j=0); $i -lt $c_avg.count; ($i++)) {
    $d[$i] = [Math]::abs([int32]$c_avg[$i] - [int32]$Result.PingReplyDetails.RoundtripTime);
    if($i -eq 0) {
        $min = $d[$i];
        $min_location = $c.Location[$i];
        } 
    if(($?) -and ($i -gt 0)) {
        if($d[$i] -le [int32]$min) {
            $min = $d[$i];
            $min_location = $c.Location[$i];
        }
    }
}
Write-host "As per the RTT value, the host location would be at $min_location";

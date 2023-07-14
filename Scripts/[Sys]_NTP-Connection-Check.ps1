<#
	.DESCRIPTION
		Check the NTP setting and configuration set on the client. 
	
	.PARAMETER

	.NOTES
		===========================================================================
		Created on:   	14th Jul., 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[Sys]_NTP-Connection-Check.ps1
		===========================================================================		

    .Configuration Mnagement
    2023.07.14
        : Script creation
    2023.07.14
        : Upload at Git
#>

# Get the value of "Type" from the registry
$Value = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" -Name "Type" | Select-Object -ExpandProperty Type

# Check if the value is NT5DS
if ($Value -eq "NT5DS") {
    $Public_value = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" -Name "NtpServer" | Select-Object -ExpandProperty NtpServer

    # Get NTP server configuration using w32tm command
    $ntpServer = & w32tm /query /status | Select-String -Pattern "Source:" | ForEach-Object {
        $_.ToString().Split(":")[1].Trim()
    }

    Write-Host "The NTP sesrver in public zone: $Public_value"

    if ($ntpServer) {
        Write-Host "The NTP server in inetneral zone:  $ntpServer"
    } else {
        Write-Host "  No NTP server found."
    }
} else {
    Write-Host "The NTP is not set with NT5DS. You may simply find out the NTP setting on your client."
    # Add any additional actions you want to perform if the condition is not met
    # ...
    # Shut down the script
    Exit
}

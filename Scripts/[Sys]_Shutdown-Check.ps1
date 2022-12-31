<#
	.DESCRIPTION
		To check who turn off the Windows server, the script is created. 
	
	.PARAMETER

	.NOTES
		===========================================================================
		Created on:   	3rd Sep., 2022
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	TBD
		===========================================================================		

    .Configuration Mnagement
    2022.09.03
        : Script creation
    2022.09.03
        : UAT done
#>

<#
[When execute the script taking much time, there're a few preparations we need to take care on the server itself.]
** Extract the shutdown log data from 1 Year ago as of now.
#>

Get-Date
Get-Date | Get-Member
$today = Get-Date
$todayDetails = $today.ToString("yyyy-MM-dd_HH-mm")

(Get-Date).AddDays(-366)
$today = Get-Date
$Days_defined = $Today.AddDays(-366)

Get-EventLog -LogName system -Source user32 |
Where-Object{($_.TimeGenerated -ge $Days_defined)} | Format-List * 

<#
[Extract the log data when the system was off by which account]
#>

Get-WinEvent -filterhash @{Logname = 'system';ID=1074} -MaxEvents 1000 | Select-Object @{Name="Computername";Expression = {$_.machinename}}, @{Name="UserName";Expression = {$_.UserId.translate([System.Security.Principal.NTAccount]).value}}, TimeCreated

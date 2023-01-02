<#
	.DESCRIPTION
		To check who accessed to the server directly via terminal access.
	
	.PARAMETER

	.NOTES
		===========================================================================
		Created on:   	3rd Sep., 2022
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[Sys-Security]_Mstsc-Access-Check.ps1
		===========================================================================		

    .Configuration Mnagement
    2022.09.03
        : Script creation
    2022.09.03
        : UAT done
    2022.12.31
        : Upload in Git.
#>

<#
[When someone accessed to the server via MSTSC or terminal session, the log data should be recorded]
#>

Get-Date
Get-Date | Get-Member
$today = Get-Date
$todayDetails = $today.ToString("yyyy-MM-dd_HH-mm")

(Get-Date).AddDays(-2)
$today = Get-Date
$Days_defined = $Today.AddDays(-2)

$folderpath = "$env:USERPROFILE\"
$destination = "$env:USERPROFILE\Desktop\$todayDetails.txt"
$Width = 1024

Get-WinEvent -LogName 'Microsoft-Windows-TerminalServices-LocalSessionManager/Operational' -MaxEvents 300 |
Select-Object TimeCreated, ID, ProviderName, LevelDisplayName, Message |
Where-Object {($_.TimeCreated -le $today) -or ($_.TimeCreated -ge $today)} |
Where-Object{$_.TimeCreated -gt $Days_defined} |
Out-file -FilePath $Destination

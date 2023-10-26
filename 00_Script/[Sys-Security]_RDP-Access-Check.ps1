<#
	.DESCRIPTION
		Check the RDP access through the Windows security event
	
	.PARAMETER

	.NOTES
		===========================================================================
		Created on:   	26th Oct. 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[Sys-Security]_RDP-Access-Check.ps1
		===========================================================================		

    .Configuration Mnagement
    2023.10.26
        : Script creation
    2023.10.26
        : UAT done
    2023.10.26
        : Upload in Git.
#>

$today = Get-Date
$startdate = $Today.AddDays(-1)
$enddate = $Today.AddDays(0)

$startdate = $startdate.ToString("dddd, MMMM dd, yyyy 00:00:00")
$enddate = $enddate.ToString("dddd, MMMM dd, yyyy 23:59:59")

Write-Host $startdate
Write-Host $enddate

$loginInfoArray = @()

$events = Get-WinEvent -FilterHashtable @{LogName='Security'; StartTime=$startdate; EndTime=$enddate} | Where-Object {$_.Id -eq 4624 -and $_.Message -match 'Account Name:\s+A191_a_*'}

if ($events) {
    foreach ($event in $events) {
        $messageLines = $event.Message -split "`r`n"
        $loginInfo = [PSCustomObject]@{
            TimeCreated = $event.TimeCreated
            AccountDomain = ($messageLines[15] | Where-Object { $_ -match 'Account Domain' }).Split(':')[1].Trim()
            AccountName = ($messageLines[14] | Where-Object { $_ -match 'Account Name' }).Split(':')[1].Trim()
            WorkstationName = ($messageLines[24] | Where-Object { $_ -match 'Workstation Name' }).Split(':')[1].Trim()
            SourceNetworkAddress = ($messageLines | Where-Object { $_ -match 'Source Network Address' }).Split(':')[1].Trim()
        }
        $loginInfoArray += $loginInfo
    }
} else {
    Write-Output "No matching events were found."
}

$loginInfoArray

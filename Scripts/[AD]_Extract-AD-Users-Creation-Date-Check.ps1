<#
	.DESCRIPTION
		Extract & collect the members' name belonged in AD group defined as specific naming rules. 
	
	.PARAMETER
	.NOTES
		===========================================================================
		Created on:   	15th Jan, 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[AD]_Extract-AD-Users-Creation-Date-Check.ps1
		===========================================================================		
    .Configuration Mnagement
    2023.01.15
        : Script creation
    2023.01.15
        : UAT done
    2023.01.15
        : Upload in Git
#>

$D_D = 1
$D_M = 1
$D_Y = 2021

Get-Date
Get-Date | Get-Member
$Date = Get-Date
$today = $date.ToString("yyyy-MM-dd")
$todayDetails = $date.ToString("yyyy-MM-dd_HH-mm")

$DeletionPath = "$env:USERPROFILE\"
$DestinationPath = "$env:USERPROFILE\Desktop\$todayDetails.csv"
$Width = 10240

$LDAP_Path = "";
$Attributes = @("Name", "SamAccountName", "EmailAddress", "Department", "Manager", "WhenCreated")

$BasementDate = Get-Date -Month $D_M -Day $D_D -Year $D_Y
$DTK_all = New-Object -TypeName 'System.Collections.ArrayList';
$Filtered_DTK_all = New-Object -TypeName 'System.Collections.ArrayList';

$DTK_all = Get-ADUser -Filter * -SearchBase $LDAP_Path -Properties * | Select-Object $Attributes

$Filtered_DTK_all = $DTK_all | Where-Object {$_.WhenCreated -lt $BasementDate};
$Filtered_DTK_all | Format-Table $Attributes -AutoSize | Out-string -Width $Width | Out-File $DestinationPath;

<#
	.DESCRIPTION
		Extract & collect the user list belonged in AD group having specific value. 
	
	.PARAMETER

	.NOTES
		===========================================================================
		Created on:   	5th Dec., 2022
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[AD]_Extract-Userlist-with-Regex-Check.ps1
		===========================================================================		

    .Configuration Mnagement
    2022.12.05
        : Script creation
    2022.12.05
        : UAT done
    2022.12.06
        : Add Key valuable to collect a specific info, then UAT done
    2022.12.31
        : Upload in Git
#>
Get-Date
Get-Date | Get-Member
$Date = Get-Date
$today = $date.ToString("yyyy-MM-dd")
$todayDetails = $date.ToString("yyyy-MM-dd_HH-mm")

$Key_MBK = "3943"
$Key_DTK = "8524"
$key_MBMK = "3359"
$New_RD = @()
$New_MBK = @()
$New_MBMK = @()
$New_DTK = @()

$RD = Get-ADUser -Filter * -SearchBase "OU=Users, OU=_GlobalResources, OU=RD, OU=A191, DC=apac, DC=corpdir, DC=net" -Properties * | select-object Name, SamAccountName, EmailAddress, userAccountControl, lastLogonTimestamp, lastlogon, department, company, dcxSiteCode, Organization
$MBK = Get-ADUser -Filter * -SearchBase "OU=Users, OU=_GlobalResources, OU=A191, DC=apac, DC=corpdir, DC=net" -Properties * | select-object Name, SamAccountName, EmailAddress, userAccountControl, lastLogonTimestamp, lastlogon, department, company, dcxSiteCode, Organization
$DTK = Get-ADUser -Filter * -SearchBase "OU=Users, OU=_GlobalResources, OU=DTK, OU=A191, DC=apac, DC=corpdir, DC=net" -Properties * | select-object Name, SamAccountName, EmailAddress, userAccountControl, lastLogonTimestamp, lastlogon, department, company, dcxSiteCode, Organization
$MBMK = Get-ADUser -Filter * -SearchBase "OU=Users, OU=_GlobalResources, OU=MBMK, OU=A191, DC=apac, DC=corpdir, DC=net" -Properties * | select-object Name, SamAccountName, EmailAddress, userAccountControl, lastLogonTimestamp, lastlogon, department, company, dcxSiteCode, Organization

Foreach($i in $RD) {
    if($i.Organization -eq $key_MBK) {
    $New_RD += $i
    }
}

Foreach($i in $MBK) {
    if($i.Organization -eq $key_MBK) {
    $New_MBK += $i
    }
}

Foreach($i in $MBMK) {
    if($i.Organization -eq $key_MBMK) {
    $New_MBMK += $i
    }
}

Foreach($i in $DTK) {
    if($i.Organization -eq $key_DTK) {
    $New_DTK += $i
    }
}

$New_RD | export-csv -path "\\s191f0000004.kr191.corpintra.net\A191_S-SHARE\1. Company Information_All\IT\07. Service Desk\AD_Info\MBKRD\$todayDetails.csv"
$New_MBK | export-csv -path "\\s191f0000004.kr191.corpintra.net\A191_S-SHARE\1. Company Information_All\IT\07. Service Desk\AD_Info\MBK\$todayDetails.csv"
$New_DTK | export-csv -path "\\s191f0000004.kr191.corpintra.net\A191_S-SHARE\1. Company Information_All\IT\07. Service Desk\AD_Info\DTK\$todayDetails.csv"
$New_MBMK | export-csv -path "\\s191f0000004.kr191.corpintra.net\A191_S-SHARE\1. Company Information_All\IT\07. Service Desk\AD_Info\MBMK\$todayDetails.csv"

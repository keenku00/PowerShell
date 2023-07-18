<#
	.DESCRIPTION
		Extract & collect the members' name belonged in AD group defined as specific naming rules. 
	
	.PARAMETER
	.NOTES
		===========================================================================
		Created on:   	18th Apr., 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[AD]_Collect-AD-Groups-beonged-In-Account_2.ps1
		===========================================================================		
    .Configuration Mnagement
    2023.04.17
        : Script creation
    2023.04.18
        : UAT done
    2023.04.18
        : Upload in Git
#>

Get-Date
Get-Date | Get-Member
$today = Get-Date
$todayDetails = $today.ToString("yyyy-MM-dd_HH-mm")

# Define the path to the folder
$path = "C:\AD"

Start-Transcript -Path "C:\AD\$todayDetails.txt" -Append

# Replace the <OU path> variable with the distinguished name of the OU that you want to export group membership for
$ouPath = "OU=Users,OU=_GlobalResources,OU=DTK,OU=A191,DC=apac,DC=corpdir,DC=net"

# Replace the <output file path> variable with the path and file name where you want to save the output file
$outputFilePath = "$env:USERPROFILE\test2.csv"

# Get all AD accounts within the specified OU path
$accounts = Get-ADUser -Filter * -SearchBase $ouPath -Properties MemberOf

# Initialize an array to hold the group membership information
$groupMembership = @()

# Loop through each AD account and retrieve its group membership information
foreach ($account in $accounts) {
    # Get the group membership for the current account
    $groups = $account.MemberOf | ForEach-Object {Get-ADGroup $_}

    # Loop through each group and add its information to the group membership array
    foreach ($group in $groups) {
        $groupMembership += [PSCustomObject]@{
            AccountName = $account.Name
            AccountSamAccountName = $account.SamAccountName
            GroupName = $group.Name
            GroupSamAccountName = $group.SamAccountName
        }
    }
}

# Export the group membership information to a CSV file
$groupMembership | Export-Csv -Path $env:USERPROFILE$todayDetails -NoTypeInformation

Stop-Transcript

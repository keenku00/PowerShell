<#
	.DESCRIPTION
		Extract & collect the members' name belonged in AD group defined as specific naming rules. 
	
	.PARAMETER
	.NOTES
		===========================================================================
		Created on:   	20th Mar., 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[AD]_Collect-AD-Groups-beonged-In-Account.ps1
		===========================================================================		
    .Configuration Mnagement
    2023.03.20
        : Script creation
    2023.03.20
        : UAT done
    2023.03.20
        : Upload in Git
#>

Get-Date
Get-Date | Get-Member
$today = Get-Date
$todayDetails = $today.ToString("yyyy-MM-dd_HH-mm")

# Define the path to the folder
$path = "C:\AD"

# Check if the folder exists at the specified path
if (Test-Path -Path $path -PathType Container) {
    Write-Host "The folder '$path' exists."
} else {
    Write-Host "The folder '$path' does not exist."
    New-Item -ItemType Directory -Path $path
}

Start-Transcript -Path "C:\AD\$todayDetails.txt" -Append

# Specify the username for which to retrieve group membership
$username = ""

# Retrieve the Active Directory user object for the specified username
$user = Get-ADUser -Identity $username

# Retrieve the list of groups that the user is a member of
$groups = Get-ADPrincipalGroupMembership -Identity $user | Select-Object -ExpandProperty Name

# Output the list of groups
Write-Host "The user '$username' is a member of the following Active Directory groups:"
foreach ($group in $groups) {
    Write-Host "- $group"
}

Stop-Transcript

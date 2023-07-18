<#
	.DESCRIPTION
		Extracts a specific attribute stored in a user account belonging to a specific OU path. 
	
	.PARAMETER
	.NOTES
		===========================================================================
		Created on:   	8th Jun., 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[AD]_Collect-User-Attribute-Execution.ps1
		===========================================================================		
    .Configuration Mnagement
    2023.06.08
        : Script creation
    2023.06.08
        : UAT done
    2023.06.08
        : Upload in Git
#>

# Import the Active Directory module
Import-Module ActiveDirectory

# Specify the OU path
$ouPath = "OU=YourOU,DC=YourDomain,DC=com"  # Update with your OU path

# Specify the attribute name to retrieve
$attributeName = "AttributeToRetrieve"  # Update with the desired attribute name

# Get the user accounts from the OU
$users = Get-ADUser -Filter * -SearchBase $ouPath -Properties *

# Initialize an empty array to store the collected information
$collectedInfo = @()

# Iterate over the user accounts and collect the attribute value along with user information
foreach ($user in $users) {
    $info = [PSCustomObject]@{
        User = $user.SamAccountName
        Attribute = $attributeName
        Value = $user.$attributeName
    }
    $collectedInfo += $info
}

# Export the collected information to a CSV file
$collectedInfo | Export-Csv -Path "test.csv" -NoTypeInformation

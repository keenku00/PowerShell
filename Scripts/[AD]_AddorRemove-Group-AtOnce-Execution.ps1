<#
	.DESCRIPTION
		Add or remove the specific AD group from tons of AD accounts at once. 
	
	.PARAMETER

	.NOTES
		===========================================================================
		Created on:   	13rd June., 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[AD]_AddorRemove-Group-AtOnce-Execution.ps1
		===========================================================================		

    .Configuration Mnagement
    2023.06.13
        : Script creation
    2023.06.13
        : UAT done
    2023.06.13
        : Upload in Git
#>

# Set the variables
$ouPath = "The specific OU path including the all AD accounts"  # Specify the OU path where the accounts reside
$groupName = "The AD group name"                # Specify the group name to add or remove
$operation = "Remove"                        # Specify "Remove" or "Add" for the operation

# Get all user accounts in the specified OU
$accounts = Get-ADUser -SearchBase $ouPath -Filter *

# Perform the operation for each account
foreach ($account in $accounts) {
    if ($operation -eq "Remove") {
        # Remove the user from the group
        Remove-ADGroupMember -Identity $groupName -Members $account -Confirm:$false
        Write-Host "Removed $($account.Name) from the group $groupName."
    }
    elseif ($operation -eq "Add") {
        # Add the user to the group
        Add-ADGroupMember -Identity $groupName -Members $account
        Write-Host "Added $($account.Name) to the group $groupName."
    }
    else {
        Write-Host "Invalid operation specified. Please use 'Remove' or 'Add'."
        break
    }
}

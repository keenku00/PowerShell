<#
	.DESCRIPTION
		The NTFS permission could be simply managed by using GUI, but it's such a burden operation.
    The following script was configured to retrieve the accounts and groups already implemented on the subfolders belonged in the parent folder.
	
	.PARAMETER
	.NOTES
		===========================================================================
		Created on:   	29th Jun., 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:       [File-Security]_NTFS-Permission_2-Execution.ps1
		===========================================================================		
    .Configuration Mnagement
    2023.06.29
        : Script creation
    2023.06.29
        : UAT done
    2023.06.29
        : Upload in Git
#>


# Define the parent folder path
$parentFolderPath = "parent_folder_path"

# Define the output file path
$outputFilePath = "permissions_report.csv"

# Get the subfolders within the parent folder
$subfolders = Get-ChildItem -Path $parentFolderPath -Directory

# Create an array to store the results
$results = @()

# Iterate over each subfolder
foreach ($subfolder in $subfolders) {
    $subfolderPath = $subfolder.FullName

    # Get the access control list (ACL) for the subfolder
    $acl = Get-Acl -Path $subfolderPath

    # Iterate over each access rule in the ACL
    foreach ($accessRule in $acl.Access) {
        $account = $accessRule.IdentityReference.Value
        $permissions = $accessRule.FileSystemRights

        # Create a custom object with the subfolder path, account, and permissions
        $result = [PSCustomObject] @{
            "Subfolder Path" = $subfolderPath
            "Account" = $account
            "Permissions" = $permissions
        }

        # Add the result to the array
        $results += $result
    }
}

# Export the results to a CSV file
$results | Export-Csv -Path $outputFilePath -NoTypeInformation

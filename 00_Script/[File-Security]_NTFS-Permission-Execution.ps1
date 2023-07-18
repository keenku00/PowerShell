<#
	.DESCRIPTION
		The NTFS permission could be simply managed by using GUI, but it's such a burden operation.
    The following scripts have been configured for convenience and automation.
	
	.PARAMETER
	.NOTES
		===========================================================================
		Created on:   	29th Jun., 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:       [File-Security]_NTFS-Permission-Execution.ps1
		===========================================================================		
    .Configuration Mnagement
    2023.06.29
        : Script creation
    2023.06.29
        : UAT done
    2023.06.29
        : Upload in Git
#>

######################################################################################
#Option#2. Modify the groups for each folder
######################################################################################

# Define the path to the subfolder
$folderPath = "folder_path"

# Disconnect inheritance and remove existing inherited permissions
icacls $folderPath /inheritance:r

# Define the permissions for different accounts
$permissions = @{
    "NT AUTHORITY\SYSTEM"            = "(OI)(CI)F"
    "BUILTIN\Administrators"         = "(OI)(CI)F"
    "DOMAIN\IT-Admin-group-account"  = "(OI)(CI)F"
    "Domain\AD-Group-needed"         = "(OI)(CI)M"
}

# Apply the permissions to the folder
foreach ($account in $permissions.Keys) {
    $permission = $permissions[$account]
    icacls $folderPath /grant "${account}:$permission"
}

######################################################################################
#Option#1. Modify the groups at once
######################################################################################
# Define the path to the text file containing folder paths
$filePath = "folder_paths.txt"

# Read the folder paths from the text file
$folderPaths = Get-Content $filePath

# Define the permissions for different accounts
$permissions = @{
    "NT AUTHORITY\SYSTEM"            = "(OI)(CI)F"
    "BUILTIN\Administrators"         = "(OI)(CI)F"
    "DOMAIN\IT-Admin-group-account"  = "(OI)(CI)F"
    "Domain\AD-Group-needed"         = "(OI)(CI)M"
}

# Iterate over each folder path
foreach ($folderPath in $folderPaths) {
    # Trim any leading or trailing white spaces from the folder path
    $folderPath = $folderPath.Trim()

    # Disconnect inheritance and remove existing inherited permissions
    icacls $folderPath /inheritance:r

    # Apply the permissions to the folder
    foreach ($account in $permissions.Keys) {
        $permission = $permissions[$account]
        icacls $folderPath /grant "${account}:$permission"
    }
}

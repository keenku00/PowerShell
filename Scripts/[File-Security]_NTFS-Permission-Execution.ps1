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

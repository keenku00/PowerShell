<#
	.DESCRIPTION
		To collect shared permissions (SMB/CIFS shares) instead of NTFS permissions, we need to use a different approach.
    We can leverage the Get-SmbShare cmdlet in PowerShell to obtain information about the shared folders and their permissions.
	
	.PARAMETER
	.NOTES
		===========================================================================
		Created on:   	29th Jul., 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:       [File-Security]_Retrieve-SMB-CIFS-Shares-Permission-Extraction.ps1
		===========================================================================		
    .Configuration Mnagement
    2023.07.29
        : Script creation
    2023.07.29
        : UAT done
    2023.07.29
        : Upload in Git
#>

# Function to get shared permissions
function Get-SharedPermissions {
    param (
        [string]$shareName
    )

    $shareACL = Get-SmbShareAccess -Name $shareName

    $shareACL | ForEach-Object {
        [PSCustomObject]@{
            ShareName = $shareName
            AccountName = $_.AccountName
            AccessControlType = $_.AccessControlType
            AccessRight = $_.AccessRight
        }
    }
}

# Get all shared folders
$sharedFolders = Get-SmbShare | Select-Object -ExpandProperty Name

# Collect shared permissions information
$sharedPermissions = @()
foreach ($shareName in $sharedFolders) {
    $sharedPermissions += Get-SharedPermissions -shareName $shareName
}

# Display the collected information
$sharedPermissions | Format-Table -AutoSize

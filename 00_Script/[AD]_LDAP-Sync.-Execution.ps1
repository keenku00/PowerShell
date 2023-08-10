<#
	.DESCRIPTION
		Achieve the object values by using the LDAP function.
	
	.PARAMETER

	.NOTES
		===========================================================================
		Created on:   	28th Jul., 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[AD]_LDAP-Sync.-Execution.ps1
		===========================================================================		

    .Configuration Mnagement
    2023.07.27
        : Script creation
    2023.07.27
        : UAT done
    2023.07.28
        : Upload in Git
#>

# Define LDAP server and OU path
$LDAPServer = "ldap-test.net"
$OUPath = "OU=test02,OU=test01,DC=a,DC=b,DC=c"

# Hardcoded credentials (replace with actual domain credentials)
$Username = "test_id"
$Password = "password" | ConvertTo-SecureString -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $Username, $Password

# Import the ActiveDirectory module
Import-Module ActiveDirectory

# Connect to the LDAP server
try {
    $context = New-Object DirectoryServices.DirectoryEntry("LDAP://$LDAPServer", $credential.UserName, $credential.GetNetworkCredential().Password)
    $adSearcher = New-Object DirectoryServices.DirectorySearcher($context)
    $adSearcher.Filter = "(objectClass=user)"
    $adSearcher.SearchRoot = "LDAP://$OUPath"
    
    # Perform the search and retrieve user information
    $users = $adSearcher.FindAll()

    foreach ($user in $users) {
        $userProperties = $user.Properties

        # Retrieve and display the desired user information
        $displayName = $userProperties["displayName"]
        $samAccountName = $userProperties["sAMAccountName"]
        $email = $userProperties["mail"]
        $title = $userProperties["title"]
        $department = $userProperties["department"]

        Write-Output "Display Name: $displayName"
        Write-Output "SamAccountName: $samAccountName"
        Write-Output "Email: $email"
        Write-Output "Title: $title"
        Write-Output "Department: $department"
        Write-Output "-----------------------"
    }
}
catch {
    Write-Output "Error occurred: $_"
    if ($_.Exception.InnerException) {
        Write-Output "Inner exception: $($_.Exception.InnerException)"
    }
}

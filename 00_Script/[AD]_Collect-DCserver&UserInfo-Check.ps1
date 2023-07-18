Add-Type -AssemblyName System.DirectoryServices.AccountManagement

    # Get the user's email address based on the login account
    $context = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Domain)
    $user = [System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity($context, [System.DirectoryServices.AccountManagement.IdentityType]::SamAccountName, $env:USERNAME)
    $fromEmail = $user.EmailAddress
    $DCserver = [pscustomobject]$context.ConnectedServer

Write-host "The connected domain controller is $DCserver"
Write-host "The login account is using the mail address: $fromEmail"

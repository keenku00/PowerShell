<#
	.DESCRIPTION
		When the script ([Sys-Network]_IP-Change_2-Execution.ps1) is executed, a static IP would be entered into the network adapter. Then, the static IP setting should be deleted to prevent unintentional IP conflicts in the future.
	
	.PARAMETER
	.NOTES
		===========================================================================
		Created on:   	20th Jun. 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[Sys-Network]_IP-Change_2-Execution.ps1
		===========================================================================		
    .Configuration Mnagement
    2023.06.20
        : Script creation
    2023.06.20
        : UAT done
    2023.06.20
        : Upload in Git
#>

#Check if the network profile is established with corporate network or not.
$Net_profile = Get-NetConnectionProfile | Select-Object -ExpandProperty Name
$Result = $Net_profile -match 'corpdir.net'

#Input the administrative account to execute the script with admin. permission.
$User = ""

#Input the password coressponding to the administrative ID above.
$PWord = "" 

#Make the password encrypted
$PWord_secured = ConvertTo-SecureString -String $PWord -AsPlainText -Force

#Remove the existing variable set at first.
$PWord = Get-Random

#Create a new credential with the corporate network.
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord_secured

Invoke-Command $env:COMPUTERNAME -ScriptBlock {

# Get the network interface associated with the SSID
$interface = Get-NetAdapter | Where-Object {
    $_.Name -like "*Wi-Fi*" -and $_.Status -eq 'Up'
}

if ($interface -eq $null) {
    Write-Host "The network interface for the GLOBALCONNECT SSID was not found."
} else {
    # Reset the network adapter to obtain IP address and DNS settings automatically
    $interface | Set-DnsClient -ResetServerAddresses
    $interface | Set-NetIPInterface -DHCP Enabled
    $interface | Set-DnsClient -RegisterThisConnectionsAddress $true

    Write-Host "Network adapter $($interface.InterfaceAlias) settings reverted to obtain IP address and DNS settings automatically."
}

} -Credential $credential

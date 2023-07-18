<#
	.DESCRIPTION
		Once the end device gets an incorrect IP range from DHCP, it might not be easy to get it again correctly. So the following script was created to manually search for an available IP, then input it on user's PC. 
	
	.PARAMETER
	.NOTES
		===========================================================================
		Created on:   	20th Jun. 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[Sys-Network]_IP-Change_1-Execution.ps1
		===========================================================================		
    .Configuration Mnagement
    2023.06.20
        : Script creation
    2023.06.20
        : UAT done
    2023.06.20
        : Upload in Git
#>

#Check if the network profile is established with a corporate network or not.
$Net_profile = Get-NetConnectionProfile | Select-Object -ExpandProperty Name
$Result = $Net_profile -match 'corpdir.net'

#Input the administrative account to execute the script with the admin. permission.
$User = ""

#Input the password corresponding to the administrative ID above.
$PWord = "" 

#Make the password encrypted
$PWord_secured = ConvertTo-SecureString -String $PWord -AsPlainText -Force

#Remove the existing variable set at first.
$PWord = Get-Random

#Create a new credential with the corporate network.
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord_secured

Invoke-Command $env:COMPUTERNAME -ScriptBlock {


# Set the desired IP configuration
$ipAddress = "53.125.205."
$subnetMask = "255.255.255.0"
$defaultGateway = "53.125.205.1"
$primaryDNS = "53.91.146.25"
$secondaryDNS = "53.91.146.27"

# Function to check if an IP address is available
function Test-IPAvailability {
    param([string]$IPAddress)
    $ping = New-Object System.Net.NetworkInformation.Ping
    $reply = $ping.Send($IPAddress, 500) # Adjust the timeout (in milliseconds) based on your network environment
    
    return (-not ($reply.Status -eq 'Success'))
}

# Find an available IP address within the range
$availableIP = $null
for ($i = 254; $i -gt 1; $i--) {  # Start from 2 to avoid network and broadcast addresses
    $currentIP = $ipAddress + $i.ToString()
    if (Test-IPAvailability $currentIP) {
        $availableIP = $currentIP
        break
    }
}

if ($availableIP -eq $null) {
    Write-Host "No available IP address found within the range."
} else {
    # Get the network interface associated with the SSID
    $interface = Get-NetAdapter | Where-Object {
        $_.Name -like "*Wi-Fi*" -and $_.Status -eq 'Up'
    }

    if ($interface -eq $null) {
        Write-Host "The network interface for the GLOBALCONNECT SSID was not found."
    } else {
        # Remove any existing IP address configuration from the network adapter
        $interface | Remove-NetIPAddress -AddressFamily IPv4 -Confirm:$false
        
        # Assign the new static IP settings to the network adapter
        $interface | New-NetIPAddress -IPAddress $availableIP -PrefixLength 24 -DefaultGateway $defaultGateway
        $interface | Set-DnsClientServerAddress -ServerAddresses $primaryDNS, $secondaryDNS
        
        Write-Host "Static IP address $availableIP successfully configured on interface $($interface.InterfaceAlias)."
    }
}


} -Credential $credential

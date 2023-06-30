<#
	.DESCRIPTION
		After checking the authentication via the used IP range, connect the shared folder to the network drive.
	
	.PARAMETER
	.NOTES
		===========================================================================
		Created on:   	30th Jun., 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:       [File-Security]_Shared-folder-mapping-Execution.ps1
		===========================================================================		
    .Configuration Mnagement
    2023.06.30
        : Script creation
    2023.06.30
        : UAT done
    2023.06.30
        : Upload in Git
#>

# Define the enterprise network IP range
$enterpriseIPRange = "0.0.0.0/8"

# Get the IP addresses of all network interfaces on the PC
$networkInterfaces = Get-NetIPAddress | Where-Object { $_.AddressFamily -eq "IPv4" }

# Flag to indicate if the PC is connected to the enterprise network or VPN network
$connectedToEnterpriseNetwork = $false

# Check if any network interface has an IP address within the enterprise IP range
foreach ($interface in $networkInterfaces) {
    $ipAddress = $interface.IPAddress
    try {
        $pingResult = Test-Connection -ComputerName $ipAddress -Count 1 -Quiet -ErrorAction Stop
        if ($pingResult -and $ipAddress -like "53.*") {
            $connectedToEnterpriseNetwork = $true
            break
        }
    }
    catch {
        # Ignore errors and continue to the next network interface
    }
}

# Output the result based on the network connection
if ($connectedToEnterpriseNetwork) {

#####################################################################################
$driveMappings = @{
    "K" = "Shared folder path#1"
    "T" = "Shared folder path#2"
    "O" = "Shared folder path#3"
}

# Disconnect existing mappings for drive letters K, T, and O if they exist
$existingDrives = Get-PSDrive -PSProvider FileSystem | Where-Object {
    $_.Name -in $driveMappings.Keys
}
$existingDrives | ForEach-Object {
    $driveLetter = $_.Name
    $null = Remove-PSDrive -Name $driveLetter -Force 2>$null
}

# Map the network drives
$driveMappings.GetEnumerator() | ForEach-Object {
    $driveLetter = $_.Key
    $networkPath = $_.Value
    $null = New-PSDrive -Name $driveLetter -PSProvider FileSystem -Root $networkPath -Persist 2>$null
}

Write-Host "The 'O,T,K' network drives were connected.`nPlease run the program one more if's not connected.`n`n※Created by Jimmy"
#####################################################################################

}
else {
    Write-Host "Cannot execute the program.`nPlease connect to enterprise network(Office network or VPN) at first."
}

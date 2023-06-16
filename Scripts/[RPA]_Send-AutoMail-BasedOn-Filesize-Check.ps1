<#
	.DESCRIPTION
		In a NAS system environment, it is not easy to set a system policy to send a system mail when the storage utilization of a specific path or driver exceeds a predefined value.
    I created the following PS-based script to use these system mail policies without the NAS-built-in features.
	.PARAMETER
	.NOTES
		===========================================================================
		Created on:   	16th Jun., 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:       [RPA]_Send-AutoMail-BasedOn-Filesize-Check.ps1
		===========================================================================		
    .Configuration Mnagement
    2023.06.16
        : Script creation
    2023.06.16
        : UAT done
    2023.06.16
        : Upload in Git
#>

$threshold = 10  # Set the storage threshold percentage
$numberOfPaths = 2  # Set the number of folder paths to monitor

# Define the folder paths to monitor
$folderPaths = @(
    "\\test.nas.net\test01\test02\test03"
)
# Add more folder paths if needed

# Calculate the total storage usage percentage across the specified folder paths
$totalUsed = 0
$totalFree = 15GB

foreach ($path in $folderPaths) {
    $rootPath = $path -replace "(.*?\\).*", '$1'
    $drive = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -eq $rootPath }
    $totalUsed += (Get-ChildItem -Path $path -Recurse | Measure-Object -Property Length -Sum).Sum
    $totalFree += $drive.Free
}

$usedPercentage = (($totalUsed / ($totalUsed + $totalFree)) * 100).ToString("F2")

# Check if the usage exceeds the threshold
if ($usedPercentage -ge $threshold) {
    # SMTP server details
    $smtpServer = "SMTP relay server IP address"
    $smtpPort = "Pre-defined SMTP port"

    # Sender and recipient email addresses
    $sender = "Storage_Check_$env:COMPUTERNAME@daimler.com"
    $recipient = "recipient@test.net"

    # Email subject and body
    $subject = "File Storage Usage Alert"
    $body = "The dedicated storage size is: '$totalFree Byte' `n"
    $body += "The storage is checked on the file path: '$folderPaths' `n"
    $body += "The file storage usage has reached $usedPercentage%."


    # Create the email message
    $message = @{
        From = $sender
        To = $recipient
        Subject = $subject
        Body = $body
        SmtpServer = $smtpServer
        Port = $smtpPort
    }

    # Send the email
    Send-MailMessage @message
}

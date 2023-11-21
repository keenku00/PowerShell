<#
	.DESCRIPTION
		Delete all files mentioned in the file($fullPathsFile). 
	
	.PARAMETER

	.NOTES
		===========================================================================
		Created on:   	21st November, 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[File]_Deletion-Execution.ps1
		===========================================================================		

    .Configuration Mnagement
    2023.11.21
        : Script creation
    2023.11.21
        : UAT done
    2023.11.21
        : Upload in Git
#>

# Function to remove files and log the action
function RemoveFilesWithLog {
    param (
        [string[]]$filePaths,
        [string]$logFilePath
    )

    # Check if log file exists, if not, create it
    if (-not (Test-Path $logFilePath)) {
        New-Item -Path $logFilePath -ItemType File -Force | Out-Null
    }

    # Loop through each file path provided
    foreach ($filePath in $filePaths) {
        if (Test-Path $filePath -PathType Leaf) {
            try {
                # Remove the file
                Remove-Item -Path $filePath -Force -ErrorAction Stop

                # Log successful removal to the log file
                $logMessage = "File removed: $filePath"
                Add-Content -Path $logFilePath -Value $logMessage
                Write-Host $logMessage -ForegroundColor Green
            } catch {
                # Log errors if file removal fails
                $errorMessage = "Error removing file: $filePath - $_"
                Add-Content -Path $logFilePath -Value $errorMessage
                Write-Host $errorMessage -ForegroundColor Red
            }
        } else {
            # Log if file does not exist
            $notFoundMessage = "File not found: $filePath"
            Add-Content -Path $logFilePath -Value $notFoundMessage
            Write-Host $notFoundMessage -ForegroundColor Yellow
        }
    }
}

$Date = Get-Date
$today = $date.ToString("yyyy-MM-dd")
$todayDetails = $date.ToString("yyyy-MM-dd_HH-mm")

# Path to the file containing full paths
$fullPathsFile = \\path\Full-paths.txt"
$logFilePath = "$HOME\log_$todayDetails.txt"

# Read file paths using UTF-8 encoding
$filePathsToRemove = Get-Content -Path $fullPathsFile -Encoding UTF8

# Call the function to remove files with logging
RemoveFilesWithLog -filePaths $filePathsToRemove -logFilePath $logFilePath

<#
	.DESCRIPTION
		: As per MBK/DTK security policy, the all files belonged in "T" drive must be removed in case when they're over 1 day.
	
	.PARAMETER

	.NOTES

    .Configuration Mnagement
    2020.08.13
        : Script creation
    2022.03.04
        : Script was modified to remove the files on a daily basis, not an weekly basis.
#>
Get-date
$todayDetails = $today.ToString("yyyy-MM-dd_HH-mm")

(Get-Date).AddDays(-1)
$today = Get-Date
$DaysToDelete = $today.AddDays(-1)
$path = "\\s191f0000004.kr191.corpintra.net\a191_t-temp"

# Define the path to the folder
$logpath = "C:\AD_Temp-deletion"

# Check if the folder exists at the specified path, then the $path value is set the path to store the log data.
if (Test-Path -Path $logpath -PathType Container) {
    Write-Host "The folder '$logpath' exists."
} else {
    Write-Host "The folder '$logpath' does not exist."
    New-Item -ItemType Directory -Path $logpath
}

Start-Transcript -Path "$logpath\$todayDetails.txt" -Append

<#Exceptional cases#>
$Fi1 = "Data_older_than_1_day_will_be_periodically_deleted.txt"
$Fo1 = "KT"

$Main_path = Get-ChildItem -Path $path -include * -exclude $Fi1, $Fo1
$Main_path_2 = $Main_path | Where-Object {$_.LastWriteTime -lt $DaysToDelete}

foreach ($directory in $Main_path_2) {
    if (Test-Path $directory) {
        Remove-Item $directory -Force -Confirm:$false -ErrorAction SilentlyContinue
        Write-Host "File '$directory' deleted."
    } else {
        Write-Host "File '$directory' not found."
    }
}

Stop-Transcript

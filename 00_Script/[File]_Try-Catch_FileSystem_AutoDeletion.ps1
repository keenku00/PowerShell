<#
	.DESCRIPTION
		Add a Try-Catch block to remove temporary files daily without unexpected errors.
	
	.PARAMETER
	.NOTES
		===========================================================================
		Created on:   	7th Aug. 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[File]_Try-Catch_FileSystem_AutoDeletion.ps1
		===========================================================================		
    .Configuration Mnagement
    2023.08.07
        : Creation & scheduling.
#>

Get-Date
Get-Date | Get-Member
(Get-Date).AddDays(-1)
$today = Get-Date
$DaysToDelete = $Today.AddDays(-1)
[String]$Fi1 = "All_data_wil_be_deleted_on_a_daily_basis.txt"

[String]$Fo1 = "A001"

#Get-ChildItem -Path $path -include * -exclude $Fi1, $Fo1, $Fo1_sub | Where-Object {$_.LastWriteTime -lt $DaysToDelete} | Remove-Item -Recurse -Force 


# Your existing code to generate and export the CSV
$csvExportSuccess = $false
$csvExportPath = "\\testpath\test"

try {
    Get-ChildItem -Path $csvExportPath -include * -exclude $Fi1, $Fo1 | Where-Object {$_.LastWriteTime -lt $DaysToDelete} | Remove-Item -Recurse -Force 
    $csvExportSuccess = $true
    Write-Host "Deletion successful."
}
catch {
    Write-Host "Deletion failed."
}

# Check if CSV export failed
if (-not $csvExportSuccess) {
    # First workaround
    try {
        Get-ChildItem -Path "\\testpath.suffix.net\test" -include * -exclude $Fi1, $Fo1, $Fo1_sub | Where-Object {$_.LastWriteTime -lt $DaysToDelete} | Remove-Item -Recurse -Force

        Write-Host "Workaround 1: Deletion successful."
    }
    catch {
        Write-Host "Workaround 1: Deletion failed."

        # Second workaround
        try {
            Get-ChildItem -Path "\\10.10.0.97\test" -include * -exclude $Fi1, $Fo1, $Fo1_sub | Where-Object {$_.LastWriteTime -lt $DaysToDelete} | Remove-Item -Recurse -Force

            Write-Host "Workaround 2: Deletion successful."
        }
        catch {
            Write-Host "All workaround attempts failed. Deletion unsuccessful."
        }
    }
}

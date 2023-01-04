<#
	.DESCRIPTION
		: Corporate policy requires all files stored in a temporary path to be deleted based on a reference date.
	
	.PARAMETER

	.NOTES

    .Configuration Mnagement
    2020.08.13
        : Script creation
    2022.03.04
        : Script was modified to remove the files on a daily basis, not an weekly basis.
    2022.12.31
        : Upload in Git
#>
Get-Date
Get-Date | Get-Member
(Get-Date).AddDays(-1)
$today = Get-Date
$DaysToDelete = $Today.AddDays(-1)

#The path needs to be handled should be clarified in the array below.
$path = "PATH needed to be handled"

<#Exceptional cases#>
$Fi1 = "Data_older_than_1_day_will_be_periodically_deleted.txt"
$Fo1 = "KT"
$Fo2 = "A002"

$Main_path = Get-ChildItem -Path $path -include * -exclude $Fi1, $Fo1, $Fo2
$Main_path_2 = $main_path | Where-Object {$_.LastWriteTime -lt $DaysToDelete} | Remove-Item -Recurse -Force -Confirm:$false

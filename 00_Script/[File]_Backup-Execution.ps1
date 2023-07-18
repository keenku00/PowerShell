<#
	.DESCRIPTION
		Copy&paste the files stored in specific path, then remove existing files. 
	
	.PARAMETER

	.NOTES
		===========================================================================
		Created on:   	8th November, 2022
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	TBD.ps1
		===========================================================================		

    .Configuration Mnagement
    2022.11.08
        : Script creation
    2022.11.08
        : UAT done
    2022.12.31
        : Upload in Git
#>

Start-Transcript -Path "$env:USERPROFILE\Desktop\log.txt" -Append

$D_D = 1
$D_M = 11
$D_Y = 2022

Get-Date
Get-Date | Get-Member
$Date = Get-Date
$today = $date.ToString("yyyy-MM-dd")
$todayDetails = $date.ToString("yyyy-MM-dd_HH-mm")

$DeletionPath = "$env:USERPROFILE\Downloads\"
$Destination = "$env:USERPROFILE\Desktop\"
$DestinationPath = "$env:USERPROFILE\Desktop\$todayDetails.txt"
$Width = 10240

<##Previous script to extract the log data ##>
<#
$DeletionDate = Get-Date -Month $D_M -Day $D_D -Year $D_Y
$Data_legacy = Get-ChildItem -path $DeletionPath\* -Include * -Recurse | select directoryname, Mode, LastWriteTime, Length, Name, lastaccesstime
$Data = $Data_legacy | where-Object {$_.lastaccesstime -lt $DeletionDate} |
Where-Object{($_.Mode -eq "-a----") -or ($_.Mode -eq "-ar---") -or ($_.Mode -eq "-a-h--")} |
Format-Table LastAccessTime, Mode, DirectoryName, Name, Length -AutoSize | Out-String -Width $Width |
out-file -FilePath $DestinationPath

$source = 'C:\Users\leejimm\Desktop\' 
$destination = 'C:\Users\leejimm\backup\' 
$date = (Get-Date).AddDays(-90) 
#>
 
$DeletionDate = Get-Date -Month $D_M -Day $D_D -Year $D_Y
$Data_legacy = Get-ChildItem -path $DeletionPath\* -Include * -Recurse | select directoryname, Mode, LastWriteTime, Length, FullName, Name, lastaccesstime
$Data = $Data_legacy | where-Object {$_.LastAccessTime -lt $DeletionDate} |
Where-Object{($_.Mode -eq "-a----") -or ($_.Mode -eq "-ar---") -or ($_.Mode -eq "-a-h--")}

<#| Format-Table LastAccessTime, Mode, DirectoryName, Name, Length -AutoSize | Out-String -Width $Width |
out-file -FilePath $DestinationPath
#>

$Data | ForEach-Object{ 
    $directory=$destination+($_.lastaccesstime).ToString('MM-dd-yyyy') 
    if(-not (Test-Path -Path $directory)){ 
        New-Item -Path $directory -ItemType Directory 
        }  
        
        $CodeExecution = Copy-Item -Path $_.FullName -Destination $directory 
        if($?){
        echo $_.FullName "Copy command succeeded"
        Remove-Item -Path $_.FullName
            if($?){
            echo $_.FullName "Deletion command succeeded"
            }
            else{
            echo $_.FullName "Deletion command failed"
            }
        }
        else{
        echo $_.FullName "Copy command failed"
        }
    } 

$ResultData = $Data | Format-Table LastAccessTime, Mode, DirectoryName, Name, Length -AutoSize | Out-String -Width $Width |
out-file -FilePath $DestinationPath

Stop-Transcript

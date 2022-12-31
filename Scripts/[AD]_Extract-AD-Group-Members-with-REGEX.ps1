<#
	.DESCRIPTION
		Extract & collect the members' name belonged in AD group defined as specific naming rules. 
	
	.PARAMETER

	.NOTES
		===========================================================================
		Created on:   	25th Nov., 2022
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	
		===========================================================================		

    .Configuration Mnagement
    2022.11.25
        : Script creation
    2022.11.25
        : UAT done
    2022.12.31
        : [AD]_Extract-AD-Group-Members-with-REGEX.ps1
#>

Get-Date
Get-Date | Get-Member
$today = Get-Date
$todayDetails = $today.ToString("yyyy-MM-dd_HH-mm")

Start-Transcript -Path "C:\AD\O_Drive-Group_log\$todayDetails.txt" -Append

$All_DTK_Goup = get-adgroup -filter * -SearchBase "OU=A191, DC=apac, DC=corpdir, DC=net" -Properties * | select -ExpandProperty Name
$regex = 'A191_O-DTK-'
$O_DTK_Group = @()

foreach($i in $All_DTK_Goup) {
    if($i -match $regex) {
        Write-host $i
        Get-ADGroupMember -identity $i | select name
        $O_DTK_Group += $i } 
}​

$Inputstring = $O_DTK_Group
$CharArray =$InputString.Split(" ")
$CharArray

Stop-Transcript

Start-Transcript -Path "C:\AD\K_Drive-Group_log\$todayDetails.txt" -Append

$All_K_Goup = get-adgroup -filter * -SearchBase "OU=A191, DC=apac, DC=corpdir, DC=net" -Properties * | select -ExpandProperty Name
$regex2 = 'A191_K-'
$K_DTK_Group = @()

foreach($i in $All_K_Goup) {
    if($i -match $regex2) {
        Write-host $i
        Get-ADGroupMember -identity $i | select name
        $K_DTK_Group += $i } 
}​

$Inputstring2 = $K_DTK_Group
$CharArray2 =$InputString2.Split(" ")
$CharArray2

Stop-Transcript

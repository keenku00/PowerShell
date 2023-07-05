<#
	.DESCRIPTION
		Extract & collect the members' names belonging to the AD group defined by specific naming rules. 
	
	.PARAMETER

	.NOTES
		===========================================================================
		Created on:   	5th Jul. 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[AD]_Extract-AD-Group-Members-with-REGEX_2.ps1
		===========================================================================		

    .Configuration Mnagement
    2023.07.05
        : Script creation
    2023.07.05
        : UAT done
    2023.07.05
        : Upload in Git
#>

#Condition_1
$All_K_Group = Get-ADGroup -Filter * -SearchBase "OU=A191, DC=apac, DC=corpdir, DC=net" -Properties *
$regex2 = 'A191_K-'
$groupData = @()

foreach ($group in $All_K_Group) {
    if ($group.Name -match $regex2) {
        Write-Host $group.Name
        $groupMembers = Get-ADGroupMember -Identity $group.Name | Select-Object Name
        $groupData += New-Object -TypeName PSObject -Property @{
            GroupName = $group.Name
            Members = $groupMembers.Name -join ', '
        }
    }
}

$groupData | Export-Csv -Path "$regex2_AD_Groups_Information.csv" -NoTypeInformation


#Condition_2
$All_K_Group = Get-ADGroup -Filter * -SearchBase "OU=A191, DC=apac, DC=corpdir, DC=net" -Properties *
$regex1 = 'A191_O-'
$groupData = @()

foreach ($group in $All_K_Group) {
    if ($group.Name -match $regex2) {
        Write-Host $group.Name
        $groupMembers = Get-ADGroupMember -Identity $group.Name | Select-Object Name
        $groupData += New-Object -TypeName PSObject -Property @{
            GroupName = $group.Name
            Members = $groupMembers.Name -join ', '
        }
    }
}

$groupData | Export-Csv -Path "$regex1_AD_Groups_Information.csv" -NoTypeInformation

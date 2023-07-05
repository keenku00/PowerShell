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

#Condition_2
$All_2_Group = Get-ADGroup -Filter * -SearchBase "OU=A191, DC=apac, DC=corpdir, DC=net" -Properties *
$regex2 = 'A191_K-'
$groupData = @()
$pattern = 'sAMAccountName="([^"]*)"'

foreach ($group in $All_2_Group) {
    $matches = [regex]::Matches($group.dcxObjectOwner, $pattern)
    $accountNames = foreach ($match in $matches) {
    $match.Groups[1].Value
    }
    if ($group.Name -match $regex2) {
        Write-Host $group.Name
        $groupMembers = Get-ADGroupMember -Identity $group.Name | Select-Object Name
        $groupData += New-Object -TypeName PSObject -Property @{
            GroupName = $group.Name
            Members = $groupMembers.Name -join ', '
            Ownership = $accountNames -join ', '
        }
    }
}

$groupData | Export-Csv -Path "AD_Groups_Information_Type1.csv" -NoTypeInformation


#Condition_1
$All_1_Group = Get-ADGroup -Filter * -SearchBase "OU=A191, DC=apac, DC=corpdir, DC=net" -Properties *
$regex1 = 'A191_O-'
$groupData = @()
$pattern = 'sAMAccountName="([^"]*)"'

foreach ($group in $All_1_Group) {
    $matches = [regex]::Matches($group.dcxObjectOwner, $pattern)
    $accountNames = foreach ($match in $matches) {
    $match.Groups[1].Value
    }

    if ($group.Name -match $regex1) {
        Write-Host $group.Name
        $groupMembers = Get-ADGroupMember -Identity $group.Name | Select-Object Name
        $groupData += New-Object -TypeName PSObject -Property @{
            GroupName = $group.Name
            Members = $groupMembers.Name -join ', '
            Ownership = $accountNames -join ', '
        }
    }
}

$groupData | Export-Csv -Path "AD_Groups_Information_Type2.csv" -NoTypeInformation

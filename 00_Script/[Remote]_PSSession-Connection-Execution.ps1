<#
	.DESCRIPTION
		Even the legacy files would be moved into the other path, the attribute value would be same as previous one. In order to change the value not to make it removed next time, the value should be changed as the new one.
	
	.PARAMETER

	.NOTES
		===========================================================================
		Created on:   	8th Nov., 2022
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[Remote]_PSSession-Connection-Execution.ps1
		===========================================================================		

    .Configuration Mnagement
    2022.11.08
        : Script creation
    2022.11.08
        : UAT done
    2023.01.01
        : Upload in Git
#>

#Input the user ID which's already having the administrative priviliage at the target server.
$User = ""

#Input the password coressponding to the user's ID above.
$PWord = "" 

#Input the target system's hostname.
$target_hostname = ""

#Make the password encrypted
$PWord_secured = ConvertTo-SecureString -String $PWord -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord_secured

#Overwrite the plain text as radom value.
$PWord = Get-Random

Enter-PSSession -ComputerName $target_hostname -Port 5985 -Credential $Credential

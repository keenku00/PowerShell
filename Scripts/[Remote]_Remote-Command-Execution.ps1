<#
	.DESCRIPTION
		When data should be collected from lots of Windows-based system, the following remote command could be utilized to collect the log data at once. 
	
	.PARAMETER

	.NOTES
		===========================================================================
		Created on:   	25th Nov., 2022
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	TBD
		===========================================================================		

    .Configuration Mnagement
    2022.11.25
        : Script creation
    2022.11.25
        : UAT done
    2023.01.01
        : Upload in Git
#>

#Define the file path including the server information
$path = "C:\Dumps\Scripts\servers.txt"

#Input the user ID
$User = ""

#Input the password coressponding to the user ID above.
$PWord = "" 

#Make the password encrypted
$PWord_secured = ConvertTo-SecureString -String $PWord -AsPlainText -Force

#Overwrite the plain text as radom value.
$PWord = Get-Random

$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord_secured

$servers= Get-Content $path
foreach($server in $servers) {
    Invoke-Command $server -ScriptBlock {
        #Define which command should be executed in the all server list
        (get-wmiobject win32_operatingsystem).caption
        } -Credential $credential
}

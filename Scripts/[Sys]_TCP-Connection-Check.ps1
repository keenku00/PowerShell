<#
	.DESCRIPTION
		To check which process is running with specific port# and service account under the TCP connection.
	
	.PARAMETER

	.NOTES
		===========================================================================
		Created on:   	14th July, 2022
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[Sys]_TCP-Connection-Check.ps1
		===========================================================================		

    .Configuration Mnagement
    2022.07.14
        : Script creation
    2022.07.16
        : UAT done
    2023.01.01
        : Upload in Git.
#>

#Collect all types of state no matter what the type is (ex. State: TimeWit, Listen, Established, Bound and etc.)
Get-NetTCPConnection |
Select-Object -Property LocalPort, State, @{name='ProcessID';expression={(Get-Process -IncludeUserName -Id $_.OwningProcess). ID}}, @{name='ProcessName';expression={(Get-Process -IncludeUserName -Id $_.OwningProcess). Path}}, @{name='User';expression={(Get-Process -IncludeUserName -Id $_.OwningProcess). Username}}  | 
Format-Table -Property * -AutoSize | Out-String -Width 4096

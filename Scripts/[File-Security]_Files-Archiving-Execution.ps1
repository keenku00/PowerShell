<#
	.DESCRIPTION
		Simple file archiving
	
	.PARAMETER
	.NOTES
		===========================================================================
		Created on:   	7th Feb., 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:       [File-Security]_Files-Archiving-Execution.ps1
		===========================================================================		
    .Configuration Mnagement
    2023.02.07
        : Script creation
    2023.02.07
        : UAT done
    2023.02.07
        : Upload in Git
#>
#Sample date 2023.03.01
$limit = Get-Date("3/1/2023")

#Destination path for archiving
$destination = "C:\Archived3"

#Destination path for archiving
$Source = $env:userprofile

Get-ChildItem -Path $Source -Recurse | Where-Object { $_.LastAccessTime -lt $limit } |
    Foreach-Object {
        $destinationPath = Join-Path $destination $_.FullName.Substring(3)
        if (!(Test-Path $destinationPath)) {
            New-Item -ItemType Directory -Path $destinationPath | Out-Null
        }
        Move-Item $_.FullName $destinationPath
    }

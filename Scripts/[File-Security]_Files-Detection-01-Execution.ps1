<#
	.DESCRIPTION
		Copy&paste the files stored in specific path, then remove existing files. 
	
	.PARAMETER
	.NOTES
		===========================================================================
		Created on:   	5th Jan., 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     [File-Security]_Files-Detection-01-Execution.ps1
		===========================================================================		
    .Configuration Mnagement
    2023.01.05
        : Script creation
    2023.01.05
        : UAT done
    2023.01.05
        : Upload in Git
#>
Function Get-FileDetection(){
$Drives = Get-PSDrive | Select-Object -ExpandProperty 'Name' | Select-String -Pattern '^[a-e]$'
$FileInfo = New-Object -TypeName 'System.Collections.ArrayList';

#The detection will be handled with the regular expression below.
$File_Extension = "*.txt" #Extension regex
$File_Name = @("*test*", "*jimmy*") #File name regex

#Detection scope is all drive built-in the server.
    ForEach($DriveLetter in $Drives)
    {
        $Drive = "$DriveLetter" + ":\"
        $Detected_Files = Get-ChildItem -Path $Drive -Include $File_Name -Filter $File_Extension -Recurse -File -ErrorAction SilentlyContinue | Select-Object FullName
        Foreach($file in $Detected_Files)
        {
            if(-not [string]::IsNullOrEmpty($file.FullName))
            {
                $Result = [PSCustomObject]@{
                        Hostname = $env:ComputerName
                        #Add Hash vaule for integrity
                        HASHVAULE = (Get-FileHash -Path $file.FullName -Algorithm SHA256).Hash
                        PATH = $file.FullName
                        }
            }
            [void]$FileInfo.Add($Result)
        }
    }
$FileInfo
}
$Result = Get-FileDetection
$Result | Out-String -Width 400

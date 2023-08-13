<#
	.DESCRIPTION
		Move or migrate the files stored in specific path. 
	
	.PARAMETER

	.NOTES
		===========================================================================
		Created on:   	13th August, 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[File]_Migration-Execution.ps1
		===========================================================================		

    .Configuration Mnagement
    2023.08.13
        : Upload in Git
#>

#--------------------------------------------------------------------------#
#Step#1 - Creation the subfolders at first to get the files from the source side.
#The folder name must be matched up with the source side.

$folders = @(
    "test01",
    "test02"
)

$parentFolderPath = "\\test.corpintra.net\shared_folder\parentfolder"

foreach ($folderName in $folders) {
    $fullPath = Join-Path -Path $parentFolderPath -ChildPath $folderName
    New-Item -Path $fullPath -ItemType Directory -Force
    Write-Host "Created folder: $fullPath"
}

#--------------------------------------------------------------------------#
#Step#2 Option#1 - Migration operation
# Define the source and destination paths
#Robocopy option: /E /MIR /SEC
$sourcePath = @(
    "test01",
    "test02"
)

$sourceRootPath = "\\test.corpintra.net\shared_folder\parentfolder"
$destinationRootPath = "\\test.corpintra.net\shared_folder_2\parentfolder"

# Define the robocopy command
$robocopyCommand = "robocopy.exe"

# Build the arguments for the robocopy command
foreach ($folderName in $sourcePath) {
    $sourceFolder = Join-Path -Path $sourceRootPath -ChildPath $folderName
    $destinationFolder = Join-Path -Path $destinationRootPath -ChildPath $folderName
    $arguments = "`"$sourceFolder`" `"$destinationFolder`" /E /MIR /SEC /R:5 /W:32 /LOG:`"$destinationFolder\log.txt`""
    
    # Execute the robocopy command
    Invoke-Expression "$robocopyCommand $arguments"
    
    Write-Host "Moved folder $folderName"
}

Write-Host "Folders moved successfully."

#--------------------------------------------------------------------------#
#Step#2 Option#2 - Move operation (Along with migration, remove the legacy files)
# Define the source and destination paths
#Robocopy option: /E /MOVE /SEC
$sourcePath = @(
    "test01",
    "test02"
)

$sourceRootPath = "\\test.corpintra.net\shared_folder\parentfolder"
$destinationRootPath = "\\test.corpintra.net\shared_folder_2\parentfolder"

# Define the robocopy command
$robocopyCommand = "robocopy.exe"

# Build the arguments for the robocopy command
foreach ($folderName in $sourcePath) {
    $sourceFolder = Join-Path -Path $sourceRootPath -ChildPath $folderName
    $destinationFolder = Join-Path -Path $destinationRootPath -ChildPath $folderName
    $arguments = "`"$sourceFolder`" `"$destinationFolder`" /E /MOVE /SEC /R:5 /W:32 /LOG:`"$destinationFolder\log.txt`""
    
    # Execute the robocopy command
    Invoke-Expression "$robocopyCommand $arguments"
    
    Write-Host "Moved folder $folderName"
}

Write-Host "Folders moved successfully."

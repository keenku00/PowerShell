<#
	.DESCRIPTION
		The important service commonly used by business users would be spooler service, but it's not smoothly supported when they got faced the issue since they're not highly likely having an administrative permission correctly. That's why the following script was created having the administrative credential.
	
	.PARAMETER

	.NOTES
		===========================================================================
		Created on:   	3rd Jan., 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[Sys]_Spooler-Execution.ps1
		===========================================================================		

    .Configuration Mnagement
    2022.01.03
        : Script creation
    2022.01.03
        : UAT done
    2022.01.03
        : Upload in Git
#>

#Check if the network profile is established with corporate network or not.
$Net_profile = Get-NetConnectionProfile | Select-Object -ExpandProperty Name
$Result = $Net_profile -match 'corpdir.net'

#Input the user ID
$User = "apac\a191_s_win10admin"

#Input the password coressponding to the user ID above.
$PWord = "PpdbS3:WD=>27yL.3nY&" 

#Make the password encrypted
$PWord_secured = ConvertTo-SecureString -String $PWord -AsPlainText -Force

#Remove the existing variable set at first.
$PWord = Get-Random

#Create a new credential with the corporate network.
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord_secured

#Invoke-Command $env:COMPUTERNAME -ScriptBlock {
#    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -ErrorAction SilentlyContinue } -Credential $credential

Add-Type -AssemblyName PresentationFramework

if($Result -ne "corpdir.net") {
    [System.Windows.MessageBox]::Show('Please connect to DAIMLER network at first. In case for using VPN, please utilize EmergencyVPN instead of Pulse VPN.','Spooler service','YesNoCancel','error') }
else {
    $msgBoxInput =  [System.Windows.MessageBox]::Show('Would you like to execute Spooler service?','Spooler service','YesNoCancel','question')
    switch  ($msgBoxInput) {
    'Yes' {
    ## Do something
    Invoke-Command $env:COMPUTERNAME -ScriptBlock {
    $PrintSpooler = Get-Service -Name Spooler
    # Logic to check Print Spooler Service and restart if not running
    if($PrintSpooler.Status -eq 'stopped') {
    # Start Print Spooler Service on local computer
    Start-Service $PrintSpooler }
    } -Credential $credential
        $PrintSpooler = Get-Service -Name Spooler
        if($PrintSpooler.Status -eq 'Running') {
            [System.Windows.Forms.MessageBox]::Show('Spooler service is running okay.','Information')
            }
        else {
            [System.Windows.Forms.MessageBox]::Show('Spooler service is still having an issue.','error')
            }
    }
    'No' {
        [System.Windows.Forms.MessageBox]::Show('Execution canceled.','Information')
    }
    'Cancel' {
        ## Do something
        [System.Windows.Forms.MessageBox]::Show('Execution canceled.','Information')
    }}
}

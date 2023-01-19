<#
	.DESCRIPTION
		To check which security patch was implemented via terminal access.
	
	.PARAMETER
	.NOTES
		===========================================================================
		Created on:   	19th Jan., 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[Sys-Security]_Remote-Security-Patch-Check.ps1
		===========================================================================		
    .Configuration Mnagement
    2023.01.19
        : Script creation
    2023.01.19
        : UAT done
    2023.01.19
        : Upload in Git.
#>

#Input the user ID which's able to manage/operate server.
$User = ""

#Input the password coressponding to the user ID above.
$PWord = ""

#Make the password encrypted
$PWord_secured = ConvertTo-SecureString -String $PWord -AsPlainText -Force

#Overwrite the plaintext password with a random value.
$PWord = Get-Random

$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord_secured

#Define the server list in the hash table value.
$infos = Import-Csv -Path "C:\Scripts\ServerList.csv"

$Connectfailed = @()

foreach($i in 0..($infos.count -1))
{
    Write-Host $infos[$i].blade -ForegroundColor Yellow
    #If the value comes out as "True", execute the if command.
    if(Test-Connection -ComputerName $infos[$i].ComputerName -Quiet)
    {
        Invoke-Command -ComputerName $infos[$i].ComputerName -ScriptBlock{
            $Session = New-Object -ComObject "Microsoft.Update.Session"
            $Searcher = $Session.CreateUpdateSearcher()
            $historyCount = $Searcher.GetTotalHistoryCount()
            $patch = $Searcher.QueryHistory(0, $historyCount) | Select-Object Date,
                @{name="Operation"; expression={switch($_.operation){
                    1 {"Installation"}; 2 {"Uninstallation"}; 3 {"Other"}}}},
                @{name="Status"; expression={switch($_.resultcode){
                    1 {"In Progress"}; 2 {"Succeeded"}; 3 {"Succeeded With Errors"};
                    4 {"Failed"}; 5 {"Aborted"}
            }}}, Title

            $today = (Get-Date)
            #Set the date one day before today as the reference point.
            $checkDate = $today.AddDays(-1)
            #Count the patched something
            $Patchresult = $patch | Where-Object {$_.Date -ge $checkDate}
            $Patchresult.count
            $Patchresult | Format-table * -AutoSize
        } -Credential $credential
    }
    else
    {
        $obj = New-Object PSObject -Property @{
        ConnectedFail = $infos[$i].ComputerName
        }
    }
    $Connectfailed += $obj
}
$Connectfailed | Format-Table ConnectedFail -AutoSize

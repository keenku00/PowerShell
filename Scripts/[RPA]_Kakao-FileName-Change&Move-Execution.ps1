<#
	.DESCRIPTION
		Once I tried to download many files in my laptop from Kakao messenger, they' normally stored in the pre-defined path with a random value such as "KakaoTalk_20230122_151558766".
    Not only it's too much burden on users, but it also would not be very difficult to figure out what the file is when it was not organized on time.
    That's why the script mentioned in this article was newly created under Powershell-based one.
	.PARAMETER
	.NOTES
		===========================================================================
		Created on:   	26th Jan., 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:       [RPA]_Kakao-FileName-Change&Move-Execution.ps1
		===========================================================================		
    .Configuration Mnagement
    2023.01.26
        : Script creation
    2023.01.26
        : UAT done
    2023.01.26
        : Upload in Git
#>

#Set-Executionpolicy -Scope CurrentUser -ExecutionPolicy UnRestricted

# TimeFramePicker.ps1
Add-Type -AssemblyName System.Windows.Forms

# Main Form
$mainForm = New-Object System.Windows.Forms.Form
$font = New-Object System.Drawing.Font(“Consolas”, 13)
$mainForm.Text = ” Pick Time Frame”
$mainForm.Font = $font
$mainForm.ForeColor = “Black”
$mainForm.BackColor = “White”
$mainForm.Width = 400
$mainForm.Height = 240

# DatePicker Label
$datePickerLabel = New-Object System.Windows.Forms.Label
$datePickerLabel.Text = “Date”
$datePickerLabel.Location = “15, 10”
$datePickerLabel.Height = 40
$datePickerLabel.Width = 90
$mainForm.Controls.Add($datePickerLabel)
 
# MinTimePicker Label
$minTimePickerLabel = New-Object System.Windows.Forms.Label
$minTimePickerLabel.Text = “Start time”
$minTimePickerLabel.Location = “15, 45”
$minTimePickerLabel.Height = 40
$minTimePickerLabel.Width = 160
$mainForm.Controls.Add($minTimePickerLabel)
 
# MaxTimePicker Label
$maxTimePickerLabel = New-Object System.Windows.Forms.Label
$maxTimePickerLabel.Text = “End time”
$maxTimePickerLabel.Location = “15, 80”
$maxTimePickerLabel.Height = 40
$maxTimePickerLabel.Width = 160
$mainForm.Controls.Add($maxTimePickerLabel)
 
# DatePicker
$datePicker = New-Object System.Windows.Forms.DateTimePicker
$datePicker.Location = “180, 12”
$datePicker.Width = “160”
$datePicker.Format = [windows.forms.datetimepickerFormat]::custom
$datePicker.CustomFormat = “dd/MM/yyyy”
$mainForm.Controls.Add($datePicker)
 
# MinTimePicker
$minTimePicker = New-Object System.Windows.Forms.DateTimePicker
$minTimePicker.Location = “180, 49”
$minTimePicker.Width = “160”
$minTimePicker.Format = [windows.forms.datetimepickerFormat]::custom
$minTimePicker.CustomFormat = “HH:mm:ss”
$minTimePicker.ShowUpDown = $TRUE
$mainForm.Controls.Add($minTimePicker)
 
# MaxTimePicker
$maxTimePicker = New-Object System.Windows.Forms.DateTimePicker
$maxTimePicker.Location = “180, 86”
$maxTimePicker.Width = “160”
$maxTimePicker.Format = [windows.forms.datetimepickerFormat]::custom
$maxTimePicker.CustomFormat = “HH:mm:ss”
$maxTimePicker.ShowUpDown = $TRUE
$mainForm.Controls.Add($maxTimePicker)
 
# OD Button
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = “20, 130”
$okButton.ForeColor = “White”
$okButton.BackColor = “Black”
$okButton.Text = “OK”
$okButton.add_Click({$mainForm.close()})
$mainForm.Controls.Add($okButton)
 
[void] $mainForm.ShowDialog()

$minTimePicker.Value
$maxTimePicker.Value

$today = Get-Date
$todayDetails = $today.ToString("yyyy-MM-dd_HH-mm")
$New_repository = New-Item -Path "$env:USERPROFILE\Desktop\$todayDetails" -ItemType Directory

Start-Transcript -Path "$New_repository\$todayDetails.txt" -Append

$extension_type = Read-Host -Prompt "Input the extension type(ex. jpg, png, pdf, etc.)";
$s1 = Read-Host -Prompt "Input the term#1 you want to add";
$s2 = Read-Host -Prompt "Input the term#2 you want to add";

$Kakao_Path_Kor = "$env:USERPROFILE\Documents\카카오톡 받은 파일";
$Kakao_Path_Eng = "$env:USERPROFILE\Documents\KakaoTalk Downloads";
$Kakao_Path_Default = @();

$BasementDate_Start = $minTimePicker.Value;
$BasementDate_End = $maxTimePicker.Value;

$Kakao_Path_Kor_exist = Test-path $Kakao_Path_Kor;
$Kakao_Path_Eng_exist = Test-path $Kakao_Path_Eng;

If($Kakao_Path_Kor_exist -eq $false) {
	If($Kakao_Path_Eng_exist -eq $false) {
		Write-host "There's no default Kakao repository" }
	elseif($Kakao_Path_Eng_exist -eq $true) {
		Write-host "The default Kakao repository is $Kakao_Path_Eng"
        $Kakao_Path_Default = $Kakao_Path_Eng; }
else { 
    Write-host "The default Kakao repository is $Kakao_Path_Kor"
    $Kakao_Path_Default = $Kakao_Path_Kor; }
}

$a = Get-ChildItem -Path "$Kakao_Path_Default" -Recurse -Filter "*.$extension_type" | Where-Object{($_.LastWriteTime -gt $BasementDate_Start) -and ($_.LastWriteTime -lt $BasementDate_End)} | Select-Object -ExpandProperty "FullName"
$j = 1;
foreach($i in $a) {
    Rename-Item -Path $i -newname "$s1-$s2-$j.$extension_type"
    if($?) { $j++; }
    }

if(($?) -and (Test-path $New_repository.FullName)) {
    $b = Get-ChildItem -Path "$Kakao_Path_Default" -Recurse | Where-Object{$_.Name -like "*$s1-$s2-*"}
    $b | Move-Item -Destination $New_repository.FullName -Force;
    }

Stop-Transcript

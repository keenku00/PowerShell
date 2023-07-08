<#
	.DESCRIPTION
	    When managing the Windows-based system, it's common to collect the time metadata.
        To pre-define the data before executing any operation, the following script was created.
	.PARAMETER
	.NOTES
		===========================================================================
		Created on:   	4th Feb., 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:       [Sys]_Time-Metadata-Check.ps1
		===========================================================================		
    .Configuration Mnagement
    2023.02.04
        : Script creation
    2023.02.04
        : UAT done
    2023.02.04
        : Upload in Git
    .Reference
        https://www.educative.io/answers/what-is-n-in-powershell
        https://stackoverflow.com/questions/44620134/dont-know-how-to-add-bold-to-a-label-in-winforms-powershell
#>

$today = Get-Date
$todayDetails = $today.ToString("yyyy-MM-dd_HH-mm")
$New_repository = New-Item -Path "$env:USERPROFILE\Desktop\$todayDetails" -ItemType Directory

Start-Transcript -Path "$New_repository\$todayDetails.txt" -Append

#Set-Executionpolicy -Scope CurrentUser -ExecutionPolicy UnRestricted

# TimeFramePicker.ps1
Add-Type -AssemblyName System.Windows.Forms

# All font definition
$font = new-object System.Drawing.Font('Ariel',10,[System.Drawing.FontStyle]::regular);
$CM_font = new-object System.Drawing.Font('Ariel',7,[System.Drawing.FontStyle]::bold);

# Main Form
$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Text = ”Time metadata”
$mainForm.Font = $font
$mainForm.ForeColor = “Black”
$mainForm.BackColor = “White”
$mainForm.Width = 400
$mainForm.Height = 315

# DatePicker Label
$datePickerLabel = New-Object System.Windows.Forms.Label
$datePickerLabel.Text = “Start Date”
$datePickerLabel.Location = “15, 10”
$datePickerLabel.Height = 40
$datePickerLabel.Width = 165
$mainForm.Controls.Add($datePickerLabel)
 
# MinTimePicker Label
$minTimePickerLabel = New-Object System.Windows.Forms.Label
$minTimePickerLabel.Text = “Start time”
$minTimePickerLabel.Location = “15, 45”
$minTimePickerLabel.Height = 40
$minTimePickerLabel.Width = 160
$mainForm.Controls.Add($minTimePickerLabel)
 
# End Date Picker Label
$enddatePickerLabel = New-Object System.Windows.Forms.Label
$enddatePickerLabel.Text = “End Date”
$enddatePickerLabel.Location = “15, 90”
$enddatePickerLabel.Height = 40
$enddatePickerLabel.Width = 165
$mainForm.Controls.Add($enddatePickerLabel)

# MaxTimePicker Label
$maxTimePickerLabel = New-Object System.Windows.Forms.Label
$maxTimePickerLabel.Text = “End time”
$maxTimePickerLabel.Location = “15, 125”
$maxTimePickerLabel.Height = 40
$maxTimePickerLabel.Width = 160
$mainForm.Controls.Add($maxTimePickerLabel)

# comment Label
$commentLabel = New-Object System.Windows.Forms.Label
$commentLabel.Font = $CM_font
$commentLabel.Text = “Created by Jimmy Lee, `nEmail: keenku00@naver.com”
$commentLabel.Location = “15, 200”
$commentLabel.Height = 40
$commentLabel.Width = 400
$mainForm.Controls.Add($commentLabel)

# DatePicker
$datePicker = New-Object System.Windows.Forms.DateTimePicker
$datePicker.Location = “180, 12”
$datePicker.Width = “160”
$datePicker.Format = [windows.forms.datetimepickerFormat]::custom
$datePicker.CustomFormat = “dd/MM/yyyy”
$mainForm.Controls.Add($datePicker)

# MinTimePicker
$minTimePicker = New-Object System.Windows.Forms.DateTimePicker
$minTimePicker.Location = “180, 45”
$minTimePicker.Width = “160”
$minTimePicker.Format = [windows.forms.datetimepickerFormat]::custom
$minTimePicker.CustomFormat = “HH:mm:ss”
$minTimePicker.ShowUpDown = $TRUE
$mainForm.Controls.Add($minTimePicker)

# End date Picker
$enddatePicker = New-Object System.Windows.Forms.DateTimePicker
$enddatePicker.Location = “180, 92”
$enddatePicker.Width = “160”
$enddatePicker.Format = [windows.forms.datetimepickerFormat]::custom
$enddatePicker.CustomFormat = “dd/MM/yyyy”
$mainForm.Controls.Add($enddatePicker)
 
# MaxTimePicker
$maxTimePicker = New-Object System.Windows.Forms.DateTimePicker
$maxTimePicker.Location = “180, 125”
$maxTimePicker.Width = “160”
$maxTimePicker.Format = [windows.forms.datetimepickerFormat]::custom
$maxTimePicker.CustomFormat = “HH:mm:ss”
$maxTimePicker.ShowUpDown = $TRUE
$mainForm.Controls.Add($maxTimePicker)
 
# OD Button
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = “265, 165”
$okButton.ForeColor = “White”
$okButton.BackColor = “Black”
$okButton.Text = “OK”
$okButton.add_Click({$mainForm.close()})
$mainForm.Controls.Add($okButton)

[void] $mainForm.ShowDialog()

###################################################
# Time variables arrangement
$datePicker.Value
$minTimePicker.Value

$enddatePicker.Value
$maxTimePicker.Value

$datePicker.Value.Date
$minTimePicker.Value.TimeOfDay

$enddatePicker.Value.Date
$maxTimePicker.Value.TimeOfDay

###################################################
# Get the original date and time from $datePicker.Value
$originalDateTime = $datePicker.Value

# Get the time component from $minTimePicker.Value.TimeOfDay
$timeComponent = $minTimePicker.Value.TimeOfDay

# Create a new DateTime object by adding the time component to the original date and time
$newDateTime = $originalDateTime.Date.Add($timeComponent)

# Output the updated date and time
Write-Host $newDateTime

###################################################
# Get the original date and time from $enddatePicker.Value
$endDate = $enddatePicker.Value

# Get the time component from $maxTimePicker.Value.TimeOfDay
$maxTime = $maxTimePicker.Value.TimeOfDay

# Create a new DateTime object with the original date and updated time
$newEndDate = $endDate.Date.Add($maxTime)

# Output the updated date and time
Write-Host $newEndDate
###################################################

Stop-Transcript

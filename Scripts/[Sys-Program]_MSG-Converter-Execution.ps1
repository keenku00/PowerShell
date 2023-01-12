<#
	.DESCRIPTION
		According to the M365 project from DAIMLER headquater, the legacy .msg files should've been archived.
    However, as archiving tons of legacy mails is burden to handle within a few days, the script was created. For convience, the script could be created as .exe file.
	
	.PARAMETER
	.NOTES
		===========================================================================
		Created on:   	11th Jan., 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:       [Sys-Program]_MSG-Converter-Execution.ps1
		===========================================================================		
    .Configuration Mnagement
    2023.01.11
        : Script creation
    2023.01.11
        : UAT done
    2023.01.12
        : Upload in Git
#>
##Authentication by using computer DNS domain name
##If the user doesn't want to set this authentication step, please remove the following if loop only.
$Authentication = $env:ComputerDNSDomain;
if($env:ComputerDomain -eq "APAC") { Write-host "Authenticated Daimler PC" }
    else {write-host "Failed to be authenticated, only Daimler PC is available."
    Start-Sleep -Seconds 5;
    Exit }

$today = Get-Date
$todayDetails = $today.ToString("yyyy-MM-dd_HH-mm")
$Logfile_name = "$todayDetails.txt"

Start-Transcript -Path "$env:USERPROFILE\desktop\$todayDetails.txt" -Append

function ConvertFrom-MsgToDoc
{
    [CmdletBinding()]

    Param
    (
        [Parameter(ParameterSetName="Path", Position=0, Mandatory=$True)]
        [String]$Path,

        [Parameter(ParameterSetName="LiteralPath", Mandatory=$True)]
        [String]$LiteralPath,

        [Parameter(ParameterSetName="FileInfo", Mandatory=$True, ValueFromPipeline=$True)]
        [System.IO.FileInfo]$Item
    )

    Begin
    {
        # OlSaveAsType constants
        $olTXT = 0
        $olRTF = 1
        $olTemplate = 2
        $olMSG = 3
        $olDoc = 4

        # WdPaperSize constants
        $wdPaper10x14 = 0
        $wdPaper11x17 = 1
        $wdPaperLetter = 2
        $wdPaperLetterSmall = 3
        $wdPaperLegal = 4
        $wdPaperExecutive = 5
        $wdPaperA3 = 6
        $wdPaperA4 = 7
        $wdPaperA4Small = 8
        $wdPaperA5 = 9
        $wdPaperB4 = 10
        $wdPaperB5 = 11
        $wdPaperCSheet = 12
        $wdPaperDSheet = 13
        $wdPaperESheet = 14
        $wdPaperFanfoldLegalGerman = 15
        $wdPaperFanfoldStdGerman = 16
        $wdPaperFanfoldUS = 17
        $wdPaperFolio = 18
        $wdPaperLedger = 19
        $wdPaperNote = 20
        $wdPaperQuarto = 21
        $wdPaperStatement = 22
        $wdPaperTabloid = 23
        $wdPaperEnvelope9 = 24
        $wdPaperEnvelope10 = 25
        $wdPaperEnvelope11 = 26
        $wdPaperEnvelope12 = 27
        $wdPaperEnvelope14 = 28
        $wdPaperEnvelopeB4 = 29
        $wdPaperEnvelopeB5 = 30
        $wdPaperEnvelopeB6 = 31
        $wdPaperEnvelopeC3 = 32
        $wdPaperEnvelopeC4 = 33
        $wdPaperEnvelopeC5 = 34
        $wdPaperEnvelopeC6 = 35
        $wdPaperEnvelopeC65 = 36
        $wdPaperEnvelopeDL = 37
        $wdPaperEnvelopeItaly = 38
        $wdPaperEnvelopeMonarch = 39
        $wdPaperEnvelopePersonal = 40
        $wdPaperCustom = 41

        # Load applications
        Write-Verbose "Loading Microsoft Outlook..."
        $outlook = New-Object -ComObject Outlook.Application

        Write-Verbose "Loading Microsoft Word..."
        $word = New-Object -ComObject Word.Application

        # Disable signature
        $signaturesPath = Join-Path $env:APPDATA "Microsoft\Signatures"
        Get-ChildItem $signaturesPath | % {
            Rename-Item $_.FullName ("_" + $_.Name)
        }
    }

    Process
    {
        switch ($PSCmdlet.ParameterSetName)
        {
            "Path"        { $files = Get-ChildItem -Path $Path }
            "LiteralPath" { $files = Get-ChildItem -LiteralPath $LiteralPath }
            "FileInfo"    { $files = $Item }
        }

        $files | % {
            # Work out file names
            $msgFn = $_.FullName
            $docFn = $msgFn -replace '\.msg$', '.doc'

            # Skip non-.msg files
            if ($msgFn -notlike "*.msg") {
                Write-Verbose "Skipping $_ (not an .msg file)..."
                return
            }

            # Do not try to overwrite existing files
            if (Test-Path -LiteralPath $docFn) {
                Write-Verbose "Skipping $_ (.doc already exists)..."
                return
            }

            # Extract message body
            Write-Verbose "Extracting message body from $_..."
            $msg = $outlook.CreateItemFromTemplate($msgFn)
            $msg.SaveAs($docFn, $olDoc)

            # Convert to A4
            Write-Verbose "Converting file size to A4..."
            $doc = $word.Documents.Add($docFn)
            $doc.PageSetup.PaperSize = $wdPaperA4
            $doc.SaveAs([ref]$docFn)
            $doc.Close()

            # Output to pipeline
            Get-ChildItem -LiteralPath $docFn
        }
    }

    End
    {
        # Enable signatures
        Get-ChildItem $signaturesPath | % {
            Rename-Item $_.FullName $_.Name.Substring(1)
        }

        Write-Verbose "Done."
    }
}

function ConvertWordTo-PDF {
 
<# 
  
.SYNOPSIS 
 
ConvertTo-PDF converts Microsoft Word documents to PDF files. 
  
.DESCRIPTION 
 
The cmdlet queries the given source folder including sub-folders to find *.docx and *.doc files, 
converts all found files and saves them as pdf in the Destination folder. After completition, the Destination
folder with the newly created PDF files will be opened with Windows Explorer.
  
.PARAMETER SourceFolder
  
Mandatory. Enter the source folder of your Microsoft Word documents.
  
.PARAMETER DestinationFolder
 
Optional. Enter the Destination folder to save the created PDF documents. If you omit this parameter, pdf files will
be saved in the Source Folder.
 
.EXAMPLE 
 
ConvertWordTo-PDF -SourceFolder C:\Temp -DestinationFolder C:\Temp1
ConvertWordTo-PDF -SourceFolder C:\temp
  
.NOTES 
Author: Patrick Gruenauer | Microsoft PowerShell MVP [2018-2021] 
Web: https://sid-500.com 
  
#>
 
[CmdletBinding()]
 
param
(
  
[Parameter (Mandatory=$true,Position=0)]
[String]
$SourceFolder,
  
[Parameter (Position=$true,Mandatory=$True)]
[String]
$DestinationFolder
 
)
 
    $i = 0
 
    $word = New-Object -ComObject word.application 
    $FormatPDF = 17
    $word.visible = $false
    $types = '*.docx','*.doc'
 
    If ((Test-Path $SourceFolder) -eq $false) {
     
    throw "Error. Source Folder $SourceFolder not found." } 
 
    If ((Test-Path $DestinationFolder) -eq $false) {
     
    throw "Error. Destination Folder $DestinationFolder not found." } 
     
    $files = Get-ChildItem -Path $SourceFolder -Include $Types -Recurse -ErrorAction SilentlyContinue
     
    foreach ($f in $files) {
 
        $path = $DestinationFolder + '\' + $f.Name.Substring(0,($f.Name.LastIndexOf('.')))
        $doc = $word.documents.open($f.FullName)
        [System.Threading.Thread]::Sleep(5000)
        $doc.saveas($path,$FormatPDF)
        $doc.close()
        Write-Output "$($f.Name)"
        $i++
 
    }
    ''
    Write-Output "$i file(s) converted."
    Start-Sleep -Seconds 2 
    Invoke-Item $DestinationFolder
    $word.Quit()  
}

function get-Folderlocation([string]$Message, [string]$InitialDirectory, [switch]$NoNewFolderButton)
{
    $browseForFolderOptions = 0
    if ($NoNewFolderButton) { $browseForFolderOptions += 512 }

    $app = New-Object -ComObject Shell.Application
    $folder = $app.BrowseForFolder(0, $Message, $browseForFolderOptions, $InitialDirectory)
    if ($folder) { $selectedDirectory = $folder.Self.Path } else { $selectedDirectory = '' }
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($app) > $null
    return $selectedDirectory
}

function button ($title, $Input_1, $Input_2, $Input_3) {

###################Load Assembly for creating form & button######

[void][System.Reflection.Assembly]::LoadWithPartialName( “System.Windows.Forms”)
[void][System.Reflection.Assembly]::LoadWithPartialName( “Microsoft.VisualBasic”)

#####Define the form size & placement

$Input_4 = "※Alert:: The number of .msg files must not be over 500./최대 변환 가능 메일 갯수는 500개 입니다."
$Input_5 = "※Copyright 2023 DAIMLER TRUCKS KOREA IT Dept. all rights reserved."
$Input_6 = "For any query, please contact to jimmy.lee@daimler.com"

$form = New-Object “System.Windows.Forms.Form”;
$form.Width = 890;
$form.Height = 295;
$form.Text = $title;
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen;

##############Define text label1
$textLabel1 = New-Object “System.Windows.Forms.Label”;
$textLabel1.Left = 25;
$textLabel1.Top = 15;
$textLabel1.width = 360;

$textLabel1.Text = $Input_1;

##############Define text label2

$textLabel2 = New-Object “System.Windows.Forms.Label”;
$textLabel2.Left = 25;
$textLabel2.Top = 50;
$textLabel2.width = 360;

$textLabel2.Text = $Input_2;

##############Define text label3

$textLabel3 = New-Object “System.Windows.Forms.Label”;
$textLabel3.Left = 25;
$textLabel3.Top = 85;
$textLabel3.width = 350;

$textLabel3.Text = $Input_3;

##############Define text label4

$textLabel4 = New-Object “System.Windows.Forms.Label”;
$textLabel4.Left = 25;
$textLabel4.Top = 140;
$textLabel4.width = 800;

$textLabel4.Text = $Input_4;

##############Define text label5

$textLabel5 = New-Object “System.Windows.Forms.Label”;
$textLabel5.Left = 25;
$textLabel5.Top = 165;
$textLabel5.width = 800;

$textLabel5.Text = $Input_5;

##############Define text label6

$textLabel6 = New-Object “System.Windows.Forms.Label”;
$textLabel6.Left = 25;
$textLabel6.Top = 205;
$textLabel6.width = 800;

$textLabel6.Text = $Input_6;

############Define text box1 for input
$textBox1 = New-Object “System.Windows.Forms.TextBox”;
$textBox1.Left = 400;
$textBox1.Top = 15;
$textBox1.width = 200;

#############define browse1 button
$Browse1 = New-Object System.Windows.Forms.Button
$Browse1.Location = New-Object System.Drawing.Point(610,14)
$Browse1.Size = New-Object System.Drawing.Size(90,20)
$Browse1.Text = 'Browse...'
$Browse1.Add_Click({(Get-Variable -Name textBox1 -Scope 1).Value.Text = Get-Folderlocation})
$form.Controls.Add($Browse1)

#############define browse2 button
$Browse2 = New-Object System.Windows.Forms.Button
$Browse2.Location = New-Object System.Drawing.Point(610,49)
$Browse2.Size = New-Object System.Drawing.Size(90,20)
$Browse2.Text = 'Browse...'
$Browse2.Add_Click({(Get-Variable -Name textBox2 -Scope 1).Value.Text = Get-Folderlocation})
$form.Controls.Add($Browse2)

#############define browse3 button
$Browse3 = New-Object System.Windows.Forms.Button
$Browse3.Location = New-Object System.Drawing.Point(610,90)
$Browse3.Size = New-Object System.Drawing.Size(90,20)
$Browse3.Text = 'Browse...'
$Browse3.Add_Click({(Get-Variable -Name textBox3 -Scope 1).Value.Text = Get-Folderlocation})
$form.Controls.Add($Browse3)

############Define text box2 for input

$textBox2 = New-Object “System.Windows.Forms.TextBox”;
$textBox2.Left = 400;
$textBox2.Top = 50;
$textBox2.width = 200;

############Define text box3 for input

$textBox3 = New-Object “System.Windows.Forms.TextBox”;
$textBox3.Left = 400;
$textBox3.Top = 90;
$textBox3.width = 200;

#############Define default values for the input boxes
$defaultValue = “”
$textBox1.Text = $defaultValue;
$textBox2.Text = $defaultValue;
$textBox3.Text = $defaultValue;

#############define OK button
$button = New-Object “System.Windows.Forms.Button”;
$button.Left = 730;
$button.Top = 89;
$button.Width = 100;
$button.Text = “Ok”;

############# This is when you have to close the form after getting values
$eventHandler = [System.EventHandler]{
$textBox1.Text;
$textBox2.Text;
$textBox3.Text;
$form.Close();};

$button.Add_Click($eventHandler) ;

#############Add controls to all the above objects defined
$form.Controls.Add($button);
$form.Controls.Add($textLabel1);
$form.Controls.Add($textLabel2);
$form.Controls.Add($textLabel3);
$form.Controls.Add($textLabel4);
$form.Controls.Add($textLabel5);
$form.Controls.Add($textLabel6);
$form.Controls.Add($textBox1);
$form.Controls.Add($textBox2);
$form.Controls.Add($textBox3);
$ret = $form.ShowDialog();

#################return values

return $textBox1.Text, $textBox2.Text, $textBox3.Text
}

$return= button “File (.msg > .word, .pdf)converter(.msg파일을 Word & PDF파일로 변환)” “The .msg file path(.msg파일이 저장된 경로):” “The .doc file path(워드 파일로 저장할 경로):” “The .pdf file path(PDF 파일로 저장할 경로):”
$Msg_path = $return[0]
$Word_path = $return[1]
$Pdf_path = $return[2]
$a = ConvertFrom-MsgToDoc -Path "$Msg_path"

##Validate if the total amount of mail is over 500 or not, if it's over 500, make it closed.
$msg_count = Get-ChildItem -Path $Msg_path | Select-Object -ExpandProperty 'Name' | Select-String -Pattern '.msg'
if($msg_count.count -gt 500) { Write-host "Failed to exceute the program, the total number of .msg file must be less than 500."
    Start-Sleep 10;
    Exit }

$i = @();
$j = @();
##Move the all word files to the other path
if($?) { 
    foreach($i in $a.Name) {
        Move-Item -Path "$Msg_path\$i" -Destination "$Word_path\$i" }
        if($?) {
        ##Once the word files were all moved into the path, initiate converting the word files into pdf files.
            $j = ConvertWordTo-PDF -SourceFolder $Word_path -DestinationFolder $Pdf_path
                if($?) {
                    Write-host "The execution was done, for the details please refer to the logfile($env:USERPROFILE\desktop\$Logfile_name)."; }
                    }
}

Stop-Transcript

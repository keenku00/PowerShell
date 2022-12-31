<#
[Preparations]
	1. Install the module
	Install-Module -Name QRCodeGenerator

Reference: <https://www.powershellgallery.com/packages/QRCodeGenerator/2.6.0> 

	2. Allow Powershell scirpt to be executed.
	Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

	3. Bring the Powershell module
	Import-Module QRCodeGenerator
	
	4. Check the available modules related to QR code.
	Get-Command -Module QRCodeGenerator
#>
<#
[Function]
#>
function New-PSOneQRCode
{
    <#
            .SYNOPSIS
            Creates a QR code graphic
 
            .DESCRIPTION
            Creates a QR code graphic in png format that - when scanned by a smart device
 
            .PARAMETER Payload
            The Payload for the QR code
 
            .PARAMETER Width
            Height and Width of generated graphics (in pixels). Default is 100.
 
            .PARAMETER Show
            Opens the generated QR code in associated program
 
            .PARAMETER OutPath
            Path to generated png file. When omitted, a temporary file name is used.
 
            .EXAMPLE
            New-PSOneQRCode -payload $payload -Width $width -Show -OutPath $OutPath
            Creates a QR code png graphics on your desktop, and opens it with the associated program
 
            .NOTES
            Compatible with all PowerShell versions including PowerShell 6/Core
            Uses binaries from https://github.com/codebude/QRCoder/wiki
 
            .LINK
            https://github.com/TobiasPSP/Modules.QRCodeGenerator
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $payload,

        [Parameter(Mandatory)]
        [bool]
        $Show,

        [ValidateRange(10,2000)]
        [int]
        $Width = 100,

        [string]
        $OutPath = "$env:temp\qrcode.png"
    )
        

    $generator = New-Object -TypeName QRCoder.QRCodeGenerator
    $data = $generator.CreateQrCode($payload, 'Q')
    $code = new-object -TypeName QRCoder.PngByteQRCode -ArgumentList ($data)
    $byteArray = $code.GetGraphic($Width)
    [System.IO.File]::WriteAllBytes($outPath, $byteArray)

    if ($Show) { Invoke-Item -Path $outPath }
}

function New-PSOneQRCodeURI
{
    <#
            .SYNOPSIS
            Creates a QR code graphic containing a URI
 
            .DESCRIPTION
            Creates a QR code graphic in png format that - when scanned by a smart device - opens a URI/URL in your webapp
 
            .PARAMETER URI
            The URI
 
            .PARAMETER Width
            Height and Width of generated graphics (in pixels). Default is 100.
 
            .PARAMETER Show
            Opens the generated QR code in associated program
 
            .PARAMETER OutPath
            Path to generated png file. When omitted, a temporary file name is used.
 
            .EXAMPLE
            New-PSOneQRCodeURI -URI "https://github.com/TobiasPSP/Modules.QRCodeGenerator" -Width 50 -Show -OutPath "$home\Desktop\qr.png"
            Creates a QR code png graphics on your desktop, and opens it with the associated program
 
            .NOTES
            Compatible with all PowerShell versions including PowerShell 6/Core
            Uses binaries from https://github.com/codebude/QRCoder/wiki
 
            .LINK
            https://github.com/TobiasPSP/Modules.QRCodeGenerator
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [alias("URL")]
        [System.Uri]
        $URI,

        [ValidateRange(10,2000)]
        [int]
        $Width = 100,

        [Switch]
        $Show,

        [string]
        $OutPath = "$env:temp\qrcode.png"
    )
    
$payload = @"
$($URI.AbsoluteUri)
"@

    New-PSOneQRCode -payload $payload -Show $Show -Width $Width -OutPath $OutPath
}

New-PSOneQRCodeURI -URI 'https://m.blog.naver.com/jimmy_jib' -Width 15 -OutPath 'C:\URL-QR.PNG'

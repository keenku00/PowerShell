<#
	.DESCRIPTION
     In the Powershell environment, it's an excersise script to create a new Object type through Invoke-RestMethod and Invoke-RestAPI cmdlet.
	
	.PARAMETER

	.NOTES
		===========================================================================
		Created on:   	21th Aug. 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	Script#2_Object-Creation.ps1
		===========================================================================		

    .Configuration Mnagement
    2023.08.21
        : Script creation
    2023.08.21
        : UAT done
    2023.08.21
        : Upload in Git
#>

function Invoke-RestApi {
    param (
        [string]$Uri,
        [string]$Method = "GET",
        [hashtable]$Headers = @{},
        [int]$TimeoutSec = 30
    )

    try {
        $response = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $Headers -TimeoutSec $TimeoutSec
        return $response
    }
    catch {
        Write-Host "An error occurred: $($_.Exception.Message)"
        return $null
    }
}

# Usage
$apiUrl = "https://jsonplaceholder.typicode.com/posts/1"
$headers = @{
    "Accept" = "application/json"
}

$response = Invoke-RestApi -Uri $apiUrl -Headers $headers

if ($response -ne $null) {
    $formattedJson = ConvertTo-Json -InputObject $response -Depth 4
    Write-Host "Formatted JSON Response:"
    Write-Host $formattedJson
}

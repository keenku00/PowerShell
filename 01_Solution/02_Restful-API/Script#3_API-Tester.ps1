<#
	.DESCRIPTION
     To retrieve HTTP resonse header value, the cURL or Postman application either would be used a lot.
     However, in Powershell environemnt, it's much easier to allow user to get intuitive results.
	
	.PARAMETER

	.NOTES
		===========================================================================
		Created on:   	23rd Dec. 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	Script#3_API-Tester.ps1
		===========================================================================		

    .Configuration Mnagement
    2023.12.23
        : Script creation
    2023.12.23
        : UAT done
    2023.12.23
        : Upload in Git
#>
#---------------------------------------------------------------
# USE CASE#1: OAuth 2.0 authentication using Bearer Token
#---------------------------------------------------------------
# Bearer Token variable setup
$accessToken = "YOUR_ACCESS_TOKEN"
$uri = "https://as.api.tester.com/app-live/prod-sns-01"
$httpMethod = "Get"

# Setting headers based on the authentication method
$headers = @{
    "Authorization" = "Bearer $accessToken"
}

# Making the REST call
$response = Invoke-RestMethod -Uri $uri -Headers $headers -Method $httpMethod

# Displaying the response
$response
$response | Format-List * -Force

#---------------------------------------------------------------
# USE CASE#2: X-API-Key
#---------------------------------------------------------------
# X-api-Key variable setup
$apiKey = "YOUR_API_KEY"
$uri = "https://as.api.tester.com/app-live/prod-sns-01"
$httpMethod = "Get"

# Setting headers
$headers = @{
    "x-api-key" = $apiKey
}

# Making the REST call
$response = Invoke-RestMethod -Uri $uri -Headers $headers -Method $httpMethod

# Displaying the response
$response
$response | Format-List * -Force

#---------------------------------------------------------------
# USE CASE#3: HTTP Basic Authentication
#---------------------------------------------------------------
# Username and Password variable setup
$username = "YOUR_USERNAME"
$password = "YOUR_PASSWORD"
$uri = "https://as.api.tester.com/app-live/prod-sns-01"
$httpMethod = "Get"

# Generating authentication information
$authInfo = ($username + ":" + $password)
$encodedAuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($authInfo))
$basicAuthHeader = "Basic " + $encodedAuthInfo

# Setting headers
$headers = @{
    "Authorization" = $basicAuthHeader
}

# Making the REST call
$response = Invoke-RestMethod -Uri $uri -Headers $headers -Method $httpMethod

# Displaying the response
$response
$response | Format-List * -Force

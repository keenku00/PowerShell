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

# 변수 설정
$apiKey = "TTTYNMmg43pkoVAkKcA9AcMn3uq2dTTTA2Cq0ew2y21qVBf2FesTpaYPw5UaqTTT"
$uri = "https://as.api.daimlertruck.com/dtk-dms-live/prod-sns-01"
$httpMethod = "Get"

# 헤더 설정
$headers = @{
    "x-api-key" = $apiKey
}

# REST 호출
$response = Invoke-RestMethod -Uri $uri -Headers $headers -Method $httpMethod

# 응답 출력
$response
$response | Format-List * -Force


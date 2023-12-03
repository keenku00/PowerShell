<#
	.DESCRIPTION
     In the Powershell environment, the value is received from the OpenAPI server through the API Key authentication header.
	
	.PARAMETER

	.NOTES
		===========================================================================
		Created on:   	20th Aug. 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	Script#1_Weather-Check.ps1
		===========================================================================		

    .Configuration Mnagement
    2023.08.20
        : Script creation
    2023.08.20
        : UAT done
    2023.08.20
        : Upload in Git
#>

# As it is a free API version, there is no need to worry about revealing the key value.
$accessKey = "05cce85339f0c735ff384c83c8b4c214"
$city = "Seoul"
$weatherApiUrl = "http://api.weatherstack.com/current?access_key=$accessKey&query=$city"
$returnvalue = $false

try {
    # Make an API request to retrieve weather data
    $weatherData = Invoke-RestMethod -Uri $weatherApiUrl -Method Get
    $PSC_weather = [PSCustomObject]@{
        Location_Name      = $weatherData.location.name
        country_Name       = $weatherData.location.country
        LocationTime       = $weatherData.location.localtime
        Temp               = $weatherData.current.temperature
        WeatherDescription = $weatherData.current.weather_descriptions[0]
        Humidity           = $weatherData.current.humidity
    }
    $returnvalue = $true
} catch {
    Write-Host "API synchronization failed."
}

# Check if the API request was successful
if ($returnvalue) {
    try {
        Write-Host ("Location_Name      : $($PSC_weather.Location_Name)")
        Write-Host ("country_Name       : $($PSC_weather.country_Name)")
        Write-Host ("LocationTime       : $($PSC_weather.LocationTime)")
        Write-Host ("Temp               : $($PSC_weather.Temp)")
        Write-Host ("WeatherDescription : $($PSC_weather.WeatherDescription)")
        Write-Host ("Humidity           : $($PSC_weather.Humidity)")
        Write-Host "Execution successful."
    } catch {
        Write-Host "API synchronization failed."
    }
}

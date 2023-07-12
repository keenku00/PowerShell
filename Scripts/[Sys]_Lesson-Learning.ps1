<#
	.DESCRIPTION
		Exercise script for the cmdlet and parameters' function.
	
	.PARAMETER

	.NOTES
		===========================================================================
		Created on:   	13th July 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[Sys]_Windows-Service-Spooler-Execution.ps1
		===========================================================================		

    .Configuration Mnagement
    2022.07.13
        : Script creation
    2022.07.13
        : UAT done
    2022.07.13
        : Upload in Git
#>

######################################################################
#Check if the service is running and run it if not started.
######################################################################

Get-Service -Name * | Select-Object Name | Select-String -Pattern ".*oo.*"
Get-Service -Name * | Select-Object -ExpandProperty Name | Select-String -Pattern ".*oo.*"

#The -ExpandProperty parameter in PowerShell is used to retrieve the value of a specific property from an object. It allows you to extract the value of a property and output it directly, instead of displaying the full object with all its properties.
#When working with cmdlets that return objects, such as Select-Object, Get-Member, or ForEach-Object, you can use -ExpandProperty to extract and output a single property's value. By specifying the property name with -ExpandProperty, PowerShell retrieves the value of that property and returns it as the output.

######################################################################
#Check if the service is running and run it if not started.
######################################################################

$serviceName = "*spool*"  # Replace "Your_Service_Name" with the actual service name

$service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

if ($service) {
    if ($service.Status -eq "Running") {
        Write-Host "The service '$serviceName' is running."
    } else {
        Write-Host "The service '$serviceName' is not running."
        Start-Service -Name $serviceName
        Write-Host "The service '$serviceName' has been started."
    }
} else {
    Write-Host "The service '$serviceName' was not found."
}

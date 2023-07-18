<#
	.DESCRIPTION
		A basic script that moves the mouse to a random location to automate certain repetitive tasks in a Windows environment.
	.PARAMETER
	.NOTES
		===========================================================================
		Created on:   	5th Jun., 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:       [RPA]_[1]_Move-Mouse-Auto-Execution.ps1
		===========================================================================		
    .Configuration Mnagement
    2023.06.05
        : Script creation
    2023.06.05
        : UAT done
    2023.06.05
        : Upload in Git
#>
# Importing required .NET types and functions from the Windows API
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class MouseMove
{
    [DllImport("user32.dll")]
    public static extern bool SetCursorPos(int X, int Y);
    
    [DllImport("user32.dll")]
    public static extern bool GetCursorPos(out POINT lpPoint);
    
    [StructLayout(LayoutKind.Sequential)]
    public struct POINT
    {
        public int X;
        public int Y;
    }
}
"@

# Function to move the mouse cursor from a starting point to an ending point
function Move-MouseCursor {
    param (
        [Parameter(Mandatory = $true)]
        [System.Drawing.Point]$StartPoint,
        
        [Parameter(Mandatory = $true)]
        [System.Drawing.Point]$EndPoint,
        
        [Parameter()]
        [int]$Duration = 1000
    )
    
    # Record the start time of the cursor movement
    $startTime = Get-Date
    
    # Initialize variables for start and end coordinates
    $startX = $StartPoint.X
    $startY = $StartPoint.Y
    $endX = $EndPoint.X
    $endY = $EndPoint.Y
    
    # Loop until the specified duration is reached
    $elapsedTime = 0
    while ($elapsedTime -lt $Duration) {
        # Get the current time
        $currentTime = Get-Date
        
        # Calculate the elapsed time since the start
        $elapsedTime = ($currentTime - $startTime).TotalMilliseconds
        
        # Calculate the intermediate coordinates based on elapsed time and duration
        $deltaX = ($endX - $startX) * ($elapsedTime / $Duration)
        $deltaY = ($endY - $startY) * ($elapsedTime / $Duration)
        
        # Set the cursor position to the intermediate coordinates
        [MouseMove]::SetCursorPos($startX + $deltaX, $startY + $deltaY)
        
        # Sleep for a short interval to control the speed of cursor movement
        Start-Sleep -Milliseconds 10
    }
    
    # Set the cursor position to the final destination coordinates
    [MouseMove]::SetCursorPos($endX, $endY)
}

# Usage example
$startingPoint = [System.Drawing.Point]::new(100, 100)
$endingPoint = [System.Drawing.Point]::new(500, 500)

# Move the mouse cursor from the starting point to the ending point over a duration of 2000 milliseconds (2 seconds)
Move-MouseCursor -StartPoint $startingPoint -EndPoint $endingPoint -Duration 2000

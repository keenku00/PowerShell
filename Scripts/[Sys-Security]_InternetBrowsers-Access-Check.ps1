#PowerShell script to get the browsing history of Google Chrome
#Reference: https://www.hexnode.com/mobile-device-management/help/script-to-fetch-browsing-history-on-windows-10-devices/#powershell-script-to-get-the-browsing-history-of-google-chrome
$UserName = "USERNAME" 
$UserName        
$Path = "$Env:systemdrive\Users\$UserName\AppData\Local\Google\Chrome\User Data\Default\History" 
        if (-not (Test-Path -Path $Path)) { 
            Write-Verbose "[!] Could not find Chrome History for username: $UserName" 
        } 
        $Regex = '(htt(p|s))://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?' 
        $Value = Get-Content -Path "$Env:systemdrive\Users\$UserName\AppData\Local\Google\Chrome\User Data\Default\History"|Select-String -AllMatches $regex |% {($_.Matches).Value} |Sort -Unique 
        $Value | ForEach-Object { 
            $Key = $_ 
            if ($Key -match $Search){ 
                New-Object -TypeName PSObject -Property @{ 
                    User = $UserName 
                    Browser = 'Chrome' 
                    DataType = 'History' 
                    Data = $_ 
                } 
            } 
        } 
        
        
#PowerShell script to get the browsing history of Microsoft Edge
$UserName = "USERNAME" 
$UserName        
$Path = "$Env:systemdrive\Users\$UserName\AppData\Local\Microsoft\Edge\User Data\Default\History" 
        if (-not (Test-Path -Path $Path)) { 
            Write-Verbose "[!] Could not find Edge History for username: $UserName" 
        } 
        $Regex = '(htt(p|s))://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?' 
        $Value = Get-Content -Path "$Env:systemdrive\Users\$UserName\AppData\Local\Microsoft\Edge\User Data\Default\History"|Select-String -AllMatches $regex |% {($_.Matches).Value} |Sort -Unique 
        $Value | ForEach-Object { 
            $Key = $_ 
            if ($Key -match $Search){ 
                New-Object -TypeName PSObject -Property @{ 
                    User = $UserName 
                    Browser = 'Edge' 
                    DataType = 'History' 
                    Data = $_ 
                } 
            } 
        } 
        
        
PowerShell script to get the browsing history of Firefox
$UserName= $args[0] 
 
#DOWNLOAD SQLITE 
if(-not (Test-Path -Path C:\sqlite.zip -PathType Leaf)){  
Invoke-WebRequest -Uri "https://www.sqlite.org/2022/sqlite-tools-win32-x86-3380500.zip" -OutFile C:\sqlite.zip 
} 
 
#Extract to SQLITE Folder 
if(-not (Test-Path -Path "C:\SQLite3\sqlite-tools-win32-x86-3380500\sqlite3.exe")){ 
Expand-Archive C:\sqlite.zip -DestinationPath C:\SQLite3 -Force 
} 
 
#READ DATA FROM TABLE 
try{ 
$Path = "C:\Users\$UserName\AppData\Roaming\Mozilla\Firefox\Profiles\" 
$Profiles = Get-ChildItem -Path "$Path\*.default-release*\" -ErrorAction SilentlyContinue 
ForEach($item in $Profiles){ 
$DataSource="$item\places.sqlite" 
$tables = C:\SQLite3\sqlite-tools-win32-x86-3380500\sqlite3.exe $DataSource .tables 
if($tables -match "moz"){ 
C:\SQLite3\sqlite-tools-win32-x86-3380500\sqlite3.exe $DataSource "SELECT url from moz_places" 
} 
} 
} 
catch 
{ 
write-host $_.Exception.Message 
} 


#PowerShell script to get the browsing history of Internet Explorer
$Null = New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS 
        $Paths = Get-ChildItem 'HKU:\' -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'S-1-5-21-[0-9]+-[0-9]+-[0-9]+-[0-9]+$' } 
        ForEach($Path in $Paths) { 
            $User = ([System.Security.Principal.SecurityIdentifier] $Path.PSChildName).Translate( [System.Security.Principal.NTAccount]) | Select -ExpandProperty Value 
            $Path = $Path | Select-Object -ExpandProperty PSPath 
            $UserPath = "$Path\Software\Microsoft\Internet Explorer\TypedURLs" 
            if (-not (Test-Path -Path $UserPath)) { 
                Write-Verbose "[!] Could not find IE History for SID: $Path" 
            } 
            else { 
                Get-Item -Path $UserPath -ErrorAction SilentlyContinue | ForEach-Object { 
                    $Key = $_ 
                    $Key.GetValueNames() | ForEach-Object { 
                        $Value = $Key.GetValue($_) 
                        if ($Value -match $Search) { 
                            New-Object -TypeName PSObject -Property @{ 
                                User = $UserName 
                                Browser = 'IE' 
                                DataType = 'History' 
                                Data = $Value 
                            } 
                        } 
                    } 
                } 
            } 
        }

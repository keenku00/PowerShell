<#
	.DESCRIPTION
        Implementing a complicated password on an internal system is crucial to prevent a cyber security issue.
        This is a script for creating complex passwords with appropriate combinations of alphabets and numbers.
  
	.PARAMETER
	.NOTES
		===========================================================================
		Created on:   	22nd Nov. 2023
		Created by:   	Jimmy Lee
		Contact to:   	keenku00@naver.com
		Filename:     	[Security]_Random-Password-Creation.ps1
		===========================================================================		
    .Configuration Mnagement
    2023.06.20
        : Script creation
    2023.06.20
        : UAT done
    2023.06.20
        : Upload in Git
    2023.11.22
        : Updated, then upload again
#>

function Get-RandomPassword {
    param (
        [Parameter(Mandatory)]
        [ValidateRange(4,[int]::MaxValue)]
        [int] $length,
        [int] $upper = 1,
        [int] $lower = 1,
        [int] $numeric = 1,
        [int] $special = 1
    )
    if($upper + $lower + $numeric + $special -gt $length) {
        throw "number of upper/lower/numeric/special char must be lower or equal to length"
    }
    $uCharSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    $lCharSet = "abcdefghijklmnopqrstuvwxyz"
    $nCharSet = "0123456789"
    $sCharSet = "/*-+,!?=()@;:._"
    $charSet = ""
    if($upper -gt 0) { $charSet += $uCharSet }
    if($lower -gt 0) { $charSet += $lCharSet }
    if($numeric -gt 0) { $charSet += $nCharSet }
    if($special -gt 0) { $charSet += $sCharSet }
    
    $charSet = $charSet.ToCharArray()
    $rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
    $bytes = New-Object byte[]($length)
    $rng.GetBytes($bytes)
 
    $result = New-Object char[]($length)
    for ($i = 0 ; $i -lt $length ; $i++) {
        $result[$i] = $charSet[$bytes[$i] % $charSet.Length]
    }
    $password = (-join $result)
    $valid = $true
    if($upper   -gt ($password.ToCharArray() | Where-Object {$_ -cin $uCharSet.ToCharArray() }).Count) { $valid = $false }
    if($lower   -gt ($password.ToCharArray() | Where-Object {$_ -cin $lCharSet.ToCharArray() }).Count) { $valid = $false }
    if($numeric -gt ($password.ToCharArray() | Where-Object {$_ -cin $nCharSet.ToCharArray() }).Count) { $valid = $false }
    if($special -gt ($password.ToCharArray() | Where-Object {$_ -cin $sCharSet.ToCharArray() }).Count) { $valid = $false }
 
    if(!$valid) {
         $password = Get-RandomPassword $length $upper $lower $numeric $special
    }
    return $password
}

# 결과를 저장할 배열 선언
$passwords = @()

# 10번 반복하여 함수 실행하고 결과를 배열에 추가
for ($i = 1; $i -le 10; $i++) {
    $password = Get-RandomPassword 15 8 2 2 3
    $passwords += [PSCustomObject]@{
        Index = $i
        Password = $password
    }
}

# Index를 기준으로 정렬하여 출력
$passwords | Sort-Object Index | ForEach-Object {
    "Password $($_.Index): $($_.Password)"
}

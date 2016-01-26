param (
    [string]$cwd,
    [string]$tokens
)

Write-Host 'Entering sample.ps1'
Write-Host "cwd = $cwd"
Write-Host "tokens = $tokens"


if(!$cwd)
{
    throw (Get-LocalizedString -Key "Working directory parameter is not set")
}

if(!(Test-Path $cwd -PathType Container))
{
    throw ("$cwd does not exist");
}

Write-Host "Setting working directory to $cwd"
Set-Location $cwd


Write-Host "Creating token list"
$tokenList = @()
$listOfTokens = $tokens.Split([environment]::NewLine)
Write-Host "    Splitting token lines"
foreach ($tokenLine in $listOfTokens) {
    Write-Host "        Token line: $tokenLine"
    $splitTokenLine = $tokenLine.split("=")
	Write-Host "            Splitting parts of tokenline"
	
    
    $token = New-Object System.Object
    $token | Add-Member -type NoteProperty -name Name -value $splitTokenLine[0]
    $token | Add-Member -type NoteProperty -name Value -value $splitTokenLine[1]
    
	$tokenName = $token.Name
	$tokenValue = $token.Value
	Write-Host "                token.Name = $tokenName" 
	Write-Host "                token.Value = $tokenValue" 
    
	$tokenList += $token
}

Write-Host "Recursively find all *.token files"
$configFiles = Get-ChildItem -Include *.token -Recurse
Write-Host "Swapping tokens"
foreach($configTokenFile in $configFiles) {
	Write-Host "swapping tokens for: " $configTokenFile.FullName
    # going through .token file, swapping out tokens
    foreach($token in $tokenList) {
		$name = $token.Name.Trim()
		$value = $token.Value.Trim()
		 Write-Host "    name: $name"
		 Write-Host "    value: $value"
		 
		(get-content $configTokenFile.FullName) | foreach-object { $_ -replace $name, $value } | set-content ($configTokenFile.FullName+".tmp")
		
        Remove-Item $configTokenFile.FullName
		Rename-Item $($configTokenFile.FullName + ".tmp") $configTokenFile.FullName
    }
	
	#rename token file to config file
	$configFilePath = $configTokenFile.DirectoryName + "\"  + $configTokenFile.Basename
	Remove-Item $configFilePath
	Rename-Item $configTokenFile.FullName $configFilePath
	
}
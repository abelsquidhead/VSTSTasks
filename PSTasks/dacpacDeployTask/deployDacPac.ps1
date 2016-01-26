param (
    [string]$cwd,
    [string]$connectionString,
	[string]$dacpacPath,
	[string]$blockOnPossibleDataLoss
)

Write-Output 'Entering deployDacPac.ps1'
Write-Output "Parameters:"
Write-Output "    cwd = $cwd"
Write-Output "    connectionString = $connectionString"
Write-Output "    dacpacPath = $dacpacPath"
Write-Output "    blockOnPossibleDataLoss = $blockOnPossibleDataLoss"

# Import the Task.Common dll that has all the cmdlets we need for Build
#import-module "Microsoft.TeamFoundation.DistributedTask.Task.Common"

# set the working dirctory
if(!$cwd)
{
    throw (Get-LocalizedString -Key "Working directory parameter is not set")
}

if(!(Test-Path $cwd -PathType Container))
{
    throw ("$cwd does not exist");
}

Write-Output "Creating task directory"
$taskDirectory = $cwd + "\tasks\dacpacDeployTask\0.1.0"
Write-Output "    taskDirectory = $taskDirectory"

Write-Output "Setting working directory to $taskDirctory"
Set-Location $taskDirectory

Write-Output "calculating block value"
if ($blockOnPossibleDataLoss -eq "true")
{
	$blockVar = $true
}
else {
	$blockVar = $false
}
Write-Output "    blockVar = $blockVar"

Write-Output "Creating argument list"
$argumentList = "/Action:Publish /SourceFile:`"$dacpacPath`" /TargetConnectionString:`"$connectionString`" /p:BlockOnPossibleDataLoss=$blockVar"
Write-Output "    argumentList = $argumentList"

Write-Output "Deploying database"
$sqlPackage = $cwd + "\tasks\dacpacDeployTask\0.1.0\SqlPackage\sqlpackage.exe"
Write-Output "    sqlPackage = $sqlPackage"
$processInfo = New-Object System.Diagnostics.ProcessStartInfo
$processInfo.CreateNoWindow = $true
$processInfo.UseShellExecute = $false
$processInfo.useshellexecute = $false
$processInfo.RedirectStandardOutput = $true
$processInfo.RedirectStandardError = $true
$processInfo.filename = "$cwd\tasks\dacpacDeployTask\0.1.0\SqlPackage\sqlpackage.exe"
$processInfo.arguments = $argumentList

$process = New-Object System.Diagnostics.Process
$process.StartInfo = $processInfo
[void] $process.Start()
$output = $process.StandardOutput.ReadToEnd() 
$errorOutput = $process.StandardError.ReadToEnd()
$process.WaitForExit()

write-output "    stdout: $output"

if ($process.ExitCode -ne 0) {
	write-error $errorOutput
	exit $process.ExitCode
}








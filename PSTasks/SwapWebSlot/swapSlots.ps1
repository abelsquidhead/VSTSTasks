[CmdletBinding(DefaultParameterSetName = 'None')]
param
(
    [String] [Parameter(Mandatory = $true)]
    $ConnectedServiceName,

    [String] [Parameter(Mandatory = $true)]
    $WebSiteName,

    [String] [Parameter(Mandatory = $false)]
    $WebSiteLocation,

    [String] [Parameter(Mandatory = $false)]
    $Slot1, 

	[String] [Parameter(Mandatory = $false)]
    $Slot2 
    
)

# Import the Task.Common and Task.Internal dll that has all the cmdlets we need for Build
import-module "Microsoft.TeamFoundation.DistributedTask.Task.Internal"
import-module "Microsoft.TeamFoundation.DistributedTask.Task.Common"

# adding System.Web explicitly, since we use http utility
Add-Type -AssemblyName System.Web

Write-Verbose "Entering script Publish-AzureWebDeployment.ps1"

Write-Host "ConnectedServiceName= $ConnectedServiceName"
Write-Host "WebSiteName= $WebSiteName"
Write-Host "WebSiteLocation= $WebSiteLocation"
Write-Host "Slot1= $Slot1"
Write-Host "Slot2= $Slot2"

Write-Host "Swapping deployment slots..."

Switch-AzureWebsiteSlot -Name $WebSiteName -Slot1 $Slot1 -Slot2 $Slot2 -force

Write-Host "Finished swapping slots"
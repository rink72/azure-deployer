
Param
(
    # Deployment definition. This is a definition in YAML syntax.
    [Parameter()]
    [Object] $WebhookData = @'
---
name: Dummy Deployment
action: Create

VirtualMachines:
 - name: vm1
   size: BIG
 - name: vm2
   size: smaller
   network: private
'@,

  # Verbose switch. Used for displaying verbose messages in testing.
  [Parameter()]
  [boolean] $TestMode = $false
)

# Set testing mode to display output in test pane
if ($TestMode) { $VerbosePreference = 'Continue' }


# If runbook was called from Webhook, WebhookData will not be null.
if ( -not $WebhookData) 
{
  Throw "Expecting webhook data."
  Return
}

# Allow testing from the test pane
if ( -not $WebhookData.RequestBody ) { $deploymentDefinition = $WebhookData }
else { $deploymentDefinition = $WebhookData.RequestBody }

Write-Verbose $deploymentDefinition

# Module imports
Import-Module psyaml

$Conn = Get-AutomationConnection -Name AzureRunAsConnection
$null = Connect-AzureRmAccount -ServicePrincipal -Tenant $Conn.TenantID -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint

$structuredDefinition = $deploymentDefinition | ConvertFrom-Yaml

$definitionName = $structuredDefinition.Name
$virtualMachines = $structuredDefinition.VirtualMachines
$action = $structuredDefinition.action


Write-Verbose -Message "Definition Name: $definitionName"
Write-Verbose -Message "Action: $action"
Write-Verbose -Message "Virtual Machines:"
$virtualMachines | Format-Table
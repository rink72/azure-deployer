
Param
(
    # Deployment definition. This is a definition in YAML syntax.
    [Parameter()]
    [String] $DeploymentDefinition = @'
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
  [switch] $Verbose = $false
)



# Module imports
Import-Module psyaml

$Conn = Get-AutomationConnection -Name AzureRunAsConnection
$null = Connect-AzureRmAccount -ServicePrincipal -Tenant $Conn.TenantID -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint

$structuredDefinition = $DeploymentDefinition | ConvertFrom-Yaml

$definitionName = $structuredDefinition.Name
$virtualMachines = $structuredDefinition.VirtualMachines
$action = $structuredDefinition.action


Write-Verbose -Message "Definition Name: $definitionName"
Write-Verbose -Message "Action: $action"
Write-Verbose -Message "Virtual Machines:"
$virtualMachines | Format-Table
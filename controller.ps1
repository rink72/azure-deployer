# Module imports
Import-Module psyaml


# Deployment definition. This is a definition in YAML syntax.
[Parameter(String)]
[string]
$DeploymentDefinition

$Conn = Get-AutomationConnection -Name AzureRunAsConnection
Connect-AzureRmAccount -ServicePrincipal -Tenant $Conn.TenantID -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint

$structuredDefinition = $DeploymentDefinition | ConvertFrom-Yaml

$definitionName = $structuredDefinition.Name
$virtualMachines = $structuredDefinition.VirtualMachines


Write-Verbose -Message "Definition Name: $definitionName"
Write-Verbose -Message "Virtual Machines:"
$virtualMachines | Format-Table


Param(
    [string]$VM,
    [string]$WorkspaceName,
    [string]$WorkspaceResourceGroup,
    [string]$VMResourceGroup,
    [string]$Location
)

$Workspace =  Get-AzOperationalInsightsWorkspace -ResourceGroupName $WorkspaceResourceGroup -Name $WorkspaceName
$WorkspaceID = $Workspace.CustomerId
$workspaceKey = (Get-AzOperationalInsightsWorkspaceSharedKey -ResourceGroupName $WorkspaceResourceGroup -Name $Workspace.Name).PrimarySharedKey
Set-AzVMExtension -ResourceGroupName $VMResourceGroup -VMName $VM -Name 'MicrosoftMonitoringAgent' -Publisher 'Microsoft.EnterpriseCloud.Monitoring' -ExtensionType 'MicrosoftMonitoringAgent' -TypeHandlerVersion '1.0' -Location $location -SettingString "{'workspaceId':  '$workspaceId'}" -ProtectedSettingString "{'workspaceKey': '$workspaceKey' }"
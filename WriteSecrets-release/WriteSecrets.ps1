Trace-VstsEnteringInvocation $MyInvocation

$ResourceGroupName= Get-VstsInput -Name "ResourceGroupName"
$KeyVaultName= Get-VstsInput -Name "KeyVaultName"
$SecretName= Get-VstsInput -Name "SecretName"
$SecretValue= Get-VstsInput -Name "SecretValue"
$TagValue1 = Get-VstsInput -name "TagValue1"
$TagValue2 = Get-VstsInput -name "TagValue2"
$TagValue3 = Get-VstsInput -name "TagValue3"


################# Initialize Azure. #################
Import-Module $PSScriptRoot\ps_modules\VstsAzureHelpers_
Initialize-Azure

# Verify that specified Key Vault exists
try {
    $DoesKVExist = Get-AzureRmResource -ResourceName $KeyVaultName -ResourceGroupName $ResourceGroupName
}
catch {
    Write-Error "Key Vault $keyVaultName not found in resource group $ResourceGroupName"
    Trace-VstsLeavingInvocation $MyInvocation
    $host.SetShouldExit(1)
}

if (!($DoesKVExist)){
    Write-Error "Key Vault $keyVaultName not found in resource group $ResourceGroupName"
    Trace-VstsLeavingInvocation $MyInvocation
    $host.SetShouldExit(1)
}

# Parse Tag Values
$Tags = @{
    'VSTS Build Definition' = $ENV:BUILD_DEFINITIONNAME
    'VSTS Build Number' = $ENV:BUILD_BUILDNUMBER
}

# Add tags
for ($i=1; $i -le 3; $i++) {
    $tagName = Get-Variable -Name $("tagvalue$i")
    If ($($tagname.Value) -match "=") {
        $Tags.add($($tagname.Value).split('=')[0],$($tagName.Value).split('=')[1])
    }
}

$secret = ConvertTo-SecureString -String $SecretValue -AsPlainText -Force
Write-Output "Creating Key Vault secret named $secretName"
Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $secretName -SecretValue $secret -ContentType 'VSTS-Created' | out-null

Write-Output "Setting tags on Key Vault secret named $secretName"
Set-AzureKeyVaultSecretAttribute -VaultName $KeyVaultName -Name $secretName -Tag $Tags -PassThru | out-null

Trace-VstsLeavingInvocation $MyInvocation

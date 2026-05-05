Import-Module Az.Compute
Import-Module Az.Accounts

# Variables provided by CloudLabs
$resourceGroupName = $resourceGroupName
$deployment_id = $deployment_id
$vmName            = "Lin-vm-1"
$sub_id            = $sub_id

# Set subscription
Select-AzSubscription -SubscriptionId $sub_id

# Retry logic
$stopRetry = $false
[int]$retryCount = 0
$maxRetries = 3

do {
    try {
        # Run command inside VM
        $result = Invoke-AzVMRunCommand `
            -ResourceGroupName $resourceGroupName `
            -Name $vmName `
            -CommandId "RunShellScript" `
            -ScriptString @"
if dpkg -l | grep -q apache2; then
    echo "APACHE_INSTALLED"
else
    echo "APACHE_NOT_INSTALLED"
fi
"@

        $output = $result.Value[0].Message

        # Evaluate result
        if ($output -match "APACHE_INSTALLED") {
            $message = @{
                Status  = "Succeeded"
                Message = "Apache is installed on VM '$vmName'."
            } | ConvertTo-Json
        }
        else {
            $message = @{
                Status  = "Failed"
                Message = "Apache is NOT installed on VM '$vmName'."
            } | ConvertTo-Json
        }

        # Return response
        Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode = [System.Net.HttpStatusCode]::OK
            Body       = $message
        })

        $stopRetry = $true
    }
    catch {
        if ($retryCount -ge $maxRetries) {
            $message = @{
                Status  = "Failed"
                Message = "Retry for validation process has been exhausted. Please try after sometime."
            } | ConvertTo-Json

            Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
                StatusCode = [System.Net.HttpStatusCode]::OK
                Body       = $message
            })

            $stopRetry = $true
        }
        else {
            Write-Host "Validation failed. Retrying... ($($retryCount+1)/$maxRetries)"
            Start-Sleep -Seconds 30
            $retryCount++
        }
    }
} while ($stopRetry -eq $false)

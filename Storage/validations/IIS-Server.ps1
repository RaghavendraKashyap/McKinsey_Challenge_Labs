Import-Module Az.Compute
Import-Module Az.Accounts

# Variables provided by CloudLabs
$deployment_id = $deployment_id
$resourceGroupName = $resourceGroupName
$sub_id = $sub_id
$vmName = "labvm-$deployment_id"

# Set subscription
Select-AzSubscription -SubscriptionId $sub_id

# Retry logic
$stopRetry = $false
[int]$retryCount = 0
$maxRetries = 3

do {
    try {

        # Script to run inside VM
        $script = '
        $feature = Get-WindowsFeature -Name Web-Server

        if ($feature.Installed) {
            Write-Output "Validation Success"
        }
        else {
            Write-Output "Validation Failed"
        }
        '

        # Execute inside VM
        $result = Invoke-AzVMRunCommand `
            -ResourceGroupName $resourceGroupName `
            -VMName $vmName `
            -CommandId "RunPowerShellScript" `
            -ScriptString $script

        $vmOutput = $result.Value[0].Message

        if ($vmOutput -match "Validation Success") {

            $message = @{
                Status  = "Succeeded"
                Message = "IIS Web Server feature is installed on VM '$vmName'."
            } | ConvertTo-Json
        }
        else {

            $message = @{
                Status  = "Failed"
                Message = "IIS Web Server feature is NOT installed on VM '$vmName'."
            } | ConvertTo-Json
        }

        # Return JSON response
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

$region = "us-east-1"
Set-AWSCredential -AccessKey $accessKey -SecretKey $secretKey 
Set-DefaultAWSRegion -Region $region
$buckets = Get-S3Bucket | Select-Object -ExpandProperty BucketName
$flag = 0
foreach ($bucket in $buckets) {
    Write-Host "Checking bucket: $bucket"
    $objects = Get-S3Object -BucketName $bucket | Select-Object -ExpandProperty Key
    foreach ($obj in $objects) { 
        if ($obj -match "\.pdf$" -or $obj -match "\.(jpg|jpeg|png|gif|bmp)$") {
            Write-Host "Found matching file: $obj in bucket: $bucket"
            $flag = 1
            break
        }
    }
    if ($flag -eq 1) {
        break
    }
}

if($flag -eq 1)
{
$message = @{Status ="Succeeded"; Message = "Required file found"}| ConvertTo-Json
            Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
                   StatusCode = [System.Net.HttpStatusCode]::OK
                   Body = $message})
}
else
{
$message = @{Status ="Failed"; Message = "Required file not found"}| ConvertTo-Json
            Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
                   StatusCode = [System.Net.HttpStatusCode]::OK
                   Body = $message})
break
}
 
 
 
Script to Validate Vnet:
 
mport-Module Az.Network
Import-Module Az.Accounts
# Variables provided by CloudLabs
$resourceGroupName = $resourceGroupName
$deployment_id = $deployment_id
$vnet1Name         = "Vnet1"
$vnet2Name         = "Vnet2"
$sub_id            = $sub_id
# Set subscription
Select-AzSubscription -SubscriptionId $sub_id
# Retry logic
$stopRetry = $false
[int]$retryCount = 0
$maxRetries = 3
do {
   try {
       # Get VNets
       $vnet1 = Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $vnet1Name -ErrorAction SilentlyContinue
       $vnet2 = Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $vnet2Name -ErrorAction SilentlyContinue
       if ($null -eq $vnet1 -or $null -eq $vnet2) {
           $message = @{
               Status  = "Failed"
               Message = "One or both VNets ('$vnet1Name', '$vnet2Name') do NOT exist in RG '$resourceGroupName'."
           } | ConvertTo-Json
       }
       else {
           # Check peering from VNet1 to VNet2
           $peering1 = Get-AzVirtualNetworkPeering -VirtualNetworkName $vnet1Name -ResourceGroupName $resourceGroupName |
                       Where-Object { $_.RemoteVirtualNetwork.Id -eq $vnet2.Id }
           # Check peering from VNet2 to VNet1
           $peering2 = Get-AzVirtualNetworkPeering -VirtualNetworkName $vnet2Name -ResourceGroupName $resourceGroupName |
                       Where-Object { $_.RemoteVirtualNetwork.Id -eq $vnet1.Id }
           if ($peering1 -and $peering2) {
               $message = @{
                   Status  = "Succeeded"
                   Message = "Bidirectional peering exists between '$vnet1Name' and '$vnet2Name'. States: VNet1->$($peering1.PeeringState), VNet2->$($peering2.PeeringState)."
               } | ConvertTo-Json
           }
           elseif ($peering1 -or $peering2) {
               $message = @{
                   Status  = "Failed"
                   Message = "Partial peering detected. Ensure bidirectional peering between '$vnet1Name' and '$vnet2Name'."
               } | ConvertTo-Json
           }
           else {
               $message = @{
                   Status  = "Failed"
                   Message = "No peering exists between '$vnet1Name' and '$vnet2Name'."
               } | ConvertTo-Json
           }
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

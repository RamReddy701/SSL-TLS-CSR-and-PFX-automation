param (
    [string]$SerialNumber,
    [string]$CommonName,
    [string]$Password,
    [string]$ExportFolder
)

Try {
    # Find certificate by Serial Number and Common Name
    $cert = Get-ChildItem Cert:\LocalMachine\My | Where-Object {
        $_.SerialNumber -eq $SerialNumber -and
        ($_.Subject -match "CN=$CommonName")
    }

    if ($cert -and $cert.HasPrivateKey) {
        # Convert password to secure string
        $securePwd = ConvertTo-SecureString -String $Password -Force -AsPlainText

        # Debug: Show original Common Name
        Write-Output "Original CommonName: $CommonName"

        # Sanitize Common Name for filename
        $safeName = $CommonName -replace '[\s\\/:*?"<>|]', "_" -replace "\.", "_"

        # Fallback to Serial Number if Common Name is empty or invalid
        if (-not $safeName -or $safeName -eq "") {
            $safeName = $SerialNumber
        }

        # Build filename and export path
        $fileName = "$safeName.pfx"
        $exportPath = Join-Path $ExportFolder $fileName

        # Debug: Show constructed path
        Write-Output "Sanitized SafeName: $safeName"
        Write-Output "Full export path: $exportPath"

        # Export certificate
        Export-PfxCertificate -Cert $cert -FilePath $exportPath -Password $securePwd -ChainOption BuildChain

        Write-Output "Export successful: $fileName"
    } else {
        Write-Output "Export failed: Certificate not found or missing private key"
    }
} Catch {
    Write-Output "Export error: $_"
}

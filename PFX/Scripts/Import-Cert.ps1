param (
    [string]$CertPath
)

Try {
    Import-Certificate -FilePath $CertPath -CertStoreLocation "Cert:\LocalMachine\My" > $null
    Write-Output "Import successful"
} Catch {
    Write-Output "Import failed: $_"
}

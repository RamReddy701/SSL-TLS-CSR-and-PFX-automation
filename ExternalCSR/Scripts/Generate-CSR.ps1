param (
    [string]$CN
)

# Sanitize CN
$CN = $CN -replace '[<>:"/\\|?*]', ''
$CN = $CN.Trim()

# Create INF content
$infContent = @"
[Version]
Signature="\$Windows NT$"

[NewRequest]
Subject = "CN=$CN, OU=JVRL technologies, O=JVRL, L=Hyderabad, S=Telangana, C=india"
KeySpec = 1
KeyLength = 2048
Exportable = TRUE
MachineKeySet = TRUE
SMIME = FALSE
PrivateKeyArchive = FALSE
UserProtected = FALSE
UseExistingKeySet = FALSE
ProviderName = "Microsoft RSA SChannel Cryptographic Provider"
ProviderType = 12
RequestType = PKCS10
KeyUsage = 0xa0

[RequestAttributes]
CertificateTemplate = WebServer
"@

# Write INF to temp file
$tempInf = [System.IO.Path]::GetTempFileName() + ".inf"
$infContent | Out-File -FilePath $tempInf -Encoding ascii

# Generate CSR to temp file
$tempCsr = [System.IO.Path]::GetTempFileName() + ".csr"
certreq -new $tempInf $tempCsr | Out-Null

# Extract only the CSR block
$csrLines = Get-Content $tempCsr | Where-Object { $_ -match '^-----BEGIN.*REQUEST-----' -or $_ -match '^-----END.*REQUEST-----' -or ($_ -notmatch '^(Active Directory|CertReq:)') }
$csrBlock = $csrLines -join "`r`n"

# Output clean CSR
Write-Output $csrBlock

# 🔐 SSL/TLS CSR & PFX Self-Service Web Portal

A browser-based automation toolkit for self-service Certificate Signing Request (CSR) generation and PKCS#12 (.pfx) packaging on Windows/IIS[cite: 2].

---

## 📌 Overview

An automated web application suite running on IIS that enables team members to generate CSRs, download them directly, submit them to Certificate Authorities, and easily import signed certs back to generate password-protected PFX bundles via their web browser—without requiring direct server access or manual MMC Snap-in configuration[cite: 2].

---

## 🔄 End-to-End Browser Workflow

```
       [ Client Browser ]                              [ Windows / IIS Server ]
               |                                                  |
1. Enter CN    | ----- (Submit CSR Request) --------------------> | Generates Key & CSR locally
2. Download    | <---- (Direct File Download: .csr) ------------- | (Key stays in cert store)
               |                                                  |
      [ Submit CSR to CA & Receive Issued Certificate (.cer/.crt) ]
               |                                                  |
3. Upload Cert | ----- (Upload .cer/.crt) ----------------------> | Imports to MMC Certificate Store
               |                                                  | (Binds public cert to private key)
4. Export PFX  | ----- (Submit CN, Serial No, Password) --------> | Bundles Key + Cert into .pfx
5. Download    | <---- (Direct File Download: .pfx) ------------- | Cleans up session files
```

| Step | Portal / Location | Action & Output |
| :--- | :--- | :--- |
| **Step 1: CSR Generation** | External CSR Portal (`/ExternalCSR/Web`) | • User opens site and inputs Common Name (CN).<br>• User clicks **Generate CSR**.<br>• Server generates private key in local store.<br>• `.csr` file is immediately downloaded to the client's browser. |
| **Step 2: CA Issuance** | External / Internal CA (DigiCert, Sectigo, AD CS) | • User submits downloaded `.csr` to Certificate Authority.<br>• CA verifies request and issues signed certificate (`.cer` / `.crt`). |
| **Step 3: Cert Import & PFX Generation** | Cert Manager Portal (`/PFX/Web`) | • User uploads signed `.cer`/`.crt` file and clicks **Import Cert**.<br>• Server imports certificate into Windows MMC Store & pairs with private key.<br>• User enters CN, Serial Number, and a secure password.<br>• User clicks **Generate PFX**.<br>• `.pfx` file downloads immediately to the client browser. |

---

## 🏗️ Architecture & File Structure

```text
SSL-TLS-CSR-and-PFX-automation/
├── ExternalCSR/
│   ├── Scripts/
│   │   └── Generate-CSR.ps1      # PowerShell backend for private key & CSR creation
│   └── Web/
│       ├── Default.aspx          # Web form for CN entry & instant CSR download
│       └── Default.aspx.cs       # Backend logic orchestrating script execution
└── PFX/
    ├── Scripts/
    │   ├── Import-Cert.ps1       # Imports CA response into Windows MMC Local Store
    │   └── Export-Cert.ps1       # Bundles matched cert & key into password-protected PFX
    └── Web/
        ├── Default.aspx          # Web form for upload, serial number, and PFX download
        └── Default.aspx.cs       # Backend logic managing import & PFX streaming
```
[cite: 1, 2]

---

## ⚙️ System Prerequisites & IIS Configuration

### Server Environment
* **Operating System:** Windows Server 2016, 2019, or 2022
* **Web Server:** IIS 8.5+ with ASP.NET Features Enabled
* **Runtime:** .NET Framework 4.7.2 or higher
* **Backend Automation:** Windows PowerShell 5.1 / PowerShell 7+

### IIS Application Setup

1. **Application Deployment:** Create two IIS web applications or virtual directories under your intranet portal
   * Path 1: `/ExternalCSR` pointing to the physical folder `ExternalCSR/Web/`
   * Path 2: `/CertManager` pointing to the physical folder `PFX/Web/`
2. **Application Pool Identity:** Ensure the Application Pool runs under an account with permissions to read/write to the Windows Machine Certificate Store (`Cert:\LocalMachine\My`)[cite: 2]. A dedicated Group Managed Service Account (gMSA) or administrator-privileged identity is recommended
3. **PowerShell Execution Policy:** Allow script execution on the web server by running
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
   ```

---

## 🔒 Security Best Practices

* **Network Access Control:** Host this portal strictly inside your corporate intranet or behind a VPN, and enable Windows Authentication (NTLM/Kerberos) or corporate SSO
* **Mandatory PFX Passwords:** Enforce complex passwords when creating PFX containers to ensure the private key remains secure during transit
* **Ephemeral Temp File Handling:** Ensure temporary uploaded certificates and exported PFX bundles in staging folders are purged immediately after being served to the client browser

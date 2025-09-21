<#
    .SYNOPSIS
        Hardens Windows cryptographic configuration to meet FIPS 140-2, CMMC, and NIST requirements.
    .DESCRIPTION
        Applies comprehensive cryptographic hardening to Windows SChannel, NET Framework, and WinHTTP 
        to comply with CMMC Level 2/3, NIST SP 800-171, FIPS 140-2, and CIS Level 2 benchmarks.
        
        Protocol Configuration:
        - Disables: SSL 2.0, SSL 3.0, TLS 1.0, TLS 1.1, PCT 1.0, Multi-Protocol Unified Hello
        - Enables:  TLS 1.2 and TLS 1.3 only
        
        Cipher Configuration:
        - Disables: RC2, RC4, DES, 3DES, NULL ciphers
        - Enables:  AES 128/256 GCM and CBC modes
        
        Hash Configuration:
        - Disables: MD5
        - Enables:  SHA-1, SHA-256, SHA-384, SHA-512
        
        Key Exchange Configuration:
        - Disables: Weak RSA and DH without minimum key lengths
        - Enables:  ECDH, Diffie-Hellman (2048-bit min), PKCS (2048-bit min)
        
        Additional Configuration:
        - Configures .NET Framework 2.0/3.x/4.x for strong cryptography
        - Configures WinHTTP to use only TLS 1.2/1.3 (DefaultSecureProtocols=0x00002800)
        - Configures FIPS-compliant elliptic curves (P-256, P-384, P-521)
        - Configures performance-optimized cipher suite order prioritizing ECDHE with AES-GCM
        - Enables HTTP/3 and QUIC support
    .NOTES
        Version:        1.0
        Author:         Brian Orange
        Creation Date:  21-SEP-2025
        Purpose/Change: 1.0 Initial script
        Target:         Windows 11 and Windows Server 2025+
        Requirements:   Run as Administrator. System restart required to fully apply changes.
        Compliance:     FIPS 140-2, CMMC Level 2/3, NIST SP 800-171, CIS Level 2
        Performance:    Optimized for modern hardware with AES-NI support
#>

# Main Function, cryptography hardening
function Set-CryptoPolicy {  
    begin {
        Write-Host "[START]   - Starting cryptography hardening..."
        Write-Host "[INFO]    - Target: Windows 11/Server 2025+ with FIPS compliance"
    }
    process {
        try {
            Set-TLSProtocol
            Set-CipherAlgorithms
            Set-HashAlgorithms
            Set-KeyAlgorithms
            Set-DotNetCrypto
            Set-CipherSuiteOrder
            Set-EllipticCurves
        } catch {
            throw "[ERROR]   - Cryptography hardening failed: $_"
        }
    }
    end {
        Write-Host "[SUCCESS] - Cryptography hardening completed successfully"
        Write-Host "[REBOOT]  - A system restart is required to fully apply these changes"
    }
}

# SSL/TLS Protocol Hardening
function Set-TLSProtocol {
    begin {
		Write-Host "[TASK]    - Configuring TLS protocols..."
        $Protocols = @(
            [PSCustomObject]@{Name='Multi-Protocol Unified Hello'; Enabled=0x00000000; Disabled=0x00000001} # Weak   - Microsoft proprietary unified hello protocol
            [PSCustomObject]@{Name='PCT 1.0';                      Enabled=0x00000000; Disabled=0x00000001} # Weak   - Private Communications Technology 1.0
            [PSCustomObject]@{Name='SSL 2.0';                      Enabled=0x00000000; Disabled=0x00000001} # Weak   - Secure Sockets Layer 2.0
            [PSCustomObject]@{Name='SSL 3.0';                      Enabled=0x00000000; Disabled=0x00000001} # Weak   - Secure Sockets Layer 3.0
            [PSCustomObject]@{Name='TLS 1.0';                      Enabled=0x00000000; Disabled=0x00000001} # Weak   - Transport Layer Security 1.0
            [PSCustomObject]@{Name='TLS 1.1';                      Enabled=0x00000000; Disabled=0x00000001} # Weak   - Transport Layer Security 1.1
            [PSCustomObject]@{Name='TLS 1.2';                      Enabled=0xffffffff; Disabled=0x00000000} # Strong - Transport Layer Security 1.2
            [PSCustomObject]@{Name='TLS 1.3';                      Enabled=0xffffffff; Disabled=0x00000000} # Strong - Transport Layer Security 1.3
        )
        $BasePath = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols'
    }
    process {
        try {
            foreach ($Protocol in $Protocols) {
                $ProtocolPath = Join-Path -Path $BasePath     -ChildPath $Protocol.Name
				
                @('Server', 'Client') | ForEach-Object {
                    $SubPath  = Join-Path -Path $ProtocolPath -ChildPath $_

					# Create path only if it doesn't exist
                    if (-not (Test-Path -LiteralPath $SubPath)) {
                        New-Item -Path $SubPath -ErrorAction Stop | Out-Null
                    }
					
					# Set protocol configuration
                    New-ItemProperty -Path $SubPath -Name 'Enabled'           -Value $Protocol.Enabled  -PropertyType DWORD -Force | Out-Null
                    New-ItemProperty -Path $SubPath -Name 'DisabledByDefault' -Value $Protocol.Disabled -PropertyType DWORD -Force | Out-Null
                }
                $Status = if ($Protocol.Enabled -eq 0xffffffff) { 'Enabled' } else { 'Disabled' }
                Write-Host "[INFO]    - Protocol configured: $($Protocol.Name.PadRight(29)) [$Status]"
            }
        } catch {
            throw "[ERROR]   - Failed to configure TLS Protocol $_"
        }
    }
}

# SSL/TLS Cipher Hardening
function Set-CipherAlgorithms {
    begin {
		Write-Host "[TASK]    - Configuring cipher algorithms..." 
        $RegistryPath = "SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers"
        $BaseKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($RegistryPath,$True)
        $Ciphers = @(
            [PSCustomObject]@{Name='AES 128/128';    Enabled=0xffffffff;} # Strong - Advanced Encryption Standard 128-bit
            [PSCustomObject]@{Name='AES 256/256';    Enabled=0xffffffff;} # Strong - Advanced Encryption Standard 256-bit
			[PSCustomObject]@{Name='DES 56/56';      Enabled=0x00000000;} # Weak   - Data Encryption Standard 56-bit
            [PSCustomObject]@{Name='RC2 40/128';     Enabled=0x00000000;} # Weak   - RC2 40-bit  block cipher
            [PSCustomObject]@{Name='RC2 56/128';     Enabled=0x00000000;} # Weak   - RC2 56-bit  block cipher
            [PSCustomObject]@{Name='RC2 128/128';    Enabled=0x00000000;} # Weak   - RC2 128-bit block cipher
            [PSCustomObject]@{Name='RC4 40/128';     Enabled=0x00000000;} # Weak   - RC4 40-bit  stream cipher
            [PSCustomObject]@{Name='RC4 56/128';     Enabled=0x00000000;} # Weak   - RC4 56-bit  stream cipher
            [PSCustomObject]@{Name='RC4 64/128';     Enabled=0x00000000;} # Weak   - RC4 64-bit  stream cipher
            [PSCustomObject]@{Name='RC4 128/128';    Enabled=0x00000000;} # Weak   - RC4 128-bit stream cipher
            [PSCustomObject]@{Name='Triple DES 168'; Enabled=0x00000000;} # Weak   - Triple Data Encryption Standard
            [PSCustomObject]@{Name='NULL';           Enabled=0x00000000;} # Weak   - NULL cipher (no encryption)
        )
    }
    process {
        try {
            # Using .NET Registry API to handle special characters in cipher names
            $BaseKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($RegistryPath, $true)
            if ($null -eq $BaseKey) {
                $BaseKey = [Microsoft.Win32.Registry]::LocalMachine.CreateSubKey($RegistryPath)
            }

            foreach ($Cipher in $Ciphers) {
                $CipherKey = $BaseKey.CreateSubKey($Cipher.Name)
                $CipherKey.SetValue("Enabled", $Cipher.Enabled, [Microsoft.Win32.RegistryValueKind]::DWord)
                $CipherKey.Close()
                Write-Host "[INFO]    - Cipher Algorithm configured: $($Cipher.Name)"
            }
        } catch {
            throw "[ERROR]   - Failed to configure Cipher Algorithm: $_"
        } finally {
            if ($BaseKey) {
                $BaseKey.Close()
            }
        }
    }
}

# Hash Algorithm Hardening
function Set-HashAlgorithms {
    begin {
        $Hashs = @(
            [PSCustomObject]@{Name='MD5';     Enabled=0x00000000} # Weak   - MD5 Message Digest Algorithm
            [PSCustomObject]@{Name='SHA';     Enabled=0xffffffff} # Weak   - SHA-1 Secure Hash Algorithm
            [PSCustomObject]@{Name='SHA256';  Enabled=0xffffffff} # Strong - SHA-2 256-bit Secure Hash Algorithm
            [PSCustomObject]@{Name='SHA384';  Enabled=0xffffffff} # Strong - SHA-2 384-bit Secure Hash Algorithm
            [PSCustomObject]@{Name='SHA512';  Enabled=0xffffffff} # Strong - SHA-2 512-bit Secure Hash Algorithm
        )
    }
    process {
        try {
            foreach ($Hash in $Hashs) {
                $HashPath = (Join-Path -Path HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes -ChildPath $Hash.Name)
                if (-not (Test-Path -LiteralPath $HashPath)) {
                    New-Item -Path $HashPath -Force -ErrorAction Stop | Out-Null
                }
                New-ItemProperty -Path $HashPath -Name 'Enabled' -Value $Hash.Enabled -PropertyType DWORD -Force | Out-Null
                Write-Host "[INFO]    - Hash Algorithm configured:   $($Hash.Name)"
            }
        } catch {
            throw "[ERROR]   - Failed to configure Hash Algorithm: $_"
        }
    }
}

# Key Exchange Algorithm Hardening
function Set-KeyAlgorithms {
    begin {
        $KeyExchanges = @(
            [PSCustomObject]@{Name='RSA';            Enabled=0x00000000; ServerMinKeyBitLength=$null; ClientMinKeyBitLength=$null} # Weak   - RSA key exchange (deprecated, vulnerable to attacks)
            [PSCustomObject]@{Name='DH';             Enabled=0x00000000; ServerMinKeyBitLength=$null; ClientMinKeyBitLength=$null} # Weak   - Basic Diffie-Hellman (vulnerable to Logjam attack)
            [PSCustomObject]@{Name='ECDH';           Enabled=0xffffffff; ServerMinKeyBitLength=$null; ClientMinKeyBitLength=$null} # Strong - Elliptic Curve Diffie-Hellman (FIPS 140-2 approved)
            [PSCustomObject]@{Name='Diffie-Hellman'; Enabled=0xffffffff; ServerMinKeyBitLength=2048;  ClientMinKeyBitLength=2048}  # Strong - Diffie-Hellman key exchange (FIPS 140-2 compliant)
            [PSCustomObject]@{Name='PKCS';           Enabled=0xffffffff; ServerMinKeyBitLength=2048;  ClientMinKeyBitLength=2048}  # Strong - PKCS RSA key exchange (FIPS compliant with sufficient key size)
        )
    }
    process {
        try {
            foreach ($KeyExchange in $KeyExchanges) {
                $KeyPath = (Join-Path -Path HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms -ChildPath $KeyExchange.Name)
                if (-not (Test-Path -LiteralPath $KeyPath)) {
                    New-Item -Path $KeyPath -Force -ErrorAction Stop | Out-Null
                }
                New-ItemProperty -Path $KeyPath -Name "Enabled" -Value $KeyExchange.Enabled -PropertyType DWORD -Force | Out-Null
                Write-Host "[INFO]    - Key Algorithm configured:    $($KeyExchange.Name)"
                if ($KeyExchange.ServerMinKeyBitLength) {
                    New-ItemProperty -Path $KeyPath -Name "ServerMinKeyBitLength" -Value $KeyExchange.ServerMinKeyBitLength -PropertyType DWORD -Force | Out-Null
                    Write-Host "[INFO]        - ServerMinKeyBitLength:   $($KeyExchange.ServerMinKeyBitLength) bits"
                }
                if ($KeyExchange.ClientMinKeyBitLength) {
                    New-ItemProperty -Path $KeyPath -Name "ClientMinKeyBitLength" -Value $KeyExchange.ClientMinKeyBitLength -PropertyType DWORD -Force | Out-Null
                    Write-Host "[INFO]        - ClientMinKeyBitLength:   $($KeyExchange.ClientMinKeyBitLength) bits"
                }
            }
        } catch {
            throw "[ERROR]   - Failed to configure Key Exchange Algorithm: $_"
        }
    }
}

# .NET Framework Cryptography Hardening
function Set-DotNetCrypto {
    begin {
        $HTTPClient = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp'
        $HTTPSystem = 'HKLM:\SYSTEM\CurrentControlSet\Services\HTTP\Parameters'
        $NetPaths = @(
            'HKLM:\SOFTWARE\Microsoft\.NETFramework\v2.0.50727',
            'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319',
            'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v2.0.50727',
            'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319'
        ) | Where-Object { Test-Path $_ }
    }
    process {
        try {
            foreach ($NetPath in $NetPaths) {
                New-ItemProperty -Path $NetPath -Name 'SchUseStrongCrypto'                 -Value 1 -PropertyType DWORD -Force | Out-Null
                New-ItemProperty -Path $NetPath -Name 'SystemDefaultTlsVersions'           -Value 1 -PropertyType DWORD -Force | Out-Null
                if ($NetPath -match 'v4\.0') {
                    New-ItemProperty -Path $NetPath -Name 'SendAuxRecord'                  -Value 0 -PropertyType DWORD -Force | Out-Null
                    New-ItemProperty -Path $NetPath -Name 'CheckCertificateRevocationList' -Value 1 -PropertyType DWORD -Force | Out-Null
                }
                $Version   = if ($NetPath -match 'Wow6432Node') {('32-bit')} else {('64-bit')}
                $Framework = if ($NetPath -match 'v4\.0') { 'NET Framework 4.0' } elseif ($NetPath -match 'v2\.0') { 'NET Framework 2.0' }
                Write-Host "[INFO]    - NET Framework Configured:    $Framework $($Version.PadRight(11)) [TLS 1.2+]"

            }
            
            # Configure WinHTTP client protocols (TLS 1.2 and 1.3)
            if (-not (Test-Path -LiteralPath $HTTPClient)) {
                New-Item -Path $HTTPClient -ErrorAction Stop | Out-Null
            }
            # 0x00002800 = TLS 1.2 (0x800) + TLS 1.3 (0x2000)
            New-ItemProperty -Path $HTTPClient -Name 'DefaultSecureProtocols' -Value 0x00002800 -PropertyType DWORD -Force | Out-Null
            Write-Host "[INFO]    - WinHTTP client configured:   TLS 1.2/1.3"
            
            # Configure HTTP/3 and QUIC support
            if (-not (Test-Path -LiteralPath $HTTPSystem)) {
                New-Item -Path $HTTPSystem -ErrorAction Stop | Out-Null
            }
            New-ItemProperty -Path $HTTPSystem -Name 'EnableHttp3' -Value 1 -PropertyType DWORD -Force | Out-Null
            New-ItemProperty -Path $HTTPSystem -Name 'EnableAltSvc' -Value 1 -PropertyType DWORD -Force | Out-Null
            Write-Host "[INFO]    - WinHTTP system configured:   HTTP3/QUIC"
            
        } catch {
            throw "[ERROR]   - Failed to configure NET Framework cryptography settings: $_"
        }
    }
}

# Cipher Suite Order Configuration
function Set-CipherSuiteOrder {
    begin {
        $CipherSuiteRegistryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002'
        $CipherSuiteOrder = @(
			# TLS 1.3 Cipher Suites
            "TLS_AES_128_GCM_SHA256",                   # TLS 1.3 AES   (Performance)
            "TLS_AES_256_GCM_SHA384",                   # TLS 1.3 AES   (Strength)
            # TLS 1.2 ECDHE with AES-GCM (PFS, AEAD)
            "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",  # TLS 1.2 ECDSA (Performance)
            "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384",  # TLS 1.2 ECDSA (Strength)
            "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",    # TLS 1.2 RSA   (Performance)
            "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",    # TLS 1.2 RSA   (Strength)
            # TLS 1.2 DHE with AES-GCM (PFS)
            "TLS_DHE_RSA_WITH_AES_128_GCM_SHA256",      # TLS 1.2 DHE   (Performance)
            "TLS_DHE_RSA_WITH_AES_256_GCM_SHA384",		# TLS 1.2 DHE   (Strength)
            # TLS 1.2 ECDHE with AES-CBC (Fallback)
            "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256",  # TLS 1.2 ECDSA (Fallback)
            "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384",  # TLS 1.2 ECDSA (Fallback)
            "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256",    # TLS 1.2 RSA   (Fallback)
            "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384",    # TLS 1.2 RSA   (Fallback)
            # TLS 1.2 Non-PFS fallbacks (FIPS compliant but less secure)
            "TLS_RSA_WITH_AES_128_GCM_SHA256",          # TLS 1.2 RSA   (Compatibility)
            "TLS_RSA_WITH_AES_256_GCM_SHA384",          # TLS 1.2 RSA   (Compatibility)
            "TLS_RSA_WITH_AES_128_CBC_SHA256",          # TLS 1.2 RSA   (Compatibility)
            "TLS_RSA_WITH_AES_256_CBC_SHA256"           # TLS 1.2 RSA   (Compatibility)
        ) -join ','
    }
    process {
        try {
            if (-not (Test-Path -LiteralPath $CipherSuiteRegistryPath)) {
                $ParentPath = Split-Path -Parent $CipherSuiteRegistryPath
                if (-not (Test-Path -LiteralPath $ParentPath)) {
                    New-Item -Path $ParentPath -ErrorAction Stop | Out-Null
                }
                New-Item -Path $CipherSuiteRegistryPath -ErrorAction Stop | Out-Null
            }
            New-ItemProperty -Path $CipherSuiteRegistryPath -Name 'Functions' -Value $CipherSuiteOrder -PropertyType String -Force | Out-Null
            Write-Host "[INFO]    - Cipher priority configured:  TLS 1.3 > ECDHE-GCM > DHE-GCM > ECDHE-CBC > RSA"
            
        } catch {
            throw "Failed to set TLS cipher suite order: $_"
        }
    }
}

# Elliptic Curve Configuration - FIPS approved curves only
function Set-EllipticCurves {   
    begin {
        $EccRegistryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002'
        $EllipticCurveOrder = @(
            "NistP256",  # P-256, fastest NIST curve, widely supported
            "NistP384",  # P-384, good balance
            "NistP521"   # P-521, maximum security
                         # curve25519 is not FIPS 140-2 approved, so excluded
        ) -join ','
    }
    process {
        try {
            if (-not (Test-Path -LiteralPath $EccRegistryPath)) {
                $ParentPath = Split-Path -Parent $EccRegistryPath
                if (-not (Test-Path -LiteralPath $ParentPath)) {
                    New-Item -Path $ParentPath -ErrorAction Stop | Out-Null
                }
                New-Item -Path $EccRegistryPath -ErrorAction Stop | Out-Null
            }
            New-ItemProperty -Path $EccRegistryPath -Name 'EccCurves' -Value $EllipticCurveOrder -PropertyType String -Force | Out-Null           
            Write-Host "[INFO]    - Elliptic curves configured:  P-256 > P-384 > P-521"
        } catch {
            throw "[ERROR] - Failed to configure elliptic curves: $_"
        }
    }
}

# Execute the main function
try {
    Set-CryptoPolicy
} catch {
    Write-Host "[FATAL]   - Script execution failed: $_"
    exit 1
}

using win32api

#List windows Certificates

if Sys.iswindows()
    println("Running on Windows!")

    end
    
    # Close the store
    Win32API.WinCrypt.CertCloseStore(store, 0)
    
else
    error("CertStore.jl is not needed.  Not running on Windows.")
end


    # Open the "MY" store
    store_name = "MY"
    store = Win32API.WinCrypt.CertOpenSystemStoreW(0, store_name)
    
    # Check if the store was opened successfully
    if store == 0
        error("Failed to open certificate store $store_name")
    end
    
    # Iterate over the certificates in the store
    cert_context = Ref{Cvoid}(0)
    while true
        cert_context[] = Win32API.WinCrypt.CertEnumCertificatesInStore(store, cert_context[])
        if cert_context[] == 0
            # No more certificates
            break
        end
        
        # Get the certificate info
        cert_info = Win32API.WinCrypt.PCERT_CONTEXT(cert_context[])
        cert = Win32API.WinCrypt.X509Certificate(cert_info)
        
        # Check if the certificate is valid
        if !Win32API.WinCrypt.CertVerifyTimeValidity(nothing, cert_info.pCertInfo)
            continue
        end
        
        # Print the certificate subject and issuer
        subject = Win32API.WinCrypt.get_cert_subject(cert)
        issuer = Win32API.WinCrypt.get_cert_issuer(cert)
        println("Subject: $subject")
        println("Issuer: $issuer")
        println()
    end

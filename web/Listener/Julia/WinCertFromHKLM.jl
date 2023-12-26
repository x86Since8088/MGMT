
using WinReg

# Open the registry key for the current user's certificate store
hkey = WinReg.openkey(WinReg.HKEY_LOCAL_MACHINE, "Software\\Microsoft\\SystemCertificates\\My")

# Get the number of subkeys (certificates) in the store
num_certs = WinReg.queryinfokey(hkey)[3]

# Loop over the subkeys and print information about each certificate
for i in 0:num_certs-1
    cert_key = WinReg.enumkey(hkey, i)
    cert = WinReg.openkey(hkey, cert_key)
    
    # Extract certificate details
    subject = WinReg.queryvalue(cert, "Subject")[1]
    issuer = WinReg.queryvalue(cert, "Issuer")[1]
    valid_from = WinReg.queryvalue(cert, "Valid From")[1]
    valid_to = WinReg.queryvalue(cert, "Valid To")[1]
    
    # Print certificate details
    println("Certificate $i:")
    println("Subject: $subject")
    println("Issuer: $issuer")
    println("Valid from: $valid_from")
    println("Valid to: $valid_to")
    println()
end

# Close the registry key
WinReg.closekey(hkey)

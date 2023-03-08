param (
    $Policy
)
try {
add-type @"
        using System.Net;
        using System.Security.Cryptography.X509Certificates;
        public class TrustAllCertsPolicy : ICertificatePolicy {
            public bool CheckValidationResult(
                ServicePoint srvPoint, X509Certificate certificate,
                WebRequest request, int certificateProblem) {
                return true;
            }
        }
"@
    }
    catch {
        # Ignore the error if the type already exists
    }
    if ($null -eq $Policy)
    {
        $Policy = New-Object TrustAllCertsPolicy
    }
    [System.Net.ServicePointManager]::CertificatePolicy = $Policy
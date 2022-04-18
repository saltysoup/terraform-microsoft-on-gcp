# Configuration Data for AD
$ConfigData = @{
    AllNodes = @(
        @{
            Nodename = "dsc-testNode1"
            Role = "Primary DC"
            DomainName = "dsc-test.contoso.com"
            CertificateFile = "C:\publicKeys\targetNode.cer"
            Thumbprint = "AC23EA3A9E291A75757A556D0B71CBBF8C4F6FD8"
            RetryCount = 20
            RetryIntervalSec = 30
        },
        @{
            Nodename = "dsc-testNode2"
            Role = "Replica DC"
            DomainName = "dsc-test.contoso.com"
            CertificateFile = "C:\publicKeys\targetNode.cer"
            Thumbprint = "AC23EA3A9E291A75757A556D0B71CBBF8C4F6FD8"
            RetryCount = 20
            RetryIntervalSec = 30
        }
    )
}
#### helper scripts ####
. "C:\Scripts\get-secrets.ps1"
$secrets = Get-Secrets

<# obj structure
{
    "domainName" = "XXX",
    "domainAdminUser" = "XXX",
    "domainAdminPassword" = "XXX",
    "domainSafemodeUser" = "XXX",
    "domainSafemodePassword" = "XXX"
}
#>

# Retrieve AD config
$baseMetadata_uri = "http://metadata.google.internal/computeMetadata/v1/instance/attributes/"
$customMetadata_ADRole_Key = "ADRole"
$fullURI = $baseMetadata_uri+$customMetadata_ADRole_Key
$customMetadata_ADRole_Value = Invoke-RestMethod -Headers @{'Metadata-Flavor' = 'Google'} -Uri $fullURI # value returns primary or secondary for respective configs


[String]$domainName = $secrets.domainName
[String]$domainAdminUser = $secrets.domainAdminUser
[String]$domainSafemodeUser = $secrets.domainSafemodeUser
[SecureString]$domainAdminPasswordsecString = ConvertTo-SecureString ([String]$secrets.domainAdminPassword) -AsPlainText -Force
[SecureString]$domainSafemodePasswordsecString = ConvertTo-SecureString ([String]$secrets.domainSafemodePassword) -AsPlainText -Force

[System.Management.Automation.PSCredential]$DomainAdminCred = New-Object System.Management.Automation.PSCredential("$domainName\$domainAdminUser", $domainAdminPasswordsecString)
[System.Management.Automation.PSCredential]$DomainSafeModeCred = New-Object System.Management.Automation.PSCredential("$domainName\$domainSafemodeUser", $domainSafemodePasswordsecString)

# A configuration to Create High Availability Domain Controller
Configuration CreateNewADForestHAMode
{
    param(
      [Parameter(Mandatory)]
      [String]$domainName,

      [Parameter(Mandatory)]
      [System.Management.Automation.PSCredential]$domainAdminCred,

      [Parameter(Mandatory)]
      [System.Management.Automation.PSCredential]$domainSafeModeCred,

      [Int]$retryCount=20,
      [Int]$retryIntervalSec=30
    )
    
    Import-DscResource -ModuleName xActiveDirectory,NetworkingDsc,PSDesiredStateConfiguration

    Write-Host "CAV is: $customMetadata_ADRole_Value"
    if ($customMetadata_ADRole_Value -ne "primary")
    {
        Node $ENV:COMPUTERNAME
        {
            WindowsFeature ADDSInstall
            {
                Ensure = "Present"
                Name = "AD-Domain-Services"
            }
        
            WindowsFeature DNS
            {
                Ensure = "Present"
                Name = "DNS"
            }

            DnsServerAddress DnsServerAddress
            {
                Address        = '127.0.0.1',(Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Select-Object -ExpandProperty "NextHop")
                InterfaceAlias = 'Ethernet'
                AddressFamily  = 'IPv4'
                Validate       = $true
                DependsOn      = "[WindowsFeature]DNS"
            }

            xADDomain FirstDC
            {
                DomainName = $domainName
                DomainAdministratorCredential = $domainAdminCred
                SafemodeAdministratorPassword = $domainSafeModeCred
                # Specifies the fully qualified, non-Universal Naming Convention (UNC) path to a directory on a fixed disk of the local computer that contains the domain database (optional).
                DatabasePath                  = "C:\NTDS"
                # Specifies the fully qualified, non-UNC path to a directory on a fixed disk of the local computer where the log file for this operation will be written (optional).
                LogPath                       = "C:\NTDS"
                # Specifies the fully qualified, non-UNC path to a directory on a fixed disk of the local computer where the Sysvol file will be written. (optional)
                SysvolPath                    = "C:\SYSVOL"
                DependsOn = "[WindowsFeature]ADDSInstall"
            }
            xWaitForADDomain DomainWait
            {
                DomainName = $domainName
                DomainUserCredential = $domainAdminCred
                RetryCount = $retryCount
                RetryIntervalSec = $retryIntervalSec
                DependsOn = "[xADDomain]FirstDC"
            }
            # Enable Recycle Bin
            xADRecycleBin RecycleBin
            {
                # Credential with Enterprise Administrator rights to the forest.
                EnterpriseAdministratorCredential = $domainAdminCred
                # Fully qualified domain name of forest to enable Active Directory Recycle Bin.
                ForestFQDN                        = $domainName
                DependsOn                         = "[xWaitForADDomain]DomainWait"
            }
            xADUser ADUser
            {
                DomainName                    = $domainName
                DomainAdministratorCredential = $domainAdminCred
                UserName                      = "AdminUser"
                Password                      = $domainAdmin
                Ensure                        = "Present"
                DependsOn                     = "[xWaitForADDomain]DomainWait"
            }
            Group AddADUserToLocalAdminGroup {
                GroupName='Administrators'
                Ensure= 'Present'
                MembersToInclude= "$domainName\AdminUser"
                Credential = $domainAdminCred
                PsDscRunAsCredential = $domainAdminCred
            }
        }
    }
    else
    {
        Write-Host "Nothing!"
    }
}


#### Configuration Data ####
$cd = @{
    AllNodes = @(
        @{
            Nodename = $ENV:COMPUTERNAME
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser = $true
        }
    )
}

    
CreateNewADForestHAMode -ConfigurationData $cd -domainName $domainName -domainAdminCred $domainAdminCred -domainSafeModeCred $domainSafeModeCred -OutputPath "C:\LCMConfig"

Start-DscConfiguration -ComputerName $ENV:COMPUTERNAME -Wait -Force -Verbose -Path "C:\LCMConfig"

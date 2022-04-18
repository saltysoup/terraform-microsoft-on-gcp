<#
    .SYNOPSIS
    install-ad-modules.ps1
    .DESCRIPTION
    This script downloads and installs the required PowerShell modules to create and configure Active Directory Domain Controllers. 
    It also creates a self signed certificate to be uses with PowerShell DSC.
    
    .EXAMPLE
    .\install-ad-modules
#>

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#==================================================
# Variables
#==================================================

$Modules = @(
    @{
        Name = 'NetworkingDsc'
        Version = '8.2.0'
    },
    @{
        Name = 'ActiveDirectoryDsc'
        Version = '6.0.1'
    },
    @{
        Name = 'ComputerManagementDsc'
        Version = '8.4.0'
    },
    @{
        Name = 'xDnsServer'
        Version = '1.16.0.0'
    },
    @{
        Name = 'xActiveDirectory'
        Version = '3.0.0.0'
    }
)

#==================================================
# Main
#==================================================

Write-Output 'Installing NuGet Package Provider'
Try {
    $Null = Install-PackageProvider -Name 'NuGet' -MinimumVersion '2.8.5' -Force -ErrorAction Stop
} Catch [System.Exception] {
    Write-Output "Failed to install NuGet Package Provider $_"
    Exit 1
}

Write-Output 'Setting PSGallery Respository to trusted'
Try {
    Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted' -ErrorAction Stop
} Catch [System.Exception] {
    Write-Output "Failed to set PSGallery Respository to trusted $_"
    Exit 1
}

Write-Output 'Installing the needed Powershell DSC modules for this Quick Start'
Foreach ($Module in $Modules) {
    Try {
        Install-Module -Name $Module.Name -RequiredVersion $Module.Version -ErrorAction Stop
    } Catch [System.Exception] {
        Write-Output "Failed to Import Modules $_"
        Exit 1
    }
}

Write-Output 'Temporarily disabling Windows Firewall'
Try {
    Get-NetFirewallProfile -ErrorAction Stop | Set-NetFirewallProfile -Enabled False -ErrorAction Stop
} Catch [System.Exception] {
    Write-Output "Failed to disable Windows Firewall $_"
    Exit 1
}
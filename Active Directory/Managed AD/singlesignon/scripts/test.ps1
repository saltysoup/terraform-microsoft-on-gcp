<#
param (
    [Parameter(Mandatory=$true)]
    [string]$localAdminUsername = 'localAdminUsername',
    [Parameter(Mandatory=$true)]
    [string]$localAdminPassword = 'localAdminPassword',
    [Parameter(Mandatory=$true)]
    [string]$ManagedADAdminUsername = 'ManagedADAdminUsername',
    [Parameter(Mandatory=$true)]
    [string]$ManagedADAdminPassword = 'ManagedADAdminPassword'
)
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$first,
    [Parameter(Mandatory=$true)]
    [string]$second
)

Add-Content -Path "C:\parameters.txt" -Value "param1: $first | param2: $second"

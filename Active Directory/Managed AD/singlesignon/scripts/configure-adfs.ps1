param (
    [Parameter(Mandatory=$true)]
    [string]$localAdminUsername,
    [Parameter(Mandatory=$true)]
    [string]$localAdminPassword,
    [Parameter(Mandatory=$true)]
    [string]$managedADAdminUsername,
    [Parameter(Mandatory=$true)]
    [string]$managedADAdminPassword
)

Add-Content -Path "C:\parameters.txt" -Value "param1: $localAdminUsername | param2: $localAdminPassword | param3: $managedADAdminUsername | param4: $managedADAdminPassword"

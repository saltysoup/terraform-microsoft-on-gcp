param (
    [Parameter(Mandatory=$true)]
    [string]$first,
    [Parameter(Mandatory=$true)]
    [string]$second
)

Add-Content -Path "C:\parameters.txt" -Value "param1: $first | param2: $second"

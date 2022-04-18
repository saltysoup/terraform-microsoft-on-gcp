function Get-Secrets()
{
    # local mapping to secret ids pre-configured in secrets manager
    $domainName = "win-addomainname"
    $domainAdminUser = "win-addomainuser"
    $domainAdminPassword = "win-addomainpassword"
    $domainSafemodeUser = "win-adsafemodeuser"
    $domainSafemodePassword = "win-adsafemodepassword"

    $secrets = @{}

    try
    {
        $secrets["domainName"] = gcloud secrets versions access latest --secret=$domainName
        $secrets["domainAdminUser"] = gcloud secrets versions access latest --secret=$domainAdminUser
        $secrets["domainAdminPassword"] = gcloud secrets versions access latest --secret=$domainAdminPassword
        $secrets["domainSafemodeUser"] = gcloud secrets versions access latest --secret=$domainSafemodeUser
        $secrets["domainSafemodePassword"] = gcloud secrets versions access latest --secret=$domainSafemodePassword
    }
    catch
    {
        throw "Error whilst retrieving values from secrets manager: $_"
    }  

    return $secrets
}




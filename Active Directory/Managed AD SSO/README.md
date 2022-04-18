# TODO
## pre-req
1. existing google cloud org/domain

## Google Admin (Gaia)
1. Create new user
2. Give super admin perms
3. disable Require password change
J<BBjb2g

## Create new Managed AD
1. Set password for setupadmin

## ADFS VM
### Configuration of VM
1. Install RSAT and ADFS role
2. Create C:\temp dir 
3. Download GCDS agent https://dl.google.com/dirsync/dirsync-win64.exe to C:\temp
4. install - start-process -FilePath "C:\temp\dirsync-win64.exe" -ArgumentList "-q -dir `"C:\Program Files\Google Cloud Directory Sync2`""
5. Domain join to managed ad
6. Restart VM
### Configuring ADFS
1. Creat nested containers under cloud ou
2. create new self sign cert
3. Install ADFS server farm using cert and DKM container
4. enable idp initiated sign on page
5. Configure claims/trusts https://cloud.google.com/architecture/identity/federating-gcp-with-active-directory-configuring-single-sign-on#configuring_adfs

## Cloud Identity
1. Enabled SSO with 3P idp
2. upload ADFS cert




https://accounts.google.com/o/oauth2/auth/identifier?client_id=118556098869.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Flocalhost%3A50223%2FCallback&response_type=code&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fadmin.directory.resource.calendar%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fapps.licensing%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fapps.groups.settings%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fadmin.directory.orgunit%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fplus.me%20https%3A%2F%2Fwww.google.com%2Fm8%2Ffeeds%2F%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fadmin.directory.user%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fadmin.directory.userschema%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fadmin.directory.group&flowName=GeneralOAuthFlow

https://accounts.google.com/o/oauth2/auth/identifier?client_id=118556098869.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Flocalhost%3A50268%2FCallback&response_type=code&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fadmin.directory.resource.calendar%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fapps.licensing%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fapps.groups.settings%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fadmin.directory.orgunit%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fplus.me%20https%3A%2F%2Fwww.google.com%2Fm8%2Ffeeds%2F%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fadmin.directory.user%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fadmin.directory.userschema%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fadmin.directory.group&flowName=GeneralOAuthFlow
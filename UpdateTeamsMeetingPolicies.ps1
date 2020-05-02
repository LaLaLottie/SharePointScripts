Install-Module MSOnline -Scope CurrentUser # Installing the Office 365 Module.

Connect-MsolService # Signing into Office 365.

$users = Get-MsolUser # Get all users in the tenant.

Set-ExecutionPolicy unrestricted -Scope CurrentUser 

Import-Module SkypeOnlineConnector # Sign into Skype for Business

$cred = Get-Credential

$session = New-CsOnlineSession -Credential $cred -Verbose

Import-PSSession -Session $session

$policies = Get-CsTeamsMeetingPolicy # Get all the meeting policies for this Teams.

Write-Output $("`n" + $users.Count + " total users: `n") # Print the total number of users in the tenant.

$num = 0

foreach ($user in $users) { # Print some of the user information and grant the user the Global meeting policy.
    Write-Output $user.DisplayName
    Write-Output $($user.UserPrincipalName + "`n")

    Grant-CsTeamsMeetingPolicy -PolicyName $null -Identity $user.UserPrincipalName
    $num = $num + 1
}

Write-Output $("`n" + $num + " users' meeting policy has been updated.")

#Disconnect-PSSession -Session $session
# Overview
The Get-ADDirectReports function retrieves the direct reports property for a specified Active Directory account. The function also has a Recurse parameter that can be specified to find all indirect users reporting to the specified account.

# Prerequisites
The ActiveDirectory module must be available in your PowerShell environment. This module is typically installed by default on domain-joined computers with the Remote Server Administration Tools (RSAT) feature installed.

# Example
To use the Get-ADDirectReports function, simply specify the Identity parameter with the name of the account you want to inspect. Optionally, you can specify the Recurse parameter to find all indirect users reporting to the specified account.

Here is an example of how to use the function:
``` powershell
Get-ADDirectReports -Identity Test_director
Get-ADDirectReports -Identity Test_director -Recurse
```

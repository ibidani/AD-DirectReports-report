# This function retrieves the direct reports property for the specified Identity.
# The Recurse parameter can be specified to find all indirect users reporting to the specified Identity.
#
# Parameters:
#   -Identity: the account to inspect
#   -Recurse: specifies whether to retrieve all indirect users under the specified Identity
#
# Examples:
#   Get-ADDirectReports -Identity Test_director
#   Get-ADDirectReports -Identity Test_director -Recurse
#
function Get-ADDirectReports
{
    [CmdletBinding()]
    PARAM (
        [Parameter(Mandatory)]
        [String[]]$Identity,
        [Switch]$Recurse
    )

    # Import the ActiveDirectory module if it is not already available
    if (-not (Get-Module -Name ActiveDirectory)) { Import-Module -Name ActiveDirectory -ErrorAction 'Stop' -Verbose:$false }

    foreach ($Account in $Identity)
    {
        try
        {
            if ($PSBoundParameters['Recurse'])
            {
                # Get the DirectReports for the specified Identity (recursively)
                Write-Verbose -Message "[PROCESS] Account: $Account (Recursive)"
                Get-Aduser -identity $Account -Properties directreports |
                ForEach-Object -Process {
                    $_.directreports | ForEach-Object -Process {
                        # Output the current object with the properties Name, SamAccountName, Mail, and Manager
                        Get-ADUser -Identity $PSItem -Properties mail, manager, Title | Select-Object -Property Name, SamAccountName, Title, Mail, @{ Name = "Manager"; Expression = { (Get-Aduser -identity $psitem.manager).samaccountname } }
                        # Gather DirectReports for the current object and repeat for each indirect report
                        Get-ADDirectReports -Identity $PSItem -Recurse
                    }
                }
            }
            else
            {
                # Get the DirectReports for the specified Identity
                Write-Verbose -Message "[PROCESS] Account: $Account"
                Get-Aduser -identity $Account -Properties directreports |
                ForEach-Object -Process {
                    $_.directreports | ForEach-Object -Process {
                        # Output the current object with the properties Name, SamAccountName, Mail, and Manager
                        Get-ADUser -Identity $PSItem -Properties mail, manager, Title | Select-Object -Property Name, SamAccountName, Title, Mail, @{ Name = "Manager"; Expression = { (Get-Aduser -identity $psitem.manager).samaccountname } }
                    }
                }
            }
        }
        catch
        {
            Write-Verbose -Message "[PROCESS] Something went wrong for Account: $Account"
            Write-Verbose -Message $Error[0].Exception.Message
        }
    }
}

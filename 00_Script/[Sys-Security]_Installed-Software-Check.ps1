function Get-Software
{
    <#
        .SYNOPSIS
        Reads installed software from registry

        .PARAMETER DisplayName
        Name or part of name of the software you are looking for

        .EXAMPLE
        Get-Software -DisplayName *Office*
        returns all software with "Office" anywhere in its name
    #>

    param
    (
    # emit only software that matches the value you submit:
    [string]
    $DisplayName = '*'
    )


    #region define friendly texts:
    $Scopes = @{
        HKLM = 'All Users'
        HKCU = 'Current User'
    }

    $Architectures = @{
        $true = '32-Bit'
        $false = '64-Bit'
    }
    #endregion

    #region define calculated custom properties:
        # add the scope of the software based on whether the key is located
        # in HKLM: or HKCU:
        $Scope = @{
            Name = 'Scope'
            Expression = {
            $Scopes[$_.PSDrive.Name]
            }
        }

        # add architecture (32- or 64-bit) based on whether the registry key 
        # contains the parent key WOW6432Node:
        $Architecture = @{
        Name = 'Architecture'
        Expression = {$Architectures[$_.PSParentPath -like '*\WOW6432Node\*']}
        }
    #endregion

    #region define the properties (registry values) we are after
        # define the registry values that you want to include into the result:
        $Values = 'AuthorizedCDFPrefix',
                    'Comments',
                    'Contact',
                    'DisplayName',
                    'DisplayVersion',
                    'EstimatedSize',
                    'HelpLink',
                    'HelpTelephone',
                    'InstallDate',
                    'InstallLocation',
                    'InstallSource',
                    'Language',
                    'ModifyPath',
                    'NoModify',
                    'PSChildName',
                    'PSDrive',
                    'PSParentPath',
                    'PSPath',
                    'PSProvider',
                    'Publisher',
                    'Readme',
                    'Size',
                    'SystemComponent',
                    'UninstallString',
                    'URLInfoAbout',
                    'URLUpdateInfo',
                    'Version',
                    'VersionMajor',
                    'VersionMinor',
                    'WindowsInstaller',
                    'Scope',
                    'Architecture'
    #endregion

    #region Define the VISIBLE properties
        # define the properties that should be visible by default
        # keep this below 5 to produce table output:
        [string[]]$visible = 'DisplayName','DisplayVersion','Scope','Architecture'
        [Management.Automation.PSMemberInfo[]]$visibleProperties = [System.Management.Automation.PSPropertySet]::new('DefaultDisplayPropertySet',$visible)
    #endregion

    #region read software from all four keys in Windows Registry:
        # read all four locations where software can be registered, and ignore non-existing keys:
        Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
                            'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
                            'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
                            'HKCU:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction Ignore |
        # exclude items with no DisplayName:
        Where-Object DisplayName |
        # include only items that match the user filter:
        Where-Object { $_.DisplayName -like $DisplayName } |
        # add the two calculated properties defined earlier:
        Select-Object -Property *, $Scope, $Architecture |
        # create final objects with all properties we want:
        Select-Object -Property $values |
        # sort by name, then scope, then architecture:
        Sort-Object -Property DisplayName, Scope, Architecture |
        # add the property PSStandardMembers so PowerShell knows which properties to
        # display by default:
        Add-Member -MemberType MemberSet -Name PSStandardMembers -Value $visibleProperties -PassThru
    #endregion 
}

#Execution command#1: Get-Software
#Execution command#1: Get-Software | Select-Object -Property *

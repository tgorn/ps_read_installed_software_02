# Registry locations for installed software
$paths = 
  # all users x64
  'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*', 
  # all users x86
  'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*', 
  # current user x64
  'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*', 
  # current user x86
  'HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
 
# calculated properties
 
# AllUsers oder CurrentUser?
$user = @{
    Name = 'Scope'
    Expression = { 
        if ($_.PSDrive -like 'HKLM' )
        {
            'AllUsers'
        }
        else
        {
            'CurrentUser'
        }
    }
}
 
# 32- or 64-Bit?
$architecture = @{
    Name = 'Architecture'
    Expression = { 
        if ($_.PSParentPath -like '*\WOW6432Node\*' )
        {
            'x86'
        }
        else
        {
            'x64'
        }
    }
}
Get-ItemProperty -ErrorAction Ignore -Path $paths |    
    # eliminate reg keys with empty DisplayName
    Where-Object DisplayName |
    # select desired properties and add calculated properties
    Select-Object -Property DisplayName, DisplayVersion, $user, $architecture
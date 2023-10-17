**Remote Server Administration Tools (RSAT):**

```
#Requires -RunAsAdministrator
#Requires -Version 5.0
#
Clear-Host;
#
Get-WindowsCapability -Online |
 Where-Object `
  {
   #
   $_.Name -like '*RSAT*' -and $_.State -eq 'NotPresent'
   #
  } | Add-WindowsCapability -Online;
#
```

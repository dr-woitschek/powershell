**USB Laufwerke aus der Registry auslesen:**

```
#Requires -RunAsAdministrator
#Requires -Version 5.0
#
Clear-Host;
#
[String]$Path = 'HKLM:\SYSTEM\CurrentControlSet\Enum\USBStor\*\*';
#
Get-ItemProperty -Path $Path |
 Select-Object -Property FriendlyName, PSParentPath, PSChildName |
  Format-Table -AutoSize;
#
Remove-Variable -Name Path;
```
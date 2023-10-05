**Win32_Product:**

---

> _Installierte Software ausgeben_

Ausgabe mit 'Format-Table'

```
#Requires -RunAsAdministrator
#Requires -Version 5.0
#
Clear-Host;
#
Get-WmiObject -Class 'Win32_Product' -Namespace 'root\CIMV2' |
 sort -Property Name |
  Format-Table -AutoSize;
#
```

<img src="https://github.com/dr-woitschek/powershell/blob/main/Beispiele/Win32_Product/Format-Table.jpg">

Ausgabe mit 'Format-List'

```
#Requires -RunAsAdministrator
#Requires -Version 5.0
#
Clear-Host;
#
Get-WmiObject -Class 'Win32_Product' -Namespace 'root\CIMV2' |
 sort -Property Name |
  Format-List -Property Vendor, Name, Version, InstallDate;
#
```

<img src="https://github.com/dr-woitschek/powershell/blob/main/Beispiele/Win32_Product/Format-List.jpg">

---

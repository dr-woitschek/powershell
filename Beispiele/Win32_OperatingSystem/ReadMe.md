**Win32_OperatingSystem:**

---

> _Betriebssystem-Informationen ausgeben_

```
#Requires -RunAsAdministrator
#Requires -Version 5.0
#
Clear-Host;
#
[Array]$OS = @();
#
try
 {
  #
  Get-Wmiobject -Class Win32_OperatingSystem `
                -ErrorAction Stop |
                 ForEach-Object `
                  {
                   #
                   $myHashtable = New-Object PSObject;
                   $myHashtable | Add-Member -Type NoteProperty -Name 'Name'      -Value $($_.Caption);
                   $myHashtable | Add-Member -Type NoteProperty -Name 'Build'     -Value $($_.Version);
                   $myHashtable | Add-Member -Type NoteProperty -Name 'Systemtyp' -Value $($_.OSArchitecture);
                   $myHashtable | Add-Member -Type NoteProperty -Name 'RAM'       -Value $([math]::Round($_.TotalVisibleMemorySize / 1024 / 1024).ToString()+' GB');
                   #
                   [Array]$OS += $myHashtable;
                   #
                   Remove-Variable -Name myHashtable;
                   #
                  };
  #
 }
catch
 {
  #
  [Array]$OS += $False;
  #
 };
#
[Array]$OS | Format-List;
#
Remove-Variable -Name OS;
#
```

Beispiel-Ausgabe:

```
Name      : Microsoft Windows 10 Pro
Build     : 10.0.19045
Systemtyp : 64-Bit
RAM       : 32 GB
```

---

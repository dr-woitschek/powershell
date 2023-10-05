**Win32_Processor:**

---

> _CPU-Informationen ausgeben_

```
#Requires -RunAsAdministrator
#Requires -Version 5.0
#
Clear-Host;
#
[Array]$CPU = @();
#
try
 {
  #
  Get-Wmiobject -Class Win32_Processor `
                -ErrorAction Stop |
                 ForEach-Object `
                  {
                   #
                   $myHashtable = New-Object PSObject;
                   $myHashtable | Add-Member -Type NoteProperty -Name 'Name'    -Value $($_.Name);
                   $myHashtable | Add-Member -Type NoteProperty -Name 'Familie' -Value $($_.Caption);
                   #
                   [Array]$CPU += $myHashtable;
                   #
                   Remove-Variable -Name myHashtable;
                   #
                  };
  #
 }
catch
 {
  #
  [Array]$CPU += $False;
  #
 };
#
[Array]$CPU | Format-List;
#
Remove-Variable -Name CPU;
#
```

Beispiel-Ausgabe:

```
Name    : Intel(R) Core(TM) i9-9900K CPU @ 3.60GHz
Familie : Intel64 Family 6 Model 158 Stepping 13
```

---

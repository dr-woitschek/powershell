**Win32_VideoController:**

---

> _Grafikkarten-Informationen ausgeben_

```
#Requires -RunAsAdministrator
#Requires -Version 5.0
#
Clear-Host;
#
[Array]$VGA = @();
#
try
 {
  #
  Get-Wmiobject -Class Win32_VideoController `
                -ErrorAction Stop |
                 ForEach-Object `
                  {
                   #
                   $myHashtable = New-Object PSObject;
                   $myHashtable | Add-Member -Type NoteProperty -Name 'Name'                 -Value $($_.Name);
                   $myHashtable | Add-Member -Type NoteProperty -Name 'Status'               -Value $($_.Status);
                   $myHashtable | Add-Member -Type NoteProperty -Name 'VideoModeDescription' -Value $($_.VideoModeDescription);
                   $myHashtable | Add-Member -Type NoteProperty -Name 'VideoProcessor'       -Value $($_.VideoProcessor);
                   #
                   [Array]$VGA += $myHashtable;
                   #
                   Remove-Variable -Name myHashtable;
                   #
                  };
  #
 }
catch
 {
  #
  [Array]$VGA += $False;
  #
 };
#
[Array]$VGA | Format-List;
#
Remove-Variable -Name VGA;
#
```

Beispiel-Ausgabe:

```
Name                 : NVIDIA GeForce RTX 2080 SUPER
Status               : OK
VideoModeDescription : 1680 x 1050 x 4294967296 Farben
VideoProcessor       : NVIDIA GeForce RTX 2080 SUPER
```

---

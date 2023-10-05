**Win32_VideoController:**

---

> _Grafikkarten-Informationen ausgeben_

```
#Requires -RunAsAdministrator
#Requires -version 5.0
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

---

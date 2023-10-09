**Win32_Battery:**

---

> _Batterie-Informationen ausgeben_

```
#Requires -RunAsAdministrator
#Requires -Version 5.0
#
Clear-Host;
#
$VerbosePreference = 'Continue';
#
[Array]$WMI = $Null;
[String]$Text = $Null;
#
try
 {
  #
  [Array]$WMI = Get-WmiObject -Class Win32_Battery  `
                              -ErrorAction Stop;
  #
  Write-Verbose -Message ('Battery Status: '''+$WMI.BatteryStatus+'''');
  #
 }
catch
 {
  #
  if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
  if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
  if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
  #
  Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Get-WmiObject');
  Write-Warning -Message ($Message);
  #
  Exit;
  #
 };
#
Switch($WMI.BatteryStatus)
 {
  #
  1       { Write-Information -InformationAction Continue -MessageData ('#'+$WMI.BatteryStatus+': Die Batterie entlädt sich'); Break;           };
  2       { Write-Information -InformationAction Continue -MessageData ('#'+$WMI.BatteryStatus+': Das Gerät hat Netzstrom'); Break;             };
  3       { Write-Information -InformationAction Continue -MessageData ('#'+$WMI.BatteryStatus+': Batterie ist voll geladen'); Break;           };
  4       { Write-Information -InformationAction Continue -MessageData ('#'+$WMI.BatteryStatus+': Batteriestand niedrig'); Break;               };
  5       { Write-Information -InformationAction Continue -MessageData ('#'+$WMI.BatteryStatus+': Batteriezustand kritisch'); Break;            };
  6       { Write-Information -InformationAction Continue -MessageData ('#'+$WMI.BatteryStatus+': Batterie lädt'); Break;                       };
  7       { Write-Information -InformationAction Continue -MessageData ('#'+$WMI.BatteryStatus+': Batterie lädt, Ladezustand hoch'); Break;     };
  8       { Write-Information -InformationAction Continue -MessageData ('#'+$WMI.BatteryStatus+': Batterie lädt, Ladezustand niedrig'); Break;  };
  9       { Write-Information -InformationAction Continue -MessageData ('#'+$WMI.BatteryStatus+': Batterie lädt, Ladezustand kritisch'); Break; };
  10      { Write-Information -InformationAction Continue -MessageData ('#'+$WMI.BatteryStatus+': nicht definiert'); Break;                     };
  11      { Write-Information -InformationAction Continue -MessageData ('#'+$WMI.BatteryStatus+': Teilweise geladen'); Break;                   };
  #
  default { Write-Warning -Message ('Unbekannter Zustand'); Break;                                                     };
  #
 };
#
Remove-Variable -Name WMI;
Remove-Variable -Name TEXT;
#
$VerbosePreference = 'SilentlyContinue';
#
Exit;
#
```

Beispiel-Ausgabe:

```
AUSFÜHRLICH: Battery Status: '2'
#2: Das Gerät hat Netzstrom
```

---

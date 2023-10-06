**Active Directory auslesen:**

---

> _Computer-Objekte aus einer OU auslesen_

```
Clear-Host;
#
[Array]$Computers = @();
#
[String]$ADFilter = $("Name -Like 'PC*'");
[String]$OU       = $('OU=Clients,DC=Weiterbildung,DC=Lokal');
#
try
 {
  #
  [Array]$Computers = Get-ADComputer -Filter $ADFilter  `
                                     -SearchBase $OU    `
                                     -ErrorAction Stop;
  #
  Write-Verbose -Message ('Get-ADComputer abgeschlossen');
  #
 }
catch
 {
  #
  if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
  if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
  if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
  #
  Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Get-ADComputer');
  Write-Warning -Message ($Message);
  #
 };
#
```

---
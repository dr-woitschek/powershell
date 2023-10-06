
> _Computer-Attribute auslesen_

```
Clear-Host;
#
[String]$Computer = 'PC01';
[Array]$Daten = @();
#
try
 {
  #
  [Array]$Daten = Get-ADComputer -Identity $Computer `
                                 -Property 'LastLogonDate'                  ,
                                           'pwdLastSet'                     ,
                                           'ms-Mcs-AdmPwd'                  ,
                                           'ms-Mcs-AdmPwdExpirationTime'    ,
                                           'msLAPS-EncryptedPassword'       ,
                                           'msLAPS-PasswordExpirationTime'  `
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
Remove-Variable -Name Computer;
Remove-Variable -Name Daten;
#
```

Beispiel-Ausgabe:

```

[Array]$Daten | Format-List;

DistinguishedName             : CN=PC01,OU=Clients,DC=Weiterbildung,DC=Lokal
DNSHostName                   : PC01.Weiterbildung.Lokal
Enabled                       : True
LastLogonDate                 : 02.10.2023 06:30:14
msLAPS-EncryptedPassword      : {1, 2, 3, 4...}
msLAPS-PasswordExpirationTime : 133434855481578108
Name                          : PC01
ObjectClass                   : computer
ObjectGUID                    : <GUID>
pwdLastSet                    : 133409547256539287
SamAccountName                : PC01$
SID                           : <SID>
UserPrincipalName             : 

```

Umrechnen von pwdLastSet

```
[Datetime]::FromFileTime($Daten.pwdLastSet);

Ausgabe:
Donnerstag, 5. Oktober 2023 06:45:25
```


---

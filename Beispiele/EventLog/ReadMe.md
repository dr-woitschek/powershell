**Windows EventLog:**

---

> _die Neuesten (Newest) 10 Einträge im Eventlog Anwendungen (Application) ausgeben_

**Get-EventLog**

```
#
Clear-Host;
#
Get-EventLog -LogName Application -Newest 10 | Format-Table -AutoSize;
#
```

<img src="https://github.com/dr-woitschek/powershell/blob/main/Beispiele/EventLog/EventLog_10_Get-EventLog.jpg">

**Get-WinEvent mit XML**

```
#Requires -RunAsAdministrator
#Requires -Version 5.0
#
Clear-Host;
#
[xml]$XML = '
 <QueryList>
  <Query Path="Microsoft-Windows-AppXDeployment/Operational">
   <Select Path="Microsoft-Windows-AppXDeployment/Operational">*</Select>
  </Query>
 </QueryList>';
#
Get-WinEvent -FilterXml $XML -MaxEvents 10 | Format-Table -AutoSize;
#
Remove-Variable -Name XML;
#
```

**Get-WinEvent**

```
#
Clear-Host;
#
Get-WinEvent -LogName Application -MaxEvents 10 | Format-Table -AutoSize;
#
```

<img src="https://github.com/dr-woitschek/powershell/blob/main/Beispiele/EventLog/EventLog_10_Get-WinEvent.jpg">

**WevtUtil.exe**

```
#
Clear-Host;
#
& 'C:\Windows\System32\wevtutil.exe' Query-Events /rd /Count:10 /Format:Text Application;
#
```

<img src="https://github.com/dr-woitschek/powershell/blob/main/Beispiele/EventLog/EventLog_10_WevtUtil.exe.jpg">

---

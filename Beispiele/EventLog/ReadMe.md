**Windows EventLog:**

_die Neuesten (Newest) 10 Einträge im Eventlog Anwendungen (Application) ausgeben_

Get-EventLog

```
#
Get-EventLog -LogName Application -Newest 10 | Format-Table -AutoSize;
#
```

Get-WinEvent

```
#
Get-WinEvent -LogName Application -MaxEvents 10 | Format-Table -AutoSize;
#

```

WevtUtil.exe:

```
#
& 'C:\Windows\System32\wevtutil.exe' Query-Events /rd /Count:4 /Format:Text Application;
#
```

**Computer Online und Locked:**

```
#Requires -RunAsAdministrator
#Requires -Version 5.0
#
Clear-Host;
#
$VerbosePreference = 'Continue';
#$VerbosePreference = 'SilentlyContinue';
$DebugPreference = 'SilentlyContinue';
#$DebugPreference = 'Continue';
#
[String]$ComputerName = 'ComputernameOderIP';
#
try
 {
  #
  $Result_Ping = $Null;
  $Result_Ping = Test-Connection -ComputerName $ComputerName `
                                 -Count 1                    `
                                 -Quiet                      `
                                 -ErrorAction Stop;
  #
  Write-Verbose -Message ('Test-Connection abgeschlossen');
  #
 }
catch
 {
  #
  if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = ('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
  if($_.CategoryInfo.Category)           { [String]$Category         = ('['+$_.CategoryInfo.Category+']');                 };
  if($_.Exception.Message)               { [String]$Message          = ('Message: '+$_.Exception.Message);                 };
  #
  Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Test-Connection ');
  Write-Warning -Message ($Message);
  #
  Exit;
  #
 };
#
if($Result_Ping)
 {
  #
  Write-Host -Object ('Der Computer '+$ComputerName+' ist Online');
  #
  try
   {
    #
    $Result_Wmi = $Null;
    $Result_Wmi = Get-WmiObject -Query "SELECT * FROM Win32_Process WHERE Name='LogonUI.exe'" `
                                -ComputerName $ComputerName                                   `
                                -ErrorAction Stop;
    #
    Write-Verbose -Message ('Get-WmiObject abgeschlossen');
    #
   }
  catch
   {
    #
    if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = ('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
    if($_.CategoryInfo.Category)           { [String]$Category         = ('['+$_.CategoryInfo.Category+']');                 };
    if($_.Exception.Message)               { [String]$Message          = ('Message: '+$_.Exception.Message);                 };
    #
    Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Get-WmiObject ');
    Write-Warning -Message ($Message);
    #
    Exit;
    #
   };
  #
  if($Result_Wmi)
   {
    #
    Write-Host -Object ('Der Computer '+$ComputerName+' ist gesperrt');
    #
   }
    else
   {
    #
    Write-Host -Object ('Der Computer '+$ComputerName+' ist nicht gesperrt');
    #
   };
  #
 }
  else
 {
  #
  Write-Host -Object ('Der Computer '+$ComputerName+' ist Offline');
  #
 };
#
Remove-Variable -Name ComputerName;
Remove-Variable -Name Result_Ping;
Remove-Variable -Name Result_Wmi -ErrorAction SilentlyContinue;
#
```

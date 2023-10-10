#Requires -RunAsAdministrator
#Requires -Version 5.0
#
<#

  .SYNOPSIS
   Erstellt eine Dateisystem-Überwachung

  .DESCRIPTION
   Erstellt eine Dateisystem-Überwachung.
   Es werden die Events "erstellen/Created", "umbennen/Renamed",
   "löschen/Deleted" und "ändern/Changed" im System registriert.
   Diese Events werden in einer Logdatei gespeichert.

  .PARAMETER
   -/-

  .INPUTS
   -/-

  .OUTPUTS
   Liste mit Events

  .NOTES
   Version: 1.0
   Author:  dr-woitschek

  .LINK
   https://github.com/dr-woitschek/powershell

  .EXAMPLE
   Create-FileSystemWatcher.ps1

#>
#
Clear-Host;
#
[Array]$EventNames = @();
[Array]$EventNames = @('Created' , 'Changed' , 'Deleted' , 'Renamed');
#
$FileSystemWatcher                       = New-Object System.IO.FileSystemWatcher;
$FileSystemWatcher.Path                  = 'C:\TEMP';
$FileSystemWatcher.Filter                = '*.*';
$FileSystemWatcher.IncludeSubdirectories = $True;
$FileSystemWatcher.EnableRaisingEvents   = $True;
#
$FSW_Action = `
 {
  #
  $FullPath   = $Event.SourceEventArgs.FullPath;
  $ChangeType = $Event.SourceEventArgs.ChangeType;
  #
  $LogMessage = ((Get-Date -Format 'yyyy-MM-dd HH-mm-ss')+' '+$ChangeType+' '+$FullPath);
  #
  Add-content -Path 'C:\TEMP\fsw.log' -Value $LogMessage;
  #
  Write-Host -Object $LogMessage;
  #
 };
#
[Array]$EventNames |
 ForEach-Object `
  {
   #
   try
    {
     #
     Register-ObjectEvent -Action $FSW_Action             `
                          -EventName $_                   `
                          -InputObject $FileSystemWatcher `
                          -ErrorAction Stop               | Out-Null;
     #
    }
   catch
    {
     #
     if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
     if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
     if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
     #
     Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Register-ObjectEvent: '+$_);
     Write-Warning -Message ($Message);
     #
    };
   #
  };
#
Get-EventSubscriber |
 sort -Property EventName |
  Format-Table -AutoSize;
#
Exit;
#
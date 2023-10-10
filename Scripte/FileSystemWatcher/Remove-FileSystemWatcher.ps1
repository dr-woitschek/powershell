#Requires -RunAsAdministrator
#Requires -Version 5.0
#
<#

  .SYNOPSIS
   Entfernt die Dateisystem-Überwachung

  .DESCRIPTION
   Entfernt die Dateisystem-Überwachung
   Es werden die Events "erstellen/Created", "umbennen/Renamed",
   "löschen/Deleted" und "ändern/Changed" aus dem System entfernt.

  .PARAMETER
   -/-

  .INPUTS
   -/-

  .OUTPUTS
   -/-

  .NOTES
   Version: 1.0
   Author:  dr-woitschek

  .LINK
   https://github.com/dr-woitschek/powershell

  .EXAMPLE
   Remove-FileSystemWatcher.ps1

#>
#
Clear-Host;
#
[Array]$EventNames = @();
[Array]$EventNames = @('Created' , 'Changed' , 'Deleted' , 'Renamed');
#
Get-EventSubscriber |
 Where-Object `
  {
   #
   $_.EventName -in $EventNames;
   #
  } | Unregister-Event;
#
Get-EventSubscriber |
 Format-Table -AutoSize;
#
Remove-Variable -Name EventNames;
#
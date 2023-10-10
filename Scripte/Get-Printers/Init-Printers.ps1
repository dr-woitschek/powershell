#Requires -RunAsAdministrator
#Requires -Version 5.0
#
<#

  .SYNOPSIS
   Re-Installation von Druckern

  .DESCRIPTION
   Re-Installation von Druckern auf mehreren Clients.
   Auslesen einer SteuerCFG-Datei und kopieren der entsprechenden Druckertreiber-Dateien auf den Zielclient.

  .PARAMETER
   -/-

  .INPUTS
   Liste an Comuter-Objekten

  .OUTPUTS
   Informationen über die Re-Installation von Druckern

  .NOTES
   Version: 1.0
   Author:  dr-woitschek

  .LINK
   https://github.com/dr-woitschek/powershell

  .EXAMPLE
   Init-Printers.ps1

#>
#
Clear-Host;
#
#                       'Continue';
#                       'SilentlyContinue';
$MyPreference_Verbose = 'SilentlyContinue';
$MyPreference_Debug   = 'SilentlyContinue';
#
$VerbosePreference    = $MyPreference_Verbose;
$DebugPreference      = $MyPreference_Debug;
#
# Einstellungen:
[String]$Drucker_CFG_Ordner    = ('\\server1\share_printers\CFG');
[String]$Druckertreiber_Ordner = ('\\server1\share_printers\DruckertreiberW10');
[String]$DruckerTreiberCFG     = ('PrinterDriverW10.cfg');
[String]$DruckerCFG            = ('PrinterW10.cfg');
#
[String]$TMP1File              = ($env:TEMP+'\'+$MyInvocation.MyCommand.Name -replace '.ps1','_TMP.txt');
#
[String]$FQDN                  = '.weiterbildung.lokal';
#
[Boolean]$CFG_Dateien_kopieren = $False;
[Boolean]$CFG_Dateien_kopieren = $True;
#
[Boolean]$Drucker_loeschen     = $True;
[Boolean]$Drucker_loeschen     = $False;
#
Write-Host -Object ('Information');
Write-Host -Object ('- Dat-Ordner:       '+$Drucker_CFG_Ordner);
Write-Host -Object ('- Treiber-Ordner:   '+$Druckertreiber_Ordner);
Write-Host -Object ('- Drucker löschen?: '+$Drucker_loeschen);
Write-Host -Object ('- CFG kopieren?:    '+$CFG_Dateien_kopieren);
Write-Host -Object ('  - CFG1:           '+$DruckerTreiberCFG);
Write-Host -Object ('  - CFG2:           '+$DruckerCFG);
Write-Host -Object ('- FQDN:             '+$FQDN);
#
[Array]$Drucker_WhiteList = @();
[Array]$Drucker_WhiteList = (
                             #
                             'Solid Edge Velocity PS Printer 2.0'  ,
                             'Microsoft XPS Document Writer'       ,
                             'Microsoft Print to PDF'              ,
                             'Fax'                                 ,
                             'An OneNote 16 senden'
                             #
                            );
#
Write-Host -Object ('- WhiteList Drucker:');
#
[Array]$Drucker_WhiteList |
 ForEach-Object `
  {
   #
   Write-Host -Object ('  - '+$_);
   #
  };
#
Write-Host -Object (' ');
#
[Array]$Computers = $Null;
[Array]$Computers = `
 @(
   #
   'PC01' ,
   'PC02'
   #
  );
#
[Int]$Anzahl = 1;
#
foreach($Computer in $Computers)
 {
  #
  [String]$Computer = $Computer+$FQDN;
  #
  [Int]$AnzahlJetzt  = $Anzahl.ToString('000');
  [Int]$AnzahlGesamt = $Computers.Count;
  #
  Write-Host -Object ('#'+$AnzahlJetzt.ToString('000')+'/'+$AnzahlGesamt.ToString('000')+' - '+$Computer);
  #
  if(Test-Connection -ComputerName $Computer -Count 1 -Quiet)
   {
    #
    if(Test-Path -Path $('\\'+$Computer+'\c$\Windows\System32\cmd.exe'))
     {
      #
      if($CFG_Dateien_kopieren)
       {
        #
        try
         {
          #
          Copy-Item -Path        ($Drucker_CFG_Ordner+'\'+$DruckerTreiberCFG)   `
                    -Destination ('\\'+$Computer+'\C$\TEMP\'+$DruckerTreiberCFG)  `
                    -ErrorAction Continue                                        `                    -Force;
          #
          Write-Host -Object (' | Datei '''+$DruckerTreiberCFG+''' kopiert');
          #
         }
        catch
         {
          #
          if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
          if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
          if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
          #
          Write-Warning -Message (' | '+$ScriptLineNumber+$Category+' Fehler bei Copy-Item');
          Write-Warning -Message (' | '+$Message);
          #
         };
        #
        try
         {
          #
          Copy-Item -Path        ($Drucker_CFG_Ordner+'\'+$DruckerCFG)   `
                    -Destination ('\\'+$Computer+'\C$\TEMP\'+$DruckerCFG)  `
                    -ErrorAction Continue                                  `                    -Force;
          #
          Write-Host -Object (' | Datei '''+$DruckerCFG+''' kopiert');
          #
         }
        catch
         {
          #
          if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
          if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
          if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
          #
          Write-Warning -Message (' | '+$ScriptLineNumber+$Category+' Fehler bei Copy-Item');
          Write-Warning -Message (' | '+$Message);
          #
         };
        #
        Write-Host -Object (' | ');
        #
       };
      #
      try
       {
        #
        [Array]$AlleDruckerObjekte = Get-Printer -ComputerName $Computer `
                                                 -ErrorAction Continue;
        #
        Write-Host -Object (' | Client hat '+$AlleDruckerObjekte.Count+' installierte Drucker');
       #Write-Host -Object (' | ');
        #
       }
      catch
       {
        #
        if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
        if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
        if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
        #
        Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Get-Printer');
        Write-Warning -Message ($Message);
        #
       };
      #
      [Array]$AlleDruckerObjekte | Format-Table -AutoSize | Out-File -FilePath $TMP1File;
      #
      Get-Content -Path $TMP1File |
       Where-Object -FilterScript `
        {
         #
         if($_.Trim() -ne '')
          {
           #
           Write-Host -Object (' |  '+$_);
           #
          };
         #
        };
      #
      Remove-Item -Path $TMP1File -Force -ErrorAction SilentlyContinue;
      #
      Write-Host -Object (' | ');
      #
      foreach($DasDruckerObjekt in $AlleDruckerObjekte)
       {
        #
        if($Drucker_loeschen)
         {
          #
          [String]$DruckerObjekt_zum_entfernen = $Null;
          [String]$DruckerObjekt_zum_entfernen = $DasDruckerObjekt.Name;
          #
          if(!($Drucker_WhiteList -contains $DruckerObjekt_zum_entfernen))
           {
            #
            Write-Warning -Message ('Drucker wird entfernt: '+$DruckerObjekt_zum_entfernen);
            #
            try
             {
              #
              $Port = Get-WmiObject -Class Win32_Printer                            `
                                    -ErrorAction Continue                           `
                                    -ComputerName $($Computer)                      `
                                    -Filter "Name = '$DruckerObjekt_zum_entfernen'" |
                       Select-Object -ExpandProperty PortName;
              #
             }
            catch
             {
              #
              if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
              if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
              if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
              #
              Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Win32_Printer/Port');
              Write-Warning -Message ($Message);
              #
             };
            #
            try
             {
              #
              $Treiber = Get-WmiObject -Class Win32_Printer                            `
                                       -ErrorAction Continue                           `
                                       -ComputerName $($Computer)                      `
                                       -Filter "Name = '$DruckerObjekt_zum_entfernen'" |
                          Select-Object -ExpandProperty DriverName;
              #
             }
            catch
             {
              #
              if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
              if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
              if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
              #
              Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Win32_Printer/Treiber');
              Write-Warning -Message ($Message);
              #
             };
            #
            try
             {
              #
              $Delete = Get-WmiObject -Class Win32_Printer                           `
                                      -ErrorAction Continue                          `
                                      -ComputerName $($Computer)                     `
                                      -Filter "Name = '$DruckerObjekt_zum_entfernen'";
              #
              $Delete.Delete();
              #
              Write-Warning -Message ('Drucker-Objekt '+$Delete+' entfernt');
              #
             }
            catch
             {
              #
              if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
              if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
              if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
              #
              Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Win32_Printer/Delete');
              Write-Warning -Message ($Message);
              #
             };
            #
            try
             {
              #
              Remove-PrinterDriver -ComputerName $Computer  `
                                   -Name $Treiber           `
                                   -RemoveFromDriverStore   `
                                   -ErrorAction Continue;
              #
              Write-Warning -Message ('Drucker-Treiber '+$Treiber+' entfernt');
              #
             }
            catch
             {
              #
              if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
              if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
              if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
              #
              Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Remove-PrinterDriver');
              Write-Warning -Message ($Message);
              #
             };
            #
            try
             {
              #
              Remove-PrinterPort -ComputerName $Computer  `
                                 -Name $Port              `
                                 -ErrorAction Continue;
              #
              Write-Warning -Message ('Drucker-Port '+$Port+' entfernt');
              #
             }
            catch
             {
              #
              if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
              if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
              if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
              #
              Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Remove-PrinterPort');
              Write-Warning -Message ($Message);
              #
             };
            #
           };
          #
         };
        #
       };
      #
      [String]$CFG_Datei1  = ('\\'+$Computer+'\C$\TEMP\'+$DruckerCFG);
      [String]$CFG_Datei2  = ('\\'+$Computer+'\C$\TEMP\'+$DruckerTreiberCFG);
      [String]$ComputerTmp = $Computer -replace ('.schulen.rgbg','') -replace ('.regensburg.de','');
      #
      $Zeilennummer1 = Get-ChildItem -Path $CFG_Datei1 | Select-String -SimpleMatch $ComputerTmp;
      $Inhalt1       = Get-Content -Path $CFG_Datei1 | Where-Object { $_.Readcount -gt $Zeilennummer1.LineNumber };
      #
      $Installationen = 1;
      #
      $Inhalt1        |
       ForEach-Object `
        {
         #
         if(($_).Trim().StartsWith('['))
          {
           #
           # weiterlaufen wenn du '[' findest...
           $Installationen = 0;
           #
          }
           else
          {
           #
           if(!($Installationen -eq 0))
            {
             #
             if(($_).Trim().StartsWith('Drucker'))
              {
               #
               $Zeile              = $_;
               $SplitZeile         = $Zeile.Split(';');
               #
               $SplitZeileTmp1     = $SplitZeile[0].Split('=');
               $SplitZeileTmp2     = $SplitZeile[1].Split('=');
               $Drucker_InventarNr = $SplitZeileTmp1[2];
               $Drucker_Typ        = $SplitZeileTmp2[1];
               #
               $Zeilennummer2      = Get-ChildItem -Path $CFG_Datei2 |
                                      Select-String -SimpleMatch $('['+$Drucker_Typ+']');
               #
               $ContentCFG_Datei2  = Get-Content -Path $CFG_Datei2;
               #
               $InfDateiname       = $ContentCFG_Datei2[$Zeilennummer2.LineNumber];
               $InfDruckertyp      = $ContentCFG_Datei2[$Zeilennummer2.LineNumber +1];
               #
               $InfDateiname       = $InfDateiname -replace 'InfDateiname=','';
               $InfDruckertyp      = $InfDruckertyp -replace 'InfDruckertyp=','';
               #
               $InfDateiOrdner     = $InfDateiname -split '\\';
               #
               $copy_source_path   = $($Druckertreiber_Ordner+'\'+$InfDateiOrdner[0]);
               $copy_target_path   = $('\\'+$Computer+'\C$\TEMP\'+$InfDateiOrdner[0]);
               #
               [Array]$Dateien     = @();
               #
               try
                {
                 #
                 [Array]$Dateien = Get-ChildItem -Path $copy_source_path  `
                                                 -ErrorAction Stop        `
                                                 -Recurse;
                 #
                 Write-Host -Object (' | Drucker-Treiber-Dateien für '''+$InfDateiOrdner[0]+''' ausgelesen');
                 #
                }
               catch
                {
                 #
                 if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
                 if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
                 if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
                 #
                 Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Get-ChildItem');
                 Write-Warning -Message ($Message);
                 #
                };
               #
               Write-Host -Object (' | Drucker-Treiber-Dateien kopieren ...');
               #
               foreach($Datei in $Dateien)
                {
                 #
                 Write-Debug -Message ('kopiere: '+$Datei.FullName);
                 #
                 try
                  {
                   #
                   Copy-Item -Path $Datei.FullName                                                            `
                             -Destination $Datei.FullName.Replace($($copy_source_path),$($copy_target_path))  `
                             -ErrorAction Stop                                                                `
                             -Force;
                   #
                  }
                 catch
                  {
                   #
                   if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
                   if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
                   if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
                   #
                   Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Copy-Item');
                   Write-Warning -Message ($Message);
                   #
                  };
                 #
                };
               #
               if(!(Test-Path $copy_target_path))
                {
                 #
                 Write-Warning -Message ('Fehler beim Drucker-Treiber Ordner');
                 Write-Warning -Message ('Drucker '+$Drucker_InventarNr+'_'+$InfDruckertyp+' wird nicht installiert');
                 #
                }
                 else
                {
                 #
                 Write-Host -Object (' | Drucker-Treiber-Dateien abgeschlossen');
                 #
                 [Array]$Invoke_Command_Array = $();
                 [Array]$Invoke_Command_Array = $(
                                                  #
                                                  $Computer              ,
                                                  $InfDateiname          ,
                                                  $InfDruckertyp         ,
                                                  $Drucker_InventarNr    ,
                                                  #
                                                  $MyPreference_Verbose  ,
                                                  $MyPreference_Debug
                                                  #
                                                 );
                 #
                 Write-Host -Object (' | ');
                 Write-Host -Object (' | Invoke-Command @ '+$Computer);
                 #
                 Invoke-Command                           `
                  -ComputerName $($Computer)              `
                  -ArgumentList $($Invoke_Command_Array)  `
                  -ScriptBlock                            `
                   {
                    #
                    $Computer              = $args[0];
                    $InfDateiname          = $args[1];
                    $InfDruckertyp         = $args[2];
                    $Drucker_InventarNr    = $args[3];
                    #
                    $MyPreference_Verbose  = $args[4];
                    $MyPreference_Debug    = $args[5];
                    #
                    $VerbosePreference     = $MyPreference_Verbose;
                    $DebugPreference       = $MyPreference_Debug;
                    #
                    Write-Host -Object (' |  '+$env:COMPUTERNAME+' | Step 1/6 - PnPutil.exe');
                    #
                    & C:\Windows\System32\PnPutil.exe -a $('C:\TEMP\'+$InfDateiname) |
                     ForEach($_) `
                      {
                       #
                       Write-Debug -Message (''+$env:COMPUTERNAME+' | '+$($_));
                       #
                      };
                    #
                    Write-Host -Object (' |  '+$env:COMPUTERNAME+' | Step 2/6 - Add-PrinterDriver: '''+$InfDruckertyp+'''');
                    #
                    try
                     {
                      #
                      Add-PrinterDriver -Name $InfDruckertyp  `
                                        -ErrorAction Stop;
                      #
                      Write-Host -Object (' |  '+$env:COMPUTERNAME+' |            abgeschlossen');
                      #
                     }
                    catch
                     {
                      #
                      if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
                      if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
                      if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
                      #
                      Write-Warning -Message (''+$env:COMPUTERNAME+' | '+$ScriptLineNumber+$Category+' Fehler bei Add-PrinterDriver');
                      Write-Warning -Message (''+$env:COMPUTERNAME+' | '+$Message);
                      #
                     };
                    #
                    Write-Host -Object (' |  '+$env:COMPUTERNAME+' | Step 3/6 - Add-PrinterPort: '''+$Drucker_InventarNr+'''');
                    #
                    if(!(Get-PrinterPort -Name $Drucker_InventarNr -ErrorAction SilentlyContinue))
                     {
                      #
                      try
                       {
                        #
                        Add-PrinterPort -Name $Drucker_InventarNr                `
                                        -PrinterHostAddress $Drucker_InventarNr  `
                                        -ErrorAction Stop;
                        #
                        Write-Host -Object (' |  '+$env:COMPUTERNAME+' |            abgeschlossen');
                        #
                       }
                      catch
                       {
                        #
                        if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
                        if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
                        if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
                        #
                        Write-Warning -Message (''+$env:COMPUTERNAME+' | '+$ScriptLineNumber+$Category+' Fehler bei Add-PrinterPort');
                        Write-Warning -Message (''+$env:COMPUTERNAME+' | '+$Message);
                        #
                       };
                      #
                     }
                      else
                     {
                      #
                      Write-Verbose -Message (' |  '+$env:COMPUTERNAME+' | Drucker-Port bereits vorhanden');
                      #
                     };
                    #
                    Write-Host -Object (' |  '+$env:COMPUTERNAME+' | Step 4/6 - Add-Printer: '''+($Drucker_InventarNr+'_'+$InfDruckertyp)+'''');
                    #
                    if(!(Get-Printer -Name $($Drucker_InventarNr+'_'+$InfDruckertyp) -ErrorAction SilentlyContinue))
                     {
                      #
                      try
                       {
                        #
                        Add-Printer -Name         ($Drucker_InventarNr+'_'+$InfDruckertyp)  `
                                    -PortName     ($Drucker_InventarNr)                     `
                                    -DriverName   ($InfDruckertyp)                          `
                                    -ErrorAction  Stop;
                        #
                        Write-Host -Object (' |  '+$env:COMPUTERNAME+' |            abgeschlossen');
                        #
                       }
                      catch
                       {
                        #
                        if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
                        if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
                        if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
                        #
                        Write-Warning -Message (''+$env:COMPUTERNAME+' | '+$ScriptLineNumber+$Category+' Fehler bei Add-Printer');
                        Write-Warning -Message (''+$env:COMPUTERNAME+' | '+$Message);
                        #
                       };
                      #
                     }
                      else
                     {
                      #
                      Write-Host -Object (' |  '+$env:COMPUTERNAME+' | Drucker bereits vorhanden');
                      #
                     };
                    #
                    Write-Host -Object (' |  '+$env:COMPUTERNAME+' | Step 5/6 - Set-Printer: '''+($Drucker_InventarNr+'_'+$InfDruckertyp)+'''');
                    #
                    $PrinterBerechtigung = "G:SYD:(A;OIIO;RPWPSDRCWDWO;;;WD)(A;;LCSWSDRCWDWO;;;WD)(A;CIIO;RC;;;AC)(A;OIIO;RPWPSDRCWDWO;;;AC)(A;;SWRC;;;AC)(A;;LCSWSDRCWDWO;;;CO)(A;OIIO;RPWPSDRCWDWO;;;CO)(A;;LCSWSDRCWDWO;;;BA)(A;OIIO;RPWPSDRCWDWO;;;BA)"
                    #
                    try
                     {
                      #
                      Set-Printer -Name           ($Drucker_InventarNr+'_'+$InfDruckertyp)  `
                                  -PermissionSDDL ($PrinterBerechtigung)                    `
                                  -ErrorAction    Stop;
                      #
                      Write-Host -Object (' |  '+$env:COMPUTERNAME+' |            abgeschlossen');
                      #
                     }
                    catch
                     {
                      #
                      if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
                      if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
                      if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
                      #
                      Write-Warning -Message (''+$env:COMPUTERNAME+' | '+$ScriptLineNumber+$Category+' Fehler bei Set-Printer');
                      Write-Warning -Message (''+$env:COMPUTERNAME+' | '+$Message);
                      #
                     };
                    #
                    Write-Host -Object (' |  '+$env:COMPUTERNAME+' | Step 5/6 - Reinigungsarbeiten');
                    #
                    $InfDateiname = $InfDateiname -split '\\';
                    #
                    try
                     {
                      #
                      Remove-Item -Path $('C:\TEMP\'+$InfDateiname[0])  `
                                  -Recurse                              `
                                  -Force                                `
                                  -ErrorAction Stop;
                      #
                      Write-Host -Object (' |  '+$env:COMPUTERNAME+' |            abgeschlossen');
                      #
                     }
                    catch
                     {
                      #
                      if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
                      if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
                      if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
                      #
                      Write-Warning -Message (''+$env:COMPUTERNAME+' | '+$ScriptLineNumber+$Category+' Fehler bei Remove-Item');
                      Write-Warning -Message (''+$env:COMPUTERNAME+' | '+$Message);
                      #
                     };
                    #
                    $VerbosePreference = 'SilentlyContinue';
                    $DebugPreference = 'SilentlyContinue';
                    #
                    [Array]$Alle_Variablen = @(
                                               #
                                               'Computer'                     ,
                                               'InfDateiname'                 ,
                    						   'InfDruckertyp'                ,
                    						   'Drucker_InventarNr'           ,
                    						   'MyPreference_Verbose'         ,
                    						   'MyPreference_Debug'           ,
                    						   #
                                               'ScriptLineNumber'             ,
                                               'Category'                     ,
                                               'Message'                      ,
                                               'TargetObject'                 ,
                                               #
                                               'Alle_Variablen'
                                               #
                                              );
                    #
                    [Array]$Alle_Variablen |
                     foreach `
                      {
                       #
                       Remove-Variable -Name $_ -ErrorAction SilentlyContinue -Confirm:$False;
                       #
                      };
                    #
                   };
                 #
                 Write-Host -Object (' | Invoke-Command abgeschlossen');
                 Write-Host -Object (' | ');
                 #
                };
               #
              };
             #
            };
           #
          };
         #
        };
      #
      try
       {
        #
        [Array]$AlleDruckerObjekte = Get-Printer -ComputerName $Computer `
                                                 -ErrorAction Continue;
        #
        Write-Host -Object (' | Client hat '+$AlleDruckerObjekte.Count+' installierte Drucker');
       #Write-Host -Object (' | ');
        #
       }
      catch
       {
        #
        if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
        if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
        if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
        #
        Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Get-Printer');
        Write-Warning -Message ($Message);
        #
       };
      #
      [Array]$AlleDruckerObjekte | Format-Table -AutoSize | Out-File -FilePath $TMP1File;
      #
      Get-Content -Path $TMP1File |
       Where-Object -FilterScript `
        {
         #
         if($_.Trim() -ne '')
          {
           #
           Write-Host -Object (' |  '+$_);
           #
          };
         #
        };
      #
      Remove-Item -Path $TMP1File -Force -ErrorAction SilentlyContinue;
      #
     }
      else
     {
      #
      Write-Warning -Message ('Windows RPC Error: '+$Computer);
      #
     };
    #
   }
    else
   {
    #
    Write-Warning -Message ('Offline: '+$Computer);
    #
   };
  #
  Write-Host -Object (' | ');
  Write-Host -Object (' ');
  #
  $Anzahl++;
  #
 };
#
$VerbosePreference = 'SilentlyContinue';
$DebugPreference   = 'SilentlyContinue';
#
[Array]$Alle_Variablen = @(
                           #
                           'MyPreference_Verbose'         ,
                           'MyPreference_Debug'           ,
                           #
						   'Drucker_CFG_Ordner'           ,
						   'Druckertreiber_Ordner'        ,
						   'DruckerTreiberCFG'            ,
						   'DruckerCFG'                   ,
						   #
						   'TMP1File'                     ,
						   'FQDN'                         ,
						   'CFG_Dateien_kopieren'         ,
						   'Drucker_loeschen'             ,
						   'Drucker_WhiteList'            ,
						   #
						   'Computers'                    ,
						   'Computer'                     ,
						   #
						   'Anzahl'                       ,
						   'AnzahlJetzt'                  ,
						   'AnzahlGesamt'                 ,
						   #
						   'AlleDruckerObjekte'           ,
						   'DasDruckerObjekt'             ,
						   'DruckerObjekt_zum_entfernen'  ,
						   #
						   'Port'                         ,
						   'Treiber'                      ,
						   'Delete'                       ,
						   #
						   'CFG_Datei1'                   ,
						   'CFG_Datei2'                   ,
						   'ComputerTmp'                  ,
						   'Zeilennummer1'                ,
						   'Zeilennummer2'                ,
						   'Inhalt1'                      ,
						   'Installationen'               ,
						   'Zeile'                        ,
						   'SplitZeile'                   ,
						   'SplitZeileTmp1'               ,
						   'SplitZeileTmp2'               ,
						   'Drucker_InventarNr'           ,
						   'Drucker_Typ'                  ,
						   'ContentCFG_Datei2'            ,
						   'InfDateiname'                 ,
						   'InfDruckertyp'                ,
						   'InfDateiname'                 ,
						   'InfDruckertyp'                ,
						   'InfDateiOrdner'               ,
						   'copy_source_path'             ,
						   'copy_target_path'             ,
						   'Dateien'                      ,
						   'Datei'                        ,
						   'Invoke_Command_Array'         ,
						   #
                           'ScriptLineNumber'             ,
                           'Category'                     ,
                           'Message'                      ,
                           'TargetObject'                 ,
                           #
                           'Alle_Variablen'
                           #
                          );
#
[Array]$Alle_Variablen |
 foreach `
  {
   #
   Remove-Variable -Name $_ -ErrorAction SilentlyContinue -Confirm:$False;
   #
  };
#
Exit;
#
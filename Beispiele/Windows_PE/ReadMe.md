**Windows PE:**

---

> _Windows PE erstellen und anpassen_

```
#Requires -RunAsAdministrator
#Requires -Version 5.0
#
$VerbosePreference = 'Continue';
$DebugPreference = 'SilentlyContinue';
#
Clear-Host;
#
[String]$Version                    = $('V1-'+$(Get-Date -Format 'yyyy-MM-dd-HH-mm-ss'));
#
[String]$Random                     = $(Get-Random);
[String]$MainDrive                  = $('C:');
[String]$WorkingDir                 = $($MainDrive+'\TEMP');
#
[Bool]$AddOn_TOOLS                  = $False;
[Bool]$AddOn_TOOLS                  = $True;
#
[Bool]$AddOn_BIOS                   = $False;
[Bool]$AddOn_BIOS                   = $True;
#
[Bool]$AddOn_TotalCommander         = $False;
[Bool]$AddOn_TotalCommander         = $True;
#
[Bool]$InstallDrivers               = $False;
[Bool]$InstallDrivers               = $True;
#
[String]$WinPE_Drivers              = ($WorkingDir+'\PE_Drivers');
#
[String]$WinPE_WorkingDir           = ($WorkingDir+'\PE');
[String]$WinPE_Arch                 = ('amd64');
[String]$WinPE_SAVE                 = ($WinPE_WorkingDir+'\'+$WinPE_Arch+'\'+$($Random));
[String]$WinPE_SAVE_Media           = ($WinPE_SAVE+'\media');
[String]$WinPE_SAVE_Media_Boot_WIM  = ($WinPE_SAVE+'\media\sources\boot.wim');
[String]$WinPE_SAVE_Mount           = ($WinPE_SAVE+'\mount');
[String]$WinPE_SAVE_FWFiles         = ($WinPE_SAVE+'\fwfiles');
#
[String]$WinPE_TOOLS_Folder         = ($WorkingDir+'\PE_Tools');
[String]$WinPE_BIOS_Folder          = ($WorkingDir+'\PE_BIOS');
[String]$WinPE_mounted_TOOLS        = ($WinPE_SAVE_Media+'\TOOLS');
[String]$WinPE_mounted_BIOS         = ($WinPE_SAVE_Media+'\BIOS');
#
[String]$WinPE_ADK                  = (${env:ProgramFiles(x86)}+'\Windows Kits\10\Assessment and Deployment Kit');
[String]$WinPE_ADK_DT               = ($WinPE_ADK+'\Deployment Tools');
[String]$WinPE_ADK_DT_DISM          = ($WinPE_ADK_DT+'\'+$WinPE_Arch+'\DISM\Dism.exe')
[String]$WinPE_ADK_WPE              = ($WinPE_ADK+'\Windows Preinstallation Environment');
#
[String]$oscdimg_Folder             = ($WinPE_ADK+'\Deployment Tools\'+$WinPE_Arch+'\Oscdimg');
[String]$oscdimg_exe                = ($oscdimg_Folder+'\Oscdimg.exe');
[String]$oscdimg_etfsboot           = ($oscdimg_Folder+'\etfsboot.com');
[String]$oscdimg_efisys             = ($oscdimg_Folder+'\efisys_noprompt.bin');
#
[String]$WinPE_ISO_File             = ($WinPE_SAVE+'\Windows_PE.iso');
#
[String]$WinPE_Source               = $($WinPE_ADK_WPE+'\'+$WinPE_Arch);
[String]$WinPE_WIM_Source_Path      = $($WinPE_Source+'\en-us\winpe.wim');
#
[Array]$WinPE_Software_Install      = @(
                                        #
                                        $($WinPE_ADK_WPE+'\'+$WinPE_Arch+'\WinPE_OCs\WinPE-NetFX.cab')         ,  `
                                        $($WinPE_ADK_WPE+'\'+$WinPE_Arch+'\WinPE_OCs\WinPE-Scripting.cab')     ,  `
                                        $($WinPE_ADK_WPE+'\'+$WinPE_Arch+'\WinPE_OCs\WinPE-PowerShell.cab')    ,  `
                                        $($WinPE_ADK_WPE+'\'+$WinPE_Arch+'\WinPE_OCs\WinPE-DismCmdlets.cab')   ,  `
                                       #$($WinPE_ADK_WPE+'\'+$WinPE_Arch+'\WinPE_OCs\WinPE-StorageWMI.cab')    ,  `
                                        $($WinPE_ADK_WPE+'\'+$WinPE_Arch+'\WinPE_OCs\WinPE-WMI.cab')           ,  `
                                        $($WinPE_ADK_WPE+'\'+$WinPE_Arch+'\WinPE_OCs\WinPE-SecureStartup.cab') ,  `
                                        $($WinPE_ADK_WPE+'\'+$WinPE_Arch+'\WinPE_OCs\WinPE-wds-tools.cab')
                                        #
                                       );
#
[Array]$WinPE_Sprachen_loeschen     = @(
                                        #
                                        'bg-bg'  ,  'cs-cz'       ,  'da-dk'  ,  'el-gr'  ,  'en-gb'  ,  'es-es'  ,  `
                                        'et-ee'  ,  'fi-fi'       ,  'fr-fr'  ,  'hr-hr'  ,  'hu-hu'  ,  'it-it'  ,  `
                                        'ja-jp'  ,  'ko-kr'       ,  'lt-lt'  ,  'lv-lv'  ,  'nb-no'  ,  'nl-nl'  ,  `
                                        'pl-pl'  ,  'pt-br'       ,  'pt-pt'  ,  'ro-ro'  ,  'ru-ru'  ,  'sk-sk'  ,  `
                                        'sl-si'  ,  'sr-latn-rs'  ,  'sv-se'  ,  'tr-tr'  ,  'uk-ua'  ,  'zh-cn'  ,  `
                                        'zh-tw'  ,  'es-mx'       ,  'fr-ca'
                                        #
                                       );
#
[String]$startnet_cmd = `
'@echo off

cd\
echo.
echo                          ____  ____  ____  ____
echo                         /\   \/\   \/\   \/\   \
echo                        /  \___\ \___\ \___\ \___\
echo                        \  / __/_/   / /   / /   /
echo                         \/_/\   \__/\/___/\/___/
echo                           /  \___\    /  \___\
echo                           \  / __/_17_\  /   /
echo                            \/_/\   \/\ \/___/
echo                              /  \__/  \___\
echo                              \  / _\  /   /
echo                               \/_/\ \/___/
echo                                 /  \___\
echo                                 \  /   /
echo                                  \/___/
echo.
echo                      Powered by Dr Woitschek
echo                       Version: '+$Version+'
echo.

echo wpeinit ...
wpeinit

echo Starting WMI Services
net start winmgmt

echo Wpeutil InitializeNetwork ...
wpeutil InitializeNetwork
echo.

echo Wpeutil DisableFirewall ...
wpeutil DisableFirewall
echo.

REM Anpassung Path Variable
for %%B IN (a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z) DO (
 if exist %%B:\TOOLS (
  set PATH=%PATH%;%%B:\TOOLS\CCTK
  set PATH=%PATH%;%%B:\TOOLS\Chrome
  set PATH=%PATH%;%%B:\TOOLS\CrystalDiskInfo
  set PATH=%PATH%;%%B:\TOOLS\DevManView
  set PATH=%PATH%;%%B:\TOOLS\DriverView
  set PATH=%PATH%;%%B:\TOOLS\HWiNFO
  set PATH=%PATH%;%%B:\TOOLS\imageX
  set PATH=%PATH%;%%B:\TOOLS\Notepad++
  set PATH=%PATH%;%%B:\TOOLS\PSTools
 )
)

echo BOOT mode:

REM reg.exe query HKLM\System\CurrentControlSet\Control /v PEFirmwareType
for /f "tokens=2*" %%A in (''reg query HKLM\System\CurrentControlSet\Control /v PEFirmwareType'') DO SET FW=%%B
if %FW%==0x1 echo  * BIOS
if %FW%==0x2 echo  * UEFI

REM bcdedit | find "path" | find "efi"
REM if %errorlevel%==0 echo UEFI mode
REM if %errorlevel%==1 echo BIOS mode

REM IP-Konfiguration ausgeben
ipconfig /all

REM UltraVNC zur Fernwartung der WinPE starten
for %%B IN (a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z) DO (
 if exist %%B:\TOOLS (
  start /min %%B:\TOOLS\UltraVNC\winvnc.exe
 )
)

REM suche die Datei PE_Sideloading.ps1 und starte es
REM for %%B IN (a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z) DO (
REM  if exist %%B:\PE_Sideloading.ps1 (
REM   echo.
REM   echo.
REM   echo  !!! PowerShell PE Sideloading !!!
REM   echo.
REM   echo.
REM 
REM   powershell.exe -ExecutionPolicy Bypass -NoProfile -File %%B:\PE_Sideloading.ps1
REM 
REM   goto :END
REM  )
REM )

REM suche die Datei PE_Sideloading.cmd und starte es
for %%B IN (a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z) DO (
 if exist %%B:\PE_Sideloading.cmd (
  echo.
  echo.
  echo  !!! CMD PE Sideloading !!!
  echo.
  echo.

  start %%B:\PE_Sideloading.cmd

  goto :END
 )
)

echo.
echo start ntp.cmd
for %%B IN (a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z) DO (
 if exist %%B:\TOOLS (
  start /min %%B:\TOOLS\w32tm\ntp.cmd
 )
)
echo.

:END
for %%B IN (a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z) DO (
 if exist %%B:\TOOLS (
  start /min %%B:\TOOLS\totalcmd\TOTALCMD64.EXE
 )
)
cd\
goto EOF

:EOF';
#
Write-Verbose -Message ('Build Windows PE ...');
Write-Verbose -Message (' ');
#
if(!(Test-Path $WinPE_ADK))
 {
  #
  Write-Warning -Message ('Assessment and Deployment Kit kann nicht gefunden werden');
  Write-Warning -Message ('Abbruch!');
  #
  Exit;
  #
 };
#
if(!(Test-Path $WinPE_TOOLS_Folder))
 {
  #
  Write-Warning -Message ('Tools Ordner kann nicht gefunden werden!');
  Write-Warning -Message ('Abbruch!');
  #
  Exit;
  #
 };
#
if(!(Test-Path $WinPE_BIOS_Folder ))
 {
  #
  Write-Warning -Message ('BIOS Ordner kann nicht gefunden werden!');
  Write-Warning -Message ('Abbruch!');
  #
  Exit;
  #
 };
#
Write-Verbose -Message ('copy MEDIA ...');
#
[String]$copy_source_path = $($WinPE_Source+'\Media');
[String]$copy_target_path = $($WinPE_SAVE+'\media');
#
try
 {
  #
  Copy-Item -Path $copy_source_path         `
            -Destination $copy_target_path  `
            -Recurse                        `
            -ErrorAction Stop               `
            -Force;
  #
  Write-Verbose -Message ('copy MEDIA abgeschlossen');
  Write-Verbose -Message (' ');
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
  Exit;
  #
 };
#
Write-Verbose -Message ('copy boot.wim ...');
#
[String]$copy_source_path = $($WinPE_WIM_Source_Path);
[String]$copy_target_path = $($WinPE_SAVE_Media_Boot_WIM);
#
if(!(Test-Path $($copy_target_path | Split-Path)))
 {
  #
  try
   {
    #
    New-Item -Path $($copy_target_path | Split-Path)  `
             -ItemType Directory                      `
             -ErrorAction Stop                        | Out-Null;
    #
    Write-Verbose -Message ('Ordner '+$($copy_target_path | Split-Path)+' erstellt');
    #
   }
  catch
   {
    #
    if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
    if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
    if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
    #
    Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei New-Item');
    Write-Warning -Message ($Message);
    #
    Exit;
    #
   };
  #
 };
#
try
 {
  #
  Copy-Item -Path $copy_source_path         `
            -Destination $copy_target_path  `
            -ErrorAction Stop               `
            -Force;
  #
  Write-Verbose -Message ('copy boot.wim abgeschlossen');
  Write-Verbose -Message (' ');
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
  Exit;
  #
 };
#
[String]$copy_source_path = $($oscdimg_Folder+'\efisys.bin');
[String]$copy_target_path = $($WinPE_SAVE_FWFiles);
#
if(!(Test-Path $($copy_target_path)))
 {
  #
  try
   {
    #
    New-Item -Path $($copy_target_path)               `
             -ItemType Directory                      `
             -ErrorAction Stop                        | Out-Null;
    #
    Write-Verbose -Message ('Ordner '+$($copy_target_path | Split-Path)+' erstellt');
    Write-Verbose -Message (' ');
    #
   }
  catch
   {
    #
    if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
    if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
    if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
    #
    Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei New-Item');
    Write-Warning -Message ($Message);
    #
    Exit;
    #
   };
  #
 };
#
try
 {
  #
  Copy-Item -Path $copy_source_path         `
            -Destination $copy_target_path  `
            -ErrorAction Stop               `
            -Force;
  #
  Write-Verbose -Message ('copy efisys.bin abgeschlossen');
  Write-Verbose -Message (' ');
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
  Exit;
  #
 };
#
[String]$copy_source_path = $($oscdimg_Folder+'\etfsboot.com');
[String]$copy_target_path = $($WinPE_SAVE_FWFiles);
#
if(!(Test-Path $($copy_target_path)))
 {
  #
  try
   {
    #
    New-Item -Path $($copy_target_path)               `
             -ItemType Directory                      `
             -ErrorAction Stop                        | Out-Null;
    #
    Write-Verbose -Message ('Ordner '+$($copy_target_path | Split-Path)+' erstellt');
    Write-Verbose -Message (' ');
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
    Exit;
    #
   };
  #
 };
#
try
 {
  #
  Copy-Item -Path $copy_source_path         `
            -Destination $copy_target_path  `
            -ErrorAction Stop               `
            -Force;
  #
  Write-Verbose -Message ('copy etfsboot.com abgeschlossen');
  Write-Verbose -Message (' ');
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
  Exit;
  #
 };
#
if(!(Test-Path $($WinPE_SAVE_Mount)))
 {
  #
  try
   {
    #
    New-Item -Path $($WinPE_SAVE_Mount)               `
             -ItemType Directory                      `
             -ErrorAction Stop                        | Out-Null;
    #
    Write-Verbose -Message ('Ordner '+$($WinPE_SAVE_Mount)+' erstellt');
    Write-Verbose -Message (' ');
    #
   }
  catch
   {
    #
    if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
    if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
    if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
    #
    Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei New-Item');
    Write-Warning -Message ($Message);
    #
    Exit;
    #
   };
  #
 };
#
$cmd1 = $($WinPE_ADK_DT_DISM);
$cmd2 = $('/Mount-Image');
$cmd3 = $('/ImageFile:'+$WinPE_SAVE_Media_Boot_WIM);
$cmd4 = $('/Index:1');
$cmd5 = $('/MountDir:'+$WinPE_SAVE_Mount);
#
Write-Verbose -Message ('dism.exe '+$cmd2+' '+$cmd3+' '+$cmd4+' '+$cmd5);
#
& $cmd1 $cmd2 $cmd3 $cmd4 $cmd5 |
 foreach($_) `
  {
   #
   if($_)
    {
     #
     Write-Debug -Message (' '+$_);
     #
    };
   #
  };
#
if(!($LASTEXITCODE -eq '0'))
 {
  #
  Write-Warning -Message ('dism.exe Mount-Image Fehler');
  Write-Warning -Message (' - Errorcode: '+$LASTEXITCODE);
  Write-Warning -Message (' - '+$Error[0].Exception.Message);
  #
  Exit;
  #
 };
#
Write-Verbose -Message (' ');
#
Write-Verbose -Message ('DE Language Pack installieren ...');
#
$cmd1 = $($WinPE_ADK_DT_DISM);
$cmd2 = $('/Add-Package');
$cmd3 = $('/Image:"'+$WinPE_SAVE_Mount+'"');
$cmd4 = $('/PackagePath:'+$('"'+$WinPE_ADK_WPE+'\'+$WinPE_Arch+'\WinPE_OCs\de-de\lp.cab"'));
#
Write-Verbose -Message ('dism.exe '+$cmd2+' '+$cmd3+' '+$cmd4);
#
& $cmd1 $cmd2 $cmd3 $cmd4 |
 foreach($_) `
  {
   #
   if($_)
    {
     #
     Write-Debug -Message (' '+$_);
     #
    };
   #
  };
#
if(!($LASTEXITCODE -eq '0'))
 {
  #
  Write-Warning -Message ('dism.exe lp.cab Fehler');
  Write-Warning -Message (' - Errorcode: '+$LASTEXITCODE);
  Write-Warning -Message (' - '+$Error[0].Exception.Message);
  #
  Exit;
  #
 };
#
Write-Verbose -Message (' ');
#
Write-Verbose -Message ('Sprache auf de-de setzen ...');
#
$cmd1 = $($WinPE_ADK_DT_DISM);
$cmd2 = $('/Image:'+$WinPE_SAVE_Mount);
$cmd3 = $('/Set-AllIntl:de-de');
#
Write-Verbose -Message ('dism.exe '+$cmd2+' '+$cmd3);
#
& $cmd1 $cmd2 $cmd3 |
 foreach($_) `
  {
   #
   if($_)
    {
     #
     Write-Debug -Message (' '+$_);
     #
    };
   #
  };
#
if(!($LASTEXITCODE -eq '0'))
 {
  #
  Write-Warning -Message ('dism.exe de-de Fehler');
  Write-Warning -Message (' - Errorcode: '+$LASTEXITCODE);
  Write-Warning -Message (' - '+$Error[0].Exception.Message);
  #
  Exit;
  #
 };
#
Write-Verbose -Message (' ');
#
Write-Verbose -Message ('PE Sprachen entfernen ...');
#
foreach($WinPE_Sprachen_loeschen_Tmp in $WinPE_Sprachen_loeschen)
 {
  #
  if(Test-Path $($WinPE_SAVE_Media+'\'+$WinPE_Sprachen_loeschen_Tmp))
   {
    #
    try
     {
      #
      Remove-Item -Path $($WinPE_SAVE_Media+'\'+$WinPE_Sprachen_loeschen_Tmp)  `
                  -Force                                                       `
                  -Recurse                                                     `
                  -ErrorAction Stop                                            | Out-Null;
      #
      Write-Verbose -Message ('Sprache '''+$($WinPE_Sprachen_loeschen_Tmp)+''' entfernt');
      #
     }
    catch
     {
      #
      if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
      if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
      if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
      #
      Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Remove-Item');
      Write-Warning -Message ($Message);
      #
      Exit;
      #
     };
    #
   };
  #
  if(Test-Path $($WinPE_SAVE_Media+'\Boot\'+$WinPE_Sprachen_loeschen_Tmp))
   {
    #
    try
     {
      #
      Remove-Item -Path $($WinPE_SAVE_Media+'\Boot\'+$WinPE_Sprachen_loeschen_Tmp)  `
                  -Force                                                       `
                  -Recurse                                                     `
                  -ErrorAction Stop                                            | Out-Null;
      #
      Write-Verbose -Message ('Sprache '''+$('\Boot\'+$WinPE_Sprachen_loeschen_Tmp)+''' entfernt');
      #
     }
    catch
     {
      #
      if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
      if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
      if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
      #
      Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Remove-Item');
      Write-Warning -Message ($Message);
      #
      Exit;
      #
     };
    #
   };
  #
 };
#
Write-Verbose -Message (' ');
#
Write-Verbose -Message ('PE addons ...');
#
foreach($WinPE_Software_Install_Tmp in $WinPE_Software_Install)
 {
  #
  $cmd1 = $($WinPE_ADK_DT_DISM);
  $cmd2 = $('/Add-Package');
  $cmd3 = $('/Image:'+$WinPE_SAVE_Mount);
  $cmd4 = $('/PackagePath:'+$WinPE_Software_Install_Tmp);
  #
  Write-Verbose -Message ('dism.exe '+$cmd2+' '+$cmd3+' '+$cmd4);
  #
  & $cmd1 $cmd2 $cmd3 $cmd4 |
   foreach($_) `
    {
     #
     if($_)
      {
       #
       Write-Debug -Message (' '+$_);
       #
      };
     #
    };
  #
  if(!($LASTEXITCODE -eq '0'))
   {
    #
    Write-Warning -Message ('dism.exe Add-Package Fehler');
    Write-Warning -Message (' - Errorcode: '+$LASTEXITCODE);
    Write-Warning -Message (' - '+$Error[0].Exception.Message);
    #
    Exit;
    #
   };
  #
 };
#
if($AddOn_TOOLS)
 {
  #
  Write-Verbose -Message (' ');
  Write-Verbose -Message ('PE AddOn: TOOLS');
  #
  if(!(Test-Path $($WinPE_mounted_TOOLS)))
   {
    #
    try
     {
      #
      New-Item -Path $($WinPE_mounted_TOOLS)            `
               -ItemType Directory                      `
               -ErrorAction Stop                        | Out-Null;
      #
      Write-Verbose -Message ('Ordner '''+$($WinPE_mounted_TOOLS)+''' erstellt');
      Write-Verbose -Message (' ');
      #
     }
    catch
     {
      #
      if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
      if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
      if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
      #
      Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei New-Item');
      Write-Warning -Message ($Message);
      #
      Exit;
      #
     };
    #
   };
  #
  [String]$copy_source_path = $($WinPE_TOOLS_Folder);
  [String]$copy_target_path = $($WinPE_mounted_TOOLS);
  #
  try
   {
    #
    Get-ChildItem -Path $copy_source_path |
     Copy-Item -Destination $copy_target_path -Recurse -ErrorAction Stop;
    #
    Write-Verbose -Message ('kopieren von '+$copy_source_path+' nach '+$copy_target_path+' abgeschlossen');
    Write-Verbose -Message (' ');
    #
   }
  catch
   {
    #
    if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
    if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
    if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
    #
    Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Get-ChildItem/Copy-Item');
    Write-Warning -Message ($Message);
    #
    Exit;
    #
   };
  #
 };
#
if($AddOn_BIOS)
 {
  #
  Write-Verbose -Message (' ');
  Write-Verbose -Message ('PE AddOn: BIOS');
  #
  if(!(Test-Path $($WinPE_mounted_BIOS)))
   {
    #
    try
     {
      #
      New-Item -Path $($WinPE_mounted_BIOS)             `
               -ItemType Directory                      `
               -ErrorAction Stop                        | Out-Null;
      #
      Write-Verbose -Message ('Ordner '''+$($WinPE_mounted_BIOS)+''' erstellt');
      Write-Verbose -Message (' ');
      #
     }
    catch
     {
      #
      if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
      if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
      if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
      #
      Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei New-Item');
      Write-Warning -Message ($Message);
      #
      Exit;
      #
     };
    #
   };
  #
  [String]$copy_source_path = $($WinPE_BIOS_Folder);
  [String]$copy_target_path = $($WinPE_mounted_BIOS);
  #
  try
   {
    #
    Get-ChildItem -Path $copy_source_path |
     Copy-Item -Destination $copy_target_path -Recurse -ErrorAction Stop;
    #
    Write-Verbose -Message ('kopieren von '+$copy_source_path+' nach '+$copy_target_path+' abgeschlossen');
    Write-Verbose -Message (' ');
    #
   }
  catch
   {
    #
    if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
    if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
    if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
    #
    Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Get-ChildItem/Copy-Item');
    Write-Warning -Message ($Message);
    #
    Exit;
    #
   };
  #
 };
#
if($AddOn_TotalCommander)
 {
  #
  Write-Verbose -Message (' ');
  Write-Verbose -Message ('PE AddOn: Total Commander');
  #
  if(!(Test-Path $($($WinPE_SAVE_Mount+'\Windows\system32\config\systemprofile\AppData\Roaming\GHISLER'))))
   {
    #
    try
     {
      #
      New-Item -Path $($($WinPE_SAVE_Mount+'\Windows\system32\config\systemprofile\AppData\Roaming\GHISLER'))  `
               -ItemType Directory                                                                             `
               -ErrorAction Stop                                                                               | Out-Null;
      #
      Write-Verbose -Message ('Ordner '''+$($WinPE_SAVE_Mount+'\Windows\system32\config\systemprofile\AppData\Roaming\GHISLER')+''' erstellt');
      Write-Verbose -Message (' ');
      #
     }
    catch
     {
      #
      if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
      if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
      if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
      #
      Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei New-Item');
      Write-Warning -Message ($Message);
      #
      Exit;
      #
     };
    #
   };
  #
  [String]$copy_source_path = $($WinPE_TOOLS_Folder+'\wincmd.ini');
  [String]$copy_target_path = $($WinPE_SAVE_Mount+'\Windows\system32\config\systemprofile\AppData\Roaming\GHISLER');
  #
  try
   {
    #
    Copy-Item -Path $copy_source_path         `
              -Destination $copy_target_path  `
              -ErrorAction Stop               `
              -Force;
    #
    Write-Verbose -Message ('kopieren von '+$copy_source_path+' nach '+$copy_target_path+' abgeschlossen');
    Write-Verbose -Message (' ');
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
    Exit;
    #
   };
  #
 };
#
try
 {
  #
  $startnet_cmd |
   Out-File -FilePath $($WinPE_SAVE_Mount+'\Windows\system32\startnet.cmd')  `
            -Encoding ascii                                                  `
            -ErrorAction Stop;
  #
  Write-Verbose -Message ('startnet.cmd Anpassung abgeschlossen');
  Write-Verbose -Message (' ');
  #
 }
catch
 {
  #
  if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
  if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
  if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
  #
  Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Out-File');
  Write-Warning -Message ($Message);
  #
  Exit;
  #
 };
#
try
 {
  #
  Remove-Item -Path $($WinPE_SAVE_Media+'\Boot\bootfix.bin')  `
              -Force                                          `
              -ErrorAction Stop;
  #
  Write-Verbose -Message ('Entfernen der Meldung ''Press any key to boot from the CD'' abgeschlossen');
  Write-Verbose -Message (' ');
  #
 }
catch
 {
  #
  if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
  if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
  if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
  #
  Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Remove-Item');
  Write-Warning -Message ($Message);
  #
  Exit;
  #
 };
#
if($InstallDrivers)
 {
  #
  Write-Verbose -Message (' ');
  Write-Verbose -Message ('PE AddOn: Add-Drivers');
  #
  if(Test-Path $WinPE_Drivers)
   {
    #
    $cmd1 = $($WinPE_ADK_DT_DISM);
    $cmd2 = $('/Image:'+$WinPE_SAVE_Mount);
    $cmd3 = $('/Add-Driver:'+$WinPE_Drivers);
    $cmd4 = $('/recurse');
    $cmd5 = $('/ForceUnsigned');
    #
    & $cmd1 $cmd2 $cmd3 $cmd4 $cmd5 |
     foreach($_) `
      {
       #
       if($_)
        {
         #
         Write-Debug -Message (' '+$_);
         #
        };
       #
      };
    #
    if(!($LASTEXITCODE -eq '0'))
     {
      #
      Write-Warning -Message ('dism.exe Add-Driver Fehler');
      Write-Warning -Message (' - Errorcode: '+$LASTEXITCODE);
      Write-Warning -Message (' - '+$Error[0].Exception.Message);
      #
      Exit;
      #
     };
    #
   }
    else
   {
    #
    Write-Warning -Message ('Treiber-Pfad wurde nicht gefunden');
    Write-Warning -Message ('Skip');
    #
   };
  #
 };
#
Write-Verbose -Message (' ');
#
Write-Verbose -Message ('unmount ...');
#
$cmd1 = $($WinPE_ADK_DT_DISM);
$cmd2 = $('/Unmount-Wim');
$cmd3 = $('/MountDir:'+$WinPE_SAVE_Mount);
$cmd4 = $('/commit');
#
Write-Verbose -Message ('dism.exe '+$cmd2+' '+$cmd3+' '+$cmd4);
#
& $cmd1 $cmd2 $cmd3 $cmd4 |
 foreach($_) `
  {
   #
   if($_)
    {
     #
     Write-Debug -Message (' '+$_);
     #
    };
   #
  };
#
if(!($LASTEXITCODE -eq '0'))
 {
  #
  Write-Warning -Message ('dism.exe unmount Fehler');
  Write-Warning -Message (' - Errorcode: '+$LASTEXITCODE);
  Write-Warning -Message (' - '+$Error[0].Exception.Message);
  #
  Exit;
  #
 };
#
Write-Verbose -Message (' ');
#
Write-Verbose -Message ('Sideloading');
#
[String]$SideloadingValue = `
'@echo off

REM von wo wird das Batch ausgefuehrt
%~d0

echo %date%
echo %time%

pause
Exit';
#
[String]$SideloadingFile = $($WinPE_SAVE_Media+'\PE_Sideloading.cmd');
#
try
 {
  #
  Set-Content -Value $SideloadingValue  `
              -Path $SideloadingFile    `
              -ErrorAction Stop;
  #
  Write-Verbose -Message ('Sideloading-Datei '''+$SideloadingFile+''' erstellt');
  Write-Verbose -Message (' ');
  #
 }
catch
 {
  #
  if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
  if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
  if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
  #
  Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Set-Content');
  Write-Warning -Message ($Message);
  #
  Exit;
  #
 };
#
$BootData   = '2#p0,e,b"{0}"#pEF,e,b"{1}"' -f "$oscdimg_etfsboot","$oscdimg_efisys";
#
$ISO_Bilder = Start-Process -FilePath $oscdimg_exe                                                                           `
                            -ArgumentList @("-bootdata:$BootData",'-u1','-udfver102',"$WinPE_SAVE_Media","$WinPE_ISO_File")  `
                            -PassThru                                                                                        `
                            -Wait                                                                                            `
                            -NoNewWindow;
#
if($ISO_Bilder.ExitCode -ne 0)
 {
  #
  Write-Warning -Message ('Fehler beim erstellen der ISO-Datei!');
  Write-Warning -Message ('ExitCode: '''+$Proc.ExitCode+'''');
  #
 }
  else
 {
  #
  Write-Verbose -Message ('ISO-Datei '''+$WinPE_ISO_File+''' wurde erstellt');
  Write-Verbose -Message (' ');
  #
 };
#
$VerbosePreference = 'SilentlyContinue';
$DebugPreference = 'SilentlyContinue';
#
Write-Information -InformationAction Continue -MessageData (' ');
Write-Information -InformationAction Continue -MessageData ('Build Version: '''+$Version+'''');
Write-Information -InformationAction Continue -MessageData ('WorkingDir:    '''+$WorkingDir+'''');
Write-Information -InformationAction Continue -MessageData ('PE Arch:       '''+$WinPE_Arch+'''');
Write-Information -InformationAction Continue -MessageData ('ISO Output:    '''+$WinPE_ISO_File+'''');
Write-Information -InformationAction Continue -MessageData (' ');
Write-Information -InformationAction Continue -MessageData ('AddOns:');
Write-Information -InformationAction Continue -MessageData ('- Allgemeine TOOLS:    '+$AddOn_TOOLS);
Write-Information -InformationAction Continue -MessageData ('- BIOS Tools/Updates:  '+$AddOn_BIOS);
Write-Information -InformationAction Continue -MessageData ('- TotalCommander       '+$AddOn_TotalCommander);
Write-Information -InformationAction Continue -MessageData ('- Treiber integration: '+$InstallDrivers);
Write-Information -InformationAction Continue -MessageData (' ');
#
Write-Information -InformationAction Continue -MessageData ('Edit:');
Write-Information -InformationAction Continue -MessageData ('cd\ "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment"');
Write-Information -InformationAction Continue -MessageData ('cd\ "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"');
#
$cmd1 = $('dism.exe /Mount-Image /ImageFile:'+$WinPE_SAVE_Media_Boot_WIM+' /Index:1 /MountDir:'+$WinPE_SAVE_Mount);
Write-Information -InformationAction Continue -MessageData ('    Mount:     '''+$cmd1+'''');
#
$cmd1 = $('dism.exe /Unmount-Wim /MountDir:'+$WinPE_SAVE_Mount+' /commit');
Write-Information -InformationAction Continue -MessageData ('    Unmount:   '''+$cmd1+'''');
#
$cmd1 = $('MakeWinPEMedia /UFD '+$WinPE_SAVE+' D:');
Write-Information -InformationAction Continue -MessageData ('    Build USB: '''+$cmd1+'''');
#
$cmd1 = $('MakeWinPEMedia /ISO '+$WinPE_SAVE+' PE.iso');
Write-Information -InformationAction Continue -MessageData ('    Build ISO: '''+$cmd1+'''');
#
[Array]$Alle_Variablen = `
 @(
   #
   'Random'                      ,
   'MainDrive'                   ,
   'WorkingDir'                  ,
   #                
   'WinPE_WorkingDir'            ,
   'WinPE_Arch'                  ,
   'WinPE_SAVE'                  ,
   'WinPE_SAVE_Media'            ,
   'WinPE_SAVE_Media_Boot_WIM'   ,
   'WinPE_SAVE_Mount'            ,
   'WinPE_SAVE_FWFiles'          ,
   #
   'WinPE_TOOLS_Folder'          ,
   'WinPE_BIOS_Folder'           ,
   'WinPE_mounted_TOOLS'         ,
   'WinPE_mounted_BIOS'          ,
   #
   'WinPE_Drivers'               ,
   #
   'WinPE_ADK'                   ,
   'WinPE_ADK_DT'                ,
   'WinPE_ADK_DT_DISM'           ,
   'WinPE_ADK_WPE'               ,
   #
   'oscdimg_Folder'              ,
   'oscdimg_exe'                 ,
   'oscdimg_etfsboot'            ,
   'oscdimg_efisys'              ,
   #
   'WinPE_ISO_File'              ,
   #
   'WinPE_Source'                ,
   'WinPE_fwfilesRoot'           ,
   'WinPE_WIM_Source_Path'       ,
   #
   'WinPE_Software_Install'      ,
   'WinPE_Software_Install_Tmp'  ,
   'WinPE_Sprachen_loeschen'     ,
   'WinPE_Sprachen_loeschen_Tmp' ,
   #
   'cmd1'                        ,
   'cmd2'                        ,
   'cmd3'                        ,
   'cmd4'                        ,
   'cmd5'                        ,
   #
   'startnet_cmd'                ,
   #
   'SideloadingValue'            ,
   'SideloadingFile'             ,
   #
   'ScriptLineNumber'            ,
   'Category'                    ,
   'Message'                     ,
   'TargetObject'                ,
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
```

Beispiel-Ausgabe:

```
AUSFÜHRLICH: Build Windows PE ...
AUSFÜHRLICH:  
AUSFÜHRLICH: copy MEDIA ...
AUSFÜHRLICH: copy MEDIA abgeschlossen
AUSFÜHRLICH:  
AUSFÜHRLICH: copy boot.wim ...
AUSFÜHRLICH: Ordner C:\TEMP\PE\amd64\853121629\media\sources erstellt
AUSFÜHRLICH: copy boot.wim abgeschlossen
AUSFÜHRLICH:  
AUSFÜHRLICH: Ordner C:\TEMP\PE\amd64\853121629 erstellt
AUSFÜHRLICH:  
AUSFÜHRLICH: copy efisys.bin abgeschlossen
AUSFÜHRLICH:  
AUSFÜHRLICH: copy etfsboot.com abgeschlossen
AUSFÜHRLICH:  
AUSFÜHRLICH: Ordner C:\TEMP\PE\amd64\853121629\mount erstellt
AUSFÜHRLICH:  
AUSFÜHRLICH: dism.exe /Mount-Image /ImageFile:C:\TEMP\PE\amd64\853121629\media\sources\boot.wim /Index:1 /MountDir:C:\TEMP\PE\amd64\853121629\mount
AUSFÜHRLICH:  
AUSFÜHRLICH: DE Language Pack installieren ...
AUSFÜHRLICH: dism.exe /Add-Package /Image:"C:\TEMP\PE\amd64\853121629\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\de-de\lp.cab"
AUSFÜHRLICH:  
AUSFÜHRLICH: Sprache auf de-de setzen ...
AUSFÜHRLICH: dism.exe /Image:C:\TEMP\PE\amd64\853121629\mount /Set-AllIntl:de-de
AUSFÜHRLICH:  
AUSFÜHRLICH: PE Sprachen entfernen ...
AUSFÜHRLICH: Sprache 'bg-bg' entfernt
AUSFÜHRLICH: Sprache '\Boot\bg-bg' entfernt
AUSFÜHRLICH: Sprache 'cs-cz' entfernt
AUSFÜHRLICH: Sprache '\Boot\cs-cz' entfernt
AUSFÜHRLICH: Sprache 'da-dk' entfernt
AUSFÜHRLICH: Sprache '\Boot\da-dk' entfernt
AUSFÜHRLICH: Sprache 'el-gr' entfernt
AUSFÜHRLICH: Sprache '\Boot\el-gr' entfernt
AUSFÜHRLICH: Sprache 'en-gb' entfernt
AUSFÜHRLICH: Sprache '\Boot\en-gb' entfernt
AUSFÜHRLICH: Sprache 'es-es' entfernt
AUSFÜHRLICH: Sprache '\Boot\es-es' entfernt
AUSFÜHRLICH: Sprache 'et-ee' entfernt
AUSFÜHRLICH: Sprache '\Boot\et-ee' entfernt
AUSFÜHRLICH: Sprache 'fi-fi' entfernt
AUSFÜHRLICH: Sprache '\Boot\fi-fi' entfernt
AUSFÜHRLICH: Sprache 'fr-fr' entfernt
AUSFÜHRLICH: Sprache '\Boot\fr-fr' entfernt
AUSFÜHRLICH: Sprache 'hr-hr' entfernt
AUSFÜHRLICH: Sprache '\Boot\hr-hr' entfernt
AUSFÜHRLICH: Sprache 'hu-hu' entfernt
AUSFÜHRLICH: Sprache '\Boot\hu-hu' entfernt
AUSFÜHRLICH: Sprache 'it-it' entfernt
AUSFÜHRLICH: Sprache '\Boot\it-it' entfernt
AUSFÜHRLICH: Sprache 'ja-jp' entfernt
AUSFÜHRLICH: Sprache '\Boot\ja-jp' entfernt
AUSFÜHRLICH: Sprache 'ko-kr' entfernt
AUSFÜHRLICH: Sprache '\Boot\ko-kr' entfernt
AUSFÜHRLICH: Sprache 'lt-lt' entfernt
AUSFÜHRLICH: Sprache '\Boot\lt-lt' entfernt
AUSFÜHRLICH: Sprache 'lv-lv' entfernt
AUSFÜHRLICH: Sprache '\Boot\lv-lv' entfernt
AUSFÜHRLICH: Sprache 'nb-no' entfernt
AUSFÜHRLICH: Sprache '\Boot\nb-no' entfernt
AUSFÜHRLICH: Sprache 'nl-nl' entfernt
AUSFÜHRLICH: Sprache '\Boot\nl-nl' entfernt
AUSFÜHRLICH: Sprache 'pl-pl' entfernt
AUSFÜHRLICH: Sprache '\Boot\pl-pl' entfernt
AUSFÜHRLICH: Sprache 'pt-br' entfernt
AUSFÜHRLICH: Sprache '\Boot\pt-br' entfernt
AUSFÜHRLICH: Sprache 'pt-pt' entfernt
AUSFÜHRLICH: Sprache '\Boot\pt-pt' entfernt
AUSFÜHRLICH: Sprache 'ro-ro' entfernt
AUSFÜHRLICH: Sprache '\Boot\ro-ro' entfernt
AUSFÜHRLICH: Sprache 'ru-ru' entfernt
AUSFÜHRLICH: Sprache '\Boot\ru-ru' entfernt
AUSFÜHRLICH: Sprache 'sk-sk' entfernt
AUSFÜHRLICH: Sprache '\Boot\sk-sk' entfernt
AUSFÜHRLICH: Sprache 'sl-si' entfernt
AUSFÜHRLICH: Sprache '\Boot\sl-si' entfernt
AUSFÜHRLICH: Sprache 'sr-latn-rs' entfernt
AUSFÜHRLICH: Sprache '\Boot\sr-latn-rs' entfernt
AUSFÜHRLICH: Sprache 'sv-se' entfernt
AUSFÜHRLICH: Sprache '\Boot\sv-se' entfernt
AUSFÜHRLICH: Sprache 'tr-tr' entfernt
AUSFÜHRLICH: Sprache '\Boot\tr-tr' entfernt
AUSFÜHRLICH: Sprache 'uk-ua' entfernt
AUSFÜHRLICH: Sprache '\Boot\uk-ua' entfernt
AUSFÜHRLICH: Sprache 'zh-cn' entfernt
AUSFÜHRLICH: Sprache '\Boot\zh-cn' entfernt
AUSFÜHRLICH: Sprache 'zh-tw' entfernt
AUSFÜHRLICH: Sprache '\Boot\zh-tw' entfernt
AUSFÜHRLICH: Sprache 'es-mx' entfernt
AUSFÜHRLICH: Sprache '\Boot\es-mx' entfernt
AUSFÜHRLICH: Sprache 'fr-ca' entfernt
AUSFÜHRLICH: Sprache '\Boot\fr-ca' entfernt
AUSFÜHRLICH:  
AUSFÜHRLICH: PE addons ...
AUSFÜHRLICH: dism.exe /Add-Package /Image:C:\TEMP\PE\amd64\853121629\mount /PackagePath:C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-NetFX.cab
AUSFÜHRLICH: dism.exe /Add-Package /Image:C:\TEMP\PE\amd64\853121629\mount /PackagePath:C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-Scripting.
cab
AUSFÜHRLICH: dism.exe /Add-Package /Image:C:\TEMP\PE\amd64\853121629\mount /PackagePath:C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-PowerShell
.cab
AUSFÜHRLICH: dism.exe /Add-Package /Image:C:\TEMP\PE\amd64\853121629\mount /PackagePath:C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-DismCmdlet
s.cab
AUSFÜHRLICH: dism.exe /Add-Package /Image:C:\TEMP\PE\amd64\853121629\mount /PackagePath:C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-WMI.cab
AUSFÜHRLICH: dism.exe /Add-Package /Image:C:\TEMP\PE\amd64\853121629\mount /PackagePath:C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-SecureStar
tup.cab
AUSFÜHRLICH: dism.exe /Add-Package /Image:C:\TEMP\PE\amd64\853121629\mount /PackagePath:C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-wds-tools.
cab
AUSFÜHRLICH:  
AUSFÜHRLICH: PE AddOn: TOOLS
AUSFÜHRLICH: Ordner 'C:\TEMP\PE\amd64\853121629\media\TOOLS' erstellt
AUSFÜHRLICH:  
AUSFÜHRLICH: kopieren von C:\TEMP\PE_Tools nach C:\TEMP\PE\amd64\853121629\media\TOOLS abgeschlossen
AUSFÜHRLICH:  
AUSFÜHRLICH:  
AUSFÜHRLICH: PE AddOn: BIOS
AUSFÜHRLICH: Ordner 'C:\TEMP\PE\amd64\853121629\media\BIOS' erstellt
AUSFÜHRLICH:  
AUSFÜHRLICH: kopieren von C:\TEMP\PE_BIOS nach C:\TEMP\PE\amd64\853121629\media\BIOS abgeschlossen
AUSFÜHRLICH:  
AUSFÜHRLICH:  
AUSFÜHRLICH: PE AddOn: Total Commander
AUSFÜHRLICH: Ordner 'C:\TEMP\PE\amd64\853121629\mount\Windows\system32\config\systemprofile\AppData\Roaming\GHISLER' erstellt
AUSFÜHRLICH:  
AUSFÜHRLICH: kopieren von C:\TEMP\PE_Tools\wincmd.ini nach C:\TEMP\PE\amd64\853121629\mount\Windows\system32\config\systemprofile\AppData\Roaming\GHISLER abgeschlossen
AUSFÜHRLICH:  
AUSFÜHRLICH: startnet.cmd Anpassung abgeschlossen
AUSFÜHRLICH:  
AUSFÜHRLICH: Entfernen der Meldung 'Press any key to boot from the CD' abgeschlossen
AUSFÜHRLICH:  
AUSFÜHRLICH:  
AUSFÜHRLICH: PE AddOn: Add-Drivers
AUSFÜHRLICH:  
AUSFÜHRLICH: unmount ...
AUSFÜHRLICH: dism.exe /Unmount-Wim /MountDir:C:\TEMP\PE\amd64\853121629\mount /commit
AUSFÜHRLICH:  
AUSFÜHRLICH: Sideloading
AUSFÜHRLICH: Sideloading-Datei 'C:\TEMP\PE\amd64\853121629\media\PE_Sideloading.cmd' erstellt
AUSFÜHRLICH:  
AUSFÜHRLICH: ISO-Datei 'C:\TEMP\PE\amd64\853121629\Windows_PE.iso' wurde erstellt
AUSFÜHRLICH:  
 
Build Version: 'V1-2023-10-09-13-01-12'
WorkingDir:    'C:\TEMP'
PE Arch:       'amd64'
ISO Output:    'C:\TEMP\PE\amd64\853121629\Windows_PE.iso'
 
AddOns:
- Allgemeine TOOLS:    True
- BIOS Tools/Updates:  True
- TotalCommander       True
- Treiber integration: True
 
Edit:
cd\ "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment"
cd\ "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"
    Mount:     'dism.exe /Mount-Image /ImageFile:C:\TEMP\PE\amd64\853121629\media\sources\boot.wim /Index:1 /MountDir:C:\TEMP\PE\amd64\853121629\mount'
    Unmount:   'dism.exe /Unmount-Wim /MountDir:C:\TEMP\PE\amd64\853121629\mount /commit'
    Build USB: 'MakeWinPEMedia /UFD C:\TEMP\PE\amd64\853121629 D:'
    Build ISO: 'MakeWinPEMedia /ISO C:\TEMP\PE\amd64\853121629 PE.iso'
```

---

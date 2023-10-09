**Sysinternals Suite herunterladen und entpacken/updaten:**

```
#
$VerbosePreference = 'continue';
#
[String]$URI = $('https://download.sysinternals.com/files/SysinternalsSuite.zip');
[String]$Tmp = $($env:TEMP+'\'+$($URI | Split-Path -Leaf));
[String]$Prg = $('C:\PSTools');
#
try
 {
  #
  Invoke-WebRequest -Uri $URI        `
                    -OutFile $Tmp    `
                    -ErrorAction Stop;
  #
  Write-Verbose -Message ('Download abgeschlossen!');
  #
 }
catch
 {
  #
  if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
  if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
  if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
  #
  Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Invoke-WebRequest');
  Write-Warning -Message ($Message);
  #
  Exit;
  #
 };
#
if(Test-Path -Path $Prg)
 {
  #
  try
   {
    #
    Remove-Item -Path $Prg       `
                -Recurse         `
                -Force           `
                -ErrorAction Stop;
    #
    Write-Verbose -Message ('Ordner '+$Prg+' bereit vorhanden, wird entfernt');
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
try
 {
  #
  Expand-Archive -Path $Tmp             `
                 -DestinationPath $Prg  `
                 -ErrorAction Stop;
  #
  Write-Verbose -Message ('ZIP-Datei entpackt');
  #
 }
catch
 {
  #
  if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
  if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
  if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
  #
  Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Expand-Archive');
  Write-Warning -Message ($Message);
  #
  Exit;
  #
 };
#
try
 {
  #
  Remove-Item -Path $Tmp  `
              -Force      `
              -ErrorAction Stop;
  #
  Write-Verbose -Message $('ZIP-Datei entfernt');
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
[Array]$Alle_Variablen = `
 @(
   #
   'Tmp'                                  ,
   'URI'                                  ,
   #
   'ScriptLineNumber'                     ,
   'Category'                             ,
   'Message'                              ,
   'TargetObject'                         ,
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
$VerbosePreference = 'SilentlyContinue';
#
Exit;
#
```

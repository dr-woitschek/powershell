
[Selenium-Chrome.ps1](https://github.com/dr-woitschek/powershell/blob/main/Scripte/Selenium-Chrome/Selenium-Chrome.ps1)

```

<#

  .SYNOPSIS
   Erzeugt einen Selenium-Browser

  .DESCRIPTION
   Erzeugt einen Selenium-Browser als Google Chrome.
   Dieser Browser kann dann angesteuert werden.

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
   Selenium-Chrome.ps1

#>

```

---

Beispiel - Browser starten und beenden

```

#
[String]$WorkingDir     = 'C:\TEMP\Browser';
[String]$Url            = 'about:blank';
[String]$BrowserOptions = '--disable-extensions' , '--ignore-certificate-errors';
#
try
 {
  #
  $Browser = New-Selenium-Chrome -WorkingDir $WorkingDir           `
                                 -BrowserOptions $BrowserOptions   `
                                 -PrefDownloadDirectory $WorkingDir;
  #
  Write-Verbose -Message ('New-Selenium-Chrome ausgeführt');
  #
 }
catch
 {
  #
  if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
  if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
  if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
  #
  Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei New-Selenium-Chrome');
  Write-Warning -Message ($Message);
  #
  $Browser.Quit();
  #
  Exit;
  #
 };
#
try
 {
  #
  $Browser.Manage().Window.Position = '0,0';
  $Browser.Manage().Window.Size = '1024,768';
  #
  $Browser.Url = $Url;
  $Browser.Navigate() | Out-Null;
  #
  Write-Verbose -Message ('Navigate '+$Url+' abgeschlossen');
  #
 }
catch
 {
  #
  if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
  if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
  if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
  #
  Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Navigate about:blank');
  Write-Warning -Message ($Message);
  #
  $Browser.Quit();
  #
  Exit;
  #
 };
#
Start-Sleep -Seconds 3;
#
try
 {
  #
  $Browser.Quit();
  #
  Write-Verbose -Message ('Quit abgeschlossen');
  #
 }
catch
 {
  #
  if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
  if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
  if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
  #
  Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Quit');
  Write-Warning -Message ($Message);
  #
  Exit;
  #
 };
#
Remove-Variable -Name WorkingDir;
Remove-Variable -Name Url;
Remove-Variable -Name BrowserOptions;
#

```

---

Beispiel - Möglichkeiten zur Fensteransteuerung

```

$Browser.Manage().Window.Position = '50,0'; # Position von LINKS,OBEN
$Browser.Manage().Window.Size = '1024,768'; # Fenstergröße

$Browser.Manage().Window.Maximize();        # Fenster maximieren
$Browser.Manage().Window.Minimize();        # Fenster minimieren
$Browser.Manage().Window.FullScreen();      # Fenster Vollbild

```

---

Beispiel - Screenshot des Browsers machen

```

#
[OpenQA.Selenium.ScreenshotImageFormat]$ImageFormat = [OpenQA.Selenium.ScreenshotImageFormat]::Png;
#
$Screenshot = [OpenQA.Selenium.Support.Extensions.WebDriverExtensions]::TakeScreenshot($Browser);
#
$Screenshot.SaveAsFile($WorkingDir+'\Screenshot.png', $ImageFormat);
#

```

---


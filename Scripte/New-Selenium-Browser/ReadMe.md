
[New-Selenium-Browser.ps1](https://github.com/dr-woitschek/powershell/blob/main/Scripte/FileSystemWatcher/New-Selenium-Browser.ps1)

```
#Requires -Version 5.0
#
<#

  .SYNOPSIS
   Erzeugt einen Selenium-Browser

  .DESCRIPTION
   Erzeugt einen Selenium-Browser als Google Chrome,
   Microsoft Edge oder Mozilla FireFox.
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
   New-Selenium-Browser.ps1

#>
#
Clear-Host;
#
$VerbosePreference = 'SilentlyContinue';
#
function New-Selenium-Browser
 {
  #
  [CmdletBinding(SupportsShouldProcess = $True,
                 HelpUri               = 'https://github.com/dr-woitschek/powershell/tree/main/',
                 ConfirmImpact         = 'High')]
  Param(
   [Parameter(Mandatory         = $True,
              ValueFromPipeline = $True,
              Position          = 0,
              HelpMessage       = 'Definiert den Selenium-Browser, oder Get-Help <Funktion> -Example')]
   [ValidateNotNullOrEmpty()]
   [ValidateNotNull()]
   [ValidateSet('Chrome' , 'Edge' , 'Firefox')]
   [String]$Browser,
   #
   [Parameter(Mandatory         = $False,
              ValueFromPipeline = $True,
              Position          = 1,
              HelpMessage       = 'Definiert die Browser-Optionen, oder Get-Help <Funktion> -Example')]
   [Object]$BrowserOptions,
   #
   [Parameter(Mandatory         = $False,
              ValueFromPipeline = $True,
              Position          = 2,
              HelpMessage       = 'Definiert das Arbeitsverzeichnis, oder Get-Help <Funktion> -Example')]
   [String]$WorkingDir
   #
  );
  #
  Process
   {
    #
    if(!($WorkingDir))
     {
      #
      $WorkingDir = $env:TEMP;
      #
     };
    #
    [Array]$Downloads = @();
    [Array]$Downloads = @(
                          #
                          ('https://www.nuget.org/api/v2/package/Newtonsoft.Json'    , 'lib/net45/Newtonsoft.Json.dll'    , 'Add-Type')  ,
                          ('https://www.nuget.org/api/v2/package/Selenium.WebDriver' , 'lib/netstandard2.0/WebDriver.dll' , 'Add-Type')
                          #
                         );
    #
    switch($Browser)
     {
      #
      'Chrome'
       {
        #
        Write-Verbose -Message 'Add Array - Browser - Chrome';
        #
        [Array]$Downloads += (, ('https://www.nuget.org/api/v2/package/Selenium.WebDriver.ChromeDriver' , 'driver/win32/chromedriver.exe' , ''));
        #
       };
      #
      'Edge'
       {
        #
        Write-Verbose -Message 'Add Array - Browser - Edge';
        #
        [Array]$Downloads += (, ('https://www.nuget.org/api/v2/package/Selenium.WebDriver.MSEdgeDriver' , 'driver/win64/msedgedriver.exe' , ''));
        #
       };
      #
      'Firefox'
       {
        #
        Write-Verbose -Message 'Add Array - Browser - Firefox';
        #
        [Array]$Downloads += (, ('https://www.nuget.org/api/v2/package/Selenium.WebDriver.GeckoDriver' , 'driver/win64/geckodriver.exe' , ''));
        #
       };
      #
     };
    #
    [Array]$Downloads |
     ForEach-Object `
      {
       #
       [String]$Url      = $_[0];
       [String]$FindFile = $_[1];
       [String]$Zip      = $_[1] | Split-Path -Leaf;
       [String]$Zip      = $Zip -replace '.dll','.zip' -replace '.exe','.zip';
       [String]$File     = $_[1] | Split-Path -Leaf;
       [String]$UnZip    = $File -replace '.dll','' -replace '.exe','';
       [String]$AddType  = $_[2];
       #
       Write-Verbose -Message ('Variable ''Url''........'''+$Url+'''');
       Write-Verbose -Message ('Variable ''FindFile''...'''+$FindFile+'''');
       Write-Verbose -Message ('Variable ''Zip''........'''+$Zip+'''');
       Write-Verbose -Message ('Variable ''File''.......'''+$File+'''');
       Write-Verbose -Message ('Variable ''UnZip''......'''+$UnZip+'''');
       Write-Verbose -Message ('Variable ''AddType''....'''+$AddType+'''');
       Write-Verbose -Message (' ');
       #
       if(!(Test-Path -Path ($WorkingDir+'\'+$File)))
        {
         #
         Write-Verbose -Message 'Download & Extract';
         #
         try
          {
           #
           Invoke-WebRequest -Uri $Url                        `
                             -OutFile ($WorkingDir+'\'+$Zip)  `
                             -ErrorAction Stop;
           #
           Write-Verbose -Message 'Download abgeschlossen';
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
         try
          {
           #
           Expand-Archive -Path ($WorkingDir+'\'+$Zip)               `
                          -DestinationPath ($WorkingDir+'\'+$UnZip)  `
                          -ErrorAction Stop;
           #
           Write-Verbose -Message 'Entpacken abgeschlossen';
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
           Return $False;
           #
          };
         #
         try
          {
           #
           Copy-Item -Path ($WorkingDir+'\'+$UnZip+'\'+$FindFile)  `
                     -Destination ($WorkingDir+'\'+$File)          `
                     -Force                                        `
                     -ErrorAction Stop;
           #
           Write-Verbose -Message 'Kopieren abgeschlossen';
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
         try
          {
           #
           Remove-Item -Path ($WorkingDir+'\'+$UnZip)  `
                       -Force                          `
                       -Recurse                        `
                       -ErrorAction Stop;
           #
           Write-Verbose -Message 'UnZip-Ordner gelöscht';
           #
           Remove-Item -Path ($WorkingDir+'\'+$Zip)    `
                       -Force                          `
                       -ErrorAction Stop;
           #
           Write-Verbose -Message 'Zip-Datei gelöscht';
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
        }
         else
        {
         #
         Write-Verbose -Message ('Datei '''+$File+''' vorhanden');
         #
        };
       #
       if($AddType -eq 'Add-Type')
        {
         #
         try
          {
           #
           Add-Type -Path ($WorkingDir+'\'+$File) -ErrorAction Stop;
           #
           Write-Verbose -Message ('Add-Type von '''+$File+''' abgeschlossen');
           #
          }
         catch
          {
           #
           if($_.InvocationInfo.ScriptLineNumber) { [String]$ScriptLineNumber = $('[Line: '+$_.InvocationInfo.ScriptLineNumber+']'); };
           if($_.CategoryInfo.Category)           { [String]$Category         = $('['+$_.CategoryInfo.Category+']');                 };
           if($_.Exception.Message)               { [String]$Message          = $('Message: '+$_.Exception.Message);                 };
           #
           Write-Warning -Message ($ScriptLineNumber+$Category+' Fehler bei Add-Type');
           Write-Warning -Message ($Message);
           #
           Exit;
           #
          };
         #
        };
       #
       Remove-Variable -Name Url;
       Remove-Variable -Name FindFile;
       Remove-Variable -Name Zip;
       Remove-Variable -Name UnZip;
       Remove-Variable -Name File;
       Remove-Variable -Name AddType;
       #
       Write-Verbose -Message (' ');
       #
      };
    #
    switch($Browser)
     {
      #
      'Chrome'
       {
        #
        Write-Verbose -Message 'Browser - Chrome';
        #
        $CheckBrowser = Get-Package -Name 'Google Chrome' -ErrorAction SilentlyContinue | select -First 1;
        #
        if(!$CheckBrowser)
         {
          #
          Write-Warning -Message ('Browser ''Google Chrome'' ist nicht installiert');
          Write-Warning -Message ('Abbruch!');
          #
          Exit;
          #
         }
          else
         {
          #
          Write-Verbose -Message 'Get-Package ''Google Chrome'' erfolgreich';
          #
         };
        #
        $CreateDefaultService = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService($WorkingDir);
        $CreateDefaultService.HideCommandPromptWindow = $True;
        #
        $SeleniumDriver = $Null;
        #
        if($BrowserOptions)
         {
          #
          $SeleniumDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver $CreateDefaultService,$BrowserOptions;
          #
         }
          else
         {
          #
          $SeleniumDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver $CreateDefaultService;
          #
         };
        #
       };
      #
      'Edge'
       {
        #
        Write-Verbose -Message 'Browser - Edge';
        #
        $CheckBrowser = Get-Package -Name 'Microsoft Edge' -ErrorAction SilentlyContinue | select -First 1;
        #
        if(!$CheckBrowser)
         {
          #
          Write-Warning -Message ('Browser ''Microsoft Edge'' ist nicht installiert');
          Write-Warning -Message ('Abbruch!');
          #
          Return;
          #
         }
          else
         {
          #
          Write-Verbose -Message 'Get-Package ''Microsoft Edge'' erfolgreich';
          #
         };
        #
       };
      #
      'Firefox'
       {
        #
        Write-Verbose -Message 'Browser - Firefox';
        #
        $CheckBrowser = Get-Package -Name 'Mozilla Firefox*' -ErrorAction SilentlyContinue | select -First 1;
        #
        if(!$CheckBrowser)
         {
          #
          Write-Warning -Message ('Browser ''Mozilla Firefox'' ist nicht installiert');
          Write-Warning -Message ('Abbruch!');
          #
          Return;
          #
         }
          else
         {
          #
          Write-Verbose -Message 'Get-Package ''Firefox'' erfolgreich';
          #
         };
        #
       };
      #
     };
    #
    Return $SeleniumDriver;
    #
   }
  End
   {
    #
    $Alle_Variablen = @(
                        #
                        'Browser'         ,
                        'BrowserOptions'  ,
                        'WorkingDir'      ,
                        'Downloads'       ,
                        #
                        'Alle_Variablen'
                        #
                       );
    #
    $Alle_Variablen |
     foreach `
      {
       #
       Remove-Variable -Name $_ -ErrorAction SilentlyContinue -Confirm:$False;
       #
      };
    #
    $Error.Clear();
    #
   };
  #
 };
#
$Browser = New-Selenium-Browser -Browser Chrome;
$Browser.Manage().Window.Position = '0,0';
$Browser.Manage().Window.Size = '1024,768';
#
$Browser.Url = 'about:blank';
$Browser.Navigate() | Out-Null;
#
Start-Sleep -Seconds 3;
#
Write-Host -Object ('Ende');
#
$Browser.Quit();
#
```

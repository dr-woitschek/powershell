#Requires -Version 5.0
#
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
#
$VerbosePreference = 'Continue';
$ErrorActionPreference = 'Stop';
#
Clear-Host;
#
function New-Selenium-Chrome
 {
  #
  [CmdletBinding(SupportsShouldProcess = $True,
                 HelpUri               = 'https://github.com/dr-woitschek/powershell/tree/main/',
                 ConfirmImpact         = 'High')]
  Param(
   [Parameter(Mandatory         = $False,
              ValueFromPipeline = $True,
              Position          = 0,
              HelpMessage       = 'Definiert das Arbeitsverzeichnis, oder Get-Help <Funktion> -Example')]
   [String]$WorkingDir,
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
              HelpMessage       = 'Definiert den Download-Ordner, oder Get-Help <Funktion> -Example')]
   [String]$PrefDownloadDirectory
   #
  );
  #
  Process
   {
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
    Write-Verbose -Message (' ');
    #
    if(!($WorkingDir))
     {
      #
      Write-Warning -Message ('WorkingDir nicht gesetzt!');
      #
      [String]$WorkingDir = ($env:TEMP+'\'+(Get-Random)+'-Selenium-Chrome-WorkingDir');
      #
      Write-Warning -Message ('WorkingDir gesetzt auf '''+$WorkingDir+'''');
      #
     }
      else
     {
      #
      Write-Verbose -Message ('WorkingDir gesetzt auf '+$WorkingDir);
      #
     };
    #
    Write-Verbose -Message (' ');
    #
    if(!(Test-Path -Path $WorkingDir))
     {
      #
      try
       {
        #
        New-Item -Path $WorkingDir    `
                 -ItemType directory  `
                 -ErrorAction Stop    | Out-Null;
        #
        Write-Verbose -Message ('WorkingDir '''+$WorkingDir+''' wurde erstellt');
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
     }
      else
     {
      #
      Write-Verbose -Message ('WorkingDir '''+$WorkingDir+''' vorhanden');
      #
     };
    #
    Write-Verbose -Message (' ');
    #
    try
     {
      #
      $Null = [System.Reflection.Assembly]::GetAssembly([OpenQA.Selenium.Chrome.ChromeDriverService]);
      #
      Write-Verbose -Message ('[OpenQA.Selenium.Chrome.ChromeDriverService] vorhanden');
      #
      [bool]$Load = $False;
      #
     }
    catch
     {
      #
      [bool]$Load = $True;
      #
     };
    #
    Write-Verbose -Message (' ');
    #
    if($Load)
     {
      #
      Write-Verbose -Message ('Assembly download/aktivieren');
      #
      [Array]$Downloads = @();
      [Array]$Downloads = @(
                            # 
                            ('https://www.nuget.org/api/v2/package/Newtonsoft.Json'                 , 'lib/net45/Newtonsoft.Json.dll'                , 'Add-Type') ,
                            ('https://www.nuget.org/api/v2/package/System.Drawing.Common'           , 'lib/netstandard2.0/System.Drawing.Common.dll' , 'Add-Type') ,
                            ('https://www.nuget.org/api/v2/package/Selenium.WebDriver'              , 'lib/netstandard2.0/WebDriver.dll'             , 'Add-Type') ,
                            ('https://www.nuget.org/api/v2/package/Selenium.Support'                , 'lib/netstandard2.0/WebDriver.Support.dll'     , 'Add-Type') ,
                            ('https://www.nuget.org/api/v2/package/Selenium.WebDriver.ChromeDriver' , 'driver/win32/chromedriver.exe'                , ''        )
                            #
                           );
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
         Write-Debug -Message ('Variable ''Url''........'''+$Url+'''');
         Write-Debug -Message ('Variable ''FindFile''...'''+$FindFile+'''');
         Write-Debug -Message ('Variable ''Zip''........'''+$Zip+'''');
         Write-Debug -Message ('Variable ''File''.......'''+$File+'''');
         Write-Debug -Message ('Variable ''UnZip''......'''+$UnZip+'''');
         Write-Debug -Message ('Variable ''AddType''....'''+$AddType+'''');
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
             Exit;
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
           try
            {
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
        };
      #
      #
     };
    #
    $CreateDefaultService = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService($WorkingDir);
    $CreateDefaultService.HideCommandPromptWindow = $True;
    #
    $SeleniumDriver = $Null;
    $ChromeOptions = $Null;
    #
    if($BrowserOptions -or $PrefDownloadDirectory)
     {
      #
      $ChromeOptions = New-Object OpenQA.Selenium.Chrome.ChromeOptions;
      #
     };
    #
    if($BrowserOptions)
     {
      #
      $ChromeOptions.AddArguments(@($BrowserOptions));
      #
     };
    #
    if($PrefDownloadDirectory)
     {
      #
      if(!(Test-Path -Path $WorkingDir))
       {
        #
        try
         {
          #
          New-Item -Path $PrefDownloadDirectory  `
                   -ItemType directory           `
                   -ErrorAction Stop             | Out-Null;
          #
          Write-Verbose -Message ('Download-Ordner '''+$PrefDownloadDirectory+''' wurde erstellt');
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
       }
        else
       {
        #
        Write-Verbose -Message ('Download-Ordner '''+$PrefDownloadDirectory+''' vorhanden');
        #
       };
      #
      $ChromeOptions.AddUserProfilePreference('download', @{
                                                            #
                                                            'default_directory'   = $PrefDownloadDirectory;
                                                            'prompt_for_download' = $False;
                                                            #
                                                            });
      #
     };
    #
    if($BrowserOptions -or $PrefDownloadDirectory)
     {
      #
      $SeleniumDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver $CreateDefaultService,$ChromeOptions;
      #
     }
      else
     {
      #
      $SeleniumDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver $CreateDefaultService;
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
                        'CheckBrowser'           ,
                        'WorkingDir'             ,
                        #
                        'ScriptLineNumber'       ,
                        'Category'               ,
                        'Message'                ,
                        #
                        'Load'                   ,
                        'Downloads'              ,
                        #
                        'Url'                    ,
                        'FindFile'               ,
                        'Zip'                    ,
                        'File'                   ,
                        'UnZip'                  ,
                        'AddType'                ,
                        #
                        'CreateDefaultService'   ,
                        #
                        'SeleniumDriver'         ,
                        'BrowserOptions'         ,
                        'PrefDownloadDirectory'  ,
                        'ChromeOptions'          ,
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
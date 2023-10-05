**Software Restriction Policy - für Benutzer schreibbare Verzeichnisse im Laufwerk C:\ finden:**

```
Clear-Host;
#
$ErrorActionPreference = 'SilentlyContinue';
#
[String]$executableFilename = 'SRP_TESTING.cmd';
[String]$Path = 'C:\';
#
Get-ChildItem -Path $Path -Recurse -Force |
 Where-Object { $_.PSIsContainer } |
  ForEach-Object `
   {
    #
    $currentFolder = $_.Fullname;
    $executableFilepath = (Join-Path $currentFolder $executableFilename);
    #
    # Datei mit Inhalt erstellen.
    New-Item -Path $executableFilepath -ItemType File -Value '@echo off' | Out-Null;
    #
    if($?)
     {
      #
      # Mehr Rechte für die neue Datei
      $Rule = New-Object System.Security.AccessControl.FileSystemAccessRule ('BUILTIN\Users' , 'ExecuteFile' , 'Allow');
      $ACL = Get-ACL -Path $executableFilepath;
      $ACL.AddAccessRule($Rule);
      #
      Set-ACL -Path $executableFilepath -AclObject $ACL;
      #
      # Datei ausführen
      & $executableFilepath;
      #
      if($?)
       {
        #
        Write-Host -Object $('-> '+$currentFolder) -BackgroundColor Red;
        #
       };
      #
      # Angelegte Datei wieder löschen
      Remove-Item -Path $executableFilepath;
      #
      Remove-Variable -Name Rule;
      Remove-Variable -Name ACL;
      #
     };
    #
    Remove-Variable -Name currentFolder;
    Remove-Variable -Name executableFilepath;
    #
  };
#
Remove-Variable -Name Path;
Remove-Variable -Name executableFilename;
#
```

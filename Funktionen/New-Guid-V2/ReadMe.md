
**Erstellt eine GUID mit Prefix**

```
#
function New-Guid-V2()
 {
  #
  [CmdletBinding(SupportsShouldProcess = $True,
                 HelpUri               = 'https://github.com/dr-woitschek/powershell/tree/main/',
                 ConfirmImpact         = 'High')]
  Param(
   [Parameter(Mandatory         = $False,
              ValueFromPipeline = $True,
              Position          = 0,
              HelpMessage       = 'Definiert die ersten Zeichen der GUID, oder Get-Help <Funktion> -Example')]
   [ValidateNotNullOrEmpty()]
   [ValidateNotNull()]
   [ValidatePattern('^0?[xX]?[0-9a-fA-F]*$')]
   [String]$Prefix
   #
  );
  #
  Process
   {
    #
    [String]$GUID = $Prefix + [system.guid]::NewGuid().ToString().Substring($Prefix.Length);
    #
    if([guid]::TryParse($GUID, $([ref][guid]::Empty)))
     {
      #
      Return '{'+$GUID+'}';
      #
     }
      else
     {
      #
      Return $False;
      #
     };
    #
   }
  End
   {
    #
    $Alle_Variablen = @(
                        #
                        'Prefix'       ,
                        'GUID'         ,
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

```

Ausgabe:

<img src="https://github.com/dr-woitschek/powershell/blob/main/Funktionen/New-Guid-V2/Ausgabe.jpg">

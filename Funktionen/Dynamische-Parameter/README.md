
.Synopsis ```Erstellen eines dynamischen Parameters für Funktionen```

.DESCRIPTION ```Der Funktionsaufruf muss mit dem Parameter -Name und -ValidateSet aufgerufen werden.```

.EXAMPLE

```

function Test-Woitschek
 {
  [CmdletBinding()]
  Param()
  DynamicParam
   {
    $DynamoOption = @( Get-ChildItem -Path 'C:\Program Files' |
     Select-Object -ExpandProperty Fullname );
    New-Dynamo-Parameter -Name Value `
                         -ValidateSet $DynamoOption `
                         -Mandatory;
   }
  Begin
   {
    $Value = $PSBoundParameters.rad;
   }
  Process
   {
    Write-Host -Object $('Value: '''+$Value+'''')
   }
  End
   {
   };
 };
#
Test-Woitschek -Value <Tab>

```

.EXAMPLE

```

...
DynamicParam
 {
  $DynamoOption = @( Get-WmiObject -Class Win32_Volume |
                      ForEach-Object { $_.Driveletter } | Sort; );
  New-Dynamo-Parameter -Name Laufwerk `
                       -ValidateSet $DynamoOption `
                       -Mandatory;
 }
begin
 {
  $Laufwerk = $PSBoundParameters.Laufwerk;
 }
...

```

.PARAMETER Name ```Namen eingeben```

.PARAMETER Type
 Type der Variable festlegen
 - [int]
 - [long]
 - [string]
 - [char]
 - [byte]
 - [bool]
 - [decimal]
 - [single]
 - [double]
 - [xml]
 - [array]
 - [hashtable]
   etc.

.PARAMETER Alias ```Legt einen alternativen Namen für den Parameter fest```

.PARAMETER ValidateSet ```Legt fest, welche exakten Werte (Case insensitiv) ein Argument annehmen darf```

.PARAMETER Mandatory ```Legt fest, der der Parameter NICHT optional ist```

.PARAMETER ParameterSetName ```Legt fest, ob eine Parametergruppe angelegt werden soll```

.PARAMETER Position ```Legt fest, welche Position der Parameter haben soll```

.PARAMETER ValueFromPipelineByPropertyName ```Enthält das eintreffende Objekt eine Eigenschaft vom passenden Datentyp und heißt die Eigenschaft so wie der Parameter, wird der Inhalt dieser Eigenschaft an den Parameter gebunden.```

.PARAMETER HelpMessage ```Angabe eines Hilfetextes zum Parameter```

.INPUTS ```Neues-Dynamo -Name <Name> -ValidateSet <ValidateSet>```

.OUTPUTS ```Dynamischer Parameter```

.NOTES

```

Version: 0.1
Creation Date: 06.02.2020
Author: Woitschek

```

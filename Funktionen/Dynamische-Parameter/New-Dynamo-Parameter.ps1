Clear-Host;
#
function New-Dynamo-Parameter
 {
  #
 <#
  .Synopsis
     Erstellen eines dynamischen Parameters für Funktionen
  .DESCRIPTION
     Der Funktionsaufruf muss mit dem Parameter -Name und -ValidateSet aufgerufen werden.
  .EXAMPLE
     #
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
  .EXAMPLE
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
  .PARAMETER Name
     Namen eingeben
  .PARAMETER Type
     Type der Variable festlegen
      [int]
      [long]
      [string]
      [char]
      [byte]
      [bool]
      [decimal]
      [single]
      [double]
      [xml]
      [array]
      [hashtable]
      etc.
  .PARAMETER Alias
     Legt einen alternativen Namen für den Parameter fest
  .PARAMETER ValidateSet
     Legt fest, welche exakten Werte (Case insensitiv) ein Argument annehmen darf
  .PARAMETER Mandatory
     Legt fest, der der Parameter NICHT optional ist
  .PARAMETER ParameterSetName
     Legt fest, ob eine Parametergruppe angelegt werden soll
  .PARAMETER Position
     Legt fest, welche Position der Parameter haben soll
  .PARAMETER ValueFromPipelineByPropertyName
     Enthält das eintreffende Objekt eine Eigenschaft vom passenden Datentyp und heißt
     die Eigenschaft so wie der Parameter, wird der Inhalt dieser Eigenschaft an den
     Parameter gebunden.
  .PARAMETER HelpMessage
     Angabe eines Hilfetextes zum Parameter
  .INPUTS
     Neues-Dynamo -Name <Name> -ValidateSet <ValidateSet>
  .OUTPUTS
     Dynamischer Parameter
  .NOTES
     Version:        0.1
     Creation Date:  06.02.2020
     Author:         Woitschek
  .LINK
     https://github.com/dr-woitschek/powershell
  #>
  #
  Param(
   [Parameter(Mandatory         = $True  ,
              ValueFromPipeline = $True  ,
              Position          = 0      ,
              HelpMessage       = 'Namen eingeben, oder Get-Help <Funktion> -Example')]
   [ValidateNotNullOrEmpty()]
   [String]$Name,
   #
   [Parameter(Mandatory         = $False ,
              ValueFromPipeline = $True  ,
              HelpMessage       = 'Type festlegen, oder Get-Help <Funktion> -Example')]
   [System.Type]$Type           = [String],
   #
   [Parameter(Mandatory         = $False ,
              ValueFromPipeline = $True  ,
              HelpMessage       = 'Legt einen alternativen Namen für den Parameter fest, oder Get-Help <Funktion> -Example')]
   [string[]]$Alias               = @(),
   #
   [Parameter(Mandatory         = $True  ,
              ValueFromPipeline = $True  ,
              HelpMessage       = 'Legt fest, welche exakten Werte (Case insensitiv) ein Argument annehmen darf, oder Get-Help <Funktion> -Example')]
   [string[]]$ValidateSet,
   #
   [Parameter(Mandatory         = $False ,
              ValueFromPipeline = $True  ,
              HelpMessage       = 'Legt fest, der der Parameter NICHT optional ist, oder Get-Help <Funktion> -Example')]
   [Switch]$Mandatory,
   #
   [Parameter(Mandatory         = $False ,
              ValueFromPipeline = $True  ,
              HelpMessage       = 'Legt fest, ob eine Parametergruppe angelegt werden soll, oder Get-Help <Funktion> -Example')]
   [String]$ParameterSetName    = '__AllParameterSets',
   #
   [Parameter(Mandatory         = $False ,
              ValueFromPipeline = $True  ,
              HelpMessage       = 'Legt fest, welche Position der Parameter haben soll, oder Get-Help <Funktion> -Example')]
   [Int]$Position,
   #
   [Parameter(Mandatory         = $False ,
              ValueFromPipeline = $True  ,
              HelpMessage       = 'Enthält das eintreffende Objekt eine Eigenschaft vom passenden Datentyp und heißt die Eigenschaft so wie der Parameter, wird der Inhalt dieser Eigenschaft an den Parameter gebunden.')]
   [Switch]$ValueFromPipelineByPropertyName,
   #
   [Parameter(Mandatory         = $False ,
              ValueFromPipeline = $True  ,
              HelpMessage       = 'Angabe eines Hilfetextes zum Parameter, oder Get-Help <Funktion> -Example')]
   [String]$HelpMessage,
   #
   [validatescript( { if(-not ($_ -is [System.Management.Automation.RuntimeDefinedParameterDictionary] -or -not $_)) { Throw 'DPDictionary must be a System.Management.Automation.RuntimeDefinedParameterDictionary object, or not exist'; }; $True; } )]
   $DPDictionary = $False
   #
  )
  #
  Begin
   {
    #
    $ParamAttr = New-Object System.Management.Automation.ParameterAttribute;
    $ParamAttr.ParameterSetName = $ParameterSetName;
    #
   }
  Process
   {
    #
    #
    if($Mandatory)                       { $ParamAttr.Mandatory = $True;                       };
    #
    if($Position -ne $null)              { $ParamAttr.Position = $Position;                    };
    #
    if($ValueFromPipelineByPropertyName) { $ParamAttr.ValueFromPipelineByPropertyName = $True; };
    #
    if($HelpMessage)                     { $ParamAttr.HelpMessage = $HelpMessage;              };
    #
    $AttributeCollection = New-Object 'Collections.ObjectModel.Collection[System.Attribute]';
    $AttributeCollection.Add($ParamAttr);
    #
    if($ValidateSet)
     {
      #
      $ParamOptions = New-Object System.Management.Automation.ValidateSetAttribute -ArgumentList $ValidateSet;
      $AttributeCollection.Add($ParamOptions);
      #
     };
    #
    if($Alias.count -gt 0)
     {
      #
      $ParamAlias = New-Object System.Management.Automation.AliasAttribute -ArgumentList $Alias;
      $AttributeCollection.Add($ParamAlias);
      #
     };
    #
    # Dynamischen Parameter erstellen
    $Parameter = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList @($Name, $Type, $AttributeCollection);
    #
    # Dynamischen Parameter zum RuntimeDefinedParameterDictionary hinzufügen, sollte es keins geben dann erstelle eins
    if($DPDictionary)
     {
      #
      $DPDictionary.Add($Name, $Parameter);
      #
     }
      else
     {
      #
      $Dictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary;
      $Dictionary.Add($Name, $Parameter);
      $Dictionary;
      #
     };
    #
    $Alle_Variablen = @(
                        #
                        'Name'                             ,
                        'Type'                             ,
                        'Alias'                            ,
                        'ValidateSet'                      ,
                        'Mandatory'                        ,
                        'ParameterSetName'                 ,
                        'Position'                         ,
                        'ValueFromPipelineByPropertyName'  ,
                        'HelpMessage'                      ,
                        'DPDictionary'                     ,
                        'ParamAttr'                        ,
                        'AttributeCollection'              ,
                        'ParamOptions'                     ,
                        'ParamAlias'                       ,
                        'Parameter'                        ,
                        #
                        'Alle_Variablen'
                        #
                       );
    #
    $Alle_Variablen |
     foreach `
      {
       #
       Remove-Variable -Name $_ -ErrorAction SilentlyContinue;
       #
      };
    #
   }
  End
   {
    #
   };
  #
 };
#
# Get-Help New-Dynamo-Parameter -Full;
#
# ------------------------------------------------------------------------------------------------------------------ #
#
function Test-Woitschek
 {
  #
  [CmdletBinding()]
  Param()
  DynamicParam
   {
    #
    $DynamoOption = @( Get-ChildItem -Path 'C:\Program Files' |
     Select-Object -ExpandProperty Fullname );
    #
    New-Dynamo-Parameter -Name Value -ValidateSet $DynamoOption -Mandatory;
    #
   }
  Begin
   {
    #
    $Value = $PSBoundParameters.Value;
    #
   }
  Process
   {
    #
    Write-Host -Object $('Value: '''+$Value+'''')
    #
   }
  End
   {
    #
    $Alle_Variablen = @(
                        #
                        'DynamoOption'   ,
                        'Value'          ,
                        #
                        'Alle_Variablen'
                        #
                       );
    #
    $Alle_Variablen |
     foreach `
      {
       #
       Remove-Variable -Name $_ -ErrorAction SilentlyContinue;
       #
      };
    #
   };
  #
 };
#
# Get-Help Test-Woitschek
Test-Woitschek -Value 'C:\Program Files\Windows Defender'
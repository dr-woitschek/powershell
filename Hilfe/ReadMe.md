**Powershell Hilfe Sammlung**

---

## Function - Param

| Parameter | Beschreibung |
| --------- | ------------ |
| [Parameter()] Mandatory = $True          | Parameter ist NICHT optional ist (=True)                                                                                                                                                                                                  |
| [Parameter()] ValueFromPipeline = $True  | Legt fest, dass der Parameter Argumente von der Pipeline akzeptiert                                                                                                                                                                       |
| [Parameter()] Position = 0               | Definiert, dass Argumente auch ohne Parameternamen übergeben werden können und legt die Nummer der Position für das Argument fest                                                                                                         |
| [Parameter()] HelpMessage = 'Hilfe Text' | kurze Hilfe für den Parameter                                                                                                                                                                                                             |
| [ValidateNotNullOrEmpty()]               | Legt fest, dass das Argument weder Null noch leer sein darf                                                                                                                                                                               |
| [ValidateNotNull()]                      | Legt fest, dass der Wert des Argumentes nicht Null sein darf                                                                                                                                                                              |
| [ValidateCount(0,1)]                     | Definiert für einen nicht optionalen Parameter die minimale und die maximale Anzahl von Argumenten, welche an den Parameter gebunden werden können                                                                                        |
| [ValidateLength(4,5)]                    | Definiert für einen nicht optionalen Parameter die minimale und die maximale Stringlänge                                                                                                                                                  |
| [ValidateSet('Vorgabe_A' , 'Vorgabe_B')] | Legt fest, welche exakten Werte (Case insensitiv) ein Argument annehmen darf                                                                                                                                                              |
| [ValidateScript( { $_ -lt 4 } )]         | Definiert ein Skriptblock zur Validierung des Argumentes. Es wird ein Fehler generiert, wenn das Ergebnis nicht $True ist oder wenn der Code einen Laufzeitfehler erzeugt. Die automatische Variable $_ steht für das übergebene Argument |
| [ValidateRange(0,10)]                    | Legt die Unter- und Obergrenze für das Argument fest                                                                                                                                                                                      |
| [ValidatePattern('[0-9][0-9][0-9]')]     | Definiert mit Hilfe einer Regular Expression ein Muster, dem das Argument entsprechen muss                                                                                                                                                |
| [Alias('AndererName')]                   | Legt einen alternativen Namen für den Parameter fest                                                                                                                                                                                      |
| [String]$Variabe                         | Parameter-Name                                                                                                                                                                                                                            |

---

## Variablen

| Variable        | Beschreibung                           |
| --------------- | -------------------------------------- |
| [int]$var       | 32-bit integer mit Vorzeichen          |
| [long]$var      | 64-bit integer mit Vorzeichen          |
| [string]$var    | string mit unicode characters          |
| [char]$var      | A unicode 16-bit character             |
| [byte]$var      | 8-bit Zahl                             |
| [bool]$var      | Boolean True/False                     |
| [decimal]$var   | 128-bit Dezimalzahl                    |
| [single]$var    | Single-precision 32-bit Fließkommazahl |
| [double]$var    | Double-precision 64-bit Fließkommazahl |
| [xml]$var       | Xml object                             |
| [array]$var     | Array                                  |
| [hashtable]$var | Hashtabelle                            |

---

## Vergleichsoperatoren

| Operator | Beschreibung        |
| -------- | ------------------- |
| -eq      | gleich              |
| -ne      | ungleich            |
| -lt      | kleiner             |
| -le      | kleiner oder gleich |
| -gt      | größer              |
| -ge      | größer oder gleich  |

---

**Sprachausgabe ansteuern:**

```
#Requires -RunAsAdministrator
#Requires -Version 5.0
#
Clear-Host;
#
Add-Type -AssemblyName System.Speech;
#
$Speak      = New-Object System.Speech.Synthesis.SpeechSynthesizer;
$Speak.Rate = 1;
#
# Installierte Stimmen ausgeben:
#  $Speak.GetInstalledVoices().VoiceInfo;
#
#  'Microsoft Zira Desktop'  -> Culture : en-US
#  'Microsoft Hedda Desktop' -> Culture : de-DE
#
$Speak.SelectVoice('Microsoft Hedda Desktop');
#
$Speak.Speak('Hallo Welt!');
#
$Speak.State;
#
Remove-Variable -Name Speak;
```
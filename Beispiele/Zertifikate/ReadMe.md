**Aufgelaufene Zertifikate auslesen:**

```
Clear-Host;
#
[Array]$Certs = @();
#
[Int]$Tage = 7;
#
[String]$Path = 'Cert:\LocalMachine\My';
#
Get-ChildItem -Path $Path -ErrorAction Stop |
 ForEach-Object `
  {
   #
   $myHashtable = New-Object PSObject;
   $myHashtable | Add-Member -Type NoteProperty -Name 'Name'             -Value $($_.Subject);
   $myHashtable | Add-Member -Type NoteProperty -Name 'Aussteller'       -Value $($_.Issuer);
   $myHashtable | Add-Member -Type NoteProperty -Name 'Seriennummer'     -Value $($_.SerialNumber);
   #
   if($_.NotAfter -lt $(Get-Date).AddDays($Tage))
    {
     #
     $myHashtable | Add-Member -Type NoteProperty -Name 'Abgelaufen'     -Value $('Ja');
     #
    }
     else
    {
     #
     $myHashtable | Add-Member -Type NoteProperty -Name 'Abgelaufen'     -Value $('Nein');
     #
    };
   #
   $myHashtable | Add-Member -Type NoteProperty -Name 'AusgestelltAm'    -Value $($_.NotBefore.ToShortDateString()+' '+$_.NotBefore.ToShortTimeString());
   $myHashtable | Add-Member -Type NoteProperty -Name 'GueltigBis'       -Value $($_.NotAfter.ToShortDateString()+' '+$_.NotAfter.ToShortTimeString());
   $myHashtable | Add-Member -Type NoteProperty -Name 'Fingerabdruck'    -Value $($_.Thumbprint);
   $myHashtable | Add-Member -Type NoteProperty -Name 'Verwendungszweck' -Value $($_.EnhancedKeyUsageList);
   #
   [Array]$Certs += $myHashtable;
   #
   Remove-Variable -Name myHashtable;
   #
  };
#
[Array]$Certs | Format-List;
#
Remove-Variable -Name Certs;
Remove-Variable -Name Tage;
Remove-Variable -Name Path;
#
```

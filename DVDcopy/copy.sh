#!/bin/bash

#schritt1: Admin-Rechte einholen
kdesudo --caption "für Root Rechte" -u root  --comment "Bitte Passwort eingeben um Exclusivzugriff auf das DVD-Laufwerk zu erhalten" sudo /bin/echo "Root Passwort eingeben"
if [[ $? -ne 0 ]]; then
kdialog --error "Drei mal falsches Passwort. Abgebrochen"
exit 1
fi

#schritt2: auf eingelegte DVD prüfen
if  ! grep -q '/dev/sr0' /etc/mtab > /dev/null 2>&1; then 
kdialog --caption "Keine Disk" --error "Keine CD oder DVD im Laufwerk! Abbruch..."
exit 2
fi

#schritt3: Speicherort für Iso erfragen
filename="$(kdialog --caption 'Bitte DVD Name (mit Endung .iso) angeben' --getsavefilename ~ "*.iso")"
if [[ $? -ne 0 ]]; then
kdialog --caption "Abgebrochen" --sorry "Abgebrochen durch Benutzerwunsch"
exit 3
fi

#schritt4: check ob Dateiname auf .iso endet
echo "$filename" | grep '.iso$'
if [[ $? -ne 0 ]]; then
  #tut er nicht, anhängen
  filename="$filname.iso"
  kdialog --caption "Problem Dateiendung" --warningcontinuecancel "Der gewählte Dateiname zum Speichern endet nicht auf .iso, es wurde ein daher .iso als Dateiendung angehängt. Der neue Speicherpfad lautet: $filename"
  if [[ $? -ne 0 ]]; then
    kdialog --caption "Abgebrochen" --sorry "Abgebrochen durch Benutzerwunsch"
    exit 4
  fi
fi

#schritt5: ermitteln der Disk-Größe
disksize=$(blockdev --getsize64 /dev/sr0)


#schritt6: erzeugen des Kopierdialoges mit Progressbar
dbusRef=$(kdialog --caption "läuft im Hintergrund" --title "Kopiervorgang" --progressbar "Die Disc wird im Hintergrund nach $filename kopiert." 100)

#schritt7:
#cdlaufwerk als root einleisen
#an programm "pv" pipen
#dort mittels Parameter -n den bereits erhaltenen Prozentwert der $disksize ermitteln und in &3 speichern
#stdout ist das mittels dd eingelesen, dies wird weiter gepiped an dd zum ausgeben als datei
# &3 wird zum stdout und weitergepiped an xargs und als qdbus %-Wert für den Progressbar genommen
sudo dd if=/dev/sr0 | { pv -s $disksize -n 2>&3 | dd  of="$filename"; } 3>&1 |  xargs -I{} qdbus $dbusRef Set org.kde.kdialog.ProgressDialog value {}

#schritt8: Fortschrittsanzeige wieder schließen
qdbus $dbusRef org.kde.kdialog.ProgressDialog.close

#schritt9: Benachrichtigen des Users und Frage nach Auswerfen
kdialog --caption "Disk auswerfen?" --title "Kopieren beendet" -yesno "Der Kopiervorgang ist beendet. Disc auswerfen?"
if [[ $? = 0 ]]; then
  sudo umount /dev/sr0
  sudo eject /dev/sr0
fi

exit 0

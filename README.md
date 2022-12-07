# ftibackup
<h1>Backup-Skript</h1>
<h2>Einführung</h2>
<p>Als Einführung in die Bash-Programmierung verwenden wir drei Befehle, deren Optionen und Parameter mit Eingaben definiert werden sollen:</p>
<ul>
  <li>tar cfz /tmp/backup.tgz /home</li>
  <li>tar tf /tmp/backup.tgz</li>
  <li>tar xfz /tmp/backup.tgz /home</li>
</ul>

<p>Dazu wird zuerst eine Endlosschliefe als Ereignissteuerung implemtiert. Diese ruft ein Menü aur, welches dann in die Unterfunktionen verzweigt. Diese Unterfunktionen sind wieder nur dafür da, Ausgaben mit erklärendem Inhalt auszugeben und dann entsprechend die Eingabe zu bewerkstelligen. Sind die Eingaben alle erfolgreich absolviert, so werden die Befehle ausgeführt und danach in das Menü zurückgekehrt.</p>



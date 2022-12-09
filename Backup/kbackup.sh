#!/bin/bash

# Author: Martin Rösner
# Mailadresse: roesner@elektronikschule.de
# Licence: GNUv2
# Version: v0.1

while : 
do


	TODO=$(kdialog --menu "Backup - Menü"  1 "Backup" 2 "Unbackup" 3 "Backupinhalt auflisten")

	BACKUPFILE=$(date +%Y%m%d-%H%M%S)"-backup"

	if [ $TODO = 1 ]; then
        	# Kompimierungsmethode: -j: bzip2; -J: xz; -z: zip
	        YESNO=1
        	until [ $YESNO = 0 ]
	        do
        	        METHODE=$(kdialog --radiolist "Methode" 1 ZIP 1 2 BZIP2 0 3 XZ 0)
                	case $METHODE in
				1)
					OPTION=" cfz "
					SUFFIX=".tgz"
					M="GZIP"
				;;
				2)
					OPTION=" cfj "
					SUFFIX=".bzip2"
					M="BZIP2"
				;;
				3)
					OPTION=" cfJ "
					SUFFIX=".xz"
					M="XZ"
				;;
				*)
        				echo -e "An unexpected error has occurred."
		        		exit
    				;;
			esac
			kdialog  --yesno "Komprimierungsmethode ist: \n-> ${M}"
        	        YESNO=$?
	        done

		# Was soll gebackuped werden?
		YESNO=1
		until [ $YESNO = 0 ]
		do
			BACKUPPFAD=$(kdialog --getexistingdirectory /home)
			kdialog --yesno "Diesen Pfad sichern?\n-> $BACKUPPFAD" 
			YESNO=$?
		done

		# Backuppfad auswählen
		YESNO=1
		until [ $YESNO = 0 ]
		do
			BACKUP=$(kdialog --getexistingdirectory /)
			kdialog --yesno "Backup hier erstellen?\n-> ${BACKUP}/${BACKUPFILE}${SUFFIX}" 
			YESNO=$?
		done

		COMMAND="tar ${OPTION} ${BACKUP}/${BACKUPFILE}${SUFFIX} ${BACKUPPFAD}"
		dialog --prgbox "Backup wird gestartet" "${COMMAND}" 10 50
		dialog --msgbox "Backup ist fertig." 5 30

	elif [ $TODO = 2 ]; then
		echo "Unbackup"

	elif [ $TODO = 3 ]; then
		# Backupdatei auswählen
		YESNO=1
        	until [ $YESNO = 0 ]
	        do
        	        BACKUPFILE=$(dialog --stdout --fselect / 10 10)
                	dialog --stdout --yesno "Ist das die richtige Backupdatei?\n-> ${BACKUPFILE}" 7 70
	                YESNO=$?
        	done

		COMMAND="tar --list -f ${BACKUPFILE}"	
		dialog --prgbox "Inhalt von ${BACKUPFILE} wird angezeigt" "${COMMAND}" 30 70

	else
		exit 1
	fi

done
exit 0

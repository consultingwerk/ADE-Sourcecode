/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-a-ger.p - German language definitions for Admin module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/*results.p,s-module.p*/
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'A. Abfrage'
    qbf-lang[ 2] = 'B. Bericht'
    qbf-lang[ 3] = 'E. Etikett'
    qbf-lang[ 4] = 'D. Datenexport'
    qbf-lang[ 5] = 'P. Sonst. Programme'
    qbf-lang[ 6] = 'S. Systemverwaltung'
    qbf-lang[ 7] = 'V. Verlassen/Ende'
    qbf-lang[ 8] = 'F. FAST TRACK'
    qbf-lang[10] = 'Die Datei' /*DBNAME.qc*/
    qbf-lang[11] = 'ist nicht vorhanden. Sie mu� EINMAL angelegt werden, bevor '
		 + 'Ihre Datenbank mit RESULTS arbeiten kann. Soll das JETZT '
		 + 'getan werden?'
   qbf-lang[12] = 'Men�punkt ausw�hlen oder weiter mit [' + KBLABEL("END-ERROR")
		 + '] im aktuellen Modul.'
    qbf-lang[13] = 'Sie besitzen keine Lizenz f�r RESULTS. Das Programm ist '
		 + 'beendet.'
    qbf-lang[14] = 'Sind Sie sicher, da� Sie "~{1~}" jetzt verlassen wollen?'
    qbf-lang[15] = 'MANUELL,HALBAUTO,AUTOMAT'
    qbf-lang[16] = 'Es ist keine Datenbank aktiv!'
   qbf-lang[17] = 'Das Programm kann nicht ausgef�hrt werden, wenn der logische'
		 + ' Datenbankname mit "QBF$" anf�ngt.'
    qbf-lang[18] = 'Abbruch'
    qbf-lang[19] = '** RESULTS kann nicht starten **^^Im Verzeichnis '
		 + '~{1~} ist weder '
		 + '~{2~}.db noch ~{2~}.qc vorhanden. ~{3~}.qc ist zwar im'
		 + 'PROPATH angegeben, geh�rt aber scheinbar zu ~{3~}.db.'
		 + 'Bitte passen Sie PROPATH an oder l�schen Sie ~{3~}.db und'
		 + '.qc (Statt L�schen ist auch Umbenennen m�glich.)'
    /* 24,26,30,32 available if necessary */
    qbf-lang[21] = '         Es gibt drei M�glichkeiten, Abfragemasken f�r '
		 + 'PROGRESS'
    qbf-lang[22] = '         RESULTS zu erstellen. Jede Maske, die mit '
		 + 'RESULTS er- '
    qbf-lang[23] = '         stellt wurde, kann nachtr�glich ge�ndert werden.'
    qbf-lang[25] = 'Sie m�chten jede Abfragemaske selbst erstellen.'
    qbf-lang[27] = 'Nachdem Sie einige Dateien aus Ihrer Datenbank ausge-'
    qbf-lang[28] = 'w�hlt haben, erstellt RESULTS f�r genau diese  '
    qbf-lang[29] = 'Dateien Abfragemasken.'
    qbf-lang[31] = 'RESULTS erzeugt alle Abfragemasken automatisch.'.


/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-user.p*/
IF qbf-s = 2 THEN
  /* format x(72) for 1,2,9-14,19-22 */
  ASSIGN
    qbf-lang[ 1] = 'Bitte geben Sie den Namen f�r die Include-Datei an, die f�r'
    qbf-lang[ 2] = 'die Suchlistenoption im Abfragemodul verwendet werden soll.'
    qbf-lang[ 3] = ' Standard Include-Datei:' /*format x(24)*/

    qbf-lang[ 8] = 'Das Programm ist nicht vorhanden:'

    qbf-lang[ 9] = 'Geben Sie den Namen f�r das Startprogramm ein. Das Programm'
		 + ' kann ein'
    qbf-lang[10] = 'einfaches Logo sein oder eine komplette login-Prozedur'
		 + ' wie z.B. "login.p"'
    qbf-lang[11] = 'im DLC-Verzeichnis. Das Programm wird ausgef�hrt, sobald '
		 + 'die Zeile'
    qbf-lang[12] = ' "signon=" in der Datei DBNAME.qc gelesen wird.'
    qbf-lang[13] = 'Geben Sie bitte den Produktnamen ein, der in den'
    qbf-lang[14] = 'Men�s angezeigt werden soll.'
    qbf-lang[15] = '           Startprogramm:' /*format x(24)*/
    qbf-lang[16] = '            Produktname:' /*format x(24)*/
    qbf-lang[17] = 'Standardvorgabe:'

    qbf-lang[18] = 'Name Ihres PROGRESS Programms:'
    qbf-lang[19] = 'Ausf�hrung des Programms, sobald die Option "sonst. Pro'
		 + 'gramme" aufgerufen wird.'

    qbf-lang[20] = 'Hier k�nnen Sie ein selbsterstelltes Export-Programm '
		 + 'einbinden.'
    qbf-lang[21] = 'Bitte geben Sie den Programmnamen und die Beschreibung'
    qbf-lang[22] = 'f�r die Verwendung im Men� "Datenexport - Typ" an.'
    qbf-lang[23] = 'Programm:'
    qbf-lang[24] = 'Beschreibung:'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-load.p:*/
IF qbf-s = 3 THEN
  ASSIGN
    /* menu strip for d-main.p,l-main.p,r-main.p */
    qbf-lang[ 1] = 'Hole,L�dt gespeicherte Vorlagen f�r ~{1~}.'
    qbf-lang[ 2] = 'Ableg,Sichern der aktuellen ~{1~}.'
    qbf-lang[ 3] = 'Tun,Ausf�hren der aktuellen ~{1~}.'
    qbf-lang[ 4] = 'Definier,Auswahl von Dateien und Feldern.'
    qbf-lang[ 5] = 'Param,�ndern der aktuellen Layout Parameter f�r ~{1~}.'
    qbf-lang[ 6] = 'Wobei,Bedingungen f�r die Selektion von Datens�tzen.'
    qbf-lang[ 7] = 'Order,�ndert die Reihenfolge der Ausgabe von Datens�tzen.'
    qbf-lang[ 8] = 'L�sch,L�scht die aktuellen ~{1~}.'
    qbf-lang[ 9] = 'Info,Information �ber aktuelle Standardeinstellungen.'
    qbf-lang[10] = 'Modul,Wechseln zu einem anderen Modul.'
    qbf-lang[11] = 'Sonst,Aufruf eines in RESULTS eingebundenen Programms.'
    qbf-lang[12] = 'Ende,Zur�ck zum vorherigen Men�.'
    qbf-lang[13] = '' /* terminator */
    qbf-lang[14] = 'Exportdaten,Etiketten,Berichte'

    qbf-lang[15] = 'Die Konfigurationsdatei wird gelesen ...'

    /* system values for CONTINUE Must be <= 12 characters */
    qbf-lang[18] = ' Abbruch...' /* for error dialog box */
    qbf-lang[19] = 'Deutsch' /* this name of this language */
    /* word "of" for "xxx of yyy" on scrolling lists */
    qbf-lang[20] = 'von'
    /* standard product name */
    qbf-lang[22] = 'PROGRESS RESULTS'
    /* system values for descriptions of calc fields */
    qbf-lang[23] = ',Gesamtsumme,Gesamtprozent,Anzahl,Textbegriff,'
		 + 'Datumsausdruck,Nummerischer Ausdruck,Logischer'
		 + ' Ausdruck,Listenelemente'
    /* system values for YES and NO.  Must be <= 8 characters each */
    qbf-lang[24] = '  Ja   ,  Nein  ' /* for yes/no dialog box */

    qbf-lang[25] = 'Die automatische Erstellung wurde unterbrochen.  '
		 + 'Soll jetzt damit weitergemacht werden?'

    qbf-lang[26] = '* ACHTUNG - die Versionsnummer stimmt nicht! *^^Die '
     + 'aktuelle Version ist <~{1~}>. Die .qc-Datei ist f�r Version <~{2~}>. '
		 + 'Es kann zu Problemen kommen, wenn Ihre Abfragemasken nicht '
		 + 'mit "Applikation �berarbeiten" im Men� Systemverwaltung '
		 + 'angepa�t worden sind.'

    qbf-lang[27] = '* ACHTUNG - Es fehlen Datenbanken! *^^Nachfolgende '
		 + 'Datenbanken werden ben�tigt, sind aber nicht gestartet:'

    qbf-lang[32] = '* ACHTUNG - Datenbankschema ge�ndert *^^Die '
		 + 'Struktur der Datenbank '
		 + 'ist ge�ndert worden, nachdem Sie Ihre Abfragemasken er'
		 + 'stellt haben. Bitte verwenden Sie "Applikation '
		 + '�berarbeiten" im Men� Systemverwaltung sobald wie m�glich,'
		 + 'um Ihre Abfragemasken anzupassen.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-main.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = " A. Applikation �berarbeiten"
    qbf-lang[ 2] = " B. Bildschirmmasken f. Abfragen"
    qbf-lang[ 3] = " C. Dateien verkn�pfen"

    qbf-lang[ 4] = " D. Inhalt Benutzerverzeichnis"
    qbf-lang[ 5] = " E. Vorgang f. Applikationsende"
    qbf-lang[ 6] = " F. Zugriffsrechte f�r Module"
    qbf-lang[ 7] = " G. Zugriffsrechte bei Abfragen"
    qbf-lang[ 8] = " H. Startprogramm u. Produktname"

    qbf-lang[11] = " I. Sprache"
    qbf-lang[12] = " K. Ausgabeziele / Drucker"
    qbf-lang[13] = " L. Farbeinstellung Bildschirm"

    qbf-lang[14] = " M. Standardsuchliste f. Abfragen"
    qbf-lang[15] = " N. Standardparameter f. Berichte"
    qbf-lang[16] = " O. Zus�tzliches Exportformat"
    qbf-lang[17] = " P. Standardfelder f. Etiketten"
    qbf-lang[18] = " Q. Eigenes Programm-Modul"

    qbf-lang[21] = 'W�hlen Sie einen Men�punkt oder [' + KBLABEL("END-ERROR")
		 + '] zum Verlassen und Sichern Ihrer �nderungen.'
    /* these next four have a length limit of 20 including colon */
    qbf-lang[22] = 'Dateien:'
    qbf-lang[23] = 'Konfiguration:'
    qbf-lang[24] = 'Sicherheit:'
    qbf-lang[25] = 'Module:'

    qbf-lang[26] = 'Systemverwaltung'
    qbf-lang[27] = 'Version'
    qbf-lang[28] = 'Laden weiterer Parameter f�r die Systemverwaltung '
		 + 'aus der Konfigurationsdatei.'
    qbf-lang[29] = 'Sind Sie sicher, da� die Applikation angepa�t werden soll?'
/* QUIT and RETURN are the PROGRESS keywords and cannot be translated */
    qbf-lang[30] = 'Wenn der Benutzer das Hauptmen� verl��t, soll die Applikat'
		 + 'ion beendet werden (QUIT) oder nur das aktuelle Programm '
		 + '(RETURN)?'
    qbf-lang[31] = 'Sind Sie sicher, da� Sie das Modul "Systemverwaltung" jetzt'
		 + ' verlassen wollen?'
    qbf-lang[32] = 'Pr�fung der Konfigurationsdatei und '
		 + 'Speichern von �nderungen.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 5 THEN
  ASSIGN
/*a-perm.p, 1..7 also used by a-form.p and a-print.p*/
    qbf-lang[ 1] = 'Zugriffsrechte'
    qbf-lang[ 2] = '    *                   - Alle Benutzer haben Zugriff.'
    qbf-lang[ 3] = '    <user>,<user>,etc.  - Nur diese Benutzer haben Zugriff.'
    qbf-lang[ 4] = '    !<user>,!<user>,*   - Alle Benutzer au�er diesen haben '
		 + 'Zugriff.'
    qbf-lang[ 5] = '    acct*               - Nur Benutzernamen mit Anfang'
		 + ' "acct" haben Zugriff.'
    qbf-lang[ 6] = 'Eingabe d. Benutzerliste (nach login-ID sortiert), getrennt'
		 + ' durch Kommata.'
    qbf-lang[ 7] = 'IDs k�nnen Joker beinhalten. Verwenden Sie "!" '
		 + 'zum Ausschlu� von Benutzern.'
		   /* from 8 thru 13, format x(30) */
    qbf-lang[ 8] = 'W�hlen Sie ein Modul aus der '
    qbf-lang[ 9] = 'Liste aus, f�r das Sie Zu-'
    qbf-lang[10] = 'griffsrechte vergeben wollen.'
    qbf-lang[11] = 'W�hlen Sie eine Funktion aus'
    qbf-lang[12] = 'der Liste aus,f�r die Sie Zu-'
    qbf-lang[13] = 'griffsrechte vergeben wollen.'
    qbf-lang[14] = 'Taste [' + KBLABEL("END-ERROR")
		 + '] nach Abschlu� aller Eingaben.'
    qbf-lang[15] = '[' + KBLABEL("GO") + '] Sichern, ['
		 + KBLABEL("END-ERROR") + '] Abbrechen.'
    qbf-lang[16] = 'Sie k�nnen sich nicht selbst aus der Systemverwaltung '
		 + 'ausschlie�en!'
/*a-print.p:*/     /*21 thru 26 must be format x(16) and right-justified */
    qbf-lang[21] = ' Initialisierung'
    qbf-lang[22] = '                '
    qbf-lang[23] = ' Druckart normal'
    qbf-lang[24] = '     Komprimiert'
    qbf-lang[25] = '        Bold  AN'
    qbf-lang[26] = '        Bold AUS'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 6 THEN
  ASSIGN
/*a-write.p:*/
    qbf-lang[ 1] = 'Laden der Standardparameter f�r Module'
    qbf-lang[ 2] = 'Laden der Standardparameter f�r Farben'
    qbf-lang[ 3] = 'Laden der Standardparameter f�r den Drucker'
    qbf-lang[ 4] = 'Laden der Liste sichtbarer Dateien'
    qbf-lang[ 5] = 'Laden der Liste f�r Verkn�pfungen'
    qbf-lang[ 6] = 'Laden der Liste mit Standardfeldern f�r Etiketten'
    qbf-lang[ 7] = 'Laden der Liste mit Zugriffsrechten f�r Abfragefunktionen'
    qbf-lang[ 8] = 'Laden von Informationen �ber die hinzugef�gte Applikation'
    qbf-lang[ 9] = 'Laden von Vorgaben f�r Systemberichte'

/* a-color.p*/
		 /* 12345678901234567890123456789012 */
    qbf-lang[11] = '        Farben f�r Bildschirmtyp:' /* must be 32 */
		 /* 1234567890123456789012345 */
    qbf-lang[12] = 'Men�:             Normal:' /* must be 25 */
    qbf-lang[13] = '    Cursor hervorgehoben:'
    qbf-lang[14] = 'Dialog Rahmen:    Normal:'
    qbf-lang[15] = '    Cursor hervorgehoben:'
    qbf-lang[16] = 'Listen:           Normal:'
    qbf-lang[17] = '    Cursor hervorgehoben:'

/*a-field.p*/    /*"----- ----- ----- ----- ----"*/
    qbf-lang[30] = 'Zeig? �nd?  Frag? List? Folg'
    qbf-lang[31] = 'Mu� zwischen 1 und 9999 liegen.'
    qbf-lang[32] = 'Wollen Sie die �nderungen, die Sie gerade in der Feldliste '
		 + 'gemacht haben, abspeichern?'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 8 THEN
/*a-label.p*/
  ASSIGN            /* 1..8 use format x(78) */
		    /* 1 and 8 are available for more explanation, in */
		    /*   case the translation won't fit in 2 thru 7.  */
    qbf-lang[ 2] = 'Geben Sie die Namen der Felder ein, die Addressinformat'
		 + 'ionen enthalten. '
    qbf-lang[ 3] = 'Verwenden Sie Joker (* f�r mehrere Zeichen, . f�r ein '
		 + 'Zeichen) wie bei '
    qbf-lang[ 4] = 'CAN-DO oder MATCHES. Die Information wird bei der Feld'
		 + 'suche f�r '
    qbf-lang[ 5] = 'Standardetiketten verwendet. ACHTUNG: Einige Feldinhalte '
		 + 'k�nnen doppelt'
    qbf-lang[ 6] = 'auftreten, z.B. Postleitzahl und Ort oder Ansprechpartner '
		 + 'und '
    qbf-lang[ 7] = 'Anrede. Achten Sie bei der Vorgabe der Suchfeldnamen '
		 + 'darauf.'
		  /* each entry in list must be <= 5 characters long */
		  /* but may be any portion of address that is applicable */
		  /* in the target country */
    qbf-lang[ 9] = 'Arede,Name,Addr1,Addr2,Str.,Postf,PLZ,Ort,P+Ort,Land'
    qbf-lang[10] = 'Suchfelder f�r <Anrede>'
    qbf-lang[11] = 'Suchfelder f�r <Name>'
    qbf-lang[12] = 'Suchfelder f�r die <erste> Zeile der Anschrift'
    qbf-lang[13] = 'Suchfelder f�r die <zweite> Zeile der Anschrift'
    qbf-lang[14] = 'Suchfelder f�r die <Stra�e> '
    qbf-lang[15] = 'Suchfelder f�r <Postfach>'
    qbf-lang[16] = 'Suchfelder f�r die <PLZ> Postleitzahl'
    qbf-lang[17] = 'Suchfelder f�r den <Ort> Ortsnamen'
    qbf-lang[18] = 'Suchfelder f�r die Kombination < PLZ und Ort>'
    qbf-lang[19] = 'Suchfelder f�r <Land> L�ndername'

/*a-join.p*/
    qbf-lang[23] = 'Die Verkn�pfung mit sich selbst ist nicht '
		 + 'm�glich.'
    qbf-lang[24] = 'Die maximale Anzahl von Verkn�pfungen ist erreicht.'
    qbf-lang[25] = 'Verkn�pfung von' /* 25 and 26 are automatically */
    qbf-lang[26] = 'mit'          /*   right-justified           */
    qbf-lang[27] = 'Eingabe (Leertaste l�scht die Verkn�pfung):'
    qbf-lang[28] = '[' + KBLABEL("END-ERROR") + '] nach Abschlu� der '
		 + '�nderungen.'
    qbf-lang[30] = 'Die Bedingung mu� mit WHERE oder OF anfangen.'
    qbf-lang[31] = 'Eingabe der ersten Verkn�pfungsdatei.'
    qbf-lang[32] = 'Geben Sie jetzt bitte den zweiten Dateinamen ein.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-form.p */
IF qbf-s = 9 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' A. Neue Abfragemaske hinzuf�gen '
    qbf-lang[ 2] = ' B. Bestehende Abfragemaske �ndern '
    qbf-lang[ 3] = ' C. Allgemeine Maskenparameter '
    qbf-lang[ 4] = ' D. Felder in einer Maske '
    qbf-lang[ 5] = ' E. Zugriffsrechte '
    qbf-lang[ 6] = ' F. L�schen der aktuellen Abfragemaske '
    qbf-lang[ 7] = ' Auswahl: ' /* format x(10) */
    qbf-lang[ 8] = ' �nderung:' /* format x(10) */
		 /* cannot changed width of 9..16 from defined below */
    qbf-lang[ 9] = ' Name d. Datenbankdatei' /* right-justify 9..14 */
    qbf-lang[10] = '              Maskentyp'
    qbf-lang[11] = 'Programmname d. Abfrage'
    qbf-lang[12] = '    Dateiname der Maske'
    qbf-lang[13] = 'Fenstername f. 4GL Code'
    qbf-lang[14] = '           Beschreibung'
    qbf-lang[15] = '(.p als Standard) ' /* left-justify 15 and 16 */
    qbf-lang[16] = '(braucht Endung) '
    qbf-lang[18] = 'Diese Maske ben�tigt ~{1~} Zeilen. RESULTS selbst braucht '
		 + 'f�nf Zeilen f�r eigene Zwecke. Es stehen insgesamt aber '
		 + 'nur 24 Zeilen am Bildschirm zur Verf�gung. Soll Ihr Rahmen '
		 + 'wirklich so gro� werden?'
    qbf-lang[19] = 'Es existiert bereits ein Abfrageprogramm mit diesem Namen.'
    qbf-lang[20] = 'Diese Maske mu� es schon geben, oder braucht die Endung .f '
		 + 'f�r autom. Erzeugung.'
    qbf-lang[21] = 'Der von Ihnen gew�hlte Name ist von der 4GL reserviert. '
		 + 'Namen bitte �ndern.'
    qbf-lang[22] = ' W�hlen Sie verf�gbare Dateien '
    qbf-lang[23] = '[' + KBLABEL("END-ERROR") + '] nach Abschlu� der �nderung'
    qbf-lang[24] = 'Maskeninformation wird in Abfragemaske gespeichert ...'
    qbf-lang[25] = 'Sie haben mindestens eine Abfragemaske ge�ndert. Entweder '
		 + 'Sie kompilieren die �nderung jetzt oder machen '
		 + 'sp�ter eine "Applikationsanpassung". Jetzt kompilieren?'
    qbf-lang[26] = 'Abfragemaske namens "~{1~}" nicht vorhanden.  Wollen Sie '
		 + 'eine anlegen?'
    qbf-lang[27] = 'Eine Abfragemaske namens "~{1~}" gibt es schon. Sollen die '
		 + 'Felder dieser Maske �bernommen werden?'
    qbf-lang[28] = 'Wollen Sie die Abfragemaske wirklich l�schen?'
    qbf-lang[29] = '** Das Abfrageprogramm "~{1~}" ist gel�scht. **'
    qbf-lang[30] = 'Die Abfragemaske wird geschrieben...'
    qbf-lang[31] = 'Die maximale Anzahl an Abfragemasken ist erreicht.'
    qbf-lang[32] = 'F�r diese Datei kann keine Abfragemaske erstellt werden.'
		 + '^^F�r eine Abfragemaske mu� das Gateway die RECID '
		 + 'unterst�tzen oder die Datei mu� einen eindeutigen Index '
		 + 'haben.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-print.p */
IF qbf-s = 10 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' A. Neues Ausgabeziel hinzuf�gen'
    qbf-lang[ 2] = ' B. Bestehendes Ausgabeziel �ndern'
    qbf-lang[ 3] = ' C. Allgemeine Ausgabeparameter'
    qbf-lang[ 4] = ' D. Steuer- und Kontrollsequenzen'
    qbf-lang[ 5] = ' E. Zugriffsrechte f. Ausgabeziele'
    qbf-lang[ 6] = ' F. Ausgabeziele l�schen'
    qbf-lang[ 7] = ' Auswahl: ' /* format x(10) */
    qbf-lang[ 8] = '�nderung: ' /* format x(10) */
    qbf-lang[ 9] = 'Mu� kleiner als 256 aber gr��er als 0 sein.'
    qbf-lang[10] = 'Hier mu� "term, thru, to, view, file, page" oder "prog" '
		 + 'stehen.'
    qbf-lang[11] = 'Mehr Ausgabeziele k�nnen Sie nicht anlegen.'
    qbf-lang[12] = 'Nur der Typ "term" bewirkt die Ausgabe auf dem '
		 + 'Bildschirm.'
    qbf-lang[13] = 'Das Programm ist im aktuellen PROPATH nicht zu finden.'
		  /*17 thru 20 must be format x(16) and right-justified */
    qbf-lang[17] = '    Beschreibung'
    qbf-lang[18] = '            Name'
    qbf-lang[19] = ' Maximale Breite'
    qbf-lang[20] = '         Art/Typ'
    qbf-lang[21] = 'siehe unten'
    qbf-lang[22] = 'TERMINAL: Bildschirm, wie in OUTPUT TO TERMINAL PAGED'
    qbf-lang[23] = 'TO: an ein Ger�t, wie bei OUTPUT TO PRINTER'
    qbf-lang[24] = 'THROUGH: �ber einen UNIX oder OS/2 Spooler bzw. Filter'
    qbf-lang[25] = 'Schreibt Bericht in eine Datei, dann Programmausf�hrung'
    qbf-lang[26] = 'Fragt Benutzer nach Dateinamen f.d. Ausgabeziel'
    qbf-lang[27] = 'Anzeige mit vorherige/n�chste Seite m�glich'
    qbf-lang[28] = 'Aufruf 4GL-Programm f�r Start/Ende eines Ausgabeflu�es'
    qbf-lang[30] = '[' + KBLABEL("END-ERROR") + '] nach Abschlu� der �nderungen'
    qbf-lang[31] = 'Es mu� mindestens ein Ausgabeziel angelegt sein!'
    qbf-lang[32] = 'Wollen Sie dieses Ausgabeziel wirklich l�schen?'.

/*--------------------------------------------------------------------------*/

RETURN.

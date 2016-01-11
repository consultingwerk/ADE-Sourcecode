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
    qbf-lang[11] = 'ist nicht vorhanden. Sie mu· EINMAL angelegt werden, bevor '
		 + 'Ihre Datenbank mit RESULTS arbeiten kann. Soll das JETZT '
		 + 'getan werden?'
   qbf-lang[12] = 'MenÅpunkt auswÑhlen oder weiter mit [' + KBLABEL("END-ERROR")
		 + '] im aktuellen Modul.'
    qbf-lang[13] = 'Sie besitzen keine Lizenz fÅr RESULTS. Das Programm ist '
		 + 'beendet.'
    qbf-lang[14] = 'Sind Sie sicher, da· Sie "~{1~}" jetzt verlassen wollen?'
    qbf-lang[15] = 'MANUELL,HALBAUTO,AUTOMAT'
    qbf-lang[16] = 'Es ist keine Datenbank aktiv!'
   qbf-lang[17] = 'Das Programm kann nicht ausgefÅhrt werden, wenn der logische'
		 + ' Datenbankname mit "QBF$" anfÑngt.'
    qbf-lang[18] = 'Abbruch'
    qbf-lang[19] = '** RESULTS kann nicht starten **^^Im Verzeichnis '
		 + '~{1~} ist weder '
		 + '~{2~}.db noch ~{2~}.qc vorhanden. ~{3~}.qc ist zwar im'
		 + 'PROPATH angegeben, gehîrt aber scheinbar zu ~{3~}.db.'
		 + 'Bitte passen Sie PROPATH an oder lîschen Sie ~{3~}.db und'
		 + '.qc (Statt Lîschen ist auch Umbenennen mîglich.)'
    /* 24,26,30,32 available if necessary */
    qbf-lang[21] = '         Es gibt drei Mîglichkeiten, Abfragemasken fÅr '
		 + 'PROGRESS'
    qbf-lang[22] = '         RESULTS zu erstellen. Jede Maske, die mit '
		 + 'RESULTS er- '
    qbf-lang[23] = '         stellt wurde, kann nachtrÑglich geÑndert werden.'
    qbf-lang[25] = 'Sie mîchten jede Abfragemaske selbst erstellen.'
    qbf-lang[27] = 'Nachdem Sie einige Dateien aus Ihrer Datenbank ausge-'
    qbf-lang[28] = 'wÑhlt haben, erstellt RESULTS fÅr genau diese  '
    qbf-lang[29] = 'Dateien Abfragemasken.'
    qbf-lang[31] = 'RESULTS erzeugt alle Abfragemasken automatisch.'.


/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-user.p*/
IF qbf-s = 2 THEN
  /* format x(72) for 1,2,9-14,19-22 */
  ASSIGN
    qbf-lang[ 1] = 'Bitte geben Sie den Namen fÅr die Include-Datei an, die fÅr'
    qbf-lang[ 2] = 'die Suchlistenoption im Abfragemodul verwendet werden soll.'
    qbf-lang[ 3] = ' Standard Include-Datei:' /*format x(24)*/

    qbf-lang[ 8] = 'Das Programm ist nicht vorhanden:'

    qbf-lang[ 9] = 'Geben Sie den Namen fÅr das Startprogramm ein. Das Programm'
		 + ' kann ein'
    qbf-lang[10] = 'einfaches Logo sein oder eine komplette login-Prozedur'
		 + ' wie z.B. "login.p"'
    qbf-lang[11] = 'im DLC-Verzeichnis. Das Programm wird ausgefÅhrt, sobald '
		 + 'die Zeile'
    qbf-lang[12] = ' "signon=" in der Datei DBNAME.qc gelesen wird.'
    qbf-lang[13] = 'Geben Sie bitte den Produktnamen ein, der in den'
    qbf-lang[14] = 'MenÅs angezeigt werden soll.'
    qbf-lang[15] = '           Startprogramm:' /*format x(24)*/
    qbf-lang[16] = '            Produktname:' /*format x(24)*/
    qbf-lang[17] = 'Standardvorgabe:'

    qbf-lang[18] = 'Name Ihres PROGRESS Programms:'
    qbf-lang[19] = 'AusfÅhrung des Programms, sobald die Option "sonst. Pro'
		 + 'gramme" aufgerufen wird.'

    qbf-lang[20] = 'Hier kînnen Sie ein selbsterstelltes Export-Programm '
		 + 'einbinden.'
    qbf-lang[21] = 'Bitte geben Sie den Programmnamen und die Beschreibung'
    qbf-lang[22] = 'fÅr die Verwendung im MenÅ "Datenexport - Typ" an.'
    qbf-lang[23] = 'Programm:'
    qbf-lang[24] = 'Beschreibung:'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-load.p:*/
IF qbf-s = 3 THEN
  ASSIGN
    /* menu strip for d-main.p,l-main.p,r-main.p */
    qbf-lang[ 1] = 'Hole,LÑdt gespeicherte Vorlagen fÅr ~{1~}.'
    qbf-lang[ 2] = 'Ableg,Sichern der aktuellen ~{1~}.'
    qbf-lang[ 3] = 'Tun,AusfÅhren der aktuellen ~{1~}.'
    qbf-lang[ 4] = 'Definier,Auswahl von Dateien und Feldern.'
    qbf-lang[ 5] = 'Param,éndern der aktuellen Layout Parameter fÅr ~{1~}.'
    qbf-lang[ 6] = 'Wobei,Bedingungen fÅr die Selektion von DatensÑtzen.'
    qbf-lang[ 7] = 'Order,éndert die Reihenfolge der Ausgabe von DatensÑtzen.'
    qbf-lang[ 8] = 'Lîsch,Lîscht die aktuellen ~{1~}.'
    qbf-lang[ 9] = 'Info,Information Åber aktuelle Standardeinstellungen.'
    qbf-lang[10] = 'Modul,Wechseln zu einem anderen Modul.'
    qbf-lang[11] = 'Sonst,Aufruf eines in RESULTS eingebundenen Programms.'
    qbf-lang[12] = 'Ende,ZurÅck zum vorherigen MenÅ.'
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
     + 'aktuelle Version ist <~{1~}>. Die .qc-Datei ist fÅr Version <~{2~}>. '
		 + 'Es kann zu Problemen kommen, wenn Ihre Abfragemasken nicht '
		 + 'mit "Applikation Åberarbeiten" im MenÅ Systemverwaltung '
		 + 'angepa·t worden sind.'

    qbf-lang[27] = '* ACHTUNG - Es fehlen Datenbanken! *^^Nachfolgende '
		 + 'Datenbanken werden benîtigt, sind aber nicht gestartet:'

    qbf-lang[32] = '* ACHTUNG - Datenbankschema geÑndert *^^Die '
		 + 'Struktur der Datenbank '
		 + 'ist geÑndert worden, nachdem Sie Ihre Abfragemasken er'
		 + 'stellt haben. Bitte verwenden Sie "Applikation '
		 + 'Åberarbeiten" im MenÅ Systemverwaltung sobald wie mîglich,'
		 + 'um Ihre Abfragemasken anzupassen.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-main.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = " A. Applikation Åberarbeiten"
    qbf-lang[ 2] = " B. Bildschirmmasken f. Abfragen"
    qbf-lang[ 3] = " C. Dateien verknÅpfen"

    qbf-lang[ 4] = " D. Inhalt Benutzerverzeichnis"
    qbf-lang[ 5] = " E. Vorgang f. Applikationsende"
    qbf-lang[ 6] = " F. Zugriffsrechte fÅr Module"
    qbf-lang[ 7] = " G. Zugriffsrechte bei Abfragen"
    qbf-lang[ 8] = " H. Startprogramm u. Produktname"

    qbf-lang[11] = " I. Sprache"
    qbf-lang[12] = " K. Ausgabeziele / Drucker"
    qbf-lang[13] = " L. Farbeinstellung Bildschirm"

    qbf-lang[14] = " M. Standardsuchliste f. Abfragen"
    qbf-lang[15] = " N. Standardparameter f. Berichte"
    qbf-lang[16] = " O. ZusÑtzliches Exportformat"
    qbf-lang[17] = " P. Standardfelder f. Etiketten"
    qbf-lang[18] = " Q. Eigenes Programm-Modul"

    qbf-lang[21] = 'WÑhlen Sie einen MenÅpunkt oder [' + KBLABEL("END-ERROR")
		 + '] zum Verlassen und Sichern Ihrer énderungen.'
    /* these next four have a length limit of 20 including colon */
    qbf-lang[22] = 'Dateien:'
    qbf-lang[23] = 'Konfiguration:'
    qbf-lang[24] = 'Sicherheit:'
    qbf-lang[25] = 'Module:'

    qbf-lang[26] = 'Systemverwaltung'
    qbf-lang[27] = 'Version'
    qbf-lang[28] = 'Laden weiterer Parameter fÅr die Systemverwaltung '
		 + 'aus der Konfigurationsdatei.'
    qbf-lang[29] = 'Sind Sie sicher, da· die Applikation angepa·t werden soll?'
/* QUIT and RETURN are the PROGRESS keywords and cannot be translated */
    qbf-lang[30] = 'Wenn der Benutzer das HauptmenÅ verlÑ·t, soll die Applikat'
		 + 'ion beendet werden (QUIT) oder nur das aktuelle Programm '
		 + '(RETURN)?'
    qbf-lang[31] = 'Sind Sie sicher, da· Sie das Modul "Systemverwaltung" jetzt'
		 + ' verlassen wollen?'
    qbf-lang[32] = 'PrÅfung der Konfigurationsdatei und '
		 + 'Speichern von énderungen.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 5 THEN
  ASSIGN
/*a-perm.p, 1..7 also used by a-form.p and a-print.p*/
    qbf-lang[ 1] = 'Zugriffsrechte'
    qbf-lang[ 2] = '    *                   - Alle Benutzer haben Zugriff.'
    qbf-lang[ 3] = '    <user>,<user>,etc.  - Nur diese Benutzer haben Zugriff.'
    qbf-lang[ 4] = '    !<user>,!<user>,*   - Alle Benutzer au·er diesen haben '
		 + 'Zugriff.'
    qbf-lang[ 5] = '    acct*               - Nur Benutzernamen mit Anfang'
		 + ' "acct" haben Zugriff.'
    qbf-lang[ 6] = 'Eingabe d. Benutzerliste (nach login-ID sortiert), getrennt'
		 + ' durch Kommata.'
    qbf-lang[ 7] = 'IDs kînnen Joker beinhalten. Verwenden Sie "!" '
		 + 'zum Ausschlu· von Benutzern.'
		   /* from 8 thru 13, format x(30) */
    qbf-lang[ 8] = 'WÑhlen Sie ein Modul aus der '
    qbf-lang[ 9] = 'Liste aus, fÅr das Sie Zu-'
    qbf-lang[10] = 'griffsrechte vergeben wollen.'
    qbf-lang[11] = 'WÑhlen Sie eine Funktion aus'
    qbf-lang[12] = 'der Liste aus,fÅr die Sie Zu-'
    qbf-lang[13] = 'griffsrechte vergeben wollen.'
    qbf-lang[14] = 'Taste [' + KBLABEL("END-ERROR")
		 + '] nach Abschlu· aller Eingaben.'
    qbf-lang[15] = '[' + KBLABEL("GO") + '] Sichern, ['
		 + KBLABEL("END-ERROR") + '] Abbrechen.'
    qbf-lang[16] = 'Sie kînnen sich nicht selbst aus der Systemverwaltung '
		 + 'ausschlie·en!'
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
    qbf-lang[ 1] = 'Laden der Standardparameter fÅr Module'
    qbf-lang[ 2] = 'Laden der Standardparameter fÅr Farben'
    qbf-lang[ 3] = 'Laden der Standardparameter fÅr den Drucker'
    qbf-lang[ 4] = 'Laden der Liste sichtbarer Dateien'
    qbf-lang[ 5] = 'Laden der Liste fÅr VerknÅpfungen'
    qbf-lang[ 6] = 'Laden der Liste mit Standardfeldern fÅr Etiketten'
    qbf-lang[ 7] = 'Laden der Liste mit Zugriffsrechten fÅr Abfragefunktionen'
    qbf-lang[ 8] = 'Laden von Informationen Åber die hinzugefÅgte Applikation'
    qbf-lang[ 9] = 'Laden von Vorgaben fÅr Systemberichte'

/* a-color.p*/
		 /* 12345678901234567890123456789012 */
    qbf-lang[11] = '        Farben fÅr Bildschirmtyp:' /* must be 32 */
		 /* 1234567890123456789012345 */
    qbf-lang[12] = 'MenÅ:             Normal:' /* must be 25 */
    qbf-lang[13] = '    Cursor hervorgehoben:'
    qbf-lang[14] = 'Dialog Rahmen:    Normal:'
    qbf-lang[15] = '    Cursor hervorgehoben:'
    qbf-lang[16] = 'Listen:           Normal:'
    qbf-lang[17] = '    Cursor hervorgehoben:'

/*a-field.p*/    /*"----- ----- ----- ----- ----"*/
    qbf-lang[30] = 'Zeig? énd?  Frag? List? Folg'
    qbf-lang[31] = 'Mu· zwischen 1 und 9999 liegen.'
    qbf-lang[32] = 'Wollen Sie die énderungen, die Sie gerade in der Feldliste '
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
    qbf-lang[ 3] = 'Verwenden Sie Joker (* fÅr mehrere Zeichen, . fÅr ein '
		 + 'Zeichen) wie bei '
    qbf-lang[ 4] = 'CAN-DO oder MATCHES. Die Information wird bei der Feld'
		 + 'suche fÅr '
    qbf-lang[ 5] = 'Standardetiketten verwendet. ACHTUNG: Einige Feldinhalte '
		 + 'kînnen doppelt'
    qbf-lang[ 6] = 'auftreten, z.B. Postleitzahl und Ort oder Ansprechpartner '
		 + 'und '
    qbf-lang[ 7] = 'Anrede. Achten Sie bei der Vorgabe der Suchfeldnamen '
		 + 'darauf.'
		  /* each entry in list must be <= 5 characters long */
		  /* but may be any portion of address that is applicable */
		  /* in the target country */
    qbf-lang[ 9] = 'Arede,Name,Addr1,Addr2,Str.,Postf,PLZ,Ort,P+Ort,Land'
    qbf-lang[10] = 'Suchfelder fÅr <Anrede>'
    qbf-lang[11] = 'Suchfelder fÅr <Name>'
    qbf-lang[12] = 'Suchfelder fÅr die <erste> Zeile der Anschrift'
    qbf-lang[13] = 'Suchfelder fÅr die <zweite> Zeile der Anschrift'
    qbf-lang[14] = 'Suchfelder fÅr die <Stra·e> '
    qbf-lang[15] = 'Suchfelder fÅr <Postfach>'
    qbf-lang[16] = 'Suchfelder fÅr die <PLZ> Postleitzahl'
    qbf-lang[17] = 'Suchfelder fÅr den <Ort> Ortsnamen'
    qbf-lang[18] = 'Suchfelder fÅr die Kombination < PLZ und Ort>'
    qbf-lang[19] = 'Suchfelder fÅr <Land> LÑndername'

/*a-join.p*/
    qbf-lang[23] = 'Die VerknÅpfung mit sich selbst ist nicht '
		 + 'mîglich.'
    qbf-lang[24] = 'Die maximale Anzahl von VerknÅpfungen ist erreicht.'
    qbf-lang[25] = 'VerknÅpfung von' /* 25 and 26 are automatically */
    qbf-lang[26] = 'mit'          /*   right-justified           */
    qbf-lang[27] = 'Eingabe (Leertaste lîscht die VerknÅpfung):'
    qbf-lang[28] = '[' + KBLABEL("END-ERROR") + '] nach Abschlu· der '
		 + 'énderungen.'
    qbf-lang[30] = 'Die Bedingung mu· mit WHERE oder OF anfangen.'
    qbf-lang[31] = 'Eingabe der ersten VerknÅpfungsdatei.'
    qbf-lang[32] = 'Geben Sie jetzt bitte den zweiten Dateinamen ein.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-form.p */
IF qbf-s = 9 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' A. Neue Abfragemaske hinzufÅgen '
    qbf-lang[ 2] = ' B. Bestehende Abfragemaske Ñndern '
    qbf-lang[ 3] = ' C. Allgemeine Maskenparameter '
    qbf-lang[ 4] = ' D. Felder in einer Maske '
    qbf-lang[ 5] = ' E. Zugriffsrechte '
    qbf-lang[ 6] = ' F. Lîschen der aktuellen Abfragemaske '
    qbf-lang[ 7] = ' Auswahl: ' /* format x(10) */
    qbf-lang[ 8] = ' énderung:' /* format x(10) */
		 /* cannot changed width of 9..16 from defined below */
    qbf-lang[ 9] = ' Name d. Datenbankdatei' /* right-justify 9..14 */
    qbf-lang[10] = '              Maskentyp'
    qbf-lang[11] = 'Programmname d. Abfrage'
    qbf-lang[12] = '    Dateiname der Maske'
    qbf-lang[13] = 'Fenstername f. 4GL Code'
    qbf-lang[14] = '           Beschreibung'
    qbf-lang[15] = '(.p als Standard) ' /* left-justify 15 and 16 */
    qbf-lang[16] = '(braucht Endung) '
    qbf-lang[18] = 'Diese Maske benîtigt ~{1~} Zeilen. RESULTS selbst braucht '
		 + 'fÅnf Zeilen fÅr eigene Zwecke. Es stehen insgesamt aber '
		 + 'nur 24 Zeilen am Bildschirm zur VerfÅgung. Soll Ihr Rahmen '
		 + 'wirklich so gro· werden?'
    qbf-lang[19] = 'Es existiert bereits ein Abfrageprogramm mit diesem Namen.'
    qbf-lang[20] = 'Diese Maske mu· es schon geben, oder braucht die Endung .f '
		 + 'fÅr autom. Erzeugung.'
    qbf-lang[21] = 'Der von Ihnen gewÑhlte Name ist von der 4GL reserviert. '
		 + 'Namen bitte Ñndern.'
    qbf-lang[22] = ' WÑhlen Sie verfÅgbare Dateien '
    qbf-lang[23] = '[' + KBLABEL("END-ERROR") + '] nach Abschlu· der énderung'
    qbf-lang[24] = 'Maskeninformation wird in Abfragemaske gespeichert ...'
    qbf-lang[25] = 'Sie haben mindestens eine Abfragemaske geÑndert. Entweder '
		 + 'Sie kompilieren die énderung jetzt oder machen '
		 + 'spÑter eine "Applikationsanpassung". Jetzt kompilieren?'
    qbf-lang[26] = 'Abfragemaske namens "~{1~}" nicht vorhanden.  Wollen Sie '
		 + 'eine anlegen?'
    qbf-lang[27] = 'Eine Abfragemaske namens "~{1~}" gibt es schon. Sollen die '
		 + 'Felder dieser Maske Åbernommen werden?'
    qbf-lang[28] = 'Wollen Sie die Abfragemaske wirklich lîschen?'
    qbf-lang[29] = '** Das Abfrageprogramm "~{1~}" ist gelîscht. **'
    qbf-lang[30] = 'Die Abfragemaske wird geschrieben...'
    qbf-lang[31] = 'Die maximale Anzahl an Abfragemasken ist erreicht.'
    qbf-lang[32] = 'FÅr diese Datei kann keine Abfragemaske erstellt werden.'
		 + '^^FÅr eine Abfragemaske mu· das Gateway die RECID '
		 + 'unterstÅtzen oder die Datei mu· einen eindeutigen Index '
		 + 'haben.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-print.p */
IF qbf-s = 10 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' A. Neues Ausgabeziel hinzufÅgen'
    qbf-lang[ 2] = ' B. Bestehendes Ausgabeziel Ñndern'
    qbf-lang[ 3] = ' C. Allgemeine Ausgabeparameter'
    qbf-lang[ 4] = ' D. Steuer- und Kontrollsequenzen'
    qbf-lang[ 5] = ' E. Zugriffsrechte f. Ausgabeziele'
    qbf-lang[ 6] = ' F. Ausgabeziele lîschen'
    qbf-lang[ 7] = ' Auswahl: ' /* format x(10) */
    qbf-lang[ 8] = 'énderung: ' /* format x(10) */
    qbf-lang[ 9] = 'Mu· kleiner als 256 aber grî·er als 0 sein.'
    qbf-lang[10] = 'Hier mu· "term, thru, to, view, file, page" oder "prog" '
		 + 'stehen.'
    qbf-lang[11] = 'Mehr Ausgabeziele kînnen Sie nicht anlegen.'
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
    qbf-lang[23] = 'TO: an ein GerÑt, wie bei OUTPUT TO PRINTER'
    qbf-lang[24] = 'THROUGH: Åber einen UNIX oder OS/2 Spooler bzw. Filter'
    qbf-lang[25] = 'Schreibt Bericht in eine Datei, dann ProgrammausfÅhrung'
    qbf-lang[26] = 'Fragt Benutzer nach Dateinamen f.d. Ausgabeziel'
    qbf-lang[27] = 'Anzeige mit vorherige/nÑchste Seite mîglich'
    qbf-lang[28] = 'Aufruf 4GL-Programm fÅr Start/Ende eines Ausgabeflu·es'
    qbf-lang[30] = '[' + KBLABEL("END-ERROR") + '] nach Abschlu· der énderungen'
    qbf-lang[31] = 'Es mu· mindestens ein Ausgabeziel angelegt sein!'
    qbf-lang[32] = 'Wollen Sie dieses Ausgabeziel wirklich lîschen?'.

/*--------------------------------------------------------------------------*/

RETURN.

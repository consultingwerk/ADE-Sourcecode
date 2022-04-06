/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-q-ger.p - German language definitions for Query module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Die Bedingungen werden von keinem Datensatz erf�llt.'
    qbf-lang[ 2] = 'Alle,Verkn�pfung,Untermenge'
    qbf-lang[ 3] = 'Alle,Anfang..,Ende..'
    qbf-lang[ 4] = 'F�r dies Datei sind keine Indizes definiert.'
    qbf-lang[ 5] = 'Wollen Sie diesen Datensatz wirklich l�schen?'
    qbf-lang[ 6] = '' /* special total message: created from #7 or #8 */
    qbf-lang[ 7] = 'Der Z�hlvorgang ist abgebrochen.'
    qbf-lang[ 8] = 'Anzahl verf�gbarer Datens�tze ist '
    qbf-lang[ 9] = 'RESULTS z�hlt gerade...   [' + KBLABEL("END-ERROR")
		 + '] unterbricht den Vorgang.'
    qbf-lang[10] = 'gleich,kleiner als,kleiner als oder gleich,'
		 + 'gr��er als,gr��er als oder gleich,'
		 + 'ungleich,vergleichbar mit,beginnt mit'
    qbf-lang[11] = 'F�r diese Abfrage gibt es keine Datens�tze.'
    qbf-lang[13] = 'Das ist schon der erste Satz der Datei.'
    qbf-lang[14] = 'Das ist schon der letzte Satz der Datei.'
    qbf-lang[15] = 'Es ist keine Abfragemaske aktiv.'
    qbf-lang[16] = 'Abfrage'
    qbf-lang[17] = 'Bitte w�hlen Sie eine Abfragemaske aus.'
    qbf-lang[18] = '[' + KBLABEL("GO")
		 + '] oder [' + KBLABEL("RETURN")
		 + '] f�r Maskenauswahl, [' + KBLABEL("END-ERROR")
		 + '] Abbrechen.'
    qbf-lang[19] = 'Laden der Abfragemaske...'
    qbf-lang[20] = 'Die Abfragemaske ist noch nicht kompiliert. '
		 + 'M�gliche Ursachen:^1) falscher PROPATH,^2) .r-Datei f�r die'
		 + ' Abfrage fehlt, oder^3) .r-Datei ist nicht kompiliert. '
		 + '^Pr�fen Sie die Datei <DBNAME>.ql auf Fehlermeldungen des '
		 + 'Kompilers.^^Sie k�nnen auch weitermachen, es kann aber zu '
		 + 'Fehlermeldungen kommen. Wollen Sie '
		 + 'weitermachen?'
    qbf-lang[21] = 'In der aktuellen Abfragemaske ist eine WOBEI-Bedingung, die'
		 + ' Werte aus der Laufzeitumgebung �bernimmt. Das wird im '
		 + 'Abfragemodul nicht unterst�tzt. Soll die WOBEI-Bedingung '
		 + 'ignoriert und weitergemacht werden?'
    qbf-lang[22] = '[' + KBLABEL("GET")
		 + '] Andere Felder f�r die Suchliste ausw�hlen.'.

ELSE

IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'N�chster,N�chster Satz.'
    qbf-lang[ 2] = 'Vorher,Vorheriger Satz.'
    qbf-lang[ 3] = 'Erster,Erster Satz.'
    qbf-lang[ 4] = 'YLetzt,Letzter Satz.'
    qbf-lang[ 5] = 'Hinzu,Hinzuf�gen eines neuen Satzes.'
    qbf-lang[ 6] = '�ndern,�ndern des angezeigten Satzes.'
    qbf-lang[ 7] = 'Kopie,Der akt. Satzinhalt wird in einen neuen Satz kopiert.'
    qbf-lang[ 8] = 'L�sch,Der angezeigte Datensatz wird gel�scht.'
    qbf-lang[ 9] = 'ZeigAndere,Anzeige einer anderen Abfragemaske.'
    qbf-lang[10] = 'Durchsuch,Liste aller Datens�tzen zum Durchsuchen.'
    qbf-lang[11] = 'XKn�pf,Verbindung von verkn�pften Dateien.'
    qbf-lang[12] = 'Fragbsp,Auswahl von S�tzen anhand eines Abfragebeispiels.'
    qbf-lang[13] = 'Wobei,Eingabe von Bedingungen (WHERE) f�r die Satzauswahl'
    qbf-lang[14] = 'Anz,Z�hlen der Datens�tze in der aktuellen (Unter)gruppe'
    qbf-lang[15] = 'Order,�nderung der Sortierreihenfolge (anderer Index).'
    qbf-lang[16] = 'Modul,Wechsel zu einem anderen Modul.'
    qbf-lang[17] = 'Info,Einzelheiten �ber die Parameter der aktuellen Maske.'
    qbf-lang[18] = 'Sonst,Aufruf einer in RESULTS eingebundenen Applikation.'
    qbf-lang[19] = 'Beende, Beenden der Abfrage.'
    qbf-lang[20] = ''. /* terminator */

RETURN.

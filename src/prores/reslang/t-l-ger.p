/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-l-ger.p - German language definitions for Labels module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* l-guess.p:1..5,l-verify.p:6.. */
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Suche in "~{1~}" nach dem Feld "~{2~}" ...'
    qbf-lang[ 2] = 'In den Dateien sind keine Felder mit Standardnamen '
		 + 'vorhanden.'
    qbf-lang[ 4] = 'Aufbau der Felder fÅr das Label'
    qbf-lang[ 5] = 'Anrede,Name,Anschrift1,Anschrift2,Stra·e,Postfach,'
		 + 'PLZ,Ort,PLZ+Ort,Land'

    qbf-lang[ 6] = 'Zeile ~{1~}: Klammern fehlen oder sind nicht geschlossen.'
    qbf-lang[ 7] = 'Zeile ~{2~}: Das Feld "~{1~}" kann nicht gefunden werden.'
    qbf-lang[ 8] = 'Zeile ~{2~}: Das Feld "~{1~}" ist kein Listenelementfeld.'
    qbf-lang[ 9] = 'Zeile ~{2~}: Feld  "~{1~}", Listenelement ~{3~}, liegt '
		 + 'au·erhalb des Bereichs.'
    qbf-lang[10] = 'Zeile ~{2~}: Das Feld "~{1~}" gehîrt zu einer Datei, '
		 + 'die nicht aktiv ist.'.

ELSE

/*--------------------------------------------------------------------------*/
/* l-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    /* each entry of 1 and also 2 must fit in format x(6) */
    qbf-lang[ 1] = 'Datei:,     :,     :,     :,     :'
    qbf-lang[ 2] = 'Order:'
    qbf-lang[ 3] = 'Etikett Info'
    qbf-lang[ 4] = 'Etikett Layout'
    qbf-lang[ 5] = 'WÑhlen Sie ein Feld'
    /*cannot change length of 6 thru 17, right-justify 6-11,13-14 */
    qbf-lang[ 6] = 'Leerzeilunterdr.:'
    qbf-lang[ 7] = '   Anzahl Kopien:'
    qbf-lang[ 8] = '    Gesamthîhe:'
    qbf-lang[ 9] = '   Oberer Rand:'
    qbf-lang[10] = '        Etikettbreite:'
    qbf-lang[11] = '          Linker Rand:'
    qbf-lang[12] = '(breit)'
    qbf-lang[13] = ' Etikett-Text'
    qbf-lang[14] = '   und Felder'
    qbf-lang[15] = 'Etiketten         ' /* 15..17 used as group.   */
    qbf-lang[16] = 'nebenein-         ' /*   do not change length, */
    qbf-lang[17] = 'ander:       ' /*        but do right-justify  */
    qbf-lang[19] = 'Sie haben noch ein Etikett in Bearbeitung. Soll der '
		 + 'Bildschirm gelîscht werden?'
    qbf-lang[20] = 'Ihr Etikett besteht aus ~{2~} Zeilen, Sie haben aber '
		 + 'nur ~{1~} definiert. '
		 + 'Einige Informationen sind grî·er als Ihr Etikett'
		 + 'und kînnen deshalb nicht ausgedruckt werden. Wollen Sie'
		 + 'trotzdem weitermachen und die Etiketten ausdrucken lassen?'
    qbf-lang[21] = 'Keine Etikettfelder oder -texte fÅr die Ausgabe vorhanden!'
    qbf-lang[22] = 'Das Programm fÅr die Etiketten wird erstellt...'
    qbf-lang[23] = 'Das Programm fÅr die Etiketten wird kompiliert...'
    qbf-lang[24] = 'Das Programm fÅr die Etikettausgabe wird ausgefÅhrt...'
    qbf-lang[25] = 'Keine Schreibrechte fÅr die Datei bzw. das GerÑt'
    qbf-lang[26] = '~{1~} Etiketten wurden ausgegeben.'
    qbf-lang[27] = 'L. Layout bearbeiten'
    qbf-lang[28] = 'N. Neue Dateien/Felder'
    qbf-lang[29] = 'Soll RESULTS in den Dateien nach Standardfeldern fÅr '
		 + 'Etiketten suchen?'
    qbf-lang[31] = 'Sollen der Bildschirm wirklich gelîscht werden?'
    qbf-lang[32] = 'Wollen Sie das Modul "Etikett" wirklich verlassen?'.

ELSE

/*--------------------------------------------------------------------------*/
/* l-main.p */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = 'Der Textabstand zwischen Etiketten mu· > 0 sein.'
    qbf-lang[ 2] = 'Der obere Rand kann nicht negativ sein.'
    qbf-lang[ 3] = 'Die Gesamthîhe mu· grî·er als 1 sein.'
    qbf-lang[ 4] = 'Die Anzahl Etiketten nebeneinander mu· mindestens 1 sein.'
    qbf-lang[ 5] = 'Die gewÅnschte Kopienanzahl mu· mindestens 1 sein.'
    qbf-lang[ 6] = 'Der linke Rand kann nicht negativ sein.'
    qbf-lang[ 7] = 'Der Textabstand mu· grî·er als 1 sein.'
    qbf-lang[ 8] = 'ja = LeerzeilenunterdrÅckung. Text rÅckt 1 Zeile nach oben.'
    qbf-lang[ 9] = 'Zeilenzahl vom oberen Etikettrand bis zur ersten Druckzeile'
    qbf-lang[10] = 'Gesamthîhe des Etiketts in Zeilen.'
    qbf-lang[11] = 'Anzahl Etiketten nebeneinander.'
    qbf-lang[12] = 'Anzahl, wie oft jedes Etikett ausgegeben wird.'
    qbf-lang[13] = 'Leerzeichen vom Etikettrand bis zur ersten Druckposition.'
    qbf-lang[14] = 'Abstand linke Ecke eines Etiketts zum nÑchsten Etikett'.

/*--------------------------------------------------------------------------*/

RETURN.

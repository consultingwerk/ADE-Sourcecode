/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-r-ger.p - German language definitions for Reports module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

IF qbf-s = 1 THEN
  ASSIGN
/*r-header.p*/
    qbf-lang[ 1] = 'Text oder Ausdruck f�r: '
    qbf-lang[ 2] = 'Zeile' /* must be < 8 characters */
		   /* 3..7 are format x(64) */
    qbf-lang[ 3] = 'Diese Funktionen k�nnen in Kopf- und Fu�zeilen '
		 + 'verwendet werden'
    qbf-lang[ 4] = '~{COUNT~} Anzahl S�tze bisher     :  '
		 + '~{TIME~}  Startzeit Bericht '
    qbf-lang[ 5] = '~{TODAY~}  aktuelles Datum        :  '
		 + '~{NOW~}   aktuelle Zeit'
    qbf-lang[ 6] = '~{PAGE~}   aktuelle Seitenzahl    :  '
		 + '~{USER~}  Benutzerkennung'
    qbf-lang[ 7] = '~{VALUE <Feld>~;<Format>~} Einf�gen von '
		 + 'Variablen mit [' + KBLABEL("GET") + ']'
    qbf-lang[ 8] = 'Auswahl des einzuf�genden Feldes'
    qbf-lang[ 9] = '[' + KBLABEL("GO") + '] Sichern, ['
		 + KBLABEL("GET") + '] Feld einf�gen, ['
		 + KBLABEL("END-ERROR") + '] Abbrechen.'

/*r-total.p*/    /*"|---------------------------|"*/
    qbf-lang[12] = 'wird Folgendes ausgegeben:'
		 /*"|--------------------------------------------|"*/
    qbf-lang[13] = 'wenn sich die Feldinhalte �ndern bei:'
		 /*"|---| |---| |---| |---| |---|" */
    qbf-lang[14] = '-Ges- -Anz- -Min- -Max- -Mit-'
    qbf-lang[15] = 'Gesamtsumme'
    qbf-lang[16] = 'F�r das Feld'
    qbf-lang[17] = 'Feldauswahl f�r Summenbildung'

/*r-calc.p*/
    qbf-lang[18] = 'Feldauswahl f�r: Aufsummierung'
    qbf-lang[19] = 'Feldauswahl f�r: Anteil in %'
    qbf-lang[20] = 'Aufsummierung'
    qbf-lang[21] = 'Anteil in %'
    qbf-lang[22] = 'Text-,Datum-,Logisch.-,Math.-,Num.-'
    qbf-lang[23] = 'Ausdruck'
    qbf-lang[24] = 'Zahl, mit der angefangen werden soll zu z�hlen.'
    qbf-lang[25] = '(Negative) Zahl, mit der stufenweise ab/aufw�rts gez�hlt '
		 + 'wird.'
    qbf-lang[26] = 'Z�hler'
    qbf-lang[27] = 'Z�hler'
		 /*"------------------------------|"*/
    qbf-lang[28] = '       Startzahl f�r den Z�hler' /*right justify*/
    qbf-lang[29] = '   bei jedem Satz hochz�hlen um' /*right justify*/
    qbf-lang[32] = 'Sie haben bereits die maximale Spaltenzahl festgelegt.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN
/* r-space.p */  /*"------------------------------|  ---------|  |------"*/
    qbf-lang[ 1] = '             Option                 aktuell  Vorgabe'
    /* 2..8 must be less than 32 characters long */
    qbf-lang[ 2] = 'Linker Rand'
    qbf-lang[ 3] = 'Leerzeichen zwischen den Spalten'
    qbf-lang[ 4] = 'Startzeile'
    qbf-lang[ 5] = 'Zeilen pro Seite'
    qbf-lang[ 6] = 'Zeilenabstand'
    qbf-lang[ 7] = 'Zeilen zw. Kopf- und Haupteil'
    qbf-lang[ 8] = 'Zeilen zw. Haupt- und Fu�teil'
		  /*1234567890123456789012345678901*/
    qbf-lang[ 9] = 'Randeinstellung/Spaltenabstand'
    qbf-lang[10] = 'Zul�ssig sind Zeilenzahlen zwischen 1 und einer Seitenl�nge'
    qbf-lang[11] = 'Bitte keine negative Seitenl�nge angeben.'
    qbf-lang[12] = 'Die Spalte, in der der Bericht anf�ngt, mu� 1 oder gr��er '
		 + 'sein.'
    qbf-lang[13] = 'Bitte geben Sie einen zul�ssigen Wert ein.'
    qbf-lang[14] = 'Die Zeile, in der der Bericht anf�ngt, mu� 1 oder gr��er '
		 + 'sein.'

/*r-set.p*/        /* format x(30) for 15..22 */
    qbf-lang[15] = 'F.  Feldbez. und -format'
    qbf-lang[16] = 'SV. Seitenvorschub'
    qbf-lang[17] = 'SB. Summenberichte'
    qbf-lang[18] = 'RS. R�nder/Spaltenabstand'
    qbf-lang[19] = 'KL. Kopfzeile links'
    qbf-lang[20] = 'KM. Kopfzeile mitte'
    qbf-lang[21] = 'KR. Kopfzeile rechts'
    qbf-lang[22] = 'FL. Fu�zeile links'
    qbf-lang[23] = 'FM. Fu�zeile mitte'
    qbf-lang[24] = 'FR. Fu�zeile rechts'
    qbf-lang[25] = 'ES. Kopftext (erste Seite)'
    qbf-lang[26] = 'LS. Fu�text (letzte Seite)'
    qbf-lang[32] = '[' + KBLABEL("END-ERROR")
		 + '] nach Abschlu� aller �nderungen.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 3 THEN
  ASSIGN
    /* r-main.p,s-page.p */
    qbf-lang[ 1] = 'Datei:,     :,     :,     :,     :'
    qbf-lang[ 2] = 'Order:'
    qbf-lang[ 3] = 'Bericht Info'
    qbf-lang[ 4] = 'Bericht Layout'
    qbf-lang[ 5] = 'mehr' /* for <<more and more>> */
    qbf-lang[ 6] = 'Bericht,Breite' /* each word comma-separated */
    qbf-lang[ 7] = 'Berichtstruktur anschauen mit den Tasten "<" oder ">".'
    qbf-lang[ 8] = 'Ein Bericht kann maximal 255 Zeichen breit sein.'
    qbf-lang[ 9] = 'Sie haben noch einen Bericht in Bearbeitung. Soll der '
		 + 'Bildschirm gel�scht werden?'
    qbf-lang[10] = 'Das Programm f�r den Bericht wird erzeugt ...'
    qbf-lang[11] = 'Das Programm f�r den Bericht wird kompiliert...'
    qbf-lang[12] = 'Das Programm f�r den Bericht wird ausgef�hrt...'
    qbf-lang[13] = 'Keine Schreibrechte f�r die Datei bzw. das Ger�t'
    qbf-lang[14] = 'Soll der Bildschirm wirklich gel�scht werden?'
    qbf-lang[15] = 'Wollen Sie das Modul "Bericht" wirklich verlassen?'
    qbf-lang[16] = '['
		 + (IF KBLABEL("CURSOR-UP") BEGINS "CTRL-" THEN 'CURSOR-UP'
		   ELSE KBLABEL("CURSOR-UP"))
		 + '] und ['
		 + (IF KBLABEL("CURSOR-DOWN") BEGINS "CTRL-" THEN 'CURSOR-DOWN'
		   ELSE KBLABEL("CURSOR-DOWN"))
		 + '] zum Bl�ttern, ['
		 + KBLABEL("END-ERROR") + '] Ende.'
    qbf-lang[17] = 'Seite'
    qbf-lang[18] = '~{1~} S�tze wurden im Bericht ausgegeben.'
    qbf-lang[19] = 'Geht nicht! Ein Summenbericht kann nur erstellt werden, '
		 + 'wenn eine Sortierreihenfolge nach Gruppen (Order) '
		 + 'angegeben wurde.'
    qbf-lang[20] = 'Geht nicht! Ein Summenbericht kann nur f�r Felder '
		 + 'erstellt werden, die keine Listenelemente (ARRAY) '
		 + 'in tabellarischer Form enthalten.'
    qbf-lang[21] = 'Summenbericht'
    qbf-lang[23] = 'Sie m�ssen erst Felder definieren, bevor der Bericht '
		 + 'erstellt werden kann.'.

ELSE

/*--------------------------------------------------------------------------*/
/* FAST TRACK interface test for r-ft.p r-ftsub.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = 'FAST TRACK f�hrt keine Terminalausgabe aus, wenn '
    qbf-lang[ 2] = 'Selektionsdaten gefragt sind. Ausgabemedium ist Drucker.'
    qbf-lang[ 3] = 'Analyse der Kopf- und Fu�zeilen...'
    qbf-lang[ 4] = 'Gruppenbildung...'
    qbf-lang[ 5] = 'Aufbau der Felder und Aggregate...'
    qbf-lang[ 6] = 'Aufbau der Dateien und WHERE-Bedingungen...'
    qbf-lang[ 7] = 'Aufbau der Kopf- und Fu�zeilen...'
    qbf-lang[ 8] = 'Aufbau der Zeilen im Bericht ...'
    qbf-lang[ 9] = 'Es gibt in FAST TRACK schon einen Bericht mit dem Namen '
		 + '~{1~}. Soll der Bericht �berschrieben werden?'
    qbf-lang[10] = 'Der Bericht wird �berschrieben ...'
    qbf-lang[11] = 'Wollen Sie FAST TRACK jetzt starten?'
    qbf-lang[12] = 'Bitte einen Namen eingeben'
    qbf-lang[13] = 'FAST TRACK kennt die Funktion TIME in Kopf/Fu�zeilen '
		 + 'nicht. Ersetzt durch NOW.'
    qbf-lang[14] = 'FAST TRACK kann "%" nicht berechnen. Das Feld '
		 + 'wird ausgelassen.'
    qbf-lang[15] = 'FAST TRACK kennt ~{1~} in Kopf/Fu�zeilen nicht, '
		 + '~{2~} wird ausgelassen.'
    qbf-lang[16] = 'Berichtsnamen d�rfen nur alphanummerische Zeichen und '
		 + 'Unterstriche beinhalten.'
    qbf-lang[17] = 'Name des Berichts in FAST TRACK:'
    qbf-lang[18] = 'Der Bericht wurde nicht nach FAST TRACK �bertragen'
    qbf-lang[19] = 'FAST TRACK wird gestartet, bitte warten ...'
    qbf-lang[20] = 'Kopf/Fu�zeile hat unpassende geschweifte Klammern, '
		 + 'Bericht NICHT �bertragbar.'
    qbf-lang[21] = 'FAST TRACK kennt keinen speziellen Kopftext f�r '
		 + 'die erste/letzte Seite.'
    qbf-lang[22] = 'ACHTUNG: F�r den Z�hler wird Startzahl ~{1~} verwendet.'
    qbf-lang[23] = 'INHALTE'
    qbf-lang[24] = 'TOTAL,COUNT,MAX,MIN,AVG'
    qbf-lang[25] = 'FAST TRACK f�hrt keine Summenberichte aus. '
		 + 'Der Bericht ist nicht �bertragbar.'
    qbf-lang[26] = 'Ohne Datei- und Felddefinitionen kann der Bericht nicht '
		 + '�bertragen werden.'.


ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 5 THEN
  ASSIGN
    /* r-short.p */
    qbf-lang[ 1] = 'Der Bericht ist kaum ausf�hrbar, '
		 + 'wenn alle Summen angezeigt w�rden. Es kann aber '
		 + 'jeweils eine neue Summenzeile ausgegeben werden, wenn sich '
		 + 'das letzte Feld der angegebenen Sortierreihenfolge (Order) '
		 + '�ndert. '
		 + '^In dem Bericht erscheint also eine neue Zeile, wenn '
		 + 'sich der Wert ~{1~} �ndert.^Soll der Summenbericht so '
		 + 'erstellt werden? '
    qbf-lang[ 2] = 'Ja'
    qbf-lang[ 3] = 'Nein'
    qbf-lang[ 4] = 'Bitte legen Sie erst Felder f�r die Sortierreihenfolge '
		 + '(Order) fest, bevor Sie die Option f�r Summenberichte '
		 + 'ausw�hlen.^^Bearbeiten Sie im Berichtmodul '
		 + 'den Punkt "Order", um die Sortierfelder zu '
		 + 'bestimmen, bevor Sie an dieser Stelle weitermachen. '
    qbf-lang[ 5] = 'Liste aller Felder f�r diesen Bericht. W�hlen Sie die '
    qbf-lang[ 6] = 'Felder aus, die aufsummiert werden sollen. '
    qbf-lang[ 7] = 'Die Summenbildung f�r ein nummerisches Feld '
		 + 'gibt eine Zwischensumme aus, wenn '
		 + 'sich der Wert des Feldes ~{1~} �ndert. '
    qbf-lang[ 8] = 'Die Summenbildung f�r ein nicht-nummerisches Feld '
		 + 'gibt die Anzahl der Datens�tze f�r jede Gruppe '
		 + 'des Feldes ~{1~} aus. '
    qbf-lang[ 9] = 'Wenn Sie f�r ein Feld keine Summenbildung angegeben haben, '
		 + 'erscheint der Wert des letzten Datensatzes der jeweiligen '
		 + 'Gruppe. '

    /* r-page.p */
    qbf-lang[26] = 'Seitenvorschub'
    qbf-lang[27] = "ohne Seitenvorschub"

    qbf-lang[28] = 'Sobald sich eines der nachfolgenden Fel-'
    qbf-lang[29] = 'der inhaltlich �ndert, kann der Bericht '
    qbf-lang[30] = 'automatisch einen Seitenvorschub aus-'
    qbf-lang[31] = 'f�hren. W�hlen Sie ein Feld, nach dem '
    qbf-lang[32] = 'ein Seitenvorschub gemacht werden soll.'.

/*--------------------------------------------------------------------------*/

RETURN.

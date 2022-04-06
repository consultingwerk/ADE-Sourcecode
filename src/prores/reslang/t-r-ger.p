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
    qbf-lang[ 1] = 'Text oder Ausdruck fÅr: '
    qbf-lang[ 2] = 'Zeile' /* must be < 8 characters */
		   /* 3..7 are format x(64) */
    qbf-lang[ 3] = 'Diese Funktionen kînnen in Kopf- und Fu·zeilen '
		 + 'verwendet werden'
    qbf-lang[ 4] = '~{COUNT~} Anzahl SÑtze bisher     :  '
		 + '~{TIME~}  Startzeit Bericht '
    qbf-lang[ 5] = '~{TODAY~}  aktuelles Datum        :  '
		 + '~{NOW~}   aktuelle Zeit'
    qbf-lang[ 6] = '~{PAGE~}   aktuelle Seitenzahl    :  '
		 + '~{USER~}  Benutzerkennung'
    qbf-lang[ 7] = '~{VALUE <Feld>~;<Format>~} EinfÅgen von '
		 + 'Variablen mit [' + KBLABEL("GET") + ']'
    qbf-lang[ 8] = 'Auswahl des einzufÅgenden Feldes'
    qbf-lang[ 9] = '[' + KBLABEL("GO") + '] Sichern, ['
		 + KBLABEL("GET") + '] Feld einfÅgen, ['
		 + KBLABEL("END-ERROR") + '] Abbrechen.'

/*r-total.p*/    /*"|---------------------------|"*/
    qbf-lang[12] = 'wird Folgendes ausgegeben:'
		 /*"|--------------------------------------------|"*/
    qbf-lang[13] = 'wenn sich die Feldinhalte Ñndern bei:'
		 /*"|---| |---| |---| |---| |---|" */
    qbf-lang[14] = '-Ges- -Anz- -Min- -Max- -Mit-'
    qbf-lang[15] = 'Gesamtsumme'
    qbf-lang[16] = 'FÅr das Feld'
    qbf-lang[17] = 'Feldauswahl fÅr Summenbildung'

/*r-calc.p*/
    qbf-lang[18] = 'Feldauswahl fÅr: Aufsummierung'
    qbf-lang[19] = 'Feldauswahl fÅr: Anteil in %'
    qbf-lang[20] = 'Aufsummierung'
    qbf-lang[21] = 'Anteil in %'
    qbf-lang[22] = 'Text-,Datum-,Logisch.-,Math.-,Num.-'
    qbf-lang[23] = 'Ausdruck'
    qbf-lang[24] = 'Zahl, mit der angefangen werden soll zu zÑhlen.'
    qbf-lang[25] = '(Negative) Zahl, mit der stufenweise ab/aufwÑrts gezÑhlt '
		 + 'wird.'
    qbf-lang[26] = 'ZÑhler'
    qbf-lang[27] = 'ZÑhler'
		 /*"------------------------------|"*/
    qbf-lang[28] = '       Startzahl fÅr den ZÑhler' /*right justify*/
    qbf-lang[29] = '   bei jedem Satz hochzÑhlen um' /*right justify*/
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
    qbf-lang[ 8] = 'Zeilen zw. Haupt- und Fu·teil'
		  /*1234567890123456789012345678901*/
    qbf-lang[ 9] = 'Randeinstellung/Spaltenabstand'
    qbf-lang[10] = 'ZulÑssig sind Zeilenzahlen zwischen 1 und einer SeitenlÑnge'
    qbf-lang[11] = 'Bitte keine negative SeitenlÑnge angeben.'
    qbf-lang[12] = 'Die Spalte, in der der Bericht anfÑngt, mu· 1 oder grî·er '
		 + 'sein.'
    qbf-lang[13] = 'Bitte geben Sie einen zulÑssigen Wert ein.'
    qbf-lang[14] = 'Die Zeile, in der der Bericht anfÑngt, mu· 1 oder grî·er '
		 + 'sein.'

/*r-set.p*/        /* format x(30) for 15..22 */
    qbf-lang[15] = 'F.  Feldbez. und -format'
    qbf-lang[16] = 'SV. Seitenvorschub'
    qbf-lang[17] = 'SB. Summenberichte'
    qbf-lang[18] = 'RS. RÑnder/Spaltenabstand'
    qbf-lang[19] = 'KL. Kopfzeile links'
    qbf-lang[20] = 'KM. Kopfzeile mitte'
    qbf-lang[21] = 'KR. Kopfzeile rechts'
    qbf-lang[22] = 'FL. Fu·zeile links'
    qbf-lang[23] = 'FM. Fu·zeile mitte'
    qbf-lang[24] = 'FR. Fu·zeile rechts'
    qbf-lang[25] = 'ES. Kopftext (erste Seite)'
    qbf-lang[26] = 'LS. Fu·text (letzte Seite)'
    qbf-lang[32] = '[' + KBLABEL("END-ERROR")
		 + '] nach Abschlu· aller énderungen.'.

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
		 + 'Bildschirm gelîscht werden?'
    qbf-lang[10] = 'Das Programm fÅr den Bericht wird erzeugt ...'
    qbf-lang[11] = 'Das Programm fÅr den Bericht wird kompiliert...'
    qbf-lang[12] = 'Das Programm fÅr den Bericht wird ausgefÅhrt...'
    qbf-lang[13] = 'Keine Schreibrechte fÅr die Datei bzw. das GerÑt'
    qbf-lang[14] = 'Soll der Bildschirm wirklich gelîscht werden?'
    qbf-lang[15] = 'Wollen Sie das Modul "Bericht" wirklich verlassen?'
    qbf-lang[16] = '['
		 + (IF KBLABEL("CURSOR-UP") BEGINS "CTRL-" THEN 'CURSOR-UP'
		   ELSE KBLABEL("CURSOR-UP"))
		 + '] und ['
		 + (IF KBLABEL("CURSOR-DOWN") BEGINS "CTRL-" THEN 'CURSOR-DOWN'
		   ELSE KBLABEL("CURSOR-DOWN"))
		 + '] zum BlÑttern, ['
		 + KBLABEL("END-ERROR") + '] Ende.'
    qbf-lang[17] = 'Seite'
    qbf-lang[18] = '~{1~} SÑtze wurden im Bericht ausgegeben.'
    qbf-lang[19] = 'Geht nicht! Ein Summenbericht kann nur erstellt werden, '
		 + 'wenn eine Sortierreihenfolge nach Gruppen (Order) '
		 + 'angegeben wurde.'
    qbf-lang[20] = 'Geht nicht! Ein Summenbericht kann nur fÅr Felder '
		 + 'erstellt werden, die keine Listenelemente (ARRAY) '
		 + 'in tabellarischer Form enthalten.'
    qbf-lang[21] = 'Summenbericht'
    qbf-lang[23] = 'Sie mÅssen erst Felder definieren, bevor der Bericht '
		 + 'erstellt werden kann.'.

ELSE

/*--------------------------------------------------------------------------*/
/* FAST TRACK interface test for r-ft.p r-ftsub.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = 'FAST TRACK fÅhrt keine Terminalausgabe aus, wenn '
    qbf-lang[ 2] = 'Selektionsdaten gefragt sind. Ausgabemedium ist Drucker.'
    qbf-lang[ 3] = 'Analyse der Kopf- und Fu·zeilen...'
    qbf-lang[ 4] = 'Gruppenbildung...'
    qbf-lang[ 5] = 'Aufbau der Felder und Aggregate...'
    qbf-lang[ 6] = 'Aufbau der Dateien und WHERE-Bedingungen...'
    qbf-lang[ 7] = 'Aufbau der Kopf- und Fu·zeilen...'
    qbf-lang[ 8] = 'Aufbau der Zeilen im Bericht ...'
    qbf-lang[ 9] = 'Es gibt in FAST TRACK schon einen Bericht mit dem Namen '
		 + '~{1~}. Soll der Bericht Åberschrieben werden?'
    qbf-lang[10] = 'Der Bericht wird Åberschrieben ...'
    qbf-lang[11] = 'Wollen Sie FAST TRACK jetzt starten?'
    qbf-lang[12] = 'Bitte einen Namen eingeben'
    qbf-lang[13] = 'FAST TRACK kennt die Funktion TIME in Kopf/Fu·zeilen '
		 + 'nicht. Ersetzt durch NOW.'
    qbf-lang[14] = 'FAST TRACK kann "%" nicht berechnen. Das Feld '
		 + 'wird ausgelassen.'
    qbf-lang[15] = 'FAST TRACK kennt ~{1~} in Kopf/Fu·zeilen nicht, '
		 + '~{2~} wird ausgelassen.'
    qbf-lang[16] = 'Berichtsnamen dÅrfen nur alphanummerische Zeichen und '
		 + 'Unterstriche beinhalten.'
    qbf-lang[17] = 'Name des Berichts in FAST TRACK:'
    qbf-lang[18] = 'Der Bericht wurde nicht nach FAST TRACK Åbertragen'
    qbf-lang[19] = 'FAST TRACK wird gestartet, bitte warten ...'
    qbf-lang[20] = 'Kopf/Fu·zeile hat unpassende geschweifte Klammern, '
		 + 'Bericht NICHT Åbertragbar.'
    qbf-lang[21] = 'FAST TRACK kennt keinen speziellen Kopftext fÅr '
		 + 'die erste/letzte Seite.'
    qbf-lang[22] = 'ACHTUNG: FÅr den ZÑhler wird Startzahl ~{1~} verwendet.'
    qbf-lang[23] = 'INHALTE'
    qbf-lang[24] = 'TOTAL,COUNT,MAX,MIN,AVG'
    qbf-lang[25] = 'FAST TRACK fÅhrt keine Summenberichte aus. '
		 + 'Der Bericht ist nicht Åbertragbar.'
    qbf-lang[26] = 'Ohne Datei- und Felddefinitionen kann der Bericht nicht '
		 + 'Åbertragen werden.'.


ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 5 THEN
  ASSIGN
    /* r-short.p */
    qbf-lang[ 1] = 'Der Bericht ist kaum ausfÅhrbar, '
		 + 'wenn alle Summen angezeigt wÅrden. Es kann aber '
		 + 'jeweils eine neue Summenzeile ausgegeben werden, wenn sich '
		 + 'das letzte Feld der angegebenen Sortierreihenfolge (Order) '
		 + 'Ñndert. '
		 + '^In dem Bericht erscheint also eine neue Zeile, wenn '
		 + 'sich der Wert ~{1~} Ñndert.^Soll der Summenbericht so '
		 + 'erstellt werden? '
    qbf-lang[ 2] = 'Ja'
    qbf-lang[ 3] = 'Nein'
    qbf-lang[ 4] = 'Bitte legen Sie erst Felder fÅr die Sortierreihenfolge '
		 + '(Order) fest, bevor Sie die Option fÅr Summenberichte '
		 + 'auswÑhlen.^^Bearbeiten Sie im Berichtmodul '
		 + 'den Punkt "Order", um die Sortierfelder zu '
		 + 'bestimmen, bevor Sie an dieser Stelle weitermachen. '
    qbf-lang[ 5] = 'Liste aller Felder fÅr diesen Bericht. WÑhlen Sie die '
    qbf-lang[ 6] = 'Felder aus, die aufsummiert werden sollen. '
    qbf-lang[ 7] = 'Die Summenbildung fÅr ein nummerisches Feld '
		 + 'gibt eine Zwischensumme aus, wenn '
		 + 'sich der Wert des Feldes ~{1~} Ñndert. '
    qbf-lang[ 8] = 'Die Summenbildung fÅr ein nicht-nummerisches Feld '
		 + 'gibt die Anzahl der DatensÑtze fÅr jede Gruppe '
		 + 'des Feldes ~{1~} aus. '
    qbf-lang[ 9] = 'Wenn Sie fÅr ein Feld keine Summenbildung angegeben haben, '
		 + 'erscheint der Wert des letzten Datensatzes der jeweiligen '
		 + 'Gruppe. '

    /* r-page.p */
    qbf-lang[26] = 'Seitenvorschub'
    qbf-lang[27] = "ohne Seitenvorschub"

    qbf-lang[28] = 'Sobald sich eines der nachfolgenden Fel-'
    qbf-lang[29] = 'der inhaltlich Ñndert, kann der Bericht '
    qbf-lang[30] = 'automatisch einen Seitenvorschub aus-'
    qbf-lang[31] = 'fÅhren. WÑhlen Sie ein Feld, nach dem '
    qbf-lang[32] = 'ein Seitenvorschub gemacht werden soll.'.

/*--------------------------------------------------------------------------*/

RETURN.

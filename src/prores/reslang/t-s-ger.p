/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-s-ger.p - German language definitions for general system use */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/

/* l-edit.p,s-edit.p */
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Einf�g'
    qbf-lang[ 2] = 'Wollen Sie hier wirklich abbrechen, ohne '
		 + 'die �nderungen zu sichern?'
    qbf-lang[ 3] = 'Geben Sie den Namen der Datei ein (merge) '
    qbf-lang[ 4] = 'Geben Sie den Begriff ein, nach dem gesucht werden soll.'
    qbf-lang[ 5] = 'Bitte Feld ausw�hlen:'
    qbf-lang[ 6] = '[' + KBLABEL("GO") + '] Sichern, ['
		 + KBLABEL("GET") + '] Feld ausw�hlen, ['
		 + KBLABEL("END-ERROR") + '] Abbrechen.'
    qbf-lang[ 7] = 'Der Suchbegriff wurde nicht gefunden.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-ask.p,s-where.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'gleich'
    qbf-lang[ 2] = 'ungleich'
    qbf-lang[ 3] = 'kleiner als'
    qbf-lang[ 4] = 'kleiner o.gleich'
    qbf-lang[ 5] = 'gr��er als'
    qbf-lang[ 6] = 'gr��er o. gleich'
    qbf-lang[ 7] = 'beginnt mit'
    qbf-lang[ 8] = 'beinhaltet'    /* must match [r.4.23] */
    qbf-lang[ 9] = 'identisch mit'

    qbf-lang[10] = 'Feldauswahl'
    qbf-lang[11] = 'Bedingung'
    qbf-lang[12] = 'Wert eingeben'
    qbf-lang[13] = 'Vergleich'

    qbf-lang[14] = 'Der Wert wird vom Benutzer w�hrend der Laufzeit '
		 + 'abgefragt.'
    qbf-lang[15] = 'Die Aufforderung an den Benutzer, den Wert einzugeben, '
		 + 'soll lauten:'

    qbf-lang[16] = 'Datentyp f. Eingabe:' /* data-type */
    qbf-lang[17] = ''

    qbf-lang[18] = '[' + KBLABEL("END-ERROR") + '] Abbrechen'
    qbf-lang[19] = '[' + KBLABEL("END-ERROR") + '] Letzen Schritt r�ckg�ngig '
		 + 'machen'
    qbf-lang[20] = '[' + KBLABEL("GET") + '] f�r Experten-Modus'

    qbf-lang[21] = 'W�hlen Sie die Vergleichsfunktion f�r dieses Feld.'

    qbf-lang[22] = 'Datentyp-Auswahl: ~{1~} f�r den Vergleich mit Feld "~{2~}".'
    qbf-lang[23] = 'Bitte geben Sie einen "~{1~}" Wert f.d. Vergleich m. Feld'
		 + ' "~{2~}" ein.'
    qbf-lang[24] = '[' + KBLABEL("PUT")
		 + '] der Wert wird beim Programmaufruf abgefragt.'
    qbf-lang[25] = 'Zusammenhang: ~{1~} ist ~{2~}  ~{3~}.'

    qbf-lang[27] = 'Sie k�nnen entweder mit dem '
		 + 'Expertenmodus arbeiten, oder nach dem Wert w�hrend '
		 + 'der Laufzeit fragen, aber nicht beides gleichzeitig.'
    qbf-lang[28] = 'Mu� nicht der unbekannte Wert sein!'
    qbf-lang[29] = 'Wollen Sie weitere Bedingungen eingeben f�r'
		    /* '?' append to string */
    qbf-lang[30] = 'Wollen Sie jetzt noch f�r andere Felder Bedingungen '
		 + 'eingeben?'
    qbf-lang[31] = 'Verkn�pfung mit der vorherigen Bedingung durch ...?'
    qbf-lang[32] = 'Experten-Modus'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 3 THEN
  ASSIGN
/* s-info.p, s-format.p */
    qbf-lang[ 1] = 'sortiert nach'
    /* s-info.p automatically right-justifies */
    qbf-lang[ 2] = 'und nach'    /*   1..9 and adds colons for you. */
    qbf-lang[ 3] = 'Datei'      /* but must fit in format x(24) */
    qbf-lang[ 4] = 'Verkn�pfung'
    qbf-lang[ 5] = 'wobei'
    qbf-lang[ 6] = 'Feld'
    qbf-lang[ 7] = 'Bedingung'
    qbf-lang[ 9] = 'Wdh. Werte unterdr�cken?'

    qbf-lang[10] = 'FROM,BY,FOR'
    qbf-lang[11] = 'Sie haben noch keine Dateien ausgew�hlt!'
    qbf-lang[12] = 'Format und Bezeichnung'
    qbf-lang[13] = 'Formate'
    qbf-lang[14] = 'Feldauswahl' /* also used by s-calc.p below */
    /* 15..18 must be format x(16) (see notes on 1..7) */
    qbf-lang[15] = 'Bezeichnung'
    qbf-lang[16] = 'Format'
    qbf-lang[17] = 'Datenbank'
    qbf-lang[18] = 'Datentyp'
    qbf-lang[19] = 'Zeitbedarf der letzten Ausf�hrung, Minuten:Sekunden'
    qbf-lang[20] = 'Symbol "?" f�r einen unbekannten Wert hier nicht erlaubt!'

/*s-calc.p*/ /* there are many more for s-calc.p, see qbf-s = 5 thru 8 */
/*s-calc.p also uses #14 */
    qbf-lang[27] = 'Aufbau von Ausdr�cken'
    qbf-lang[28] = 'Ausdruck'
    qbf-lang[29] = 'Wollen Sie diesen Ausdruck noch erweitern?'
    qbf-lang[30] = 'Bitte Funktion ausw�hlen'
    qbf-lang[31] = 'Aktuelles Tagesdatum'
    qbf-lang[32] = 'Konstante'.

ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 4 THEN
  ASSIGN
/*s-help.p*/
    qbf-lang[ 1] = 'F�r diese Option ist leider keine Hilfe verf�gbar.'
    qbf-lang[ 2] = 'Hilfe'

/*s-order.p*/
    qbf-lang[15] = 'asc/desc' /*neither can be over 8 characters */
    qbf-lang[16] = 'F�r jede Komponente "a" f�r aufsteigend/ascending'
    qbf-lang[17] = ' oder "d" f�r absteigend/descending eingeben:'

/*s-define.p*/
    qbf-lang[21] = 'B. Bez./Format/Wdh.'
    qbf-lang[22] = 'F. Felder ausw�hlen'
    qbf-lang[23] = 'D. Dateien ausw�hlen'
    qbf-lang[24] = 'S. Summen (Gruppen/Gesamt)'
    qbf-lang[25] = 'A. Aufsummierung'
    qbf-lang[26] = 'P. Prozentanteil %'
    qbf-lang[27] = 'Z. Z�hler'
    qbf-lang[28] = 'M. Math. Ausdruck'
    qbf-lang[29] = 'T. Textausdruck'
    qbf-lang[30] = 'N. Nummer. Ausdruck'
    qbf-lang[31] = 'K. Kalenderfunktionen'
    qbf-lang[32] = 'L. Logischer Ausdruck'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - string expressions */
IF qbf-s = 5 THEN
  ASSIGN
    qbf-lang[ 1] = 's,Konstante oder Feld,s00=s24,~{1~}'
    qbf-lang[ 2] = 's,Bestimmte Zeichenfolge,s00=s25n26n27,SUBSTRING(~{1~}'
		 + ';INTEGER(~{2~});INTEGER(~{3~}))'
    qbf-lang[ 3] = 's,2 Zeichenketten kombinieren,s00=s28s29,~{1~} + ~{2~}'
    qbf-lang[ 4] = 's,3 Zeichenketten kombinieren,s00=s28s29s29,'
		 + '~{1~} + ~{2~} + ~{3~}'
    qbf-lang[ 5] = 's,4 Zeichenketten kombinieren,s00=s28s29s29s29,'
		 + '~{1~} + ~{2~} + ~{3~} + ~{4~}'
    qbf-lang[ 6] = 's,K�rzere v.2 Zeichenketten,s00=s30s31,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 's,L�ngere v.2 Zeichenketten,s00=s30s31,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 8] = 's,L�nge einer Zeichenkette,n00=s32,LENGTH(~{1~})'
    qbf-lang[ 9] = 's,Benutzerkennung,s00=,USERID("RESULTSDB")'
    qbf-lang[10] = 's,Aktuelle Zeit als Text,s00=,STRING(TIME;"HH:MM:SS")'

    qbf-lang[24] = 'Textfeld ausw�hlen, um eine Berichtspalte '
		 + 'einzuf�gen, oder <<Konstante>>, um einen '
		 + 'konstanten Zeichenwert in den Bericht einzuf�gen.'
    qbf-lang[25] = 'SUBSTRING erm�glicht Ihnen, eine bestimmte Zeichenfolge '
		 + 'in einer Zeichenkette zu suchen. W�hlen Sie ein '
		 + 'Feld, in dem gesucht werden soll.'
    qbf-lang[26] = 'Eingabe der Zeichenposition, ab der gesucht werden soll.'
    qbf-lang[27] = 'Wieviele Zeichen sollen ab Startposition durchsucht werden?'
    qbf-lang[28] = 'W�hlen Sie den ersten Wert f.d. Verkn�pfung'
    qbf-lang[29] = 'W�hlen Sie den n�chsten Wert f.d. Verkn�pfung'
    qbf-lang[30] = 'Auswahl des ersten Wertes f�r den Vergleich'
    qbf-lang[31] = 'Auswahl des zweiten Wertes f�r den Vergleich'
    qbf-lang[32] = 'Wert, dessen Zeichenl�nge gemessen werden soll.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - numeric expressions */
IF qbf-s = 6 THEN
  ASSIGN
    qbf-lang[ 1] = 'n,Konstante oder Feld,n00=n26,~{1~}'
    qbf-lang[ 2] = 'n,Kleinere v. 2 Werten,n00=n24n25,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 3] = 'n,Gr��ere von 2 Werten,n00=n24n25,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 4] = 'n,Rest ermitteln,n00=n31n32,~{1~} MODULO ~{2~}'
    qbf-lang[ 5] = 'n,Absoluten Wert ausgeben,n00=n27,'
		 + '(IF ~{1~} < 0 THEN - ~{1~} ELSE ~{1~})'
    qbf-lang[ 6] = 'n,Gerundeten Wert ausgeben,n00=n28,ROUND(~{1~};0)'
    qbf-lang[ 7] = 'n,Wert ohne Nachkomma,n00=n29,TRUNCATE(~{1~};0)'
    qbf-lang[ 8] = 'n,Wurzel berechnen,n00=n30,SQRT(~{1~})'
    qbf-lang[ 9] = 'n,Zeitformat,s00=n23,STRING(INTEGER(~{1~});"HH:MM:SS")'

    qbf-lang[23] = 'Auswahl eines Feldes mit Anzeigeformat HH:MM:SS'
    qbf-lang[24] = 'Auswahl des ersten Wertes f�r den Vergleich'
    qbf-lang[25] = 'Auswahl des zweiten Wertes f�r den Vergleich'
    qbf-lang[26] = 'Feld ausw�hlen, um eine Berichtspalte einzuf�gen, oder'
		 + ' <<Konstante>>, um einen '
		 + 'konstanten nummerischen Wert in den Bericht einzuf�gen.'
    qbf-lang[27] = 'W�hlen Sie ein Feld aus, da� als absoluter Wert (ohne '
		 + 'Vorzeichen) dargestellt werden soll.'
    qbf-lang[28] = 'Der Wert, den Sie w�hlen, wird auf die n�chste ganze '
		 + 'Zahl gerundet.'
    qbf-lang[29] = 'Der Wert, den Sie w�hlen, wird ohne Nachkommastellen '
		 + 'ausgegeben.'
    qbf-lang[30] = 'Auswahl eines Feldes zum Wurzelziehen.'
    qbf-lang[31] = 'Nach Teilung einer Zahl durch einen Quotienten bleibt ein '
		 + 'Rest. F�r welche Werte soll die Berechnung gemacht werden?'
    qbf-lang[32] = 'Durch was soll geteilt werden?'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - date expressions */
IF qbf-s = 7 THEN
  ASSIGN
    qbf-lang[ 1] = 'd,Aktuelles Tagesdatum,d00=,TODAY'
    qbf-lang[ 2] = 'd,Tage zum Datum addieren,d00=d22n23,~{1~} + ~{2~}'
    qbf-lang[ 3] = 'd,Tage vom Datum subtrahieren,d00=d22n24,~{1~} - ~{2~}'
    qbf-lang[ 4] = 'd,Anzahl Tage zwischen zwei Daten,n00=d25d26,~{1~} - ~{2~}'
    qbf-lang[ 5] = 'd,Das Fr�here v. zwei Daten,d00=d20d21,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 6] = 'd,Das Sp�tere v. zwei Daten,d00=d20d21,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 'd,Tag "n" vom Monat,n00=d27,DAY(~{1~})'
    qbf-lang[ 8] = 'd,Monat "n" des Jahres,n00=d28,MONTH(~{1~})'
    qbf-lang[ 9] = 'd,Name des Monats,s00=d29,ENTRY(MONTH(~{1~});"Januar'
		 + ';Februar;M�rz;April;Mai;Juni;Juli;August;September'
		 + ';Oktober;November;Dezember")'
    qbf-lang[10] = 'd,Jahr,n00=d30,YEAR(~{1~})'
    qbf-lang[11] = 'd,Tag "n" der Woche,n00=d31,WEEKDAY(~{1~})'
    qbf-lang[12] = 'd,Name d. Wochentags,s00=d32,ENTRY(WEEKDAY(~{1~});"'
		 + 'Sonntag;Montag;Dienstag;Mittwoch;Donnerstag;Frei'
		 + 'tag;Samstag")'
    qbf-lang[20] = 'Auswahl des ersten Datums f�r den Vergleich'
    qbf-lang[21] = 'Auswahl des zweiten Datums f�r den Vergleich'
    qbf-lang[22] = 'W�hlen Sie ein "Datum"-Feld.'
    qbf-lang[23] = 'W�hlen Sie das Feld mit der Tageszahl, die zu dem '
		 + 'Datum hinzugez�hlt werden soll.'
    qbf-lang[24] = 'W�hlen Sie das Feld mit der Tageszahl, die von dem '
		 + 'Datum abgezogen werden soll.'
    qbf-lang[25] = 'Zwei "Datum"-Werte werden verglichen. Der Unterschied '
		 + 'in Tagen wird angezeigt. Bitte w�hlen Sie das '
		 + 'erste Datum.'
    qbf-lang[26] = 'W�hlen Sie den zweiten "Datum"-Wert f�r den Vergleich.'
    qbf-lang[27] = 'Tag eines Monats als Zahl zwischen 1 und 31.'
    qbf-lang[28] = 'Monat eines Jahres als Zahl zwischen 1 und 12.'
    qbf-lang[29] = 'Der Monatsname wird ausgegeben.'
    qbf-lang[30] = 'Die Jahreszahl aus einem "Datum"-Feld wird ausgegeben.'
    qbf-lang[31] = 'Tag in der Woche als Zahl zwischen 1 und 7, angefangen mit '
		 + 'Sonntag als 1.'
    qbf-lang[32] = 'Der Name des Wochentags wird ausgegeben.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - mathematical expressions */
IF qbf-s = 8 THEN
  ASSIGN
    qbf-lang[ 1] = 'm,Addieren,n00=n25n26m...,~{1~} + ~{2~}'
    qbf-lang[ 2] = 'm,Subtrahieren,n00=n25n27m...,~{1~} - ~{2~}'
    qbf-lang[ 3] = 'm,Multiplizieren,n00=n28n29m...,~{1~} * ~{2~}'
    qbf-lang[ 4] = 'm,Dividieren,n00=n30n31m...,~{1~} / ~{2~}'
    qbf-lang[ 5] = 'm,Potenzieren,n00=n25n32m...,EXP(~{1~};~{2~})'

    qbf-lang[25] = 'Ersten Wert eingeben'
    qbf-lang[26] = 'N�chster Wert, der addiert werden soll'
    qbf-lang[27] = 'N�chster Wert, der subtrahiert werden soll'
    qbf-lang[28] = 'Ersten Multiplikator eingeben'
    qbf-lang[29] = '(N�chsten) Multiplikator eingeben'
    qbf-lang[30] = 'Quotient (Wert, der geteilt werden soll) eingeben'
    qbf-lang[31] = 'Divisor (Wert, durch den geteilt werden soll) eingeben'
    qbf-lang[32] = 'Potenzfaktor (Zahl, mit der potenziert wird) eingeben'.

/*--------------------------------------------------------------------------*/

RETURN.

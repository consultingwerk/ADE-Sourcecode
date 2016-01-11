/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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
    qbf-lang[ 1] = 'EinfÅg'
    qbf-lang[ 2] = 'Wollen Sie hier wirklich abbrechen, ohne '
		 + 'die énderungen zu sichern?'
    qbf-lang[ 3] = 'Geben Sie den Namen der Datei ein (merge) '
    qbf-lang[ 4] = 'Geben Sie den Begriff ein, nach dem gesucht werden soll.'
    qbf-lang[ 5] = 'Bitte Feld auswÑhlen:'
    qbf-lang[ 6] = '[' + KBLABEL("GO") + '] Sichern, ['
		 + KBLABEL("GET") + '] Feld auswÑhlen, ['
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
    qbf-lang[ 5] = 'grî·er als'
    qbf-lang[ 6] = 'grî·er o. gleich'
    qbf-lang[ 7] = 'beginnt mit'
    qbf-lang[ 8] = 'beinhaltet'    /* must match [r.4.23] */
    qbf-lang[ 9] = 'identisch mit'

    qbf-lang[10] = 'Feldauswahl'
    qbf-lang[11] = 'Bedingung'
    qbf-lang[12] = 'Wert eingeben'
    qbf-lang[13] = 'Vergleich'

    qbf-lang[14] = 'Der Wert wird vom Benutzer wÑhrend der Laufzeit '
		 + 'abgefragt.'
    qbf-lang[15] = 'Die Aufforderung an den Benutzer, den Wert einzugeben, '
		 + 'soll lauten:'

    qbf-lang[16] = 'Datentyp f. Eingabe:' /* data-type */
    qbf-lang[17] = ''

    qbf-lang[18] = '[' + KBLABEL("END-ERROR") + '] Abbrechen'
    qbf-lang[19] = '[' + KBLABEL("END-ERROR") + '] Letzen Schritt rÅckgÑngig '
		 + 'machen'
    qbf-lang[20] = '[' + KBLABEL("GET") + '] fÅr Experten-Modus'

    qbf-lang[21] = 'WÑhlen Sie die Vergleichsfunktion fÅr dieses Feld.'

    qbf-lang[22] = 'Datentyp-Auswahl: ~{1~} fÅr den Vergleich mit Feld "~{2~}".'
    qbf-lang[23] = 'Bitte geben Sie einen "~{1~}" Wert f.d. Vergleich m. Feld'
		 + ' "~{2~}" ein.'
    qbf-lang[24] = '[' + KBLABEL("PUT")
		 + '] der Wert wird beim Programmaufruf abgefragt.'
    qbf-lang[25] = 'Zusammenhang: ~{1~} ist ~{2~}  ~{3~}.'

    qbf-lang[27] = 'Sie kînnen entweder mit dem '
		 + 'Expertenmodus arbeiten, oder nach dem Wert wÑhrend '
		 + 'der Laufzeit fragen, aber nicht beides gleichzeitig.'
    qbf-lang[28] = 'Mu· nicht der unbekannte Wert sein!'
    qbf-lang[29] = 'Wollen Sie weitere Bedingungen eingeben fÅr'
		    /* '?' append to string */
    qbf-lang[30] = 'Wollen Sie jetzt noch fÅr andere Felder Bedingungen '
		 + 'eingeben?'
    qbf-lang[31] = 'VerknÅpfung mit der vorherigen Bedingung durch ...?'
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
    qbf-lang[ 4] = 'VerknÅpfung'
    qbf-lang[ 5] = 'wobei'
    qbf-lang[ 6] = 'Feld'
    qbf-lang[ 7] = 'Bedingung'
    qbf-lang[ 9] = 'Wdh. Werte unterdrÅcken?'

    qbf-lang[10] = 'FROM,BY,FOR'
    qbf-lang[11] = 'Sie haben noch keine Dateien ausgewÑhlt!'
    qbf-lang[12] = 'Format und Bezeichnung'
    qbf-lang[13] = 'Formate'
    qbf-lang[14] = 'Feldauswahl' /* also used by s-calc.p below */
    /* 15..18 must be format x(16) (see notes on 1..7) */
    qbf-lang[15] = 'Bezeichnung'
    qbf-lang[16] = 'Format'
    qbf-lang[17] = 'Datenbank'
    qbf-lang[18] = 'Datentyp'
    qbf-lang[19] = 'Zeitbedarf der letzten AusfÅhrung, Minuten:Sekunden'
    qbf-lang[20] = 'Symbol "?" fÅr einen unbekannten Wert hier nicht erlaubt!'

/*s-calc.p*/ /* there are many more for s-calc.p, see qbf-s = 5 thru 8 */
/*s-calc.p also uses #14 */
    qbf-lang[27] = 'Aufbau von AusdrÅcken'
    qbf-lang[28] = 'Ausdruck'
    qbf-lang[29] = 'Wollen Sie diesen Ausdruck noch erweitern?'
    qbf-lang[30] = 'Bitte Funktion auswÑhlen'
    qbf-lang[31] = 'Aktuelles Tagesdatum'
    qbf-lang[32] = 'Konstante'.

ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 4 THEN
  ASSIGN
/*s-help.p*/
    qbf-lang[ 1] = 'FÅr diese Option ist leider keine Hilfe verfÅgbar.'
    qbf-lang[ 2] = 'Hilfe'

/*s-order.p*/
    qbf-lang[15] = 'asc/desc' /*neither can be over 8 characters */
    qbf-lang[16] = 'FÅr jede Komponente "a" fÅr aufsteigend/ascending'
    qbf-lang[17] = ' oder "d" fÅr absteigend/descending eingeben:'

/*s-define.p*/
    qbf-lang[21] = 'B. Bez./Format/Wdh.'
    qbf-lang[22] = 'F. Felder auswÑhlen'
    qbf-lang[23] = 'D. Dateien auswÑhlen'
    qbf-lang[24] = 'S. Summen (Gruppen/Gesamt)'
    qbf-lang[25] = 'A. Aufsummierung'
    qbf-lang[26] = 'P. Prozentanteil %'
    qbf-lang[27] = 'Z. ZÑhler'
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
    qbf-lang[ 6] = 's,KÅrzere v.2 Zeichenketten,s00=s30s31,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 's,LÑngere v.2 Zeichenketten,s00=s30s31,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 8] = 's,LÑnge einer Zeichenkette,n00=s32,LENGTH(~{1~})'
    qbf-lang[ 9] = 's,Benutzerkennung,s00=,USERID("RESULTSDB")'
    qbf-lang[10] = 's,Aktuelle Zeit als Text,s00=,STRING(TIME;"HH:MM:SS")'

    qbf-lang[24] = 'Textfeld auswÑhlen, um eine Berichtspalte '
		 + 'einzufÅgen, oder <<Konstante>>, um einen '
		 + 'konstanten Zeichenwert in den Bericht einzufÅgen.'
    qbf-lang[25] = 'SUBSTRING ermîglicht Ihnen, eine bestimmte Zeichenfolge '
		 + 'in einer Zeichenkette zu suchen. WÑhlen Sie ein '
		 + 'Feld, in dem gesucht werden soll.'
    qbf-lang[26] = 'Eingabe der Zeichenposition, ab der gesucht werden soll.'
    qbf-lang[27] = 'Wieviele Zeichen sollen ab Startposition durchsucht werden?'
    qbf-lang[28] = 'WÑhlen Sie den ersten Wert f.d. VerknÅpfung'
    qbf-lang[29] = 'WÑhlen Sie den nÑchsten Wert f.d. VerknÅpfung'
    qbf-lang[30] = 'Auswahl des ersten Wertes fÅr den Vergleich'
    qbf-lang[31] = 'Auswahl des zweiten Wertes fÅr den Vergleich'
    qbf-lang[32] = 'Wert, dessen ZeichenlÑnge gemessen werden soll.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - numeric expressions */
IF qbf-s = 6 THEN
  ASSIGN
    qbf-lang[ 1] = 'n,Konstante oder Feld,n00=n26,~{1~}'
    qbf-lang[ 2] = 'n,Kleinere v. 2 Werten,n00=n24n25,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 3] = 'n,Grî·ere von 2 Werten,n00=n24n25,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 4] = 'n,Rest ermitteln,n00=n31n32,~{1~} MODULO ~{2~}'
    qbf-lang[ 5] = 'n,Absoluten Wert ausgeben,n00=n27,'
		 + '(IF ~{1~} < 0 THEN - ~{1~} ELSE ~{1~})'
    qbf-lang[ 6] = 'n,Gerundeten Wert ausgeben,n00=n28,ROUND(~{1~};0)'
    qbf-lang[ 7] = 'n,Wert ohne Nachkomma,n00=n29,TRUNCATE(~{1~};0)'
    qbf-lang[ 8] = 'n,Wurzel berechnen,n00=n30,SQRT(~{1~})'
    qbf-lang[ 9] = 'n,Zeitformat,s00=n23,STRING(INTEGER(~{1~});"HH:MM:SS")'

    qbf-lang[23] = 'Auswahl eines Feldes mit Anzeigeformat HH:MM:SS'
    qbf-lang[24] = 'Auswahl des ersten Wertes fÅr den Vergleich'
    qbf-lang[25] = 'Auswahl des zweiten Wertes fÅr den Vergleich'
    qbf-lang[26] = 'Feld auswÑhlen, um eine Berichtspalte einzufÅgen, oder'
		 + ' <<Konstante>>, um einen '
		 + 'konstanten nummerischen Wert in den Bericht einzufÅgen.'
    qbf-lang[27] = 'WÑhlen Sie ein Feld aus, da· als absoluter Wert (ohne '
		 + 'Vorzeichen) dargestellt werden soll.'
    qbf-lang[28] = 'Der Wert, den Sie wÑhlen, wird auf die nÑchste ganze '
		 + 'Zahl gerundet.'
    qbf-lang[29] = 'Der Wert, den Sie wÑhlen, wird ohne Nachkommastellen '
		 + 'ausgegeben.'
    qbf-lang[30] = 'Auswahl eines Feldes zum Wurzelziehen.'
    qbf-lang[31] = 'Nach Teilung einer Zahl durch einen Quotienten bleibt ein '
		 + 'Rest. FÅr welche Werte soll die Berechnung gemacht werden?'
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
    qbf-lang[ 5] = 'd,Das FrÅhere v. zwei Daten,d00=d20d21,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 6] = 'd,Das SpÑtere v. zwei Daten,d00=d20d21,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 'd,Tag "n" vom Monat,n00=d27,DAY(~{1~})'
    qbf-lang[ 8] = 'd,Monat "n" des Jahres,n00=d28,MONTH(~{1~})'
    qbf-lang[ 9] = 'd,Name des Monats,s00=d29,ENTRY(MONTH(~{1~});"Januar'
		 + ';Februar;MÑrz;April;Mai;Juni;Juli;August;September'
		 + ';Oktober;November;Dezember")'
    qbf-lang[10] = 'd,Jahr,n00=d30,YEAR(~{1~})'
    qbf-lang[11] = 'd,Tag "n" der Woche,n00=d31,WEEKDAY(~{1~})'
    qbf-lang[12] = 'd,Name d. Wochentags,s00=d32,ENTRY(WEEKDAY(~{1~});"'
		 + 'Sonntag;Montag;Dienstag;Mittwoch;Donnerstag;Frei'
		 + 'tag;Samstag")'
    qbf-lang[20] = 'Auswahl des ersten Datums fÅr den Vergleich'
    qbf-lang[21] = 'Auswahl des zweiten Datums fÅr den Vergleich'
    qbf-lang[22] = 'WÑhlen Sie ein "Datum"-Feld.'
    qbf-lang[23] = 'WÑhlen Sie das Feld mit der Tageszahl, die zu dem '
		 + 'Datum hinzugezÑhlt werden soll.'
    qbf-lang[24] = 'WÑhlen Sie das Feld mit der Tageszahl, die von dem '
		 + 'Datum abgezogen werden soll.'
    qbf-lang[25] = 'Zwei "Datum"-Werte werden verglichen. Der Unterschied '
		 + 'in Tagen wird angezeigt. Bitte wÑhlen Sie das '
		 + 'erste Datum.'
    qbf-lang[26] = 'WÑhlen Sie den zweiten "Datum"-Wert fÅr den Vergleich.'
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
    qbf-lang[26] = 'NÑchster Wert, der addiert werden soll'
    qbf-lang[27] = 'NÑchster Wert, der subtrahiert werden soll'
    qbf-lang[28] = 'Ersten Multiplikator eingeben'
    qbf-lang[29] = '(NÑchsten) Multiplikator eingeben'
    qbf-lang[30] = 'Quotient (Wert, der geteilt werden soll) eingeben'
    qbf-lang[31] = 'Divisor (Wert, durch den geteilt werden soll) eingeben'
    qbf-lang[32] = 'Potenzfaktor (Zahl, mit der potenziert wird) eingeben'.

/*--------------------------------------------------------------------------*/

RETURN.

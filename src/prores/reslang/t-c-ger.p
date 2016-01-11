/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-c-ger.p - German language definitions for Scrolling Lists */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*
As of [Thu Apr 25 15:13:33 EDT 1991], this
is a list of the scrolling list programs:
  u-browse.i     c-print.p
  b-pick.p       i-pick.p
  c-entry.p      i-zap.p
  c-field.p      s-field.p
  c-file.p       u-pick.p
  c-flag.p       u-print.p
  c-form.p
*/

/* c-entry.p,c-field.p,c-file.p,c-form.p,c-print.p,c-vector.p,s-field.p */
ASSIGN
  qbf-lang[ 1] = 'Erste Datei fr die Verknpfung ausw„hlen oder ['
	       + KBLABEL("END-ERROR") + '] zum Verlassen.'
  qbf-lang[ 2] = '[' + KBLABEL("GO") + '] Auswahlende, ['
	       + KBLABEL("INSERT-MODE") + '] Wechsel Bez./Name, ['
	       + KBLABEL("END-ERROR") + '] Abbruch.'
  qbf-lang[ 3] = '[' + KBLABEL("END-ERROR")
	       + '] beendet die Dateiauswahl.'
  qbf-lang[ 4] = '[' + KBLABEL("GO") + '] Auswahl beenden, ['
	       + KBLABEL("INSERT-MODE")
	       + '] Wechsel Bez/Dat/Progr.'
  qbf-lang[ 5] = 'Bez.-/Name-'
  qbf-lang[ 6] = 'Bez./Name'
  qbf-lang[ 7] = 'Datei,Progr,Bez. '
  qbf-lang[ 8] = 'Suche nach verfgbaren Feldern...'
  qbf-lang[ 9] = 'Felder ausw„hlen'
  qbf-lang[10] = 'Datei ausw„hlen'
  qbf-lang[11] = 'Verknpfte Dateien ausw„hlen'
  qbf-lang[12] = 'Abfragemaske ausw„hlen'
  qbf-lang[13] = 'Ausgabeziel ausw„hlen'
  qbf-lang[14] = 'verknpfen' /* should match t-q-eng.p "Join" string */
  qbf-lang[16] = '       Datenbank' /* max length 16 */
  qbf-lang[17] = '           Datei' /* max length 16 */
  qbf-lang[18] = '            Feld' /* max length 16 */
  qbf-lang[19] = 'Max.Feldeintr„ge'/* max length 16 */
  qbf-lang[20] = 'Der Wert'
  qbf-lang[21] = 'liegt nicht im Bereich von 1 bis'
  qbf-lang[22] = 'Die Datei gibt es schon. Sollen die neuen Daten angeh„ngt '
	       + 'werden? '
  qbf-lang[23] = 'Bitte geben Sie den Namen fr eine Datei ein, nicht fr ein '
	       + 'Ausgabeziel.'
  qbf-lang[24] = 'Bitte den Namen fr die Ausgabedatei eingeben'

	       /* 12345678901234567890123456789012345678901234567890 */

  qbf-lang[27] = 'Kein Eintrag: Alle Listenelemente werden unterein-'
  qbf-lang[28] = 'ander ausgegeben. Nummernliste einzelner Elemente,'
  qbf-lang[29] = 'durch Kommata getrennt: Neue Berichtspalten.'
  qbf-lang[30] = 'Jedes Element in der durch Kommata getrennten '
  qbf-lang[31] = 'Liste wird in einer eigenen Spalte ausgegeben.'
  qbf-lang[32] = 'Geben Sie die Listenelemente fr die Ausgabe ein'.

RETURN.

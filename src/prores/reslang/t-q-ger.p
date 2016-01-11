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
/* t-q-ger.p - German language definitions for Query module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Die Bedingungen werden von keinem Datensatz erfÅllt.'
    qbf-lang[ 2] = 'Alle,VerknÅpfung,Untermenge'
    qbf-lang[ 3] = 'Alle,Anfang..,Ende..'
    qbf-lang[ 4] = 'FÅr dies Datei sind keine Indizes definiert.'
    qbf-lang[ 5] = 'Wollen Sie diesen Datensatz wirklich lîschen?'
    qbf-lang[ 6] = '' /* special total message: created from #7 or #8 */
    qbf-lang[ 7] = 'Der ZÑhlvorgang ist abgebrochen.'
    qbf-lang[ 8] = 'Anzahl verfÅgbarer DatensÑtze ist '
    qbf-lang[ 9] = 'RESULTS zÑhlt gerade...   [' + KBLABEL("END-ERROR")
		 + '] unterbricht den Vorgang.'
    qbf-lang[10] = 'gleich,kleiner als,kleiner als oder gleich,'
		 + 'grî·er als,grî·er als oder gleich,'
		 + 'ungleich,vergleichbar mit,beginnt mit'
    qbf-lang[11] = 'FÅr diese Abfrage gibt es keine DatensÑtze.'
    qbf-lang[13] = 'Das ist schon der erste Satz der Datei.'
    qbf-lang[14] = 'Das ist schon der letzte Satz der Datei.'
    qbf-lang[15] = 'Es ist keine Abfragemaske aktiv.'
    qbf-lang[16] = 'Abfrage'
    qbf-lang[17] = 'Bitte wÑhlen Sie eine Abfragemaske aus.'
    qbf-lang[18] = '[' + KBLABEL("GO")
		 + '] oder [' + KBLABEL("RETURN")
		 + '] fÅr Maskenauswahl, [' + KBLABEL("END-ERROR")
		 + '] Abbrechen.'
    qbf-lang[19] = 'Laden der Abfragemaske...'
    qbf-lang[20] = 'Die Abfragemaske ist noch nicht kompiliert. '
		 + 'Mîgliche Ursachen:^1) falscher PROPATH,^2) .r-Datei fÅr die'
		 + ' Abfrage fehlt, oder^3) .r-Datei ist nicht kompiliert. '
		 + '^PrÅfen Sie die Datei <DBNAME>.ql auf Fehlermeldungen des '
		 + 'Kompilers.^^Sie kînnen auch weitermachen, es kann aber zu '
		 + 'Fehlermeldungen kommen. Wollen Sie '
		 + 'weitermachen?'
    qbf-lang[21] = 'In der aktuellen Abfragemaske ist eine WOBEI-Bedingung, die'
		 + ' Werte aus der Laufzeitumgebung Åbernimmt. Das wird im '
		 + 'Abfragemodul nicht unterstÅtzt. Soll die WOBEI-Bedingung '
		 + 'ignoriert und weitergemacht werden?'
    qbf-lang[22] = '[' + KBLABEL("GET")
		 + '] Andere Felder fÅr die Suchliste auswÑhlen.'.

ELSE

IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'NÑchster,NÑchster Satz.'
    qbf-lang[ 2] = 'Vorher,Vorheriger Satz.'
    qbf-lang[ 3] = 'Erster,Erster Satz.'
    qbf-lang[ 4] = 'YLetzt,Letzter Satz.'
    qbf-lang[ 5] = 'Hinzu,HinzufÅgen eines neuen Satzes.'
    qbf-lang[ 6] = 'éndern,éndern des angezeigten Satzes.'
    qbf-lang[ 7] = 'Kopie,Der akt. Satzinhalt wird in einen neuen Satz kopiert.'
    qbf-lang[ 8] = 'Lîsch,Der angezeigte Datensatz wird gelîscht.'
    qbf-lang[ 9] = 'ZeigAndere,Anzeige einer anderen Abfragemaske.'
    qbf-lang[10] = 'Durchsuch,Liste aller DatensÑtzen zum Durchsuchen.'
    qbf-lang[11] = 'XKnÅpf,Verbindung von verknÅpften Dateien.'
    qbf-lang[12] = 'Fragbsp,Auswahl von SÑtzen anhand eines Abfragebeispiels.'
    qbf-lang[13] = 'Wobei,Eingabe von Bedingungen (WHERE) fÅr die Satzauswahl'
    qbf-lang[14] = 'Anz,ZÑhlen der DatensÑtze in der aktuellen (Unter)gruppe'
    qbf-lang[15] = 'Order,énderung der Sortierreihenfolge (anderer Index).'
    qbf-lang[16] = 'Modul,Wechsel zu einem anderen Modul.'
    qbf-lang[17] = 'Info,Einzelheiten Åber die Parameter der aktuellen Maske.'
    qbf-lang[18] = 'Sonst,Aufruf einer in RESULTS eingebundenen Applikation.'
    qbf-lang[19] = 'Beende, Beenden der Abfrage.'
    qbf-lang[20] = ''. /* terminator */

RETURN.

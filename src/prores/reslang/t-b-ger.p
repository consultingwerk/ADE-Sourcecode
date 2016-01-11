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
/* t-b-ger.p - German language definitions for Build subsystem */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* b-build.p,b-again.p */
IF qbf-s = 1 THEN
  ASSIGN
		/* formats: x(10) x(45) x(8) */
    qbf-lang[ 1] = 'Programm,Datenbank und Datei,Zeit'
    qbf-lang[ 2] = 'Die Checkpoint-Datei ist defekt. L”schen Sie die .qc-Datei '
		 + 'und starten Sie erneut.'
    qbf-lang[ 3] = 'Bearbeitung    '   /*format x(15)*/
    qbf-lang[ 4] = 'Kompilierung   '   /*format x(15)*/
    qbf-lang[ 5] = 'Neukompilierung'   /*format x(15)*/
    qbf-lang[ 6] = 'Bearbeitung der Datei,Bearbeitung der Maske,Bearbeitung '
		 + 'des Programms'
    qbf-lang[ 7] = 'Alle Masken mit (*) werden erzeugt. ['
		 +  KBLABEL("RETURN") + '] setzt/l”scht einen Stern.'
    qbf-lang[ 8] = '[' + KBLABEL("GO") + '] nach Auswahlende, ['
		 + KBLABEL("END-ERROR") + '] Abbrechen.'
    qbf-lang[ 9] = 'Eine Liste fr die Abfragemasken wird erstellt...'
    qbf-lang[10] = 'Ist Ihre Abfragemaske jetzt fertig?'
    qbf-lang[11] = 'Suche nach eingebundenen OF-Verknpfungen.'
    qbf-lang[12] = 'Eine Liste mit den Verknpfungen wird erstellt.'
    qbf-lang[13] = 'Es konnten nicht alle Verbindungen lokalisiert werden.'
    qbf-lang[14] = 'Redundante (doppelte) Verknpfungen werden eleminiert.'
    qbf-lang[15] = 'Sind Sie sicher, daá Sie hier abbrechen wollen?'
    qbf-lang[16] = 'absolute Dauer,durchschn. Dauer'
    qbf-lang[17] = 'Einlesen der checkpoint-Datei...'
    qbf-lang[18] = 'Schreiben der checkpoint-Datei...'
    qbf-lang[19] = 'gibt es schon. RESULTS w„hlt deshalb'
    qbf-lang[20] = 'šberarbeitung der Datei'
    qbf-lang[21] = 'Prfung, ob die Maske "~{1~}" ge„ndert wurde.'
    qbf-lang[22] = 'Abfragemaske kann ohne RECID oder UNIQUE INDEX '
		 + 'nicht erstellt werden.'
    qbf-lang[23] = 'Die Maske ist nicht ge„ndert worden.'
    qbf-lang[24] = 'muá nicht neu kompiliert werden.'
    qbf-lang[25] = 'Kein Feld aktiv. Es wird keine Abfragemaske er'
		 + 'stellt.'
    qbf-lang[26] = 'Kein Feld aktiv. Bestehende Abfragemaske wird '
		 + 'gel”scht.'
    qbf-lang[27] = 'Die lesbare Dateiliste wird komprimiert.'
    qbf-lang[28] = 'absolute Zeitdauer'
    qbf-lang[29] = 'Fertig!'
    qbf-lang[30] = 'Die Kompilierung von "~{1~}" hat nicht funktioniert.'
    qbf-lang[31] = 'Schreiben der Konfigurationsdatei'
    qbf-lang[32] = 'W„hrend der Kompilierung und/oder Programmerstellung sind '
		 + 'Fehler aufgetreten.'
		 + '^^Drcken Sie eine beliebige Taste, um sich die Abfrage'
		 + 'logdatei anzuschauen. Zeilen, die Fehler beinhalten, '
		 + 'werden unterlegt dargestellt.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN

/* b-misc.p */
    /* 1..10 for qbf-l-auto[] */
    qbf-lang[ 1] = 'Anrede,*Anrede*,Name'
    qbf-lang[ 2] = '*Name*,Firma,*Liefer*,Address'
    qbf-lang[ 3] = '*Kontakt*,*Partner*,Address2'
    qbf-lang[ 4] = '*Anschr*,*Addr*,Abteilung,*Abt*'
    qbf-lang[ 5] = 'Straáe,*Str*,City'
    qbf-lang[ 6] = 'Postfach,*Postf*,St'
    qbf-lang[ 7] = 'PLZ,*PLZ*,Zip'
    qbf-lang[ 8] = 'Ort,Stadt,*Stadt*'
    qbf-lang[ 9] = 'PLZOrt,POrt'
    qbf-lang[10] = '*Land*,*Region*'

    qbf-lang[15] = 'Beisp. fr Datenexport'.

/*--------------------------------------------------------------------------*/

RETURN.

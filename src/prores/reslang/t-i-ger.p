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
/* t-i-ger.p - German language definitions for Directory */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*i-dir.p,i-pick.p,i-zap.p,a-info.p,i-read.p*/
ASSIGN
  qbf-lang[ 1] = 'Export,Graph,Etikett,Abfrage,Bericht'
  qbf-lang[ 2] = 'Beschreibung fr:'
  qbf-lang[ 3] = 'Einige Dateien und/oder Felder fehlen aus einem der nach'
	       + 'folgenden Grnde:^1) Die Originaldaten'
	       + 'banken sind hier nicht aktiv^2) Das Datenbankschema wurde ge'
	       + '„ndert^3) Ihre Zugriffsrechte sind nicht ausreichend'
  qbf-lang[ 4] = '~{1~} Beschreibung muá eindeutig sein. Bitte versuchen Sie '
	       + 'es nochmal.'
  qbf-lang[ 5] = 'Sie haben zu viele Eintr„ge gespeichert. L”schen Sie bitte'
	       + 'Eintr„ge in beliebigen Modulen, um wieder freien Speicher-'
	       + 'platz zu erhalten.'
  qbf-lang[ 6] = 'Beschr.-,Datenbk.,Programm'
  qbf-lang[ 7] = 'Wollen Sie die Datei berschreiben: '
  qbf-lang[ 8] = 'mit'
  qbf-lang[ 9] = 'W„hlen Sie'
  qbf-lang[10] = 'ein Exportformat,einen Graph,ein Etikett,eine Abfragemaske,'
	       + 'einen Bericht'
  qbf-lang[11] = 'Exportformat,Graph,Etikett,Abfrage,Bericht'
  qbf-lang[12] = 'Exportformate,Graphen,Etikett,Abfragen,Berichte'
  qbf-lang[13] = 'Datenexportformat,Graph,Etikettformat,Abfragen,'
	       + 'Berichtformat'
  qbf-lang[14] = 'zum Laden,zum Sichern,zum L”schen'
  qbf-lang[15] = 'Bearbeitung...'
  qbf-lang[16] = '~{1~} aus einem anderen Verzeichnis'
  qbf-lang[17] = '~{1~} neu abspeichern'
  qbf-lang[18] = 'nicht vorhanden'
  qbf-lang[19] = 'Alle markierten Objekte werden gel”scht. ['
	       + KBLABEL('RETURN') + '] setzt/l”scht Marken.'
  qbf-lang[20] = '[' + KBLABEL('GO') + '] Auswahl beenden, ['
	       + KBLABEL('END-ERROR') + '] Abbrechen.'
  qbf-lang[21] = 'Verschiebt ~{1~} auf Position ~{2~}.'
  qbf-lang[22] = '~{1~} wird gel”scht.'
  qbf-lang[23] = '[' + KBLABEL("GO") + '] Auswahlende, ['
	       + KBLABEL("INSERT-MODE") + '] Wechsel Bez/Datbk/'
	       + 'Progr, ['
	       + KBLABEL("END-ERROR") + '] Abbruch.'
  qbf-lang[24] = 'Liste fr Berichtlayouts wird berarbeitet...'
/*a-info.p only:*/ /* 25..29 use format x(64) */
  qbf-lang[25] = 'Diese Option zeigt Ihnen den Inhalt der .qd-Datei '
  qbf-lang[26] = 'eines beliebigen Benutzers an. Dort sind die Pro-'
  qbf-lang[27] = 'gramme des Benutzers fr dessen Berichte, Etiketten'
  qbf-lang[28] = 'und Datenexportformate beschrieben.'
  qbf-lang[29] = 'Geben Sie den kompletten Pfad der gewnschten .qd-Datei an:'
  qbf-lang[30] = 'Gewnschte Datei nicht vorhanden oder falscher Pfad/Dateiname'
  qbf-lang[31] = 'Sie haben die Endung ".qd" vergessen.'
  qbf-lang[32] = 'Das Verzeichnis wird gelesen...'.

RETURN.

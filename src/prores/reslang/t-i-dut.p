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
/* t-i-eng.p - English language definitions for Directory */
/* translation by Ton Voskuilen, PROGRESS Holland */
/* september, 1991 */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*i-dir.p,i-pick.p,i-zap.p,a-info.p,i-read.p*/
ASSIGN
  qbf-lang[ 1] = 'export,,etiket,,rapport'
  qbf-lang[ 2] = 'Vul omschrijving in van'
  qbf-lang[ 3] = 'Sommige tabellen/velden zijn overgeslagen, om een van de '
	       + 'volgende redenen:^1) database niet opgegeven '
	       + '^2) database definities zijn veranderd^3) geen '
	       + 'toestemming voor toegang'
  qbf-lang[ 4] = 'Iedere ~{1~} moet een unieke naam hebben.  Probeer nogmaals.'
  qbf-lang[ 5] = 'Er zijn teveel objekten opgeslagen.  Verwijder enkele!  '
	       + 'Verwijderen uit enige module directory zal ruimte vrij maken.'
  qbf-lang[ 6] = 'Omschr--,Database,Prgramma'
  qbf-lang[ 7] = 'Weet u zeker dat u dit wilt overschrijven?'
  qbf-lang[ 8] = 'met'
  qbf-lang[ 9] = 'Kies'
  qbf-lang[10] = 'een Export Formaat,een Graph,een Etiket,een Query,een Rapport'
  qbf-lang[11] = 'export formaat,graph,etiket,query,rapport'
  qbf-lang[12] = 'Export Formaten,Graphs,Etiketten,Queries,Rapporten'
  qbf-lang[13] = 'Data Export Formaten,Graphs,Etiket Formaten,Opvraagschermen,'
	       + 'Rapport Definities'
  qbf-lang[14] = 'om in te lezen,om op te slaan,om te verwijderen'
  qbf-lang[15] = 'Bezig...'
  qbf-lang[16] = '~{1~} uit een andere directory halen'
  qbf-lang[17] = 'opslaan als nieuw ~{1~}'
  qbf-lang[18] = 'niet besckikbaar'
  qbf-lang[19] = 'Gemerkte objekten worden verwijderd. Gebruik ['
	       + KBLABEL('RETURN') + '] voor merken/niet-merken.'
  qbf-lang[20] = 'Druk op [' + KBLABEL('GO') + '] voor verwijderen, of op ['
	       + KBLABEL('END-ERROR') + '] om niet te verwijderen.'
  qbf-lang[21] = 'Verplaats nummer ~{1~} naar positie ~{2~}.'
  qbf-lang[22] = 'Nummer ~{1~} wordt verwijderd.'
  qbf-lang[23] = '[' + KBLABEL("GO") + '] voor selekteren, ['
	       + KBLABEL("INSERT-MODE") + '] voor wisselen, ['
	       + KBLABEL("END-ERROR") + '] voor einde.'
  qbf-lang[24] = 'WIjzigingen in rapporten directory worden weggeschreven...'
/*a-info.p only:*/ /* 25..29 use format x(64) */
  qbf-lang[25] = 'Deze optie toont de inhoud van een directory van een '
  qbf-lang[26] = 'gebruiker, en laat zien welke programma''s overeen komen met '
  qbf-lang[27] = 'de gedefinieerde rapporten, export formaten, etiketten, etc.'
  qbf-lang[28] = 'Geef de volledige bestandsnaam op voor het ".qd" bestand'
  qbf-lang[29] = ''
  qbf-lang[30] = 'Bestand kan niet worden gevonden.'
  qbf-lang[31] = 'U bent ".qd" vergeten.'
  qbf-lang[32] = 'Directory wordt gelezen...'.

RETURN.

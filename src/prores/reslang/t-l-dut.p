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
/* t-l-eng.p - English language definitions for Labels module */
/* translation by Ton Voskuilen, PROGRESS Holland */
/* september, 1991 */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* l-guess.p:1..5,l-verify.p:6.. */
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'In "~{1~}" wordt gezocht naar veld "~{2~}"...'
    qbf-lang[ 2] = 'Velden kunnen met automatisch zoeken niet worden gevonden.'
    qbf-lang[ 4] = 'Velden voor etiket worden opgezet.'
    qbf-lang[ 5] = 'name,address #1,address #2,address #3,city,'
		 + 'state,zip+4,zip,city-state-zip,country'
    qbf-lang[ 6] = 'Regel ~{1~}: Aantal haakjes-karakters klopt niet.'
    qbf-lang[ 7] = 'Regel ~{2~}: Veld "~{1~}" niet gevonden.'
    qbf-lang[ 8] = 'Regel ~{2~}: Veld "~{1~}", is geen array veld.'
    qbf-lang[ 9] = 'Regel ~{2~}: Veld "~{1~}", extent ~{3~} ongeldige waarde.'
    qbf-lang[10] = 'Regel ~{2~}: Veld "~{1~}", niet geselekteerde tabel.'.

ELSE

/*--------------------------------------------------------------------------*/
/* l-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    /* each entry of 1 and also 2 must fit in format x(6) */
    qbf-lang[ 1] = 'Tabel:,     :,     :,     :,     :'
    qbf-lang[ 2] = ' Orde:'
    qbf-lang[ 3] = 'Etiket Info'
    qbf-lang[ 4] = 'Etiket Layout'
    qbf-lang[ 5] = 'Kies een veld'
    /*cannot change length of 6 thru 17, right-justify 6-11,13-14 */
    qbf-lang[ 6] = 'Lege rgls oversl:'
    qbf-lang[ 7] = '  Aantal kopieen:'
    qbf-lang[ 8] = ' Totale hoogte:'
    qbf-lang[ 9] = ' Top lege rgls:'
    qbf-lang[10] = '        Tekst afstand:'
    qbf-lang[11] = '      Linker kantlijn:'
    qbf-lang[12] = '(brdte)'
    qbf-lang[13] = ' Etiket tekst'
    qbf-lang[14] = '    en velden'
    qbf-lang[15] = 'Aantal etiketten  ' /* 15..17 used as group.   */
    qbf-lang[16] = 'in de             ' /*   do not change length, */
    qbf-lang[17] = 'breedte:     ' /*        but do right-justify  */
    qbf-lang[19] = 'U heeft het huidige etiket niet gewist.  '
		 + 'Wilt u nog verder gaan?'
    qbf-lang[20] = 'De etiket-hoogte is ~{1~}, maar u heeft ~{2~} gedefinieerd '
		 + 'Sommige informatie zal er dus niet op passen en zal niet '
		 + 'worden afgedrukt.'
		 + 'Wilt u verder gaan met het afdrukken van dit etiket?'
    qbf-lang[21] = 'Er is geen etiket tekst of velden om te af te drukken!'
    qbf-lang[22] = 'Het etiketprogramma wordt gemaakt...'
    qbf-lang[23] = 'Het etiketprogramma wordt gecompileerd...'
    qbf-lang[24] = 'Het etiketprogramma wordt uitgevoerd...'
    qbf-lang[25] = 'Schrijven naar uitvoer bestemming niet mogelijk!'
    qbf-lang[26] = '~{1~} etiketten afgedrukt.'
    qbf-lang[27] = 'V. Velden'
    qbf-lang[28] = 'T. Tabellen'
    qbf-lang[29] = 'Moet het programma proberen de velden voor de etiketten '
		 + 'automatisch te selekteren?'
    qbf-lang[31] = 'Weet u zeker dat u deze instellingen wilt verwijderen?'
    qbf-lang[32] = 'Weet u zeker dat u deze module wilt verlaten?'.

ELSE

/*--------------------------------------------------------------------------*/
/* l-main.p */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = 'Bij meerdere etiketten naast elkaar, dan tekst afstand > 0.'
    qbf-lang[ 2] = 'Het aantal lege regels aan begin pagina kan niet negatief.'
    qbf-lang[ 3] = 'De totale hoogte per etiket moet groter zijn dan 1.'
    qbf-lang[ 4] = 'Aantal etiketten naast elkaar moet minimaal 1 zijn.'
    qbf-lang[ 5] = 'Aantal kopieen moet minimaal 1 zijn.'
    qbf-lang[ 6] = 'Linker kantlijn kan niet negatief zijn.'
    qbf-lang[ 7] = 'Tekst afstand moet minimaal 1 zijn.'
    qbf-lang[ 8] = 'Onderliggende regels omhoog schuiven bij lege regel(s).'
    qbf-lang[ 9] = 'Aant. rgls vanaf bovenkant etiket tot eerste af te '
		 + 'drukken rgl.'
    qbf-lang[10] = 'Totale hoogte van een etiket in aantal regels.'
    qbf-lang[11] = 'Aantal etiketten naast elkaar.'
    qbf-lang[12] = 'Aantal kopieen per etiket.'
    qbf-lang[13] = 'Aantal spaties van begin etiket tot eerste afdruk positie.'
    qbf-lang[14] = 'Afstand tussen linkse zijden van etiketten naast elkaar '.

/*--------------------------------------------------------------------------*/

RETURN.

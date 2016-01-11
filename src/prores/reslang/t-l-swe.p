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
/* t-l-swe.p - Swedish language definitions for Labels module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* l-guess.p:1..5,l-verify.p:6.. */
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'S”ker i "~{1~}" efter "~{2~}" f„lt...'
    qbf-lang[ 2] = 'Inga f„lt kunde hittas med automatisk s”kning.'
    qbf-lang[ 4] = 'S„tter upp etikettf„lt'
    qbf-lang[ 5] = 'namn,adr1,adr2,adr3,'
                 + 'pnr-stad,pnr,stad,land,ex-1,ex-2'

    qbf-lang[ 6] = 'Rad ~{1~}: Klamrar ej parvis.'
    qbf-lang[ 7] = 'Rad ~{2~}: Hittar ej f„lt "~{1~}".'
    qbf-lang[ 8] = 'Rad ~{2~}: F„lt "~{1~}", „r inget matrisf„lt.'
    qbf-lang[ 9] = 'Rad ~{2~}: F„lt "~{1~}", element ~{3~} utanf”r intervall.'
    qbf-lang[10] = 'Rad ~{2~}: F„lt "~{1~}", fr†n ej vald fil.'.

ELSE

/*--------------------------------------------------------------------------*/
/* l-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    /* each entry of 1 and also 2 must fit in format x(6) */
    qbf-lang[ 1] = 'Filer:,     :,     :,     :,     :'
    qbf-lang[ 2] = 'Ordn.:'
    qbf-lang[ 3] = 'Etikettinfo'
    qbf-lang[ 4] = 'Etikettlayout'
    qbf-lang[ 5] = 'V„lj ett f„lt'
    /*cannot change length of 6 thru 17, right-justify 6-11,13-14 */
    qbf-lang[ 6] = ' Skippa tomrader:'
    qbf-lang[ 7] = ' Kopior av varje:'
    qbf-lang[ 8] = '    Total h”jd:'
    qbf-lang[ 9] = '  Toppmarginal:'
    qbf-lang[10] = ' Text t. text avst†nd:'
    qbf-lang[11] = '     V„nster marginal:'
    qbf-lang[12] = '(bredd)'
    qbf-lang[13] = '   Etikettext'
    qbf-lang[14] = '     och f„lt'
    qbf-lang[15] = 'Antal             ' /* 15..17 used as group.   */
    qbf-lang[16] = 'etiketter         ' /*   do not change length, */
    qbf-lang[17] = 'i sidled:      ' /*        but do right-justify  */
    qbf-lang[19] = 'Du rensade inte bort aktuell etikett. '
                 + 'Vill du „nd† forts„tta?'
    qbf-lang[20] = 'Etiketth”jd „r ~{1~}, men du har ~{2~} rader '
                 + 'definierade. En del av informationen f†r ej plats p†  '
                 + 'etiketten och kommer d„rf”r ej att skrivas.  '
                 + 'Vill du „nd† forts„tta med utskrift av etiketterna?'
    qbf-lang[21] = 'Etikettext eller f„lt saknas f”r utskrift!'
    qbf-lang[22] = 'Genererar etikettprogram...'
    qbf-lang[23] = 'Kompilerar etikettprogram..'
    qbf-lang[24] = 'K”r genererat program...'
    qbf-lang[25] = 'Kunde ej skriva till fil el enhet.'
    qbf-lang[26] = '~{1~} etiketter utskrivna.'
    qbf-lang[27] = 'F. F„lt'
    qbf-lang[28] = 'A. Aktiva tabeller'
    qbf-lang[29] = 'Skall programmet f”rs”ka v„lja f„lt till etiketterna '
                 + 'automatiskt?'
    qbf-lang[31] = 'S„kert att du vill ta bort dessa inst„llningar?'
    qbf-lang[32] = 'S„kert att du vill avsluta denna modul?'.

ELSE

/*--------------------------------------------------------------------------*/
/* l-main.p */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = 'Om mer „n 1 etikett i sidled m†ste textavst†nd vara > 0'
    qbf-lang[ 2] = 'Toppmarginal kan ej vara < 0'
    qbf-lang[ 3] = 'Total h”jd m†ste vara > 1'
    qbf-lang[ 4] = 'Antal etiketter i sidled m†ste vara > 0'
    qbf-lang[ 5] = 'Antal kopior m†ste vara > 0'
    qbf-lang[ 6] = 'V„nstermarginal kan ej vara < 0'
    qbf-lang[ 7] = 'Textmellanrum m†ste vara > 1'
    qbf-lang[ 8] = 'Flytta upp l„gre rader vid tom rad'
    qbf-lang[ 9] = 'Antal tomma rader f”re f”rsta skrivraden p† etiketten'
    qbf-lang[10] = 'Total etiketth”jd i antal rader'
    qbf-lang[11] = 'Antal etiketter i sidled'
    qbf-lang[12] = 'Antal kopior av varje etikett'
    qbf-lang[13] = 'Antal blanka fr†n v„nsterkant till f”rsta skrivposition'
    qbf-lang[14] = 'Avst†nd fr†n v„nsterkant av en etikett t. v„kant av n„sta'.

/*--------------------------------------------------------------------------*/

RETURN.

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
/* t-l-dan.p - Danish language definitions for Labels module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* l-guess.p:1..5,l-verify.p:6.. */
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'S›ger i "~{1~}" efter "~{2~}" felt...'
    qbf-lang[ 2] = 'Ingen felter fundet benyttende den automatiske s›gning.'
    qbf-lang[ 4] = 'Ops‘tter label felter'
    qbf-lang[ 5] = 'person,titel,firma,addresse 1,addresse 2,addresse 3,'
		 + 'post-nr,post-by,post-nr-by,land'

    qbf-lang[ 6] = 'Linie ~{1~}: Ubalanceret eller manglende parrentes.'
    qbf-lang[ 7] = 'Linie ~{2~}: Kan ikke finde felt "~{1~}".'
    qbf-lang[ 8] = 'Linie ~{2~}: Felt "~{1~}", er ikke et array felt.'
    qbf-lang[ 9] = 'Linie ~{2~}: Felt "~{1~}", index ~{3~} udenfor v‘rdi.'
    qbf-lang[10] = 'Linie ~{2~}: Felt "~{1~}", fra en ikke valgt fil.'.

ELSE

/*--------------------------------------------------------------------------*/
/* l-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    /* each entry of 1 and also 2 must fit in format x(6) */
    qbf-lang[ 1] = 'Filer:,     :,     :,     :,     :'
    qbf-lang[ 2] = 'Sort.:'
    qbf-lang[ 3] = 'Label Info'
    qbf-lang[ 4] = 'Label Layout'
    qbf-lang[ 5] = 'V‘lg et Felt'
    /*Cannot change length of 6 thru 17, right-justify 6-11,13-14 */
    qbf-lang[ 6] = 'Skip tomme linie:'
    qbf-lang[ 7] = '    Antal kopier:'
    qbf-lang[ 8] = '  Antal linier:'
    qbf-lang[ 9] = '    Top Margen:'
    qbf-lang[10] = '       Kolonne bredde:'
    qbf-lang[11] = '       Venstre margin:'
    qbf-lang[12] = 'pr labl'
    qbf-lang[13] = '  Label tekst'
    qbf-lang[14] = '    og Felter'
    qbf-lang[15] = 'Angiv antallet af ' /* 15..17 used as group.   */
    qbf-lang[16] = 'Labels p† tv‘rs   ' /*   do not change length, */
    qbf-lang[17] = 'af papiret:  ' /*        but do right-justify  */
    qbf-lang[19] = 'Du slettede ikke den aktuelle label.  '
		 + 'nsker du stadig at forts‘tte?'
    qbf-lang[20] = 'Din labels h›jde er ~{1~}, men du har defineret ~{2~} '
		 + 'linier.  Dele af information vil ikke kunne v‘re p† den '
		 + 'st›rrelse du har defineret, og vil derfor ikke blive skrevet.  '
		 + 'nsker du at forts‘tte med udskrivningen af disse labels?'
    qbf-lang[21] = 'Der er ingen label tekst eller felter at udskrive!'
    qbf-lang[22] = 'Genererer label program...'
    qbf-lang[23] = 'Kompilerer label program...'
    qbf-lang[24] = 'Afvikler det genererede program...'
    qbf-lang[25] = 'Kan ikke skrive til fil eller enhed'
    qbf-lang[26] = '~{1~} labels udskrevet.'
    qbf-lang[27] = 'F. Felter'
    qbf-lang[28] = 'A. Aktive Filer'
    qbf-lang[29] = 'Skal dette program fors›ge automatisk at udv‘lge felter? '
    qbf-lang[31] = 'Er du sikker p† du ›nsker at slette denne ops‘tning?'
    qbf-lang[32] = 'Er du sikker p† du ›nsker at afslutte dette modul?'.

ELSE

/*--------------------------------------------------------------------------*/
/* l-main.p */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = 'Hvis der er mere end een label p† tv‘rs, skal kolonne bredde
 > 0'
    qbf-lang[ 2] = 'Top margen kan ikke v‘re negativ'
    qbf-lang[ 3] = 'Antal linier skal v‘re st›rre end een'
    qbf-lang[ 4] = 'Antal af labels p† tv‘rs skal v‘re mindst een'
    qbf-lang[ 5] = 'Antal af kopier skal v‘re mindst een'
    qbf-lang[ 6] = 'Venstre margen kan ikke v‘re negativ'
    qbf-lang[ 7] = 'Kolonne bredde skal v‘re st›rre end een'
    qbf-lang[ 8] = 'Flyt f›lgende linier op n†r linier er blanke'
    qbf-lang[ 9] = 'Antal af liner fra toppen af labelen til f›rste linie af print'
    qbf-lang[10] = 'Total h›jde af label m†lt i linier'
    qbf-lang[11] = 'Antal af labels p† tv‘rs'
    qbf-lang[12] = 'Antal kopier af hver label'
    qbf-lang[13] = 'Antal mellemrum fra kanten af labelen til f›rste print position'
    qbf-lang[14] = 'Afstand fra venstre kant af een label til kanten af den n‘ste'.

/*--------------------------------------------------------------------------*/

RETURN.

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
/* t-s-dan.p - Danish language definitions for general system use */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/

/* l-edit.p,s-edit.p */
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Indsët'
    qbf-lang[ 2] = 'Er du sikker pÜ du õnsker at afslutte uden at gemme ëndringer?'
    qbf-lang[ 3] = 'Angiv navnet pÜ filen der skal indgÜ'
    qbf-lang[ 4] = 'Angiv sõgetekst'
    qbf-lang[ 5] = 'Vëlg Felt der skal indsëttes'
    qbf-lang[ 6] = 'Tryk [' + KBLABEL("GO") + '] for gem, ['
	     + KBLABEL("GET") + '] for indsët felt, ['
	     + KBLABEL("END-ERROR") + '] for fortryd.'
    qbf-lang[ 7] = 'Sõgetekst ikke fundet.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-ask.p,s-where.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Lig med'
    qbf-lang[ 2] = 'Forskellig fra'
    qbf-lang[ 3] = 'Mindre end'
    qbf-lang[ 4] = 'Mindre eller Lig'
    qbf-lang[ 5] = 'Stõrre end'
    qbf-lang[ 6] = 'Stõrre eller Lig'
    qbf-lang[ 7] = 'Begynder'
    qbf-lang[ 8] = 'Indeholder'    /* must match [r.4.23] */
    qbf-lang[ 9] = 'Svarer til'

    qbf-lang[10] = 'Vëlg et Felt'
    qbf-lang[11] = 'Udtryk'
    qbf-lang[12] = 'Indtast en Vërdi'
    qbf-lang[13] = 'Sammenligning'

    qbf-lang[14] = 'Spõrg brugeren efter en vërdi pÜ afviklings tidspunktet.'
    qbf-lang[15] = 'Indtast et spõrgsmÜlstegn for at spõrge under afvikling:'

    qbf-lang[16] = 'Spõrg efter' /* data-type */
    qbf-lang[17] = 'Vërdi'

    qbf-lang[18] = 'Tryk [' + KBLABEL("END-ERROR") + '] for afslut.'
    qbf-lang[19] = 'Tryk [' + KBLABEL("END-ERROR") + '] for fortryd sidste step.'
    qbf-lang[20] = 'Tryk [' + KBLABEL("GET") + '] for Expert niveau.'

    qbf-lang[21] = 'Udvëlg typen af sammenligning der skal udfõres pÜ feltet.'

    qbf-lang[22] = 'Indtast ~{1~} vërdien der skal sammenlignes med "~{2~}".'
    qbf-lang[23] = 'Indtast ~{1~} vërdien for "~{2~}".'
    qbf-lang[24] = 'Tryk [' + KBLABEL("PUT")
	     + '] for at spõrge efter en vërdi under afvikling.'
    qbf-lang[25] = 'Brug: ~{1~} er ~{2~} en ~{3~} vërdi.'

    qbf-lang[27] = '"Expert niveau" er ikke kompatibelt med "spõrg efter '
	     + 'vërdi under afvikling".  Du kan kun benytte den ene.'
    qbf-lang[28] = 'MÜ ikke vëre en ukendt vërdi!'
    qbf-lang[29] = 'Indtast flere vërdier for' /* '?' append to string */
    qbf-lang[30] = 'Indtast flere udvëlgelses kriterier?'
    qbf-lang[31] = 'Kombiner med forrige kriterie, benyttende?'
    qbf-lang[32] = 'Expert niveau'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 3 THEN
  ASSIGN
/* s-info.p, s-format.p */
    qbf-lang[ 1] = 'Sorter efter' /* s-info.p automatically right-justifies */
    qbf-lang[ 2] = 'og efter'     /*   1..9 og adds colons for you. */
    qbf-lang[ 3] = 'Fil'          /* but must fit i format x(24) */
    qbf-lang[ 4] = 'Relation'
    qbf-lang[ 5] = 'Udvëlg efter'
    qbf-lang[ 6] = 'Felt'
    qbf-lang[ 7] = 'Udtryk'
    qbf-lang[ 9] = 'Fjern gentagne vërdier?'

    qbf-lang[10] = 'FRA,MED,TIL'
    qbf-lang[11] = 'Du har endnu ikke valgt filer!'
    qbf-lang[12] = 'Format og Label'
    qbf-lang[13] = 'Format'
    qbf-lang[14] = 'Vëlg et Felt' /* also used by s-calc.p below */
    /* 15..18 skal vëre format x(16) (see notes on 1..7) */
    qbf-lang[15] = 'Label'
    qbf-lang[16] = 'Format'
    qbf-lang[17] = 'Database'
    qbf-lang[18] = 'Type'
    qbf-lang[19] = 'Tid brugt til sidste Kõrsel i minuter:sekunder'
    qbf-lang[20] = 'Udtryk kan ikke have ukendt vërdi (?)'

/*s-calc.p*/ /* there are many more for s-calc.p, see qbf-s = 5 thru 8 */
/*s-calc.p also uses #14 */
    qbf-lang[27] = 'Udtryks opbygger'
    qbf-lang[28] = 'Udtryk'
    qbf-lang[29] = 'Fortsët med tilfõjelser til dette udtryk?'
    qbf-lang[30] = 'Udvëlg Operation'
    qbf-lang[31] = 'dags dato'
    qbf-lang[32] = 'konstant vërdi'.

ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 4 THEN
  ASSIGN
/*s-help.p*/
    qbf-lang[ 1] = 'Der er endnu ikke hjëlp tilgëngelig for denne funktion.'
    qbf-lang[ 2] = 'Hjëlp'

/*s-order.p*/
    qbf-lang[15] = 'stigende/faldende' /*neither can be over 8 characters */
    qbf-lang[16] = 'For hver komponent, tast "s" for'
    qbf-lang[17] = 'stigende eller "f" for faldende.'

/*s-define.p*/
    qbf-lang[21] = 'B.  Brede/Format af Felter'
    qbf-lang[22] = 'F.  Felter'
    qbf-lang[23] = 'A.  Aktive Filer'
    qbf-lang[24] = 'S.  Subtotal og Total'
    qbf-lang[25] = 'L.  Lõbende Total'
    qbf-lang[26] = 'P.  Procent af Total'
    qbf-lang[27] = 'T.  Tëllere'
    qbf-lang[28] = 'UB. Beregnet Udtryk'
    qbf-lang[29] = 'UK. Karakter Udtryk'
    qbf-lang[30] = 'UN. Numerisk Udtryk'
    qbf-lang[31] = 'UD. Dato Udtryk'
    qbf-lang[32] = 'UL. Logisk Udtryk'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - string expressions */
IF qbf-s = 5 THEN
  ASSIGN
    qbf-lang[ 1] = 's,Konstant eller Felt,s00=s24,~{1~}'
    qbf-lang[ 2] = 's,Delstreng,s00=s25n26n27,SUBSTRING(~{1~}'
	     + ';INTEGER(~{2~});INTEGER(~{3~}))'
    qbf-lang[ 3] = 's,Sammensët to tekst strenge,s00=s28s29,~{1~} + ~{2~}'
    qbf-lang[ 4] = 's,Sammensët tre tekst strenge,s00=s28s29s29,'
	     + '~{1~} + ~{2~} + ~{3~}'
    qbf-lang[ 5] = 's,Sammensët fire tekst strenge,s00=s28s29s29s29,'
	     + '~{1~} + ~{2~} + ~{3~} + ~{4~}'
    qbf-lang[ 6] = 's,Mindste af to tekst strenge,s00=s30s31,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 's,Stõrste af to tekst strenge,s00=s30s31,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 8] = 's,Lëngde af tekst streng,n00=s32,LENGTH(~{1~})'
    qbf-lang[ 9] = 's,Bruger ID,s00=,USERID("RESULTSDB")'
    qbf-lang[10] = 's,Aktuel tid,s00=,STRING(TIME;"HH:MM:SS")'

    qbf-lang[24] = 'Indtast felt navnet der skal inkluderes som en kolonne i '
	     + 'din rapport, eller udvëlg <<konstant vërdi>> for at indsëtte en'
	     + ' konstant tekst streng i rapporten.'
    qbf-lang[25] = 'DELSTRENG tillader dig at udtrëke en del af en karakter '
	     + 'streng til visning.  Udvëlg et felt navn.'
    qbf-lang[26] = 'Indtast start karakter positionen'
    qbf-lang[27] = 'Indtast antal af karakterer der skal udtrëkkes'
    qbf-lang[28] = 'Udvëlg den fõrste vërdi'
    qbf-lang[29] = 'Udvëlg den nëste vërdi'
    qbf-lang[30] = 'Udvëlg den fõrste vërdi til sammenligningen'
    qbf-lang[31] = 'Udvëlg den anden vërdi til sammenligningen'
    qbf-lang[32] = 'Den returnerede vërdi svarer til lëngden af den '
	     + 'udvalgte tekst streng.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - numeric expressions */
IF qbf-s = 6 THEN
  ASSIGN
    qbf-lang[ 1] = 'n,Konstant eller Felt,n00=n26,~{1~}'
    qbf-lang[ 2] = 'n,Mindste af to vërdier,n00=n24n25,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 3] = 'n,Stõrste af to vërdier,n00=n24n25,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 4] = 'n,Restvërdi,n00=n31n32,~{1~} MODULO ~{2~}'
    qbf-lang[ 5] = 'n,Absolut Vërdi,n00=n27,'
	     + '(IF ~{1~} < 0 THEN - ~{1~} ELSE ~{1~})'
    qbf-lang[ 6] = 'n,Afrund,n00=n28,ROUND(~{1~};0)'
    qbf-lang[ 7] = 'n,Afskër,n00=n29,TRUNCATE(~{1~};0)'
    qbf-lang[ 8] = 'n,Kvadratrod,n00=n30,SQRT(~{1~})'
    qbf-lang[ 9] = 'n,Vis som tid,s00=n23,STRING(INTEGER(~{1~});"HH:MM:SS")'

    qbf-lang[23] = 'Udvëlg et felt der skal vises som TT:MM:SS'
    qbf-lang[24] = 'Udvëlg den fõrste vërdi til sammenligningen'
    qbf-lang[25] = 'Udvëlg den anden vërdi til sammenligningen'
    qbf-lang[26] = 'Indtast felt navnet der skal inkluderes som en kolonne i '
	     + 'din rapport, eller udvëlg <<konstant vërdi>> for at indsëtte en'
	     + ' konstant numerisk vërdi i rapporten.'
    qbf-lang[27] = 'Udvëlg et felt der skal vises som en absolut (positiv) '
	     + 'vërdi.'
    qbf-lang[28] = 'Udvëlg et felt der skal afrundes til den nërmeste hele vërdi.'
    qbf-lang[29] = 'Udvëlg et felt der skal afskëres (decimal del fjernes).'
    qbf-lang[30] = 'Udvëlg et felt der skal tages kvadratrod af.'
    qbf-lang[31] = 'Efter dividering af vërdien med kvotienten, returneres rest'
	     + ' vërdien.  Hvilken vërdi õnsker du rest vërdien af?'
    qbf-lang[32] = 'Divideret med hvad?'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - date expressions */
IF qbf-s = 7 THEN
  ASSIGN
    qbf-lang[ 1] = 'd,Aktuel Dato,d00=,TODAY'
    qbf-lang[ 2] = 'd,Adder dage til dato vërdi,d00=d22n23,~{1~} + ~{2~}'
    qbf-lang[ 3] = 'd,Fratrëk dage fra dato vërdi,d00=d22n24,~{1~} - ~{2~}'
    qbf-lang[ 4] = 'd,Difference mellem to datoer,n00=d25d26,~{1~} - ~{2~}'
    qbf-lang[ 5] = 'd,Tidligste af to datoer,d00=d20d21,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 6] = 'd,Sidste af to datoer,d00=d20d21,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 'd,Dag i mÜned,n00=d27,DAY(~{1~})'
    qbf-lang[ 8] = 'd,MÜned i Ür,n00=d28,MONTH(~{1~})'
    qbf-lang[ 9] = 'd,Navn pÜ mÜned,s00=d29,ENTRY(MONTH(~{1~});"Januar'
	     + ';Februar;Marts;April;Maj;Juni;Juli;August;September'
	     + ';Oktober;November;December")'
    qbf-lang[10] = 'd,èret,n00=d30,YEAR(~{1~})'
    qbf-lang[11] = 'd,Dag i ugen,n00=d31,WEEKDAY(~{1~})'
    qbf-lang[12] = 'd,Navn pÜ ugedag,s00=d32,ENTRY(WEEKDAY(~{1~});"'
	     + 'Sõndag;Mandag;Tirsdag;Onsdag;Torsdag;Fredag;Lõrdag")'

    qbf-lang[20] = 'Udvëlg den fõrste vërdi til sammenligningen'
    qbf-lang[21] = 'Udvëlg den anden vërdi til sammenligningen'
    qbf-lang[22] = 'Udvëlg et dato felt.'
    qbf-lang[23] = 'Udvëlg et felt der indeholder antallet dage der skal '
	     + 'adderes til datoen.'
    qbf-lang[24] = 'Udvëlg et felt der indeholder antallet dage der skal '
	     + 'fratrëkkes datoen.'
    qbf-lang[25] = 'Sammenlign to dato vërdier og vis '
	     + ' forskellen i dage mellem de to datoer.  Vëlg det '
	     + 'fõrste felt.'
    qbf-lang[26] = 'Vëlg nu det andet dato felt.'
    qbf-lang[27] = 'Returnerer dagen i mÜneden som et nummer fra '
	     + '1 til 31.'
    qbf-lang[28] = 'Returnerer mÜneden i Üret som et nummer fra '
	     + '1 til 12.'
    qbf-lang[29] = 'Returnerer navnet pÜ mÜneden.'
    qbf-lang[30] = 'Returnerer Ürs delen fra en dato som et heltal.'
    qbf-lang[31] = 'Returnerer en vërdi for ugedagen, med Sõndag som 1.'
    qbf-lang[32] = 'Returnerer navnet pÜ dagen i ugen.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - mathematical expressions */
IF qbf-s = 8 THEN
  ASSIGN
    qbf-lang[ 1] = 'm,Adder,n00=n25n26m...,~{1~} + ~{2~}'
    qbf-lang[ 2] = 'm,Subtraher,n00=n25n27m...,~{1~} - ~{2~}'
    qbf-lang[ 3] = 'm,Multiplicer,n00=n28n29m...,~{1~} * ~{2~}'
    qbf-lang[ 4] = 'm,Divider,n00=n30n31m...,~{1~} / ~{2~}'
    qbf-lang[ 5] = 'm,Oplõft til potens,n00=n25n32m...,EXP(~{1~};~{2~})'

    qbf-lang[25] = 'Indtast fõrste vërdi'
    qbf-lang[26] = 'Indtast nëste vërdi for adder'
    qbf-lang[27] = 'Indtast nëste vërdi to substraher'
    qbf-lang[28] = 'Indtast fõrste multiplikator'
    qbf-lang[29] = 'Indtast nëste multiplikator'
    qbf-lang[30] = 'Indtast kvotient'
    qbf-lang[31] = 'Indtast divisor'
    qbf-lang[32] = 'Indtast potens'.

/*--------------------------------------------------------------------------*/

RETURN.

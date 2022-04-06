/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
    qbf-lang[ 1] = 'Inds�t'
    qbf-lang[ 2] = 'Er du sikker p� du �nsker at afslutte uden at gemme �ndringer?'
    qbf-lang[ 3] = 'Angiv navnet p� filen der skal indg�'
    qbf-lang[ 4] = 'Angiv s�getekst'
    qbf-lang[ 5] = 'V�lg Felt der skal inds�ttes'
    qbf-lang[ 6] = 'Tryk [' + KBLABEL("GO") + '] for gem, ['
	     + KBLABEL("GET") + '] for inds�t felt, ['
	     + KBLABEL("END-ERROR") + '] for fortryd.'
    qbf-lang[ 7] = 'S�getekst ikke fundet.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-ask.p,s-where.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Lig med'
    qbf-lang[ 2] = 'Forskellig fra'
    qbf-lang[ 3] = 'Mindre end'
    qbf-lang[ 4] = 'Mindre eller Lig'
    qbf-lang[ 5] = 'St�rre end'
    qbf-lang[ 6] = 'St�rre eller Lig'
    qbf-lang[ 7] = 'Begynder'
    qbf-lang[ 8] = 'Indeholder'    /* must match [r.4.23] */
    qbf-lang[ 9] = 'Svarer til'

    qbf-lang[10] = 'V�lg et Felt'
    qbf-lang[11] = 'Udtryk'
    qbf-lang[12] = 'Indtast en V�rdi'
    qbf-lang[13] = 'Sammenligning'

    qbf-lang[14] = 'Sp�rg brugeren efter en v�rdi p� afviklings tidspunktet.'
    qbf-lang[15] = 'Indtast et sp�rgsm�lstegn for at sp�rge under afvikling:'

    qbf-lang[16] = 'Sp�rg efter' /* data-type */
    qbf-lang[17] = 'V�rdi'

    qbf-lang[18] = 'Tryk [' + KBLABEL("END-ERROR") + '] for afslut.'
    qbf-lang[19] = 'Tryk [' + KBLABEL("END-ERROR") + '] for fortryd sidste step.'
    qbf-lang[20] = 'Tryk [' + KBLABEL("GET") + '] for Expert niveau.'

    qbf-lang[21] = 'Udv�lg typen af sammenligning der skal udf�res p� feltet.'

    qbf-lang[22] = 'Indtast ~{1~} v�rdien der skal sammenlignes med "~{2~}".'
    qbf-lang[23] = 'Indtast ~{1~} v�rdien for "~{2~}".'
    qbf-lang[24] = 'Tryk [' + KBLABEL("PUT")
	     + '] for at sp�rge efter en v�rdi under afvikling.'
    qbf-lang[25] = 'Brug: ~{1~} er ~{2~} en ~{3~} v�rdi.'

    qbf-lang[27] = '"Expert niveau" er ikke kompatibelt med "sp�rg efter '
	     + 'v�rdi under afvikling".  Du kan kun benytte den ene.'
    qbf-lang[28] = 'M� ikke v�re en ukendt v�rdi!'
    qbf-lang[29] = 'Indtast flere v�rdier for' /* '?' append to string */
    qbf-lang[30] = 'Indtast flere udv�lgelses kriterier?'
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
    qbf-lang[ 5] = 'Udv�lg efter'
    qbf-lang[ 6] = 'Felt'
    qbf-lang[ 7] = 'Udtryk'
    qbf-lang[ 9] = 'Fjern gentagne v�rdier?'

    qbf-lang[10] = 'FRA,MED,TIL'
    qbf-lang[11] = 'Du har endnu ikke valgt filer!'
    qbf-lang[12] = 'Format og Label'
    qbf-lang[13] = 'Format'
    qbf-lang[14] = 'V�lg et Felt' /* also used by s-calc.p below */
    /* 15..18 skal v�re format x(16) (see notes on 1..7) */
    qbf-lang[15] = 'Label'
    qbf-lang[16] = 'Format'
    qbf-lang[17] = 'Database'
    qbf-lang[18] = 'Type'
    qbf-lang[19] = 'Tid brugt til sidste K�rsel i minuter:sekunder'
    qbf-lang[20] = 'Udtryk kan ikke have ukendt v�rdi (?)'

/*s-calc.p*/ /* there are many more for s-calc.p, see qbf-s = 5 thru 8 */
/*s-calc.p also uses #14 */
    qbf-lang[27] = 'Udtryks opbygger'
    qbf-lang[28] = 'Udtryk'
    qbf-lang[29] = 'Forts�t med tilf�jelser til dette udtryk?'
    qbf-lang[30] = 'Udv�lg Operation'
    qbf-lang[31] = 'dags dato'
    qbf-lang[32] = 'konstant v�rdi'.

ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 4 THEN
  ASSIGN
/*s-help.p*/
    qbf-lang[ 1] = 'Der er endnu ikke hj�lp tilg�ngelig for denne funktion.'
    qbf-lang[ 2] = 'Hj�lp'

/*s-order.p*/
    qbf-lang[15] = 'stigende/faldende' /*neither can be over 8 characters */
    qbf-lang[16] = 'For hver komponent, tast "s" for'
    qbf-lang[17] = 'stigende eller "f" for faldende.'

/*s-define.p*/
    qbf-lang[21] = 'B.  Brede/Format af Felter'
    qbf-lang[22] = 'F.  Felter'
    qbf-lang[23] = 'A.  Aktive Filer'
    qbf-lang[24] = 'S.  Subtotal og Total'
    qbf-lang[25] = 'L.  L�bende Total'
    qbf-lang[26] = 'P.  Procent af Total'
    qbf-lang[27] = 'T.  T�llere'
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
    qbf-lang[ 3] = 's,Sammens�t to tekst strenge,s00=s28s29,~{1~} + ~{2~}'
    qbf-lang[ 4] = 's,Sammens�t tre tekst strenge,s00=s28s29s29,'
	     + '~{1~} + ~{2~} + ~{3~}'
    qbf-lang[ 5] = 's,Sammens�t fire tekst strenge,s00=s28s29s29s29,'
	     + '~{1~} + ~{2~} + ~{3~} + ~{4~}'
    qbf-lang[ 6] = 's,Mindste af to tekst strenge,s00=s30s31,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 's,St�rste af to tekst strenge,s00=s30s31,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 8] = 's,L�ngde af tekst streng,n00=s32,LENGTH(~{1~})'
    qbf-lang[ 9] = 's,Bruger ID,s00=,USERID("RESULTSDB")'
    qbf-lang[10] = 's,Aktuel tid,s00=,STRING(TIME;"HH:MM:SS")'

    qbf-lang[24] = 'Indtast felt navnet der skal inkluderes som en kolonne i '
	     + 'din rapport, eller udv�lg <<konstant v�rdi>> for at inds�tte en'
	     + ' konstant tekst streng i rapporten.'
    qbf-lang[25] = 'DELSTRENG tillader dig at udtr�ke en del af en karakter '
	     + 'streng til visning.  Udv�lg et felt navn.'
    qbf-lang[26] = 'Indtast start karakter positionen'
    qbf-lang[27] = 'Indtast antal af karakterer der skal udtr�kkes'
    qbf-lang[28] = 'Udv�lg den f�rste v�rdi'
    qbf-lang[29] = 'Udv�lg den n�ste v�rdi'
    qbf-lang[30] = 'Udv�lg den f�rste v�rdi til sammenligningen'
    qbf-lang[31] = 'Udv�lg den anden v�rdi til sammenligningen'
    qbf-lang[32] = 'Den returnerede v�rdi svarer til l�ngden af den '
	     + 'udvalgte tekst streng.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - numeric expressions */
IF qbf-s = 6 THEN
  ASSIGN
    qbf-lang[ 1] = 'n,Konstant eller Felt,n00=n26,~{1~}'
    qbf-lang[ 2] = 'n,Mindste af to v�rdier,n00=n24n25,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 3] = 'n,St�rste af to v�rdier,n00=n24n25,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 4] = 'n,Restv�rdi,n00=n31n32,~{1~} MODULO ~{2~}'
    qbf-lang[ 5] = 'n,Absolut V�rdi,n00=n27,'
	     + '(IF ~{1~} < 0 THEN - ~{1~} ELSE ~{1~})'
    qbf-lang[ 6] = 'n,Afrund,n00=n28,ROUND(~{1~};0)'
    qbf-lang[ 7] = 'n,Afsk�r,n00=n29,TRUNCATE(~{1~};0)'
    qbf-lang[ 8] = 'n,Kvadratrod,n00=n30,SQRT(~{1~})'
    qbf-lang[ 9] = 'n,Vis som tid,s00=n23,STRING(INTEGER(~{1~});"HH:MM:SS")'

    qbf-lang[23] = 'Udv�lg et felt der skal vises som TT:MM:SS'
    qbf-lang[24] = 'Udv�lg den f�rste v�rdi til sammenligningen'
    qbf-lang[25] = 'Udv�lg den anden v�rdi til sammenligningen'
    qbf-lang[26] = 'Indtast felt navnet der skal inkluderes som en kolonne i '
	     + 'din rapport, eller udv�lg <<konstant v�rdi>> for at inds�tte en'
	     + ' konstant numerisk v�rdi i rapporten.'
    qbf-lang[27] = 'Udv�lg et felt der skal vises som en absolut (positiv) '
	     + 'v�rdi.'
    qbf-lang[28] = 'Udv�lg et felt der skal afrundes til den n�rmeste hele v�rdi.'
    qbf-lang[29] = 'Udv�lg et felt der skal afsk�res (decimal del fjernes).'
    qbf-lang[30] = 'Udv�lg et felt der skal tages kvadratrod af.'
    qbf-lang[31] = 'Efter dividering af v�rdien med kvotienten, returneres rest'
	     + ' v�rdien.  Hvilken v�rdi �nsker du rest v�rdien af?'
    qbf-lang[32] = 'Divideret med hvad?'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - date expressions */
IF qbf-s = 7 THEN
  ASSIGN
    qbf-lang[ 1] = 'd,Aktuel Dato,d00=,TODAY'
    qbf-lang[ 2] = 'd,Adder dage til dato v�rdi,d00=d22n23,~{1~} + ~{2~}'
    qbf-lang[ 3] = 'd,Fratr�k dage fra dato v�rdi,d00=d22n24,~{1~} - ~{2~}'
    qbf-lang[ 4] = 'd,Difference mellem to datoer,n00=d25d26,~{1~} - ~{2~}'
    qbf-lang[ 5] = 'd,Tidligste af to datoer,d00=d20d21,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 6] = 'd,Sidste af to datoer,d00=d20d21,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 'd,Dag i m�ned,n00=d27,DAY(~{1~})'
    qbf-lang[ 8] = 'd,M�ned i �r,n00=d28,MONTH(~{1~})'
    qbf-lang[ 9] = 'd,Navn p� m�ned,s00=d29,ENTRY(MONTH(~{1~});"Januar'
	     + ';Februar;Marts;April;Maj;Juni;Juli;August;September'
	     + ';Oktober;November;December")'
    qbf-lang[10] = 'd,�ret,n00=d30,YEAR(~{1~})'
    qbf-lang[11] = 'd,Dag i ugen,n00=d31,WEEKDAY(~{1~})'
    qbf-lang[12] = 'd,Navn p� ugedag,s00=d32,ENTRY(WEEKDAY(~{1~});"'
	     + 'S�ndag;Mandag;Tirsdag;Onsdag;Torsdag;Fredag;L�rdag")'

    qbf-lang[20] = 'Udv�lg den f�rste v�rdi til sammenligningen'
    qbf-lang[21] = 'Udv�lg den anden v�rdi til sammenligningen'
    qbf-lang[22] = 'Udv�lg et dato felt.'
    qbf-lang[23] = 'Udv�lg et felt der indeholder antallet dage der skal '
	     + 'adderes til datoen.'
    qbf-lang[24] = 'Udv�lg et felt der indeholder antallet dage der skal '
	     + 'fratr�kkes datoen.'
    qbf-lang[25] = 'Sammenlign to dato v�rdier og vis '
	     + ' forskellen i dage mellem de to datoer.  V�lg det '
	     + 'f�rste felt.'
    qbf-lang[26] = 'V�lg nu det andet dato felt.'
    qbf-lang[27] = 'Returnerer dagen i m�neden som et nummer fra '
	     + '1 til 31.'
    qbf-lang[28] = 'Returnerer m�neden i �ret som et nummer fra '
	     + '1 til 12.'
    qbf-lang[29] = 'Returnerer navnet p� m�neden.'
    qbf-lang[30] = 'Returnerer �rs delen fra en dato som et heltal.'
    qbf-lang[31] = 'Returnerer en v�rdi for ugedagen, med S�ndag som 1.'
    qbf-lang[32] = 'Returnerer navnet p� dagen i ugen.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - mathematical expressions */
IF qbf-s = 8 THEN
  ASSIGN
    qbf-lang[ 1] = 'm,Adder,n00=n25n26m...,~{1~} + ~{2~}'
    qbf-lang[ 2] = 'm,Subtraher,n00=n25n27m...,~{1~} - ~{2~}'
    qbf-lang[ 3] = 'm,Multiplicer,n00=n28n29m...,~{1~} * ~{2~}'
    qbf-lang[ 4] = 'm,Divider,n00=n30n31m...,~{1~} / ~{2~}'
    qbf-lang[ 5] = 'm,Opl�ft til potens,n00=n25n32m...,EXP(~{1~};~{2~})'

    qbf-lang[25] = 'Indtast f�rste v�rdi'
    qbf-lang[26] = 'Indtast n�ste v�rdi for adder'
    qbf-lang[27] = 'Indtast n�ste v�rdi to substraher'
    qbf-lang[28] = 'Indtast f�rste multiplikator'
    qbf-lang[29] = 'Indtast n�ste multiplikator'
    qbf-lang[30] = 'Indtast kvotient'
    qbf-lang[31] = 'Indtast divisor'
    qbf-lang[32] = 'Indtast potens'.

/*--------------------------------------------------------------------------*/

RETURN.

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
/* t-s-swe.p - Swedish language definitions for general system use */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/

/* l-edit.p,s-edit.p */
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Infoga'
    qbf-lang[ 2] = 'SÑkert att du vill avsluta utan att spara Ñndringar?'
    qbf-lang[ 3] = 'Skriv namnet pÜ fil som skall lÑsas in'
    qbf-lang[ 4] = 'Skriv sîkstrÑng'
    qbf-lang[ 5] = 'VÑlj fÑlt att infoga'
    qbf-lang[ 6] = 'Tryck [' + KBLABEL("GO") + '] fîr spara, ['
                 + KBLABEL("GET") + '] fîr addera fÑlt, ['
                 + KBLABEL("END-ERROR") + '] fîr Üngra'
    qbf-lang[ 7] = 'SîkstrÑng ej funnen.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-ask.p,s-where.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Lika med'
    qbf-lang[ 2] = 'Skilt frÜn'
    qbf-lang[ 3] = 'Mindre Ñn'
    qbf-lang[ 4] = 'Mindre el lika'
    qbf-lang[ 5] = 'Stîrre Ñn'
    qbf-lang[ 6] = 'Stîrre el lika'
    qbf-lang[ 7] = 'Bîrjar med'
    qbf-lang[ 8] = 'InnehÜller'    /* must match [r.4.23] */
    qbf-lang[ 9] = 'Matchar'

    qbf-lang[10] = 'VÑlj ett fÑlt'
    qbf-lang[11] = 'Uttryck'
    qbf-lang[12] = 'Ange ett vÑrde'
    qbf-lang[13] = 'JÑmfîrelser'

    qbf-lang[14] = 'Vid kîrning, be anvÑndare om ett vÑrde.'
    qbf-lang[15] = 'Ange frÜga som stÑlls vid kîrning:'

    qbf-lang[16] = 'Be om' /* data-type */
    qbf-lang[17] = 'vÑrde'

    qbf-lang[18] = 'Tryck [' + KBLABEL("END-ERROR") + '] fîr avslut.'
    qbf-lang[19] = 'Tryck [' + KBLABEL("END-ERROR") + '] att Üngra sista steg.'
    qbf-lang[20] = 'Press [' + KBLABEL("GET") + '] fîr ExpertlÑge.'

    qbf-lang[21] = 'VÑlj jÑmfîrelsetyp att utfîras pÜ fÑltet.'

    qbf-lang[22] = 'Ange ~{1~} vÑrde att jÑmfîras med "~{2~}".'
    qbf-lang[23] = 'Ange ~{1~} vÑrde fîr "~{2~}".'
    qbf-lang[24] = 'Tryck [' + KBLABEL("PUT")
                 + '] fîr att fordra ett vÑrde vid kîrning.'
    qbf-lang[25] = 'Valtext: ~{1~} Ñr ~{2~} ett ~{3~} vÑrde.'

    qbf-lang[27] = '"ExpertlÑge" Ñr inte det samma som "be om '
                 + 'ett vÑrde vid kîrning".  AnvÑnd det ena eller det andra.'
    qbf-lang[28] = 'FÜr ej vara okÑnt vÑrde!'
    qbf-lang[29] = 'Ange flera vÑrden fîr' /* '?' append to string */
    qbf-lang[30] = 'Ange flera urvalskriteriera?'
    qbf-lang[31] = 'Kombinera med fîregÜende kriteria och anvÑnd?'
    qbf-lang[32] = 'ExpertlÑge'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 3 THEN
  ASSIGN
/* s-info.p, s-format.p */
    qbf-lang[ 1] = 'Sort per'  /* s-info.p automatically right-justifies */
    qbf-lang[ 2] = 'och per'   /*   1..9 and adds colons for you. */
    qbf-lang[ 3] = 'Fil'      /* but must fit in format x(24) */
    qbf-lang[ 4] = 'Relation'
    qbf-lang[ 5] = 'DÑr'
    qbf-lang[ 6] = 'FÑlt'
    qbf-lang[ 7] = 'Uttryck'
    qbf-lang[ 9] = 'Gîmma rep. vÑrden?'

    qbf-lang[10] = 'FRèN,PER,FôR'
    qbf-lang[11] = 'Du har inte valt nÜgra tabeller!'
    qbf-lang[12] = 'Format och rubriker'
    qbf-lang[13] = 'Format'
    qbf-lang[14] = 'VÑlj ett fÑlt' /* also used by s-calc.p below */
    /* 15..18 must be format x(16) (see notes on 1..7) */
    qbf-lang[15] = 'Rubrik'
    qbf-lang[16] = 'Format'
    qbf-lang[17] = 'Databas'
    qbf-lang[18] = 'Typ'
    qbf-lang[19] = 'AnvÑnd tid vid sen. kîrning,minuter:sekunder'
    qbf-lang[20] = 'Uttryck kan ej vara okÑnt vÑrde (?)'

/*s-calc.p*/ /* there are many more for s-calc.p, see qbf-s = 5 thru 8 */
/*s-calc.p also uses #14 */
    qbf-lang[27] = 'Uttrycksbyggare'
    qbf-lang[28] = 'Uttryck'
    qbf-lang[29] = 'Ytterligare tillÑgg till detta uttryck?'
    qbf-lang[30] = 'VÑlj operation'
    qbf-lang[31] = 'dagens datum'
    qbf-lang[32] = 'konstant vÑrde'.

ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 4 THEN
  ASSIGN
/*s-help.p*/
    qbf-lang[ 1] = 'NÜgon hjÑlp fîr detta val finns Ñnnu ej.'
    qbf-lang[ 2] = 'HjÑlp'

/*s-order.p*/
    qbf-lang[15] = 'stigande/fallande' /*neither can be over 8 characters */
    qbf-lang[16] = 'Fîr varje komponent, skriv "s" fîr'
    qbf-lang[17] = 'stigande eller "f" fîr fallande.'

/*s-define.p*/
    qbf-lang[21] = 'W. Bredd/Format av fÑlt'
    qbf-lang[22] = 'F. FÑlt'
    qbf-lang[23] = 'A. Aktiva tabeller'
    qbf-lang[24] = 'T. Totaler och subtotaler'
    qbf-lang[25] = 'R. Ackumulerad total'
    qbf-lang[26] = 'P. Procent av total'
    qbf-lang[27] = 'C. RÑknare'
    qbf-lang[28] = 'M. Matematikuttryck'
    qbf-lang[29] = 'S. StrÑnguttryck'
    qbf-lang[30] = 'N. Numeriska uttryck'
    qbf-lang[31] = 'D. Datumuttryck'
    qbf-lang[32] = 'L. Logiska uttryck'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - string expressions */
IF qbf-s = 5 THEN
  ASSIGN
    qbf-lang[ 1] = 's,konstant eller fÑlt,s00=s24,~{1~}'
    qbf-lang[ 2] = 's,substrÑng,s00=s25n26n27,SUBSTRING(~{1~}'
                 + ';INTEGER(~{2~});INTEGER(~{3~}))'
    qbf-lang[ 3] = 's,kombinera tvÜ strÑngar,s00=s28s29,~{1~} + ~{2~}'
    qbf-lang[ 4] = 's,kombinera tre strÑngar,s00=s28s29s29,'
                 + '~{1~} + ~{2~} + ~{3~}'
    qbf-lang[ 5] = 's,kombinera fyra strÑngar,s00=s28s29s29s29,'
                 + '~{1~} + ~{2~} + ~{3~} + ~{4~}'
    qbf-lang[ 6] = 's,Minst av tvÜ strÑngar,s00=s30s31,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 's,Stîrst av tvÜ strÑngar,s00=s30s31,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 8] = 's,LÑngd av strÑng,n00=s32,LENGTH(~{1~})'
    qbf-lang[ 9] = 's,Anv.id,s00=,USERID("RESULTSDB")'
    qbf-lang[10] = 's,Aktuell tid,s00=,STRING(TIME;"HH:MM:SS")'

    qbf-lang[24] = 'Ange fÑltnamnet att inkludera som en kolumn i din '
                 + 'rapport, el vÑlj  <<konstant vÑrde>> fîr att infoga  '
                 + 'konstant strÑngvÑrde i rapporten.'
    qbf-lang[25] = 'SUBSTRING ger dig mîjlighet att skriva en  del av en tecken'
                 + 'strÑng.  VÑlj ett fÑltnamn.'
    qbf-lang[26] = 'Ange startpositionen i strÑngen.'
    qbf-lang[27] = 'Ange antal tecken du vill ta ut.'
    qbf-lang[28] = 'VÑlj fîrsta vÑrdet'
    qbf-lang[29] = 'VÑlj nÑsta vÑrde'
    qbf-lang[30] = 'VÑlj fîrsta komponenten att jÑmfîra'
    qbf-lang[31] = 'VÑlj andra komponenten att jÑmfîra'
    qbf-lang[32] = 'Returnerat tal motsvarar lÑngden av '
                 + 'vald strÑng.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - numeric expressions */
IF qbf-s = 6 THEN
  ASSIGN
    qbf-lang[ 1] = 'n,Konstant el FÑlt,n00=n26,~{1~}'
    qbf-lang[ 2] = 'n,Minst av tvÜ tal,n00=n24n25,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 3] = 'n,Stîrst av tvÜ tal,n00=n24n25,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 4] = 'n,Rest,n00=n31n32,~{1~} MODULO ~{2~}'
    qbf-lang[ 5] = 'n,AbsolutvÑrde,n00=n27,'
                 + '(IF ~{1~} < 0 THEN - ~{1~} ELSE ~{1~})'
    qbf-lang[ 6] = 'n,Avrundat,n00=n28,ROUND(~{1~};0)'
    qbf-lang[ 7] = 'n,Avhugget,n00=n29,TRUNCATE(~{1~};0)'
    qbf-lang[ 8] = 'n,Kvadr.rot,n00=n30,SQRT(~{1~})'
    qbf-lang[ 9] = 'n,Visa som tid,s00=n23,STRING(INTEGER(~{1~});"HH:MM:SS")'

    qbf-lang[23] = 'VÑlj ett fÑlt att visa enligt HH:MM:SS'
    qbf-lang[24] = 'VÑlj fîrsta komponent att jÑmfîra'
    qbf-lang[25] = 'VÑlj andra komponent att jÑmfîra'
    qbf-lang[26] = 'Ange fÑltnamnet att inkludera som en kolumn i din '
                 + 'rapport, el vÑlj <<konst. vÑrde>> fîr att infoga konstant '
                 + 'numeriskt vÑrde i rapporten.'
    qbf-lang[27] = 'VÑlj ett fÑlt som skall visas som ett absolutvÑrde '
                 + '(utan tecken).'
    qbf-lang[28] = 'VÑlj ett fÑlt som avrundas till nÑrmaste heltal.'
    qbf-lang[29] = 'VÑlj ett fÑlt som avrundas nedÜt (dec.delen '
                 + 'borttagen).'
    qbf-lang[30] = 'VÑlj ett fÑlt vars kvadr.rot berÑknas.'
    qbf-lang[31] = 'Efter division av ett tal (t) med ett annat (n) blir detta '
                 + 'resten.  Ange ett vÑrde pÜ talet t.'
    qbf-lang[32] = 'Dividerat med talet n'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - date expressions */
IF qbf-s = 7 THEN
  ASSIGN
    qbf-lang[ 1] = 'd,Aktuellt datum,d00=,TODAY'
    qbf-lang[ 2] = 'd,Addera dagar till Datum,d00=d22n23,~{1~} + ~{2~}'
    qbf-lang[ 3] = 'd,Subtrahera dagar frÜn Datum,d00=d22n24,~{1~} - ~{2~}'
    qbf-lang[ 4] = 'd,Differens mellan tvÜ datum,n00=d25d26,~{1~} - ~{2~}'
    qbf-lang[ 5] = 'd,Tidigaste av tvÜ datum,d00=d20d21,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 6] = 'd,Senaste av tvÜ datum,d00=d20d21,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 'd,Dag i mÜnad,n00=d27,DAY(~{1~})'
    qbf-lang[ 8] = 'd,MÜnad i Ür,n00=d28,MONTH(~{1~})'
    qbf-lang[ 9] = 'd,MÜnadsnamn,s00=d29,ENTRY(MONTH(~{1~});"Januari'
                 + ';Februari;Mars;April;Maj;Juni;Juli;Augusti;September'
                 + ';Oktober;November;December")'
    qbf-lang[10] = 'd,èrsvÑrde,n00=d30,YEAR(~{1~})'
    qbf-lang[11] = 'd,Veckodag,n00=d31,WEEKDAY(~{1~})'
    qbf-lang[12] = 'd,Namn pÜ veckodag,s00=d32,ENTRY(WEEKDAY(~{1~});"'
                 + 'Sîndag;MÜndag;Tisdag;Onsdag;Torsdag;Fredag;Lîrdag")'

    qbf-lang[20] = 'VÑlj fîrsta komponent att jÑmfîra'
    qbf-lang[21] = 'VÑlj andra komponent att jÑmfîra'
    qbf-lang[22] = 'VÑlj ett datumfÑlt.'
    qbf-lang[23] = 'VÑlj ett fÑlt som innehÜller antal dagar som skall '
                 + 'adderas till detta datum.'
    qbf-lang[24] = 'VÑlj ett fÑlt som innehÜller antal dagar som skall '
                 + 'subtraheras frÜn detta datum.'
    qbf-lang[25] = 'JÑmfîr tvÜ datum och visa differensen mellan '
                 + 'dessa, i dagar, som en kolumn.  VÑlj fîrsta '
                 + 'fÑltet.'
    qbf-lang[26] = 'VÑlj nu andra datumfÑltet.'
    qbf-lang[27] = 'Detta returnerar dagen i mÜnaden som ett tal frÜn '
                 + '1 till 31.'
    qbf-lang[28] = 'Detta returnerar Ürets mÜnad som ett tal frÜn '
                 + '1 till 12.'
    qbf-lang[29] = 'Detta returnerar mÜnadens namn.'
    qbf-lang[30] = 'Detta returnerar Ürdelen av datum som ett heltal.'
    qbf-lang[31] = 'Detta returnerar veckodagsnumret, med sîndag = 1.'
    qbf-lang[32] = 'Detta returnerar namnet pÜ veckodagen.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - mathematical expressions */
IF qbf-s = 8 THEN
  ASSIGN
    qbf-lang[ 1] = 'm,Addera,n00=n25n26m...,~{1~} + ~{2~}'
    qbf-lang[ 2] = 'm,Subtrahera,n00=n25n27m...,~{1~} - ~{2~}'
    qbf-lang[ 3] = 'm,Multiplicera,n00=n28n29m...,~{1~} * ~{2~}'
    qbf-lang[ 4] = 'm,Dividera,n00=n30n31m...,~{1~} / ~{2~}'
    qbf-lang[ 5] = 'm,Upphîj till,n00=n25n32m...,EXP(~{1~};~{2~})'

    qbf-lang[25] = 'Ange fîrsta talet'
    qbf-lang[26] = 'Ange nÑsta tal att addera'
    qbf-lang[27] = 'Ange nÑsta tal att subtrahera'
    qbf-lang[28] = 'Ange fîrsta faktor'
    qbf-lang[29] = 'Ange nÑsta faktor'
    qbf-lang[30] = 'Ange tÑljare'
    qbf-lang[31] = 'Ange nÑmnare'
    qbf-lang[32] = 'Ange potens'.

/*--------------------------------------------------------------------------*/

RETURN.

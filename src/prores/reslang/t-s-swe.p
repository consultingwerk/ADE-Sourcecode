/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
    qbf-lang[ 2] = 'S„kert att du vill avsluta utan att spara „ndringar?'
    qbf-lang[ 3] = 'Skriv namnet p† fil som skall l„sas in'
    qbf-lang[ 4] = 'Skriv s”kstr„ng'
    qbf-lang[ 5] = 'V„lj f„lt att infoga'
    qbf-lang[ 6] = 'Tryck [' + KBLABEL("GO") + '] f”r spara, ['
                 + KBLABEL("GET") + '] f”r addera f„lt, ['
                 + KBLABEL("END-ERROR") + '] f”r †ngra'
    qbf-lang[ 7] = 'S”kstr„ng ej funnen.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-ask.p,s-where.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Lika med'
    qbf-lang[ 2] = 'Skilt fr†n'
    qbf-lang[ 3] = 'Mindre „n'
    qbf-lang[ 4] = 'Mindre el lika'
    qbf-lang[ 5] = 'St”rre „n'
    qbf-lang[ 6] = 'St”rre el lika'
    qbf-lang[ 7] = 'B”rjar med'
    qbf-lang[ 8] = 'Inneh†ller'    /* must match [r.4.23] */
    qbf-lang[ 9] = 'Matchar'

    qbf-lang[10] = 'V„lj ett f„lt'
    qbf-lang[11] = 'Uttryck'
    qbf-lang[12] = 'Ange ett v„rde'
    qbf-lang[13] = 'J„mf”relser'

    qbf-lang[14] = 'Vid k”rning, be anv„ndare om ett v„rde.'
    qbf-lang[15] = 'Ange fr†ga som st„lls vid k”rning:'

    qbf-lang[16] = 'Be om' /* data-type */
    qbf-lang[17] = 'v„rde'

    qbf-lang[18] = 'Tryck [' + KBLABEL("END-ERROR") + '] f”r avslut.'
    qbf-lang[19] = 'Tryck [' + KBLABEL("END-ERROR") + '] att †ngra sista steg.'
    qbf-lang[20] = 'Press [' + KBLABEL("GET") + '] f”r Expertl„ge.'

    qbf-lang[21] = 'V„lj j„mf”relsetyp att utf”ras p† f„ltet.'

    qbf-lang[22] = 'Ange ~{1~} v„rde att j„mf”ras med "~{2~}".'
    qbf-lang[23] = 'Ange ~{1~} v„rde f”r "~{2~}".'
    qbf-lang[24] = 'Tryck [' + KBLABEL("PUT")
                 + '] f”r att fordra ett v„rde vid k”rning.'
    qbf-lang[25] = 'Valtext: ~{1~} „r ~{2~} ett ~{3~} v„rde.'

    qbf-lang[27] = '"Expertl„ge" „r inte det samma som "be om '
                 + 'ett v„rde vid k”rning".  Anv„nd det ena eller det andra.'
    qbf-lang[28] = 'F†r ej vara ok„nt v„rde!'
    qbf-lang[29] = 'Ange flera v„rden f”r' /* '?' append to string */
    qbf-lang[30] = 'Ange flera urvalskriteriera?'
    qbf-lang[31] = 'Kombinera med f”reg†ende kriteria och anv„nd?'
    qbf-lang[32] = 'Expertl„ge'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 3 THEN
  ASSIGN
/* s-info.p, s-format.p */
    qbf-lang[ 1] = 'Sort per'  /* s-info.p automatically right-justifies */
    qbf-lang[ 2] = 'och per'   /*   1..9 and adds colons for you. */
    qbf-lang[ 3] = 'Fil'      /* but must fit in format x(24) */
    qbf-lang[ 4] = 'Relation'
    qbf-lang[ 5] = 'D„r'
    qbf-lang[ 6] = 'F„lt'
    qbf-lang[ 7] = 'Uttryck'
    qbf-lang[ 9] = 'G”mma rep. v„rden?'

    qbf-lang[10] = 'FRN,PER,F™R'
    qbf-lang[11] = 'Du har inte valt n†gra tabeller!'
    qbf-lang[12] = 'Format och rubriker'
    qbf-lang[13] = 'Format'
    qbf-lang[14] = 'V„lj ett f„lt' /* also used by s-calc.p below */
    /* 15..18 must be format x(16) (see notes on 1..7) */
    qbf-lang[15] = 'Rubrik'
    qbf-lang[16] = 'Format'
    qbf-lang[17] = 'Databas'
    qbf-lang[18] = 'Typ'
    qbf-lang[19] = 'Anv„nd tid vid sen. k”rning,minuter:sekunder'
    qbf-lang[20] = 'Uttryck kan ej vara ok„nt v„rde (?)'

/*s-calc.p*/ /* there are many more for s-calc.p, see qbf-s = 5 thru 8 */
/*s-calc.p also uses #14 */
    qbf-lang[27] = 'Uttrycksbyggare'
    qbf-lang[28] = 'Uttryck'
    qbf-lang[29] = 'Ytterligare till„gg till detta uttryck?'
    qbf-lang[30] = 'V„lj operation'
    qbf-lang[31] = 'dagens datum'
    qbf-lang[32] = 'konstant v„rde'.

ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 4 THEN
  ASSIGN
/*s-help.p*/
    qbf-lang[ 1] = 'N†gon hj„lp f”r detta val finns „nnu ej.'
    qbf-lang[ 2] = 'Hj„lp'

/*s-order.p*/
    qbf-lang[15] = 'stigande/fallande' /*neither can be over 8 characters */
    qbf-lang[16] = 'F”r varje komponent, skriv "s" f”r'
    qbf-lang[17] = 'stigande eller "f" f”r fallande.'

/*s-define.p*/
    qbf-lang[21] = 'W. Bredd/Format av f„lt'
    qbf-lang[22] = 'F. F„lt'
    qbf-lang[23] = 'A. Aktiva tabeller'
    qbf-lang[24] = 'T. Totaler och subtotaler'
    qbf-lang[25] = 'R. Ackumulerad total'
    qbf-lang[26] = 'P. Procent av total'
    qbf-lang[27] = 'C. R„knare'
    qbf-lang[28] = 'M. Matematikuttryck'
    qbf-lang[29] = 'S. Str„nguttryck'
    qbf-lang[30] = 'N. Numeriska uttryck'
    qbf-lang[31] = 'D. Datumuttryck'
    qbf-lang[32] = 'L. Logiska uttryck'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - string expressions */
IF qbf-s = 5 THEN
  ASSIGN
    qbf-lang[ 1] = 's,konstant eller f„lt,s00=s24,~{1~}'
    qbf-lang[ 2] = 's,substr„ng,s00=s25n26n27,SUBSTRING(~{1~}'
                 + ';INTEGER(~{2~});INTEGER(~{3~}))'
    qbf-lang[ 3] = 's,kombinera tv† str„ngar,s00=s28s29,~{1~} + ~{2~}'
    qbf-lang[ 4] = 's,kombinera tre str„ngar,s00=s28s29s29,'
                 + '~{1~} + ~{2~} + ~{3~}'
    qbf-lang[ 5] = 's,kombinera fyra str„ngar,s00=s28s29s29s29,'
                 + '~{1~} + ~{2~} + ~{3~} + ~{4~}'
    qbf-lang[ 6] = 's,Minst av tv† str„ngar,s00=s30s31,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 's,St”rst av tv† str„ngar,s00=s30s31,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 8] = 's,L„ngd av str„ng,n00=s32,LENGTH(~{1~})'
    qbf-lang[ 9] = 's,Anv.id,s00=,USERID("RESULTSDB")'
    qbf-lang[10] = 's,Aktuell tid,s00=,STRING(TIME;"HH:MM:SS")'

    qbf-lang[24] = 'Ange f„ltnamnet att inkludera som en kolumn i din '
                 + 'rapport, el v„lj  <<konstant v„rde>> f”r att infoga  '
                 + 'konstant str„ngv„rde i rapporten.'
    qbf-lang[25] = 'SUBSTRING ger dig m”jlighet att skriva en  del av en tecken'
                 + 'str„ng.  V„lj ett f„ltnamn.'
    qbf-lang[26] = 'Ange startpositionen i str„ngen.'
    qbf-lang[27] = 'Ange antal tecken du vill ta ut.'
    qbf-lang[28] = 'V„lj f”rsta v„rdet'
    qbf-lang[29] = 'V„lj n„sta v„rde'
    qbf-lang[30] = 'V„lj f”rsta komponenten att j„mf”ra'
    qbf-lang[31] = 'V„lj andra komponenten att j„mf”ra'
    qbf-lang[32] = 'Returnerat tal motsvarar l„ngden av '
                 + 'vald str„ng.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - numeric expressions */
IF qbf-s = 6 THEN
  ASSIGN
    qbf-lang[ 1] = 'n,Konstant el F„lt,n00=n26,~{1~}'
    qbf-lang[ 2] = 'n,Minst av tv† tal,n00=n24n25,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 3] = 'n,St”rst av tv† tal,n00=n24n25,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 4] = 'n,Rest,n00=n31n32,~{1~} MODULO ~{2~}'
    qbf-lang[ 5] = 'n,Absolutv„rde,n00=n27,'
                 + '(IF ~{1~} < 0 THEN - ~{1~} ELSE ~{1~})'
    qbf-lang[ 6] = 'n,Avrundat,n00=n28,ROUND(~{1~};0)'
    qbf-lang[ 7] = 'n,Avhugget,n00=n29,TRUNCATE(~{1~};0)'
    qbf-lang[ 8] = 'n,Kvadr.rot,n00=n30,SQRT(~{1~})'
    qbf-lang[ 9] = 'n,Visa som tid,s00=n23,STRING(INTEGER(~{1~});"HH:MM:SS")'

    qbf-lang[23] = 'V„lj ett f„lt att visa enligt HH:MM:SS'
    qbf-lang[24] = 'V„lj f”rsta komponent att j„mf”ra'
    qbf-lang[25] = 'V„lj andra komponent att j„mf”ra'
    qbf-lang[26] = 'Ange f„ltnamnet att inkludera som en kolumn i din '
                 + 'rapport, el v„lj <<konst. v„rde>> f”r att infoga konstant '
                 + 'numeriskt v„rde i rapporten.'
    qbf-lang[27] = 'V„lj ett f„lt som skall visas som ett absolutv„rde '
                 + '(utan tecken).'
    qbf-lang[28] = 'V„lj ett f„lt som avrundas till n„rmaste heltal.'
    qbf-lang[29] = 'V„lj ett f„lt som avrundas ned†t (dec.delen '
                 + 'borttagen).'
    qbf-lang[30] = 'V„lj ett f„lt vars kvadr.rot ber„knas.'
    qbf-lang[31] = 'Efter division av ett tal (t) med ett annat (n) blir detta '
                 + 'resten.  Ange ett v„rde p† talet t.'
    qbf-lang[32] = 'Dividerat med talet n'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - date expressions */
IF qbf-s = 7 THEN
  ASSIGN
    qbf-lang[ 1] = 'd,Aktuellt datum,d00=,TODAY'
    qbf-lang[ 2] = 'd,Addera dagar till Datum,d00=d22n23,~{1~} + ~{2~}'
    qbf-lang[ 3] = 'd,Subtrahera dagar fr†n Datum,d00=d22n24,~{1~} - ~{2~}'
    qbf-lang[ 4] = 'd,Differens mellan tv† datum,n00=d25d26,~{1~} - ~{2~}'
    qbf-lang[ 5] = 'd,Tidigaste av tv† datum,d00=d20d21,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 6] = 'd,Senaste av tv† datum,d00=d20d21,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 'd,Dag i m†nad,n00=d27,DAY(~{1~})'
    qbf-lang[ 8] = 'd,M†nad i †r,n00=d28,MONTH(~{1~})'
    qbf-lang[ 9] = 'd,M†nadsnamn,s00=d29,ENTRY(MONTH(~{1~});"Januari'
                 + ';Februari;Mars;April;Maj;Juni;Juli;Augusti;September'
                 + ';Oktober;November;December")'
    qbf-lang[10] = 'd,rsv„rde,n00=d30,YEAR(~{1~})'
    qbf-lang[11] = 'd,Veckodag,n00=d31,WEEKDAY(~{1~})'
    qbf-lang[12] = 'd,Namn p† veckodag,s00=d32,ENTRY(WEEKDAY(~{1~});"'
                 + 'S”ndag;M†ndag;Tisdag;Onsdag;Torsdag;Fredag;L”rdag")'

    qbf-lang[20] = 'V„lj f”rsta komponent att j„mf”ra'
    qbf-lang[21] = 'V„lj andra komponent att j„mf”ra'
    qbf-lang[22] = 'V„lj ett datumf„lt.'
    qbf-lang[23] = 'V„lj ett f„lt som inneh†ller antal dagar som skall '
                 + 'adderas till detta datum.'
    qbf-lang[24] = 'V„lj ett f„lt som inneh†ller antal dagar som skall '
                 + 'subtraheras fr†n detta datum.'
    qbf-lang[25] = 'J„mf”r tv† datum och visa differensen mellan '
                 + 'dessa, i dagar, som en kolumn.  V„lj f”rsta '
                 + 'f„ltet.'
    qbf-lang[26] = 'V„lj nu andra datumf„ltet.'
    qbf-lang[27] = 'Detta returnerar dagen i m†naden som ett tal fr†n '
                 + '1 till 31.'
    qbf-lang[28] = 'Detta returnerar †rets m†nad som ett tal fr†n '
                 + '1 till 12.'
    qbf-lang[29] = 'Detta returnerar m†nadens namn.'
    qbf-lang[30] = 'Detta returnerar †rdelen av datum som ett heltal.'
    qbf-lang[31] = 'Detta returnerar veckodagsnumret, med s”ndag = 1.'
    qbf-lang[32] = 'Detta returnerar namnet p† veckodagen.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - mathematical expressions */
IF qbf-s = 8 THEN
  ASSIGN
    qbf-lang[ 1] = 'm,Addera,n00=n25n26m...,~{1~} + ~{2~}'
    qbf-lang[ 2] = 'm,Subtrahera,n00=n25n27m...,~{1~} - ~{2~}'
    qbf-lang[ 3] = 'm,Multiplicera,n00=n28n29m...,~{1~} * ~{2~}'
    qbf-lang[ 4] = 'm,Dividera,n00=n30n31m...,~{1~} / ~{2~}'
    qbf-lang[ 5] = 'm,Upph”j till,n00=n25n32m...,EXP(~{1~};~{2~})'

    qbf-lang[25] = 'Ange f”rsta talet'
    qbf-lang[26] = 'Ange n„sta tal att addera'
    qbf-lang[27] = 'Ange n„sta tal att subtrahera'
    qbf-lang[28] = 'Ange f”rsta faktor'
    qbf-lang[29] = 'Ange n„sta faktor'
    qbf-lang[30] = 'Ange t„ljare'
    qbf-lang[31] = 'Ange n„mnare'
    qbf-lang[32] = 'Ange potens'.

/*--------------------------------------------------------------------------*/

RETURN.

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
/* t-s-eng.p - English language definitions for general system use */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/

/* l-edit.p,s-edit.p */
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Lis„„'
    qbf-lang[ 2] = 'Haluatko varmasti lopettaa ilman muutosten tallettamista?'
    qbf-lang[ 3] = 'Kirjoita yhdistett„v„n tiedoston nimi'
    qbf-lang[ 4] = 'Kirjoita etsitt„v„ merkkijono'
    qbf-lang[ 5] = 'Valitse kentt„'
    qbf-lang[ 6] = '[' + KBLABEL("GO") + '] = talletus, ['
		 + KBLABEL("GET") + '] = kent„n lis„ys, ['
		 + KBLABEL("END-ERROR") + '] = peruutus.'
    qbf-lang[ 7] = 'Etsitt„v„„ merkkijonoa ei l”ytynyt.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-ask.p,s-where.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Yht„suuri'
    qbf-lang[ 2] = 'Erisuuri'
    qbf-lang[ 3] = 'Pienempi kuin'
    qbf-lang[ 4] = 'Pien. tai yht.'
    qbf-lang[ 5] = 'Suurempi kuin'
    qbf-lang[ 6] = 'Suur. tai yht.'
    qbf-lang[ 7] = 'Alkaa'
    qbf-lang[ 8] = 'Sis„lt„„'    /* must match [r.4.23] */
    qbf-lang[ 9] = 'Sopii maskiin'

    qbf-lang[10] = 'Valitse kentt„'
    qbf-lang[11] = 'Lauseke'
    qbf-lang[12] = 'Sy”t„ arvo'
    qbf-lang[13] = 'Valitse vertailu' 

    qbf-lang[14] = 'Kysy k„ytt„j„lt„ arvoa ohjelman ajon aikana.'
    qbf-lang[15] = 'Sy”t„ ajoaikaisesti teht„v„ kysymys:'

    qbf-lang[16] = 'Kysy tietotyypin' /* data-type */
    qbf-lang[17] = 'arvo'

    qbf-lang[18] = '[' + KBLABEL("END-ERROR") + '] = lopetus,'
    qbf-lang[19] = '[' + KBLABEL("END-ERROR") + '] = viimeisen ehdon peruutus,'
    qbf-lang[20] = '[' + KBLABEL("GET") + '] = ehdon muokkaaminen.'

    qbf-lang[21] = 'Valitse kent„lle teht„v„n vertailun tyyppi.'

    qbf-lang[22] = 'Sy”t„ ~{1~} tieto verrattavaksi tiedon "~{2~}" kanssa.'
    qbf-lang[23] = 'Sy”t„ ~{1~} arvoksi tiedolle "~{2~}".'
    qbf-lang[24] = 'Paina [' + KBLABEL("PUT")
		 + '] arvon kysymiseksi ajon aikana.'
    qbf-lang[25] = 'Kysymyksen merkitys: ~{1~} on ~{2~} jokin ~{3~}.'

    qbf-lang[27] = 'Itse muokatussa ehdossa ei voi k„ytt„„ arvon '
		 + 'kysymist„ ajon aikana.  K„yt„ vain toista.'
    qbf-lang[28] = 'Ei voi olla tuntematon arvo!'
    qbf-lang[29] = 'Sy”t„tk” lis„„ arvoja kent„lle' /* '?' append to string */
    qbf-lang[30] = 'Sy”t„tk” lis„„ valintakriteerej„?'
    qbf-lang[31] = 'Yhdist„tk” aikaisempiin kriteereihin?'
    qbf-lang[32] = 'Ehdon muokkaaminen'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 3 THEN
  ASSIGN
/* s-info.p, s-format.p */
    qbf-lang[ 1] = 'Lajittelu'  /* s-info.p automatically right-justifies */
    qbf-lang[ 2] = 'ja edelleen'    /*   1..9 and adds colons for you. */
    qbf-lang[ 3] = 'Taulu tai vast.'      /* but must fit in format x(24) */
    qbf-lang[ 4] = 'Relaatio'
    qbf-lang[ 5] = 'Jossa'
    qbf-lang[ 6] = 'Kentt„'
    qbf-lang[ 7] = 'Lauseke'
    qbf-lang[ 9] = 'Piilota toistuvat arvot?'

    qbf-lang[10] = 'ALKAEN,LISŽYS,-'
    qbf-lang[11] = 'Et ole viel„ valinnut yht„„n kentt„„!'
    qbf-lang[12] = 'Esitysmuoto ja otsikko'
    qbf-lang[13] = 'Esitysmuodot'
    qbf-lang[14] = 'Valitse kentt„' /* also used by s-calc.p below */
    /* 15..18 must be format x(16) (see notes on 1..7) */
    qbf-lang[15] = 'Otsikko'
    qbf-lang[16] = 'Esitysmuoto'
    qbf-lang[17] = 'Tietokanta'
    qbf-lang[18] = 'Tietotyyppi'
    qbf-lang[19] = 'Viimeisen ajon kestoaika,minuuttia:sekunttia'
    qbf-lang[20] = 'Lausekkeella ei voi olla tuntematon arvo (?)'

/*s-calc.p*/ /* there are many more for s-calc.p, see qbf-s = 5 thru 8 */
/*s-calc.p also uses #14 */
    qbf-lang[27] = 'Lausekkeen muodostus'
    qbf-lang[28] = 'Lauseke'
    qbf-lang[29] = 'Lis„„tk” viel„ t„t„ lauseketta?'
    qbf-lang[30] = 'Valitse funktio'
    qbf-lang[31] = 'kuluvan p„iv„n p„iv„ys'
    qbf-lang[32] = 'vakio'.

ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 4 THEN
  ASSIGN
/*s-help.p*/
    qbf-lang[ 1] = 'Apua ei ole m„„ritelty t„lle valinnalle.'
    qbf-lang[ 2] = 'Apu'

/*s-order.p*/
    qbf-lang[15] = 'Nouseva/Laskeva' /*neither can be over 8 characters */
    qbf-lang[16] = 'Kirjoita "N" kent„n nousevalle'
    qbf-lang[17] = '      ja "L" laskevalle lajittelulle.'

/*s-define.p*/
    qbf-lang[21] = 'F. Leveys/Kenttien muoto'
    qbf-lang[22] = 'K. Kent„t'
    qbf-lang[23] = 'T. Taulut'
    qbf-lang[24] = 'S. Yhteis- ja v„lisummat'
    qbf-lang[25] = 'Y. Kumulatiivinen'
    qbf-lang[26] = 'P. Prosentteja'
    qbf-lang[27] = 'C. Laskuri'
    qbf-lang[28] = 'M. Matemaattinen lauseke'
    qbf-lang[29] = 'T. Tekstimuotoinen lauseke'
    qbf-lang[30] = 'N. Numeerinen lauseke'
    qbf-lang[31] = 'D. P„iv„m„„r„lauseke'
    qbf-lang[32] = 'L. Looginen lauseke'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - string expressions */
IF qbf-s = 5 THEN
  ASSIGN
    qbf-lang[ 1] = 's,Vakio tai kentt„,s00=s24,~{1~}'
    qbf-lang[ 2] = 's,Osateksti,s00=s25n26n27,SUBSTRING(~{1~}'
		 + ';INTEGER(~{2~});INTEGER(~{3~}))'
    qbf-lang[ 3] = 's,Yhdist„ kaksi teksti„,s00=s28s29,~{1~} + ~{2~}'
    qbf-lang[ 4] = 's,Yhdist„ kolme teksti„,s00=s28s29s29,'
		 + '~{1~} + ~{2~} + ~{3~}'
    qbf-lang[ 5] = 's,Yhdist„ nelj„ teksti„,s00=s28s29s29s29,'
		 + '~{1~} + ~{2~} + ~{3~} + ~{4~}'
    qbf-lang[ 6] = 's,Pienempi kahdesta tekstist„,s00=s30s31,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 's,Suurempi kahdesta tekstist„,s00=s30s31,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 8] = 's,Tekstin pituus,n00=s32,LENGTH(~{1~})'
    qbf-lang[ 9] = 's,K„ytt„j„tunnus,s00=,USERID("RESULTSDB")'
    qbf-lang[10] = 's,Aika,s00=,STRING(TIME;"HH:MM:SS")'

    qbf-lang[24]  = 'Valitse kent„n nimi raporttisi sarakkeeksi tai valitse ' 
                  + '<<vakio>>, jos haluat raporttiisi vakiotekstin.'
    qbf-lang[25] = 'OSATEKSTI ottaa tekstist„ tulostukseen yhten„isen osan. '
		 + 'Valitse kent„n nimi.'
    qbf-lang[26] = 'Sy”t„ osatekstin alun positio'
    qbf-lang[27] = 'Sy”t„ osatekstiin tulevien merkkien m„„r„'
    qbf-lang[28] = 'Valitse ensimm„inen arvo'
    qbf-lang[29] = 'Valitse seuraava arvo'
    qbf-lang[30] = 'Valitse ensimm„inen verrattava'
    qbf-lang[31] = 'Valitse toinen verrattava'
    qbf-lang[32] = 'Numero tarkoittaa valitun tekstin pituutta.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - numeric expressions */
IF qbf-s = 6 THEN
  ASSIGN
    qbf-lang[ 1] = 'n,Vakio tai kentt„,n00=n26,~{1~}'
    qbf-lang[ 2] = 'n,Kahdesta numerosta pienempi,n00=n24n25,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 3] = 'n,Kahdesta numerosta suurempi,n00=n24n25,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 4] = 'n,Jakoj„„nn”s,n00=n31n32,~{1~} MODULO ~{2~}'
    qbf-lang[ 5] = 'n,Absoluuttinen arvo,n00=n27,'
		 + '(IF ~{1~} < 0 THEN - ~{1~} ELSE ~{1~})'
    qbf-lang[ 6] = 'n,Py”ristys,n00=n28,ROUND(~{1~};0)'
    qbf-lang[ 7] = 'n,Katkaisu,n00=n29,TRUNCATE(~{1~};0)'
    qbf-lang[ 8] = 'n,Neli”juuri,n00=n30,SQRT(~{1~})'
    qbf-lang[ 9] = 'n,N„ytt„„ aikana,s00=n23,STRING(INTEGER(~{1~});"HH:MM:SS")'

    qbf-lang[23] = 'Valitse kentt„, joka n„ytet„„n aikana, "HH:MM:SS"'
    qbf-lang[24] = 'Valitse ensimm„inen verrattava'
    qbf-lang[25] = 'Valitse toinen verrattava'
    qbf-lang[26] = 'Valitse kentt„ raporttisi sarakkeeksi tai valitse '
		 + '<<vakio>>, jos haluat raporttiisi vakionumeron.'
    qbf-lang[27] = 'Valitse kentt„, jonka absoluuttinen (etumerkit”n) arvo '
		 + 'n„ytet„„n.'
    qbf-lang[28] = 'Valitse kentt„, joka py”ristet„„n l„himp„„n kokonaislukuun.'
    qbf-lang[29] = 'Valitse kentt„, joka py”ristet„„n alasp„in (desimaaliosa '
		 + 'poistetaan).'
    qbf-lang[30] = 'Valitse kentt„, jonka neli”juuri lasketaan.'
    qbf-lang[31] = 'Kun numero on jaettu jakajalla, t„st„ tulee '
		 + 'jakoj„„nn”s.  Mist„ luvusta haluat jakoj„„nn”ksen?'
    qbf-lang[32] = 'Mill„ jaetaan?'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - date expressions */
IF qbf-s = 7 THEN
  ASSIGN
    qbf-lang[ 1] = 'd,Nykyp„iv„,d00=,TODAY'
    qbf-lang[ 2] = 'd,Lis„„ p„ivi„ p„iv„ykseen,d00=d22n23,~{1~} + ~{2~}'
    qbf-lang[ 3] = 'd,V„hent„„ p„ivi„ p„iv„yksest„,d00=d22n24,~{1~} - ~{2~}'
    qbf-lang[ 4] = 'd,Kahden p„iv„yksen erotus,n00=d25d26,~{1~} - ~{2~}'
    qbf-lang[ 5] = 'd,Kahdesta p„iv„yksest„ aikaisempi,d00=d20d21,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 6] = 'd,Kahdesta p„iv„yksest„ my”hempi,d00=d20d21,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 'd,Kuukauden p„iv„,n00=d27,DAY(~{1~})'
    qbf-lang[ 8] = 'd,Vuoden kuukausi,n00=d28,MONTH(~{1~})'
    qbf-lang[ 9] = 'd,Kuukauden nimi,s00=d29,ENTRY(MONTH(~{1~});"Tammikuu'
		 + ';Helmikuu;Maaliskuu;Huhtikuu;Toukokuu;Kes„kuu;Hein„kuu;Elokuu;Syyskuu'
		 + ';Lokakuu;Marraskuu;Joulukuu")'
    qbf-lang[10] = 'd,Vuosi,n00=d30,YEAR(~{1~})'
    qbf-lang[11] = 'd,Viikonp„iv„,n00=d31,WEEKDAY(~{1~})'
    qbf-lang[12] = 'd,Viikonp„iv„n nimi,s00=d32,ENTRY(WEEKDAY(~{1~});"'
		 + 'Sunnuntai;Maanantai;Tiistai;Keskiviikko;Torstai;Perjantai;Lauantai")'

    qbf-lang[20] = 'Valitse ensimm„inen verrattava'
    qbf-lang[21] = 'Valitse toinen verrattava'
    qbf-lang[22] = 'Valitse p„iv„yskentt„.'
    qbf-lang[23] = 'Valitse kentt„, jossa on p„ivien lukum„„r„ lis„tt„v„ksi '
		 + 't„h„n p„iv„ykseen.'
    qbf-lang[24] = 'Valitse kentt„, jossa on p„ivien lukum„„r„ v„hennett„v„ksi '
		 + 't„st„ p„iv„yksest„.'
    qbf-lang[25] = 'Vertaa kahta p„iv„yst„ ja n„ytt„„ n„iden erotuksen '
		 + 'p„iviss„ omana sarakkeenaan.  Valitse ensimm„inen '
		 + 'kentt„.'
    qbf-lang[26] = 'Valitse nyt toinen p„iv„yskentt„.'
    qbf-lang[27] = 'T„m„ palauttaa kuukauden p„iv„n numerona (1 - 31).'
    qbf-lang[28] = 'T„m„ palauttaa kuukauden numerona (1 - 12). '
    qbf-lang[29] = 'T„m„ palauttaa kuukauden nimen.'
    qbf-lang[30] = 'T„m„ palauttaa p„iv„yksen vuoden numeron.'
    qbf-lang[31] = 'T„m„ palauttaa viikonp„iv„n numeron, sunnuntai on 1.'
    qbf-lang[32] = 'T„m„ palauttaa viikonp„iv„n nimen.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - mathematical expressions */
IF qbf-s = 8 THEN
  ASSIGN
    qbf-lang[ 1] = 'm,Summa    (+) ,n00=n25n26m...,~{1~} + ~{2~}'
    qbf-lang[ 2] = 'm,Erotus   (-) ,n00=n25n27m...,~{1~} - ~{2~}'
    qbf-lang[ 3] = 'm,Tulo     (*),n00=n28n29m...,~{1~} * ~{2~}'
    qbf-lang[ 4] = 'm,Osam„„r„ (/),n00=n30n31m...,~{1~} / ~{2~}'
    qbf-lang[ 5] = 'm,Potenssiin korotus,n00=n25n32m...,EXP(~{1~};~{2~})'

    qbf-lang[25] = 'Sy”t„ ensimm„inen numero'
    qbf-lang[26] = 'Sy”t„ seuraava lis„tt„v„ numero'
    qbf-lang[27] = 'Sy”t„ seuraava v„hennett„v„ numero'
    qbf-lang[28] = 'Sy”t„ ensimm„inen kerrottava'
    qbf-lang[29] = 'Sy”t„ seuraava kerrottava'
    qbf-lang[30] = 'Sy”t„ jaettava'
    qbf-lang[31] = 'Sy”t„ jakaja'
    qbf-lang[32] = 'Sy”t„ potenssi'.

/*--------------------------------------------------------------------------*/

RETURN.

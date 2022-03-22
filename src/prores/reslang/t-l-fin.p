/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-l-eng.p - Finnish language definitions for Labels module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* l-guess.p:1..5,l-verify.p:6.. */
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Haetaan "~{1~}"-taulusta "~{2~}"-kentt„„...'
    qbf-lang[ 2] = 'Automaattisella haulla ei l”ynyt yht„„n kentt„„.  Peruutatko?'
    qbf-lang[ 4] = 'Tarrakenttien valinta'
    qbf-lang[ 5] = 'Nimi,Osoite-1,Osoite-2,Osoite-3,Postitoimipaikka,'
                 + 'Postinumero,Postinro + -tpaikka,Maa,Lis-1,Lis-2'

    qbf-lang[ 6] = 'Rivi ~{1~}: Aaltosulkuja eri m„„r„.'
    qbf-lang[ 7] = 'Rivi ~{2~}: Kentt„„ "~{1~}" ei l”ydy.'
    qbf-lang[ 8] = 'Rivi ~{2~}: Kentt„ "~{1~}" ei ole taulukko.'
    qbf-lang[ 9] = 'Rivi ~{2~}: Kent„n "~{1~}" indeksi ~{3~} liian suuri.'
    qbf-lang[10] = 'Rivi ~{2~}: Kent„n "~{1~}" taulua ei ole valittu.'.

ELSE

/*--------------------------------------------------------------------------*/
/* l-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    /* each entry of 1 and also 2 must fit in format x(6) */
    qbf-lang[ 1] = 'Taul.:,     :,     :,     :,     :'
    qbf-lang[ 2] = 'J„rj.:'
    qbf-lang[ 3] = 'Tarran kuvaus'
    qbf-lang[ 4] = 'Tarran layout'
    qbf-lang[ 5] = 'Valitse kentt„'
    /*cannot change length of 6 thru 17, right-justify 6-11,13-14 */
    qbf-lang[ 6] = '    Ohita tyhj„t:'
    qbf-lang[ 7] = '         Kopiota:'
    qbf-lang[ 8] = '       Korkeus:'
    qbf-lang[ 9] = ' Yl„marginaali:'
    qbf-lang[10] = '   Tekstialkujen v„li:'
    qbf-lang[11] = '     Vasen marginaali:'
    qbf-lang[12] = '' /* leve„ otettiin pois */
    qbf-lang[13] = '  Tarrateksti'
    qbf-lang[14] = '    ja kent„t'
    qbf-lang[15] = '' /* 15..17 used as group.   */
    qbf-lang[16] = ' Tarrasarakkeita  ' /*   do not change length, */
    qbf-lang[17] = ' tulosteessa:' /*        but do right-justify  */
    qbf-lang[19] = 'Et poistanut nykyist„ tarraa.  '
                 + 'Haluatko silti jatkaa?'
    qbf-lang[20] = 'Tarrasi korkeus on ~{1~}, mutta rivej„ m„„ritelty ~{2~}. '
                 + 'Jotkut tiedot eiv„t mahdu tarran m„„riteltyyn kokoon '
                 + 'eik„ niit„ voida tulostaa.  '
                 + 'Haluatko silti jatkaa ja tulostaa n„m„ tarrat?'
    qbf-lang[21] = 'Tarratekstej„ tai -kentti„ ei ole tulostettavaksi!'
    qbf-lang[22] = 'Tuottaa tarraohjelmaa...'
    qbf-lang[23] = 'K„„nt„„ „sken luotua ohjelmaa...'
    qbf-lang[24] = 'Ohjelma k„ynnistyy...'
    qbf-lang[25] = 'Tiedostoon tai laitteeseen ei voi kirjoittaa '
    qbf-lang[26] = '~{1~} kpl. tarroja tulostettiin.'
    qbf-lang[27] = 'K. Kent„t'
    qbf-lang[28] = 'T. Taulut'
    qbf-lang[29] = 'Haluatko, ett„ RESULTS valitsee kent„t tarroihin '
                 + 'automaattisesti?'
    qbf-lang[31] = 'Haluatko varmasti poistaa tehdyt m„„ritykset?'
    qbf-lang[32] = 'Haluatko varmasti poistua t„st„ moduulista?'.

ELSE

/*--------------------------------------------------------------------------*/
/* l-main.p */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = 'Jos sivusuunnassa on useampia tarroja, v„lin pit„„ olla > 0'
    qbf-lang[ 2] = 'Yl„marginaali ei voi olla negatiivinen'
    qbf-lang[ 3] = 'Kokonaiskorkeuden pit„„ olla yht„ suurempi'
    qbf-lang[ 4] = 'Tarrojen m„„r„ sivusuunnassa v„hint„„n yksi'
    qbf-lang[ 5] = 'Kopioiden m„„r„ v„hint„„n yksi'
    qbf-lang[ 6] = 'Vasen marginaali ei voi olla negatiivinen'
    qbf-lang[ 7] = 'Tekstien v„lin pit„„ olla yht„ suurempi'
    qbf-lang[ 8] = 'Tyhj„t alemmat rivit nostetaan ylemm„s'
    qbf-lang[ 9] = 'Rivien luku tarran yl„reunasta ensimm„iseen tulostettavaan'
    qbf-lang[10] = 'Tarran kokonaiskorkeus (rivej„)'
    qbf-lang[11] = 'Tarrojen lukum„„r„ sivusuunnassa'
    qbf-lang[12] = 'Kopioiden lukum„„r„ (kutakin tarraa)'
    qbf-lang[13] = 'Et„isyys tarran reunasta tulostettavaan sarakkeeseen'
    qbf-lang[14] = 'Viereisten tarrojen ALKUSARAKKEIDEN et„isyys'.

/*--------------------------------------------------------------------------*/

RETURN.

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
/* t-r-eng.p - English language definitions for Reports module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

IF qbf-s = 1 THEN
  ASSIGN
/*r-header.p*/
    qbf-lang[ 1] = 'Sy”t„ lauseke kohtaan:'
    qbf-lang[ 2] = 'Rivi' /* must be < 8 characters */
                   /* 3..7 are format x(64) */
    qbf-lang[ 3] = 'N„it„ funktioita voidaan k„ytt„„ sivuotsikoissa.'
    qbf-lang[ 4] = '~{COUNT~}  Tietueiden lukum„„r„  :  '
                 + '~{TIME~}  Raportin aloitusaika'
    qbf-lang[ 5] = '~{TODAY~}  Nykyp„iv„n p„iv„ys    :  '
                 + '~{NOW~}   Nykyinen aika'
    qbf-lang[ 6] = '~{PAGE~}   Sivunumero            :  '
                 + '~{USER~}  K„ytt„j„tunnus'
    qbf-lang[ 7] = '~{VALUE <lauseke>~;<muoto>~}   Muuttuja (sy”tt”'
                 + ' [' + KBLABEL("GET") + ']-n„pp„imell„)'
    qbf-lang[ 8] = 'Valitse lis„tt„v„ kentt„'
    qbf-lang[ 9] = '[' + KBLABEL("GO") + '] = talletus, ['
                 + KBLABEL("GET") + '] = kent„n lis„ys, ['
                 + KBLABEL("END-ERROR") + '] = peruutus.'

/*r-total.p*/    /*"|---------------------------|"*/
    qbf-lang[12] = 'Suorita n„m„ toiminnot:'
                 /*"|--------------------------------------------|"*/
    qbf-lang[13] = 'kun n„iden kenttien arvot muuttuvat:'
                 /*"|---| |---| |---| |---| |---|" */
    qbf-lang[14] = 'Yht.- Lkm.- Min.- Maks. K-arv'
    qbf-lang[15] = 'Laskentarivi'
    qbf-lang[16] = 'Kent„lle:'
    qbf-lang[17] = 'Valitse laskettava kentt„'

/*r-calc.p*/
    qbf-lang[18] = 'Valitse kumuloituva sarake'
    qbf-lang[19] = 'Valitse prosentuaalinen sarake'
    qbf-lang[20] = 'Kumulatiivinen'
    qbf-lang[21] = '% yhteissummasta'
    qbf-lang[22] = 'Tekstin,P„iv„yksen,Looginen,Matem.,Numeerinen'
    qbf-lang[23] = 'arvo'
    qbf-lang[24] = 'Sy”t„ laskurin aloitusarvo'
    qbf-lang[25] = 'Sy”t„ laskurin lis„ys; negatiivinen numero on v„hennys'
    qbf-lang[26] = 'Laskuri'
    qbf-lang[27] = 'Laskuri'
                 /*"------------------------------|"*/
    qbf-lang[28] = '           Laskurin aloitusarvo' /*right justify*/
    qbf-lang[29] = '   Lis„„ joka tietueen kohdalla' /*right justify*/
    qbf-lang[32] = 'Olet m„„ritellyt jo maksimim„„r„n sarakkeita.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN
/* r-space.p */  /*"------------------------------|  ---------|  |------"*/
    qbf-lang[ 1] = '             M„„ritys              Nykyinen   Oletus'
    /* 2..8 must be less than 32 characters long */
    qbf-lang[ 2] = 'Vasen marginaali'
    qbf-lang[ 3] = 'Sarakkeiden v„liss„ tyhji„'
    qbf-lang[ 4] = 'Aloitusrivi'
    qbf-lang[ 5] = 'Sivun rivim„„r„'
    qbf-lang[ 6] = 'Rivien v„liss„ tyhji„'
    qbf-lang[ 7] = 'Yl„otsikon ja rivien alun v„li'
    qbf-lang[ 8] = 'Rivien lopun ja alaotsikon v„li'
                  /*1234567890123456789012345678901*/
    qbf-lang[ 9] = 'V„lit'
    qbf-lang[10] = 'Riviv„lin pit„„ olla yhden tai sivukoon v„list„'
    qbf-lang[11] = 'Negatiiviset sivupituudet eiv„t kelpaa'
    qbf-lang[12] = 'Raportin vasen „„rilaita on sarake 1'
    qbf-lang[13] = 'Sy”t„ arvo j„rkev„n„'
    qbf-lang[14] = 'Raportin ylin rivi on v„hint„„n rivi 1'

/*r-set.p*/        /* format x(30) for 15..22 */
    qbf-lang[15] = 'E.  Esitysmuodot ja otsikot'
    qbf-lang[16] = 'V.  Sivuvaihdot'
    qbf-lang[17] = 'S.  Summaraportti'
    qbf-lang[18] = 'K.  Kenttien v„lit'
    qbf-lang[19] = 'VY. Vasen yl„otsikko'
    qbf-lang[20] = 'YK. Yl„otsikko keskelle'
    qbf-lang[21] = 'OY. Oikea yl„otsikko'
    qbf-lang[22] = 'VA. Vasen alaotsikko'
    qbf-lang[23] = 'AK. Alaotsikko keskelle'
    qbf-lang[24] = 'OA. Oikea alaotsikko'
    qbf-lang[25] = 'ES. Vain etusivun yl„otsikko'
    qbf-lang[26] = 'VS. Viim. sivun alaotsikko'
    qbf-lang[32] = 'Paina [' + KBLABEL("END-ERROR")
                 + '], kun muutokset ovat valmiit.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 3 THEN
  ASSIGN
    /* r-main.p,s-page.p */
    qbf-lang[ 1] = 'Taul.:,     :,     :,     :,     :'
    qbf-lang[ 2] = 'J„rj.:'
    qbf-lang[ 3] = 'Raportin kuvaus'
    qbf-lang[ 4] = 'Raportin layout'
    qbf-lang[ 5] = 'lis„„' /* for <<more and more>> */
    qbf-lang[ 6] = 'Raportti,Leveys' /* each word comma-separated */
    qbf-lang[ 7] = 'N„pp„imill„ < ja > siirret„„n raporttia sivusuunnassa'
    qbf-lang[ 8] = 'Raportin maksimileveys on 255 merkki„'
    qbf-lang[ 9] = 'Et poistanut raportin m„„rityksi„.  Haluatko silti '
                 + 'jatkaa?'
    qbf-lang[10] = 'Tuottaa raporttiohjelmaa...'
    qbf-lang[11] = 'K„„nt„„ „sken luotua ohjelmaa...'
    qbf-lang[12] = 'Ohjelma k„ynnistyy...'
    qbf-lang[13] = 'Ei voi kirjoittaa tiedostoon tai laitteelle'
    qbf-lang[14] = 'Haluatko varmasti poistaa nykyisen raportin '
                 + 'm„„rityksen?'
    qbf-lang[15] = 'Haluatko varmasti poistua t„st„ moduulista?'
    qbf-lang[16] = 'N„pp„imill„ ['
                 + (IF KBLABEL("CURSOR-UP") BEGINS "CTRL-" THEN 'CURSOR-UP'
                   ELSE KBLABEL("CURSOR-UP"))
                 + '] ja ['
                 + (IF KBLABEL("CURSOR-DOWN") BEGINS "CTRL-" THEN 'CURSOR-DOWN'
                   ELSE KBLABEL("CURSOR-DOWN"))
                 + '] selataan, ['
                 + KBLABEL("END-ERROR") + '] lopetetaan.'
    qbf-lang[17] = 'Sivu'
    qbf-lang[18] = '~{1~} tietuetta tulostettiin raporttiin.'
    qbf-lang[19] = 'Summaraporttia ei voi luoda, jos yht„„n lajittelukentt„„ '
                 + 'ei ole m„„ritelty.'
    qbf-lang[20] = 'Summaraporttiin ei voi m„„ritell„ '
                 + 'taulukkomuuttujia.'
    qbf-lang[21] = 'Summaraportti'
    qbf-lang[23] = 'Raporttia ei voi luoda, jos siihen ei ole m„„ritelty yht„„n kentt„„.'.

ELSE

/*--------------------------------------------------------------------------*/
/* FAST TRACK interface test for r-ft.p r-ftsub.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = 'FAST TRACK ei tue tulostusta p„„tteelle, kun tiedon'
    qbf-lang[ 2] = 'valintakriteeri kysyt„„n.  Tulostus siirretty kirjoittimelle.'
    qbf-lang[ 3] = 'Sivuotsikoiden m„„rityksi„ tutkitaan...'
    qbf-lang[ 4] = 'Luodaan raportin katkotasot...'
    qbf-lang[ 5] = 'Luodaan kent„t ja yhteissummat...'
    qbf-lang[ 6] = 'Luodaan taulut ja JOSSA-lausekkeet...'
    qbf-lang[ 7] = 'Luodaan m„„ritellyt sivuotsikot...'
    qbf-lang[ 8] = 'Luodaan raporttirivit...'
    qbf-lang[ 9] = 'FAST TRACK:ss„ on jo raportti nimelt„ ~{1~}.  Haluatko '
                 + 'kirjoittaa sen p„„lle?'
    qbf-lang[10] = 'Kirjoitetaan vanhan raportin p„„lle...'
    qbf-lang[11] = 'Haluatko k„ynnist„„ FAST TRACKin?'
    qbf-lang[12] = 'Sy”t„ nimi'
    qbf-lang[13] = 'FAST TRACK ei hyv„ksy aloitusaikaa sivuotsikoissa, '
                 + 'korvattu nykyajalla.'
    qbf-lang[14] = 'FAST TRACK ei hyv„ksy prosenttisaraketta, kentt„ sivuutetaan.'
    qbf-lang[15] = 'FAST TRACK ei hyv„ksy teksti„ ~{1~} sivuotsikoissa, '
                 + '~{2~} sivuutetaan.'
    qbf-lang[16] = 'Raportin nimess„ ei saa olla muita erikoismerkkej„ kuin '
                 + 'alaviiva.'
    qbf-lang[17] = 'Raportin nimi FAST TRACKiss„:'
    qbf-lang[18] = 'Raporttia ei siirretty FAST TRACKiin'
    qbf-lang[19] = 'FAST TRACK k„ynnistyy, odota hetki...'
    qbf-lang[20] = 'Sivuotsikoissa pariton m„„r„ aaltosulkuja, '
                 + 'raportti EI siirtynyt.'
    qbf-lang[21] = 'FAST TRACK ei hyv„ksy otsikkoja katkotason perusteella. '
                 + '  Sivuutettiin.'
    qbf-lang[22] = 'Varoitus: Aloitusnumero ~{1~} m„„ritelty laskuriin.'
    qbf-lang[23] = 'SISŽLTŽŽ'
    qbf-lang[24] = 'TOTAL,COUNT,MAX,MIN,AVG'
    qbf-lang[25] = 'FAST TRACK ei hyv„ksy summaraportteja.  '
                 + 'Raporttia ei voitu siirt„„.'
    qbf-lang[26] = 'Raporttia ei voi siirt„„ FAST TRACKiin ilman '
                 + 'yht„„n kentt„„.'.


ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 5 THEN
  ASSIGN
    /* r-short.p */
    qbf-lang[ 1] = 'M„„rittelem„ll„ raportti summaraportiksi tulostus rajoitetaan '
                 + 'vain summiin ja muuhun yhteenvetotietoon.  Summatieto tulostetaan, '
                 + 'kun tieto vaihtuu kent„ss„, joka on ilmaistu "J„rj."-m„„rittelyll„, '
                 + 't„m„n sarakkeen alle tulevalle riville. '
                 + '^T„ss„ raportissa uusi rivi tulee joka kerralla, kun '
                 + '~{1~}-kentt„ vaihtuu.^Tehd„„nk” t„st„ raportista '
                 + 'summaraportti?'
    qbf-lang[ 2] = 'Kyll„'
    qbf-lang[ 3] = 'Ei'
    qbf-lang[ 4] = 'Et voi m„„ritell„ raporttia summaraportiksi ennen kuin '
                 + 'olet valinnut "Laj"-kent„t raportin lajittelemiseksi.^^'
                 + 'Valitse lajittelukent„t "Laj"-valinnalla '
                 + 'Raporttimoduulin p„„valikosta, ja yrit„ sen j„lkeen '
                 + 't„t„ m„„rittely„ uudestaan.'
    qbf-lang[ 5] = 'T„m„ lista n„ytt„„ kaikki t„h„n menness„ m„„ritellyt '
                 + 'raportin kent„t.'
    qbf-lang[ 6] = '  T„hdell„ merkityt kent„t tullaan summaamaan.'
    qbf-lang[ 7] = 'Jos olet m„„ritellyt numeerisen kent„n summattavaksi, rivien '
                 + 'v„lisumma tulostuu joka kerralla, kun ~{1~}-kent„n arvo muuttuu.'
    qbf-lang[ 8] = 'Jos olet valinnut muun kuin numeerisen kent„n, laskuri n„ytt„„ '
                 + 'tietueiden lukum„„r„n ~{1~}-kent„n ryhm„ss„.'
    qbf-lang[ 9] = 'Jos et valitse kent„n summaamista, silloin ryhm„n '
                 + 'viimeisen tietueen tiedot tulostuvat siit„ kent„st„.'

    /* r-page.p */
    qbf-lang[26] = 'Sivuvaihdot'
    qbf-lang[27] = "„l„ tee sivuvaihtoa"

    qbf-lang[28] = 'Kun arvo muuttuu jossain seuraavista'
    qbf-lang[29] = 'kentist„, raportin tulostus jatkuu'
    qbf-lang[30] = 'automaattisesti seuraavalta sivulta.'
    qbf-lang[31] = 'Poimi kentt„ alla olevasta listasta, '
    qbf-lang[32] = 'jos haluat n„in k„yv„n.'.

/*--------------------------------------------------------------------------*/

RETURN.

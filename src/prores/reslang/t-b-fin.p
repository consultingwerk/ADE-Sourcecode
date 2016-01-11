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
/* t-b-eng.p - English language definitions for Build subsystem */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* b-build.p,b-again.p */
IF qbf-s = 1 THEN
  ASSIGN
                /* formats: x(10) x(45) x(8) */
    qbf-lang[ 1] = 'Ohjelma,Tietokanta ja taulu,Aika'
    qbf-lang[ 2] = 'Alustustiedosto on vioittunut.  Poista .qc-tiedosto ja '
                 + 'aloita uudestaan.'
    qbf-lang[ 3] = 'K„sittelyss„'     /*format x(15)*/
    qbf-lang[ 4] = 'K„„nt„„'      /*format x(15)*/
    qbf-lang[ 5] = 'Uusk„„nn”s'   /*format x(15)*/
    qbf-lang[ 6] = 'K„sitelt„v„ taulu,K„sitelt„v„ lomake,K„sitelt„v„ ohjelma'
    qbf-lang[ 7] = 'Kaikki merkityt lomakkeet luodaan uudestaan. Merkitse ne ['
                 + KBLABEL("RETURN") + ']-n„pp„imell„.'
    qbf-lang[ 8] = '[' + KBLABEL("GO") + '] = hyv„ksyminen, ['
                 + KBLABEL("END-ERROR") + '] = lopetus.'
    qbf-lang[ 9] = 'Kyselylomakkeiden luetteloa varten selataan tauluja...'
    qbf-lang[10] = 'Oletko lopettanut kyselylomakkeiden m„„rittelemeisen?'
    qbf-lang[11] = 'Indeksin nimeen perustuvia relaatioita ("OF") haetaan.'
    qbf-lang[12] = 'Relaatioiden luetteloa rakennetaan.'
    qbf-lang[13] = 'Kaikkia yhdisteit„ ei kyetty l”yt„m„„n.'
    qbf-lang[14] = 'Ylim„„r„inen relaatiotieto poistetaan.'
    qbf-lang[15] = 'Haluatko varmasti lopettaa?'
    qbf-lang[16] = 'Kulunut aika,Keskim. aika'
    qbf-lang[17] = 'Asetustiedostoa luetaan...'
    qbf-lang[18] = 'Asetustiedostoa kirjoitetaan...'
    qbf-lang[19] = 'on jo olemassa.  Tilalla k„ytet„„n'
    qbf-lang[20] = 'tiedostoa kirjoitetaan'
    qbf-lang[21] = 'Selataan lomakkeen "~{1~}" muutoksia.'
    qbf-lang[22] = 'Kyselylomake vaatii tietueosoittimen (RECID) '
                 + 'tai yksiselitteisen indeksin.'
    qbf-lang[23] = 'Lomaketta ei muutettu.'
    qbf-lang[24] = 'ei vaadi uudelleen k„„nt„mist„.'
    qbf-lang[25] = 'Lomakkeella ei ole yht„„n kentt„„.  Lomaketta ei voida tuottaa.'
    qbf-lang[26] = 'Lomakkeeseen ei j„„nyt yht„„n kentt„„.  Lomake poistettiin.'
    qbf-lang[27] = 'Katseltavien taulujen luetteloa pakataan.'
    qbf-lang[28] = 'Kulunut aika'
    qbf-lang[29] = 'Valmis!'
    qbf-lang[30] = '"~{1~}"-ohjelman k„„nn”s ep„onnistui.'
    qbf-lang[31] = 'Asetustiedostoa kirjoitetaan:'
    qbf-lang[32] = 'Ohjelman luonnin ja/tai k„„nn”n aikana ilmeni virheit„.'
                 + '^^Paina jotain n„pp„inta, jolloin n„et lokitiedoston.  Virheit„ '
                 + 'sis„lt„neet rivit n„ytet„„n korostetusti.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN

/* b-misc.p */
    /* 1..10 for qbf-l-auto[] */
    qbf-lang[ 1] = 'nimi,*nimi*,yhteys,*yhteys*'
    qbf-lang[ 2] = '*katu,*tie,*osoite,*osoite*1'
    qbf-lang[ 3] = '*postinumero*,*osoite*2'
    qbf-lang[ 4] = '*osoite*3'
    qbf-lang[ 5] = 'kaupunki,*kaupunki*'
    qbf-lang[ 6] = 'maakunta,valtio,*valtio*'
    qbf-lang[ 7] = 'toimipaikka,*paikka*'
    qbf-lang[ 8] = 'paikka*4'
    qbf-lang[ 9] = '*posti*'
    qbf-lang[10] = '*maa*'

    qbf-lang[15] = 'Esimerkkisiirto'.

/*--------------------------------------------------------------------------*/

RETURN.

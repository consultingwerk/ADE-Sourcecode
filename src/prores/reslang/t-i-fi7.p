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
/* t-i-eng.p - English language definitions for Directory */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*i-dir.p,i-pick.p,i-zap.p,a-info.p,i-read.p*/
ASSIGN
  qbf-lang[ 1] = 'siirto,graafi,tarra,kysely,raportti'
  qbf-lang[ 2] = 'Moduuli:'
  qbf-lang[ 3] = 'Jotkut tauluista/kentist~{ on j~{tetty pois jostain seuraavista '
               + 'syist~{:^1) niiden tietokantoja ei ole kytketty ajoon '
               + '^2) tietokannan m~{~{rityst~{ on muutettu^3) k~{ytt|oikeudet '
               + 'ovat riitt~{m~{tt|m~{t'
  qbf-lang[ 4] = 'Moduulin ~{1~} nimen pit~{~{ olla yksiselitteinen.  Yrit~{ uudestaan.'
  qbf-lang[ 5] = 'Liian monta talletusta.  Poista jotkut niist~{!  '
               + 'Poistot mist~{ moduulihakemistosta tahansa vapauttavat tilaa.'
  qbf-lang[ 6] = 'Kuvaus----,Tietokanta,Ohjelma---'
  qbf-lang[ 7] = 'Haluatko varmasti kirjoittaa moduulin p~{~{lle: '
  qbf-lang[ 8] = 'ja tuhota moduulin'
  qbf-lang[ 9] = 'Valitse'
  qbf-lang[10] = 'Tiedonsiirto (PROGRESS),Graafi,Tarra,Kysely,Raportti'
  qbf-lang[11] = 'tiedonsiirto,graafi,tarra,kysely,raportti'
  qbf-lang[12] = 'tiedonsiirtoja,graafeja,tarroja,kyselyit~{,raportteja'
  qbf-lang[13] = 'tiedonsiirtoja,graafeja,tarroja,kyselyit~{,'
               + 'raporttim~{~{rityksi~{'
  qbf-lang[14] = 'k~{sitelt~{v~{ksi,talletettavaksi,poistettavaksi'
  qbf-lang[15] = 'Ohjelmaa ajetaan...'
  qbf-lang[16] = 'hae ~{1~} toisesta hakemistosta'   
  qbf-lang[17] = 'talleta ~{1~} uutena'
  qbf-lang[18] = 'ei olemassa'
  qbf-lang[19] = 'Merkitse poistettavat moduulit ['
               + KBLABEL('RETURN') + ']-n~{pp~{imell~{.'
  qbf-lang[20] = 'Paina [' + KBLABEL('GO') + '], kun olet valmis, ['
               + KBLABEL('END-ERROR') + '] jos haluat peruuttaa.'
  qbf-lang[21] = 'Numero ~{1~} siirret~{~{n positioon ~{2~}.'
  qbf-lang[22] = 'Poistetaan numero ~{1~}.'
  qbf-lang[23] = '[' + KBLABEL("GO") + '] = valinta, ['
               + KBLABEL("INSERT-MODE") + '] = vaihto, ['
               + KBLABEL("END-ERROR") + '] = lopetus.'
  qbf-lang[24] = 'P~{ivitetty~{ raporttihakemistoa kirjoitetaan...'
/*a-info.p only:*/ /* 25..29 use format x(64) */
  qbf-lang[25] = 'T~{m~{ ohjelma n~{ytt~{~{ k~{ytt~{j~{n oman hakemistotiedoston'
  qbf-lang[26] = 'sis~{ll|n.  Se n~{ytt~{~{ mitk~{ tuotetut ohjelmat'
  qbf-lang[27] = 'vastaavat mit~{kin m~{~{ritelty~{ raporttia, tiedonsiirtoa,'
  qbf-lang[28] = 'tarraa ja niin edelleen.'
  qbf-lang[29] = 'Kirjoita k~{ytt~{j~{n .qd-tiedoston koko nimi (ml. polku)'
  qbf-lang[30] = 'Merkitty~{ tiedostoa ei l|ydy.'
  qbf-lang[31] = 'Unohdit tiedoston .qd-loppuosan.'
  qbf-lang[32] = 'Hakemistoa luetaan...'.

RETURN.

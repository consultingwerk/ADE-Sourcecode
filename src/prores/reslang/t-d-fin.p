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
/* t-d-eng.p - English language definitions for Data Export module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* d-edit.p,a-edit.p */
IF qbf-s = 1 THEN
/*
When entering codes, the following methods may be used:
  'x' - literal character enclosed in single quotes.
  ^x  - interpreted as control-character.
  ##h - one or two hex digits followed by the letter "h".
  ### - one, two or three digits, a decimal number.
  xxx - "xxx" is a symbol such as "lf" from the following table.
*/
  ASSIGN
    qbf-lang[ 1] = 'on symbooli kuten'
    qbf-lang[ 2] = 'seuraavasta taulusta.'
    qbf-lang[ 3] = '[' + KBLABEL("GET")
                 + ']-n„pp„imell„ vaihdetaan sy”tt”tapaa.'
    /* format x(70): */
    qbf-lang[ 4] = 'Koodeja sy”tett„ess„ n„it„ tapoja voi k„ytt„„ ja sekottaa '
                 + 'vapaasti:'
    /* format x(60): */
    qbf-lang[ 5] = 'merkkitieto yksinkertaisissa lainausmerkeiss„.'
    qbf-lang[ 6] = 'tulkitaan ohjausmerkiksi.'
    qbf-lang[ 7] = 'yksi tai kaksi heksanumeroa; per„„n h-kirjain.'
    qbf-lang[ 8] = 'yhdest„ kolmeen numeroa, desimaalinumero'
    qbf-lang[ 9] = 'ei ole k„ytetty koodi.  Korjaa se.'
    qbf-lang[10] = 'Tulostuksen ohjauskoodeja talletetaan...'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Taul.:,     :,     :,     :,     :'
    qbf-lang[ 2] = 'J„rj.:'
    qbf-lang[ 3] = 'Tiedon siirron kuvaus'
    qbf-lang[ 4] = 'Tiedon siirron layout'
    qbf-lang[ 5] = 'Kent„t:,      :,      :,      :,      :'
    qbf-lang[ 7] = ' Siirron tyyppi:'
    qbf-lang[ 8] = 'Otsakkeet:'
    qbf-lang[ 9] = '   (siirtonimet ens. tietueesta)'
    qbf-lang[10] = '  Tietueen alku:'
    qbf-lang[11] = ' Tietueen loppu:'
    qbf-lang[12] = '  Kent„n rajaus:'
    qbf-lang[13] = '  Kenttien v„li:'
    qbf-lang[14] = 'Tiedonsiirto ei mahdollista taulukkomuotoisten kenttien siirtoa. '
                 + 'Jatkaessasi ne tullaan poistamaan siirrosta. '
                 + '^Haluatko jatkaa?'
    qbf-lang[15] = 'Tiedonsiirto edellytt„„ kenttien valitsemista.'
    qbf-lang[21] = 'Et poistanut nykyisen siirtomuodon m„„rityst„.  '
                 + 'Haluatko silti jatkaa?'
    qbf-lang[22] = 'Tuottaa siirto-ohjelmaa...'
    qbf-lang[23] = 'K„„nt„„ „sken luotua siirto-ohjelmaa...'
    qbf-lang[24] = 'Ohjelma k„ynnistyy...'
    qbf-lang[25] = 'Tiedostoon tai laitteeseen ei voi kirjoittaa'
    qbf-lang[26] = '~{1~} tietuetta siirrettiin.'
    qbf-lang[31] = 'Haluatko varmasti poistaa esill„ olevan tiedonsiirron?'
    qbf-lang[32] = 'Haluatko varmasti poistua t„st„ moduulista?'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
/* this set contains only export formats.  Each is composed of the */
/* internal RESULTS id and the description.  The description must  */
/* not contain a comma, and must fit within format x(32).          */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = 'PROGRESS,PROGRESS siirtomuoto'
    qbf-lang[ 2] = 'ASCII   ,Tavallinen ASCII'
    qbf-lang[ 3] = 'ASCII-H ,ASCII; kenttien nimet otsikkoina'
    qbf-lang[ 4] = 'FIXED   ,ASCII;vakiopituiset kent„t (SDF)'
    qbf-lang[ 5] = 'CSV     ,Pilkuilla erotetut kent„t (CSV)'
    qbf-lang[ 6] = 'DIF     ,DIF'
    qbf-lang[ 7] = 'SYLK    ,SYLK'
    qbf-lang[ 8] = 'WS      ,WordStar'
    qbf-lang[ 9] = 'WORD    ,Microsoft Word'
    qbf-lang[10] = 'WORD4WIN,Microsoft Word for Windows'
    qbf-lang[11] = 'WPERF   ,WordPerfect'
    qbf-lang[12] = 'OFISW   ,CTOS/BTOS OfisWriter'
    qbf-lang[13] = 'USER    ,Omat'
    qbf-lang[14] = '*'. /* terminator for list */

/*--------------------------------------------------------------------------*/

RETURN.

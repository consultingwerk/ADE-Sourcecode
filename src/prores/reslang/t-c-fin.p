/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-c-eng.p - English language definitions for Scrolling Lists */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*
As of [Thu Apr 25 15:13:33 EDT 1991], this
is a list of the scrolling list programs:
  u-browse.i     c-print.p
  b-pick.p       i-pick.p
  c-entry.p      i-zap.p
  c-field.p      s-field.p
  c-file.p       u-pick.p
  c-flag.p       u-print.p
  c-form.p
*/

/* c-entry.p,c-field.p,c-file.p,c-form.p,c-print.p,c-vector.p,s-field.p */
ASSIGN
  qbf-lang[ 1] = 'Valitse yhdistett„v„ taulu tai lopeta ['
               + KBLABEL("END-ERROR") + ']-n„pp„imell„.'
  qbf-lang[ 2] = '[' + KBLABEL("GO") + '] = hyv„ksy, ['
               + KBLABEL("INSERT-MODE") + '] = vaihto, ['
               + KBLABEL("END-ERROR") + '] = lopetus.'
  qbf-lang[ 3] = 'Paina [' + KBLABEL("END-ERROR")
               + '] p„„tt„„ksesi taulujen valinnan.'
  qbf-lang[ 4] = '[' + KBLABEL("GO") + '] = hyv„ksy, ['
               + KBLABEL("INSERT-MODE")
               + '] = vaihda (kuvaus/taulu/ohjelma).'
  qbf-lang[ 5] = 'Otsake/Nimi--'
  qbf-lang[ 6] = 'Kuvaus/Nimi--'
  qbf-lang[ 7] = 'Taulu--,Ohjelma,Kuvaus-'
  qbf-lang[ 8] = 'Haetaan valittavia kentti„...'
  qbf-lang[ 9] = 'Valitse kent„t'
  qbf-lang[10] = 'Valitse taulu'
  qbf-lang[11] = 'Valitse liitett„v„t taulut'
  qbf-lang[12] = 'Valitse kyselylomake'
  qbf-lang[13] = 'Valitse tulostuslaite'
  qbf-lang[14] = 'Yhd' /* should match t-q-eng.p "Join" string */
  qbf-lang[16] = '      Tietokanta' /* max length 16 */
  qbf-lang[17] = '           Taulu' /* max length 16 */
  qbf-lang[18] = '          Kentt„' /* max length 16 */
  qbf-lang[19] = 'Maksimi taulukko' /* max length 16 */
  qbf-lang[20] = 'Arvo'
  qbf-lang[21] = 'on ulkopuolella alueesta 1 - '
  qbf-lang[22] = 'Jatketaanko olemassa olevan tiedoston loppuun?'
  qbf-lang[23] = 'T„t„ vaihtoehtoa ei voi k„ytt„„ m„„ritellyss„ tulostuksessa'
  qbf-lang[24] = 'Sy”t„ tiedoston nimi'

               /* 12345678901234567890123456789012345678901234567890 */
  qbf-lang[27] = 'j„t„ tyhj„ksi taulukkokenttien kohdalla tai sy”t„'
  qbf-lang[28] = 'yksitt„iset alkiot pilkuilla erotettuina,'
  qbf-lang[29] = 'jolloin ne tulevat rinnakkain raporttiin.'
  qbf-lang[30] = 'Sy”t„ yksitt„iset alkiot pilkuilla erotettuina, '
  qbf-lang[31] = 'jolloin ne tulevat rinnakkain raporttiin.'
  qbf-lang[32] = 'Sy”t„ k„ytett„v„n taulukon alkion indeksinumero.'.

RETURN.

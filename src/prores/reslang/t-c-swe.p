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
/* t-c-swe.p - Swedish language definitions for Scrolling Lists */

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
  qbf-lang[ 1] = 'V„lj relaterad fil el tryck ['
               + KBLABEL("END-ERROR") + '] f”r avslut.'
  qbf-lang[ 2] = 'Tryck [' + KBLABEL("GO") + '] f”r klart, ['
               + KBLABEL("INSERT-MODE") + '] f”r infoga/”verskr, ['
               + KBLABEL("END-ERROR") + '] avsluta.'
  qbf-lang[ 3] = 'Tryck [' + KBLABEL("END-ERROR")
               + '] f”r avbryt val av tabell.'
  qbf-lang[ 4] = 'Tryck [' + KBLABEL("GO") + '] f”r klart, ['
               + KBLABEL("INSERT-MODE")
               + '] skifta beskr/tabell/program.'
  qbf-lang[ 5] = 'Rubr/Namn'
  qbf-lang[ 6] = 'Besk/Namn'
  qbf-lang[ 7] = 'Tab.,Prog,Besk'
  qbf-lang[ 8] = 'S”ker upp tillg„ngliga f„lt...'
  qbf-lang[ 9] = 'V„lj f„lt'
  qbf-lang[10] = 'V„lj tabell'
  qbf-lang[11] = 'V„lj relaterad tabell'
  qbf-lang[12] = 'V„lj fr†geformul„r'
  qbf-lang[13] = 'V„lj utdataenhet'
  qbf-lang[14] = 'Relation' /* should match t-q-eng.p "Join" string */
  qbf-lang[16] = '         Databas' /* max length 16 */
  qbf-lang[17] = '          Tabell' /* max length 16 */
  qbf-lang[18] = '            F„lt' /* max length 16 */
  qbf-lang[19] = '   Antal element' /* max length 16 */
  qbf-lang[20] = 'V„rdet'
  qbf-lang[21] = '„r utanf”r intervallet 1 till'
  qbf-lang[22] = 'L„ggs till existerande fil?'
  qbf-lang[23] = 'Kan ej anv denna funktion med angiven utdatadestination'
  qbf-lang[24] = 'Ange utdata filnamn'

               /* 12345678901234567890123456789012345678901234567890 */
  qbf-lang[27] = 'L„mna blank f”r alla element i en kolumn, el ange en'
  qbf-lang[28] = 'komma-separerad lista av indiv. matriselement'
  qbf-lang[29] = 'att inkluderas sida-vid-sida i rapporten.'
  qbf-lang[30] = 'Ange en komma-separerad lista av indiv. matris'
  qbf-lang[31] = 'element att inkluderas sida-vid-sida som f„lt.'
  qbf-lang[32] = 'Ange index av matriselementet som ska anv„ndas.'.

RETURN.

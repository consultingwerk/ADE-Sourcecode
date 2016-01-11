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
/* t-c-dan.p - Danish language definitions for Scrolling Lists */
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
  c-felt.p      s-felt.p
  c-file.p       u-pick.p
  c-flag.p       u-print.p
  c-form.p
*/

/* c-entry.p,c-felt.p,c-file.p,c-form.p,c-print.p,c-vector.p,s-felt.p */
ASSIGN
  qbf-lang[ 1] = 'Udv‘lg fil i relation eller tryk ['
	       + KBLABEL("END-ERROR") + '] for afslut.'
  qbf-lang[ 2] = 'Tryk [' + KBLABEL("GO") + '] n†r udf›rt, ['
	       + KBLABEL("INSERT-MODE") + '] for skift, ['
	       + KBLABEL("END-ERROR") + '] for afslut.'
  qbf-lang[ 3] = 'Tryk [' + KBLABEL("END-ERROR")
	       + '] for at afslutte udv‘lgning af filer.'
  qbf-lang[ 4] = 'Tryk [' + KBLABEL("GO") + '] n†r udf›rt, ['
	       + KBLABEL("INSERT-MODE")
	       + '] for skift mellem besk/fil/program.'
  qbf-lang[ 5] = 'Tekst/Navn-'
  qbf-lang[ 6] = 'Besk/Navn'
  qbf-lang[ 7] = 'Fil-,Prog,Besk'
  qbf-lang[ 8] = 'Fremfinder tilg‘ngelige felter...'
  qbf-lang[ 9] = 'V‘lg Felter'
  qbf-lang[10] = 'Udv‘lg Fil'
  qbf-lang[11] = 'Udv‘lg Relateret Fil'
  qbf-lang[12] = 'Udv‘lg Foresp›rgsel Sk‘rm'
  qbf-lang[13] = 'Udv‘lg Udskrifts enhed'
  qbf-lang[14] = 'Rela' /* should match t-q-dan.p "Join" string */
  qbf-lang[16] = '        Database' /* max length 16 */
  qbf-lang[17] = '             Fil' /* max length 16 */
  qbf-lang[18] = '            Felt' /* max length 16 */
  qbf-lang[19] = ' Maximum omr†de' /* max length 16 */
  qbf-lang[20] = 'V‘rdien'
  qbf-lang[21] = 'er udenfor omr†det 1 til'
  qbf-lang[22] = 'Tilf›jes til eksisterende fil?'
  qbf-lang[23] = 'Kan ikke benytte denne option med den angivne udskrifts destination'
  qbf-lang[24] = 'Indtast udskrifts filnavn'

	       /* 12345678901234567890123456789012345678901234567890 */
  qbf-lang[27] = 'Efterlad blank for stakkede array elementer, eller'
  qbf-lang[28] = 'angiv en komma-sepereret liste af enkelt elementer'
  qbf-lang[29] = 'der skal st† ved siden af hinanden som felter.'
  qbf-lang[30] = 'Angiv en komma-sepereret liste a enkelt elementer'
  qbf-lang[31] = 'der skal st† ved siden af hinanden som felter.'
  qbf-lang[32] = 'Angiv nummeret p† array-elementer der ›nskes.'.

RETURN.
